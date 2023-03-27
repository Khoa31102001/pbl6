import { OrderItem } from '@app/order_item/order-item.entity';
import { PaymentService } from '@app/payment/payment.service';
import { ProductSize } from '@app/product_size/product_size.entity';
import { User } from '@app/user/user.entity';
import { ResponseTransfomer } from '@core/transform/response.transform';
import {
  BadRequestException,
  CACHE_MANAGER,
  Inject,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { Filter, Sort } from 'src/common/class';
import { FilterSign } from 'src/common/enums/filter.enum';
import { ORDER_STATUS } from 'src/common/enums/order.enum';
import { IFilterOptions } from 'src/common/interface/filter-options.interface';
import { IPaginationOptions } from 'src/common/interface/pagination-options.interface';
import { In, Repository } from 'typeorm';
import { CreateOrderDto } from './dto/create-order.dto';
import { Order } from './order.entity';
import { Cache } from 'cache-manager';
import { Cron } from '@nestjs/schedule';

@Injectable()
export class OrderService {
  constructor(
    @Inject(CACHE_MANAGER)
    private cacheManager: Cache,

    @Inject('ORDER_REPOSITORY')
    private orderRepository: Repository<Order>,

    @Inject('PRODUCT_SIZE_REPOSITORY')
    private productSizeRepository: Repository<ProductSize>,

    @Inject('USER_REPOSITORY')
    private userRepository: Repository<User>,
    private paymentService: PaymentService,
  ) {}

  async findAllByUser(userEmail: string, pagination: IPaginationOptions) {
    const user = await this.userRepository.findOneByOrFail({
      email: userEmail,
    });
    const queryBuilder = this.orderRepository
      .createQueryBuilder('order')
      .leftJoinAndSelect('order.orderItems', 'orderItem')
      .leftJoinAndSelect('orderItem.productSize', 'productSize')
      .leftJoinAndSelect('productSize.product', 'product')
      .leftJoinAndSelect('productSize.size', 'size')
      .leftJoinAndSelect('product.images', 'images')
      .where('order.user_id = :userId', { userId: user.id });

    return new ResponseTransfomer(queryBuilder).paginationResponseTransform(
      pagination,
    );
  }

  async getOrderPaymentUrl(orderId: number, userId: number) {
    const paymentUrl = await this.cacheManager.get(`order_${orderId}`);

    if (paymentUrl) {
      return paymentUrl;
    }

    const order = await this.orderRepository.findOne({
      where: { id: orderId, userId },
    });

    if (!order) {
      throw new NotFoundException('Order not found');
    }

    if (order.status !== ORDER_STATUS.ON_PAYMENT) {
      throw new BadRequestException('Order is not on payment');
    }

    if (!paymentUrl) {
      throw new InternalServerErrorException('Payment url not found in cache');
    }

    return paymentUrl;
  }

  async findAll(
    filterOptions: IFilterOptions,
    paginationOptions: IPaginationOptions,
  ) {
    const { filter, search, sort } = filterOptions;
    const orderFilters = Filter.produce({ filter });
    const orderSorts = Sort.produce({ sort });
    const queryBuilder = this.orderRepository
      .createQueryBuilder('order')
      .leftJoinAndSelect('order.orderItems', 'orderItem')
      .leftJoinAndSelect('orderItem.productSize', 'productSize')
      .leftJoinAndSelect('productSize.product', 'product')
      .leftJoinAndSelect('productSize.size', 'size')
      .leftJoinAndSelect('product.images', 'images')
      .leftJoinAndSelect('order.user', 'user');

    orderFilters.forEach((item, index) => {
      item.column = `order.${item.column}`;

      queryBuilder.andWhere(
        `LOWER(${item.column}) ${item.sign} LOWER(:value${index})`,
        {
          [`value${index}`]:
            item.sign === FilterSign.$like ? `%${item.value}%` : item.value,
        },
      );
    });

    if (search) {
      queryBuilder.andWhere('LOWER(order.name) LIKE LOWER(:name)', {
        name: `%${search}%`,
      });
    }

    if (orderSorts.length > 0) {
      orderSorts.forEach((orderSort) => {
        queryBuilder.addOrderBy(
          `order.${orderSort.sort}`,
          orderSort.order === 'ASC' ? 'ASC' : 'DESC',
        );
      });
    } else {
      queryBuilder.addOrderBy('order.updatedAt', 'DESC');
    }

    return new ResponseTransfomer(queryBuilder).paginationResponseTransform(
      paginationOptions,
    );
  }

  async findOneByUser(id: number, userId: number) {
    return this.orderRepository.findOne({
      where: { userId, id },
      relations: [
        'orderItems',
        'orderItems.productSize.product',
        'orderItems.productSize.product.images',
        'orderItems.productSize.size',
      ],
    });
  }

  async createOrder(
    createOrdertDto: CreateOrderDto,
    userEmail: string,
  ): Promise<string> {
    const productSizeIds = createOrdertDto.items.map(
      (productItem) => productItem.productSizeId,
    );

    const foundProductSizes = await this.productSizeRepository.find({
      where: { id: In(productSizeIds) },
      relations: ['product', 'product.discount'],
    });

    const user = await this.userRepository.findOneByOrFail({
      email: userEmail,
    });
    let resultOrder;

    await this.productSizeRepository.manager.transaction(
      async (transactionalEntityManager) => {
        const orderItems = [];
        const order = new Order();

        for (const productSize of createOrdertDto.items) {
          const foundProductItem = foundProductSizes.find(
            (item) => item.id === productSize.productSizeId,
          );

          if (!foundProductItem) {
            throw new NotFoundException(
              `Product size with id ${productSize.productSizeId} not found`,
            );
          }

          if (foundProductItem.quantity < productSize.quantity) {
            throw new BadRequestException({
              message: `Product size with id ${productSize.productSizeId} has not enough quantity`,
              detail: foundProductItem,
            });
          }

          const currentDate = new Date();
          const discountActived = (
            foundProductItem.product.discount as any
          ).filter(
            (discount) =>
              discount.startDate <= currentDate &&
              discount.endDate >= currentDate,
          );

          foundProductItem.quantity -= productSize.quantity;
          const orderItem = new OrderItem();
          orderItem.productSize = foundProductItem;
          orderItem.quantity = productSize.quantity;
          orderItem.price = foundProductItem.product.price;
          orderItem.total =
            foundProductItem.product.price * productSize.quantity;
          orderItem.order = order;

          if (discountActived.length) {
            orderItem.total = Math.round(
              orderItem.total * (1 - discountActived[0].percent / 100),
            );
          }

          orderItems.push(orderItem);
        }

        await transactionalEntityManager.save(orderItems);

        await transactionalEntityManager.save(foundProductSizes);

        const shipCost = 20000;

        order.orderItems = orderItems;
        order.total =
          orderItems.reduce((acc, item) => acc + item.total, 0) + shipCost;
        order.status = ORDER_STATUS.ON_PAYMENT;
        order.address = createOrdertDto.address;
        order.name = createOrdertDto.name;
        order.phone = createOrdertDto.phone;
        order.user = user;
        resultOrder = await transactionalEntityManager.save(order);
      },
    );

    const url = await this.paymentService.payWithMomo(resultOrder.id);

    await this.cacheManager.set(`order_${resultOrder.id}`, url, {
      ttl: 60 * 10,
    });
    return url;
  }

  async findOneById(
    id: number,
    relations = [
      'orderItems',
      'orderItems.productSize',
      'orderItems.productSize.product',
      'user',
    ],
  ) {
    const options = {
      where: { id },
      relations,
    };
    const order = await this.orderRepository.findOne(options);

    if (!order) {
      throw new NotFoundException(`Order with id ${id} not found`);
    }

    return order;
  }

  async updateStatus(id: number, status: ORDER_STATUS) {
    const order = await this.findOneById(id);
    order.status = status;
    await this.orderRepository.save(order);
  }

  async received(userId: number, orderId: number) {
    try {
      const options = {
        where: { id: orderId, userId },
      };
      const order = await this.orderRepository.findOne(options);

      if (order.status === ORDER_STATUS.ON_DELIVERY) {
        order.status = ORDER_STATUS.COMPLETED;
        return this.orderRepository.save(order);
      }

      throw new BadRequestException(
        `Order with id ${orderId} is not on delivery`,
      );
    } catch (err) {
      throw new BadRequestException(err.message);
    }
  }

  async deleteOne(id: number): Promise<void> {
    const order = await this.findOneById(id);
    await this.orderRepository.delete(order.id);
  }

  @Cron('*/5 * * * *', { name: 'handleOrderStatusCronJob' })
  async handleOrderStatusCronJob() {
    const options = {
      where: { status: ORDER_STATUS.ON_PAYMENT },
      relations: ['orderItems', 'orderItems.productSize'],
    };
    const orders = await this.orderRepository.find(options);
    const cancelOrders: Order[] = [];
    const productSizes: ProductSize[] = [];

    orders?.forEach((order) => {
      const createdAt = Date.parse(order.createdAt);
      const durationMinutes = (Date.now() - createdAt) / 60000;

      if (durationMinutes >= 10) {
        order.status = ORDER_STATUS.CANCELLED;
        order.orderItems?.forEach((orderItem) => {
          const foundProductSize = productSizes.find(
            (productSize) => productSize.id === orderItem.productSize.id,
          );

          if (foundProductSize) {
            foundProductSize.quantity =
              Number(foundProductSize.quantity) + Number(orderItem.quantity);
          } else {
            orderItem.productSize.quantity =
              Number(orderItem.productSize.quantity) +
              Number(orderItem.quantity);
            productSizes.push(orderItem.productSize);
          }
        });
        cancelOrders.push(order);
      }
    });

    if (cancelOrders) {
      await this.productSizeRepository.save(productSizes);
      await this.orderRepository.save(cancelOrders);
    }
  }
}

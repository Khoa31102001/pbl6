import { OrderService } from '@app/order/order.service';
import { ProductSize } from '@app/product_size/product_size.entity';
import { MomoPayment } from '@core/utils/payment/momo';
import {
  CACHE_MANAGER,
  forwardRef,
  Inject,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { MOMO_RESULT_CODE } from 'src/common/enums';
import { ORDER_STATUS } from 'src/common/enums/order.enum';
import { Repository } from 'typeorm';
import { CreatePaymentDto } from './dto/create-payment.dto';
import { Payment } from './payment.entity';
import { Cache } from 'cache-manager';
import { InjectQueue } from '@nestjs/bull';
import { Queue } from 'bull';
import { EMAIL_TYPE } from 'src/common/enums/email.enum';
import { addCommaToNumber } from 'src/common/utils';
import { OrderItem } from '@app/order_item/order-item.entity';

@Injectable()
export class PaymentService {
  constructor(
    @Inject(CACHE_MANAGER)
    private cacheManager: Cache,

    @Inject('PAYMENT_REPOSITORY')
    private paymentRepository: Repository<Payment>,

    @InjectQueue('email')
    private emailQueue: Queue,

    @Inject(forwardRef(() => OrderService))
    private orderService: OrderService,

    @Inject('PRODUCT_SIZE_REPOSITORY')
    private productSizeRepository: Repository<ProductSize>,
  ) {}

  async payWithMomo(orderId: number) {
    const order = await this.orderService.findOneById(orderId);

    return MomoPayment.sendRequest({ orderId: order.id, amount: order.total });
  }

  async handleNotify({
    orderId,
    amount,
    transId,
    message,
    payType,
    resultCode,
  }) {
    orderId = Number(orderId.split('_')[0]);

    await this.createOne({ orderId, amount, transId, message, payType });

    switch (resultCode) {
      case MOMO_RESULT_CODE.SUCCESSFUL:
        await this.orderService.updateStatus(
          orderId,
          ORDER_STATUS.ON_PREPARING,
        );

        const foundOrder = await this.orderService.findOneById(orderId);

        await this.emailQueue.add({
          to: foundOrder.user.email,
          subject: EMAIL_TYPE.PLACE_ORDER.subject,
          template: EMAIL_TYPE.PLACE_ORDER.template,
          context: {
            address: foundOrder.address,
            orderId: foundOrder.id,
            createdAt: new Date(foundOrder.createdAt).toLocaleString('vi-VN'),
            phone: foundOrder.phone,
            total: addCommaToNumber(Number(foundOrder.total)),
            items: foundOrder.orderItems.map((item: OrderItem) => ({
              name: `${item.productSize.product.name}`,
              quantity: addCommaToNumber(item.quantity),
              total: addCommaToNumber(item.total),
            })),
          },
        });
        break;

      case MOMO_RESULT_CODE.QR_CODE_EXPIRED:
      case MOMO_RESULT_CODE.USER_DENIED:
        const order = await this.orderService.findOneById(orderId);
        const productSizes: ProductSize[] = [];

        order.orderItems.forEach((orderItem) => {
          orderItem.productSize.quantity =
            Number(orderItem.productSize.quantity) + Number(orderItem.quantity);
          productSizes.push(orderItem.productSize);
        });

        await this.productSizeRepository.save(productSizes);
        await this.orderService.updateStatus(orderId, ORDER_STATUS.CANCELLED);
        break;
    }
    await this.cacheManager.del(`order_${orderId}`);
  }

  async findAll() {
    return this.paymentRepository.find();
  }

  async findOneById(id: number): Promise<Payment> {
    const options = {
      where: { id },
    };
    const payment = await this.paymentRepository.findOne(options);

    if (!payment) {
      throw new NotFoundException(`Payment with id ${id} not found`);
    }

    return payment;
  }

  async createOne(createPaymentDto: CreatePaymentDto) {
    await this.paymentRepository.save(createPaymentDto);
  }

  async deleteOne(id: number) {
    const payment = await this.findOneById(id);

    await this.paymentRepository.delete(payment.id);
  }
}

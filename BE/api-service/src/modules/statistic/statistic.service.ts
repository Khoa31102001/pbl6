import { Order } from '@app/order/order.entity';
import { Receipt } from '@app/receipt/receipt.entity';
import { Inject, Injectable, ParseIntPipe } from '@nestjs/common';
import { ORDER_STATUS } from 'src/common/enums/order.enum';
import { Between, In, Repository } from 'typeorm';

@Injectable()
export class StatisticService {
  constructor(
    @Inject('ORDER_REPOSITORY')
    private orderRepository: Repository<Order>,

    @Inject('RECEIPT_REPOSITORY')
    private receiptRepository: Repository<Receipt>,
  ) {}

  async getTopSaleProduct(
    sort = 'desc',
    startDate: string,
    endDate: string,
    limit = 10,
  ) {
    startDate = !!startDate
      ? new Date(startDate).toISOString()
      : new Date(
          new Date().getFullYear(),
          new Date().getMonth(),
          1,
        ).toISOString();

    endDate = !endDate
      ? new Date().toISOString()
      : new Date(endDate).toISOString();

    const orders = await this.orderRepository.find({
      where: {
        status: In([ORDER_STATUS.ON_DELIVERY, ORDER_STATUS.ON_PREPARING]),
        createdAt: Between(startDate, endDate),
      },
      relations: [
        'user',
        'orderItems',
        'orderItems.productSize',
        'orderItems.productSize.product',
        'orderItems.productSize.product.images',
      ],
    });

    let topSaleProduct = [];

    orders.forEach((order) => {
      const obj = {
        quantity: order.orderItems.reduce(
          (acc, cur) => acc + Number(cur.quantity),
          0,
        ),
        product: order.orderItems[0].productSize.product,
      };

      const product = topSaleProduct.find(
        (item) => item.product.id === obj.product.id,
      );

      if (product) {
        product.quantity += obj.quantity;
      } else {
        topSaleProduct.push(obj);
      }
    });

    if (sort === 'asc') {
      topSaleProduct = topSaleProduct.sort((a, b) => a.quantity - b.quantity);
    } else {
      topSaleProduct = topSaleProduct.sort((a, b) => b.quantity - a.quantity);
    }

    return topSaleProduct.slice(0, limit);
  }

  async getRevenue(startDate: string, endDate: string) {
    startDate = startDate
      ? new Date(startDate).toISOString()
      : new Date(
          new Date().getFullYear(),
          new Date().getMonth(),
          1,
        ).toISOString();

    endDate = endDate
      ? new Date(endDate).toISOString()
      : new Date().toISOString();

    const receipts = await this.receiptRepository.find({
      where: {
        createdAt: Between(startDate, endDate),
      },
      relations: ['receiptProducts'],
    });

    const totalExpense = receipts.reduce(
      (acc, cur) =>
        acc +
        cur.receiptProducts.reduce(
          (acc, cur) => acc + parseInt(cur.quantity) * parseInt(cur.price),
          0,
        ),
      0,
    );

    const orders = await this.orderRepository.find({
      where: {
        status: In([ORDER_STATUS.ON_DELIVERY, ORDER_STATUS.ON_PREPARING]),
        createdAt: Between(startDate, endDate),
      },
      relations: ['orderItems'],
    });

    const totalIncome = orders.reduce((acc, cur) => acc + parseInt(cur.total), 0);

    return {
      totalExpense,
      totalIncome,
      revenue: totalIncome - totalExpense,
    };
  }

  async getIncomeByCategory(startDate: string, endDate: string) {
    startDate = startDate
      ? new Date(startDate).toISOString()
      : new Date(
          new Date().getFullYear(),
          new Date().getMonth(),
          1,
        ).toISOString();

    endDate = endDate
      ? new Date(endDate).toISOString()
      : new Date().toISOString();

    const orders = await this.orderRepository.find({
      where: {
        status: In([ORDER_STATUS.ON_DELIVERY, ORDER_STATUS.ON_PREPARING]),
        createdAt: Between(startDate, endDate),
      },
      relations: [
        'orderItems',
        'orderItems.productSize',
        'orderItems.productSize.product',
        'orderItems.productSize.product.category',
      ],
    });

    const incomeByCategory = {};

    orders.forEach((order) => {
      order.orderItems.forEach((item) => {
        const category = item.productSize.product.category.name;

        incomeByCategory[category] = incomeByCategory[category]
          ? incomeByCategory[category] + item.total
          : item.total;
      });
    });

    return incomeByCategory;
  }
}

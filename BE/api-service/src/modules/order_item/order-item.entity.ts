import { Column, Entity, JoinColumn, ManyToOne } from 'typeorm';
import { BaseEntity } from '@core/base/base.entity';
import { Order } from '@app/order/order.entity';
import { ProductSize } from '@app/product_size/product_size.entity';

@Entity('order_items')
export class OrderItem extends BaseEntity {
  // @Column({
  //   name: 'order_id',
  //   type: 'int',
  //   nullable: false,
  // })
  // orderId: number;

  @ManyToOne(() => Order, (order) => order.orderItems)
  @JoinColumn({ name: 'order_id' })
  order: Order;

  @Column({
    name: 'product_size_id',
    type: 'int',
    nullable: false,
  })
  productSizeId: number;

  @ManyToOne(() => ProductSize, (productSize) => productSize.orderItems)
  @JoinColumn({ name: 'product_size_id' })
  productSize: ProductSize;

  @Column({
    type: 'int',
    nullable: false,
  })
  quantity: number;

  @Column({
    type: 'int',
    nullable: false,
  })
  price: number;

  @Column({
    type: 'int',
    nullable: false,
  })
  total: number;
}

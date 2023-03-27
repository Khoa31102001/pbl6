import { forwardRef, Module } from '@nestjs/common';
import { PaymentService } from './payment.service';
import { PaymentController } from './payment.controller';
import { DatabaseModule } from '@app/base/database/database.module';
import { paymentProviders } from './payment.provider';
import { OrderModule } from '@app/order/order.module';
import { productSizeProviders } from '@app/product_size/product_size.provider';
import { REDIS_HOST, REDIS_PORT } from '@config/env';
import { BullModule } from '@nestjs/bull';

@Module({
  imports: [
    DatabaseModule, forwardRef(() => OrderModule),
    BullModule.forRoot({
      redis: {
        host: REDIS_HOST,
        port: REDIS_PORT,
      },
    }),
    BullModule.registerQueue({
      name: 'email',
    })
  ],
  providers: [PaymentService, ...paymentProviders, ...productSizeProviders],
  controllers: [PaymentController],
  exports: [PaymentService],
})
export class PaymentModule {}

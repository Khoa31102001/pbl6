import {
  forwardRef,
  MiddlewareConsumer,
  Module,
  RequestMethod,
} from '@nestjs/common';
import { OrderService } from './order.service';
import { OrderController } from './order.controller';
import { DatabaseModule } from '@app/base/database/database.module';
import { orderProviders } from './order.provider';
import { productSizeProviders } from '@app/product_size/product_size.provider';
import { userProviders } from '@app/user/user.provider';
import { PaymentModule } from '@app/payment/payment.module';
import { REDIS_HOST, REDIS_PORT } from '@config/env';
import { BullModule } from '@nestjs/bull';
import { AuthMiddleware } from 'src/middleware/auth.middleware';
import { ScheduleModule } from '@nestjs/schedule';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    DatabaseModule,
    forwardRef(() => PaymentModule),
    BullModule.forRoot({
      redis: {
        host: REDIS_HOST,
        port: REDIS_PORT,
      },
    }),
    BullModule.registerQueue({
      name: 'email',
    }),
  ],
  providers: [
    OrderService,
    ...orderProviders,
    ...productSizeProviders,
    ...userProviders,
  ],
  controllers: [OrderController],
  exports: [OrderService],
})
export class OrderModule {
  configure(consumer: MiddlewareConsumer) {
    consumer
      .apply(AuthMiddleware)
      .forRoutes({ path: 'orders/:id/received', method: RequestMethod.PUT });
  }
}

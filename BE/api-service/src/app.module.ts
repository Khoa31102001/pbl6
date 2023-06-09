import { DatabaseModule } from '@app/base/database/database.module';
import { AuthModule } from '@app/auth/auth.module';
import { UserModule } from '@app/user/user.module';
import { ProductModule } from '@app/product/product.module';
import { CacheModule, Module } from '@nestjs/common';
import { CategoryModule } from '@app/category/category.module';
import { SizeModule } from './modules/size/size.module';
import { ProductSizeModule } from './modules/product_size/product_size.module';
import { OrderModule } from '@app/order/order.module';
import { PaymentModule } from '@app/payment/payment.module';
import { DiscountModule } from '@app/discount/discount.module';
import { ImageModule } from '@app/image/image.module';
import * as redisStore from 'cache-manager-redis-store';
import { StatisticModule } from '@app/statistic/statistic.module';
import { ReceiptModule } from '@app/receipt/receipt.module';

@Module({
  imports: [
    CacheModule.register({
      isGlobal: true,
      store: redisStore,
      host: process.env.REDIS_HOST,
      port: process.env.REDIS_PORT,
    }),
    DatabaseModule,
    UserModule,
    AuthModule,
    ProductModule,
    CategoryModule,
    SizeModule,
    ProductSizeModule,
    OrderModule,
    PaymentModule,
    DiscountModule,
    ImageModule,
    StatisticModule,
    ReceiptModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}

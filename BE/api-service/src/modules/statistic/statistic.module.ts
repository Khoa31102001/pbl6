import { Module } from '@nestjs/common';
import { StatisticService } from './statistic.service';
import { StatisticController } from './statistic.controller';
import { DatabaseModule } from '@app/base/database/database.module';
import { OrderModule } from '@app/order/order.module';
import { orderProviders } from '@app/order/order.provider';
import { ReceiptModule } from '@app/receipt/receipt.module';
import { receiptProviders } from '@app/receipt/receipt.provider';

@Module({
  imports: [DatabaseModule, OrderModule, ReceiptModule],
  providers: [StatisticService, ...orderProviders, ...receiptProviders],
  controllers: [StatisticController],
  exports: [StatisticService],
})
export class StatisticModule {}

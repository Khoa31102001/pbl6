import { Module } from '@nestjs/common';
import { ProductService } from './product.service';
import { ProductController } from './product.controller';
import { DatabaseModule } from '@app/base/database/database.module';
import { productProviders } from './product.provider';
import { CategoryModule } from '@app/category/category.module';
import { SizeModule } from '@app/size/size.module';
import { ProductSizeModule } from '@app/product_size/product_size.module';
import { productSizeProviders } from '@app/product_size/product_size.provider';
import { ImageModule } from '@app/image/image.module';
import { imageProviders } from '@app/image/image.provider';

@Module({
  imports: [
    DatabaseModule,
    CategoryModule,
    SizeModule,
    ProductSizeModule,
    ImageModule,
  ],
  providers: [
    ProductService,
    ...productProviders,
    ...productSizeProviders,
    ...imageProviders,
  ],
  controllers: [ProductController],
  exports: [ProductService],
})
export class ProductModule {}

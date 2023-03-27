import { DataSource } from 'typeorm';
import { Factory, Seeder } from 'typeorm-seeding';

/* eslint-disable no-console */
/* eslint-disable @typescript-eslint/no-unused-vars */
import { Category } from '@app/category/category.entity';
import { Product } from '@app/product/product.entity';
import { Size } from '@app/size/size.entity';
import { ProductSize } from '@app/product_size/product_size.entity';
import { Image } from '@app/image/image.entity';

// https://www.npmjs.com/package/typeorm-seeding#%E2%9D%AF-basic-seeder
export default class DataSeeder implements Seeder {
  public async run(factory: Factory, _connection: DataSource): Promise<any> {
    console.log('\tSeeding data...');
    const categories = await factory(Category)().createMany(10);
    console.log('\t Categories created:', categories.length);

    const images: Image[] = await factory(Image)().createMany(5);

    console.log('\t Images created:', images.length);

    const sizes = await factory(Size)().createMany(10);
    console.log('\t Sizes created:', sizes.length);

    const products = await factory(Product)()
      .map(async (product: Product) => {
        product.category =
          categories[Math.floor(Math.random() * categories.length)];
        product.images = images;
        return product;
      })
      .createMany(100);
    console.log('\t Products created:', products.length);

    const product2Sizes = [];
    products.forEach((product) => {
      const randomSizes = sizes.sort(() => 0.5 - Math.random()).slice(0, 2);
      product2Sizes.push({
        product,
        size: randomSizes[0],
      });
      product2Sizes.push({
        product,
        size: randomSizes[1],
      });
    });
    const productSizes = await factory(ProductSize)()
      .map(async (productSize) => {
        const lastProduct = product2Sizes.pop();
        productSize.product = lastProduct.product;
        productSize.size = lastProduct.size;
        return productSize;
      })
      .createMany(200);
    console.log('\t ProductsSizes created:', productSizes.length);
  }
}

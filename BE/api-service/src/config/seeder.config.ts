import { join } from 'path';
import { DATABASE_CONFIG } from './env';

const seedingConfig = {
  name: 'seeding',
  type: <any>DATABASE_CONFIG.TYPEORM_CONNECTION,
  host: DATABASE_CONFIG.TYPEORM_HOST,
  port: DATABASE_CONFIG.TYPEORM_PORT,
  username: DATABASE_CONFIG.TYPEORM_USERNAME,
  password: DATABASE_CONFIG.TYPEORM_PASSWORD,
  database: DATABASE_CONFIG.TYPEORM_DATABASE,
  entities: [join(__dirname, '../../../', '**/*.entity{.ts,.js}')],
  seeds: [join(__dirname, '../../../', '**/*.seed{.ts,.js}')],
  factories: [join(__dirname, '../../../', '**/*.factory{.ts,.js}')],
};

export default seedingConfig;

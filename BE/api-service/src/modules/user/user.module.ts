import { DatabaseModule } from '@app/base/database/database.module';
import { Module } from '@nestjs/common';
import { BullModule } from '@nestjs/bull';
import { UserController } from './user.controller';
import { userProviders } from './user.provider';
import { UserService } from './user.service';
import { JwtModule } from '@nestjs/jwt';
import { JWT, REDIS_HOST, REDIS_PORT } from 'src/config/env';

@Module({
  imports: [
    BullModule.forRoot({
      redis: {
        host: REDIS_HOST,
        port: REDIS_PORT,
      },
    }),
    BullModule.registerQueue({
      name: 'email',
    }),
    JwtModule.register({
      secret: JWT.SECRET,
      signOptions: {
        expiresIn: JWT.EXPIRES_IN,
      },
    }),
    DatabaseModule,
  ],
  controllers: [UserController],
  providers: [UserService, ...userProviders],
  exports: [UserService],
})
export class UserModule {}

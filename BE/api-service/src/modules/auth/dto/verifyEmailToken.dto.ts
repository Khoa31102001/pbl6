import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty } from 'class-validator';

export class VerifyEmailTokenDto {
  @ApiProperty()
  @IsNotEmpty()
  token: string;
}

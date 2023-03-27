import { ValidHttpResponse } from '@core/response/validHttp.response';
import { Body, Controller, HttpStatus, Post } from '@nestjs/common';
import { ApiOperation, ApiResponse } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import {
  AuthCredentialsDto,
  SignUpCredentialsDto,
} from './dto/auth-credentials.dto';
import { VerifyEmailTokenDto } from './dto/verifyEmailToken.dto';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('signup')
  @ApiOperation({
    tags: ['Auth'],
    operationId: 'Sign up',
    summary: 'Sign up',
    description: 'Sign up',
  })
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Sign up',
  })
  async signUp(@Body() signUpCredentialsDto: SignUpCredentialsDto) {
    await this.authService.signUp(signUpCredentialsDto);
    return ValidHttpResponse.toNoContentResponse();
  }

  @Post('signin')
  @ApiOperation({
    tags: ['Auth'],
    operationId: 'Sign in',
    summary: 'Sign in',
    description: 'Sign in',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Sign in',
  })
  async signIn(@Body() authCredentialsDto: AuthCredentialsDto) {
    const data = await this.authService.signIn(authCredentialsDto);
    return ValidHttpResponse.toOkResponse(data);
  }

  @Post('verify-email-token')
  @ApiOperation({
    tags: ['Auth'],
    operationId: 'Verify email token',
    summary: 'Verify email token',
    description: 'Verify email token',
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Verify email',
  })
  async verifyEmailToken(@Body() verifyEmailTokenDto: VerifyEmailTokenDto) {
    const data = await this.authService.verifyEmailToken(
      verifyEmailTokenDto.token,
    );
    return ValidHttpResponse.toOkResponse(data);
  }
}

import { ConflictException, Inject, Injectable } from '@nestjs/common';
import { compareHashString, hashString } from 'src/common/utils/bcrypt';
import { Repository } from 'typeorm';
import { User } from './user.entity';
import {
  AuthCredentialsDto,
  SignUpCredentialsDto,
} from '@app/auth/dto/auth-credentials.dto';
import { InjectQueue } from '@nestjs/bull';
import { Queue } from 'bull';
import { JwtService } from '@nestjs/jwt';
import { EMAIL_TYPE } from 'src/common/enums/email.enum';
import { EMAIL_CONFIRMATION_URL } from '@config/env';
import { UpdateProfileDto } from './dto/update-profile.dto';

@Injectable()
export class UserService {
  constructor(
    @Inject('USER_REPOSITORY')
    private userRepository: Repository<User>,

    @InjectQueue('email')
    private emailQueue: Queue,

    private jwtService: JwtService,
  ) {}

  async sendVerifyEmail(email: string, verifyUrl: string) {
    await this.emailQueue.add(
      {
        to: email,
        subject: EMAIL_TYPE.VERIFY_EMAIL.subject,
        template: EMAIL_TYPE.VERIFY_EMAIL.template,
        context: {
          url: verifyUrl,
        },
      },
      {
        removeOnComplete: true,
      },
    );
  }

  async saveUser(user: User) {
    return this.userRepository.save(user);
  }

  async updatePassword(email: string, password: string) {
    const user = await this.userRepository.findOneBy({ email });
    if (!user) {
      throw new ConflictException('User not found');
    }
    user.password = hashString(password);
    await this.userRepository.save(user);
  }

  async updateProfile(updateProfileDto: UpdateProfileDto, email: string) {
    const user = await this.userRepository.findOneBy({ email });
    if (!user) {
      throw new ConflictException('User not found');
    }

    // delete null fields
    Object.keys(updateProfileDto).forEach(
      (key) => updateProfileDto[key] == null && delete updateProfileDto[key],
    );

    await this.userRepository.update(user.id, updateProfileDto);
  }

  async getMe(email: string) {
    const user = await this.userRepository.findOneBy({ email });
    if (user.password) {
      delete user.password;
    }
    return user;
  }

  async findOne(userInfo: { id?: number; email?: string }) {
    const { id, email } = userInfo;

    let user: User;
    if (id) {
      user = await this.userRepository.findOneBy({ id });
    }
    if (email) {
      user = await this.userRepository.findOneBy({ email });
    }

    return user;
  }

  async createOne(signUpCredentialsDto: SignUpCredentialsDto): Promise<void> {
    const { email } = signUpCredentialsDto;
    const existUser = await this.userRepository.findBy({ email });

    if (existUser.length) {
      throw new ConflictException('Email already exists');
    }

    const user = new User();
    user.email = email;

    await this.userRepository.insert(user);
    await this.handleSendVerifyEmail(email);
  }

  async handleSendVerifyEmail(email: string) {
    const token = this.jwtService.sign({ email });
    const verifyUrl = `${EMAIL_CONFIRMATION_URL}?token=${token}`;
    await this.sendVerifyEmail(email, verifyUrl);
  }

  async isValidCredential(
    authCredentialsDto: AuthCredentialsDto,
  ): Promise<boolean> {
    const { email, password } = authCredentialsDto;
    const user = await this.userRepository.findOneBy({ email });

    if (!user || !user?.password || !user?.isEmailConfirmed) {
      throw new ConflictException('Invalid credentials');
    }

    return user && compareHashString(password, user.password);
  }
}

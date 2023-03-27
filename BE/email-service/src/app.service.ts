import { MailerService } from '@nestjs-modules/mailer';
import { Process, Processor } from '@nestjs/bull';
import { BadRequestException, Injectable } from '@nestjs/common';
import { Job } from 'bull';
import { join } from 'path';
import { IEmailQueueData } from './interfaces/IEmailQueuData.interface';

@Injectable()
@Processor('email')
export class AppService {
  constructor(private mailerService: MailerService) {}

  @Process()
  async sendEmailHandleProcess(job: Job<unknown>) {
    const data: IEmailQueueData = job.data as IEmailQueueData;
    const isSuccess = await this.sendEmail(data);
    console.log('isSent: ', isSuccess);
    await job.progress(100);
  }

  async sendEmail(data: IEmailQueueData) {
    const dir = join(__dirname, 'templates');
    let template = '';
    switch (data.template) {
      case 'verify-email':
        template = 'verify_email';
        break;
      case 'place_order':
        template = 'place_order';
        break;
      default:
        throw new BadRequestException('Template not found');
    }
    try {
      const res = await this.mailerService.sendMail({
        to: data.to,
        from: '"Eshopping Team" <eshopping@ichhoa.dev>',
        subject: data.subject,
        template: `${dir}/${template}.hbs`,
        context: data.context,
      });
      return (
        res.accepted.length > 0 &&
        res.rejected.length === 0 &&
        res.response.includes('Ok')
      );
    } catch (error) {
      console.log(error);
    }
  }
}

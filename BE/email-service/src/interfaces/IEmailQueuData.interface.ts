export interface IEmailQueueData {
  to: string;
  subject: string;
  template: string;
  context: object;
}

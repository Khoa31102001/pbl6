import { config } from 'dotenv';
config();
const env = process.env;

export const REDIS_HOST = env.REDIS_HOST || 'localhost';
export const SERVER_PORT = env.SERVER_PORT || 3003;

export const MAIL_HOST = env.MAIL_HOST || 'smtp.sendgrid.net';
export const MAIL_USER = env.MAIL_USER || 'apikey';
export const MAIL_PASS = env.MAIL_PASS;

import { NestMiddleware } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { NextFunction, Request, Response } from 'express';

export class AuthMiddleware implements NestMiddleware {
  use(req: Request, res: Response, next: NextFunction) {
    const jwtService = new JwtService({ secret: process.env.JWT_SECRET });
    const payload = jwtService.decode(req.headers.authorization.split(' ')[1]);
    req.user = payload;
    next();
  }
}

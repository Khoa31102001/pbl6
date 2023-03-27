import { ProjectLogger } from "@core/loggers/log-service";
import { NextFunction, Request, Response } from "express";


export const RequestLoggerMiddleware = ( req: Request, res: Response, next: NextFunction ) => {
    const { method, url, body, params, query } = req;    
    ProjectLogger.info(`Request: ${method} ${url} with body: ${JSON.stringify(body)} and params: ${JSON.stringify(params)} and query: ${JSON.stringify(query)}`);

    next();
};
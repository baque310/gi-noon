import {
  ArgumentsHost, Catch, ExceptionFilter, HttpException, HttpStatus,
} from '@nestjs/common';
import { HttpAdapterHost } from '@nestjs/core';
import { Prisma } from '@prisma/client';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
  constructor(private readonly httpAdapterHost: HttpAdapterHost) {}

  catch(exception: unknown, host: ArgumentsHost): void {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const { httpAdapter } = this.httpAdapterHost;

    if (exception instanceof Prisma.PrismaClientKnownRequestError) {
      const statusMap: Record<string, number> = {
        P2002: HttpStatus.CONFLICT,
        P2003: HttpStatus.BAD_REQUEST,
        P2025: HttpStatus.NOT_FOUND,
      };
      const msgMap: Record<string, string> = {
        P2002: 'Resource already exists',
        P2003: 'Foreign key constraint failed',
        P2025: 'Record not found',
      };
      const status = statusMap[exception.code] || HttpStatus.INTERNAL_SERVER_ERROR;
      const message = msgMap[exception.code] || 'Database error';
      httpAdapter.reply(response, { statusCode: status, message }, status);
    } else if (exception instanceof HttpException) {
      const status = exception.getStatus();
      const res: any = exception.getResponse();
      const message = typeof res === 'string' ? res : res.message;
      httpAdapter.reply(response, { statusCode: status, message }, status);
    } else if (exception instanceof Error) {
      httpAdapter.reply(response, {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: exception.message,
      }, HttpStatus.INTERNAL_SERVER_ERROR);
    } else {
      httpAdapter.reply(response, {
        statusCode: HttpStatus.INTERNAL_SERVER_ERROR,
        message: 'Unknown error occurred',
      }, HttpStatus.INTERNAL_SERVER_ERROR);
    }
  }
}

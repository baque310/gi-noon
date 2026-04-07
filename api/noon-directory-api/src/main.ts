import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as cookieParser from 'cookie-parser';
import { json, urlencoded } from 'express';

async function bootstrap() {
  process.env.TZ = 'Asia/Baghdad';

  const app = await NestFactory.create(AppModule, {
    logger: ['debug', 'error', 'warn'],
    forceCloseConnections: true,
  });
  app.enableCors({
    origin: process.env.ORIGIN_CLIENT?.split(',') || '*',
    credentials: true,
  });
  app.use(cookieParser());
  app.use(json({ limit: '50mb' }));
  app.use(urlencoded({ extended: true, limit: '50mb' }));

  app.use(
    ['/api-docs'],
    require('express-basic-auth')({
      users: { [process.env.SWAGGER_USER as string]: process.env.SWAGGER_PASSWORD },
      challenge: true,
      unauthorizedResponse: (req: any) => `Unauthorized access attempt from IP: ${req.ip}`,
      realm: 'swaggerRealm',
    }),
  );

  const options = new DocumentBuilder()
    .setTitle('Noon Directory API')
    .setDescription('API documentation for Noon Directory Platform')
    .setVersion('1.0')
    .addBearerAuth({ type: 'http', scheme: 'bearer', bearerFormat: 'JWT' }, 'bearer')
    .addApiKey({ type: 'apiKey', name: 'x-api-key', in: 'header' }, 'apiKey')
    .addSecurityRequirements('apiKey')
    .build();

  const document = SwaggerModule.createDocument(app, options);
  document.security = [{ apiKey: [] }];
  SwaggerModule.setup('/api-docs', app, document);

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: true,
      forbidNonWhitelisted: false,
    }),
  );

  app.enableShutdownHooks();
  await app.listen(process.env.PORT || 3003, process.env.HOST || '0.0.0.0');
  console.log(`🚀 Noon Directory API is running on: ${await app.getUrl()}`);
}
bootstrap();

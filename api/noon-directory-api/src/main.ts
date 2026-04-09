import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
import * as cookieParser from 'cookie-parser';
import { json, urlencoded } from 'express';
import * as express from 'express';
import { join } from 'path';

async function bootstrap() {
  process.env.TZ = 'Asia/Baghdad';

  const app = await NestFactory.create(AppModule, {
    logger: ['debug', 'error', 'warn'],
    forceCloseConnections: true,
  });

  // ===== Global prefix /api for all API routes =====
  app.setGlobalPrefix('api', {
    exclude: ['/dashboard(.*)'],
  });

  app.enableCors({
    origin: process.env.ORIGIN_CLIENT?.split(',') || '*',
    credentials: true,
  });
  app.use(cookieParser());
  app.use(json({ limit: '50mb' }));
  app.use(urlencoded({ extended: true, limit: '50mb' }));

  // ===== Serve Dashboard static files under /dashboard =====
  const dashboardPath = join(process.cwd(), '..', 'dashboard-build');
  app.use('/dashboard', express.static(dashboardPath));
  // Handle Next.js client-side routing - serve index.html for all /dashboard/* routes
  app.use('/dashboard/*', (req: any, res: any, next: any) => {
    const fs = require('fs');
    const requestedPath = req.originalUrl.replace('/dashboard', '');
    const staticFile = join(dashboardPath, requestedPath);
    // If the file exists, serve it
    if (fs.existsSync(staticFile) && fs.statSync(staticFile).isFile()) {
      return next();
    }
    // Try .html version (Next.js static export)
    const htmlFile = join(dashboardPath, requestedPath + '.html');
    if (fs.existsSync(htmlFile)) {
      return res.sendFile(htmlFile);
    }
    // Try index.html in subfolder
    const indexFile = join(dashboardPath, requestedPath, 'index.html');
    if (fs.existsSync(indexFile)) {
      return res.sendFile(indexFile);
    }
    // Fallback to dashboard index (SPA routing)
    const mainIndex = join(dashboardPath, 'index.html');
    if (fs.existsSync(mainIndex)) {
      return res.sendFile(mainIndex);
    }
    next();
  });

  // ===== Swagger Docs =====
  app.use(
    ['/api/api-docs'],
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
  SwaggerModule.setup('api/api-docs', app, document);

  app.useGlobalPipes(
    new ValidationPipe({
      transform: true,
      whitelist: true,
      forbidNonWhitelisted: false,
    }),
  );

  app.enableShutdownHooks();
  await app.listen(process.env.PORT || 3040, process.env.HOST || '0.0.0.0');
  console.log(`🚀 Noon Directory API is running on: ${await app.getUrl()}`);
  console.log(`📋 Dashboard served at: ${await app.getUrl()}/dashboard`);
  console.log(`📖 API Docs at: ${await app.getUrl()}/api/api-docs`);
}
bootstrap();

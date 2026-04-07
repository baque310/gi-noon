import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ServeStaticModule } from '@nestjs/serve-static';
import { ScheduleModule } from '@nestjs/schedule';
import { MulterModule } from '@nestjs/platform-express';
import { APP_FILTER, APP_GUARD } from '@nestjs/core';
import { join } from 'path';
import * as dotenv from 'dotenv';

// Core modules
import { PrismaModule } from './prisma/prisma.module';
import { AuthModule } from './auth/auth.module';
import { AdminModule } from './admin/admin.module';

// Feature modules
import { DirectoryListingModule } from './directory-listing/directory-listing.module';
import { BannerModule } from './banner/banner.module';
import { AdRequestModule } from './ad-request/ad-request.module';
import { JobSeekerModule } from './job-seeker/job-seeker.module';
import { NotificationsModule } from './notifications/notifications.module';

// Guards & Filters
import { ApiKeyGuard, AtGuard } from './auth/common/guards';
import { AllExceptionsFilter } from './all-exceptions.filter';
import { PrismaService } from './prisma/prisma.service';
import { JwtService } from '@nestjs/jwt';
import { AuthService } from './auth/auth.service';

dotenv.config();

@Module({
  imports: [
    ServeStaticModule.forRoot({
      rootPath: join(process.cwd(), 'uploads'),
      serveRoot: '/uploads',
      exclude: ['/(.*)'],
      serveStaticOptions: { index: false },
    }),
    ScheduleModule.forRoot(),
    ConfigModule.forRoot({ isGlobal: true }),
    MulterModule.register({ dest: './uploads' }),

    // Core
    PrismaModule,
    AuthModule,
    AdminModule,

    // Features
    DirectoryListingModule,
    BannerModule,
    AdRequestModule,
    JobSeekerModule,
    NotificationsModule,
  ],
  providers: [
    { provide: APP_GUARD, useClass: ApiKeyGuard },
    { provide: APP_GUARD, useClass: AtGuard },
    { provide: APP_FILTER, useClass: AllExceptionsFilter },
    PrismaService,
    JwtService,
    AuthService,
  ],
})
export class AppModule {}

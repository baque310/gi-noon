import { Module } from '@nestjs/common';
import { BannerService } from './banner.service';
import { BannerAdminController, BannerPublicController } from './banner.controller';

@Module({
  controllers: [BannerAdminController, BannerPublicController],
  providers: [BannerService],
})
export class BannerModule {}

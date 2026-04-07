import { Module } from '@nestjs/common';
import { AdRequestService } from './ad-request.service';
import { AdRequestAdminController, AdRequestPublicController } from './ad-request.controller';

@Module({
  controllers: [AdRequestAdminController, AdRequestPublicController],
  providers: [AdRequestService],
})
export class AdRequestModule {}

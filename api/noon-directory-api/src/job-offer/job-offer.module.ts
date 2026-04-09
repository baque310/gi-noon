import { Module } from '@nestjs/common';
import { JobOfferService } from './job-offer.service';
import { JobOfferAdminController, JobOfferPublicController } from './job-offer.controller';

@Module({
  controllers: [JobOfferAdminController, JobOfferPublicController],
  providers: [JobOfferService],
})
export class JobOfferModule {}

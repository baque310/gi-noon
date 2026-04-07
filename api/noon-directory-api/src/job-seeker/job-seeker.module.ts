import { Module } from '@nestjs/common';
import { JobSeekerService } from './job-seeker.service';
import { JobSeekerAdminController, JobSeekerPublicController } from './job-seeker.controller';

@Module({
  controllers: [JobSeekerAdminController, JobSeekerPublicController],
  providers: [JobSeekerService],
})
export class JobSeekerModule {}

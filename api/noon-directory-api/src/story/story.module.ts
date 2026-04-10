import { Module } from '@nestjs/common';
import { StoryService } from './story.service';
import { StoryAdminController, StoryPublicController } from './story.controller';

@Module({
  controllers: [StoryAdminController, StoryPublicController],
  providers: [StoryService],
})
export class StoryModule {}

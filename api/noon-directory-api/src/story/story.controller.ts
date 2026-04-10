import { Controller, Get, Post, Patch, Delete, Body, Param, UseInterceptors, UploadedFiles } from '@nestjs/common';
import { StoryService } from './story.service';
import { ApiTags, ApiConsumes } from '@nestjs/swagger';
import { FileFieldsInterceptor } from '@nestjs/platform-express';
import { multerConfig } from 'src/multer.config';
import { Public } from 'src/auth/common/decorators';

@ApiTags('Story - Admin')
@Controller('manager/story')
export class StoryAdminController {
  constructor(private readonly service: StoryService) {}

  @Post()
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileFieldsInterceptor([
    { name: 'thumbnail', maxCount: 1 },
    { name: 'video', maxCount: 1 },
  ], multerConfig))
  create(
    @Body() data: any,
    @UploadedFiles() files: { thumbnail?: Express.Multer.File[], video?: Express.Multer.File[] },
  ) {
    const thumbnailFile = files.thumbnail?.[0]?.filename;
    const videoFile = files.video?.[0]?.filename;
    if (!thumbnailFile || !videoFile) {
      throw new Error('Both thumbnail and video files are required');
    }
    return this.service.create(data, thumbnailFile, videoFile);
  }

  @Get()
  findAll() { return this.service.findAll(); }

  @Get(':id')
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Patch(':id')
  update(@Param('id') id: string, @Body() data: any) { return this.service.update(id, data); }

  @Delete(':id')
  remove(@Param('id') id: string) { return this.service.remove(id); }
}

@ApiTags('Story - Public')
@Controller('public/story')
export class StoryPublicController {
  constructor(private readonly service: StoryService) {}

  @Get()
  @Public()
  findAllActive() { return this.service.findAllActive(); }

  @Post(':id/view')
  @Public()
  incrementView(@Param('id') id: string) { return this.service.incrementView(id); }
}

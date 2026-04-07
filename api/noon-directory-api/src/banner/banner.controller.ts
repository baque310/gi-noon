import { Controller, Get, Post, Patch, Delete, Body, Param, UseInterceptors, UploadedFile } from '@nestjs/common';
import { BannerService } from './banner.service';
import { ApiTags, ApiConsumes } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { multerConfig } from 'src/multer.config';
import { Public } from 'src/auth/common/decorators';

@ApiTags('Banner - Admin')
@Controller('manager/banner')
export class BannerAdminController {
  constructor(private readonly service: BannerService) {}

  @Post()
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('url', multerConfig))
  create(@Body() data: any, @UploadedFile() file: Express.Multer.File) {
    return this.service.create(data, file.filename);
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

@ApiTags('Banner - Public')
@Controller('public/banner')
export class BannerPublicController {
  constructor(private readonly service: BannerService) {}

  @Get()
  @Public()
  findAllActive() { return this.service.findAllActive(); }
}

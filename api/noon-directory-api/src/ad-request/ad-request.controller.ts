import { Controller, Get, Post, Delete, Body, Param, Query, Patch, UseInterceptors, UploadedFile } from '@nestjs/common';
import { AdRequestService } from './ad-request.service';
import { ApiTags, ApiConsumes } from '@nestjs/swagger';
import { Public } from 'src/auth/common/decorators';
import { FileInterceptor } from '@nestjs/platform-express';
import { multerConfig } from 'src/multer.config';

@ApiTags('Ad Request - Admin')
@Controller('manager/ad-request')
export class AdRequestAdminController {
  constructor(private readonly service: AdRequestService) {}

  @Get()
  findAll(
    @Query('skip') skip?: string, @Query('take') take?: string, @Query('status') status?: string,
  ) {
    return this.service.findAll({ skip: skip ? parseInt(skip) : 0, take: take ? parseInt(take) : 10, status });
  }

  @Get(':id')
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Patch(':id/approve')
  approve(@Param('id') id: string, @Body('adminNote') adminNote?: string) {
    return this.service.approve(id, adminNote);
  }

  @Patch(':id/reject')
  reject(@Param('id') id: string, @Body('adminNote') adminNote?: string) {
    return this.service.reject(id, adminNote);
  }

  @Delete(':id')
  remove(@Param('id') id: string) { return this.service.remove(id); }
}

@ApiTags('Ad Request - Public')
@Controller('public/ad-request')
export class AdRequestPublicController {
  constructor(private readonly service: AdRequestService) {}

  @Post()
  @Public()
  submit(@Body() data: any) { return this.service.submitRequest(data); }
}

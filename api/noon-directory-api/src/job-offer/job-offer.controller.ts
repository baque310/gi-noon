import { Controller, Get, Post, Delete, Body, Param, Query, Patch, UseInterceptors, UploadedFile } from '@nestjs/common';
import { JobOfferService } from './job-offer.service';
import { ApiTags, ApiConsumes } from '@nestjs/swagger';
import { Public } from 'src/auth/common/decorators';
import { FileInterceptor } from '@nestjs/platform-express';
import { multerConfig } from 'src/multer.config';

@ApiTags('Job Offer - Admin')
@Controller('manager/job-offer')
export class JobOfferAdminController {
  constructor(private readonly service: JobOfferService) {}

  @Get()
  findAll(
    @Query('skip') skip?: string, @Query('take') take?: string,
    @Query('province') province?: string, @Query('category') category?: string,
    @Query('status') status?: string,
  ) {
    return this.service.findAll({
      skip: skip ? parseInt(skip) : 0, take: take ? parseInt(take) : 10,
      province, category, status,
    });
  }

  @Get(':id')
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Patch(':id')
  update(@Param('id') id: string, @Body() data: any) {
    return this.service.update(id, data);
  }

  @Patch(':id/approve')
  approve(@Param('id') id: string) { return this.service.approve(id); }

  @Patch(':id/reject')
  reject(@Param('id') id: string) { return this.service.reject(id); }

  @Delete(':id')
  remove(@Param('id') id: string) { return this.service.remove(id); }

  @Post(':id/logo')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('logo', multerConfig))
  uploadLogo(@Param('id') id: string, @UploadedFile() file: Express.Multer.File) {
    return this.service.uploadLogo(id, file.filename);
  }
}

@ApiTags('Job Offer - Public')
@Controller('public/job-offer')
export class JobOfferPublicController {
  constructor(private readonly service: JobOfferService) {}

  @Post()
  @Public()
  submit(@Body() data: any) { return this.service.submit(data); }

  @Get()
  @Public()
  getAll(@Query('province') province?: string, @Query('category') category?: string) {
    return this.service.getPublicJobOffers(province, category);
  }
}

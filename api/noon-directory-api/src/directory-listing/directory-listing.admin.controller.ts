import { Controller, Get, Post, Patch, Delete, Body, Param, Query, UseInterceptors, UploadedFile } from '@nestjs/common';
import { DirectoryListingService } from './directory-listing.service';
import { ApiTags, ApiConsumes } from '@nestjs/swagger';
import { FileInterceptor } from '@nestjs/platform-express';
import { multerConfig } from 'src/multer.config';

@ApiTags('Directory Listing - Admin')
@Controller('manager/directory-listing')
export class DirectoryListingAdminController {
  constructor(private readonly service: DirectoryListingService) {}

  @Post()
  create(@Body() data: any) {
    return this.service.create(data);
  }

  @Get()
  findAll(
    @Query('skip') skip?: string,
    @Query('take') take?: string,
    @Query('search') search?: string,
    @Query('category') category?: string,
    @Query('province') province?: string,
  ) {
    return this.service.findAll({
      skip: skip ? parseInt(skip) : 0,
      take: take ? parseInt(take) : 10,
      search, category, province,
    });
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.service.findById(id);
  }

  @Patch(':id')
  update(@Param('id') id: string, @Body() data: any) {
    return this.service.update(id, data);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.service.remove(id);
  }

  @Post(':id/logo')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('logo', multerConfig))
  uploadLogo(@Param('id') id: string, @UploadedFile() file: Express.Multer.File) {
    return this.service.uploadLogo(id, file.filename);
  }

  @Post(':id/image')
  @ApiConsumes('multipart/form-data')
  @UseInterceptors(FileInterceptor('image', multerConfig))
  addImage(@Param('id') id: string, @UploadedFile() file: Express.Multer.File) {
    return this.service.addImage(id, file.filename);
  }

  @Delete('image/:imageId')
  removeImage(@Param('imageId') imageId: string) {
    return this.service.removeImage(imageId);
  }
}

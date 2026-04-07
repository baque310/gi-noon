import { Controller, Get, Param, Query, Post } from '@nestjs/common';
import { DirectoryListingService } from './directory-listing.service';
import { ApiTags } from '@nestjs/swagger';
import { Public } from 'src/auth/common/decorators';

@ApiTags('Directory Listing - Public')
@Controller('public/directory-listing')
export class DirectoryListingPublicController {
  constructor(private readonly service: DirectoryListingService) {}

  @Get()
  @Public()
  getPublicDirectory(@Query('province') province?: string) {
    return this.service.getPublicDirectory(province);
  }

  @Get(':id')
  @Public()
  getById(@Param('id') id: string) {
    return this.service.findById(id);
  }

  @Post(':id/click')
  @Public()
  trackClick(@Param('id') id: string) {
    return this.service.trackClick(id);
  }
}

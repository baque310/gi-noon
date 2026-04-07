import { Module } from '@nestjs/common';
import { DirectoryListingService } from './directory-listing.service';
import { DirectoryListingAdminController } from './directory-listing.admin.controller';
import { DirectoryListingPublicController } from './directory-listing.public.controller';

@Module({
  controllers: [DirectoryListingAdminController, DirectoryListingPublicController],
  providers: [DirectoryListingService],
  exports: [DirectoryListingService],
})
export class DirectoryListingModule {}

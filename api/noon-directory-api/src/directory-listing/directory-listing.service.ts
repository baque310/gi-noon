import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { nd_Status } from '@prisma/client';
import { fileUnlink } from 'src/utils';

@Injectable()
export class DirectoryListingService {
  constructor(private readonly prismaService: PrismaService) {}

  async create(data: any) {
    const { sendNotification, ...listingData } = data;
    const newListing = await this.prismaService.ndDirectoryListing.create({ data: listingData });

    if (sendNotification === true || sendNotification === 'true') {
      let categoryName = 'مكان';
      switch (newListing.category) {
        case 'INSTITUTE': categoryName = 'معهد تقوية'; break;
        case 'PRIVATE_SCHOOL': categoryName = 'مدرسة أهلية'; break;
        case 'KINDERGARTEN': categoryName = 'روضة أطفال'; break;
        case 'TEACHER': categoryName = 'أستاذ'; break;
        case 'LIBRARY': categoryName = 'مكتبة'; break;
        case 'HEALTH_DENTAL': categoryName = 'طبيب أسنان'; break;
      }

      await this.prismaService.ndNotification.create({
        data: {
          title: `تم إضافة ${categoryName} جديد!`,
          body: `${newListing.name} متاح الآن في ${newListing.province}. تفقد التفاصيل الآن في دليل نون.`,
        },
      });
    }

    return newListing;
  }

  async findAll(params: { skip?: number; take?: number; search?: string; category?: string; province?: string }) {
    const where: any = {};
    if (params.search) {
      where.OR = [
        { name: { contains: params.search } },
        { description: { contains: params.search } },
      ];
    }
    if (params.category) where.category = params.category;
    if (params.province) where.province = { contains: params.province };

    const skip = (params.skip || 0) * (params.take || 10);
    const take = params.take || 10;

    const [data, totalCount] = await Promise.all([
      this.prismaService.ndDirectoryListing.findMany({
        skip, take, where, include: { images: true },
        orderBy: { createdAt: 'desc' },
      }),
      this.prismaService.ndDirectoryListing.count({ where }),
    ]);
    return { data, totalCount, pageCount: Math.ceil(totalCount / take) };
  }

  async findById(id: string) {
    const listing = await this.prismaService.ndDirectoryListing.findUnique({
      where: { id }, include: { images: true, reviews: { where: { isApproved: nd_Status.TRUE } } },
    });
    if (!listing) throw new NotFoundException('Listing not found');
    // Increment view count
    await this.prismaService.ndDirectoryListing.update({ where: { id }, data: { viewCount: { increment: 1 } } });
    return listing;
  }

  async update(id: string, data: any) {
    await this.findById(id);
    return this.prismaService.ndDirectoryListing.update({ where: { id }, data });
  }

  async remove(id: string) {
    const listing = await this.findById(id);
    if (listing.logo) fileUnlink(listing.logo);
    listing.images?.forEach((img) => fileUnlink(img.url));
    await this.prismaService.ndDirectoryListing.delete({ where: { id } });
    return { success: true, message: 'Listing deleted' };
  }

  async uploadLogo(id: string, filename: string) {
    const listing = await this.findById(id);
    if (listing.logo) fileUnlink(listing.logo);
    return this.prismaService.ndDirectoryListing.update({ where: { id }, data: { logo: filename } });
  }

  async addImage(id: string, filename: string) {
    await this.findById(id);
    return this.prismaService.ndDirectoryListingImage.create({
      data: { url: filename, directoryListingId: id },
    });
  }

  async removeImage(imageId: string) {
    const image = await this.prismaService.ndDirectoryListingImage.findUnique({ where: { id: imageId } });
    if (!image) throw new NotFoundException('Image not found');
    fileUnlink(image.url);
    return this.prismaService.ndDirectoryListingImage.delete({ where: { id: imageId } });
  }

  // ========== PUBLIC ENDPOINTS FOR MOBILE ==========

  async getPublicDirectory(province?: string) {
    const where: any = { isActive: nd_Status.TRUE };
    if (province && province.trim() !== '') {
      where.province = { contains: province.trim() };
    }

    const listings = await this.prismaService.ndDirectoryListing.findMany({
      where, include: { images: true }, orderBy: [{ isFeatured: 'desc' }, { createdAt: 'desc' }],
    });

    const categories: Record<string, any[]> = {
      institute: [], physical_activity: [], kindergarten: [], private_school: [],
      teacher: [], library: [], uniform: [],
      smart_toys: [], health_dental: [], health_pediatric: [], health_specialist: [],
    };

    for (const listing of listings) {
      const key = listing.category.toLowerCase();
      if (categories[key]) categories[key].push(listing);
    }

    return { categories };
  }

  async trackClick(id: string) {
    await this.prismaService.ndDirectoryListing.update({
      where: { id }, data: { clickCount: { increment: 1 } },
    });
    return { success: true };
  }
}

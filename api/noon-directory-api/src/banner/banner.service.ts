import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { nd_Status } from '@prisma/client';
import { fileUnlink } from 'src/utils';

@Injectable()
export class BannerService {
  constructor(private readonly prismaService: PrismaService) {}

  async create(data: any, filename: string) {
    return this.prismaService.ndBanner.create({
      data: { 
        ...data, 
        url: filename, 
        priority: data.priority ? parseInt(data.priority) : 99999,
        isVertical: data.isVertical === 'true' || data.isVertical === true
      },
    });
  }

  async findAll() {
    return this.prismaService.ndBanner.findMany({ orderBy: { priority: 'asc' } });
  }

  async findAllActive() {
    return this.prismaService.ndBanner.findMany({
      where: { isActive: nd_Status.TRUE },
      orderBy: { priority: 'asc' },
    });
  }

  async findOne(id: string) {
    const banner = await this.prismaService.ndBanner.findUnique({ where: { id } });
    if (!banner) throw new NotFoundException('Banner not found');
    return banner;
  }

  async update(id: string, data: any) {
    await this.findOne(id);
    return this.prismaService.ndBanner.update({ where: { id }, data });
  }

  async remove(id: string) {
    const banner = await this.findOne(id);
    if (banner.url) fileUnlink(banner.url);
    await this.prismaService.ndBanner.delete({ where: { id } });
    return { success: true, message: 'Banner deleted' };
  }
}

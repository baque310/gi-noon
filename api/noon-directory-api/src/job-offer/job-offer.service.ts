import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { nd_AdRequestStatus, nd_Status } from '@prisma/client';

@Injectable()
export class JobOfferService {
  constructor(private readonly prismaService: PrismaService) {}

  async submit(data: any) {
    return this.prismaService.ndJobOffer.create({ data });
  }

  async findAll(params: { skip?: number; take?: number; province?: string; category?: string; status?: string }) {
    const where: any = {};
    if (params.province) where.province = { contains: params.province };
    if (params.category) where.category = params.category;
    if (params.status) where.isApproved = params.status;

    const skip = (params.skip || 0) * (params.take || 10);
    const take = params.take || 10;

    const [data, totalCount] = await Promise.all([
      this.prismaService.ndJobOffer.findMany({ skip, take, where, orderBy: { createdAt: 'desc' } }),
      this.prismaService.ndJobOffer.count({ where }),
    ]);
    return { data, totalCount, pageCount: Math.ceil(totalCount / take) };
  }

  async findOne(id: string) {
    const offer = await this.prismaService.ndJobOffer.findUnique({ where: { id } });
    if (!offer) throw new NotFoundException('Job offer not found');
    return offer;
  }

  async update(id: string, data: any) {
    await this.findOne(id);
    return this.prismaService.ndJobOffer.update({ where: { id }, data });
  }

  async approve(id: string) {
    await this.findOne(id);
    return this.prismaService.ndJobOffer.update({
      where: { id }, data: { isApproved: nd_AdRequestStatus.APPROVED },
    });
  }

  async reject(id: string) {
    await this.findOne(id);
    return this.prismaService.ndJobOffer.update({
      where: { id }, data: { isApproved: nd_AdRequestStatus.REJECTED },
    });
  }

  async remove(id: string) {
    await this.findOne(id);
    await this.prismaService.ndJobOffer.delete({ where: { id } });
    return { success: true, message: 'Job offer deleted' };
  }

  async uploadLogo(id: string, filename: string) {
    await this.findOne(id);
    return this.prismaService.ndJobOffer.update({
      where: { id },
      data: { companyLogo: filename },
    });
  }

  // Public: get approved job offers (hide contact info)
  async getPublicJobOffers(province?: string, category?: string) {
    const where: any = { isApproved: nd_AdRequestStatus.APPROVED, isActive: nd_Status.TRUE };
    if (province) where.province = { contains: province };
    if (category) where.category = category;

    const offers = await this.prismaService.ndJobOffer.findMany({
      where,
      orderBy: { createdAt: 'desc' },
      select: {
        id: true,
        companyName: true,
        companyLogo: true,
        jobTitle: true,
        category: true,
        province: true,
        description: true,
        requirements: true,
        salaryRange: true,
        createdAt: true,
        // contactPhone and contactEmail are intentionally EXCLUDED for public
      },
    });
    return offers;
  }
}

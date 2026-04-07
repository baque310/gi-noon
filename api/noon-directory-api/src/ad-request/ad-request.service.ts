import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { nd_AdRequestStatus } from '@prisma/client';

@Injectable()
export class AdRequestService {
  constructor(private readonly prismaService: PrismaService) {}

  // Mobile: submit ad request
  async submitRequest(data: any) {
    return this.prismaService.ndAdRequest.create({ data });
  }

  // Admin: list all requests
  async findAll(params: { skip?: number; take?: number; status?: string }) {
    const where: any = {};
    if (params.status) where.status = params.status;

    const skip = (params.skip || 0) * (params.take || 10);
    const take = params.take || 10;

    const [data, totalCount] = await Promise.all([
      this.prismaService.ndAdRequest.findMany({
        skip, take, where, include: { images: true }, orderBy: { createdAt: 'desc' },
      }),
      this.prismaService.ndAdRequest.count({ where }),
    ]);
    return { data, totalCount, pageCount: Math.ceil(totalCount / take) };
  }

  async findOne(id: string) {
    const req = await this.prismaService.ndAdRequest.findUnique({
      where: { id }, include: { images: true },
    });
    if (!req) throw new NotFoundException('Ad request not found');
    return req;
  }

  // Admin: approve request -> create listing automatically
  async approve(id: string, adminNote?: string) {
    const req = await this.findOne(id);
    await this.prismaService.ndAdRequest.update({
      where: { id },
      data: { status: nd_AdRequestStatus.APPROVED, adminNote },
    });

    // Auto-create a directory listing from the approved request
    const listing = await this.prismaService.ndDirectoryListing.create({
      data: {
        name: req.name,
        category: req.category,
        province: req.province,
        phone: req.phone,
        email: req.email,
        description: req.description,
        logo: req.logo,
        address: req.address,
        website: req.website,
      },
    });

    // Copy images
    for (const img of req.images) {
      await this.prismaService.ndDirectoryListingImage.create({
        data: { url: img.url, directoryListingId: listing.id },
      });
    }

    return { success: true, message: 'Request approved and listing created', listing };
  }

  // Admin: reject request
  async reject(id: string, adminNote?: string) {
    await this.findOne(id);
    await this.prismaService.ndAdRequest.update({
      where: { id },
      data: { status: nd_AdRequestStatus.REJECTED, adminNote },
    });
    return { success: true, message: 'Request rejected' };
  }

  async remove(id: string) {
    await this.findOne(id);
    await this.prismaService.ndAdRequest.delete({ where: { id } });
    return { success: true, message: 'Request deleted' };
  }
}

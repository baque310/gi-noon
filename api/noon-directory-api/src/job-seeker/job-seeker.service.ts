import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { nd_AdRequestStatus, nd_Status } from '@prisma/client';

@Injectable()
export class JobSeekerService {
  constructor(private readonly prismaService: PrismaService) {}

  async submit(data: any) {
    return this.prismaService.ndJobSeeker.create({ data });
  }

  async findAll(params: { skip?: number; take?: number; province?: string; speciality?: string; status?: string }) {
    const where: any = {};
    if (params.province) where.province = { contains: params.province };
    if (params.speciality) where.speciality = { contains: params.speciality };
    if (params.status) where.isApproved = params.status;

    const skip = (params.skip || 0) * (params.take || 10);
    const take = params.take || 10;

    const [data, totalCount] = await Promise.all([
      this.prismaService.ndJobSeeker.findMany({ skip, take, where, orderBy: { createdAt: 'desc' } }),
      this.prismaService.ndJobSeeker.count({ where }),
    ]);
    return { data, totalCount, pageCount: Math.ceil(totalCount / take) };
  }

  async findOne(id: string) {
    const seeker = await this.prismaService.ndJobSeeker.findUnique({ where: { id } });
    if (!seeker) throw new NotFoundException('Job seeker not found');
    return seeker;
  }

  async approve(id: string) {
    await this.findOne(id);
    return this.prismaService.ndJobSeeker.update({
      where: { id }, data: { isApproved: nd_AdRequestStatus.APPROVED },
    });
  }

  async reject(id: string) {
    await this.findOne(id);
    return this.prismaService.ndJobSeeker.update({
      where: { id }, data: { isApproved: nd_AdRequestStatus.REJECTED },
    });
  }

  async remove(id: string) {
    await this.findOne(id);
    await this.prismaService.ndJobSeeker.delete({ where: { id } });
    return { success: true, message: 'Job seeker deleted' };
  }

  // Public: get approved job seekers
  async getPublicJobSeekers(province?: string, speciality?: string) {
    const where: any = { isApproved: nd_AdRequestStatus.APPROVED, isActive: nd_Status.TRUE };
    if (province) where.province = { contains: province };
    if (speciality) where.speciality = { contains: speciality };
    return this.prismaService.ndJobSeeker.findMany({ where, orderBy: { createdAt: 'desc' } });
  }
}

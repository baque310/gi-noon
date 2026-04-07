import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class AdminService {
  constructor(private readonly prismaService: PrismaService) {}

  async findOne(id: string) {
    const admin = await this.prismaService.ndAdmin.findUnique({
      where: { id },
    });
    if (!admin) {
      throw new NotFoundException('Admin not found');
    }
    admin.roles = JSON.parse(admin.roles) as any;
    return admin;
  }

  async findAll(params: { skip?: number; take?: number; search?: string }) {
    const skip = params.skip || 0;
    const take = params.take || 10;
    const where: any = {};

    if (params.search) {
      where.OR = [{ username: { contains: params.search } }];
    }

    const [data, totalCount] = await Promise.all([
      this.prismaService.ndAdmin.findMany({
        skip: skip * take,
        take,
        where,
        select: {
          id: true,
          username: true,
          photo: true,
          isActive: true,
          RoleType: true,
          createdAt: true,
        },
      }),
      this.prismaService.ndAdmin.count({ where }),
    ]);
    const pageCount = Math.ceil(totalCount / take);
    return { data, totalCount, pageCount };
  }

  async remove(id: string) {
    const admin = await this.prismaService.ndAdmin.findUnique({ where: { id } });
    if (!admin) throw new NotFoundException('Admin not found');
    await this.prismaService.ndAdmin.delete({ where: { id } });
    return { success: true, message: 'Admin deleted successfully' };
  }
}

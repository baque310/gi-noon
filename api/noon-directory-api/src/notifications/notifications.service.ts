import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class NotificationsService {
  constructor(private prisma: PrismaService) {}

  async create(createNotificationDto: { title: string; body: string; link?: string }) {
    return this.prisma.ndNotification.create({
      data: createNotificationDto,
    });
  }

  async findAllActive() {
    return this.prisma.ndNotification.findMany({
      where: { isActive: 'TRUE' },
      orderBy: { createdAt: 'desc' },
      take: 50,
    });
  }

  async findAll() {
    return this.prisma.ndNotification.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  async remove(id: string) {
    return this.prisma.ndNotification.delete({
      where: { id },
    });
  }
}

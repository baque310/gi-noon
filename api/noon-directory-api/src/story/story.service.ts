import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { nd_Status } from '@prisma/client';
import { fileUnlink } from 'src/utils';

@Injectable()
export class StoryService {
  constructor(private readonly prismaService: PrismaService) {}

  async create(data: any, thumbnailFilename: string, videoFilename: string) {
    return this.prismaService.ndStory.create({
      data: {
        title: data.title || '',
        advertiserName: data.advertiserName || null,
        thumbnail: thumbnailFilename,
        videoUrl: videoFilename,
        duration: data.duration ? parseInt(data.duration) : 15,
        priority: data.priority ? parseInt(data.priority) : 99999,
        link: data.link || null,
        expiresAt: data.expiresAt ? new Date(data.expiresAt) : null,
      },
    });
  }

  async findAll() {
    return this.prismaService.ndStory.findMany({
      orderBy: { priority: 'asc' },
    });
  }

  async findAllActive() {
    return this.prismaService.ndStory.findMany({
      where: {
        isActive: nd_Status.TRUE,
        OR: [
          { expiresAt: null },
          { expiresAt: { gte: new Date() } },
        ],
      },
      orderBy: { priority: 'asc' },
    });
  }

  async findOne(id: string) {
    const story = await this.prismaService.ndStory.findUnique({ where: { id } });
    if (!story) throw new NotFoundException('Story not found');
    return story;
  }

  async update(id: string, data: any) {
    await this.findOne(id);
    const updateData: any = {};
    if (data.title !== undefined) updateData.title = data.title;
    if (data.advertiserName !== undefined) updateData.advertiserName = data.advertiserName;
    if (data.link !== undefined) updateData.link = data.link;
    if (data.priority !== undefined) updateData.priority = parseInt(data.priority);
    if (data.duration !== undefined) updateData.duration = parseInt(data.duration);
    if (data.isActive !== undefined) updateData.isActive = data.isActive;
    if (data.expiresAt !== undefined) updateData.expiresAt = data.expiresAt ? new Date(data.expiresAt) : null;
    return this.prismaService.ndStory.update({ where: { id }, data: updateData });
  }

  async incrementView(id: string) {
    return this.prismaService.ndStory.update({
      where: { id },
      data: { viewCount: { increment: 1 } },
    });
  }

  async remove(id: string) {
    const story = await this.findOne(id);
    if (story.thumbnail) fileUnlink(story.thumbnail);
    if (story.videoUrl) fileUnlink(story.videoUrl);
    await this.prismaService.ndStory.delete({ where: { id } });
    return { success: true, message: 'Story deleted' };
  }
}

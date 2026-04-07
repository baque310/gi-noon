import { Controller, Get, Post, Delete, Body, Param, Query, Patch } from '@nestjs/common';
import { JobSeekerService } from './job-seeker.service';
import { ApiTags } from '@nestjs/swagger';
import { Public } from 'src/auth/common/decorators';

@ApiTags('Job Seeker - Admin')
@Controller('manager/job-seeker')
export class JobSeekerAdminController {
  constructor(private readonly service: JobSeekerService) {}

  @Get()
  findAll(
    @Query('skip') skip?: string, @Query('take') take?: string,
    @Query('province') province?: string, @Query('speciality') speciality?: string,
    @Query('status') status?: string,
  ) {
    return this.service.findAll({
      skip: skip ? parseInt(skip) : 0, take: take ? parseInt(take) : 10,
      province, speciality, status,
    });
  }

  @Get(':id')
  findOne(@Param('id') id: string) { return this.service.findOne(id); }

  @Patch(':id/approve')
  approve(@Param('id') id: string) { return this.service.approve(id); }

  @Patch(':id/reject')
  reject(@Param('id') id: string) { return this.service.reject(id); }

  @Delete(':id')
  remove(@Param('id') id: string) { return this.service.remove(id); }
}

@ApiTags('Job Seeker - Public')
@Controller('public/job-seeker')
export class JobSeekerPublicController {
  constructor(private readonly service: JobSeekerService) {}

  @Post()
  @Public()
  submit(@Body() data: any) { return this.service.submit(data); }

  @Get()
  @Public()
  getAll(@Query('province') province?: string, @Query('speciality') speciality?: string) {
    return this.service.getPublicJobSeekers(province, speciality);
  }
}

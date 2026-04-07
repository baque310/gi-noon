import { Controller, Get, Delete, Param } from '@nestjs/common';
import { NotificationsService } from './notifications.service';
import { Public } from '../auth/common/decorators';

@Controller()
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Public()
  @Get('public/notifications')
  findAllActive() {
    return this.notificationsService.findAllActive();
  }

  @Get('admin/notifications')
  findAll() {
    return this.notificationsService.findAll();
  }

  @Delete('admin/notifications/:id')
  remove(@Param('id') id: string) {
    return this.notificationsService.remove(id);
  }
}

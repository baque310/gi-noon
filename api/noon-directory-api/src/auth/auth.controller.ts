import { Body, Controller, Post, Res, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateAdminDto, SigninAdminDto } from './dto';
import { ApiTags } from '@nestjs/swagger';
import { Public } from './common/decorators';
import { GetCurrentAdmin, GetCurrentAdminId } from './common/decorators';
import { AuthGuard } from '@nestjs/passport';
import { Response } from 'express';

@ApiTags('Auth')
@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Public()
  @Post('signup')
  signup(@Body() dto: CreateAdminDto) {
    return this.authService.signupLocal(dto);
  }

  @Public()
  @Post('signin')
  signin(
    @Body() dto: SigninAdminDto,
    @Res({ passthrough: true }) response: Response,
  ) {
    return this.authService.signinLocal(dto, response);
  }

  @Post('logout')
  logout(
    @GetCurrentAdminId() adminId: string,
    @Res({ passthrough: true }) response: Response,
  ) {
    return this.authService.logout(adminId, response);
  }

  @UseGuards(AuthGuard('jwt-refresh'))
  @Post('refresh')
  refreshTokens(
    @GetCurrentAdminId() adminId: string,
    @GetCurrentAdmin('refreshToken') refreshToken: string,
    @Res({ passthrough: true }) response: Response,
  ) {
    return this.authService.refreshTokens(adminId, refreshToken, response);
  }
}

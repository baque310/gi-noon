import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { Request } from 'express';
import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AdminService } from 'src/admin/admin.service';
import { nd_Status } from '@prisma/client';

@Injectable()
export class RtStrategy extends PassportStrategy(Strategy, 'jwt-refresh') {
  constructor(
    readonly configService: ConfigService,
    private readonly adminService: AdminService,
  ) {
    super({
      jwtFromRequest: RtStrategy.cookieExtractor,
      secretOrKey: configService.get('JWT_RT_SECRET'),
      passReqToCallback: true,
    });
  }
  async validate(req: Request, payload: any) {
    const admin = await this.adminService.findOne(payload.sub);
    if (!admin.hashedRt || admin.isActive !== nd_Status.TRUE) {
      throw new UnauthorizedException('Unauthorized');
    }
    const refreshToken = RtStrategy.extractTokenFromCookie(req);
    return { ...payload, refreshToken };
  }
  private static cookieExtractor(req: Request) {
    let token = null;
    if (req && req.cookies) {
      token = req.cookies['token_refresh'];
    }
    return token;
  }
  private static extractTokenFromCookie(req: Request) {
    return req.cookies['token_refresh'];
  }
}

@Injectable()
export class RtAdminStrategy extends PassportStrategy(Strategy, 'admin-jwt-refresh') {
  constructor(
    readonly configService: ConfigService,
    private readonly adminService: AdminService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get('JWT_RT_SECRET'),
      passReqToCallback: true,
    });
  }
  async validate(req: Request, payload: any) {
    const refreshToken = req?.headers?.authorization?.split(' ')[1];
    const admin = await this.adminService.findOne(payload.sub);
    if (!admin.hashedRt || admin.isActive !== nd_Status.TRUE) {
      throw new UnauthorizedException('Unauthorized');
    }
    return { ...payload, refreshToken };
  }
}

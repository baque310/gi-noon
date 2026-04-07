import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { Request } from 'express';
import { AdminService } from 'src/admin/admin.service';
import { nd_Status } from '@prisma/client';

export type JwtPayload = {
  sub: string;
  username: string;
};

@Injectable()
export class AtStrategy extends PassportStrategy(Strategy, 'jwt') {
  constructor(
    readonly configService: ConfigService,
    private readonly adminService: AdminService,
  ) {
    super({
      jwtFromRequest: AtStrategy.cookieExtractor,
      secretOrKey: configService.get('JWT_AT_SECRET'),
    });
  }
  async validate(payload: JwtPayload) {
    const admin = await this.adminService.findOne(payload.sub);
    if (!admin.hashedRt || admin.isActive !== nd_Status.TRUE) {
      throw new UnauthorizedException('Unauthorized');
    }
    return payload;
  }
  private static cookieExtractor(request: Request) {
    let token_access = null;
    if (request && request.cookies) {
      token_access = request.cookies['token_access'];
    }
    return token_access;
  }
}

@Injectable()
export class AtAdminStrategy extends PassportStrategy(Strategy, 'admin-jwt') {
  constructor(
    readonly configService: ConfigService,
    private readonly adminService: AdminService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get('JWT_AT_SECRET'),
    });
  }
  async validate(payload: JwtPayload) {
    const admin = await this.adminService.findOne(payload.sub);
    if (!admin.hashedRt || admin.isActive !== nd_Status.TRUE) {
      throw new UnauthorizedException('Unauthorized');
    }
    return payload;
  }
}

@Injectable()
export class VendorAtStrategy extends PassportStrategy(Strategy, 'vendor-jwt') {
  constructor(readonly configService: ConfigService) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      secretOrKey: configService.get('JWT_VENDOR_AT_SECRET'),
    });
  }
  async validate(payload: any) {
    return payload;
  }
}

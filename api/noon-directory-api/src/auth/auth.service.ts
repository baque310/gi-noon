import {
  UnauthorizedException,
  Injectable,
  HttpException,
  HttpStatus,
  Res,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';
import { CreateAdminDto, SigninAdminDto } from './dto';
import * as bcrypt from 'bcrypt';
import { Tokens } from './types';
import { JwtService } from '@nestjs/jwt/dist';
import { ConfigService } from '@nestjs/config';
import { hashData } from 'src/utils';
import { NdAdmin, nd_Status } from '@prisma/client';
import { Response } from 'express';

const cookieHttpOptions = { httpOnly: true, secure: false };
const cookieHttpsOptions = { httpOnly: true, secure: true, sameSite: 'none' as const };

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async signupLocal(dto: CreateAdminDto) {
    const admin = await this.prisma.ndAdmin.findUnique({
      where: { username: dto.username },
    });
    if (admin)
      throw new HttpException('username already exist', HttpStatus.BAD_REQUEST);

    const hash = await hashData(dto.password);
    const newAdmin = await this.prisma.ndAdmin.create({
      data: {
        username: dto.username,
        hash,
        isActive: dto.isActive,
        roles: JSON.stringify(dto.roles || []),
      },
    });
    const tokens = await this.getTokens(newAdmin);
    await this.updateRtHash(newAdmin.id, tokens.token_refresh);
    return tokens.admin;
  }

  async signinLocal(
    dto: SigninAdminDto,
    @Res({ passthrough: true }) response: Response,
  ): Promise<any> {
    const admin = await this.prisma.ndAdmin.findFirst({
      where: { username: dto.username, isActive: nd_Status.TRUE },
    });
    if (!admin) throw new UnauthorizedException('Access denied');

    const passwordMatches = await bcrypt.compare(dto.password, admin.hash);
    if (!passwordMatches) throw new UnauthorizedException('Access denied');

    const tokens = await this.getTokens(admin);
    await this.updateRtHash(admin.id, tokens.token_refresh);

    delete (admin as any).hash;
    delete (admin as any).hashedRt;
    admin.roles = JSON.parse(admin.roles) as any;

    response.cookie(
      'token_access',
      tokens.token_access,
      process.env.NODE_ENV == 'production' ? cookieHttpsOptions : cookieHttpOptions,
    );
    response.cookie(
      'token_refresh',
      tokens.token_refresh,
      process.env.NODE_ENV == 'production' ? cookieHttpsOptions : cookieHttpOptions,
    );
    return admin;
  }

  async logout(
    adminId: string,
    @Res({ passthrough: true }) response: Response,
  ) {
    try {
      response.clearCookie('token_access');
      response.clearCookie('token_refresh');
      await this.prisma.ndAdmin.updateMany({
        where: { id: adminId, hashedRt: { not: null } },
        data: { hashedRt: null },
      });
    } catch (error) {}
  }

  async refreshTokens(
    adminId: string,
    rt: string,
    @Res({ passthrough: true }) response: Response,
  ) {
    const admin = await this.prisma.ndAdmin.findFirst({
      where: { id: adminId, isActive: nd_Status.TRUE },
    });
    if (!admin || !admin.hashedRt) throw new UnauthorizedException('Access denied');

    const rtMatches = await bcrypt.compare(rt, admin.hashedRt);
    if (!rtMatches) throw new UnauthorizedException('Access denied');

    delete (admin as any).hash;
    delete (admin as any).hashedRt;
    admin.roles = JSON.parse(admin.roles) as any;

    const tokens = await this.getTokens(admin);
    response.cookie(
      'token_access',
      tokens.token_access,
      process.env.NODE_ENV == 'production' ? cookieHttpsOptions : cookieHttpOptions,
    );
    response.cookie(
      'token_refresh',
      tokens.token_refresh,
      process.env.NODE_ENV == 'production' ? cookieHttpsOptions : cookieHttpOptions,
    );
    await this.updateRtHash(admin.id, tokens.token_refresh);
    return tokens.admin;
  }

  async getTokens(admin: NdAdmin): Promise<Tokens> {
    const [at, rt] = await Promise.all([
      this.jwtService.signAsync(
        { sub: admin.id, username: admin.username, userType: 'ADMIN' },
        {
          secret: this.configService.get<string>('JWT_AT_SECRET'),
          expiresIn: this.configService.get<string>('JWT_AT_EXPIRE') || '7d',
        },
      ),
      this.jwtService.signAsync(
        { sub: admin.id, username: admin.username, userType: 'ADMIN' },
        {
          secret: this.configService.get<string>('JWT_RT_SECRET'),
          expiresIn: this.configService.get<string>('JWT_RT_EXPIRE') || '7d',
        },
      ),
    ]);
    return { token_access: at, token_refresh: rt, admin };
  }

  async updateRtHash(adminId: string, rt: string) {
    const hash = await hashData(rt);
    await this.prisma.ndAdmin.update({
      where: { id: adminId },
      data: { hashedRt: hash },
    });
  }
}

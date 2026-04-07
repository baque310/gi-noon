import { Global, Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { AtStrategy, AtAdminStrategy, VendorAtStrategy, RtStrategy, RtAdminStrategy } from './strategies';
import { JwtModule } from '@nestjs/jwt';
import { AdminService } from 'src/admin/admin.service';

@Global()
@Module({
  imports: [JwtModule.register({})],
  controllers: [AuthController],
  providers: [
    AuthService,
    AtStrategy,
    AtAdminStrategy,
    VendorAtStrategy,
    RtStrategy,
    RtAdminStrategy,
    AdminService,
  ],
  exports: [
    AuthService,
    AtStrategy,
    AtAdminStrategy,
    VendorAtStrategy,
    RtStrategy,
    RtAdminStrategy,
    AdminService,
  ],
})
export class AuthModule {}

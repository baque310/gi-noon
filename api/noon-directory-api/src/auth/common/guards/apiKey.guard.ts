import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class ApiKeyGuard implements CanActivate {
  constructor(private prisma: PrismaService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const apiKey = request.headers['x-api-key'];

    if (!apiKey) throw new UnauthorizedException('API key is missing');

    // Allow local development key or env key
    if (apiKey === process.env.VALID_API_KEY) return true;

    const client = await this.prisma.ndClient.findUnique({
      where: { apiKey },
    });

    if (!client || !client.isActive) {
      throw new UnauthorizedException('Invalid or inactive API key');
    }

    return true;
  }
}

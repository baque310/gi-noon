import { existsSync, mkdirSync } from 'fs';
import { diskStorage } from 'multer';
import { extname, join } from 'path';

const dir = join(process.cwd(), 'uploads');
export const multerConfig = {
  dest: dir,
  storage: diskStorage({
    destination: (req: any, file: any, cb: any) => {
      if (!existsSync(dir)) {
        mkdirSync(dir, { recursive: true });
      }
      cb(null, dir);
    },
    filename: (req: any, file: any, cb: any) => {
      const randomName = Array(32)
        .fill(null)
        .map(() => Math.round(Math.random() * 16).toString(16))
        .join('');
      cb(null, `${randomName}${extname(file.originalname)}`);
    },
  }),
  fileFilter: (req: any, file: any, cb: any) => {
    const allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.pdf', '.svg', '.mp4', '.mov', '.webm'];
    const ext = extname(file.originalname).toLowerCase();
    if (!allowedExtensions.includes(ext)) {
      return cb(new Error('Only image or pdf files are allowed!'), false);
    }
    cb(null, true);
  },
};

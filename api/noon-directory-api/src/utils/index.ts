import * as bcrypt from 'bcrypt';
import { BadRequestException } from '@nestjs/common';
import { access, unlink } from 'fs/promises';

export const hashData = async (data: string): Promise<string> => {
  const salt = await bcrypt.genSalt();
  return bcrypt.hashSync(data, salt);
};

export async function isfileExist(path: string): Promise<any> {
  try {
    await access('./uploads/' + path);
    return true;
  } catch (error) {
    return false;
  }
}

export async function fileUnlink(path: string): Promise<any> {
  try {
    if (await isfileExist(path)) return await unlink('./uploads/' + path);
  } catch (error) {
    console.log(error);
  }
}

export function isPasswordStrong(password: string): boolean {
  if (password.length < 8) {
    throw new BadRequestException('Password must be at least 8 characters long');
  }
  const hasLetter = /[a-zA-Z]/.test(password);
  const hasNumber = /[0-9]/.test(password);
  if (!hasLetter || !hasNumber) {
    throw new BadRequestException('Password must contain at least one letter and one number');
  }
  return true;
}

export function createArabicSearchConditions<T>(
  field: keyof T,
  search: string,
): Array<{ [key in keyof T]?: any }> {
  const variations = new Set<string>();
  variations.add(search);

  if (/[اأإآ]/.test(search)) {
    variations.add(search.replace(/ا|أ|إ|آ/g, 'ا'));
    variations.add(search.replace(/ا|أ|إ|آ/g, 'أ'));
    variations.add(search.replace(/ا|أ|إ|آ/g, 'إ'));
    variations.add(search.replace(/ا|أ|إ|آ/g, 'آ'));
  }
  if (/[وؤ]/.test(search)) {
    variations.add(search.replace(/و|ؤ/g, 'و'));
    variations.add(search.replace(/و|ؤ/g, 'ؤ'));
  }
  if (/[ىئ]/.test(search)) {
    variations.add(search.replace(/ى|ئ/g, 'ى'));
    variations.add(search.replace(/ى|ئ/g, 'ئ'));
  }
  if (/[هة]/.test(search)) {
    variations.add(search.replace(/ه|ة/g, 'ه'));
    variations.add(search.replace(/ه|ة/g, 'ة'));
  }

  return Array.from(variations).map((variant) => ({
    [field]: { contains: variant },
  })) as Array<{ [key in keyof T]?: any }>;
}

export function buildSearchConditions<T>(fields: (keyof T)[], search: string) {
  const searchConditions = fields.flatMap((field) =>
    createArabicSearchConditions<T>(field, search),
  );
  return { OR: searchConditions };
}

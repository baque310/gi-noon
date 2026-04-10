const bcrypt = require('bcrypt');
const { PrismaClient } = require('@prisma/client');

const prisma = new PrismaClient();

async function main() {
  const salt = await bcrypt.genSalt();
  const hash = bcrypt.hashSync('Admin@2024!', salt);

  const admin = await prisma.ndAdmin.upsert({
    where: { username: 'admin' },
    update: {},
    create: {
      username: 'admin',
      hash,
      roles: JSON.stringify([{ resource: '*', permissions: [{ action: '*', possession: 'any' }] }]),
      isActive: 'TRUE',
      RoleType: 'SuperAdmin',
    },
  });

  // Insert a sample disclaimer
  await prisma.ndDisclaimer.upsert({
    where: { id: 'default-disclaimer' },
    update: {},
    create: {
      id: 'default-disclaimer',
      title: 'إخلاء مسؤولية',
      content: 'دليل نون هو منصة إعلانية فقط ولا يتحمل أي مسؤولية عن جودة الخدمات أو المنتجات المقدمة من قبل المُعلنين. يتحمل المُعلن المسؤولية الكاملة عن صحة المعلومات المنشورة والخدمات المقدمة. يُنصح بالتحقق من المعلومات والخدمات بشكل مستقل قبل اتخاذ أي قرار.',
      isActive: 'TRUE',
    },
  });

  console.log('✅ Admin created:', admin.username);
  console.log('✅ Disclaimer created');
}

main()
  .catch((e) => { console.error(e); process.exit(1); })
  .finally(async () => { await prisma.$disconnect(); });

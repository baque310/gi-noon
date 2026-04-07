const fs = require('fs');
const file = 'd:/workspace noonTech/prooooooooooooooooooooo/mobile/noon-main/lib/view/screen/home/pages/biometric/biometric_attendance_screen.dart';
let txt = fs.readFileSync(file, 'utf8');
txt = txt.replace(/withOpacity\(/g, 'withValues(alpha: ');
fs.writeFileSync(file, txt);
console.log('done replacing opacity');

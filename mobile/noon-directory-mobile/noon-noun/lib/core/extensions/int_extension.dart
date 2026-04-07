import 'package:s_extensions/extensions/number_ext.dart';

extension IntExtension on int {
  String toKBMB() {
    if (this < 1024) {
      return '$this B';
    }
    if (this < 1024 * 1024) {
      return '${(this / 1024).fixed00} KB';
    }
    return '${(this / 1024 / 1024).fixed00} MB';
  }
}

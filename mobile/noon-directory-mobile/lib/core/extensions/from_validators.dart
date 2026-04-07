import 'package:get/get.dart';
import 'package:noon/core/localization/language.dart';

extension FromValidators on String? {
  String? get isValidText {
    if (this != null && this!.trim().isNotEmpty) {
      return null;
    } else {
      return AppLanguage.fieldIsRequired.tr;
    }
  }
}

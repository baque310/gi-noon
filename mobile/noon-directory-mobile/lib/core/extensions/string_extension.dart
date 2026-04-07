import 'package:noon/core/constant/api_urls.dart';

extension StringExtension on String? {
  String? get imgUrlToFullUrl {
    if (this == null) {
      return null;
    }
    return '${ApiUrls.filesUrl}/$this';
  }

  String? get pdfUrlToFullUrl {
    if (this == null) {
      return null;
    }
    return '${ApiUrls.filesUrl}/$this';
  }
}

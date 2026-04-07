import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:s_extensions/s_extensions.dart';
import 'package:share_plus/share_plus.dart';
import 'package:noon/core/localization/language.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FileHelper {
  static Future<File?> downloadFile({
    required String url,
    String? name,
    Function(String fileName, String path)? onComplete,
    void Function(String? path, double progress)? onProgress,
  }) async {
    try {
      // final result = await FileDownloader.downloadFile(
      //   url: url,
      //   name: name ?? Uri.parse(url).pathSegments.last,
      //   downloadService: .httpConnection,
      //   notificationType: .all,
      //   downloadDestination: Platform.isIOS ? .appFiles : .publicDownloads,
      //   onDownloadCompleted: (String path) {
      //     final savedName = path.split(Platform.pathSeparator).last;

      //     if (onComplete != null) {
      //       onComplete(savedName, path);
      //     }

      //     Get.snackbar(
      //       'تم تحميل الملف بنجاح ✓',
      //       'تم حفظ الملف في مجلد التحميلات',
      //     );
      //   },
      //   onDownloadError: (String error) {
      //     Get.snackbar('خطأ في تحميل الملف', error);
      //   },
      //   onProgress: onProgress,
      // );
      // return result;

      Directory? directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt >= 29) {
          directory = await getExternalStorageDirectory();
        } else {
          directory = Directory('/storage/emulated/0/Download');
          if (!await directory.exists()) {
            directory = await getExternalStorageDirectory();
          }
        }
      }
      final saveDir = directory ?? await getApplicationSupportDirectory();

      if (Platform.isAndroid) {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        if (androidInfo.version.sdkInt <= 32) {
          final status = await Permission.storage.request();
          if (!status.isGranted) {
            Get.snackbar(
              AppLanguage.errorStr.tr,
              AppLanguage.permissionDenied.tr,
            );
            return null;
          }
        }
      }

      final fileName = name ?? Uri.parse(url).pathSegments.last;
      final filePath = '${saveDir.path}/$fileName';

      final dio = Dio();
      final response = await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (!total.isNegative && onProgress.isNotNull) {
            onProgress!(filePath, received / total);
          }
        },
      );

      final file = File(filePath);
      if (await file.exists()) {
        if (onComplete != null) {
          onComplete(fileName, filePath);
        }

        Get.snackbar(AppLanguage.fileDownloadedStr.tr, ' ', duration: 3.sec);

        return file;
      } else {
        Get.snackbar(
          AppLanguage.errorStr.tr,
          '${AppLanguage.fileDownloadErrorStr.tr} ${response.statusCode}',
        );
        return null;
      }
    } catch (e) {
      Get.snackbar(
        AppLanguage.errorStr.tr,
        '${AppLanguage.fileDownloadErrorStr.tr} ${e.toString()}',
      );
      return null;
    }
  }

  static Future<void> saveImageToGallery(String url) async {
    try {
      if (!await Gal.hasAccess()) {
        await Gal.requestAccess();
      }

      String filePath = url;
      bool isLocal = !url.startsWith('http');

      if (!isLocal) {
        final tempDir = await getTemporaryDirectory();
        final fileName = url.split('/').last.split('?').first;
        filePath = '${tempDir.path}/$fileName';

        final dio = Dio();
        await dio.download(url, filePath);
      }

      final ext = url
          .split('/')
          .last
          .split('?')
          .first
          .split('.')
          .last
          .toLowerCase();
      final isVideo = ['mp4', 'mov', 'avi'].contains(ext);

      if (isVideo) {
        await Gal.putVideo(filePath);
      } else {
        await Gal.putImage(filePath);
      }

      Get.snackbar(AppLanguage.success.tr, AppLanguage.imageSavedToGallery.tr);

      if (!isLocal) {
        final file = File(filePath);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      if (e is GalException) {
        Get.snackbar(
          'خطأ',
          'لا يمكن الوصول إلى المعرض. يرجى التحقق من الإعدادات.',
        );
      } else {
        Get.snackbar('خطأ', 'فشل حفظ الصورة: ${e.toString()}');
      }
    }
  }

  static Future<bool> shareFile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        Get.snackbar(
          AppLanguage.fileShareErrorTitle.tr,
          AppLanguage.fileNotFoundError.tr,
        );
        return false;
      }

      await SharePlus.instance.share(ShareParams(files: [XFile(filePath)]));
      return true;
    } catch (e) {
      Get.snackbar(AppLanguage.fileShareErrorTitle.tr, e.toString());
      return true;
    }
  }
}

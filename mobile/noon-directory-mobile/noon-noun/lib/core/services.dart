import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:noon/core/constant/app_strings.dart';

class MyServices extends GetxService {
  Future<MyServices> init() async {
    await Hive.initFlutter();
    await Hive.openBox(AppStrings.boxKey);
    await Hive.openBox<String>('downloaded_files');
    await Hive.openBox<String>('downloaded_files_paths');

    return this;
  }
}

Future<void> initialServices() async {
  await Get.putAsync(() => MyServices().init());
}

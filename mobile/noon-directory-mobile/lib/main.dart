import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/device_utils.dart';
import 'package:noon/core/init_easy_loading.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/services.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/firebase/firebase_initializations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:noon/routes.dart';
import 'package:noon/theme.dart';
import 'package:s_extensions/s_extensions.dart';
import 'controllers/global_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initEasyLoading();
  await initialServices();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await initializeFirebase();
  await initializeDateFormatting('ar', null);
  await initializeDateFormatting('en', null);
  DeviceUtils.stopDeviceOrientation;
  ApiService().initializeDio();

  Get.put(GlobalController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppSizes().init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      getPages: routes,
      translations: AppLanguage(),
      locale: Get.find<GlobalController>().locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      fallbackLocale: const Locale('ar'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: EasyLoading.init(
        builder: (context, child) {
          FlutterSExtensions.update(context);
          return child!;
        },
      ),
    );
  }
}

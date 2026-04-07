import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/custom_appbar.dart';

import '../../../core/localization/language.dart';

class NotRegisteredScreen extends StatelessWidget {
  const NotRegisteredScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: '',
        isLeading: true,
        press: () {
          Get.back();
        },
      ),
      body: Center(
        child: Text(AppLanguage.notRegisterYet.tr, style: AppTextStyles.bold20),
      ),
    );
  }
}

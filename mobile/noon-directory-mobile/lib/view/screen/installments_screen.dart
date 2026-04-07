import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/installments_controller.dart';
import 'package:noon/view/widget/app_tab_bar.dart';
import 'package:noon/view/widget/installment_item.dart';
import 'package:noon/view/widget/other_payment_item.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import '../../core/localization/language.dart';
import '../widget/custom_appbar.dart';
import '../widget/error_message.dart';

class InstallmentsScreen extends StatelessWidget {
  InstallmentsScreen({super.key});

  final controller = Get.find<InstallmentsController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: CustomAppBar(
          appBarName: AppLanguage.aqsatiStr.tr,
          isLeading: true,
          press: () => Get.back(),
          bottom: AppTabBar(
            isScrollable: false,
            tabs: [AppLanguage.aqsatiStr.tr, AppLanguage.otherAqsatiStr.tr],
            onTap: (index) => controller.updateSelectedTab(index),
          ),
        ),
        body: TabBarView(
          children: [_buildInstallmentsTab(), _buildOtherPaymentsTab()],
        ),
      ),
    );
  }

  Widget _buildInstallmentsTab() {
    return Obx(() {
      if (controller.isLoadingInstallments.value) {
        return const Center(child: Loading());
      }

      if (controller.installmentsError.value.isNotEmpty) {
        return ErrorMessage(
          press: () => controller.fetchInstallments(),
          errorMsg: controller.installmentsError.value,
        );
      }

      if (controller.installmentsData.isEmpty) {
        return NoDataWidget(title: AppLanguage.noInfoAvailable.tr);
      }

      return ListView.separated(
        padding: const .symmetric(horizontal: 16, vertical: 24),
        itemCount: controller.installmentsData.length,
        itemBuilder: (_, i) =>
            InstallmentItem(installment: controller.installmentsData[i]),
        separatorBuilder: (_, _) => const SizedBox(height: 8),
      );
    });
  }

  Widget _buildOtherPaymentsTab() {
    return Obx(() {
      if (controller.isLoadingOtherPayments.value) {
        return const Center(child: Loading());
      }

      if (controller.otherPaymentsError.value.isNotEmpty) {
        return ErrorMessage(
          press: () => controller.fetchOtherPayments(),
          errorMsg: controller.otherPaymentsError.value,
        );
      }

      if (controller.otherPaymentsData.isEmpty) {
        return NoDataWidget(title: AppLanguage.noInfoAvailable.tr);
      }

      return ListView.separated(
        padding: const .symmetric(horizontal: 16, vertical: 24),
        itemCount: controller.otherPaymentsData.length,
        itemBuilder: (_, i) =>
            OtherPaymentItem(otherPayment: controller.otherPaymentsData[i]),
        separatorBuilder: (_, _) => const SizedBox(height: 8),
      );
    });
  }
}

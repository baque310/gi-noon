import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_text_style.dart';
import '../../core/localization/language.dart';
import '../../models/installment_model.dart';

class InstallmentPaymentsScreen extends StatelessWidget {
  InstallmentPaymentsScreen({super.key});

  final payments = Get.arguments['payments'] as List<InstallmentPaymentModel>;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.payments.tr,
        isLeading: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemBuilder: (_, i) => PaymentItem(payment: payments[i]),
        separatorBuilder: (_, _) => const SizedBox(height: 8),
        itemCount: payments.length,
      ),
    );
  }
}

class PaymentItem extends StatelessWidget {
  const PaymentItem({super.key, required this.payment});

  final InstallmentPaymentModel payment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gray200Color, width: 0.5),
      ),
      child: Column(
        spacing: 6,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 12,
            children: [
              Text(
                '${AppLanguage.paymentNumber.tr} : ${payment.installmentNumber}',
                style: AppTextStyles.textSemiBold14,
              ),
              StatusChip(status: payment.isPaid),
            ],
          ),
          const Divider(
            thickness: 0.5,
            height: 0,
            color: AppColors.gray200Color,
          ),
          Text(
            '${AppLanguage.amount.tr} : ${_formattedAmount(payment.amount)}',
            style: AppTextStyles.textRegular14,
          ),
          Text(
            '${AppLanguage.paymentDeadline.tr} : $date',
            style: AppTextStyles.textRegular14,
          ),
        ],
      ),
    );
  }

  String get date => payment.dueDate.formatDateToYearMonthDay;

  String _formattedAmount(double amount) {
    return '${NumberFormat('#,###', 'en_US').format(amount.round())} ${AppLanguage.iqd.tr}';
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final (title, textColor, bgColor, borderColor) = _getChipStyle;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        title,
        style: AppTextStyles.textSemiBold10.copyWith(color: textColor),
      ),
    );
  }

  (String title, Color textColor, Color bgColor, Color borderColor)
  get _getChipStyle {
    if (status == 'paid') {
      return (
        AppLanguage.paid.tr,
        AppColors.mainColor,
        AppColors.green50,
        AppColors.mainColor,
      );
    } else {
      return (
        AppLanguage.unpaid.tr,
        AppColors.yellow500Color,
        AppColors.yellow50Color,
        AppColors.yellow500Color,
      );
    }
  }
}

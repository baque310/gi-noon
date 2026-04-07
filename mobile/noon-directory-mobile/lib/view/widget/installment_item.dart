import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/installment_model.dart';
import 'package:noon/view/widget/installment_card.dart';
import 'package:noon/view/widget/installment_total_tile.dart';

class InstallmentItem extends StatelessWidget {
  const InstallmentItem({super.key, required this.installment});

  final InstallmentModel installment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Summary tiles row
        Row(
          children: [
            Expanded(
              child: InstallmentTotalTile(
                title: AppLanguage.totalYearInstallment.tr,
                text: _formattedAmount(installment.finalTotalAmount),
                icon: AppAssets.icCalendar,
                color: AppColors.mainColor,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InstallmentTotalTile(
                title: AppLanguage.paid.tr,
                text: _formattedAmount(installment.totalPaid),
                icon: AppAssets.icTimer,
                color: AppColors.green600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Remaining amount card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: installment.remainingAmount > 0
                  ? [
                      const Color(0xFFFF6B35),
                      const Color(0xFFFF8E53),
                    ]
                  : [
                      AppColors.green600,
                      AppColors.green400,
                    ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLanguage.remainingStr.tr}:',
                style: AppTextStyles.semiBold14.copyWith(color: Colors.white),
              ),
              Text(
                _formattedAmount(
                    installment.remainingAmount > 0
                        ? installment.remainingAmount
                        : 0),
                style: AppTextStyles.bold16.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
        // Discount info
        if (installment.discountAmount > 0) ...[
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200, width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLanguage.discountStr.tr}:',
                  style: AppTextStyles.regular14.copyWith(
                    color: Colors.red.shade700,
                  ),
                ),
                Text(
                  '- ${_formattedAmount(installment.discountAmount)}',
                  style: AppTextStyles.bold14.copyWith(
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 16),
        // Payment history header
        if (installment.installmentPayments.isNotEmpty) ...[
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              '${AppLanguage.payments.tr} (${installment.paymentsMade}/${installment.installmentPayments.length})',
              style: AppTextStyles.bold14,
            ),
          ),
          const SizedBox(height: 8),
        ],
        // Payment cards
        ...installment.installmentPayments.map(
          (e) => InstallmentCard(
            isPaid: e.isPaid.toLowerCase() == 'paid',
            title:
                '${AppLanguage.installment.tr} ${e.installmentNumber}',
            date: e.paidDate?.formatDateToYearMonthDay ??
                e.dueDate.formatDateToYearMonthDay,
            amount: _formattedAmount(e.amount),
          ),
        ),
        // No payments yet message
        if (installment.installmentPayments.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.payment_outlined,
                    size: 40, color: Colors.grey.shade400),
                const SizedBox(height: 8),
                Text(
                  AppLanguage.noInfoAvailable.tr,
                  style: AppTextStyles.regular14.copyWith(
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _formattedAmount(double amount) {
    return '${NumberFormat('#,###', 'en_US').format(amount.round())} ${AppLanguage.iqd.tr}';
  }
}

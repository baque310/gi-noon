import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/other_installment_model.dart';
import 'package:noon/view/widget/installment_card.dart';

class OtherPaymentItem extends StatelessWidget {
  const OtherPaymentItem({super.key, required this.otherPayment});

  final OtherInstallmentModel otherPayment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...otherPayment.payments.map(
          (payment) => InstallmentCard(
            isPaid: payment.paymentStatus.toLowerCase() == 'paid',
            title: payment.title,
            date: payment.createdAt.formatDateToYearMonthDay,
            amount: _formattedAmount(payment.amount),
          ),
        ),
      ],
    );
  }

  String _formattedAmount(double amount) {
    final formatter = NumberFormat('#,###', 'en_US');
    return '${formatter.format(amount)} ${AppLanguage.iqd.tr}';
  }
}

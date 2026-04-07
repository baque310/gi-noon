import 'dart:convert';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'installment_model.g.dart';

abstract class InstallmentModel
    implements Built<InstallmentModel, InstallmentModelBuilder> {
  String get id;

  String get title;

  int? get numberOfInstallments;

  double get totalAmount;

  double? get installmentAmount;

  double get discountAmount;

  double get finalTotalAmount;

  // bool get isActive;

  String? get notes;

  DateTime get createdAt;

  String get studentEnrollmentId;

  String get schoolYearId;

  String get schoolId;

  String? get discountId;

  int? get daysBetweenInstallments;

  DateTime? get startDate;

  double? get outstandingAmount;

  @BuiltValueField(wireName: 'InstallmentPayments')
  BuiltList<InstallmentPaymentModel> get installmentPayments;

  InstallmentModel._();

  factory InstallmentModel([void Function(InstallmentModelBuilder) updates]) =
      _$InstallmentModel;

  static Serializer<InstallmentModel> get serializer =>
      _$installmentModelSerializer;

  factory InstallmentModel.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(InstallmentModel.serializer, json)!;
  }

  String toJson() {
    return json.encode(
      serializers.serializeWith(InstallmentModel.serializer, this),
    );
  }

  /// Total amount paid by the student
  double get totalPaid {
    double sum = 0;
    for (final p in installmentPayments) {
      if (p.isPaid.toLowerCase() == 'paid' ||
          p.isPaid.toLowerCase() == 'partial') {
        sum += p.amount;
      }
    }
    return sum;
  }

  /// Remaining amount to be paid
  double get remainingAmount {
    return finalTotalAmount - totalPaid;
  }

  /// Number of payments made
  int get paymentsMade {
    return installmentPayments
        .where((p) =>
            p.isPaid.toLowerCase() == 'paid' ||
            p.isPaid.toLowerCase() == 'partial')
        .length;
  }
}

abstract class InstallmentPaymentModel
    implements Built<InstallmentPaymentModel, InstallmentPaymentModelBuilder> {
  String get id;

  int get installmentNumber;

  double get amount;

  DateTime get dueDate;

  DateTime? get paidDate;

  String get isPaid;

  String get paymentMethod;

  String? get notes;

  DateTime get createdAt;

  String get installmentId;

  String get schoolId;

  InstallmentPaymentModel._();

  factory InstallmentPaymentModel([
    void Function(InstallmentPaymentModelBuilder) updates,
  ]) = _$InstallmentPaymentModel;

  static Serializer<InstallmentPaymentModel> get serializer =>
      _$installmentPaymentModelSerializer;

  factory InstallmentPaymentModel.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(
      InstallmentPaymentModel.serializer,
      json,
    )!;
  }

  String toJson() {
    return json.encode(
      serializers.serializeWith(InstallmentPaymentModel.serializer, this),
    );
  }
}

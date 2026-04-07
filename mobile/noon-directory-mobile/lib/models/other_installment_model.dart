import 'dart:convert';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'other_installment_model.g.dart';

abstract class OtherInstallmentModel
    implements Built<OtherInstallmentModel, OtherInstallmentModelBuilder> {
  OtherInstallmentModel._();

  String get enrollmentId;

  @BuiltValueField(wireName: 'payments')
  BuiltList<PaymentModel> get payments;

  factory OtherInstallmentModel([
    void Function(OtherInstallmentModelBuilder)? updates,
  ]) = _$OtherInstallmentModel;

  static Serializer<OtherInstallmentModel> get serializer =>
      _$otherInstallmentModelSerializer;

  factory OtherInstallmentModel.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(OtherInstallmentModel.serializer, json)!;
  }

  String toJson() {
    return json.encode(
      serializers.serializeWith(OtherInstallmentModel.serializer, this),
    );
  }
}

abstract class PaymentModel
    implements Built<PaymentModel, PaymentModelBuilder> {
  PaymentModel._();

  String get id;
  String get title;
  double get amount;
  DateTime? get paidDate;
  String get paymentStatus;
  String get paymentMethod;
  String? get notes;
  DateTime get createdAt;
  DateTime get updatedAt;
  String get studentEnrollmentId;
  String get schoolYearId;
  String get schoolId;
  String? get discountId;
  int? get discount;

  factory PaymentModel([void Function(PaymentModelBuilder)? updates]) =
      _$PaymentModel;

  static Serializer<PaymentModel> get serializer => _$paymentModelSerializer;

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(PaymentModel.serializer, json)!;
  }

  String toJson() {
    return json.encode(
      serializers.serializeWith(PaymentModel.serializer, this),
    );
  }
}

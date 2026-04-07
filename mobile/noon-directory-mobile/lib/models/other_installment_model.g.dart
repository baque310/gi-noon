// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_installment_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<OtherInstallmentModel> _$otherInstallmentModelSerializer =
    _$OtherInstallmentModelSerializer();
Serializer<PaymentModel> _$paymentModelSerializer = _$PaymentModelSerializer();

class _$OtherInstallmentModelSerializer
    implements StructuredSerializer<OtherInstallmentModel> {
  @override
  final Iterable<Type> types = const [
    OtherInstallmentModel,
    _$OtherInstallmentModel,
  ];
  @override
  final String wireName = 'OtherInstallmentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    OtherInstallmentModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'enrollmentId',
      serializers.serialize(
        object.enrollmentId,
        specifiedType: const FullType(String),
      ),
      'payments',
      serializers.serialize(
        object.payments,
        specifiedType: const FullType(BuiltList, const [
          const FullType(PaymentModel),
        ]),
      ),
    ];

    return result;
  }

  @override
  OtherInstallmentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = OtherInstallmentModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'enrollmentId':
          result.enrollmentId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'payments':
          result.payments.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(PaymentModel),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$PaymentModelSerializer implements StructuredSerializer<PaymentModel> {
  @override
  final Iterable<Type> types = const [PaymentModel, _$PaymentModel];
  @override
  final String wireName = 'PaymentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    PaymentModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      ),
      'amount',
      serializers.serialize(
        object.amount,
        specifiedType: const FullType(double),
      ),
      'paymentStatus',
      serializers.serialize(
        object.paymentStatus,
        specifiedType: const FullType(String),
      ),
      'paymentMethod',
      serializers.serialize(
        object.paymentMethod,
        specifiedType: const FullType(String),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
      ),
      'studentEnrollmentId',
      serializers.serialize(
        object.studentEnrollmentId,
        specifiedType: const FullType(String),
      ),
      'schoolYearId',
      serializers.serialize(
        object.schoolYearId,
        specifiedType: const FullType(String),
      ),
      'schoolId',
      serializers.serialize(
        object.schoolId,
        specifiedType: const FullType(String),
      ),
    ];
    Object? value;
    value = object.paidDate;
    if (value != null) {
      result
        ..add('paidDate')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.notes;
    if (value != null) {
      result
        ..add('notes')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.discountId;
    if (value != null) {
      result
        ..add('discountId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.discount;
    if (value != null) {
      result
        ..add('discount')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  PaymentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PaymentModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'title':
          result.title =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'amount':
          result.amount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )!
                  as double;
          break;
        case 'paidDate':
          result.paidDate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'paymentStatus':
          result.paymentStatus =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'paymentMethod':
          result.paymentMethod =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'notes':
          result.notes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'createdAt':
          result.createdAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'updatedAt':
          result.updatedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'studentEnrollmentId':
          result.studentEnrollmentId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'schoolYearId':
          result.schoolYearId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'schoolId':
          result.schoolId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'discountId':
          result.discountId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'discount':
          result.discount =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
      }
    }

    return result.build();
  }
}

class _$OtherInstallmentModel extends OtherInstallmentModel {
  @override
  final String enrollmentId;
  @override
  final BuiltList<PaymentModel> payments;

  factory _$OtherInstallmentModel([
    void Function(OtherInstallmentModelBuilder)? updates,
  ]) => (OtherInstallmentModelBuilder()..update(updates))._build();

  _$OtherInstallmentModel._({
    required this.enrollmentId,
    required this.payments,
  }) : super._();
  @override
  OtherInstallmentModel rebuild(
    void Function(OtherInstallmentModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  OtherInstallmentModelBuilder toBuilder() =>
      OtherInstallmentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is OtherInstallmentModel &&
        enrollmentId == other.enrollmentId &&
        payments == other.payments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, enrollmentId.hashCode);
    _$hash = $jc(_$hash, payments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'OtherInstallmentModel')
          ..add('enrollmentId', enrollmentId)
          ..add('payments', payments))
        .toString();
  }
}

class OtherInstallmentModelBuilder
    implements Builder<OtherInstallmentModel, OtherInstallmentModelBuilder> {
  _$OtherInstallmentModel? _$v;

  String? _enrollmentId;
  String? get enrollmentId => _$this._enrollmentId;
  set enrollmentId(String? enrollmentId) => _$this._enrollmentId = enrollmentId;

  ListBuilder<PaymentModel>? _payments;
  ListBuilder<PaymentModel> get payments =>
      _$this._payments ??= ListBuilder<PaymentModel>();
  set payments(ListBuilder<PaymentModel>? payments) =>
      _$this._payments = payments;

  OtherInstallmentModelBuilder();

  OtherInstallmentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _enrollmentId = $v.enrollmentId;
      _payments = $v.payments.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(OtherInstallmentModel other) {
    _$v = other as _$OtherInstallmentModel;
  }

  @override
  void update(void Function(OtherInstallmentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  OtherInstallmentModel build() => _build();

  _$OtherInstallmentModel _build() {
    _$OtherInstallmentModel _$result;
    try {
      _$result =
          _$v ??
          _$OtherInstallmentModel._(
            enrollmentId: BuiltValueNullFieldError.checkNotNull(
              enrollmentId,
              r'OtherInstallmentModel',
              'enrollmentId',
            ),
            payments: payments.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'payments';
        payments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'OtherInstallmentModel',
          _$failedField,
          e.toString(),
        );
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$PaymentModel extends PaymentModel {
  @override
  final String id;
  @override
  final String title;
  @override
  final double amount;
  @override
  final DateTime? paidDate;
  @override
  final String paymentStatus;
  @override
  final String paymentMethod;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String studentEnrollmentId;
  @override
  final String schoolYearId;
  @override
  final String schoolId;
  @override
  final String? discountId;
  @override
  final int? discount;

  factory _$PaymentModel([void Function(PaymentModelBuilder)? updates]) =>
      (PaymentModelBuilder()..update(updates))._build();

  _$PaymentModel._({
    required this.id,
    required this.title,
    required this.amount,
    this.paidDate,
    required this.paymentStatus,
    required this.paymentMethod,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.studentEnrollmentId,
    required this.schoolYearId,
    required this.schoolId,
    this.discountId,
    this.discount,
  }) : super._();
  @override
  PaymentModel rebuild(void Function(PaymentModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PaymentModelBuilder toBuilder() => PaymentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PaymentModel &&
        id == other.id &&
        title == other.title &&
        amount == other.amount &&
        paidDate == other.paidDate &&
        paymentStatus == other.paymentStatus &&
        paymentMethod == other.paymentMethod &&
        notes == other.notes &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        studentEnrollmentId == other.studentEnrollmentId &&
        schoolYearId == other.schoolYearId &&
        schoolId == other.schoolId &&
        discountId == other.discountId &&
        discount == other.discount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, paidDate.hashCode);
    _$hash = $jc(_$hash, paymentStatus.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, studentEnrollmentId.hashCode);
    _$hash = $jc(_$hash, schoolYearId.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, discountId.hashCode);
    _$hash = $jc(_$hash, discount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PaymentModel')
          ..add('id', id)
          ..add('title', title)
          ..add('amount', amount)
          ..add('paidDate', paidDate)
          ..add('paymentStatus', paymentStatus)
          ..add('paymentMethod', paymentMethod)
          ..add('notes', notes)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('studentEnrollmentId', studentEnrollmentId)
          ..add('schoolYearId', schoolYearId)
          ..add('schoolId', schoolId)
          ..add('discountId', discountId)
          ..add('discount', discount))
        .toString();
  }
}

class PaymentModelBuilder
    implements Builder<PaymentModel, PaymentModelBuilder> {
  _$PaymentModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  DateTime? _paidDate;
  DateTime? get paidDate => _$this._paidDate;
  set paidDate(DateTime? paidDate) => _$this._paidDate = paidDate;

  String? _paymentStatus;
  String? get paymentStatus => _$this._paymentStatus;
  set paymentStatus(String? paymentStatus) =>
      _$this._paymentStatus = paymentStatus;

  String? _paymentMethod;
  String? get paymentMethod => _$this._paymentMethod;
  set paymentMethod(String? paymentMethod) =>
      _$this._paymentMethod = paymentMethod;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _studentEnrollmentId;
  String? get studentEnrollmentId => _$this._studentEnrollmentId;
  set studentEnrollmentId(String? studentEnrollmentId) =>
      _$this._studentEnrollmentId = studentEnrollmentId;

  String? _schoolYearId;
  String? get schoolYearId => _$this._schoolYearId;
  set schoolYearId(String? schoolYearId) => _$this._schoolYearId = schoolYearId;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  String? _discountId;
  String? get discountId => _$this._discountId;
  set discountId(String? discountId) => _$this._discountId = discountId;

  int? _discount;
  int? get discount => _$this._discount;
  set discount(int? discount) => _$this._discount = discount;

  PaymentModelBuilder();

  PaymentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _amount = $v.amount;
      _paidDate = $v.paidDate;
      _paymentStatus = $v.paymentStatus;
      _paymentMethod = $v.paymentMethod;
      _notes = $v.notes;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _studentEnrollmentId = $v.studentEnrollmentId;
      _schoolYearId = $v.schoolYearId;
      _schoolId = $v.schoolId;
      _discountId = $v.discountId;
      _discount = $v.discount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PaymentModel other) {
    _$v = other as _$PaymentModel;
  }

  @override
  void update(void Function(PaymentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PaymentModel build() => _build();

  _$PaymentModel _build() {
    final _$result =
        _$v ??
        _$PaymentModel._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'PaymentModel', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'PaymentModel',
            'title',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'PaymentModel',
            'amount',
          ),
          paidDate: paidDate,
          paymentStatus: BuiltValueNullFieldError.checkNotNull(
            paymentStatus,
            r'PaymentModel',
            'paymentStatus',
          ),
          paymentMethod: BuiltValueNullFieldError.checkNotNull(
            paymentMethod,
            r'PaymentModel',
            'paymentMethod',
          ),
          notes: notes,
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'PaymentModel',
            'createdAt',
          ),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
            updatedAt,
            r'PaymentModel',
            'updatedAt',
          ),
          studentEnrollmentId: BuiltValueNullFieldError.checkNotNull(
            studentEnrollmentId,
            r'PaymentModel',
            'studentEnrollmentId',
          ),
          schoolYearId: BuiltValueNullFieldError.checkNotNull(
            schoolYearId,
            r'PaymentModel',
            'schoolYearId',
          ),
          schoolId: BuiltValueNullFieldError.checkNotNull(
            schoolId,
            r'PaymentModel',
            'schoolId',
          ),
          discountId: discountId,
          discount: discount,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

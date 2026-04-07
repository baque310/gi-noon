// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'installment_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<InstallmentModel> _$installmentModelSerializer =
    _$InstallmentModelSerializer();
Serializer<InstallmentPaymentModel> _$installmentPaymentModelSerializer =
    _$InstallmentPaymentModelSerializer();

class _$InstallmentModelSerializer
    implements StructuredSerializer<InstallmentModel> {
  @override
  final Iterable<Type> types = const [InstallmentModel, _$InstallmentModel];
  @override
  final String wireName = 'InstallmentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    InstallmentModel object, {
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
      'totalAmount',
      serializers.serialize(
        object.totalAmount,
        specifiedType: const FullType(double),
      ),
      'discountAmount',
      serializers.serialize(
        object.discountAmount,
        specifiedType: const FullType(double),
      ),
      'finalTotalAmount',
      serializers.serialize(
        object.finalTotalAmount,
        specifiedType: const FullType(double),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
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
      'InstallmentPayments',
      serializers.serialize(
        object.installmentPayments,
        specifiedType: const FullType(BuiltList, const [
          const FullType(InstallmentPaymentModel),
        ]),
      ),
    ];
    Object? value;
    value = object.numberOfInstallments;
    if (value != null) {
      result
        ..add('numberOfInstallments')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.installmentAmount;
    if (value != null) {
      result
        ..add('installmentAmount')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(double)),
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
    value = object.daysBetweenInstallments;
    if (value != null) {
      result
        ..add('daysBetweenInstallments')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.startDate;
    if (value != null) {
      result
        ..add('startDate')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.outstandingAmount;
    if (value != null) {
      result
        ..add('outstandingAmount')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(double)),
        );
    }
    return result;
  }

  @override
  InstallmentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InstallmentModelBuilder();

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
        case 'numberOfInstallments':
          result.numberOfInstallments =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'totalAmount':
          result.totalAmount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )!
                  as double;
          break;
        case 'installmentAmount':
          result.installmentAmount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double?;
          break;
        case 'discountAmount':
          result.discountAmount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )!
                  as double;
          break;
        case 'finalTotalAmount':
          result.finalTotalAmount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )!
                  as double;
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
        case 'daysBetweenInstallments':
          result.daysBetweenInstallments =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'startDate':
          result.startDate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'outstandingAmount':
          result.outstandingAmount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double?;
          break;
        case 'InstallmentPayments':
          result.installmentPayments.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(InstallmentPaymentModel),
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

class _$InstallmentPaymentModelSerializer
    implements StructuredSerializer<InstallmentPaymentModel> {
  @override
  final Iterable<Type> types = const [
    InstallmentPaymentModel,
    _$InstallmentPaymentModel,
  ];
  @override
  final String wireName = 'InstallmentPaymentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    InstallmentPaymentModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'installmentNumber',
      serializers.serialize(
        object.installmentNumber,
        specifiedType: const FullType(int),
      ),
      'amount',
      serializers.serialize(
        object.amount,
        specifiedType: const FullType(double),
      ),
      'dueDate',
      serializers.serialize(
        object.dueDate,
        specifiedType: const FullType(DateTime),
      ),
      'isPaid',
      serializers.serialize(
        object.isPaid,
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
      'installmentId',
      serializers.serialize(
        object.installmentId,
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
    return result;
  }

  @override
  InstallmentPaymentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InstallmentPaymentModelBuilder();

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
        case 'installmentNumber':
          result.installmentNumber =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'amount':
          result.amount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )!
                  as double;
          break;
        case 'dueDate':
          result.dueDate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'paidDate':
          result.paidDate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'isPaid':
          result.isPaid =
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
        case 'installmentId':
          result.installmentId =
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
      }
    }

    return result.build();
  }
}

class _$InstallmentModel extends InstallmentModel {
  @override
  final String id;
  @override
  final String title;
  @override
  final int? numberOfInstallments;
  @override
  final double totalAmount;
  @override
  final double? installmentAmount;
  @override
  final double discountAmount;
  @override
  final double finalTotalAmount;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final String studentEnrollmentId;
  @override
  final String schoolYearId;
  @override
  final String schoolId;
  @override
  final String? discountId;
  @override
  final int? daysBetweenInstallments;
  @override
  final DateTime? startDate;
  @override
  final double? outstandingAmount;
  @override
  final BuiltList<InstallmentPaymentModel> installmentPayments;

  factory _$InstallmentModel([
    void Function(InstallmentModelBuilder)? updates,
  ]) => (InstallmentModelBuilder()..update(updates))._build();

  _$InstallmentModel._({
    required this.id,
    required this.title,
    this.numberOfInstallments,
    required this.totalAmount,
    this.installmentAmount,
    required this.discountAmount,
    required this.finalTotalAmount,
    this.notes,
    required this.createdAt,
    required this.studentEnrollmentId,
    required this.schoolYearId,
    required this.schoolId,
    this.discountId,
    this.daysBetweenInstallments,
    this.startDate,
    this.outstandingAmount,
    required this.installmentPayments,
  }) : super._();
  @override
  InstallmentModel rebuild(void Function(InstallmentModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InstallmentModelBuilder toBuilder() =>
      InstallmentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InstallmentModel &&
        id == other.id &&
        title == other.title &&
        numberOfInstallments == other.numberOfInstallments &&
        totalAmount == other.totalAmount &&
        installmentAmount == other.installmentAmount &&
        discountAmount == other.discountAmount &&
        finalTotalAmount == other.finalTotalAmount &&
        notes == other.notes &&
        createdAt == other.createdAt &&
        studentEnrollmentId == other.studentEnrollmentId &&
        schoolYearId == other.schoolYearId &&
        schoolId == other.schoolId &&
        discountId == other.discountId &&
        daysBetweenInstallments == other.daysBetweenInstallments &&
        startDate == other.startDate &&
        outstandingAmount == other.outstandingAmount &&
        installmentPayments == other.installmentPayments;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, numberOfInstallments.hashCode);
    _$hash = $jc(_$hash, totalAmount.hashCode);
    _$hash = $jc(_$hash, installmentAmount.hashCode);
    _$hash = $jc(_$hash, discountAmount.hashCode);
    _$hash = $jc(_$hash, finalTotalAmount.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, studentEnrollmentId.hashCode);
    _$hash = $jc(_$hash, schoolYearId.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, discountId.hashCode);
    _$hash = $jc(_$hash, daysBetweenInstallments.hashCode);
    _$hash = $jc(_$hash, startDate.hashCode);
    _$hash = $jc(_$hash, outstandingAmount.hashCode);
    _$hash = $jc(_$hash, installmentPayments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InstallmentModel')
          ..add('id', id)
          ..add('title', title)
          ..add('numberOfInstallments', numberOfInstallments)
          ..add('totalAmount', totalAmount)
          ..add('installmentAmount', installmentAmount)
          ..add('discountAmount', discountAmount)
          ..add('finalTotalAmount', finalTotalAmount)
          ..add('notes', notes)
          ..add('createdAt', createdAt)
          ..add('studentEnrollmentId', studentEnrollmentId)
          ..add('schoolYearId', schoolYearId)
          ..add('schoolId', schoolId)
          ..add('discountId', discountId)
          ..add('daysBetweenInstallments', daysBetweenInstallments)
          ..add('startDate', startDate)
          ..add('outstandingAmount', outstandingAmount)
          ..add('installmentPayments', installmentPayments))
        .toString();
  }
}

class InstallmentModelBuilder
    implements Builder<InstallmentModel, InstallmentModelBuilder> {
  _$InstallmentModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  int? _numberOfInstallments;
  int? get numberOfInstallments => _$this._numberOfInstallments;
  set numberOfInstallments(int? numberOfInstallments) =>
      _$this._numberOfInstallments = numberOfInstallments;

  double? _totalAmount;
  double? get totalAmount => _$this._totalAmount;
  set totalAmount(double? totalAmount) => _$this._totalAmount = totalAmount;

  double? _installmentAmount;
  double? get installmentAmount => _$this._installmentAmount;
  set installmentAmount(double? installmentAmount) =>
      _$this._installmentAmount = installmentAmount;

  double? _discountAmount;
  double? get discountAmount => _$this._discountAmount;
  set discountAmount(double? discountAmount) =>
      _$this._discountAmount = discountAmount;

  double? _finalTotalAmount;
  double? get finalTotalAmount => _$this._finalTotalAmount;
  set finalTotalAmount(double? finalTotalAmount) =>
      _$this._finalTotalAmount = finalTotalAmount;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

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

  int? _daysBetweenInstallments;
  int? get daysBetweenInstallments => _$this._daysBetweenInstallments;
  set daysBetweenInstallments(int? daysBetweenInstallments) =>
      _$this._daysBetweenInstallments = daysBetweenInstallments;

  DateTime? _startDate;
  DateTime? get startDate => _$this._startDate;
  set startDate(DateTime? startDate) => _$this._startDate = startDate;

  double? _outstandingAmount;
  double? get outstandingAmount => _$this._outstandingAmount;
  set outstandingAmount(double? outstandingAmount) =>
      _$this._outstandingAmount = outstandingAmount;

  ListBuilder<InstallmentPaymentModel>? _installmentPayments;
  ListBuilder<InstallmentPaymentModel> get installmentPayments =>
      _$this._installmentPayments ??= ListBuilder<InstallmentPaymentModel>();
  set installmentPayments(
    ListBuilder<InstallmentPaymentModel>? installmentPayments,
  ) => _$this._installmentPayments = installmentPayments;

  InstallmentModelBuilder();

  InstallmentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _numberOfInstallments = $v.numberOfInstallments;
      _totalAmount = $v.totalAmount;
      _installmentAmount = $v.installmentAmount;
      _discountAmount = $v.discountAmount;
      _finalTotalAmount = $v.finalTotalAmount;
      _notes = $v.notes;
      _createdAt = $v.createdAt;
      _studentEnrollmentId = $v.studentEnrollmentId;
      _schoolYearId = $v.schoolYearId;
      _schoolId = $v.schoolId;
      _discountId = $v.discountId;
      _daysBetweenInstallments = $v.daysBetweenInstallments;
      _startDate = $v.startDate;
      _outstandingAmount = $v.outstandingAmount;
      _installmentPayments = $v.installmentPayments.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InstallmentModel other) {
    _$v = other as _$InstallmentModel;
  }

  @override
  void update(void Function(InstallmentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InstallmentModel build() => _build();

  _$InstallmentModel _build() {
    _$InstallmentModel _$result;
    try {
      _$result =
          _$v ??
          _$InstallmentModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'InstallmentModel',
              'id',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'InstallmentModel',
              'title',
            ),
            numberOfInstallments: numberOfInstallments,
            totalAmount: BuiltValueNullFieldError.checkNotNull(
              totalAmount,
              r'InstallmentModel',
              'totalAmount',
            ),
            installmentAmount: installmentAmount,
            discountAmount: BuiltValueNullFieldError.checkNotNull(
              discountAmount,
              r'InstallmentModel',
              'discountAmount',
            ),
            finalTotalAmount: BuiltValueNullFieldError.checkNotNull(
              finalTotalAmount,
              r'InstallmentModel',
              'finalTotalAmount',
            ),
            notes: notes,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'InstallmentModel',
              'createdAt',
            ),
            studentEnrollmentId: BuiltValueNullFieldError.checkNotNull(
              studentEnrollmentId,
              r'InstallmentModel',
              'studentEnrollmentId',
            ),
            schoolYearId: BuiltValueNullFieldError.checkNotNull(
              schoolYearId,
              r'InstallmentModel',
              'schoolYearId',
            ),
            schoolId: BuiltValueNullFieldError.checkNotNull(
              schoolId,
              r'InstallmentModel',
              'schoolId',
            ),
            discountId: discountId,
            daysBetweenInstallments: daysBetweenInstallments,
            startDate: startDate,
            outstandingAmount: outstandingAmount,
            installmentPayments: installmentPayments.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'installmentPayments';
        installmentPayments.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'InstallmentModel',
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

class _$InstallmentPaymentModel extends InstallmentPaymentModel {
  @override
  final String id;
  @override
  final int installmentNumber;
  @override
  final double amount;
  @override
  final DateTime dueDate;
  @override
  final DateTime? paidDate;
  @override
  final String isPaid;
  @override
  final String paymentMethod;
  @override
  final String? notes;
  @override
  final DateTime createdAt;
  @override
  final String installmentId;
  @override
  final String schoolId;

  factory _$InstallmentPaymentModel([
    void Function(InstallmentPaymentModelBuilder)? updates,
  ]) => (InstallmentPaymentModelBuilder()..update(updates))._build();

  _$InstallmentPaymentModel._({
    required this.id,
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
    this.paidDate,
    required this.isPaid,
    required this.paymentMethod,
    this.notes,
    required this.createdAt,
    required this.installmentId,
    required this.schoolId,
  }) : super._();
  @override
  InstallmentPaymentModel rebuild(
    void Function(InstallmentPaymentModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  InstallmentPaymentModelBuilder toBuilder() =>
      InstallmentPaymentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InstallmentPaymentModel &&
        id == other.id &&
        installmentNumber == other.installmentNumber &&
        amount == other.amount &&
        dueDate == other.dueDate &&
        paidDate == other.paidDate &&
        isPaid == other.isPaid &&
        paymentMethod == other.paymentMethod &&
        notes == other.notes &&
        createdAt == other.createdAt &&
        installmentId == other.installmentId &&
        schoolId == other.schoolId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, installmentNumber.hashCode);
    _$hash = $jc(_$hash, amount.hashCode);
    _$hash = $jc(_$hash, dueDate.hashCode);
    _$hash = $jc(_$hash, paidDate.hashCode);
    _$hash = $jc(_$hash, isPaid.hashCode);
    _$hash = $jc(_$hash, paymentMethod.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, installmentId.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InstallmentPaymentModel')
          ..add('id', id)
          ..add('installmentNumber', installmentNumber)
          ..add('amount', amount)
          ..add('dueDate', dueDate)
          ..add('paidDate', paidDate)
          ..add('isPaid', isPaid)
          ..add('paymentMethod', paymentMethod)
          ..add('notes', notes)
          ..add('createdAt', createdAt)
          ..add('installmentId', installmentId)
          ..add('schoolId', schoolId))
        .toString();
  }
}

class InstallmentPaymentModelBuilder
    implements
        Builder<InstallmentPaymentModel, InstallmentPaymentModelBuilder> {
  _$InstallmentPaymentModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _installmentNumber;
  int? get installmentNumber => _$this._installmentNumber;
  set installmentNumber(int? installmentNumber) =>
      _$this._installmentNumber = installmentNumber;

  double? _amount;
  double? get amount => _$this._amount;
  set amount(double? amount) => _$this._amount = amount;

  DateTime? _dueDate;
  DateTime? get dueDate => _$this._dueDate;
  set dueDate(DateTime? dueDate) => _$this._dueDate = dueDate;

  DateTime? _paidDate;
  DateTime? get paidDate => _$this._paidDate;
  set paidDate(DateTime? paidDate) => _$this._paidDate = paidDate;

  String? _isPaid;
  String? get isPaid => _$this._isPaid;
  set isPaid(String? isPaid) => _$this._isPaid = isPaid;

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

  String? _installmentId;
  String? get installmentId => _$this._installmentId;
  set installmentId(String? installmentId) =>
      _$this._installmentId = installmentId;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  InstallmentPaymentModelBuilder();

  InstallmentPaymentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _installmentNumber = $v.installmentNumber;
      _amount = $v.amount;
      _dueDate = $v.dueDate;
      _paidDate = $v.paidDate;
      _isPaid = $v.isPaid;
      _paymentMethod = $v.paymentMethod;
      _notes = $v.notes;
      _createdAt = $v.createdAt;
      _installmentId = $v.installmentId;
      _schoolId = $v.schoolId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InstallmentPaymentModel other) {
    _$v = other as _$InstallmentPaymentModel;
  }

  @override
  void update(void Function(InstallmentPaymentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InstallmentPaymentModel build() => _build();

  _$InstallmentPaymentModel _build() {
    final _$result =
        _$v ??
        _$InstallmentPaymentModel._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'InstallmentPaymentModel',
            'id',
          ),
          installmentNumber: BuiltValueNullFieldError.checkNotNull(
            installmentNumber,
            r'InstallmentPaymentModel',
            'installmentNumber',
          ),
          amount: BuiltValueNullFieldError.checkNotNull(
            amount,
            r'InstallmentPaymentModel',
            'amount',
          ),
          dueDate: BuiltValueNullFieldError.checkNotNull(
            dueDate,
            r'InstallmentPaymentModel',
            'dueDate',
          ),
          paidDate: paidDate,
          isPaid: BuiltValueNullFieldError.checkNotNull(
            isPaid,
            r'InstallmentPaymentModel',
            'isPaid',
          ),
          paymentMethod: BuiltValueNullFieldError.checkNotNull(
            paymentMethod,
            r'InstallmentPaymentModel',
            'paymentMethod',
          ),
          notes: notes,
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'InstallmentPaymentModel',
            'createdAt',
          ),
          installmentId: BuiltValueNullFieldError.checkNotNull(
            installmentId,
            r'InstallmentPaymentModel',
            'installmentId',
          ),
          schoolId: BuiltValueNullFieldError.checkNotNull(
            schoolId,
            r'InstallmentPaymentModel',
            'schoolId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

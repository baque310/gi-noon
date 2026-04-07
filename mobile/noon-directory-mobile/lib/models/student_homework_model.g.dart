// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_homework_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StudentHomeworkModel> _$studentHomeworkModelSerializer =
    _$StudentHomeworkModelSerializer();

class _$StudentHomeworkModelSerializer
    implements StructuredSerializer<StudentHomeworkModel> {
  @override
  final Iterable<Type> types = const [
    StudentHomeworkModel,
    _$StudentHomeworkModel,
  ];
  @override
  final String wireName = 'StudentHomeworkModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    StudentHomeworkModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'HomeworkStatus',
      serializers.serialize(
        object.homeworkStatus,
        specifiedType: const FullType(String),
      ),
    ];
    Object? value;
    value = object.completedAt;
    if (value != null) {
      result
        ..add('completedAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.studentId;
    if (value != null) {
      result
        ..add('studentId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.homeworkId;
    if (value != null) {
      result
        ..add('homeworkId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  StudentHomeworkModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StudentHomeworkModelBuilder();

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
        case 'HomeworkStatus':
          result.homeworkStatus =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'completedAt':
          result.completedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'studentId':
          result.studentId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'homeworkId':
          result.homeworkId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
      }
    }

    return result.build();
  }
}

class _$StudentHomeworkModel extends StudentHomeworkModel {
  @override
  final String id;
  @override
  final String homeworkStatus;
  @override
  final DateTime? completedAt;
  @override
  final String? studentId;
  @override
  final String? homeworkId;

  factory _$StudentHomeworkModel([
    void Function(StudentHomeworkModelBuilder)? updates,
  ]) => (StudentHomeworkModelBuilder()..update(updates))._build();

  _$StudentHomeworkModel._({
    required this.id,
    required this.homeworkStatus,
    this.completedAt,
    this.studentId,
    this.homeworkId,
  }) : super._();
  @override
  StudentHomeworkModel rebuild(
    void Function(StudentHomeworkModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  StudentHomeworkModelBuilder toBuilder() =>
      StudentHomeworkModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StudentHomeworkModel &&
        id == other.id &&
        homeworkStatus == other.homeworkStatus &&
        completedAt == other.completedAt &&
        studentId == other.studentId &&
        homeworkId == other.homeworkId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, homeworkStatus.hashCode);
    _$hash = $jc(_$hash, completedAt.hashCode);
    _$hash = $jc(_$hash, studentId.hashCode);
    _$hash = $jc(_$hash, homeworkId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StudentHomeworkModel')
          ..add('id', id)
          ..add('homeworkStatus', homeworkStatus)
          ..add('completedAt', completedAt)
          ..add('studentId', studentId)
          ..add('homeworkId', homeworkId))
        .toString();
  }
}

class StudentHomeworkModelBuilder
    implements Builder<StudentHomeworkModel, StudentHomeworkModelBuilder> {
  _$StudentHomeworkModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _homeworkStatus;
  String? get homeworkStatus => _$this._homeworkStatus;
  set homeworkStatus(String? homeworkStatus) =>
      _$this._homeworkStatus = homeworkStatus;

  DateTime? _completedAt;
  DateTime? get completedAt => _$this._completedAt;
  set completedAt(DateTime? completedAt) => _$this._completedAt = completedAt;

  String? _studentId;
  String? get studentId => _$this._studentId;
  set studentId(String? studentId) => _$this._studentId = studentId;

  String? _homeworkId;
  String? get homeworkId => _$this._homeworkId;
  set homeworkId(String? homeworkId) => _$this._homeworkId = homeworkId;

  StudentHomeworkModelBuilder();

  StudentHomeworkModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _homeworkStatus = $v.homeworkStatus;
      _completedAt = $v.completedAt;
      _studentId = $v.studentId;
      _homeworkId = $v.homeworkId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StudentHomeworkModel other) {
    _$v = other as _$StudentHomeworkModel;
  }

  @override
  void update(void Function(StudentHomeworkModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StudentHomeworkModel build() => _build();

  _$StudentHomeworkModel _build() {
    final _$result =
        _$v ??
        _$StudentHomeworkModel._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'StudentHomeworkModel',
            'id',
          ),
          homeworkStatus: BuiltValueNullFieldError.checkNotNull(
            homeworkStatus,
            r'StudentHomeworkModel',
            'homeworkStatus',
          ),
          completedAt: completedAt,
          studentId: studentId,
          homeworkId: homeworkId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

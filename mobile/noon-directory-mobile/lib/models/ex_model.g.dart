// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ex_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ExModel> _$exModelSerializer = _$ExModelSerializer();

class _$ExModelSerializer implements StructuredSerializer<ExModel> {
  @override
  final Iterable<Type> types = const [ExModel, _$ExModel];
  @override
  final String wireName = 'ExModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ExModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'Schedule',
      serializers.serialize(
        object.schedule,
        specifiedType: const FullType(ScheduleModel),
      ),
      'teacherSubject',
      serializers.serialize(
        object.teacherSubject,
        specifiedType: const FullType(TeacherSubject),
      ),
    ];

    return result;
  }

  @override
  ExModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExModelBuilder();

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
        case 'Schedule':
          result.schedule.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(ScheduleModel),
                )!
                as ScheduleModel,
          );
          break;
        case 'teacherSubject':
          result.teacherSubject.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(TeacherSubject),
                )!
                as TeacherSubject,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$ExModel extends ExModel {
  @override
  final String id;
  @override
  final ScheduleModel schedule;
  @override
  final TeacherSubject teacherSubject;

  factory _$ExModel([void Function(ExModelBuilder)? updates]) =>
      (ExModelBuilder()..update(updates))._build();

  _$ExModel._({
    required this.id,
    required this.schedule,
    required this.teacherSubject,
  }) : super._();
  @override
  ExModel rebuild(void Function(ExModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExModelBuilder toBuilder() => ExModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExModel &&
        id == other.id &&
        schedule == other.schedule &&
        teacherSubject == other.teacherSubject;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, schedule.hashCode);
    _$hash = $jc(_$hash, teacherSubject.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExModel')
          ..add('id', id)
          ..add('schedule', schedule)
          ..add('teacherSubject', teacherSubject))
        .toString();
  }
}

class ExModelBuilder implements Builder<ExModel, ExModelBuilder> {
  _$ExModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  ScheduleModelBuilder? _schedule;
  ScheduleModelBuilder get schedule =>
      _$this._schedule ??= ScheduleModelBuilder();
  set schedule(ScheduleModelBuilder? schedule) => _$this._schedule = schedule;

  TeacherSubjectBuilder? _teacherSubject;
  TeacherSubjectBuilder get teacherSubject =>
      _$this._teacherSubject ??= TeacherSubjectBuilder();
  set teacherSubject(TeacherSubjectBuilder? teacherSubject) =>
      _$this._teacherSubject = teacherSubject;

  ExModelBuilder();

  ExModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _schedule = $v.schedule.toBuilder();
      _teacherSubject = $v.teacherSubject.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExModel other) {
    _$v = other as _$ExModel;
  }

  @override
  void update(void Function(ExModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExModel build() => _build();

  _$ExModel _build() {
    _$ExModel _$result;
    try {
      _$result =
          _$v ??
          _$ExModel._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ExModel', 'id'),
            schedule: schedule.build(),
            teacherSubject: teacherSubject.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'schedule';
        schedule.build();
        _$failedField = 'teacherSubject';
        teacherSubject.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ExModel',
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

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

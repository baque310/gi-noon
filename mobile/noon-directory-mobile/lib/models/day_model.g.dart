// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DayModel> _$dayModelSerializer = _$DayModelSerializer();

class _$DayModelSerializer implements StructuredSerializer<DayModel> {
  @override
  final Iterable<Type> types = const [DayModel, _$DayModel];
  @override
  final String wireName = 'DayModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    DayModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.schedule;
    if (value != null) {
      result
        ..add('Schedule')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(ScheduleModel),
          ),
        );
    }
    value = object.teacherSubject;
    if (value != null) {
      result
        ..add('teacherSubject')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(TeacherSubject),
          ),
        );
    }
    value = object.section;
    if (value != null) {
      result
        ..add('section')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(Section)),
        );
    }
    return result;
  }

  @override
  DayModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DayModelBuilder();

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
                  )
                  as String?;
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
        case 'section':
          result.section.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(Section),
                )!
                as Section,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$DayModel extends DayModel {
  @override
  final String? id;
  @override
  final ScheduleModel? schedule;
  @override
  final TeacherSubject? teacherSubject;
  @override
  final Section? section;

  factory _$DayModel([void Function(DayModelBuilder)? updates]) =>
      (DayModelBuilder()..update(updates))._build();

  _$DayModel._({this.id, this.schedule, this.teacherSubject, this.section})
    : super._();
  @override
  DayModel rebuild(void Function(DayModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DayModelBuilder toBuilder() => DayModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DayModel &&
        id == other.id &&
        schedule == other.schedule &&
        teacherSubject == other.teacherSubject &&
        section == other.section;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, schedule.hashCode);
    _$hash = $jc(_$hash, teacherSubject.hashCode);
    _$hash = $jc(_$hash, section.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DayModel')
          ..add('id', id)
          ..add('schedule', schedule)
          ..add('teacherSubject', teacherSubject)
          ..add('section', section))
        .toString();
  }
}

class DayModelBuilder implements Builder<DayModel, DayModelBuilder> {
  _$DayModel? _$v;

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

  SectionBuilder? _section;
  SectionBuilder get section => _$this._section ??= SectionBuilder();
  set section(SectionBuilder? section) => _$this._section = section;

  DayModelBuilder();

  DayModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _schedule = $v.schedule?.toBuilder();
      _teacherSubject = $v.teacherSubject?.toBuilder();
      _section = $v.section?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DayModel other) {
    _$v = other as _$DayModel;
  }

  @override
  void update(void Function(DayModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DayModel build() => _build();

  _$DayModel _build() {
    _$DayModel _$result;
    try {
      _$result =
          _$v ??
          _$DayModel._(
            id: id,
            schedule: _schedule?.build(),
            teacherSubject: _teacherSubject?.build(),
            section: _section?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'schedule';
        _schedule?.build();
        _$failedField = 'teacherSubject';
        _teacherSubject?.build();
        _$failedField = 'section';
        _section?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'DayModel',
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

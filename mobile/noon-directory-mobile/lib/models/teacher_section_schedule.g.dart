// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_section_schedule.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TeacherSectionSchedule> _$teacherSectionScheduleSerializer =
    _$TeacherSectionScheduleSerializer();

class _$TeacherSectionScheduleSerializer
    implements StructuredSerializer<TeacherSectionSchedule> {
  @override
  final Iterable<Type> types = const [
    TeacherSectionSchedule,
    _$TeacherSectionSchedule,
  ];
  @override
  final String wireName = 'TeacherSectionSchedule';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    TeacherSectionSchedule object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.teacherSubjectId;
    if (value != null) {
      result
        ..add('teacherSubjectId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.sectionId;
    if (value != null) {
      result
        ..add('sectionId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.schoolId;
    if (value != null) {
      result
        ..add('schoolId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.schoolYearId;
    if (value != null) {
      result
        ..add('schoolYearId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.scheduleId;
    if (value != null) {
      result
        ..add('scheduleId')
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
    return result;
  }

  @override
  TeacherSectionSchedule deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeacherSectionScheduleBuilder();

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
        case 'teacherSubjectId':
          result.teacherSubjectId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'sectionId':
          result.sectionId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'schoolId':
          result.schoolId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'schoolYearId':
          result.schoolYearId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'scheduleId':
          result.scheduleId =
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
      }
    }

    return result.build();
  }
}

class _$TeacherSectionSchedule extends TeacherSectionSchedule {
  @override
  final String id;
  @override
  final String? teacherSubjectId;
  @override
  final String? sectionId;
  @override
  final String? schoolId;
  @override
  final String? schoolYearId;
  @override
  final String? scheduleId;
  @override
  final ScheduleModel? schedule;
  @override
  final TeacherSubject? teacherSubject;

  factory _$TeacherSectionSchedule([
    void Function(TeacherSectionScheduleBuilder)? updates,
  ]) => (TeacherSectionScheduleBuilder()..update(updates))._build();

  _$TeacherSectionSchedule._({
    required this.id,
    this.teacherSubjectId,
    this.sectionId,
    this.schoolId,
    this.schoolYearId,
    this.scheduleId,
    this.schedule,
    this.teacherSubject,
  }) : super._();
  @override
  TeacherSectionSchedule rebuild(
    void Function(TeacherSectionScheduleBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TeacherSectionScheduleBuilder toBuilder() =>
      TeacherSectionScheduleBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeacherSectionSchedule &&
        id == other.id &&
        teacherSubjectId == other.teacherSubjectId &&
        sectionId == other.sectionId &&
        schoolId == other.schoolId &&
        schoolYearId == other.schoolYearId &&
        scheduleId == other.scheduleId &&
        schedule == other.schedule &&
        teacherSubject == other.teacherSubject;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, teacherSubjectId.hashCode);
    _$hash = $jc(_$hash, sectionId.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, schoolYearId.hashCode);
    _$hash = $jc(_$hash, scheduleId.hashCode);
    _$hash = $jc(_$hash, schedule.hashCode);
    _$hash = $jc(_$hash, teacherSubject.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeacherSectionSchedule')
          ..add('id', id)
          ..add('teacherSubjectId', teacherSubjectId)
          ..add('sectionId', sectionId)
          ..add('schoolId', schoolId)
          ..add('schoolYearId', schoolYearId)
          ..add('scheduleId', scheduleId)
          ..add('schedule', schedule)
          ..add('teacherSubject', teacherSubject))
        .toString();
  }
}

class TeacherSectionScheduleBuilder
    implements Builder<TeacherSectionSchedule, TeacherSectionScheduleBuilder> {
  _$TeacherSectionSchedule? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _teacherSubjectId;
  String? get teacherSubjectId => _$this._teacherSubjectId;
  set teacherSubjectId(String? teacherSubjectId) =>
      _$this._teacherSubjectId = teacherSubjectId;

  String? _sectionId;
  String? get sectionId => _$this._sectionId;
  set sectionId(String? sectionId) => _$this._sectionId = sectionId;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  String? _schoolYearId;
  String? get schoolYearId => _$this._schoolYearId;
  set schoolYearId(String? schoolYearId) => _$this._schoolYearId = schoolYearId;

  String? _scheduleId;
  String? get scheduleId => _$this._scheduleId;
  set scheduleId(String? scheduleId) => _$this._scheduleId = scheduleId;

  ScheduleModelBuilder? _schedule;
  ScheduleModelBuilder get schedule =>
      _$this._schedule ??= ScheduleModelBuilder();
  set schedule(ScheduleModelBuilder? schedule) => _$this._schedule = schedule;

  TeacherSubjectBuilder? _teacherSubject;
  TeacherSubjectBuilder get teacherSubject =>
      _$this._teacherSubject ??= TeacherSubjectBuilder();
  set teacherSubject(TeacherSubjectBuilder? teacherSubject) =>
      _$this._teacherSubject = teacherSubject;

  TeacherSectionScheduleBuilder();

  TeacherSectionScheduleBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _teacherSubjectId = $v.teacherSubjectId;
      _sectionId = $v.sectionId;
      _schoolId = $v.schoolId;
      _schoolYearId = $v.schoolYearId;
      _scheduleId = $v.scheduleId;
      _schedule = $v.schedule?.toBuilder();
      _teacherSubject = $v.teacherSubject?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeacherSectionSchedule other) {
    _$v = other as _$TeacherSectionSchedule;
  }

  @override
  void update(void Function(TeacherSectionScheduleBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeacherSectionSchedule build() => _build();

  _$TeacherSectionSchedule _build() {
    _$TeacherSectionSchedule _$result;
    try {
      _$result =
          _$v ??
          _$TeacherSectionSchedule._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'TeacherSectionSchedule',
              'id',
            ),
            teacherSubjectId: teacherSubjectId,
            sectionId: sectionId,
            schoolId: schoolId,
            schoolYearId: schoolYearId,
            scheduleId: scheduleId,
            schedule: _schedule?.build(),
            teacherSubject: _teacherSubject?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'schedule';
        _schedule?.build();
        _$failedField = 'teacherSubject';
        _teacherSubject?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeacherSectionSchedule',
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

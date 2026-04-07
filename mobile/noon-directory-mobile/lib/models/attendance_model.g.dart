// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AttendanceModel> _$attendanceModelSerializer =
    _$AttendanceModelSerializer();
Serializer<SectionScheduleModel> _$sectionScheduleModelSerializer =
    _$SectionScheduleModelSerializer();
Serializer<EnrollmentSectionModel> _$enrollmentSectionModelSerializer =
    _$EnrollmentSectionModelSerializer();

class _$AttendanceModelSerializer
    implements StructuredSerializer<AttendanceModel> {
  @override
  final Iterable<Type> types = const [AttendanceModel, _$AttendanceModel];
  @override
  final String wireName = 'AttendanceModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    AttendanceModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'date',
      serializers.serialize(
        object.date,
        specifiedType: const FullType(DateTime),
      ),
      'Status',
      serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      ),
      'SectionSchedule',
      serializers.serialize(
        object.sectionSchedule,
        specifiedType: const FullType(SectionScheduleModel),
      ),
      'StudentEnrollment',
      serializers.serialize(
        object.studentEnrollment,
        specifiedType: const FullType(StudentEnrollmentModel),
      ),
      'SchoolYear',
      serializers.serialize(
        object.schoolYear,
        specifiedType: const FullType(SchoolYear),
      ),
    ];

    return result;
  }

  @override
  AttendanceModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttendanceModelBuilder();

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
        case 'date':
          result.date =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'Status':
          result.status =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'SectionSchedule':
          result.sectionSchedule.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(SectionScheduleModel),
                )!
                as SectionScheduleModel,
          );
          break;
        case 'StudentEnrollment':
          result.studentEnrollment.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(StudentEnrollmentModel),
                )!
                as StudentEnrollmentModel,
          );
          break;
        case 'SchoolYear':
          result.schoolYear.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(SchoolYear),
                )!
                as SchoolYear,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$SectionScheduleModelSerializer
    implements StructuredSerializer<SectionScheduleModel> {
  @override
  final Iterable<Type> types = const [
    SectionScheduleModel,
    _$SectionScheduleModel,
  ];
  @override
  final String wireName = 'SectionScheduleModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    SectionScheduleModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'section',
      serializers.serialize(
        object.section,
        specifiedType: const FullType(Section),
      ),
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
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  SectionScheduleModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SectionScheduleModelBuilder();

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
        case 'section':
          result.section.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(Section),
                )!
                as Section,
          );
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

class _$EnrollmentSectionModelSerializer
    implements StructuredSerializer<EnrollmentSectionModel> {
  @override
  final Iterable<Type> types = const [
    EnrollmentSectionModel,
    _$EnrollmentSectionModel,
  ];
  @override
  final String wireName = 'EnrollmentSectionModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    EnrollmentSectionModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'Class',
      serializers.serialize(
        object.classInfo,
        specifiedType: const FullType(ClassInfo),
      ),
    ];

    return result;
  }

  @override
  EnrollmentSectionModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnrollmentSectionModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'Class':
          result.classInfo.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(ClassInfo),
                )!
                as ClassInfo,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$AttendanceModel extends AttendanceModel {
  @override
  final String id;
  @override
  final DateTime date;
  @override
  final String status;
  @override
  final SectionScheduleModel sectionSchedule;
  @override
  final StudentEnrollmentModel studentEnrollment;
  @override
  final SchoolYear schoolYear;

  factory _$AttendanceModel([void Function(AttendanceModelBuilder)? updates]) =>
      (AttendanceModelBuilder()..update(updates))._build();

  _$AttendanceModel._({
    required this.id,
    required this.date,
    required this.status,
    required this.sectionSchedule,
    required this.studentEnrollment,
    required this.schoolYear,
  }) : super._();
  @override
  AttendanceModel rebuild(void Function(AttendanceModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttendanceModelBuilder toBuilder() => AttendanceModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttendanceModel &&
        id == other.id &&
        date == other.date &&
        status == other.status &&
        sectionSchedule == other.sectionSchedule &&
        studentEnrollment == other.studentEnrollment &&
        schoolYear == other.schoolYear;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, date.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, sectionSchedule.hashCode);
    _$hash = $jc(_$hash, studentEnrollment.hashCode);
    _$hash = $jc(_$hash, schoolYear.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AttendanceModel')
          ..add('id', id)
          ..add('date', date)
          ..add('status', status)
          ..add('sectionSchedule', sectionSchedule)
          ..add('studentEnrollment', studentEnrollment)
          ..add('schoolYear', schoolYear))
        .toString();
  }
}

class AttendanceModelBuilder
    implements Builder<AttendanceModel, AttendanceModelBuilder> {
  _$AttendanceModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _date;
  DateTime? get date => _$this._date;
  set date(DateTime? date) => _$this._date = date;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  SectionScheduleModelBuilder? _sectionSchedule;
  SectionScheduleModelBuilder get sectionSchedule =>
      _$this._sectionSchedule ??= SectionScheduleModelBuilder();
  set sectionSchedule(SectionScheduleModelBuilder? sectionSchedule) =>
      _$this._sectionSchedule = sectionSchedule;

  StudentEnrollmentModelBuilder? _studentEnrollment;
  StudentEnrollmentModelBuilder get studentEnrollment =>
      _$this._studentEnrollment ??= StudentEnrollmentModelBuilder();
  set studentEnrollment(StudentEnrollmentModelBuilder? studentEnrollment) =>
      _$this._studentEnrollment = studentEnrollment;

  SchoolYearBuilder? _schoolYear;
  SchoolYearBuilder get schoolYear =>
      _$this._schoolYear ??= SchoolYearBuilder();
  set schoolYear(SchoolYearBuilder? schoolYear) =>
      _$this._schoolYear = schoolYear;

  AttendanceModelBuilder();

  AttendanceModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _date = $v.date;
      _status = $v.status;
      _sectionSchedule = $v.sectionSchedule.toBuilder();
      _studentEnrollment = $v.studentEnrollment.toBuilder();
      _schoolYear = $v.schoolYear.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttendanceModel other) {
    _$v = other as _$AttendanceModel;
  }

  @override
  void update(void Function(AttendanceModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttendanceModel build() => _build();

  _$AttendanceModel _build() {
    _$AttendanceModel _$result;
    try {
      _$result =
          _$v ??
          _$AttendanceModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'AttendanceModel',
              'id',
            ),
            date: BuiltValueNullFieldError.checkNotNull(
              date,
              r'AttendanceModel',
              'date',
            ),
            status: BuiltValueNullFieldError.checkNotNull(
              status,
              r'AttendanceModel',
              'status',
            ),
            sectionSchedule: sectionSchedule.build(),
            studentEnrollment: studentEnrollment.build(),
            schoolYear: schoolYear.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'sectionSchedule';
        sectionSchedule.build();
        _$failedField = 'studentEnrollment';
        studentEnrollment.build();
        _$failedField = 'schoolYear';
        schoolYear.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'AttendanceModel',
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

class _$SectionScheduleModel extends SectionScheduleModel {
  @override
  final String? id;
  @override
  final Section section;
  @override
  final ScheduleModel schedule;
  @override
  final TeacherSubject teacherSubject;

  factory _$SectionScheduleModel([
    void Function(SectionScheduleModelBuilder)? updates,
  ]) => (SectionScheduleModelBuilder()..update(updates))._build();

  _$SectionScheduleModel._({
    this.id,
    required this.section,
    required this.schedule,
    required this.teacherSubject,
  }) : super._();
  @override
  SectionScheduleModel rebuild(
    void Function(SectionScheduleModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  SectionScheduleModelBuilder toBuilder() =>
      SectionScheduleModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SectionScheduleModel &&
        id == other.id &&
        section == other.section &&
        schedule == other.schedule &&
        teacherSubject == other.teacherSubject;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, section.hashCode);
    _$hash = $jc(_$hash, schedule.hashCode);
    _$hash = $jc(_$hash, teacherSubject.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SectionScheduleModel')
          ..add('id', id)
          ..add('section', section)
          ..add('schedule', schedule)
          ..add('teacherSubject', teacherSubject))
        .toString();
  }
}

class SectionScheduleModelBuilder
    implements Builder<SectionScheduleModel, SectionScheduleModelBuilder> {
  _$SectionScheduleModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  SectionBuilder? _section;
  SectionBuilder get section => _$this._section ??= SectionBuilder();
  set section(SectionBuilder? section) => _$this._section = section;

  ScheduleModelBuilder? _schedule;
  ScheduleModelBuilder get schedule =>
      _$this._schedule ??= ScheduleModelBuilder();
  set schedule(ScheduleModelBuilder? schedule) => _$this._schedule = schedule;

  TeacherSubjectBuilder? _teacherSubject;
  TeacherSubjectBuilder get teacherSubject =>
      _$this._teacherSubject ??= TeacherSubjectBuilder();
  set teacherSubject(TeacherSubjectBuilder? teacherSubject) =>
      _$this._teacherSubject = teacherSubject;

  SectionScheduleModelBuilder();

  SectionScheduleModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _section = $v.section.toBuilder();
      _schedule = $v.schedule.toBuilder();
      _teacherSubject = $v.teacherSubject.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SectionScheduleModel other) {
    _$v = other as _$SectionScheduleModel;
  }

  @override
  void update(void Function(SectionScheduleModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SectionScheduleModel build() => _build();

  _$SectionScheduleModel _build() {
    _$SectionScheduleModel _$result;
    try {
      _$result =
          _$v ??
          _$SectionScheduleModel._(
            id: id,
            section: section.build(),
            schedule: schedule.build(),
            teacherSubject: teacherSubject.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'section';
        section.build();
        _$failedField = 'schedule';
        schedule.build();
        _$failedField = 'teacherSubject';
        teacherSubject.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'SectionScheduleModel',
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

class _$EnrollmentSectionModel extends EnrollmentSectionModel {
  @override
  final String name;
  @override
  final ClassInfo classInfo;

  factory _$EnrollmentSectionModel([
    void Function(EnrollmentSectionModelBuilder)? updates,
  ]) => (EnrollmentSectionModelBuilder()..update(updates))._build();

  _$EnrollmentSectionModel._({required this.name, required this.classInfo})
    : super._();
  @override
  EnrollmentSectionModel rebuild(
    void Function(EnrollmentSectionModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  EnrollmentSectionModelBuilder toBuilder() =>
      EnrollmentSectionModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnrollmentSectionModel &&
        name == other.name &&
        classInfo == other.classInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, classInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnrollmentSectionModel')
          ..add('name', name)
          ..add('classInfo', classInfo))
        .toString();
  }
}

class EnrollmentSectionModelBuilder
    implements Builder<EnrollmentSectionModel, EnrollmentSectionModelBuilder> {
  _$EnrollmentSectionModel? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ClassInfoBuilder? _classInfo;
  ClassInfoBuilder get classInfo => _$this._classInfo ??= ClassInfoBuilder();
  set classInfo(ClassInfoBuilder? classInfo) => _$this._classInfo = classInfo;

  EnrollmentSectionModelBuilder();

  EnrollmentSectionModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _classInfo = $v.classInfo.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnrollmentSectionModel other) {
    _$v = other as _$EnrollmentSectionModel;
  }

  @override
  void update(void Function(EnrollmentSectionModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnrollmentSectionModel build() => _build();

  _$EnrollmentSectionModel _build() {
    _$EnrollmentSectionModel _$result;
    try {
      _$result =
          _$v ??
          _$EnrollmentSectionModel._(
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'EnrollmentSectionModel',
              'name',
            ),
            classInfo: classInfo.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'classInfo';
        classInfo.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EnrollmentSectionModel',
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

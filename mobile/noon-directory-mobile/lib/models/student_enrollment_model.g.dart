// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_enrollment_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StudentEnrollmentModel> _$studentEnrollmentModelSerializer =
    _$StudentEnrollmentModelSerializer();

class _$StudentEnrollmentModelSerializer
    implements StructuredSerializer<StudentEnrollmentModel> {
  @override
  final Iterable<Type> types = const [
    StudentEnrollmentModel,
    _$StudentEnrollmentModel,
  ];
  @override
  final String wireName = 'StudentEnrollmentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    StudentEnrollmentModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'Student',
      serializers.serialize(
        object.student,
        specifiedType: const FullType(StudentModel),
      ),
    ];
    Object? value;
    value = object.createdAt;
    if (value != null) {
      result
        ..add('createdAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updatedAt')
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
    value = object.status;
    if (value != null) {
      result
        ..add('status')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(StudentStutus),
          ),
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
    value = object.stageId;
    if (value != null) {
      result
        ..add('stageId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.classId;
    if (value != null) {
      result
        ..add('classId')
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
    value = object.schoolYearId;
    if (value != null) {
      result
        ..add('schoolYearId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.section;
    if (value != null) {
      result
        ..add('Section')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(EnrollmentSectionModel),
          ),
        );
    }
    return result;
  }

  @override
  StudentEnrollmentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StudentEnrollmentModelBuilder();

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
        case 'createdAt':
          result.createdAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'updatedAt':
          result.updatedAt =
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
        case 'status':
          result.status =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(StudentStutus),
                  )
                  as StudentStutus?;
          break;
        case 'schoolId':
          result.schoolId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'stageId':
          result.stageId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'classId':
          result.classId =
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
        case 'schoolYearId':
          result.schoolYearId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'Student':
          result.student.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(StudentModel),
                )!
                as StudentModel,
          );
          break;
        case 'Section':
          result.section.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(EnrollmentSectionModel),
                )!
                as EnrollmentSectionModel,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$StudentEnrollmentModel extends StudentEnrollmentModel {
  @override
  final String id;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? studentId;
  @override
  final StudentStutus? status;
  @override
  final String? schoolId;
  @override
  final String? stageId;
  @override
  final String? classId;
  @override
  final String? sectionId;
  @override
  final String? schoolYearId;
  @override
  final StudentModel student;
  @override
  final EnrollmentSectionModel? section;

  factory _$StudentEnrollmentModel([
    void Function(StudentEnrollmentModelBuilder)? updates,
  ]) => (StudentEnrollmentModelBuilder()..update(updates))._build();

  _$StudentEnrollmentModel._({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.studentId,
    this.status,
    this.schoolId,
    this.stageId,
    this.classId,
    this.sectionId,
    this.schoolYearId,
    required this.student,
    this.section,
  }) : super._();
  @override
  StudentEnrollmentModel rebuild(
    void Function(StudentEnrollmentModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  StudentEnrollmentModelBuilder toBuilder() =>
      StudentEnrollmentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StudentEnrollmentModel &&
        id == other.id &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        studentId == other.studentId &&
        status == other.status &&
        schoolId == other.schoolId &&
        stageId == other.stageId &&
        classId == other.classId &&
        sectionId == other.sectionId &&
        schoolYearId == other.schoolYearId &&
        student == other.student &&
        section == other.section;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, studentId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, stageId.hashCode);
    _$hash = $jc(_$hash, classId.hashCode);
    _$hash = $jc(_$hash, sectionId.hashCode);
    _$hash = $jc(_$hash, schoolYearId.hashCode);
    _$hash = $jc(_$hash, student.hashCode);
    _$hash = $jc(_$hash, section.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StudentEnrollmentModel')
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('studentId', studentId)
          ..add('status', status)
          ..add('schoolId', schoolId)
          ..add('stageId', stageId)
          ..add('classId', classId)
          ..add('sectionId', sectionId)
          ..add('schoolYearId', schoolYearId)
          ..add('student', student)
          ..add('section', section))
        .toString();
  }
}

class StudentEnrollmentModelBuilder
    implements Builder<StudentEnrollmentModel, StudentEnrollmentModelBuilder> {
  _$StudentEnrollmentModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _studentId;
  String? get studentId => _$this._studentId;
  set studentId(String? studentId) => _$this._studentId = studentId;

  StudentStutus? _status;
  StudentStutus? get status => _$this._status;
  set status(StudentStutus? status) => _$this._status = status;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  String? _stageId;
  String? get stageId => _$this._stageId;
  set stageId(String? stageId) => _$this._stageId = stageId;

  String? _classId;
  String? get classId => _$this._classId;
  set classId(String? classId) => _$this._classId = classId;

  String? _sectionId;
  String? get sectionId => _$this._sectionId;
  set sectionId(String? sectionId) => _$this._sectionId = sectionId;

  String? _schoolYearId;
  String? get schoolYearId => _$this._schoolYearId;
  set schoolYearId(String? schoolYearId) => _$this._schoolYearId = schoolYearId;

  StudentModelBuilder? _student;
  StudentModelBuilder get student => _$this._student ??= StudentModelBuilder();
  set student(StudentModelBuilder? student) => _$this._student = student;

  EnrollmentSectionModelBuilder? _section;
  EnrollmentSectionModelBuilder get section =>
      _$this._section ??= EnrollmentSectionModelBuilder();
  set section(EnrollmentSectionModelBuilder? section) =>
      _$this._section = section;

  StudentEnrollmentModelBuilder();

  StudentEnrollmentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _studentId = $v.studentId;
      _status = $v.status;
      _schoolId = $v.schoolId;
      _stageId = $v.stageId;
      _classId = $v.classId;
      _sectionId = $v.sectionId;
      _schoolYearId = $v.schoolYearId;
      _student = $v.student.toBuilder();
      _section = $v.section?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StudentEnrollmentModel other) {
    _$v = other as _$StudentEnrollmentModel;
  }

  @override
  void update(void Function(StudentEnrollmentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StudentEnrollmentModel build() => _build();

  _$StudentEnrollmentModel _build() {
    _$StudentEnrollmentModel _$result;
    try {
      _$result =
          _$v ??
          _$StudentEnrollmentModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'StudentEnrollmentModel',
              'id',
            ),
            createdAt: createdAt,
            updatedAt: updatedAt,
            studentId: studentId,
            status: status,
            schoolId: schoolId,
            stageId: stageId,
            classId: classId,
            sectionId: sectionId,
            schoolYearId: schoolYearId,
            student: student.build(),
            section: _section?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'student';
        student.build();
        _$failedField = 'section';
        _section?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'StudentEnrollmentModel',
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

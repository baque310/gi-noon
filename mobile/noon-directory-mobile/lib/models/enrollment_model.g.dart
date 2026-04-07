// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<EnrollmentModel> _$enrollmentModelSerializer =
    _$EnrollmentModelSerializer();

class _$EnrollmentModelSerializer
    implements StructuredSerializer<EnrollmentModel> {
  @override
  final Iterable<Type> types = const [EnrollmentModel, _$EnrollmentModel];
  @override
  final String wireName = 'EnrollmentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    EnrollmentModel object, {
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
    value = object.schoolYearId;
    if (value != null) {
      result
        ..add('schoolYearId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.schoolYear;
    if (value != null) {
      result
        ..add('SchoolYear')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(SchoolYear),
          ),
        );
    }
    value = object.stage;
    if (value != null) {
      result
        ..add('Stage')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(Stage)),
        );
    }
    value = object.classInfo;
    if (value != null) {
      result
        ..add('Class')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(ClassInfo),
          ),
        );
    }
    value = object.section;
    if (value != null) {
      result
        ..add('Section')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(Section)),
        );
    }
    return result;
  }

  @override
  EnrollmentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EnrollmentModelBuilder();

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
        case 'schoolYearId':
          result.schoolYearId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
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
        case 'Stage':
          result.stage.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(Stage),
                )!
                as Stage,
          );
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
        case 'Section':
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

class _$EnrollmentModel extends EnrollmentModel {
  @override
  final String? id;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? studentId;
  @override
  final String? schoolId;
  @override
  final String? stageId;
  @override
  final String? schoolYearId;
  @override
  final SchoolYear? schoolYear;
  @override
  final Stage? stage;
  @override
  final ClassInfo? classInfo;
  @override
  final Section? section;

  factory _$EnrollmentModel([void Function(EnrollmentModelBuilder)? updates]) =>
      (EnrollmentModelBuilder()..update(updates))._build();

  _$EnrollmentModel._({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.studentId,
    this.schoolId,
    this.stageId,
    this.schoolYearId,
    this.schoolYear,
    this.stage,
    this.classInfo,
    this.section,
  }) : super._();
  @override
  EnrollmentModel rebuild(void Function(EnrollmentModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  EnrollmentModelBuilder toBuilder() => EnrollmentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is EnrollmentModel &&
        id == other.id &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        studentId == other.studentId &&
        schoolId == other.schoolId &&
        stageId == other.stageId &&
        schoolYearId == other.schoolYearId &&
        schoolYear == other.schoolYear &&
        stage == other.stage &&
        classInfo == other.classInfo &&
        section == other.section;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, studentId.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, stageId.hashCode);
    _$hash = $jc(_$hash, schoolYearId.hashCode);
    _$hash = $jc(_$hash, schoolYear.hashCode);
    _$hash = $jc(_$hash, stage.hashCode);
    _$hash = $jc(_$hash, classInfo.hashCode);
    _$hash = $jc(_$hash, section.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'EnrollmentModel')
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('studentId', studentId)
          ..add('schoolId', schoolId)
          ..add('stageId', stageId)
          ..add('schoolYearId', schoolYearId)
          ..add('schoolYear', schoolYear)
          ..add('stage', stage)
          ..add('classInfo', classInfo)
          ..add('section', section))
        .toString();
  }
}

class EnrollmentModelBuilder
    implements Builder<EnrollmentModel, EnrollmentModelBuilder> {
  _$EnrollmentModel? _$v;

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

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  String? _stageId;
  String? get stageId => _$this._stageId;
  set stageId(String? stageId) => _$this._stageId = stageId;

  String? _schoolYearId;
  String? get schoolYearId => _$this._schoolYearId;
  set schoolYearId(String? schoolYearId) => _$this._schoolYearId = schoolYearId;

  SchoolYearBuilder? _schoolYear;
  SchoolYearBuilder get schoolYear =>
      _$this._schoolYear ??= SchoolYearBuilder();
  set schoolYear(SchoolYearBuilder? schoolYear) =>
      _$this._schoolYear = schoolYear;

  StageBuilder? _stage;
  StageBuilder get stage => _$this._stage ??= StageBuilder();
  set stage(StageBuilder? stage) => _$this._stage = stage;

  ClassInfoBuilder? _classInfo;
  ClassInfoBuilder get classInfo => _$this._classInfo ??= ClassInfoBuilder();
  set classInfo(ClassInfoBuilder? classInfo) => _$this._classInfo = classInfo;

  SectionBuilder? _section;
  SectionBuilder get section => _$this._section ??= SectionBuilder();
  set section(SectionBuilder? section) => _$this._section = section;

  EnrollmentModelBuilder();

  EnrollmentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _studentId = $v.studentId;
      _schoolId = $v.schoolId;
      _stageId = $v.stageId;
      _schoolYearId = $v.schoolYearId;
      _schoolYear = $v.schoolYear?.toBuilder();
      _stage = $v.stage?.toBuilder();
      _classInfo = $v.classInfo?.toBuilder();
      _section = $v.section?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(EnrollmentModel other) {
    _$v = other as _$EnrollmentModel;
  }

  @override
  void update(void Function(EnrollmentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  EnrollmentModel build() => _build();

  _$EnrollmentModel _build() {
    _$EnrollmentModel _$result;
    try {
      _$result =
          _$v ??
          _$EnrollmentModel._(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            studentId: studentId,
            schoolId: schoolId,
            stageId: stageId,
            schoolYearId: schoolYearId,
            schoolYear: _schoolYear?.build(),
            stage: _stage?.build(),
            classInfo: _classInfo?.build(),
            section: _section?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'schoolYear';
        _schoolYear?.build();
        _$failedField = 'stage';
        _stage?.build();
        _$failedField = 'classInfo';
        _classInfo?.build();
        _$failedField = 'section';
        _section?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'EnrollmentModel',
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_subject_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TeacherSubject> _$teacherSubjectSerializer =
    _$TeacherSubjectSerializer();
Serializer<StageSubject> _$stageSubjectSerializer = _$StageSubjectSerializer();

class _$TeacherSubjectSerializer
    implements StructuredSerializer<TeacherSubject> {
  @override
  final Iterable<Type> types = const [TeacherSubject, _$TeacherSubject];
  @override
  final String wireName = 'TeacherSubject';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    TeacherSubject object, {
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
    value = object.teacherId;
    if (value != null) {
      result
        ..add('teacherId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.stageSubjectId;
    if (value != null) {
      result
        ..add('stageSubjectId')
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
    value = object.teacher;
    if (value != null) {
      result
        ..add('Teacher')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(TeacherModel),
          ),
        );
    }
    value = object.stageSubject;
    if (value != null) {
      result
        ..add('StageSubject')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(StageSubject),
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
  TeacherSubject deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeacherSubjectBuilder();

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
        case 'teacherId':
          result.teacherId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'stageSubjectId':
          result.stageSubjectId =
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
        case 'Teacher':
          result.teacher.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(TeacherModel),
                )!
                as TeacherModel,
          );
          break;
        case 'StageSubject':
          result.stageSubject.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(StageSubject),
                )!
                as StageSubject,
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

class _$StageSubjectSerializer implements StructuredSerializer<StageSubject> {
  @override
  final Iterable<Type> types = const [StageSubject, _$StageSubject];
  @override
  final String wireName = 'StageSubject';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    StageSubject object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[];
    Object? value;
    value = object.subject;
    if (value != null) {
      result
        ..add('Subject')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(Subject)),
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
    return result;
  }

  @override
  StageSubject deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StageSubjectBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'Subject':
          result.subject.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(Subject),
                )!
                as Subject,
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
      }
    }

    return result.build();
  }
}

class _$TeacherSubject extends TeacherSubject {
  @override
  final String? id;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? teacherId;
  @override
  final String? stageSubjectId;
  @override
  final String? schoolYearId;
  @override
  final TeacherModel? teacher;
  @override
  final StageSubject? stageSubject;
  @override
  final Section? section;

  factory _$TeacherSubject([void Function(TeacherSubjectBuilder)? updates]) =>
      (TeacherSubjectBuilder()..update(updates))._build();

  _$TeacherSubject._({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.teacherId,
    this.stageSubjectId,
    this.schoolYearId,
    this.teacher,
    this.stageSubject,
    this.section,
  }) : super._();
  @override
  TeacherSubject rebuild(void Function(TeacherSubjectBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TeacherSubjectBuilder toBuilder() => TeacherSubjectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeacherSubject &&
        id == other.id &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        teacherId == other.teacherId &&
        stageSubjectId == other.stageSubjectId &&
        schoolYearId == other.schoolYearId &&
        teacher == other.teacher &&
        stageSubject == other.stageSubject &&
        section == other.section;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, teacherId.hashCode);
    _$hash = $jc(_$hash, stageSubjectId.hashCode);
    _$hash = $jc(_$hash, schoolYearId.hashCode);
    _$hash = $jc(_$hash, teacher.hashCode);
    _$hash = $jc(_$hash, stageSubject.hashCode);
    _$hash = $jc(_$hash, section.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeacherSubject')
          ..add('id', id)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('teacherId', teacherId)
          ..add('stageSubjectId', stageSubjectId)
          ..add('schoolYearId', schoolYearId)
          ..add('teacher', teacher)
          ..add('stageSubject', stageSubject)
          ..add('section', section))
        .toString();
  }
}

class TeacherSubjectBuilder
    implements Builder<TeacherSubject, TeacherSubjectBuilder> {
  _$TeacherSubject? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _teacherId;
  String? get teacherId => _$this._teacherId;
  set teacherId(String? teacherId) => _$this._teacherId = teacherId;

  String? _stageSubjectId;
  String? get stageSubjectId => _$this._stageSubjectId;
  set stageSubjectId(String? stageSubjectId) =>
      _$this._stageSubjectId = stageSubjectId;

  String? _schoolYearId;
  String? get schoolYearId => _$this._schoolYearId;
  set schoolYearId(String? schoolYearId) => _$this._schoolYearId = schoolYearId;

  TeacherModelBuilder? _teacher;
  TeacherModelBuilder get teacher => _$this._teacher ??= TeacherModelBuilder();
  set teacher(TeacherModelBuilder? teacher) => _$this._teacher = teacher;

  StageSubjectBuilder? _stageSubject;
  StageSubjectBuilder get stageSubject =>
      _$this._stageSubject ??= StageSubjectBuilder();
  set stageSubject(StageSubjectBuilder? stageSubject) =>
      _$this._stageSubject = stageSubject;

  SectionBuilder? _section;
  SectionBuilder get section => _$this._section ??= SectionBuilder();
  set section(SectionBuilder? section) => _$this._section = section;

  TeacherSubjectBuilder();

  TeacherSubjectBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _teacherId = $v.teacherId;
      _stageSubjectId = $v.stageSubjectId;
      _schoolYearId = $v.schoolYearId;
      _teacher = $v.teacher?.toBuilder();
      _stageSubject = $v.stageSubject?.toBuilder();
      _section = $v.section?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeacherSubject other) {
    _$v = other as _$TeacherSubject;
  }

  @override
  void update(void Function(TeacherSubjectBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeacherSubject build() => _build();

  _$TeacherSubject _build() {
    _$TeacherSubject _$result;
    try {
      _$result =
          _$v ??
          _$TeacherSubject._(
            id: id,
            createdAt: createdAt,
            updatedAt: updatedAt,
            teacherId: teacherId,
            stageSubjectId: stageSubjectId,
            schoolYearId: schoolYearId,
            teacher: _teacher?.build(),
            stageSubject: _stageSubject?.build(),
            section: _section?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'teacher';
        _teacher?.build();
        _$failedField = 'stageSubject';
        _stageSubject?.build();
        _$failedField = 'section';
        _section?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeacherSubject',
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

class _$StageSubject extends StageSubject {
  @override
  final Subject? subject;
  @override
  final Stage? stage;

  factory _$StageSubject([void Function(StageSubjectBuilder)? updates]) =>
      (StageSubjectBuilder()..update(updates))._build();

  _$StageSubject._({this.subject, this.stage}) : super._();
  @override
  StageSubject rebuild(void Function(StageSubjectBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StageSubjectBuilder toBuilder() => StageSubjectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StageSubject &&
        subject == other.subject &&
        stage == other.stage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, stage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StageSubject')
          ..add('subject', subject)
          ..add('stage', stage))
        .toString();
  }
}

class StageSubjectBuilder
    implements Builder<StageSubject, StageSubjectBuilder> {
  _$StageSubject? _$v;

  SubjectBuilder? _subject;
  SubjectBuilder get subject => _$this._subject ??= SubjectBuilder();
  set subject(SubjectBuilder? subject) => _$this._subject = subject;

  StageBuilder? _stage;
  StageBuilder get stage => _$this._stage ??= StageBuilder();
  set stage(StageBuilder? stage) => _$this._stage = stage;

  StageSubjectBuilder();

  StageSubjectBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subject = $v.subject?.toBuilder();
      _stage = $v.stage?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StageSubject other) {
    _$v = other as _$StageSubject;
  }

  @override
  void update(void Function(StageSubjectBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StageSubject build() => _build();

  _$StageSubject _build() {
    _$StageSubject _$result;
    try {
      _$result =
          _$v ??
          _$StageSubject._(subject: _subject?.build(), stage: _stage?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'subject';
        _subject?.build();
        _$failedField = 'stage';
        _stage?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'StageSubject',
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

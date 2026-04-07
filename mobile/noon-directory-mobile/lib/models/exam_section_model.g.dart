// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_section_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ExamSectionModel> _$examSectionModelSerializer =
    _$ExamSectionModelSerializer();
Serializer<Exam> _$examSerializer = _$ExamSerializer();
Serializer<ExamType> _$examTypeSerializer = _$ExamTypeSerializer();

class _$ExamSectionModelSerializer
    implements StructuredSerializer<ExamSectionModel> {
  @override
  final Iterable<Type> types = const [ExamSectionModel, _$ExamSectionModel];
  @override
  final String wireName = 'ExamSectionModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ExamSectionModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'teachers',
      serializers.serialize(
        object.teachers,
        specifiedType: const FullType(BuiltList, const [
          const FullType(ExamTeacherModel),
        ]),
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
    value = object.examDate;
    if (value != null) {
      result
        ..add('examDate')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
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
    value = object.exam;
    if (value != null) {
      result
        ..add('Exam')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(Exam)),
        );
    }
    value = object.examResult;
    if (value != null) {
      result
        ..add('ExamResult')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(DegreesModel),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  ExamSectionModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExamSectionModelBuilder();

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
        case 'examDate':
          result.examDate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
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
        case 'teachers':
          result.teachers.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(ExamTeacherModel),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'Exam':
          result.exam.replace(
            serializers.deserialize(value, specifiedType: const FullType(Exam))!
                as Exam,
          );
          break;
        case 'ExamResult':
          result.examResult.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(DegreesModel),
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

class _$ExamSerializer implements StructuredSerializer<Exam> {
  @override
  final Iterable<Type> types = const [Exam, _$Exam];
  @override
  final String wireName = 'Exam';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    Exam object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'StageSubject',
      serializers.serialize(
        object.stageSubject,
        specifiedType: const FullType(StageSubjectModel),
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
    value = object.content;
    if (value != null) {
      result
        ..add('content')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.score;
    if (value != null) {
      result
        ..add('score')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.examType;
    if (value != null) {
      result
        ..add('ExamType')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(ExamType)),
        );
    }
    return result;
  }

  @override
  Exam deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExamBuilder();

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
        case 'content':
          result.content =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'score':
          result.score =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'ExamType':
          result.examType.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(ExamType),
                )!
                as ExamType,
          );
          break;
        case 'StageSubject':
          result.stageSubject.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(StageSubjectModel),
                )!
                as StageSubjectModel,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$ExamTypeSerializer implements StructuredSerializer<ExamType> {
  @override
  final Iterable<Type> types = const [ExamType, _$ExamType];
  @override
  final String wireName = 'ExamType';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ExamType object, {
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
    value = object.name;
    if (value != null) {
      result
        ..add('name')
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
    value = object.schoolId;
    if (value != null) {
      result
        ..add('schoolId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  ExamType deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExamTypeBuilder();

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
        case 'name':
          result.name =
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
        case 'schoolId':
          result.schoolId =
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

class _$ExamSectionModel extends ExamSectionModel {
  @override
  final String? id;
  @override
  final DateTime? examDate;
  @override
  final Section? section;
  @override
  final BuiltList<ExamTeacherModel> teachers;
  @override
  final Exam? exam;
  @override
  final BuiltList<DegreesModel>? examResult;

  factory _$ExamSectionModel([
    void Function(ExamSectionModelBuilder)? updates,
  ]) => (ExamSectionModelBuilder()..update(updates))._build();

  _$ExamSectionModel._({
    this.id,
    this.examDate,
    this.section,
    required this.teachers,
    this.exam,
    this.examResult,
  }) : super._();
  @override
  ExamSectionModel rebuild(void Function(ExamSectionModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExamSectionModelBuilder toBuilder() =>
      ExamSectionModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExamSectionModel &&
        id == other.id &&
        examDate == other.examDate &&
        section == other.section &&
        teachers == other.teachers &&
        exam == other.exam &&
        examResult == other.examResult;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, examDate.hashCode);
    _$hash = $jc(_$hash, section.hashCode);
    _$hash = $jc(_$hash, teachers.hashCode);
    _$hash = $jc(_$hash, exam.hashCode);
    _$hash = $jc(_$hash, examResult.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExamSectionModel')
          ..add('id', id)
          ..add('examDate', examDate)
          ..add('section', section)
          ..add('teachers', teachers)
          ..add('exam', exam)
          ..add('examResult', examResult))
        .toString();
  }
}

class ExamSectionModelBuilder
    implements Builder<ExamSectionModel, ExamSectionModelBuilder> {
  _$ExamSectionModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  DateTime? _examDate;
  DateTime? get examDate => _$this._examDate;
  set examDate(DateTime? examDate) => _$this._examDate = examDate;

  SectionBuilder? _section;
  SectionBuilder get section => _$this._section ??= SectionBuilder();
  set section(SectionBuilder? section) => _$this._section = section;

  ListBuilder<ExamTeacherModel>? _teachers;
  ListBuilder<ExamTeacherModel> get teachers =>
      _$this._teachers ??= ListBuilder<ExamTeacherModel>();
  set teachers(ListBuilder<ExamTeacherModel>? teachers) =>
      _$this._teachers = teachers;

  ExamBuilder? _exam;
  ExamBuilder get exam => _$this._exam ??= ExamBuilder();
  set exam(ExamBuilder? exam) => _$this._exam = exam;

  ListBuilder<DegreesModel>? _examResult;
  ListBuilder<DegreesModel> get examResult =>
      _$this._examResult ??= ListBuilder<DegreesModel>();
  set examResult(ListBuilder<DegreesModel>? examResult) =>
      _$this._examResult = examResult;

  ExamSectionModelBuilder();

  ExamSectionModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _examDate = $v.examDate;
      _section = $v.section?.toBuilder();
      _teachers = $v.teachers.toBuilder();
      _exam = $v.exam?.toBuilder();
      _examResult = $v.examResult?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExamSectionModel other) {
    _$v = other as _$ExamSectionModel;
  }

  @override
  void update(void Function(ExamSectionModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExamSectionModel build() => _build();

  _$ExamSectionModel _build() {
    _$ExamSectionModel _$result;
    try {
      _$result =
          _$v ??
          _$ExamSectionModel._(
            id: id,
            examDate: examDate,
            section: _section?.build(),
            teachers: teachers.build(),
            exam: _exam?.build(),
            examResult: _examResult?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'section';
        _section?.build();
        _$failedField = 'teachers';
        teachers.build();
        _$failedField = 'exam';
        _exam?.build();
        _$failedField = 'examResult';
        _examResult?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ExamSectionModel',
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

class _$Exam extends Exam {
  @override
  final String? id;
  @override
  final String? content;
  @override
  final int? score;
  @override
  final ExamType? examType;
  @override
  final StageSubjectModel stageSubject;

  factory _$Exam([void Function(ExamBuilder)? updates]) =>
      (ExamBuilder()..update(updates))._build();

  _$Exam._({
    this.id,
    this.content,
    this.score,
    this.examType,
    required this.stageSubject,
  }) : super._();
  @override
  Exam rebuild(void Function(ExamBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExamBuilder toBuilder() => ExamBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Exam &&
        id == other.id &&
        content == other.content &&
        score == other.score &&
        examType == other.examType &&
        stageSubject == other.stageSubject;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, examType.hashCode);
    _$hash = $jc(_$hash, stageSubject.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Exam')
          ..add('id', id)
          ..add('content', content)
          ..add('score', score)
          ..add('examType', examType)
          ..add('stageSubject', stageSubject))
        .toString();
  }
}

class ExamBuilder implements Builder<Exam, ExamBuilder> {
  _$Exam? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  ExamTypeBuilder? _examType;
  ExamTypeBuilder get examType => _$this._examType ??= ExamTypeBuilder();
  set examType(ExamTypeBuilder? examType) => _$this._examType = examType;

  StageSubjectModelBuilder? _stageSubject;
  StageSubjectModelBuilder get stageSubject =>
      _$this._stageSubject ??= StageSubjectModelBuilder();
  set stageSubject(StageSubjectModelBuilder? stageSubject) =>
      _$this._stageSubject = stageSubject;

  ExamBuilder();

  ExamBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _content = $v.content;
      _score = $v.score;
      _examType = $v.examType?.toBuilder();
      _stageSubject = $v.stageSubject.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Exam other) {
    _$v = other as _$Exam;
  }

  @override
  void update(void Function(ExamBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Exam build() => _build();

  _$Exam _build() {
    _$Exam _$result;
    try {
      _$result =
          _$v ??
          _$Exam._(
            id: id,
            content: content,
            score: score,
            examType: _examType?.build(),
            stageSubject: stageSubject.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'examType';
        _examType?.build();
        _$failedField = 'stageSubject';
        stageSubject.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(r'Exam', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

class _$ExamType extends ExamType {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? schoolId;

  factory _$ExamType([void Function(ExamTypeBuilder)? updates]) =>
      (ExamTypeBuilder()..update(updates))._build();

  _$ExamType._({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.schoolId,
  }) : super._();
  @override
  ExamType rebuild(void Function(ExamTypeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExamTypeBuilder toBuilder() => ExamTypeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExamType &&
        id == other.id &&
        name == other.name &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        schoolId == other.schoolId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExamType')
          ..add('id', id)
          ..add('name', name)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('schoolId', schoolId))
        .toString();
  }
}

class ExamTypeBuilder implements Builder<ExamType, ExamTypeBuilder> {
  _$ExamType? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  ExamTypeBuilder();

  ExamTypeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _schoolId = $v.schoolId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExamType other) {
    _$v = other as _$ExamType;
  }

  @override
  void update(void Function(ExamTypeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExamType build() => _build();

  _$ExamType _build() {
    final _$result =
        _$v ??
        _$ExamType._(
          id: id,
          name: name,
          createdAt: createdAt,
          updatedAt: updatedAt,
          schoolId: schoolId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'degrees_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<DegreesModel> _$degreesModelSerializer = _$DegreesModelSerializer();

class _$DegreesModelSerializer implements StructuredSerializer<DegreesModel> {
  @override
  final Iterable<Type> types = const [DegreesModel, _$DegreesModel];
  @override
  final String wireName = 'DegreesModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    DegreesModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'score',
      serializers.serialize(object.score, specifiedType: const FullType(int)),
      'notes',
      serializers.serialize(
        object.notes,
        specifiedType: const FullType(String),
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
    value = object.examSectionId;
    if (value != null) {
      result
        ..add('examSectionId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.student;
    if (value != null) {
      result
        ..add('Student')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(StudentModel),
          ),
        );
    }
    value = object.examSection;
    if (value != null) {
      result
        ..add('ExamSection')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(ExamSectionModel),
          ),
        );
    }
    return result;
  }

  @override
  DegreesModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = DegreesModelBuilder();

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
        case 'score':
          result.score =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
        case 'notes':
          result.notes =
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
        case 'examSectionId':
          result.examSectionId =
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
        case 'ExamSection':
          result.examSection.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(ExamSectionModel),
                )!
                as ExamSectionModel,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$DegreesModel extends DegreesModel {
  @override
  final String id;
  @override
  final int score;
  @override
  final String notes;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? studentId;
  @override
  final String? examSectionId;
  @override
  final StudentModel? student;
  @override
  final ExamSectionModel? examSection;

  factory _$DegreesModel([void Function(DegreesModelBuilder)? updates]) =>
      (DegreesModelBuilder()..update(updates))._build();

  _$DegreesModel._({
    required this.id,
    required this.score,
    required this.notes,
    this.createdAt,
    this.updatedAt,
    this.studentId,
    this.examSectionId,
    this.student,
    this.examSection,
  }) : super._();
  @override
  DegreesModel rebuild(void Function(DegreesModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  DegreesModelBuilder toBuilder() => DegreesModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is DegreesModel &&
        id == other.id &&
        score == other.score &&
        notes == other.notes &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        studentId == other.studentId &&
        examSectionId == other.examSectionId &&
        student == other.student &&
        examSection == other.examSection;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, studentId.hashCode);
    _$hash = $jc(_$hash, examSectionId.hashCode);
    _$hash = $jc(_$hash, student.hashCode);
    _$hash = $jc(_$hash, examSection.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'DegreesModel')
          ..add('id', id)
          ..add('score', score)
          ..add('notes', notes)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('studentId', studentId)
          ..add('examSectionId', examSectionId)
          ..add('student', student)
          ..add('examSection', examSection))
        .toString();
  }
}

class DegreesModelBuilder
    implements Builder<DegreesModel, DegreesModelBuilder> {
  _$DegreesModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _score;
  int? get score => _$this._score;
  set score(int? score) => _$this._score = score;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _studentId;
  String? get studentId => _$this._studentId;
  set studentId(String? studentId) => _$this._studentId = studentId;

  String? _examSectionId;
  String? get examSectionId => _$this._examSectionId;
  set examSectionId(String? examSectionId) =>
      _$this._examSectionId = examSectionId;

  StudentModelBuilder? _student;
  StudentModelBuilder get student => _$this._student ??= StudentModelBuilder();
  set student(StudentModelBuilder? student) => _$this._student = student;

  ExamSectionModelBuilder? _examSection;
  ExamSectionModelBuilder get examSection =>
      _$this._examSection ??= ExamSectionModelBuilder();
  set examSection(ExamSectionModelBuilder? examSection) =>
      _$this._examSection = examSection;

  DegreesModelBuilder();

  DegreesModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _score = $v.score;
      _notes = $v.notes;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _studentId = $v.studentId;
      _examSectionId = $v.examSectionId;
      _student = $v.student?.toBuilder();
      _examSection = $v.examSection?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(DegreesModel other) {
    _$v = other as _$DegreesModel;
  }

  @override
  void update(void Function(DegreesModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  DegreesModel build() => _build();

  _$DegreesModel _build() {
    _$DegreesModel _$result;
    try {
      _$result =
          _$v ??
          _$DegreesModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'DegreesModel',
              'id',
            ),
            score: BuiltValueNullFieldError.checkNotNull(
              score,
              r'DegreesModel',
              'score',
            ),
            notes: BuiltValueNullFieldError.checkNotNull(
              notes,
              r'DegreesModel',
              'notes',
            ),
            createdAt: createdAt,
            updatedAt: updatedAt,
            studentId: studentId,
            examSectionId: examSectionId,
            student: _student?.build(),
            examSection: _examSection?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'student';
        _student?.build();
        _$failedField = 'examSection';
        _examSection?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'DegreesModel',
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

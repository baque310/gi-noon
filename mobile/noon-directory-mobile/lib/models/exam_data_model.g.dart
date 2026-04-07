// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_data_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ExamDataModel> _$examDataModelSerializer =
    _$ExamDataModelSerializer();

class _$ExamDataModelSerializer implements StructuredSerializer<ExamDataModel> {
  @override
  final Iterable<Type> types = const [ExamDataModel, _$ExamDataModel];
  @override
  final String wireName = 'ExamDataModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ExamDataModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'content',
      serializers.serialize(
        object.content,
        specifiedType: const FullType(String),
      ),
      'score',
      serializers.serialize(
        object.score,
        specifiedType: const FullType(double),
      ),
      'stageSubject',
      serializers.serialize(
        object.stageSubject,
        specifiedType: const FullType(StageSubjectModel),
      ),
      'examSections',
      serializers.serialize(
        object.examSections,
        specifiedType: const FullType(BuiltList, const [
          const FullType(ExamSectionModel),
        ]),
      ),
      'schoolYear',
      serializers.serialize(
        object.schoolYear,
        specifiedType: const FullType(SchoolYear),
      ),
    ];
    Object? value;
    value = object.originalScore;
    if (value != null) {
      result
        ..add('orignalScore')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.teacherName;
    if (value != null) {
      result
        ..add('teacherName')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.done;
    if (value != null) {
      result
        ..add('done')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(bool)),
        );
    }
    return result;
  }

  @override
  ExamDataModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExamDataModelBuilder();

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
        case 'content':
          result.content =
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
                    specifiedType: const FullType(double),
                  )!
                  as double;
          break;
        case 'orignalScore':
          result.originalScore =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'teacherName':
          result.teacherName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'done':
          result.done =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )
                  as bool?;
          break;
        case 'stageSubject':
          result.stageSubject.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(StageSubjectModel),
                )!
                as StageSubjectModel,
          );
          break;
        case 'examSections':
          result.examSections.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(ExamSectionModel),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'schoolYear':
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

class _$ExamDataModel extends ExamDataModel {
  @override
  final String id;
  @override
  final String content;
  @override
  final double score;
  @override
  final int? originalScore;
  @override
  final String? teacherName;
  @override
  final bool? done;
  @override
  final StageSubjectModel stageSubject;
  @override
  final BuiltList<ExamSectionModel> examSections;
  @override
  final SchoolYear schoolYear;

  factory _$ExamDataModel([void Function(ExamDataModelBuilder)? updates]) =>
      (ExamDataModelBuilder()..update(updates))._build();

  _$ExamDataModel._({
    required this.id,
    required this.content,
    required this.score,
    this.originalScore,
    this.teacherName,
    this.done,
    required this.stageSubject,
    required this.examSections,
    required this.schoolYear,
  }) : super._();
  @override
  ExamDataModel rebuild(void Function(ExamDataModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExamDataModelBuilder toBuilder() => ExamDataModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExamDataModel &&
        id == other.id &&
        content == other.content &&
        score == other.score &&
        originalScore == other.originalScore &&
        teacherName == other.teacherName &&
        done == other.done &&
        stageSubject == other.stageSubject &&
        examSections == other.examSections &&
        schoolYear == other.schoolYear;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, score.hashCode);
    _$hash = $jc(_$hash, originalScore.hashCode);
    _$hash = $jc(_$hash, teacherName.hashCode);
    _$hash = $jc(_$hash, done.hashCode);
    _$hash = $jc(_$hash, stageSubject.hashCode);
    _$hash = $jc(_$hash, examSections.hashCode);
    _$hash = $jc(_$hash, schoolYear.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExamDataModel')
          ..add('id', id)
          ..add('content', content)
          ..add('score', score)
          ..add('originalScore', originalScore)
          ..add('teacherName', teacherName)
          ..add('done', done)
          ..add('stageSubject', stageSubject)
          ..add('examSections', examSections)
          ..add('schoolYear', schoolYear))
        .toString();
  }
}

class ExamDataModelBuilder
    implements Builder<ExamDataModel, ExamDataModelBuilder> {
  _$ExamDataModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  double? _score;
  double? get score => _$this._score;
  set score(double? score) => _$this._score = score;

  int? _originalScore;
  int? get originalScore => _$this._originalScore;
  set originalScore(int? originalScore) =>
      _$this._originalScore = originalScore;

  String? _teacherName;
  String? get teacherName => _$this._teacherName;
  set teacherName(String? teacherName) => _$this._teacherName = teacherName;

  bool? _done;
  bool? get done => _$this._done;
  set done(bool? done) => _$this._done = done;

  StageSubjectModelBuilder? _stageSubject;
  StageSubjectModelBuilder get stageSubject =>
      _$this._stageSubject ??= StageSubjectModelBuilder();
  set stageSubject(StageSubjectModelBuilder? stageSubject) =>
      _$this._stageSubject = stageSubject;

  ListBuilder<ExamSectionModel>? _examSections;
  ListBuilder<ExamSectionModel> get examSections =>
      _$this._examSections ??= ListBuilder<ExamSectionModel>();
  set examSections(ListBuilder<ExamSectionModel>? examSections) =>
      _$this._examSections = examSections;

  SchoolYearBuilder? _schoolYear;
  SchoolYearBuilder get schoolYear =>
      _$this._schoolYear ??= SchoolYearBuilder();
  set schoolYear(SchoolYearBuilder? schoolYear) =>
      _$this._schoolYear = schoolYear;

  ExamDataModelBuilder();

  ExamDataModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _content = $v.content;
      _score = $v.score;
      _originalScore = $v.originalScore;
      _teacherName = $v.teacherName;
      _done = $v.done;
      _stageSubject = $v.stageSubject.toBuilder();
      _examSections = $v.examSections.toBuilder();
      _schoolYear = $v.schoolYear.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExamDataModel other) {
    _$v = other as _$ExamDataModel;
  }

  @override
  void update(void Function(ExamDataModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExamDataModel build() => _build();

  _$ExamDataModel _build() {
    _$ExamDataModel _$result;
    try {
      _$result =
          _$v ??
          _$ExamDataModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'ExamDataModel',
              'id',
            ),
            content: BuiltValueNullFieldError.checkNotNull(
              content,
              r'ExamDataModel',
              'content',
            ),
            score: BuiltValueNullFieldError.checkNotNull(
              score,
              r'ExamDataModel',
              'score',
            ),
            originalScore: originalScore,
            teacherName: teacherName,
            done: done,
            stageSubject: stageSubject.build(),
            examSections: examSections.build(),
            schoolYear: schoolYear.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stageSubject';
        stageSubject.build();
        _$failedField = 'examSections';
        examSections.build();
        _$failedField = 'schoolYear';
        schoolYear.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ExamDataModel',
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage_subject_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<StageSubjectModel> _$stageSubjectModelSerializer =
    _$StageSubjectModelSerializer();

class _$StageSubjectModelSerializer
    implements StructuredSerializer<StageSubjectModel> {
  @override
  final Iterable<Type> types = const [StageSubjectModel, _$StageSubjectModel];
  @override
  final String wireName = 'StageSubjectModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    StageSubjectModel object, {
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
    value = object.stage;
    if (value != null) {
      result
        ..add('Stage')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(Stage)),
        );
    }
    value = object.classDetail;
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
    value = object.subject;
    if (value != null) {
      result
        ..add('Subject')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(Subject)),
        );
    }
    value = object.teachers;
    if (value != null) {
      result
        ..add('TeacherSubject')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(TeacherSubject),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  StageSubjectModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = StageSubjectModelBuilder();

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
          result.classDetail.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(ClassInfo),
                )!
                as ClassInfo,
          );
          break;
        case 'Subject':
          result.subject.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(Subject),
                )!
                as Subject,
          );
          break;
        case 'TeacherSubject':
          result.teachers.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(TeacherSubject),
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

class _$StageSubjectModel extends StageSubjectModel {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final Stage? stage;
  @override
  final ClassInfo? classDetail;
  @override
  final Subject? subject;
  @override
  final BuiltList<TeacherSubject>? teachers;

  factory _$StageSubjectModel([
    void Function(StageSubjectModelBuilder)? updates,
  ]) => (StageSubjectModelBuilder()..update(updates))._build();

  _$StageSubjectModel._({
    this.id,
    this.name,
    this.stage,
    this.classDetail,
    this.subject,
    this.teachers,
  }) : super._();
  @override
  StageSubjectModel rebuild(void Function(StageSubjectModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  StageSubjectModelBuilder toBuilder() =>
      StageSubjectModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StageSubjectModel &&
        id == other.id &&
        name == other.name &&
        stage == other.stage &&
        classDetail == other.classDetail &&
        subject == other.subject &&
        teachers == other.teachers;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, stage.hashCode);
    _$hash = $jc(_$hash, classDetail.hashCode);
    _$hash = $jc(_$hash, subject.hashCode);
    _$hash = $jc(_$hash, teachers.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'StageSubjectModel')
          ..add('id', id)
          ..add('name', name)
          ..add('stage', stage)
          ..add('classDetail', classDetail)
          ..add('subject', subject)
          ..add('teachers', teachers))
        .toString();
  }
}

class StageSubjectModelBuilder
    implements Builder<StageSubjectModel, StageSubjectModelBuilder> {
  _$StageSubjectModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  StageBuilder? _stage;
  StageBuilder get stage => _$this._stage ??= StageBuilder();
  set stage(StageBuilder? stage) => _$this._stage = stage;

  ClassInfoBuilder? _classDetail;
  ClassInfoBuilder get classDetail =>
      _$this._classDetail ??= ClassInfoBuilder();
  set classDetail(ClassInfoBuilder? classDetail) =>
      _$this._classDetail = classDetail;

  SubjectBuilder? _subject;
  SubjectBuilder get subject => _$this._subject ??= SubjectBuilder();
  set subject(SubjectBuilder? subject) => _$this._subject = subject;

  ListBuilder<TeacherSubject>? _teachers;
  ListBuilder<TeacherSubject> get teachers =>
      _$this._teachers ??= ListBuilder<TeacherSubject>();
  set teachers(ListBuilder<TeacherSubject>? teachers) =>
      _$this._teachers = teachers;

  StageSubjectModelBuilder();

  StageSubjectModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _stage = $v.stage?.toBuilder();
      _classDetail = $v.classDetail?.toBuilder();
      _subject = $v.subject?.toBuilder();
      _teachers = $v.teachers?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(StageSubjectModel other) {
    _$v = other as _$StageSubjectModel;
  }

  @override
  void update(void Function(StageSubjectModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  StageSubjectModel build() => _build();

  _$StageSubjectModel _build() {
    _$StageSubjectModel _$result;
    try {
      _$result =
          _$v ??
          _$StageSubjectModel._(
            id: id,
            name: name,
            stage: _stage?.build(),
            classDetail: _classDetail?.build(),
            subject: _subject?.build(),
            teachers: _teachers?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stage';
        _stage?.build();
        _$failedField = 'classDetail';
        _classDetail?.build();
        _$failedField = 'subject';
        _subject?.build();
        _$failedField = 'teachers';
        _teachers?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'StageSubjectModel',
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_subject_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LessonSubjectModel> _$lessonSubjectModelSerializer =
    _$LessonSubjectModelSerializer();

class _$LessonSubjectModelSerializer
    implements StructuredSerializer<LessonSubjectModel> {
  @override
  final Iterable<Type> types = const [LessonSubjectModel, _$LessonSubjectModel];
  @override
  final String wireName = 'LessonSubjectModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    LessonSubjectModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[];
    Object? value;
    value = object.subjectId;
    if (value != null) {
      result
        ..add('subjectId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.subjectName;
    if (value != null) {
      result
        ..add('subjectName')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.lessonCount;
    if (value != null) {
      result
        ..add('lessonCount')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.lessons;
    if (value != null) {
      result
        ..add('lessons')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(LessonModel),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  LessonSubjectModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LessonSubjectModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case 'subjectId':
          result.subjectId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'subjectName':
          result.subjectName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'lessonCount':
          result.lessonCount =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'lessons':
          result.lessons.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(LessonModel),
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

class _$LessonSubjectModel extends LessonSubjectModel {
  @override
  final String? subjectId;
  @override
  final String? subjectName;
  @override
  final int? lessonCount;
  @override
  final BuiltList<LessonModel>? lessons;

  factory _$LessonSubjectModel([
    void Function(LessonSubjectModelBuilder)? updates,
  ]) => (LessonSubjectModelBuilder()..update(updates))._build();

  _$LessonSubjectModel._({
    this.subjectId,
    this.subjectName,
    this.lessonCount,
    this.lessons,
  }) : super._();
  @override
  LessonSubjectModel rebuild(
    void Function(LessonSubjectModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  LessonSubjectModelBuilder toBuilder() =>
      LessonSubjectModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LessonSubjectModel &&
        subjectId == other.subjectId &&
        subjectName == other.subjectName &&
        lessonCount == other.lessonCount &&
        lessons == other.lessons;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subjectId.hashCode);
    _$hash = $jc(_$hash, subjectName.hashCode);
    _$hash = $jc(_$hash, lessonCount.hashCode);
    _$hash = $jc(_$hash, lessons.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LessonSubjectModel')
          ..add('subjectId', subjectId)
          ..add('subjectName', subjectName)
          ..add('lessonCount', lessonCount)
          ..add('lessons', lessons))
        .toString();
  }
}

class LessonSubjectModelBuilder
    implements Builder<LessonSubjectModel, LessonSubjectModelBuilder> {
  _$LessonSubjectModel? _$v;

  String? _subjectId;
  String? get subjectId => _$this._subjectId;
  set subjectId(String? subjectId) => _$this._subjectId = subjectId;

  String? _subjectName;
  String? get subjectName => _$this._subjectName;
  set subjectName(String? subjectName) => _$this._subjectName = subjectName;

  int? _lessonCount;
  int? get lessonCount => _$this._lessonCount;
  set lessonCount(int? lessonCount) => _$this._lessonCount = lessonCount;

  ListBuilder<LessonModel>? _lessons;
  ListBuilder<LessonModel> get lessons =>
      _$this._lessons ??= ListBuilder<LessonModel>();
  set lessons(ListBuilder<LessonModel>? lessons) => _$this._lessons = lessons;

  LessonSubjectModelBuilder();

  LessonSubjectModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subjectId = $v.subjectId;
      _subjectName = $v.subjectName;
      _lessonCount = $v.lessonCount;
      _lessons = $v.lessons?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LessonSubjectModel other) {
    _$v = other as _$LessonSubjectModel;
  }

  @override
  void update(void Function(LessonSubjectModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LessonSubjectModel build() => _build();

  _$LessonSubjectModel _build() {
    _$LessonSubjectModel _$result;
    try {
      _$result =
          _$v ??
          _$LessonSubjectModel._(
            subjectId: subjectId,
            subjectName: subjectName,
            lessonCount: lessonCount,
            lessons: _lessons?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lessons';
        _lessons?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'LessonSubjectModel',
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'homework_subject_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<HomeworkSubjectModel> _$homeworkSubjectModelSerializer =
    _$HomeworkSubjectModelSerializer();

class _$HomeworkSubjectModelSerializer
    implements StructuredSerializer<HomeworkSubjectModel> {
  @override
  final Iterable<Type> types = const [
    HomeworkSubjectModel,
    _$HomeworkSubjectModel,
  ];
  @override
  final String wireName = 'HomeworkSubjectModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    HomeworkSubjectModel object, {
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
    value = object.homeworkCount;
    if (value != null) {
      result
        ..add('homeworkCount')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.homeworks;
    if (value != null) {
      result
        ..add('homeworks')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(HomeworkModel),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  HomeworkSubjectModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HomeworkSubjectModelBuilder();

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
        case 'homeworkCount':
          result.homeworkCount =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'homeworks':
          result.homeworks.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(HomeworkModel),
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

class _$HomeworkSubjectModel extends HomeworkSubjectModel {
  @override
  final String? subjectId;
  @override
  final String? subjectName;
  @override
  final int? homeworkCount;
  @override
  final BuiltList<HomeworkModel>? homeworks;

  factory _$HomeworkSubjectModel([
    void Function(HomeworkSubjectModelBuilder)? updates,
  ]) => (HomeworkSubjectModelBuilder()..update(updates))._build();

  _$HomeworkSubjectModel._({
    this.subjectId,
    this.subjectName,
    this.homeworkCount,
    this.homeworks,
  }) : super._();
  @override
  HomeworkSubjectModel rebuild(
    void Function(HomeworkSubjectModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  HomeworkSubjectModelBuilder toBuilder() =>
      HomeworkSubjectModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HomeworkSubjectModel &&
        subjectId == other.subjectId &&
        subjectName == other.subjectName &&
        homeworkCount == other.homeworkCount &&
        homeworks == other.homeworks;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, subjectId.hashCode);
    _$hash = $jc(_$hash, subjectName.hashCode);
    _$hash = $jc(_$hash, homeworkCount.hashCode);
    _$hash = $jc(_$hash, homeworks.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HomeworkSubjectModel')
          ..add('subjectId', subjectId)
          ..add('subjectName', subjectName)
          ..add('homeworkCount', homeworkCount)
          ..add('homeworks', homeworks))
        .toString();
  }
}

class HomeworkSubjectModelBuilder
    implements Builder<HomeworkSubjectModel, HomeworkSubjectModelBuilder> {
  _$HomeworkSubjectModel? _$v;

  String? _subjectId;
  String? get subjectId => _$this._subjectId;
  set subjectId(String? subjectId) => _$this._subjectId = subjectId;

  String? _subjectName;
  String? get subjectName => _$this._subjectName;
  set subjectName(String? subjectName) => _$this._subjectName = subjectName;

  int? _homeworkCount;
  int? get homeworkCount => _$this._homeworkCount;
  set homeworkCount(int? homeworkCount) =>
      _$this._homeworkCount = homeworkCount;

  ListBuilder<HomeworkModel>? _homeworks;
  ListBuilder<HomeworkModel> get homeworks =>
      _$this._homeworks ??= ListBuilder<HomeworkModel>();
  set homeworks(ListBuilder<HomeworkModel>? homeworks) =>
      _$this._homeworks = homeworks;

  HomeworkSubjectModelBuilder();

  HomeworkSubjectModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _subjectId = $v.subjectId;
      _subjectName = $v.subjectName;
      _homeworkCount = $v.homeworkCount;
      _homeworks = $v.homeworks?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HomeworkSubjectModel other) {
    _$v = other as _$HomeworkSubjectModel;
  }

  @override
  void update(void Function(HomeworkSubjectModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HomeworkSubjectModel build() => _build();

  _$HomeworkSubjectModel _build() {
    _$HomeworkSubjectModel _$result;
    try {
      _$result =
          _$v ??
          _$HomeworkSubjectModel._(
            subjectId: subjectId,
            subjectName: subjectName,
            homeworkCount: homeworkCount,
            homeworks: _homeworks?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'homeworks';
        _homeworks?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'HomeworkSubjectModel',
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

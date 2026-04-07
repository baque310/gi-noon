// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_teacher_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ExamTeacherModel> _$examTeacherModelSerializer =
    _$ExamTeacherModelSerializer();

class _$ExamTeacherModelSerializer
    implements StructuredSerializer<ExamTeacherModel> {
  @override
  final Iterable<Type> types = const [ExamTeacherModel, _$ExamTeacherModel];
  @override
  final String wireName = 'ExamTeacherModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ExamTeacherModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'fullName',
      serializers.serialize(
        object.fullName,
        specifiedType: const FullType(String),
      ),
    ];

    return result;
  }

  @override
  ExamTeacherModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ExamTeacherModelBuilder();

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
        case 'fullName':
          result.fullName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ExamTeacherModel extends ExamTeacherModel {
  @override
  final String id;
  @override
  final String fullName;

  factory _$ExamTeacherModel([
    void Function(ExamTeacherModelBuilder)? updates,
  ]) => (ExamTeacherModelBuilder()..update(updates))._build();

  _$ExamTeacherModel._({required this.id, required this.fullName}) : super._();
  @override
  ExamTeacherModel rebuild(void Function(ExamTeacherModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ExamTeacherModelBuilder toBuilder() =>
      ExamTeacherModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ExamTeacherModel &&
        id == other.id &&
        fullName == other.fullName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ExamTeacherModel')
          ..add('id', id)
          ..add('fullName', fullName))
        .toString();
  }
}

class ExamTeacherModelBuilder
    implements Builder<ExamTeacherModel, ExamTeacherModelBuilder> {
  _$ExamTeacherModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  ExamTeacherModelBuilder();

  ExamTeacherModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fullName = $v.fullName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ExamTeacherModel other) {
    _$v = other as _$ExamTeacherModel;
  }

  @override
  void update(void Function(ExamTeacherModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ExamTeacherModel build() => _build();

  _$ExamTeacherModel _build() {
    final _$result =
        _$v ??
        _$ExamTeacherModel._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ExamTeacherModel',
            'id',
          ),
          fullName: BuiltValueNullFieldError.checkNotNull(
            fullName,
            r'ExamTeacherModel',
            'fullName',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

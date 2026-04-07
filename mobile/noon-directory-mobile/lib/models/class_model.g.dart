// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ClassInfo> _$classInfoSerializer = _$ClassInfoSerializer();

class _$ClassInfoSerializer implements StructuredSerializer<ClassInfo> {
  @override
  final Iterable<Type> types = const [ClassInfo, _$ClassInfo];
  @override
  final String wireName = 'ClassInfo';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ClassInfo object, {
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
    return result;
  }

  @override
  ClassInfo deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ClassInfoBuilder();

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
      }
    }

    return result.build();
  }
}

class _$ClassInfo extends ClassInfo {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final Stage? stage;

  factory _$ClassInfo([void Function(ClassInfoBuilder)? updates]) =>
      (ClassInfoBuilder()..update(updates))._build();

  _$ClassInfo._({this.id, this.name, this.stage}) : super._();
  @override
  ClassInfo rebuild(void Function(ClassInfoBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ClassInfoBuilder toBuilder() => ClassInfoBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ClassInfo &&
        id == other.id &&
        name == other.name &&
        stage == other.stage;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, stage.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ClassInfo')
          ..add('id', id)
          ..add('name', name)
          ..add('stage', stage))
        .toString();
  }
}

class ClassInfoBuilder implements Builder<ClassInfo, ClassInfoBuilder> {
  _$ClassInfo? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  StageBuilder? _stage;
  StageBuilder get stage => _$this._stage ??= StageBuilder();
  set stage(StageBuilder? stage) => _$this._stage = stage;

  ClassInfoBuilder();

  ClassInfoBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _stage = $v.stage?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ClassInfo other) {
    _$v = other as _$ClassInfo;
  }

  @override
  void update(void Function(ClassInfoBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ClassInfo build() => _build();

  _$ClassInfo _build() {
    _$ClassInfo _$result;
    try {
      _$result =
          _$v ?? _$ClassInfo._(id: id, name: name, stage: _stage?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'stage';
        _stage?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ClassInfo',
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

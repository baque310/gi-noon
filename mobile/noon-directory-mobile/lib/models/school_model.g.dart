// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SchoolModel> _$schoolModelSerializer = _$SchoolModelSerializer();

class _$SchoolModelSerializer implements StructuredSerializer<SchoolModel> {
  @override
  final Iterable<Type> types = const [SchoolModel, _$SchoolModel];
  @override
  final String wireName = 'SchoolModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    SchoolModel object, {
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
    return result;
  }

  @override
  SchoolModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SchoolModelBuilder();

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
      }
    }

    return result.build();
  }
}

class _$SchoolModel extends SchoolModel {
  @override
  final String? id;
  @override
  final String? name;

  factory _$SchoolModel([void Function(SchoolModelBuilder)? updates]) =>
      (SchoolModelBuilder()..update(updates))._build();

  _$SchoolModel._({this.id, this.name}) : super._();
  @override
  SchoolModel rebuild(void Function(SchoolModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SchoolModelBuilder toBuilder() => SchoolModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SchoolModel && id == other.id && name == other.name;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SchoolModel')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class SchoolModelBuilder implements Builder<SchoolModel, SchoolModelBuilder> {
  _$SchoolModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SchoolModelBuilder();

  SchoolModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SchoolModel other) {
    _$v = other as _$SchoolModel;
  }

  @override
  void update(void Function(SchoolModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SchoolModel build() => _build();

  _$SchoolModel _build() {
    final _$result = _$v ?? _$SchoolModel._(id: id, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

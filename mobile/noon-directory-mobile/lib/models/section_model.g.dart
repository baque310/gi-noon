// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'section_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Section> _$sectionSerializer = _$SectionSerializer();

class _$SectionSerializer implements StructuredSerializer<Section> {
  @override
  final Iterable<Type> types = const [Section, _$Section];
  @override
  final String wireName = 'Section';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    Section object, {
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
    value = object.classInfo;
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
    return result;
  }

  @override
  Section deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SectionBuilder();

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
        case 'Class':
          result.classInfo.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(ClassInfo),
                )!
                as ClassInfo,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$Section extends Section {
  @override
  final String? id;
  @override
  final String? name;
  @override
  final ClassInfo? classInfo;

  factory _$Section([void Function(SectionBuilder)? updates]) =>
      (SectionBuilder()..update(updates))._build();

  _$Section._({this.id, this.name, this.classInfo}) : super._();
  @override
  Section rebuild(void Function(SectionBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SectionBuilder toBuilder() => SectionBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Section &&
        id == other.id &&
        name == other.name &&
        classInfo == other.classInfo;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, classInfo.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Section')
          ..add('id', id)
          ..add('name', name)
          ..add('classInfo', classInfo))
        .toString();
  }
}

class SectionBuilder implements Builder<Section, SectionBuilder> {
  _$Section? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  ClassInfoBuilder? _classInfo;
  ClassInfoBuilder get classInfo => _$this._classInfo ??= ClassInfoBuilder();
  set classInfo(ClassInfoBuilder? classInfo) => _$this._classInfo = classInfo;

  SectionBuilder();

  SectionBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _classInfo = $v.classInfo?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Section other) {
    _$v = other as _$Section;
  }

  @override
  void update(void Function(SectionBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Section build() => _build();

  _$Section _build() {
    _$Section _$result;
    try {
      _$result =
          _$v ??
          _$Section._(id: id, name: name, classInfo: _classInfo?.build());
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'classInfo';
        _classInfo?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'Section',
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

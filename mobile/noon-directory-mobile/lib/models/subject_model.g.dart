// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Subject> _$subjectSerializer = _$SubjectSerializer();

class _$SubjectSerializer implements StructuredSerializer<Subject> {
  @override
  final Iterable<Type> types = const [Subject, _$Subject];
  @override
  final String wireName = 'Subject';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    Subject object, {
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
  Subject deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SubjectBuilder();

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

class _$Subject extends Subject {
  @override
  final String? id;
  @override
  final String? name;

  factory _$Subject([void Function(SubjectBuilder)? updates]) =>
      (SubjectBuilder()..update(updates))._build();

  _$Subject._({this.id, this.name}) : super._();
  @override
  Subject rebuild(void Function(SubjectBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SubjectBuilder toBuilder() => SubjectBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Subject && id == other.id && name == other.name;
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
    return (newBuiltValueToStringHelper(r'Subject')
          ..add('id', id)
          ..add('name', name))
        .toString();
  }
}

class SubjectBuilder implements Builder<Subject, SubjectBuilder> {
  _$Subject? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  SubjectBuilder();

  SubjectBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _name = $v.name;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Subject other) {
    _$v = other as _$Subject;
  }

  @override
  void update(void Function(SubjectBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Subject build() => _build();

  _$Subject _build() {
    final _$result = _$v ?? _$Subject._(id: id, name: name);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school_year_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<SchoolYear> _$schoolYearSerializer = _$SchoolYearSerializer();

class _$SchoolYearSerializer implements StructuredSerializer<SchoolYear> {
  @override
  final Iterable<Type> types = const [SchoolYear, _$SchoolYear];
  @override
  final String wireName = 'SchoolYear';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    SchoolYear object, {
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
    value = object.from;
    if (value != null) {
      result
        ..add('from')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.to;
    if (value != null) {
      result
        ..add('to')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  SchoolYear deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SchoolYearBuilder();

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
        case 'from':
          result.from =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'to':
          result.to =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
      }
    }

    return result.build();
  }
}

class _$SchoolYear extends SchoolYear {
  @override
  final String? id;
  @override
  final int? from;
  @override
  final int? to;

  factory _$SchoolYear([void Function(SchoolYearBuilder)? updates]) =>
      (SchoolYearBuilder()..update(updates))._build();

  _$SchoolYear._({this.id, this.from, this.to}) : super._();
  @override
  SchoolYear rebuild(void Function(SchoolYearBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SchoolYearBuilder toBuilder() => SchoolYearBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SchoolYear &&
        id == other.id &&
        from == other.from &&
        to == other.to;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, from.hashCode);
    _$hash = $jc(_$hash, to.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SchoolYear')
          ..add('id', id)
          ..add('from', from)
          ..add('to', to))
        .toString();
  }
}

class SchoolYearBuilder implements Builder<SchoolYear, SchoolYearBuilder> {
  _$SchoolYear? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  int? _from;
  int? get from => _$this._from;
  set from(int? from) => _$this._from = from;

  int? _to;
  int? get to => _$this._to;
  set to(int? to) => _$this._to = to;

  SchoolYearBuilder();

  SchoolYearBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _from = $v.from;
      _to = $v.to;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SchoolYear other) {
    _$v = other as _$SchoolYear;
  }

  @override
  void update(void Function(SchoolYearBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SchoolYear build() => _build();

  _$SchoolYear _build() {
    final _$result = _$v ?? _$SchoolYear._(id: id, from: from, to: to);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

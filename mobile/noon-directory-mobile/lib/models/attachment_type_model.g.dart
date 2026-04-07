// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_type_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AttachmentTypeModel> _$attachmentTypeModelSerializer =
    _$AttachmentTypeModelSerializer();

class _$AttachmentTypeModelSerializer
    implements StructuredSerializer<AttachmentTypeModel> {
  @override
  final Iterable<Type> types = const [
    AttachmentTypeModel,
    _$AttachmentTypeModel,
  ];
  @override
  final String wireName = 'AttachmentTypeModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    AttachmentTypeModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'title',
      serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      ),
    ];
    Object? value;
    value = object.id;
    if (value != null) {
      result
        ..add('id')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.category;
    if (value != null) {
      result
        ..add('category')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.numberOfSides;
    if (value != null) {
      result
        ..add('numberOfSides')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    return result;
  }

  @override
  AttachmentTypeModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttachmentTypeModelBuilder();

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
        case 'title':
          result.title =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'category':
          result.category =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'numberOfSides':
          result.numberOfSides =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
      }
    }

    return result.build();
  }
}

class _$AttachmentTypeModel extends AttachmentTypeModel {
  @override
  final String? id;
  @override
  final String title;
  @override
  final String? category;
  @override
  final int? numberOfSides;

  factory _$AttachmentTypeModel([
    void Function(AttachmentTypeModelBuilder)? updates,
  ]) => (AttachmentTypeModelBuilder()..update(updates))._build();

  _$AttachmentTypeModel._({
    this.id,
    required this.title,
    this.category,
    this.numberOfSides,
  }) : super._();
  @override
  AttachmentTypeModel rebuild(
    void Function(AttachmentTypeModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  AttachmentTypeModelBuilder toBuilder() =>
      AttachmentTypeModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttachmentTypeModel &&
        id == other.id &&
        title == other.title &&
        category == other.category &&
        numberOfSides == other.numberOfSides;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, category.hashCode);
    _$hash = $jc(_$hash, numberOfSides.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AttachmentTypeModel')
          ..add('id', id)
          ..add('title', title)
          ..add('category', category)
          ..add('numberOfSides', numberOfSides))
        .toString();
  }
}

class AttachmentTypeModelBuilder
    implements Builder<AttachmentTypeModel, AttachmentTypeModelBuilder> {
  _$AttachmentTypeModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _category;
  String? get category => _$this._category;
  set category(String? category) => _$this._category = category;

  int? _numberOfSides;
  int? get numberOfSides => _$this._numberOfSides;
  set numberOfSides(int? numberOfSides) =>
      _$this._numberOfSides = numberOfSides;

  AttachmentTypeModelBuilder();

  AttachmentTypeModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _category = $v.category;
      _numberOfSides = $v.numberOfSides;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttachmentTypeModel other) {
    _$v = other as _$AttachmentTypeModel;
  }

  @override
  void update(void Function(AttachmentTypeModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttachmentTypeModel build() => _build();

  _$AttachmentTypeModel _build() {
    final _$result =
        _$v ??
        _$AttachmentTypeModel._(
          id: id,
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'AttachmentTypeModel',
            'title',
          ),
          category: category,
          numberOfSides: numberOfSides,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

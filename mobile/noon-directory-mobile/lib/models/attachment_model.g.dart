// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<AttachmentModel> _$attachmentModelSerializer =
    _$AttachmentModelSerializer();

class _$AttachmentModelSerializer
    implements StructuredSerializer<AttachmentModel> {
  @override
  final Iterable<Type> types = const [AttachmentModel, _$AttachmentModel];
  @override
  final String wireName = 'AttachmentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    AttachmentModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  AttachmentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AttachmentModelBuilder();

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
        case 'url':
          result.url =
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

class _$AttachmentModel extends AttachmentModel {
  @override
  final String id;
  @override
  final String url;

  factory _$AttachmentModel([void Function(AttachmentModelBuilder)? updates]) =>
      (AttachmentModelBuilder()..update(updates))._build();

  _$AttachmentModel._({required this.id, required this.url}) : super._();
  @override
  AttachmentModel rebuild(void Function(AttachmentModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AttachmentModelBuilder toBuilder() => AttachmentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AttachmentModel && id == other.id && url == other.url;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'AttachmentModel')
          ..add('id', id)
          ..add('url', url))
        .toString();
  }
}

class AttachmentModelBuilder
    implements Builder<AttachmentModel, AttachmentModelBuilder> {
  _$AttachmentModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  AttachmentModelBuilder();

  AttachmentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _url = $v.url;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(AttachmentModel other) {
    _$v = other as _$AttachmentModel;
  }

  @override
  void update(void Function(AttachmentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AttachmentModel build() => _build();

  _$AttachmentModel _build() {
    final _$result =
        _$v ??
        _$AttachmentModel._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'AttachmentModel',
            'id',
          ),
          url: BuiltValueNullFieldError.checkNotNull(
            url,
            r'AttachmentModel',
            'url',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

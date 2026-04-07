// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationModel> _$notificationModelSerializer =
    _$NotificationModelSerializer();

class _$NotificationModelSerializer
    implements StructuredSerializer<NotificationModel> {
  @override
  final Iterable<Type> types = const [NotificationModel, _$NotificationModel];
  @override
  final String wireName = 'NotificationModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    NotificationModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'isSeen',
      serializers.serialize(
        object.isSeen,
        specifiedType: const FullType(String),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(String),
      ),
    ];
    Object? value;
    value = object.title;
    if (value != null) {
      result
        ..add('title')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.isAlert;
    if (value != null) {
      result
        ..add('isAlert')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.body;
    if (value != null) {
      result
        ..add('body')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.imageUrl;
    if (value != null) {
      result
        ..add('imageUrl')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.data;
    if (value != null) {
      result
        ..add('data')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(NotificationDataModel),
          ),
        );
    }
    return result;
  }

  @override
  NotificationModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationModelBuilder();

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
        case 'title':
          result.title =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'isSeen':
          result.isSeen =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'isAlert':
          result.isAlert =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'body':
          result.body =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'imageUrl':
          result.imageUrl =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'updatedAt':
          result.updatedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'data':
          result.data.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(NotificationDataModel),
                )!
                as NotificationDataModel,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$NotificationModel extends NotificationModel {
  @override
  final String id;
  @override
  final String? title;
  @override
  final String isSeen;
  @override
  final String? isAlert;
  @override
  final String? body;
  @override
  final String? imageUrl;
  @override
  final String updatedAt;
  @override
  final NotificationDataModel? data;

  factory _$NotificationModel([
    void Function(NotificationModelBuilder)? updates,
  ]) => (NotificationModelBuilder()..update(updates))._build();

  _$NotificationModel._({
    required this.id,
    this.title,
    required this.isSeen,
    this.isAlert,
    this.body,
    this.imageUrl,
    required this.updatedAt,
    this.data,
  }) : super._();
  @override
  NotificationModel rebuild(void Function(NotificationModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  NotificationModelBuilder toBuilder() =>
      NotificationModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationModel &&
        id == other.id &&
        title == other.title &&
        isSeen == other.isSeen &&
        isAlert == other.isAlert &&
        body == other.body &&
        imageUrl == other.imageUrl &&
        updatedAt == other.updatedAt &&
        data == other.data;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, isSeen.hashCode);
    _$hash = $jc(_$hash, isAlert.hashCode);
    _$hash = $jc(_$hash, body.hashCode);
    _$hash = $jc(_$hash, imageUrl.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationModel')
          ..add('id', id)
          ..add('title', title)
          ..add('isSeen', isSeen)
          ..add('isAlert', isAlert)
          ..add('body', body)
          ..add('imageUrl', imageUrl)
          ..add('updatedAt', updatedAt)
          ..add('data', data))
        .toString();
  }
}

class NotificationModelBuilder
    implements Builder<NotificationModel, NotificationModelBuilder> {
  _$NotificationModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _isSeen;
  String? get isSeen => _$this._isSeen;
  set isSeen(String? isSeen) => _$this._isSeen = isSeen;

  String? _isAlert;
  String? get isAlert => _$this._isAlert;
  set isAlert(String? isAlert) => _$this._isAlert = isAlert;

  String? _body;
  String? get body => _$this._body;
  set body(String? body) => _$this._body = body;

  String? _imageUrl;
  String? get imageUrl => _$this._imageUrl;
  set imageUrl(String? imageUrl) => _$this._imageUrl = imageUrl;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  NotificationDataModelBuilder? _data;
  NotificationDataModelBuilder get data =>
      _$this._data ??= NotificationDataModelBuilder();
  set data(NotificationDataModelBuilder? data) => _$this._data = data;

  NotificationModelBuilder();

  NotificationModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _isSeen = $v.isSeen;
      _isAlert = $v.isAlert;
      _body = $v.body;
      _imageUrl = $v.imageUrl;
      _updatedAt = $v.updatedAt;
      _data = $v.data?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationModel other) {
    _$v = other as _$NotificationModel;
  }

  @override
  void update(void Function(NotificationModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationModel build() => _build();

  _$NotificationModel _build() {
    _$NotificationModel _$result;
    try {
      _$result =
          _$v ??
          _$NotificationModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'NotificationModel',
              'id',
            ),
            title: title,
            isSeen: BuiltValueNullFieldError.checkNotNull(
              isSeen,
              r'NotificationModel',
              'isSeen',
            ),
            isAlert: isAlert,
            body: body,
            imageUrl: imageUrl,
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'NotificationModel',
              'updatedAt',
            ),
            data: _data?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        _data?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'NotificationModel',
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

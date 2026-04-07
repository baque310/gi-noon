// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_data_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<NotificationDataModel> _$notificationDataModelSerializer =
    _$NotificationDataModelSerializer();

class _$NotificationDataModelSerializer
    implements StructuredSerializer<NotificationDataModel> {
  @override
  final Iterable<Type> types = const [
    NotificationDataModel,
    _$NotificationDataModel,
  ];
  @override
  final String wireName = 'NotificationDataModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    NotificationDataModel object, {
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
    value = object.type;
    if (value != null) {
      result
        ..add('type')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    return result;
  }

  @override
  NotificationDataModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = NotificationDataModelBuilder();

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
        case 'type':
          result.type =
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

class _$NotificationDataModel extends NotificationDataModel {
  @override
  final String? id;
  @override
  final String? type;

  factory _$NotificationDataModel([
    void Function(NotificationDataModelBuilder)? updates,
  ]) => (NotificationDataModelBuilder()..update(updates))._build();

  _$NotificationDataModel._({this.id, this.type}) : super._();
  @override
  NotificationDataModel rebuild(
    void Function(NotificationDataModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  NotificationDataModelBuilder toBuilder() =>
      NotificationDataModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is NotificationDataModel &&
        id == other.id &&
        type == other.type;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'NotificationDataModel')
          ..add('id', id)
          ..add('type', type))
        .toString();
  }
}

class NotificationDataModelBuilder
    implements Builder<NotificationDataModel, NotificationDataModelBuilder> {
  _$NotificationDataModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  NotificationDataModelBuilder();

  NotificationDataModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _type = $v.type;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(NotificationDataModel other) {
    _$v = other as _$NotificationDataModel;
  }

  @override
  void update(void Function(NotificationDataModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  NotificationDataModel build() => _build();

  _$NotificationDataModel _build() {
    final _$result = _$v ?? _$NotificationDataModel._(id: id, type: type);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

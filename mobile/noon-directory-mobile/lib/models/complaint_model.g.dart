// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complaint_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ComplaintModel> _$complaintModelSerializer =
    _$ComplaintModelSerializer();

class _$ComplaintModelSerializer
    implements StructuredSerializer<ComplaintModel> {
  @override
  final Iterable<Type> types = const [ComplaintModel, _$ComplaintModel];
  @override
  final String wireName = 'ComplaintModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ComplaintModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'title',
      serializers.serialize(
        object.title,
        specifiedType: const FullType(String),
      ),
      'description',
      serializers.serialize(
        object.description,
        specifiedType: const FullType(String),
      ),
      'approval_status',
      serializers.serialize(
        object.status,
        specifiedType: const FullType(String),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      ),
    ];

    return result;
  }

  @override
  ComplaintModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ComplaintModelBuilder();

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
                  )!
                  as String;
          break;
        case 'description':
          result.description =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'approval_status':
          result.status =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'createdAt':
          result.createdAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
      }
    }

    return result.build();
  }
}

class _$ComplaintModel extends ComplaintModel {
  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final String status;
  @override
  final DateTime createdAt;

  factory _$ComplaintModel([void Function(ComplaintModelBuilder)? updates]) =>
      (ComplaintModelBuilder()..update(updates))._build();

  _$ComplaintModel._({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
  }) : super._();
  @override
  ComplaintModel rebuild(void Function(ComplaintModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ComplaintModelBuilder toBuilder() => ComplaintModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ComplaintModel &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        status == other.status &&
        createdAt == other.createdAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ComplaintModel')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('status', status)
          ..add('createdAt', createdAt))
        .toString();
  }
}

class ComplaintModelBuilder
    implements Builder<ComplaintModel, ComplaintModelBuilder> {
  _$ComplaintModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  ComplaintModelBuilder();

  ComplaintModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _description = $v.description;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ComplaintModel other) {
    _$v = other as _$ComplaintModel;
  }

  @override
  void update(void Function(ComplaintModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ComplaintModel build() => _build();

  _$ComplaintModel _build() {
    final _$result =
        _$v ??
        _$ComplaintModel._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ComplaintModel',
            'id',
          ),
          title: BuiltValueNullFieldError.checkNotNull(
            title,
            r'ComplaintModel',
            'title',
          ),
          description: BuiltValueNullFieldError.checkNotNull(
            description,
            r'ComplaintModel',
            'description',
          ),
          status: BuiltValueNullFieldError.checkNotNull(
            status,
            r'ComplaintModel',
            'status',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'ComplaintModel',
            'createdAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

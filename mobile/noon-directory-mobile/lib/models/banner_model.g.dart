// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<BannerModel> _$bannerModelSerializer = _$BannerModelSerializer();

class _$BannerModelSerializer implements StructuredSerializer<BannerModel> {
  @override
  final Iterable<Type> types = const [BannerModel, _$BannerModel];
  @override
  final String wireName = 'BannerModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    BannerModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      ),
      'updatedAt',
      serializers.serialize(
        object.updatedAt,
        specifiedType: const FullType(DateTime),
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
    value = object.description;
    if (value != null) {
      result
        ..add('description')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.url;
    if (value != null) {
      result
        ..add('url')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.status;
    if (value != null) {
      result
        ..add('Status')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.schoolId;
    if (value != null) {
      result
        ..add('schoolId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.school;
    if (value != null) {
      result
        ..add('School')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(SchoolModel),
          ),
        );
    }
    return result;
  }

  @override
  BannerModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BannerModelBuilder();

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
        case 'description':
          result.description =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'url':
          result.url =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'Status':
          result.status =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'createdAt':
          result.createdAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'updatedAt':
          result.updatedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'schoolId':
          result.schoolId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'School':
          result.school.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(SchoolModel),
                )!
                as SchoolModel,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$BannerModel extends BannerModel {
  @override
  final String id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? url;
  @override
  final String? status;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? schoolId;
  @override
  final SchoolModel? school;

  factory _$BannerModel([void Function(BannerModelBuilder)? updates]) =>
      (BannerModelBuilder()..update(updates))._build();

  _$BannerModel._({
    required this.id,
    this.title,
    this.description,
    this.url,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    this.schoolId,
    this.school,
  }) : super._();
  @override
  BannerModel rebuild(void Function(BannerModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BannerModelBuilder toBuilder() => BannerModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BannerModel &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        url == other.url &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        schoolId == other.schoolId &&
        school == other.school;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, school.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BannerModel')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('url', url)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('schoolId', schoolId)
          ..add('school', school))
        .toString();
  }
}

class BannerModelBuilder implements Builder<BannerModel, BannerModelBuilder> {
  _$BannerModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _status;
  String? get status => _$this._status;
  set status(String? status) => _$this._status = status;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  SchoolModelBuilder? _school;
  SchoolModelBuilder get school => _$this._school ??= SchoolModelBuilder();
  set school(SchoolModelBuilder? school) => _$this._school = school;

  BannerModelBuilder();

  BannerModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _description = $v.description;
      _url = $v.url;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _schoolId = $v.schoolId;
      _school = $v.school?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BannerModel other) {
    _$v = other as _$BannerModel;
  }

  @override
  void update(void Function(BannerModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BannerModel build() => _build();

  _$BannerModel _build() {
    _$BannerModel _$result;
    try {
      _$result =
          _$v ??
          _$BannerModel._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'BannerModel', 'id'),
            title: title,
            description: description,
            url: url,
            status: status,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'BannerModel',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'BannerModel',
              'updatedAt',
            ),
            schoolId: schoolId,
            school: _school?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'school';
        _school?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'BannerModel',
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

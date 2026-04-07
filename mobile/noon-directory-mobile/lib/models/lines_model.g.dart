// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lines_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LinesModel> _$linesModelSerializer = _$LinesModelSerializer();

class _$LinesModelSerializer implements StructuredSerializer<LinesModel> {
  @override
  final Iterable<Type> types = const [LinesModel, _$LinesModel];
  @override
  final String wireName = 'LinesModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    LinesModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.fullName;
    if (value != null) {
      result
        ..add('fullName')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.carType;
    if (value != null) {
      result
        ..add('carType')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.carColor;
    if (value != null) {
      result
        ..add('carColor')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.carNumber;
    if (value != null) {
      result
        ..add('carNumber')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.address;
    if (value != null) {
      result
        ..add('address')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.phone1;
    if (value != null) {
      result
        ..add('phone1')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.phone2;
    if (value != null) {
      result
        ..add('phone2')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.photo;
    if (value != null) {
      result
        ..add('photo')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('createdAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updatedAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
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
    return result;
  }

  @override
  LinesModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LinesModelBuilder();

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
        case 'fullName':
          result.fullName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'carType':
          result.carType =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'carColor':
          result.carColor =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'carNumber':
          result.carNumber =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'address':
          result.address =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'phone1':
          result.phone1 =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'phone2':
          result.phone2 =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'photo':
          result.photo =
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
                  )
                  as DateTime?;
          break;
        case 'updatedAt':
          result.updatedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'schoolId':
          result.schoolId =
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

class _$LinesModel extends LinesModel {
  @override
  final String id;
  @override
  final String? fullName;
  @override
  final String? carType;
  @override
  final String? carColor;
  @override
  final String? carNumber;
  @override
  final String? address;
  @override
  final String? phone1;
  @override
  final String? phone2;
  @override
  final String? photo;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? schoolId;

  factory _$LinesModel([void Function(LinesModelBuilder)? updates]) =>
      (LinesModelBuilder()..update(updates))._build();

  _$LinesModel._({
    required this.id,
    this.fullName,
    this.carType,
    this.carColor,
    this.carNumber,
    this.address,
    this.phone1,
    this.phone2,
    this.photo,
    this.createdAt,
    this.updatedAt,
    this.schoolId,
  }) : super._();
  @override
  LinesModel rebuild(void Function(LinesModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LinesModelBuilder toBuilder() => LinesModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LinesModel &&
        id == other.id &&
        fullName == other.fullName &&
        carType == other.carType &&
        carColor == other.carColor &&
        carNumber == other.carNumber &&
        address == other.address &&
        phone1 == other.phone1 &&
        phone2 == other.phone2 &&
        photo == other.photo &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        schoolId == other.schoolId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, carType.hashCode);
    _$hash = $jc(_$hash, carColor.hashCode);
    _$hash = $jc(_$hash, carNumber.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, phone1.hashCode);
    _$hash = $jc(_$hash, phone2.hashCode);
    _$hash = $jc(_$hash, photo.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LinesModel')
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('carType', carType)
          ..add('carColor', carColor)
          ..add('carNumber', carNumber)
          ..add('address', address)
          ..add('phone1', phone1)
          ..add('phone2', phone2)
          ..add('photo', photo)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('schoolId', schoolId))
        .toString();
  }
}

class LinesModelBuilder implements Builder<LinesModel, LinesModelBuilder> {
  _$LinesModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _carType;
  String? get carType => _$this._carType;
  set carType(String? carType) => _$this._carType = carType;

  String? _carColor;
  String? get carColor => _$this._carColor;
  set carColor(String? carColor) => _$this._carColor = carColor;

  String? _carNumber;
  String? get carNumber => _$this._carNumber;
  set carNumber(String? carNumber) => _$this._carNumber = carNumber;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _phone1;
  String? get phone1 => _$this._phone1;
  set phone1(String? phone1) => _$this._phone1 = phone1;

  String? _phone2;
  String? get phone2 => _$this._phone2;
  set phone2(String? phone2) => _$this._phone2 = phone2;

  String? _photo;
  String? get photo => _$this._photo;
  set photo(String? photo) => _$this._photo = photo;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  LinesModelBuilder();

  LinesModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fullName = $v.fullName;
      _carType = $v.carType;
      _carColor = $v.carColor;
      _carNumber = $v.carNumber;
      _address = $v.address;
      _phone1 = $v.phone1;
      _phone2 = $v.phone2;
      _photo = $v.photo;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _schoolId = $v.schoolId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LinesModel other) {
    _$v = other as _$LinesModel;
  }

  @override
  void update(void Function(LinesModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LinesModel build() => _build();

  _$LinesModel _build() {
    final _$result =
        _$v ??
        _$LinesModel._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'LinesModel', 'id'),
          fullName: fullName,
          carType: carType,
          carColor: carColor,
          carNumber: carNumber,
          address: address,
          phone1: phone1,
          phone2: phone2,
          photo: photo,
          createdAt: createdAt,
          updatedAt: updatedAt,
          schoolId: schoolId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

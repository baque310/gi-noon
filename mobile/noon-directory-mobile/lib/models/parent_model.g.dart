// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ParentModel> _$parentModelSerializer = _$ParentModelSerializer();

class _$ParentModelSerializer implements StructuredSerializer<ParentModel> {
  @override
  final Iterable<Type> types = const [ParentModel, _$ParentModel];
  @override
  final String wireName = 'ParentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ParentModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'fullName',
      serializers.serialize(
        object.fullName,
        specifiedType: const FullType(String),
      ),
    ];
    Object? value;
    value = object.birth;
    if (value != null) {
      result
        ..add('birth')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.enrollmentDate;
    if (value != null) {
      result
        ..add('enrollmentDate')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
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
    value = object.email;
    if (value != null) {
      result
        ..add('email')
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
    value = object.userId;
    if (value != null) {
      result
        ..add('userId')
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
    value = object.students;
    if (value != null) {
      result
        ..add('Student')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(StudentModel),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  ParentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ParentModelBuilder();

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
                  )!
                  as String;
          break;
        case 'birth':
          result.birth =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'enrollmentDate':
          result.enrollmentDate =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'address':
          result.address =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'email':
          result.email =
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
        case 'userId':
          result.userId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
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
        case 'Student':
          result.students.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(StudentModel),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$ParentModel extends ParentModel {
  @override
  final String id;
  @override
  final String fullName;
  @override
  final DateTime? birth;
  @override
  final DateTime? enrollmentDate;
  @override
  final String? address;
  @override
  final String? email;
  @override
  final String? phone1;
  @override
  final String? phone2;
  @override
  final String? photo;
  @override
  final DateTime? createdAt;
  @override
  final String? userId;
  @override
  final String? schoolId;
  @override
  final SchoolModel? school;
  @override
  final BuiltList<StudentModel>? students;

  factory _$ParentModel([void Function(ParentModelBuilder)? updates]) =>
      (ParentModelBuilder()..update(updates))._build();

  _$ParentModel._({
    required this.id,
    required this.fullName,
    this.birth,
    this.enrollmentDate,
    this.address,
    this.email,
    this.phone1,
    this.phone2,
    this.photo,
    this.createdAt,
    this.userId,
    this.schoolId,
    this.school,
    this.students,
  }) : super._();
  @override
  ParentModel rebuild(void Function(ParentModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ParentModelBuilder toBuilder() => ParentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ParentModel &&
        id == other.id &&
        fullName == other.fullName &&
        birth == other.birth &&
        enrollmentDate == other.enrollmentDate &&
        address == other.address &&
        email == other.email &&
        phone1 == other.phone1 &&
        phone2 == other.phone2 &&
        photo == other.photo &&
        createdAt == other.createdAt &&
        userId == other.userId &&
        schoolId == other.schoolId &&
        school == other.school &&
        students == other.students;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, birth.hashCode);
    _$hash = $jc(_$hash, enrollmentDate.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone1.hashCode);
    _$hash = $jc(_$hash, phone2.hashCode);
    _$hash = $jc(_$hash, photo.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, school.hashCode);
    _$hash = $jc(_$hash, students.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ParentModel')
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('birth', birth)
          ..add('enrollmentDate', enrollmentDate)
          ..add('address', address)
          ..add('email', email)
          ..add('phone1', phone1)
          ..add('phone2', phone2)
          ..add('photo', photo)
          ..add('createdAt', createdAt)
          ..add('userId', userId)
          ..add('schoolId', schoolId)
          ..add('school', school)
          ..add('students', students))
        .toString();
  }
}

class ParentModelBuilder implements Builder<ParentModel, ParentModelBuilder> {
  _$ParentModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  DateTime? _birth;
  DateTime? get birth => _$this._birth;
  set birth(DateTime? birth) => _$this._birth = birth;

  DateTime? _enrollmentDate;
  DateTime? get enrollmentDate => _$this._enrollmentDate;
  set enrollmentDate(DateTime? enrollmentDate) =>
      _$this._enrollmentDate = enrollmentDate;

  String? _address;
  String? get address => _$this._address;
  set address(String? address) => _$this._address = address;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

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

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  SchoolModelBuilder? _school;
  SchoolModelBuilder get school => _$this._school ??= SchoolModelBuilder();
  set school(SchoolModelBuilder? school) => _$this._school = school;

  ListBuilder<StudentModel>? _students;
  ListBuilder<StudentModel> get students =>
      _$this._students ??= ListBuilder<StudentModel>();
  set students(ListBuilder<StudentModel>? students) =>
      _$this._students = students;

  ParentModelBuilder();

  ParentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fullName = $v.fullName;
      _birth = $v.birth;
      _enrollmentDate = $v.enrollmentDate;
      _address = $v.address;
      _email = $v.email;
      _phone1 = $v.phone1;
      _phone2 = $v.phone2;
      _photo = $v.photo;
      _createdAt = $v.createdAt;
      _userId = $v.userId;
      _schoolId = $v.schoolId;
      _school = $v.school?.toBuilder();
      _students = $v.students?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ParentModel other) {
    _$v = other as _$ParentModel;
  }

  @override
  void update(void Function(ParentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ParentModel build() => _build();

  _$ParentModel _build() {
    _$ParentModel _$result;
    try {
      _$result =
          _$v ??
          _$ParentModel._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'ParentModel', 'id'),
            fullName: BuiltValueNullFieldError.checkNotNull(
              fullName,
              r'ParentModel',
              'fullName',
            ),
            birth: birth,
            enrollmentDate: enrollmentDate,
            address: address,
            email: email,
            phone1: phone1,
            phone2: phone2,
            photo: photo,
            createdAt: createdAt,
            userId: userId,
            schoolId: schoolId,
            school: _school?.build(),
            students: _students?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'school';
        _school?.build();
        _$failedField = 'students';
        _students?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ParentModel',
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

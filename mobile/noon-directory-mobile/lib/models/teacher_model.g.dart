// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TeacherModel> _$teacherModelSerializer = _$TeacherModelSerializer();
Serializer<TeacherSubjectModel> _$teacherSubjectModelSerializer =
    _$TeacherSubjectModelSerializer();

class _$TeacherModelSerializer implements StructuredSerializer<TeacherModel> {
  @override
  final Iterable<Type> types = const [TeacherModel, _$TeacherModel];
  @override
  final String wireName = 'TeacherModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    TeacherModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'fullName',
      serializers.serialize(
        object.fullName,
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
    value = object.birth;
    if (value != null) {
      result
        ..add('birth')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.hiringDate;
    if (value != null) {
      result
        ..add('hiringDate')
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
    value = object.gender;
    if (value != null) {
      result
        ..add('Gender')
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
    value = object.teacherSubjects;
    if (value != null) {
      result
        ..add('TeacherSubject')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(TeacherSubjectModel),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  TeacherModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeacherModelBuilder();

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
        case 'hiringDate':
          result.hiringDate =
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
        case 'Gender':
          result.gender =
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
        case 'TeacherSubject':
          result.teacherSubjects.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(TeacherSubjectModel),
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

class _$TeacherSubjectModelSerializer
    implements StructuredSerializer<TeacherSubjectModel> {
  @override
  final Iterable<Type> types = const [
    TeacherSubjectModel,
    _$TeacherSubjectModel,
  ];
  @override
  final String wireName = 'TeacherSubjectModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    TeacherSubjectModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'SchoolYear',
      serializers.serialize(
        object.schoolYear,
        specifiedType: const FullType(SchoolYear),
      ),
      'StageSubject',
      serializers.serialize(
        object.stageSubject,
        specifiedType: const FullType(StageSubjectModel),
      ),
    ];

    return result;
  }

  @override
  TeacherSubjectModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeacherSubjectModelBuilder();

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
        case 'SchoolYear':
          result.schoolYear.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(SchoolYear),
                )!
                as SchoolYear,
          );
          break;
        case 'StageSubject':
          result.stageSubject.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(StageSubjectModel),
                )!
                as StageSubjectModel,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$TeacherModel extends TeacherModel {
  @override
  final String? id;
  @override
  final String fullName;
  @override
  final DateTime? birth;
  @override
  final DateTime? hiringDate;
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
  final String? userId;
  @override
  final String? schoolId;
  @override
  final String? gender;
  @override
  final SchoolModel? school;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final BuiltList<TeacherSubjectModel>? teacherSubjects;

  factory _$TeacherModel([void Function(TeacherModelBuilder)? updates]) =>
      (TeacherModelBuilder()..update(updates))._build();

  _$TeacherModel._({
    this.id,
    required this.fullName,
    this.birth,
    this.hiringDate,
    this.address,
    this.email,
    this.phone1,
    this.phone2,
    this.photo,
    this.userId,
    this.schoolId,
    this.gender,
    this.school,
    this.createdAt,
    this.updatedAt,
    this.teacherSubjects,
  }) : super._();
  @override
  TeacherModel rebuild(void Function(TeacherModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  TeacherModelBuilder toBuilder() => TeacherModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeacherModel &&
        id == other.id &&
        fullName == other.fullName &&
        birth == other.birth &&
        hiringDate == other.hiringDate &&
        address == other.address &&
        email == other.email &&
        phone1 == other.phone1 &&
        phone2 == other.phone2 &&
        photo == other.photo &&
        userId == other.userId &&
        schoolId == other.schoolId &&
        gender == other.gender &&
        school == other.school &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        teacherSubjects == other.teacherSubjects;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, birth.hashCode);
    _$hash = $jc(_$hash, hiringDate.hashCode);
    _$hash = $jc(_$hash, address.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, phone1.hashCode);
    _$hash = $jc(_$hash, phone2.hashCode);
    _$hash = $jc(_$hash, photo.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, gender.hashCode);
    _$hash = $jc(_$hash, school.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, teacherSubjects.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeacherModel')
          ..add('id', id)
          ..add('fullName', fullName)
          ..add('birth', birth)
          ..add('hiringDate', hiringDate)
          ..add('address', address)
          ..add('email', email)
          ..add('phone1', phone1)
          ..add('phone2', phone2)
          ..add('photo', photo)
          ..add('userId', userId)
          ..add('schoolId', schoolId)
          ..add('gender', gender)
          ..add('school', school)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('teacherSubjects', teacherSubjects))
        .toString();
  }
}

class TeacherModelBuilder
    implements Builder<TeacherModel, TeacherModelBuilder> {
  _$TeacherModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  DateTime? _birth;
  DateTime? get birth => _$this._birth;
  set birth(DateTime? birth) => _$this._birth = birth;

  DateTime? _hiringDate;
  DateTime? get hiringDate => _$this._hiringDate;
  set hiringDate(DateTime? hiringDate) => _$this._hiringDate = hiringDate;

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

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  String? _gender;
  String? get gender => _$this._gender;
  set gender(String? gender) => _$this._gender = gender;

  SchoolModelBuilder? _school;
  SchoolModelBuilder get school => _$this._school ??= SchoolModelBuilder();
  set school(SchoolModelBuilder? school) => _$this._school = school;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ListBuilder<TeacherSubjectModel>? _teacherSubjects;
  ListBuilder<TeacherSubjectModel> get teacherSubjects =>
      _$this._teacherSubjects ??= ListBuilder<TeacherSubjectModel>();
  set teacherSubjects(ListBuilder<TeacherSubjectModel>? teacherSubjects) =>
      _$this._teacherSubjects = teacherSubjects;

  TeacherModelBuilder();

  TeacherModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _fullName = $v.fullName;
      _birth = $v.birth;
      _hiringDate = $v.hiringDate;
      _address = $v.address;
      _email = $v.email;
      _phone1 = $v.phone1;
      _phone2 = $v.phone2;
      _photo = $v.photo;
      _userId = $v.userId;
      _schoolId = $v.schoolId;
      _gender = $v.gender;
      _school = $v.school?.toBuilder();
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _teacherSubjects = $v.teacherSubjects?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeacherModel other) {
    _$v = other as _$TeacherModel;
  }

  @override
  void update(void Function(TeacherModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeacherModel build() => _build();

  _$TeacherModel _build() {
    _$TeacherModel _$result;
    try {
      _$result =
          _$v ??
          _$TeacherModel._(
            id: id,
            fullName: BuiltValueNullFieldError.checkNotNull(
              fullName,
              r'TeacherModel',
              'fullName',
            ),
            birth: birth,
            hiringDate: hiringDate,
            address: address,
            email: email,
            phone1: phone1,
            phone2: phone2,
            photo: photo,
            userId: userId,
            schoolId: schoolId,
            gender: gender,
            school: _school?.build(),
            createdAt: createdAt,
            updatedAt: updatedAt,
            teacherSubjects: _teacherSubjects?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'school';
        _school?.build();

        _$failedField = 'teacherSubjects';
        _teacherSubjects?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeacherModel',
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

class _$TeacherSubjectModel extends TeacherSubjectModel {
  @override
  final String id;
  @override
  final SchoolYear schoolYear;
  @override
  final StageSubjectModel stageSubject;

  factory _$TeacherSubjectModel([
    void Function(TeacherSubjectModelBuilder)? updates,
  ]) => (TeacherSubjectModelBuilder()..update(updates))._build();

  _$TeacherSubjectModel._({
    required this.id,
    required this.schoolYear,
    required this.stageSubject,
  }) : super._();
  @override
  TeacherSubjectModel rebuild(
    void Function(TeacherSubjectModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TeacherSubjectModelBuilder toBuilder() =>
      TeacherSubjectModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeacherSubjectModel &&
        id == other.id &&
        schoolYear == other.schoolYear &&
        stageSubject == other.stageSubject;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, schoolYear.hashCode);
    _$hash = $jc(_$hash, stageSubject.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeacherSubjectModel')
          ..add('id', id)
          ..add('schoolYear', schoolYear)
          ..add('stageSubject', stageSubject))
        .toString();
  }
}

class TeacherSubjectModelBuilder
    implements Builder<TeacherSubjectModel, TeacherSubjectModelBuilder> {
  _$TeacherSubjectModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  SchoolYearBuilder? _schoolYear;
  SchoolYearBuilder get schoolYear =>
      _$this._schoolYear ??= SchoolYearBuilder();
  set schoolYear(SchoolYearBuilder? schoolYear) =>
      _$this._schoolYear = schoolYear;

  StageSubjectModelBuilder? _stageSubject;
  StageSubjectModelBuilder get stageSubject =>
      _$this._stageSubject ??= StageSubjectModelBuilder();
  set stageSubject(StageSubjectModelBuilder? stageSubject) =>
      _$this._stageSubject = stageSubject;

  TeacherSubjectModelBuilder();

  TeacherSubjectModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _schoolYear = $v.schoolYear.toBuilder();
      _stageSubject = $v.stageSubject.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeacherSubjectModel other) {
    _$v = other as _$TeacherSubjectModel;
  }

  @override
  void update(void Function(TeacherSubjectModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeacherSubjectModel build() => _build();

  _$TeacherSubjectModel _build() {
    _$TeacherSubjectModel _$result;
    try {
      _$result =
          _$v ??
          _$TeacherSubjectModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'TeacherSubjectModel',
              'id',
            ),
            schoolYear: schoolYear.build(),
            stageSubject: stageSubject.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'schoolYear';
        schoolYear.build();
        _$failedField = 'stageSubject';
        stageSubject.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeacherSubjectModel',
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

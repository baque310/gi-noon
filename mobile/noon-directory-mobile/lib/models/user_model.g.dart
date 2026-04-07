// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserModel> _$userModelSerializer = _$UserModelSerializer();

class _$UserModelSerializer implements StructuredSerializer<UserModel> {
  @override
  final Iterable<Type> types = const [UserModel, _$UserModel];
  @override
  final String wireName = 'UserModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    UserModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'username',
      serializers.serialize(
        object.username,
        specifiedType: const FullType(String),
      ),
      'isDeleted',
      serializers.serialize(
        object.isDeleted,
        specifiedType: const FullType(bool),
      ),
      'isActive',
      serializers.serialize(
        object.isActive,
        specifiedType: const FullType(bool),
      ),
      'isDefaultPass',
      serializers.serialize(
        object.isDefaultPass,
        specifiedType: const FullType(bool),
      ),
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
      'schoolId',
      serializers.serialize(
        object.schoolId,
        specifiedType: const FullType(String),
      ),
    ];
    Object? value;
    value = object.student;
    if (value != null) {
      result
        ..add('Student')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(StudentModel),
          ),
        );
    }
    value = object.teacher;
    if (value != null) {
      result
        ..add('Teacher')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(TeacherModel),
          ),
        );
    }
    value = object.parent;
    if (value != null) {
      result
        ..add('Parent')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(ParentModel),
          ),
        );
    }
    return result;
  }

  @override
  UserModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserModelBuilder();

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
        case 'username':
          result.username =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'isDeleted':
          result.isDeleted =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isActive':
          result.isActive =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
          break;
        case 'isDefaultPass':
          result.isDefaultPass =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(bool),
                  )!
                  as bool;
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
                  )!
                  as String;
          break;
        case 'Student':
          result.student.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(StudentModel),
                )!
                as StudentModel,
          );
          break;
        case 'Teacher':
          result.teacher.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(TeacherModel),
                )!
                as TeacherModel,
          );
          break;
        case 'Parent':
          result.parent.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(ParentModel),
                )!
                as ParentModel,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$UserModel extends UserModel {
  @override
  final String id;
  @override
  final String username;
  @override
  final bool isDeleted;
  @override
  final bool isActive;
  @override
  final bool isDefaultPass;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String schoolId;
  @override
  final StudentModel? student;
  @override
  final TeacherModel? teacher;
  @override
  final ParentModel? parent;

  factory _$UserModel([void Function(UserModelBuilder)? updates]) =>
      (UserModelBuilder()..update(updates))._build();

  _$UserModel._({
    required this.id,
    required this.username,
    required this.isDeleted,
    required this.isActive,
    required this.isDefaultPass,
    required this.createdAt,
    required this.updatedAt,
    required this.schoolId,
    this.student,
    this.teacher,
    this.parent,
  }) : super._();
  @override
  UserModel rebuild(void Function(UserModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  UserModelBuilder toBuilder() => UserModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserModel &&
        id == other.id &&
        username == other.username &&
        isDeleted == other.isDeleted &&
        isActive == other.isActive &&
        isDefaultPass == other.isDefaultPass &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        schoolId == other.schoolId &&
        student == other.student &&
        teacher == other.teacher &&
        parent == other.parent;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, username.hashCode);
    _$hash = $jc(_$hash, isDeleted.hashCode);
    _$hash = $jc(_$hash, isActive.hashCode);
    _$hash = $jc(_$hash, isDefaultPass.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, student.hashCode);
    _$hash = $jc(_$hash, teacher.hashCode);
    _$hash = $jc(_$hash, parent.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserModel')
          ..add('id', id)
          ..add('username', username)
          ..add('isDeleted', isDeleted)
          ..add('isActive', isActive)
          ..add('isDefaultPass', isDefaultPass)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('schoolId', schoolId)
          ..add('student', student)
          ..add('teacher', teacher)
          ..add('parent', parent))
        .toString();
  }
}

class UserModelBuilder implements Builder<UserModel, UserModelBuilder> {
  _$UserModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _username;
  String? get username => _$this._username;
  set username(String? username) => _$this._username = username;

  bool? _isDeleted;
  bool? get isDeleted => _$this._isDeleted;
  set isDeleted(bool? isDeleted) => _$this._isDeleted = isDeleted;

  bool? _isActive;
  bool? get isActive => _$this._isActive;
  set isActive(bool? isActive) => _$this._isActive = isActive;

  bool? _isDefaultPass;
  bool? get isDefaultPass => _$this._isDefaultPass;
  set isDefaultPass(bool? isDefaultPass) =>
      _$this._isDefaultPass = isDefaultPass;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  StudentModelBuilder? _student;
  StudentModelBuilder get student => _$this._student ??= StudentModelBuilder();
  set student(StudentModelBuilder? student) => _$this._student = student;

  TeacherModelBuilder? _teacher;
  TeacherModelBuilder get teacher => _$this._teacher ??= TeacherModelBuilder();
  set teacher(TeacherModelBuilder? teacher) => _$this._teacher = teacher;

  ParentModelBuilder? _parent;
  ParentModelBuilder get parent => _$this._parent ??= ParentModelBuilder();
  set parent(ParentModelBuilder? parent) => _$this._parent = parent;

  UserModelBuilder();

  UserModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _username = $v.username;
      _isDeleted = $v.isDeleted;
      _isActive = $v.isActive;
      _isDefaultPass = $v.isDefaultPass;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _schoolId = $v.schoolId;
      _student = $v.student?.toBuilder();
      _teacher = $v.teacher?.toBuilder();
      _parent = $v.parent?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserModel other) {
    _$v = other as _$UserModel;
  }

  @override
  void update(void Function(UserModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserModel build() => _build();

  _$UserModel _build() {
    _$UserModel _$result;
    try {
      _$result =
          _$v ??
          _$UserModel._(
            id: BuiltValueNullFieldError.checkNotNull(id, r'UserModel', 'id'),
            username: BuiltValueNullFieldError.checkNotNull(
              username,
              r'UserModel',
              'username',
            ),
            isDeleted: BuiltValueNullFieldError.checkNotNull(
              isDeleted,
              r'UserModel',
              'isDeleted',
            ),
            isActive: BuiltValueNullFieldError.checkNotNull(
              isActive,
              r'UserModel',
              'isActive',
            ),
            isDefaultPass: BuiltValueNullFieldError.checkNotNull(
              isDefaultPass,
              r'UserModel',
              'isDefaultPass',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'UserModel',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'UserModel',
              'updatedAt',
            ),
            schoolId: BuiltValueNullFieldError.checkNotNull(
              schoolId,
              r'UserModel',
              'schoolId',
            ),
            student: _student?.build(),
            teacher: _teacher?.build(),
            parent: _parent?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'student';
        _student?.build();
        _$failedField = 'teacher';
        _teacher?.build();
        _$failedField = 'parent';
        _parent?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UserModel',
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

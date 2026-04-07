// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teaching_staff_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TeachingStaffModel> _$teachingStaffModelSerializer =
    _$TeachingStaffModelSerializer();

class _$TeachingStaffModelSerializer
    implements StructuredSerializer<TeachingStaffModel> {
  @override
  final Iterable<Type> types = const [TeachingStaffModel, _$TeachingStaffModel];
  @override
  final String wireName = 'TeachingStaffModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    TeachingStaffModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.photo;
    if (value != null) {
      result
        ..add('photo')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.fullName;
    if (value != null) {
      result
        ..add('fullName')
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
    value = object.teacherSubject;
    if (value != null) {
      result
        ..add('TeacherSubject')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(TeacherSubject),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  TeachingStaffModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = TeachingStaffModelBuilder();

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
        case 'photo':
          result.photo =
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
        case 'TeacherSubject':
          result.teacherSubject.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(TeacherSubject),
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

class _$TeachingStaffModel extends TeachingStaffModel {
  @override
  final String id;
  @override
  final String? photo;
  @override
  final String? fullName;
  @override
  final String? gender;
  @override
  final BuiltList<TeacherSubject>? teacherSubject;

  factory _$TeachingStaffModel([
    void Function(TeachingStaffModelBuilder)? updates,
  ]) => (TeachingStaffModelBuilder()..update(updates))._build();

  _$TeachingStaffModel._({
    required this.id,
    this.photo,
    this.fullName,
    this.gender,
    this.teacherSubject,
  }) : super._();
  @override
  TeachingStaffModel rebuild(
    void Function(TeachingStaffModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  TeachingStaffModelBuilder toBuilder() =>
      TeachingStaffModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TeachingStaffModel &&
        id == other.id &&
        photo == other.photo &&
        fullName == other.fullName &&
        gender == other.gender &&
        teacherSubject == other.teacherSubject;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, photo.hashCode);
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, gender.hashCode);
    _$hash = $jc(_$hash, teacherSubject.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'TeachingStaffModel')
          ..add('id', id)
          ..add('photo', photo)
          ..add('fullName', fullName)
          ..add('gender', gender)
          ..add('teacherSubject', teacherSubject))
        .toString();
  }
}

class TeachingStaffModelBuilder
    implements Builder<TeachingStaffModel, TeachingStaffModelBuilder> {
  _$TeachingStaffModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _photo;
  String? get photo => _$this._photo;
  set photo(String? photo) => _$this._photo = photo;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _gender;
  String? get gender => _$this._gender;
  set gender(String? gender) => _$this._gender = gender;

  ListBuilder<TeacherSubject>? _teacherSubject;
  ListBuilder<TeacherSubject> get teacherSubject =>
      _$this._teacherSubject ??= ListBuilder<TeacherSubject>();
  set teacherSubject(ListBuilder<TeacherSubject>? teacherSubject) =>
      _$this._teacherSubject = teacherSubject;

  TeachingStaffModelBuilder();

  TeachingStaffModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _photo = $v.photo;
      _fullName = $v.fullName;
      _gender = $v.gender;
      _teacherSubject = $v.teacherSubject?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TeachingStaffModel other) {
    _$v = other as _$TeachingStaffModel;
  }

  @override
  void update(void Function(TeachingStaffModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  TeachingStaffModel build() => _build();

  _$TeachingStaffModel _build() {
    _$TeachingStaffModel _$result;
    try {
      _$result =
          _$v ??
          _$TeachingStaffModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'TeachingStaffModel',
              'id',
            ),
            photo: photo,
            fullName: fullName,
            gender: gender,
            teacherSubject: _teacherSubject?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'teacherSubject';
        _teacherSubject?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'TeachingStaffModel',
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

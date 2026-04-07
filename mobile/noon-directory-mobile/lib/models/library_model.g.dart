// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LibraryModel> _$libraryModelSerializer = _$LibraryModelSerializer();

class _$LibraryModelSerializer implements StructuredSerializer<LibraryModel> {
  @override
  final Iterable<Type> types = const [LibraryModel, _$LibraryModel];
  @override
  final String wireName = 'LibraryModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    LibraryModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
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
    value = object.sectionId;
    if (value != null) {
      result
        ..add('sectionId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.classId;
    if (value != null) {
      result
        ..add('classId')
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
    value = object.authorId;
    if (value != null) {
      result
        ..add('authorId')
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
  LibraryModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LibraryModelBuilder();

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
        case 'sectionId':
          result.sectionId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'classId':
          result.classId =
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
        case 'authorId':
          result.authorId =
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

class _$LibraryModel extends LibraryModel {
  @override
  final String id;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? url;
  @override
  final String? sectionId;
  @override
  final String? classId;
  @override
  final String? status;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  @override
  final String? schoolId;
  @override
  final String? authorId;
  @override
  final SchoolModel? school;

  factory _$LibraryModel([void Function(LibraryModelBuilder)? updates]) =>
      (LibraryModelBuilder()..update(updates))._build();

  _$LibraryModel._({
    required this.id,
    this.title,
    this.description,
    this.url,
    this.sectionId,
    this.classId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.schoolId,
    this.authorId,
    this.school,
  }) : super._();
  @override
  LibraryModel rebuild(void Function(LibraryModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LibraryModelBuilder toBuilder() => LibraryModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LibraryModel &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        url == other.url &&
        sectionId == other.sectionId &&
        classId == other.classId &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        schoolId == other.schoolId &&
        authorId == other.authorId &&
        school == other.school;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, sectionId.hashCode);
    _$hash = $jc(_$hash, classId.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, authorId.hashCode);
    _$hash = $jc(_$hash, school.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LibraryModel')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('url', url)
          ..add('sectionId', sectionId)
          ..add('classId', classId)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('schoolId', schoolId)
          ..add('authorId', authorId)
          ..add('school', school))
        .toString();
  }
}

class LibraryModelBuilder
    implements Builder<LibraryModel, LibraryModelBuilder> {
  _$LibraryModel? _$v;

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

  String? _sectionId;
  String? get sectionId => _$this._sectionId;
  set sectionId(String? sectionId) => _$this._sectionId = sectionId;

  String? _classId;
  String? get classId => _$this._classId;
  set classId(String? classId) => _$this._classId = classId;

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

  String? _authorId;
  String? get authorId => _$this._authorId;
  set authorId(String? authorId) => _$this._authorId = authorId;

  SchoolModelBuilder? _school;
  SchoolModelBuilder get school => _$this._school ??= SchoolModelBuilder();
  set school(SchoolModelBuilder? school) => _$this._school = school;

  LibraryModelBuilder();

  LibraryModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _description = $v.description;
      _url = $v.url;
      _sectionId = $v.sectionId;
      _classId = $v.classId;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _schoolId = $v.schoolId;
      _authorId = $v.authorId;
      _school = $v.school?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LibraryModel other) {
    _$v = other as _$LibraryModel;
  }

  @override
  void update(void Function(LibraryModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LibraryModel build() => _build();

  _$LibraryModel _build() {
    _$LibraryModel _$result;
    try {
      _$result =
          _$v ??
          _$LibraryModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'LibraryModel',
              'id',
            ),
            title: title,
            description: description,
            url: url,
            sectionId: sectionId,
            classId: classId,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            schoolId: schoolId,
            authorId: authorId,
            school: _school?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'school';
        _school?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'LibraryModel',
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reusable_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ReusableModel> _$reusableModelSerializer =
    _$ReusableModelSerializer();

class _$ReusableModelSerializer implements StructuredSerializer<ReusableModel> {
  @override
  final Iterable<Type> types = const [ReusableModel, _$ReusableModel];
  @override
  final String wireName = 'ReusableModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ReusableModel object, {
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
      'School',
      serializers.serialize(
        object.school,
        specifiedType: const FullType(SchoolModel),
      ),
    ];
    Object? value;
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
        ..add('status')
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
    value = object.sectionId;
    if (value != null) {
      result
        ..add('sectionId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.attachments;
    if (value != null) {
      result
        ..add('GalleryAttachment')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(BuiltList, const [
              const FullType(AttachmentModel),
            ]),
          ),
        );
    }
    return result;
  }

  @override
  ReusableModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ReusableModelBuilder();

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
        case 'status':
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
                  )!
                  as String;
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
        case 'classId':
          result.classId =
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
        case 'GalleryAttachment':
          result.attachments.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(AttachmentModel),
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

class _$ReusableModel extends ReusableModel {
  @override
  final String id;
  @override
  final String title;
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
  final String schoolId;
  @override
  final SchoolModel school;
  @override
  final String? classId;
  @override
  final String? sectionId;
  @override
  final BuiltList<AttachmentModel>? attachments;

  factory _$ReusableModel([void Function(ReusableModelBuilder)? updates]) =>
      (ReusableModelBuilder()..update(updates))._build();

  _$ReusableModel._({
    required this.id,
    required this.title,
    this.description,
    this.url,
    this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.schoolId,
    required this.school,
    this.classId,
    this.sectionId,
    this.attachments,
  }) : super._();
  @override
  ReusableModel rebuild(void Function(ReusableModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ReusableModelBuilder toBuilder() => ReusableModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ReusableModel &&
        id == other.id &&
        title == other.title &&
        description == other.description &&
        url == other.url &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        schoolId == other.schoolId &&
        school == other.school &&
        classId == other.classId &&
        sectionId == other.sectionId &&
        attachments == other.attachments;
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
    _$hash = $jc(_$hash, classId.hashCode);
    _$hash = $jc(_$hash, sectionId.hashCode);
    _$hash = $jc(_$hash, attachments.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ReusableModel')
          ..add('id', id)
          ..add('title', title)
          ..add('description', description)
          ..add('url', url)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('schoolId', schoolId)
          ..add('school', school)
          ..add('classId', classId)
          ..add('sectionId', sectionId)
          ..add('attachments', attachments))
        .toString();
  }
}

class ReusableModelBuilder
    implements Builder<ReusableModel, ReusableModelBuilder> {
  _$ReusableModel? _$v;

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

  String? _classId;
  String? get classId => _$this._classId;
  set classId(String? classId) => _$this._classId = classId;

  String? _sectionId;
  String? get sectionId => _$this._sectionId;
  set sectionId(String? sectionId) => _$this._sectionId = sectionId;

  ListBuilder<AttachmentModel>? _attachments;
  ListBuilder<AttachmentModel> get attachments =>
      _$this._attachments ??= ListBuilder<AttachmentModel>();
  set attachments(ListBuilder<AttachmentModel>? attachments) =>
      _$this._attachments = attachments;

  ReusableModelBuilder();

  ReusableModelBuilder get _$this {
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
      _school = $v.school.toBuilder();
      _classId = $v.classId;
      _sectionId = $v.sectionId;
      _attachments = $v.attachments?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ReusableModel other) {
    _$v = other as _$ReusableModel;
  }

  @override
  void update(void Function(ReusableModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ReusableModel build() => _build();

  _$ReusableModel _build() {
    _$ReusableModel _$result;
    try {
      _$result =
          _$v ??
          _$ReusableModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'ReusableModel',
              'id',
            ),
            title: BuiltValueNullFieldError.checkNotNull(
              title,
              r'ReusableModel',
              'title',
            ),
            description: description,
            url: url,
            status: status,
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'ReusableModel',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'ReusableModel',
              'updatedAt',
            ),
            schoolId: BuiltValueNullFieldError.checkNotNull(
              schoolId,
              r'ReusableModel',
              'schoolId',
            ),
            school: school.build(),
            classId: classId,
            sectionId: sectionId,
            attachments: _attachments?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'school';
        school.build();

        _$failedField = 'attachments';
        _attachments?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ReusableModel',
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

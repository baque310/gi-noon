// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_attachment_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<UserAttachmentModel> _$userAttachmentModelSerializer =
    _$UserAttachmentModelSerializer();

class _$UserAttachmentModelSerializer
    implements StructuredSerializer<UserAttachmentModel> {
  @override
  final Iterable<Type> types = const [
    UserAttachmentModel,
    _$UserAttachmentModel,
  ];
  @override
  final String wireName = 'UserAttachmentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    UserAttachmentModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
    ];
    Object? value;
    value = object.urlFace;
    if (value != null) {
      result
        ..add('url_face')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.urlBack;
    if (value != null) {
      result
        ..add('url_back')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.notes;
    if (value != null) {
      result
        ..add('notes')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.approvalStatus;
    if (value != null) {
      result
        ..add('approval_status')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.approvalReason;
    if (value != null) {
      result
        ..add('approval_reason')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.approvalDate;
    if (value != null) {
      result
        ..add('approval_date')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.status;
    if (value != null) {
      result
        ..add('status')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(bool)),
        );
    }
    value = object.createdAt;
    if (value != null) {
      result
        ..add('createdAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.updatedAt;
    if (value != null) {
      result
        ..add('updatedAt')
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
    value = object.attTypeId;
    if (value != null) {
      result
        ..add('attTypeId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.attType;
    if (value != null) {
      result
        ..add('AttType')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(AttachmentTypeModel),
          ),
        );
    }
    return result;
  }

  @override
  UserAttachmentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserAttachmentModelBuilder();

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
        case 'url_face':
          result.urlFace =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'url_back':
          result.urlBack =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'notes':
          result.notes =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'approval_status':
          result.approvalStatus =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'approval_reason':
          result.approvalReason =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'approval_date':
          result.approvalDate =
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
                    specifiedType: const FullType(bool),
                  )
                  as bool?;
          break;
        case 'createdAt':
          result.createdAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'updatedAt':
          result.updatedAt =
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
        case 'attTypeId':
          result.attTypeId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'AttType':
          result.attType.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(AttachmentTypeModel),
                )!
                as AttachmentTypeModel,
          );
          break;
      }
    }

    return result.build();
  }
}

class _$UserAttachmentModel extends UserAttachmentModel {
  @override
  final String id;
  @override
  final String? urlFace;
  @override
  final String? urlBack;
  @override
  final String? notes;
  @override
  final String? approvalStatus;
  @override
  final String? approvalReason;
  @override
  final String? approvalDate;
  @override
  final bool? status;
  @override
  final String? createdAt;
  @override
  final String? updatedAt;
  @override
  final String? userId;
  @override
  final String? attTypeId;
  @override
  final AttachmentTypeModel? attType;

  factory _$UserAttachmentModel([
    void Function(UserAttachmentModelBuilder)? updates,
  ]) => (UserAttachmentModelBuilder()..update(updates))._build();

  _$UserAttachmentModel._({
    required this.id,
    this.urlFace,
    this.urlBack,
    this.notes,
    this.approvalStatus,
    this.approvalReason,
    this.approvalDate,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.attTypeId,
    this.attType,
  }) : super._();
  @override
  UserAttachmentModel rebuild(
    void Function(UserAttachmentModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  UserAttachmentModelBuilder toBuilder() =>
      UserAttachmentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserAttachmentModel &&
        id == other.id &&
        urlFace == other.urlFace &&
        urlBack == other.urlBack &&
        notes == other.notes &&
        approvalStatus == other.approvalStatus &&
        approvalReason == other.approvalReason &&
        approvalDate == other.approvalDate &&
        status == other.status &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        userId == other.userId &&
        attTypeId == other.attTypeId &&
        attType == other.attType;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, urlFace.hashCode);
    _$hash = $jc(_$hash, urlBack.hashCode);
    _$hash = $jc(_$hash, notes.hashCode);
    _$hash = $jc(_$hash, approvalStatus.hashCode);
    _$hash = $jc(_$hash, approvalReason.hashCode);
    _$hash = $jc(_$hash, approvalDate.hashCode);
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, attTypeId.hashCode);
    _$hash = $jc(_$hash, attType.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'UserAttachmentModel')
          ..add('id', id)
          ..add('urlFace', urlFace)
          ..add('urlBack', urlBack)
          ..add('notes', notes)
          ..add('approvalStatus', approvalStatus)
          ..add('approvalReason', approvalReason)
          ..add('approvalDate', approvalDate)
          ..add('status', status)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('userId', userId)
          ..add('attTypeId', attTypeId)
          ..add('attType', attType))
        .toString();
  }
}

class UserAttachmentModelBuilder
    implements Builder<UserAttachmentModel, UserAttachmentModelBuilder> {
  _$UserAttachmentModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _urlFace;
  String? get urlFace => _$this._urlFace;
  set urlFace(String? urlFace) => _$this._urlFace = urlFace;

  String? _urlBack;
  String? get urlBack => _$this._urlBack;
  set urlBack(String? urlBack) => _$this._urlBack = urlBack;

  String? _notes;
  String? get notes => _$this._notes;
  set notes(String? notes) => _$this._notes = notes;

  String? _approvalStatus;
  String? get approvalStatus => _$this._approvalStatus;
  set approvalStatus(String? approvalStatus) =>
      _$this._approvalStatus = approvalStatus;

  String? _approvalReason;
  String? get approvalReason => _$this._approvalReason;
  set approvalReason(String? approvalReason) =>
      _$this._approvalReason = approvalReason;

  String? _approvalDate;
  String? get approvalDate => _$this._approvalDate;
  set approvalDate(String? approvalDate) => _$this._approvalDate = approvalDate;

  bool? _status;
  bool? get status => _$this._status;
  set status(bool? status) => _$this._status = status;

  String? _createdAt;
  String? get createdAt => _$this._createdAt;
  set createdAt(String? createdAt) => _$this._createdAt = createdAt;

  String? _updatedAt;
  String? get updatedAt => _$this._updatedAt;
  set updatedAt(String? updatedAt) => _$this._updatedAt = updatedAt;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _attTypeId;
  String? get attTypeId => _$this._attTypeId;
  set attTypeId(String? attTypeId) => _$this._attTypeId = attTypeId;

  AttachmentTypeModelBuilder? _attType;
  AttachmentTypeModelBuilder get attType =>
      _$this._attType ??= AttachmentTypeModelBuilder();
  set attType(AttachmentTypeModelBuilder? attType) => _$this._attType = attType;

  UserAttachmentModelBuilder();

  UserAttachmentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _urlFace = $v.urlFace;
      _urlBack = $v.urlBack;
      _notes = $v.notes;
      _approvalStatus = $v.approvalStatus;
      _approvalReason = $v.approvalReason;
      _approvalDate = $v.approvalDate;
      _status = $v.status;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _userId = $v.userId;
      _attTypeId = $v.attTypeId;
      _attType = $v.attType?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(UserAttachmentModel other) {
    _$v = other as _$UserAttachmentModel;
  }

  @override
  void update(void Function(UserAttachmentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  UserAttachmentModel build() => _build();

  _$UserAttachmentModel _build() {
    _$UserAttachmentModel _$result;
    try {
      _$result =
          _$v ??
          _$UserAttachmentModel._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'UserAttachmentModel',
              'id',
            ),
            urlFace: urlFace,
            urlBack: urlBack,
            notes: notes,
            approvalStatus: approvalStatus,
            approvalReason: approvalReason,
            approvalDate: approvalDate,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt,
            userId: userId,
            attTypeId: attTypeId,
            attType: _attType?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'attType';
        _attType?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'UserAttachmentModel',
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

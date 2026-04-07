// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lesson_attachment_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<LessonAttachmentModel> _$lessonAttachmentModelSerializer =
    _$LessonAttachmentModelSerializer();

class _$LessonAttachmentModelSerializer
    implements StructuredSerializer<LessonAttachmentModel> {
  @override
  final Iterable<Type> types = const [
    LessonAttachmentModel,
    _$LessonAttachmentModel,
  ];
  @override
  final String wireName = 'LessonAttachmentModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    LessonAttachmentModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'url',
      serializers.serialize(object.url, specifiedType: const FullType(String)),
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
      'lessonId',
      serializers.serialize(
        object.lessonId,
        specifiedType: const FullType(String),
      ),
    ];

    return result;
  }

  @override
  LessonAttachmentModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LessonAttachmentModelBuilder();

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
        case 'url':
          result.url =
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
        case 'updatedAt':
          result.updatedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'lessonId':
          result.lessonId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
      }
    }

    return result.build();
  }
}

class _$LessonAttachmentModel extends LessonAttachmentModel {
  @override
  final String id;
  @override
  final String url;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String lessonId;

  factory _$LessonAttachmentModel([
    void Function(LessonAttachmentModelBuilder)? updates,
  ]) => (LessonAttachmentModelBuilder()..update(updates))._build();

  _$LessonAttachmentModel._({
    required this.id,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
    required this.lessonId,
  }) : super._();
  @override
  LessonAttachmentModel rebuild(
    void Function(LessonAttachmentModelBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  LessonAttachmentModelBuilder toBuilder() =>
      LessonAttachmentModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LessonAttachmentModel &&
        id == other.id &&
        url == other.url &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        lessonId == other.lessonId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, lessonId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LessonAttachmentModel')
          ..add('id', id)
          ..add('url', url)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('lessonId', lessonId))
        .toString();
  }
}

class LessonAttachmentModelBuilder
    implements Builder<LessonAttachmentModel, LessonAttachmentModelBuilder> {
  _$LessonAttachmentModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  String? _lessonId;
  String? get lessonId => _$this._lessonId;
  set lessonId(String? lessonId) => _$this._lessonId = lessonId;

  LessonAttachmentModelBuilder();

  LessonAttachmentModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _url = $v.url;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _lessonId = $v.lessonId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LessonAttachmentModel other) {
    _$v = other as _$LessonAttachmentModel;
  }

  @override
  void update(void Function(LessonAttachmentModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LessonAttachmentModel build() => _build();

  _$LessonAttachmentModel _build() {
    final _$result =
        _$v ??
        _$LessonAttachmentModel._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'LessonAttachmentModel',
            'id',
          ),
          url: BuiltValueNullFieldError.checkNotNull(
            url,
            r'LessonAttachmentModel',
            'url',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'LessonAttachmentModel',
            'createdAt',
          ),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
            updatedAt,
            r'LessonAttachmentModel',
            'updatedAt',
          ),
          lessonId: BuiltValueNullFieldError.checkNotNull(
            lessonId,
            r'LessonAttachmentModel',
            'lessonId',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

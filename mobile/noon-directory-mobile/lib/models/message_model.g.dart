// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<MessageModel> _$messageModelSerializer = _$MessageModelSerializer();

class _$MessageModelSerializer implements StructuredSerializer<MessageModel> {
  @override
  final Iterable<Type> types = const [MessageModel, _$MessageModel];
  @override
  final String wireName = 'MessageModel';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    MessageModel object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      '_id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'message',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'senderId',
      serializers.serialize(
        object.senderId,
        specifiedType: const FullType(String),
      ),
      'senderName',
      serializers.serialize(
        object.senderName,
        specifiedType: const FullType(String),
      ),
      'senderType',
      serializers.serialize(
        object.senderType,
        specifiedType: const FullType(String),
      ),
      'createdAt',
      serializers.serialize(
        object.createdAt,
        specifiedType: const FullType(DateTime),
      ),
      'roomId',
      serializers.serialize(
        object.roomId,
        specifiedType: const FullType(String),
      ),
    ];
    Object? value;
    value = object.messageType;
    if (value != null) {
      result
        ..add('messageType')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.fileName;
    if (value != null) {
      result
        ..add('fileName')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.fileUrl;
    if (value != null) {
      result
        ..add('fileUrl')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.fileSize;
    if (value != null) {
      result
        ..add('fileSize')
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.fileMimeType;
    if (value != null) {
      result
        ..add('fileMimeType')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.fileDuration;
    if (value != null) {
      result
        ..add('fileDuration')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(double)),
        );
    }
    return result;
  }

  @override
  MessageModel deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MessageModelBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current! as String;
      iterator.moveNext();
      final Object? value = iterator.current;
      switch (key) {
        case '_id':
          result.id =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'message':
          result.text =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'senderId':
          result.senderId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'senderName':
          result.senderName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'senderType':
          result.senderType =
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
        case 'roomId':
          result.roomId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'messageType':
          result.messageType =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'fileName':
          result.fileName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'fileUrl':
          result.fileUrl =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'fileSize':
          result.fileSize =
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'fileMimeType':
          result.fileMimeType =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'fileDuration':
          result.fileDuration =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(double),
                  )
                  as double?;
          break;
      }
    }

    return result.build();
  }
}

class _$MessageModel extends MessageModel {
  @override
  final String id;
  @override
  final String text;
  @override
  final String senderId;
  @override
  final String senderName;
  @override
  final String senderType;
  @override
  final DateTime createdAt;
  @override
  final String roomId;
  @override
  final String? messageType;
  @override
  final String? fileName;
  @override
  final String? fileUrl;
  @override
  final int? fileSize;
  @override
  final String? fileMimeType;
  @override
  final double? fileDuration;

  factory _$MessageModel([void Function(MessageModelBuilder)? updates]) =>
      (MessageModelBuilder()..update(updates))._build();

  _$MessageModel._({
    required this.id,
    required this.text,
    required this.senderId,
    required this.senderName,
    required this.senderType,
    required this.createdAt,
    required this.roomId,
    this.messageType,
    this.fileName,
    this.fileUrl,
    this.fileSize,
    this.fileMimeType,
    this.fileDuration,
  }) : super._();
  @override
  MessageModel rebuild(void Function(MessageModelBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MessageModelBuilder toBuilder() => MessageModelBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MessageModel &&
        id == other.id &&
        text == other.text &&
        senderId == other.senderId &&
        senderName == other.senderName &&
        senderType == other.senderType &&
        createdAt == other.createdAt &&
        roomId == other.roomId &&
        messageType == other.messageType &&
        fileName == other.fileName &&
        fileUrl == other.fileUrl &&
        fileSize == other.fileSize &&
        fileMimeType == other.fileMimeType &&
        fileDuration == other.fileDuration;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, text.hashCode);
    _$hash = $jc(_$hash, senderId.hashCode);
    _$hash = $jc(_$hash, senderName.hashCode);
    _$hash = $jc(_$hash, senderType.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, roomId.hashCode);
    _$hash = $jc(_$hash, messageType.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, fileUrl.hashCode);
    _$hash = $jc(_$hash, fileSize.hashCode);
    _$hash = $jc(_$hash, fileMimeType.hashCode);
    _$hash = $jc(_$hash, fileDuration.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MessageModel')
          ..add('id', id)
          ..add('text', text)
          ..add('senderId', senderId)
          ..add('senderName', senderName)
          ..add('senderType', senderType)
          ..add('createdAt', createdAt)
          ..add('roomId', roomId)
          ..add('messageType', messageType)
          ..add('fileName', fileName)
          ..add('fileUrl', fileUrl)
          ..add('fileSize', fileSize)
          ..add('fileMimeType', fileMimeType)
          ..add('fileDuration', fileDuration))
        .toString();
  }
}

class MessageModelBuilder
    implements Builder<MessageModel, MessageModelBuilder> {
  _$MessageModel? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _text;
  String? get text => _$this._text;
  set text(String? text) => _$this._text = text;

  String? _senderId;
  String? get senderId => _$this._senderId;
  set senderId(String? senderId) => _$this._senderId = senderId;

  String? _senderName;
  String? get senderName => _$this._senderName;
  set senderName(String? senderName) => _$this._senderName = senderName;

  String? _senderType;
  String? get senderType => _$this._senderType;
  set senderType(String? senderType) => _$this._senderType = senderType;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _roomId;
  String? get roomId => _$this._roomId;
  set roomId(String? roomId) => _$this._roomId = roomId;

  String? _messageType;
  String? get messageType => _$this._messageType;
  set messageType(String? messageType) => _$this._messageType = messageType;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  String? _fileUrl;
  String? get fileUrl => _$this._fileUrl;
  set fileUrl(String? fileUrl) => _$this._fileUrl = fileUrl;

  int? _fileSize;
  int? get fileSize => _$this._fileSize;
  set fileSize(int? fileSize) => _$this._fileSize = fileSize;

  String? _fileMimeType;
  String? get fileMimeType => _$this._fileMimeType;
  set fileMimeType(String? fileMimeType) => _$this._fileMimeType = fileMimeType;

  double? _fileDuration;
  double? get fileDuration => _$this._fileDuration;
  set fileDuration(double? fileDuration) => _$this._fileDuration = fileDuration;

  MessageModelBuilder();

  MessageModelBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _text = $v.text;
      _senderId = $v.senderId;
      _senderName = $v.senderName;
      _senderType = $v.senderType;
      _createdAt = $v.createdAt;
      _roomId = $v.roomId;
      _messageType = $v.messageType;
      _fileName = $v.fileName;
      _fileUrl = $v.fileUrl;
      _fileSize = $v.fileSize;
      _fileMimeType = $v.fileMimeType;
      _fileDuration = $v.fileDuration;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MessageModel other) {
    _$v = other as _$MessageModel;
  }

  @override
  void update(void Function(MessageModelBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MessageModel build() => _build();

  _$MessageModel _build() {
    final _$result =
        _$v ??
        _$MessageModel._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'MessageModel', 'id'),
          text: BuiltValueNullFieldError.checkNotNull(
            text,
            r'MessageModel',
            'text',
          ),
          senderId: BuiltValueNullFieldError.checkNotNull(
            senderId,
            r'MessageModel',
            'senderId',
          ),
          senderName: BuiltValueNullFieldError.checkNotNull(
            senderName,
            r'MessageModel',
            'senderName',
          ),
          senderType: BuiltValueNullFieldError.checkNotNull(
            senderType,
            r'MessageModel',
            'senderType',
          ),
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'MessageModel',
            'createdAt',
          ),
          roomId: BuiltValueNullFieldError.checkNotNull(
            roomId,
            r'MessageModel',
            'roomId',
          ),
          messageType: messageType,
          fileName: fileName,
          fileUrl: fileUrl,
          fileSize: fileSize,
          fileMimeType: fileMimeType,
          fileDuration: fileDuration,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_last_message.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatRoomLastMessage> _$chatRoomLastMessageSerializer =
    _$ChatRoomLastMessageSerializer();

class _$ChatRoomLastMessageSerializer
    implements StructuredSerializer<ChatRoomLastMessage> {
  @override
  final Iterable<Type> types = const [
    ChatRoomLastMessage,
    _$ChatRoomLastMessage,
  ];
  @override
  final String wireName = 'ChatRoomLastMessage';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ChatRoomLastMessage object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'content',
      serializers.serialize(
        object.content,
        specifiedType: const FullType(String),
      ),
      'messageType',
      serializers.serialize(
        object.messageType,
        specifiedType: const FullType(String),
      ),
      'senderId',
      serializers.serialize(
        object.senderId,
        specifiedType: const FullType(String),
      ),
      'senderType',
      serializers.serialize(
        object.senderType,
        specifiedType: const FullType(String),
      ),
      'senderName',
      serializers.serialize(
        object.senderName,
        specifiedType: const FullType(String),
      ),
      'roomId',
      serializers.serialize(
        object.roomId,
        specifiedType: const FullType(String),
      ),
      'schoolId',
      serializers.serialize(
        object.schoolId,
        specifiedType: const FullType(String),
      ),
      'isDeleted',
      serializers.serialize(
        object.isDeletedString,
        specifiedType: const FullType(String),
      ),
      'isEdited',
      serializers.serialize(
        object.isEditedString,
        specifiedType: const FullType(String),
      ),
      'isRead',
      serializers.serialize(
        object.isReadString,
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
    ];
    Object? value;
    value = object.fileName;
    if (value != null) {
      result
        ..add('fileName')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.filePath;
    if (value != null) {
      result
        ..add('filePath')
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
        ..add(serializers.serialize(value, specifiedType: const FullType(int)));
    }
    value = object.readAt;
    if (value != null) {
      result
        ..add('readAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    value = object.editedAt;
    if (value != null) {
      result
        ..add('editedAt')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(DateTime)),
        );
    }
    return result;
  }

  @override
  ChatRoomLastMessage deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatRoomLastMessageBuilder();

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
        case 'content':
          result.content =
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
                  )!
                  as String;
          break;
        case 'fileName':
          result.fileName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'filePath':
          result.filePath =
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
              serializers.deserialize(value, specifiedType: const FullType(int))
                  as int?;
          break;
        case 'senderId':
          result.senderId =
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
        case 'senderName':
          result.senderName =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'roomId':
          result.roomId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'schoolId':
          result.schoolId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'isDeleted':
          result.isDeletedString =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'isEdited':
          result.isEditedString =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'isRead':
          result.isReadString =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'readAt':
          result.readAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
          break;
        case 'editedAt':
          result.editedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )
                  as DateTime?;
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
      }
    }

    return result.build();
  }
}

class _$ChatRoomLastMessage extends ChatRoomLastMessage {
  @override
  final String id;
  @override
  final String content;
  @override
  final String messageType;
  @override
  final String? fileName;
  @override
  final String? filePath;
  @override
  final String? fileUrl;
  @override
  final int? fileSize;
  @override
  final String? fileMimeType;
  @override
  final int? fileDuration;
  @override
  final String senderId;
  @override
  final String senderType;
  @override
  final String senderName;
  @override
  final String roomId;
  @override
  final String schoolId;
  @override
  final String isDeletedString;
  @override
  final String isEditedString;
  @override
  final String isReadString;
  @override
  final DateTime? readAt;
  @override
  final DateTime? editedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  factory _$ChatRoomLastMessage([
    void Function(ChatRoomLastMessageBuilder)? updates,
  ]) => (ChatRoomLastMessageBuilder()..update(updates))._build();

  _$ChatRoomLastMessage._({
    required this.id,
    required this.content,
    required this.messageType,
    this.fileName,
    this.filePath,
    this.fileUrl,
    this.fileSize,
    this.fileMimeType,
    this.fileDuration,
    required this.senderId,
    required this.senderType,
    required this.senderName,
    required this.roomId,
    required this.schoolId,
    required this.isDeletedString,
    required this.isEditedString,
    required this.isReadString,
    this.readAt,
    this.editedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : super._();
  @override
  ChatRoomLastMessage rebuild(
    void Function(ChatRoomLastMessageBuilder) updates,
  ) => (toBuilder()..update(updates)).build();

  @override
  ChatRoomLastMessageBuilder toBuilder() =>
      ChatRoomLastMessageBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatRoomLastMessage &&
        id == other.id &&
        content == other.content &&
        messageType == other.messageType &&
        fileName == other.fileName &&
        filePath == other.filePath &&
        fileUrl == other.fileUrl &&
        fileSize == other.fileSize &&
        fileMimeType == other.fileMimeType &&
        fileDuration == other.fileDuration &&
        senderId == other.senderId &&
        senderType == other.senderType &&
        senderName == other.senderName &&
        roomId == other.roomId &&
        schoolId == other.schoolId &&
        isDeletedString == other.isDeletedString &&
        isEditedString == other.isEditedString &&
        isReadString == other.isReadString &&
        readAt == other.readAt &&
        editedAt == other.editedAt &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, content.hashCode);
    _$hash = $jc(_$hash, messageType.hashCode);
    _$hash = $jc(_$hash, fileName.hashCode);
    _$hash = $jc(_$hash, filePath.hashCode);
    _$hash = $jc(_$hash, fileUrl.hashCode);
    _$hash = $jc(_$hash, fileSize.hashCode);
    _$hash = $jc(_$hash, fileMimeType.hashCode);
    _$hash = $jc(_$hash, fileDuration.hashCode);
    _$hash = $jc(_$hash, senderId.hashCode);
    _$hash = $jc(_$hash, senderType.hashCode);
    _$hash = $jc(_$hash, senderName.hashCode);
    _$hash = $jc(_$hash, roomId.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, isDeletedString.hashCode);
    _$hash = $jc(_$hash, isEditedString.hashCode);
    _$hash = $jc(_$hash, isReadString.hashCode);
    _$hash = $jc(_$hash, readAt.hashCode);
    _$hash = $jc(_$hash, editedAt.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatRoomLastMessage')
          ..add('id', id)
          ..add('content', content)
          ..add('messageType', messageType)
          ..add('fileName', fileName)
          ..add('filePath', filePath)
          ..add('fileUrl', fileUrl)
          ..add('fileSize', fileSize)
          ..add('fileMimeType', fileMimeType)
          ..add('fileDuration', fileDuration)
          ..add('senderId', senderId)
          ..add('senderType', senderType)
          ..add('senderName', senderName)
          ..add('roomId', roomId)
          ..add('schoolId', schoolId)
          ..add('isDeletedString', isDeletedString)
          ..add('isEditedString', isEditedString)
          ..add('isReadString', isReadString)
          ..add('readAt', readAt)
          ..add('editedAt', editedAt)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt))
        .toString();
  }
}

class ChatRoomLastMessageBuilder
    implements Builder<ChatRoomLastMessage, ChatRoomLastMessageBuilder> {
  _$ChatRoomLastMessage? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _content;
  String? get content => _$this._content;
  set content(String? content) => _$this._content = content;

  String? _messageType;
  String? get messageType => _$this._messageType;
  set messageType(String? messageType) => _$this._messageType = messageType;

  String? _fileName;
  String? get fileName => _$this._fileName;
  set fileName(String? fileName) => _$this._fileName = fileName;

  String? _filePath;
  String? get filePath => _$this._filePath;
  set filePath(String? filePath) => _$this._filePath = filePath;

  String? _fileUrl;
  String? get fileUrl => _$this._fileUrl;
  set fileUrl(String? fileUrl) => _$this._fileUrl = fileUrl;

  int? _fileSize;
  int? get fileSize => _$this._fileSize;
  set fileSize(int? fileSize) => _$this._fileSize = fileSize;

  String? _fileMimeType;
  String? get fileMimeType => _$this._fileMimeType;
  set fileMimeType(String? fileMimeType) => _$this._fileMimeType = fileMimeType;

  int? _fileDuration;
  int? get fileDuration => _$this._fileDuration;
  set fileDuration(int? fileDuration) => _$this._fileDuration = fileDuration;

  String? _senderId;
  String? get senderId => _$this._senderId;
  set senderId(String? senderId) => _$this._senderId = senderId;

  String? _senderType;
  String? get senderType => _$this._senderType;
  set senderType(String? senderType) => _$this._senderType = senderType;

  String? _senderName;
  String? get senderName => _$this._senderName;
  set senderName(String? senderName) => _$this._senderName = senderName;

  String? _roomId;
  String? get roomId => _$this._roomId;
  set roomId(String? roomId) => _$this._roomId = roomId;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  String? _isDeletedString;
  String? get isDeletedString => _$this._isDeletedString;
  set isDeletedString(String? isDeletedString) =>
      _$this._isDeletedString = isDeletedString;

  String? _isEditedString;
  String? get isEditedString => _$this._isEditedString;
  set isEditedString(String? isEditedString) =>
      _$this._isEditedString = isEditedString;

  String? _isReadString;
  String? get isReadString => _$this._isReadString;
  set isReadString(String? isReadString) => _$this._isReadString = isReadString;

  DateTime? _readAt;
  DateTime? get readAt => _$this._readAt;
  set readAt(DateTime? readAt) => _$this._readAt = readAt;

  DateTime? _editedAt;
  DateTime? get editedAt => _$this._editedAt;
  set editedAt(DateTime? editedAt) => _$this._editedAt = editedAt;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ChatRoomLastMessageBuilder();

  ChatRoomLastMessageBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _content = $v.content;
      _messageType = $v.messageType;
      _fileName = $v.fileName;
      _filePath = $v.filePath;
      _fileUrl = $v.fileUrl;
      _fileSize = $v.fileSize;
      _fileMimeType = $v.fileMimeType;
      _fileDuration = $v.fileDuration;
      _senderId = $v.senderId;
      _senderType = $v.senderType;
      _senderName = $v.senderName;
      _roomId = $v.roomId;
      _schoolId = $v.schoolId;
      _isDeletedString = $v.isDeletedString;
      _isEditedString = $v.isEditedString;
      _isReadString = $v.isReadString;
      _readAt = $v.readAt;
      _editedAt = $v.editedAt;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatRoomLastMessage other) {
    _$v = other as _$ChatRoomLastMessage;
  }

  @override
  void update(void Function(ChatRoomLastMessageBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatRoomLastMessage build() => _build();

  _$ChatRoomLastMessage _build() {
    final _$result =
        _$v ??
        _$ChatRoomLastMessage._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ChatRoomLastMessage',
            'id',
          ),
          content: BuiltValueNullFieldError.checkNotNull(
            content,
            r'ChatRoomLastMessage',
            'content',
          ),
          messageType: BuiltValueNullFieldError.checkNotNull(
            messageType,
            r'ChatRoomLastMessage',
            'messageType',
          ),
          fileName: fileName,
          filePath: filePath,
          fileUrl: fileUrl,
          fileSize: fileSize,
          fileMimeType: fileMimeType,
          fileDuration: fileDuration,
          senderId: BuiltValueNullFieldError.checkNotNull(
            senderId,
            r'ChatRoomLastMessage',
            'senderId',
          ),
          senderType: BuiltValueNullFieldError.checkNotNull(
            senderType,
            r'ChatRoomLastMessage',
            'senderType',
          ),
          senderName: BuiltValueNullFieldError.checkNotNull(
            senderName,
            r'ChatRoomLastMessage',
            'senderName',
          ),
          roomId: BuiltValueNullFieldError.checkNotNull(
            roomId,
            r'ChatRoomLastMessage',
            'roomId',
          ),
          schoolId: BuiltValueNullFieldError.checkNotNull(
            schoolId,
            r'ChatRoomLastMessage',
            'schoolId',
          ),
          isDeletedString: BuiltValueNullFieldError.checkNotNull(
            isDeletedString,
            r'ChatRoomLastMessage',
            'isDeletedString',
          ),
          isEditedString: BuiltValueNullFieldError.checkNotNull(
            isEditedString,
            r'ChatRoomLastMessage',
            'isEditedString',
          ),
          isReadString: BuiltValueNullFieldError.checkNotNull(
            isReadString,
            r'ChatRoomLastMessage',
            'isReadString',
          ),
          readAt: readAt,
          editedAt: editedAt,
          createdAt: BuiltValueNullFieldError.checkNotNull(
            createdAt,
            r'ChatRoomLastMessage',
            'createdAt',
          ),
          updatedAt: BuiltValueNullFieldError.checkNotNull(
            updatedAt,
            r'ChatRoomLastMessage',
            'updatedAt',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

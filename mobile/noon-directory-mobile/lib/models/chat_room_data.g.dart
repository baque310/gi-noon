// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatRoomData> _$chatRoomDataSerializer = _$ChatRoomDataSerializer();

class _$ChatRoomDataSerializer implements StructuredSerializer<ChatRoomData> {
  @override
  final Iterable<Type> types = const [ChatRoomData, _$ChatRoomData];
  @override
  final String wireName = 'ChatRoomData';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ChatRoomData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'name',
      serializers.serialize(object.name, specifiedType: const FullType(String)),
      'type',
      serializers.serialize(object.type, specifiedType: const FullType(String)),
      'schoolId',
      serializers.serialize(
        object.schoolId,
        specifiedType: const FullType(String),
      ),
      'createdBy',
      serializers.serialize(
        object.createdBy,
        specifiedType: const FullType(String),
      ),
      'isActive',
      serializers.serialize(
        object.isActiveString,
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
      'ChatRoomMember',
      serializers.serialize(
        object.chatRoomMember,
        specifiedType: const FullType(BuiltList, const [
          const FullType(ChatRoomMember),
        ]),
      ),
      'unreadCount',
      serializers.serialize(
        object.unreadCount,
        specifiedType: const FullType(int),
      ),
    ];
    Object? value;
    value = object.rocketChatId;
    if (value != null) {
      result
        ..add('rocketChatId')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.uniqueCode;
    if (value != null) {
      result
        ..add('uniqueCode')
        ..add(
          serializers.serialize(value, specifiedType: const FullType(String)),
        );
    }
    value = object.lastMessage;
    if (value != null) {
      result
        ..add('lastMessage')
        ..add(
          serializers.serialize(
            value,
            specifiedType: const FullType(ChatRoomLastMessage),
          ),
        );
    }
    return result;
  }

  @override
  ChatRoomData deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatRoomDataBuilder();

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
        case 'rocketChatId':
          result.rocketChatId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'name':
          result.name =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'uniqueCode':
          result.uniqueCode =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )
                  as String?;
          break;
        case 'type':
          result.type =
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
        case 'createdBy':
          result.createdBy =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'isActive':
          result.isActiveString =
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
        case 'lastMessage':
          result.lastMessage.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(ChatRoomLastMessage),
                )!
                as ChatRoomLastMessage,
          );
          break;
        case 'ChatRoomMember':
          result.chatRoomMember.replace(
            serializers.deserialize(
                  value,
                  specifiedType: const FullType(BuiltList, const [
                    const FullType(ChatRoomMember),
                  ]),
                )!
                as BuiltList<Object?>,
          );
          break;
        case 'unreadCount':
          result.unreadCount =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(int),
                  )!
                  as int;
          break;
      }
    }

    return result.build();
  }
}

class _$ChatRoomData extends ChatRoomData {
  @override
  final String id;
  @override
  final String? rocketChatId;
  @override
  final String name;
  @override
  final String? uniqueCode;
  @override
  final String type;
  @override
  final String schoolId;
  @override
  final String createdBy;
  @override
  final String isActiveString;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final ChatRoomLastMessage? lastMessage;
  @override
  final BuiltList<ChatRoomMember> chatRoomMember;
  @override
  final int unreadCount;

  factory _$ChatRoomData([void Function(ChatRoomDataBuilder)? updates]) =>
      (ChatRoomDataBuilder()..update(updates))._build();

  _$ChatRoomData._({
    required this.id,
    this.rocketChatId,
    required this.name,
    this.uniqueCode,
    required this.type,
    required this.schoolId,
    required this.createdBy,
    required this.isActiveString,
    required this.createdAt,
    required this.updatedAt,
    this.lastMessage,
    required this.chatRoomMember,
    required this.unreadCount,
  }) : super._();
  @override
  ChatRoomData rebuild(void Function(ChatRoomDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatRoomDataBuilder toBuilder() => ChatRoomDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatRoomData &&
        id == other.id &&
        rocketChatId == other.rocketChatId &&
        name == other.name &&
        uniqueCode == other.uniqueCode &&
        type == other.type &&
        schoolId == other.schoolId &&
        createdBy == other.createdBy &&
        isActiveString == other.isActiveString &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        lastMessage == other.lastMessage &&
        chatRoomMember == other.chatRoomMember &&
        unreadCount == other.unreadCount;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, rocketChatId.hashCode);
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, uniqueCode.hashCode);
    _$hash = $jc(_$hash, type.hashCode);
    _$hash = $jc(_$hash, schoolId.hashCode);
    _$hash = $jc(_$hash, createdBy.hashCode);
    _$hash = $jc(_$hash, isActiveString.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, updatedAt.hashCode);
    _$hash = $jc(_$hash, lastMessage.hashCode);
    _$hash = $jc(_$hash, chatRoomMember.hashCode);
    _$hash = $jc(_$hash, unreadCount.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatRoomData')
          ..add('id', id)
          ..add('rocketChatId', rocketChatId)
          ..add('name', name)
          ..add('uniqueCode', uniqueCode)
          ..add('type', type)
          ..add('schoolId', schoolId)
          ..add('createdBy', createdBy)
          ..add('isActiveString', isActiveString)
          ..add('createdAt', createdAt)
          ..add('updatedAt', updatedAt)
          ..add('lastMessage', lastMessage)
          ..add('chatRoomMember', chatRoomMember)
          ..add('unreadCount', unreadCount))
        .toString();
  }
}

class ChatRoomDataBuilder
    implements Builder<ChatRoomData, ChatRoomDataBuilder> {
  _$ChatRoomData? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _rocketChatId;
  String? get rocketChatId => _$this._rocketChatId;
  set rocketChatId(String? rocketChatId) => _$this._rocketChatId = rocketChatId;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _uniqueCode;
  String? get uniqueCode => _$this._uniqueCode;
  set uniqueCode(String? uniqueCode) => _$this._uniqueCode = uniqueCode;

  String? _type;
  String? get type => _$this._type;
  set type(String? type) => _$this._type = type;

  String? _schoolId;
  String? get schoolId => _$this._schoolId;
  set schoolId(String? schoolId) => _$this._schoolId = schoolId;

  String? _createdBy;
  String? get createdBy => _$this._createdBy;
  set createdBy(String? createdBy) => _$this._createdBy = createdBy;

  String? _isActiveString;
  String? get isActiveString => _$this._isActiveString;
  set isActiveString(String? isActiveString) =>
      _$this._isActiveString = isActiveString;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  DateTime? _updatedAt;
  DateTime? get updatedAt => _$this._updatedAt;
  set updatedAt(DateTime? updatedAt) => _$this._updatedAt = updatedAt;

  ChatRoomLastMessageBuilder? _lastMessage;
  ChatRoomLastMessageBuilder get lastMessage =>
      _$this._lastMessage ??= ChatRoomLastMessageBuilder();
  set lastMessage(ChatRoomLastMessageBuilder? lastMessage) =>
      _$this._lastMessage = lastMessage;

  ListBuilder<ChatRoomMember>? _chatRoomMember;
  ListBuilder<ChatRoomMember> get chatRoomMember =>
      _$this._chatRoomMember ??= ListBuilder<ChatRoomMember>();
  set chatRoomMember(ListBuilder<ChatRoomMember>? chatRoomMember) =>
      _$this._chatRoomMember = chatRoomMember;

  int? _unreadCount;
  int? get unreadCount => _$this._unreadCount;
  set unreadCount(int? unreadCount) => _$this._unreadCount = unreadCount;

  ChatRoomDataBuilder();

  ChatRoomDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _rocketChatId = $v.rocketChatId;
      _name = $v.name;
      _uniqueCode = $v.uniqueCode;
      _type = $v.type;
      _schoolId = $v.schoolId;
      _createdBy = $v.createdBy;
      _isActiveString = $v.isActiveString;
      _createdAt = $v.createdAt;
      _updatedAt = $v.updatedAt;
      _lastMessage = $v.lastMessage?.toBuilder();
      _chatRoomMember = $v.chatRoomMember.toBuilder();
      _unreadCount = $v.unreadCount;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatRoomData other) {
    _$v = other as _$ChatRoomData;
  }

  @override
  void update(void Function(ChatRoomDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatRoomData build() => _build();

  _$ChatRoomData _build() {
    _$ChatRoomData _$result;
    try {
      _$result =
          _$v ??
          _$ChatRoomData._(
            id: BuiltValueNullFieldError.checkNotNull(
              id,
              r'ChatRoomData',
              'id',
            ),
            rocketChatId: rocketChatId,
            name: BuiltValueNullFieldError.checkNotNull(
              name,
              r'ChatRoomData',
              'name',
            ),
            uniqueCode: uniqueCode,
            type: BuiltValueNullFieldError.checkNotNull(
              type,
              r'ChatRoomData',
              'type',
            ),
            schoolId: BuiltValueNullFieldError.checkNotNull(
              schoolId,
              r'ChatRoomData',
              'schoolId',
            ),
            createdBy: BuiltValueNullFieldError.checkNotNull(
              createdBy,
              r'ChatRoomData',
              'createdBy',
            ),
            isActiveString: BuiltValueNullFieldError.checkNotNull(
              isActiveString,
              r'ChatRoomData',
              'isActiveString',
            ),
            createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt,
              r'ChatRoomData',
              'createdAt',
            ),
            updatedAt: BuiltValueNullFieldError.checkNotNull(
              updatedAt,
              r'ChatRoomData',
              'updatedAt',
            ),
            lastMessage: _lastMessage?.build(),
            chatRoomMember: chatRoomMember.build(),
            unreadCount: BuiltValueNullFieldError.checkNotNull(
              unreadCount,
              r'ChatRoomData',
              'unreadCount',
            ),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'lastMessage';
        _lastMessage?.build();
        _$failedField = 'chatRoomMember';
        chatRoomMember.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
          r'ChatRoomData',
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

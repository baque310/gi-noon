// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_room_member.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ChatRoomMember> _$chatRoomMemberSerializer =
    _$ChatRoomMemberSerializer();

class _$ChatRoomMemberSerializer
    implements StructuredSerializer<ChatRoomMember> {
  @override
  final Iterable<Type> types = const [ChatRoomMember, _$ChatRoomMember];
  @override
  final String wireName = 'ChatRoomMember';

  @override
  Iterable<Object?> serialize(
    Serializers serializers,
    ChatRoomMember object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = <Object?>[
      'id',
      serializers.serialize(object.id, specifiedType: const FullType(String)),
      'roomId',
      serializers.serialize(
        object.roomId,
        specifiedType: const FullType(String),
      ),
      'userId',
      serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      ),
      'userType',
      serializers.serialize(
        object.userType,
        specifiedType: const FullType(String),
      ),
      'joinedAt',
      serializers.serialize(
        object.joinedAt,
        specifiedType: const FullType(DateTime),
      ),
      'isActive',
      serializers.serialize(
        object.isActiveString,
        specifiedType: const FullType(String),
      ),
      'memberName',
      serializers.serialize(
        object.memberName,
        specifiedType: const FullType(String),
      ),
    ];

    return result;
  }

  @override
  ChatRoomMember deserialize(
    Serializers serializers,
    Iterable<Object?> serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ChatRoomMemberBuilder();

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
        case 'roomId':
          result.roomId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'userId':
          result.userId =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'userType':
          result.userType =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'joinedAt':
          result.joinedAt =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(DateTime),
                  )!
                  as DateTime;
          break;
        case 'isActive':
          result.isActiveString =
              serializers.deserialize(
                    value,
                    specifiedType: const FullType(String),
                  )!
                  as String;
          break;
        case 'memberName':
          result.memberName =
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

class _$ChatRoomMember extends ChatRoomMember {
  @override
  final String id;
  @override
  final String roomId;
  @override
  final String userId;
  @override
  final String userType;
  @override
  final DateTime joinedAt;
  @override
  final String isActiveString;
  @override
  final String memberName;

  factory _$ChatRoomMember([void Function(ChatRoomMemberBuilder)? updates]) =>
      (ChatRoomMemberBuilder()..update(updates))._build();

  _$ChatRoomMember._({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.userType,
    required this.joinedAt,
    required this.isActiveString,
    required this.memberName,
  }) : super._();
  @override
  ChatRoomMember rebuild(void Function(ChatRoomMemberBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ChatRoomMemberBuilder toBuilder() => ChatRoomMemberBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatRoomMember &&
        id == other.id &&
        roomId == other.roomId &&
        userId == other.userId &&
        userType == other.userType &&
        joinedAt == other.joinedAt &&
        isActiveString == other.isActiveString &&
        memberName == other.memberName;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, roomId.hashCode);
    _$hash = $jc(_$hash, userId.hashCode);
    _$hash = $jc(_$hash, userType.hashCode);
    _$hash = $jc(_$hash, joinedAt.hashCode);
    _$hash = $jc(_$hash, isActiveString.hashCode);
    _$hash = $jc(_$hash, memberName.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'ChatRoomMember')
          ..add('id', id)
          ..add('roomId', roomId)
          ..add('userId', userId)
          ..add('userType', userType)
          ..add('joinedAt', joinedAt)
          ..add('isActiveString', isActiveString)
          ..add('memberName', memberName))
        .toString();
  }
}

class ChatRoomMemberBuilder
    implements Builder<ChatRoomMember, ChatRoomMemberBuilder> {
  _$ChatRoomMember? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _roomId;
  String? get roomId => _$this._roomId;
  set roomId(String? roomId) => _$this._roomId = roomId;

  String? _userId;
  String? get userId => _$this._userId;
  set userId(String? userId) => _$this._userId = userId;

  String? _userType;
  String? get userType => _$this._userType;
  set userType(String? userType) => _$this._userType = userType;

  DateTime? _joinedAt;
  DateTime? get joinedAt => _$this._joinedAt;
  set joinedAt(DateTime? joinedAt) => _$this._joinedAt = joinedAt;

  String? _isActiveString;
  String? get isActiveString => _$this._isActiveString;
  set isActiveString(String? isActiveString) =>
      _$this._isActiveString = isActiveString;

  String? _memberName;
  String? get memberName => _$this._memberName;
  set memberName(String? memberName) => _$this._memberName = memberName;

  ChatRoomMemberBuilder();

  ChatRoomMemberBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _roomId = $v.roomId;
      _userId = $v.userId;
      _userType = $v.userType;
      _joinedAt = $v.joinedAt;
      _isActiveString = $v.isActiveString;
      _memberName = $v.memberName;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ChatRoomMember other) {
    _$v = other as _$ChatRoomMember;
  }

  @override
  void update(void Function(ChatRoomMemberBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ChatRoomMember build() => _build();

  _$ChatRoomMember _build() {
    final _$result =
        _$v ??
        _$ChatRoomMember._(
          id: BuiltValueNullFieldError.checkNotNull(
            id,
            r'ChatRoomMember',
            'id',
          ),
          roomId: BuiltValueNullFieldError.checkNotNull(
            roomId,
            r'ChatRoomMember',
            'roomId',
          ),
          userId: BuiltValueNullFieldError.checkNotNull(
            userId,
            r'ChatRoomMember',
            'userId',
          ),
          userType: BuiltValueNullFieldError.checkNotNull(
            userType,
            r'ChatRoomMember',
            'userType',
          ),
          joinedAt: BuiltValueNullFieldError.checkNotNull(
            joinedAt,
            r'ChatRoomMember',
            'joinedAt',
          ),
          isActiveString: BuiltValueNullFieldError.checkNotNull(
            isActiveString,
            r'ChatRoomMember',
            'isActiveString',
          ),
          memberName: BuiltValueNullFieldError.checkNotNull(
            memberName,
            r'ChatRoomMember',
            'memberName',
          ),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:noon/models/serializers.dart';

import 'chat_room_member.dart';
import 'chat_room_last_message.dart';

part 'chat_room_data.g.dart';

abstract class ChatRoomData
    implements Built<ChatRoomData, ChatRoomDataBuilder> {
  String get id;

  String? get rocketChatId;

  String get name;

  String? get uniqueCode;

  String get type;

  String get schoolId;

  String get createdBy;

  @BuiltValueField(wireName: 'isActive')
  String get isActiveString;

  @BuiltValueSerializer(custom: true)
  bool get isActive => isActiveString.toUpperCase() == 'TRUE';

  DateTime get createdAt;

  DateTime get updatedAt;

  @BuiltValueField(wireName: 'lastMessage')
  ChatRoomLastMessage? get lastMessage;

  @BuiltValueField(wireName: 'ChatRoomMember')
  BuiltList<ChatRoomMember> get chatRoomMember;

  int get unreadCount;

  // Constructor
  ChatRoomData._();

  factory ChatRoomData([void Function(ChatRoomDataBuilder) updates]) =
      _$ChatRoomData;

  // Serializer
  static Serializer<ChatRoomData> get serializer => _$chatRoomDataSerializer;

  // fromJson method
  factory ChatRoomData.fromJson(Map<String, dynamic> jsonData) {
    return serializers.deserializeWith(ChatRoomData.serializer, jsonData)!;
  }

  bool get isGroup => type.contains('GROUP');

  bool get isDirectMsg => type == 'DIRECT_MESSAGE';

  String? get lastMessageText => lastMessage?.content;
}

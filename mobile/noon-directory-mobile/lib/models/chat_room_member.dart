import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'chat_room_member.g.dart';

abstract class ChatRoomMember
    implements Built<ChatRoomMember, ChatRoomMemberBuilder> {
  String get id;
  String get roomId;
  String get userId;
  String get userType;
  DateTime get joinedAt;
  @BuiltValueField(wireName: 'isActive')
  String get isActiveString;
  @BuiltValueSerializer(custom: true)
  bool get isActive => isActiveString.toUpperCase() == 'TRUE';
  String get memberName;

  // Constructor
  ChatRoomMember._();
  factory ChatRoomMember([void Function(ChatRoomMemberBuilder) updates]) =
      _$ChatRoomMember;

  // Serializer
  static Serializer<ChatRoomMember> get serializer =>
      _$chatRoomMemberSerializer;

  // fromJson method
  factory ChatRoomMember.fromJson(Map<String, dynamic> jsonData) {
    return serializers.deserializeWith(ChatRoomMember.serializer, jsonData)!;
  }

  // toJson method (optional)
  String toJsonString() {
    return json.encode(
      serializers.serializeWith(ChatRoomMember.serializer, this),
    );
  }
}

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'chat_room_last_message.g.dart';

abstract class ChatRoomLastMessage
    implements Built<ChatRoomLastMessage, ChatRoomLastMessageBuilder> {
  String get id;

  String get content;

  String get messageType;

  String? get fileName;

  String? get filePath;

  String? get fileUrl;

  int? get fileSize;

  String? get fileMimeType;

  int? get fileDuration;

  String get senderId;

  String get senderType;

  String get senderName;

  String get roomId;

  String get schoolId;

  @BuiltValueField(wireName: 'isDeleted')
  String get isDeletedString;

  bool get isDeleted => isDeletedString.toUpperCase() == 'TRUE';

  @BuiltValueField(wireName: 'isEdited')
  String get isEditedString;

  bool get isEdited => isEditedString.toUpperCase() == 'TRUE';

  @BuiltValueField(wireName: 'isRead')
  String get isReadString;

  bool get isRead => isReadString.toUpperCase() == 'TRUE';

  DateTime? get readAt;

  DateTime? get editedAt;

  DateTime get createdAt;

  DateTime get updatedAt;

  ChatRoomLastMessage._();

  factory ChatRoomLastMessage([
    void Function(ChatRoomLastMessageBuilder) updates,
  ]) = _$ChatRoomLastMessage;

  static Serializer<ChatRoomLastMessage> get serializer =>
      _$chatRoomLastMessageSerializer;

  factory ChatRoomLastMessage.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(ChatRoomLastMessage.serializer, json)!;
  }
}

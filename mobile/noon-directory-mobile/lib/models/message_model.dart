import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'message_model.g.dart';

abstract class MessageModel
    implements Built<MessageModel, MessageModelBuilder> {
  @BuiltValueField(wireName: '_id')
  String get id;

  @BuiltValueField(wireName: 'message')
  String get text;

  String get senderId;

  String get senderName;

  String get senderType;

  DateTime get createdAt;

  String get roomId;

  // نوع الرسالة: text, image, file, audio, etc.
  String? get messageType;

  @BuiltValueField(wireName: 'fileName')
  String? get fileName;

  @BuiltValueField(wireName: 'fileUrl')
  String? get fileUrl;

  @BuiltValueField(wireName: 'fileSize')
  int? get fileSize;

  @BuiltValueField(wireName: 'fileMimeType')
  String? get fileMimeType;

  @BuiltValueField(wireName: 'fileDuration')
  double? get fileDuration;

  bool get isImage => messageType == 'image';
  bool get isText => messageType == 'text' || messageType == null;
  bool get isFile => messageType == 'file';
  bool get isAudio => messageType == 'audio';
  bool get validate => isAudio || isFile || isImage || text.isNotEmpty;

  MessageModel._();

  factory MessageModel([void Function(MessageModelBuilder) updates]) =
      _$MessageModel;

  static Serializer<MessageModel> get serializer => _$messageModelSerializer;

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(MessageModel.serializer, json)!;
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(MessageModel.serializer, this)
        as Map<String, dynamic>;
  }
}

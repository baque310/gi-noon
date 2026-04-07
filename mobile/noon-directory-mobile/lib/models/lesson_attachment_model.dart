import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'lesson_attachment_model.g.dart';

abstract class LessonAttachmentModel
    implements Built<LessonAttachmentModel, LessonAttachmentModelBuilder> {
  // Fields
  String get id;

  String get url;

  @BuiltValueField(wireName: 'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: 'lessonId')
  String get lessonId;

  // Constructor
  LessonAttachmentModel._();
  factory LessonAttachmentModel([
    void Function(LessonAttachmentModelBuilder) updates,
  ]) = _$LessonAttachmentModel;

  // Serializer
  static Serializer<LessonAttachmentModel> get serializer =>
      _$lessonAttachmentModelSerializer;

  // fromJson method
  factory LessonAttachmentModel.fromJson(String data) {
    return serializers.deserializeWith(
      LessonAttachmentModel.serializer,
      json.decode(data),
    )!;
  }

  // toJson method
  String toJson() {
    return json.encode(
      serializers.serializeWith(LessonAttachmentModel.serializer, this),
    );
  }
}

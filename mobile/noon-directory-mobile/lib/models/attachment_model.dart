import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'attachment_model.g.dart';

abstract class AttachmentModel
    implements Built<AttachmentModel, AttachmentModelBuilder> {
  String get id;
  String get url;

  AttachmentModel._();

  factory AttachmentModel([void Function(AttachmentModelBuilder) updates]) =
      _$AttachmentModel;

  factory AttachmentModel.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(AttachmentModel.serializer, json)!;
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(AttachmentModel.serializer, this)
        as Map<String, dynamic>;
  }

  static Serializer<AttachmentModel> get serializer =>
      _$attachmentModelSerializer;
}

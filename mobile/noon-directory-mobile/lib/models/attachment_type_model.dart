import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'attachment_type_model.g.dart';

abstract class AttachmentTypeModel
    implements Built<AttachmentTypeModel, AttachmentTypeModelBuilder> {
  String? get id;
  String get title;
  String? get category;
  int? get numberOfSides;

  AttachmentTypeModel._();

  factory AttachmentTypeModel([
    void Function(AttachmentTypeModelBuilder) updates,
  ]) = _$AttachmentTypeModel;

  factory AttachmentTypeModel.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(AttachmentTypeModel.serializer, json)!;
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(AttachmentTypeModel.serializer, this)
        as Map<String, dynamic>;
  }

  static Serializer<AttachmentTypeModel> get serializer =>
      _$attachmentTypeModelSerializer;
}

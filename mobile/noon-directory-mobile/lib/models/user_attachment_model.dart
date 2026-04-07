import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/attachment_type_model.dart';
import 'package:noon/models/serializers.dart';

part 'user_attachment_model.g.dart';

abstract class UserAttachmentModel
    implements Built<UserAttachmentModel, UserAttachmentModelBuilder> {
  String get id;

  @BuiltValueField(wireName: 'url_face')
  String? get urlFace;

  @BuiltValueField(wireName: 'url_back')
  String? get urlBack;

  String? get notes;

  @BuiltValueField(wireName: 'approval_status')
  String? get approvalStatus;

  @BuiltValueField(wireName: 'approval_reason')
  String? get approvalReason;

  @BuiltValueField(wireName: 'approval_date')
  String? get approvalDate;

  bool? get status;

  String? get createdAt;

  String? get updatedAt;

  String? get userId;

  String? get attTypeId;

  @BuiltValueField(wireName: 'AttType')
  AttachmentTypeModel? get attType;

  UserAttachmentModel._();

  factory UserAttachmentModel([
    void Function(UserAttachmentModelBuilder) updates,
  ]) = _$UserAttachmentModel;

  factory UserAttachmentModel.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(UserAttachmentModel.serializer, json)!;
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(UserAttachmentModel.serializer, this)
        as Map<String, dynamic>;
  }

  static Serializer<UserAttachmentModel> get serializer =>
      _$userAttachmentModelSerializer;
}

import 'dart:convert';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/attachment_model.dart';
import 'package:noon/models/school_model.dart';
import 'serializers.dart';

part 'reusable_model.g.dart';

abstract class ReusableModel
    implements Built<ReusableModel, ReusableModelBuilder> {
  // Fields
  String get id;
  String get title;
  String? get description;
  String? get url;
  String? get status;
  DateTime get createdAt;
  DateTime get updatedAt;
  String get schoolId;
  @BuiltValueField(wireName: 'School')
  SchoolModel get school;
  String? get classId;
  String? get sectionId;

  @BuiltValueField(wireName: 'GalleryAttachment')
  BuiltList<AttachmentModel>? get attachments;

  // Constructor
  ReusableModel._();
  factory ReusableModel([void Function(ReusableModelBuilder) updates]) =
      _$ReusableModel;

  // Serializer
  static Serializer<ReusableModel> get serializer => _$reusableModelSerializer;

  // fromJson method
  factory ReusableModel.fromJson(String data) {
    return serializers.deserializeWith(
      ReusableModel.serializer,
      json.decode(data),
    )!;
  }
}

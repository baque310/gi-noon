import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'complaint_model.g.dart';

abstract class ComplaintModel
    implements Built<ComplaintModel, ComplaintModelBuilder> {
  String get id;
  String get title;
  String get description;
  @BuiltValueField(wireName: 'approval_status')
  String get status;
  DateTime get createdAt;

  ComplaintModel._(); // Private constructor

  factory ComplaintModel([void Function(ComplaintModelBuilder) updates]) =
      _$ComplaintModel;

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return serializers.deserializeWith(ComplaintModel.serializer, json)!;
  }

  Map<String, dynamic> toJson() {
    return serializers.serializeWith(ComplaintModel.serializer, this)
        as Map<String, dynamic>;
  }

  static Serializer<ComplaintModel> get serializer =>
      _$complaintModelSerializer;
}

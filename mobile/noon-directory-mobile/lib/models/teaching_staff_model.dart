import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/teacher_subject_model.dart';

part 'teaching_staff_model.g.dart';

abstract class TeachingStaffModel
    implements Built<TeachingStaffModel, TeachingStaffModelBuilder> {
  // Fields
  String get id;
  String? get photo;
  String? get fullName;
  @BuiltValueField(wireName: 'Gender')
  String? get gender;

  @BuiltValueField(wireName: 'TeacherSubject')
  BuiltList<TeacherSubject>? get teacherSubject;

  // Constructor
  TeachingStaffModel._();
  factory TeachingStaffModel([
    void Function(TeachingStaffModelBuilder) updates,
  ]) = _$TeachingStaffModel;

  // Serializer
  static Serializer<TeachingStaffModel> get serializer =>
      _$teachingStaffModelSerializer;

  // FromMap function
  factory TeachingStaffModel.fromMap(Map<String, dynamic> data) {
    return serializers.deserializeWith(TeachingStaffModel.serializer, data)!;
  }

  // FromJson function
  factory TeachingStaffModel.fromJson(String data) {
    return serializers.deserializeWith(
      TeachingStaffModel.serializer,
      json.decode(data),
    )!;
  }
}

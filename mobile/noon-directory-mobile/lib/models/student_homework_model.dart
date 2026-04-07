import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'serializers.dart';

part 'student_homework_model.g.dart';

abstract class StudentHomeworkModel
    implements Built<StudentHomeworkModel, StudentHomeworkModelBuilder> {
  String get id;
  @BuiltValueField(wireName: 'HomeworkStatus')
  String get homeworkStatus;
  DateTime? get completedAt;
  String? get studentId;
  String? get homeworkId;

  StudentHomeworkModel._();
  factory StudentHomeworkModel(
          [void Function(StudentHomeworkModelBuilder) updates]) =
      _$StudentHomeworkModel;

  static Serializer<StudentHomeworkModel> get serializer =>
      _$studentHomeworkModelSerializer;

  factory StudentHomeworkModel.fromJson(String jsonStr) {
    return serializers.deserializeWith(
      StudentHomeworkModel.serializer,
      json.decode(jsonStr),
    )!;
  }
}

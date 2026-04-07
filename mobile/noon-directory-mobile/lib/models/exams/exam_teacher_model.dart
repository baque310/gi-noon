import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'exam_teacher_model.g.dart';

abstract class ExamTeacherModel
    implements Built<ExamTeacherModel, ExamTeacherModelBuilder> {
  ExamTeacherModel._();

  String get id;
  String get fullName;

  factory ExamTeacherModel([void Function(ExamTeacherModelBuilder) updates]) =
      _$ExamTeacherModel;

  static Serializer<ExamTeacherModel> get serializer =>
      _$examTeacherModelSerializer;

  factory ExamTeacherModel.fromJson(String data) {
    return serializers.deserializeWith(
      ExamTeacherModel.serializer,
      json.decode(data),
    )!;
  }
}

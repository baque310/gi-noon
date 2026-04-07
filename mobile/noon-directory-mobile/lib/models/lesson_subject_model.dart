import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/lesson_model.dart';
import 'package:noon/models/serializers.dart';

part 'lesson_subject_model.g.dart';

// Subject model
abstract class LessonSubjectModel
    implements Built<LessonSubjectModel, LessonSubjectModelBuilder> {
  String? get subjectId;
  String? get subjectName;
  int? get lessonCount;
  BuiltList<LessonModel>? get lessons;

  // Constructor
  LessonSubjectModel._();
  factory LessonSubjectModel([
    void Function(LessonSubjectModelBuilder) updates,
  ]) = _$LessonSubjectModel;

  // Serializer
  static Serializer<LessonSubjectModel> get serializer =>
      _$lessonSubjectModelSerializer;

  // fromJson method
  factory LessonSubjectModel.fromJson(String data) {
    return serializers.deserializeWith(
      LessonSubjectModel.serializer,
      json.decode(data),
    )!;
  }
}

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/school_year_model.dart';
import 'package:noon/models/lesson_attachment_model.dart';
import 'package:noon/models/serializers.dart';

part 'lesson_model.g.dart';

abstract class LessonModel implements Built<LessonModel, LessonModelBuilder> {
  // Fields
  String get id;
  String get title;
  String get content;

  @BuiltValueField(wireName: 'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: 'teacherSubjectId')
  String get teacherSubjectId;

  @BuiltValueField(wireName: 'sectionId')
  String? get sectionId;

  @BuiltValueField(wireName: 'schoolYearId')
  String get schoolYearId;

  @BuiltValueField(wireName: 'schoolId')
  String get schoolId;

  @BuiltValueField(wireName: 'teacherSubject')
  TeacherSubject get teacherSubject;

  @BuiltValueField(wireName: 'Section')
  Section get section;

  @BuiltValueField(wireName: 'SchoolYear')
  SchoolYear get schoolYear;

  @BuiltValueField(wireName: 'LessonAttachment')
  BuiltList<LessonAttachmentModel> get lessonAttachment;

  // Constructor
  LessonModel._();
  factory LessonModel([void Function(LessonModelBuilder) updates]) =
      _$LessonModel;

  // Serializer
  static Serializer<LessonModel> get serializer => _$lessonModelSerializer;

  // fromJson method
  factory LessonModel.fromJson(String data) {
    return serializers.deserializeWith(
      LessonModel.serializer,
      json.decode(data),
    )!;
  }
}

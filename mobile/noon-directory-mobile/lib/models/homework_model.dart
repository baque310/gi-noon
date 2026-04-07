import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/attachment_model.dart';
import 'package:noon/models/school_year_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/models/student_homework_model.dart';
import 'serializers.dart';

part 'homework_model.g.dart';

abstract class HomeworkModel
    implements Built<HomeworkModel, HomeworkModelBuilder> {
  String? get id;
  String get title;
  DateTime get dueDate;
  String get content;
  DateTime get createdAt;
  DateTime get updatedAt;
  String get teacherSubjectId;
  String? get sectionId;
  String get schoolYearId;
  String get schoolId;
  TeacherSubject get teacherSubject;
  @BuiltValueField(wireName: 'Section')
  Section get section;
  @BuiltValueField(wireName: 'SchoolYear')
  SchoolYear get schoolYear;
  @BuiltValueField(wireName: 'HomeworkAttachment')
  BuiltList<AttachmentModel> get attachments;
  @BuiltValueField(wireName: 'StudentHomework')
  BuiltList<StudentHomeworkModel>? get studentHomeworks;

  HomeworkModel._();
  factory HomeworkModel([void Function(HomeworkModelBuilder) updates]) =
      _$HomeworkModel;

  static Serializer<HomeworkModel> get serializer => _$homeworkModelSerializer;

  factory HomeworkModel.fromJson(String jsonStr) {
    return serializers.deserializeWith(
      HomeworkModel.serializer,
      json.decode(jsonStr),
    )!;
  }
}

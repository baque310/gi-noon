import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/degrees_model.dart';
import 'package:noon/models/exams/exam_teacher_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/stage_subject_model.dart';

part 'exam_section_model.g.dart';

abstract class ExamSectionModel
    implements Built<ExamSectionModel, ExamSectionModelBuilder> {
  String? get id;
  DateTime? get examDate;
  @BuiltValueField(wireName: 'Section')
  Section? get section;

  @BuiltValueField(wireName: 'teachers')
  BuiltList<ExamTeacherModel> get teachers;

  @BuiltValueField(wireName: 'Exam')
  Exam? get exam;

  @BuiltValueField(wireName: 'ExamResult')
  BuiltList<DegreesModel>? get examResult;

  ExamSectionModel._();
  factory ExamSectionModel([void Function(ExamSectionModelBuilder) updates]) =
      _$ExamSectionModel;

  static Serializer<ExamSectionModel> get serializer =>
      _$examSectionModelSerializer;

  // Function to deserialize from JSON
  factory ExamSectionModel.fromJson(String data) {
    return serializers.deserializeWith(
      ExamSectionModel.serializer,
      json.decode(data),
    )!;
  }
}

abstract class Exam implements Built<Exam, ExamBuilder> {
  String? get id;

  String? get content;
  int? get score;

  @BuiltValueField(wireName: 'ExamType')
  ExamType? get examType;

  @BuiltValueField(wireName: 'StageSubject')
  StageSubjectModel get stageSubject;

  Exam._();
  factory Exam([void Function(ExamBuilder) updates]) = _$Exam;

  static Serializer<Exam> get serializer => _$examSerializer;
}

abstract class ExamType implements Built<ExamType, ExamTypeBuilder> {
  String? get id;
  String? get name;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  String? get schoolId;

  ExamType._();
  factory ExamType([void Function(ExamTypeBuilder) updates]) = _$ExamType;

  static Serializer<ExamType> get serializer => _$examTypeSerializer;
}

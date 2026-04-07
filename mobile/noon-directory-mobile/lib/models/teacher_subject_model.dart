import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/subject_model.dart';
import 'package:noon/models/teacher_model.dart';

part 'teacher_subject_model.g.dart';

abstract class TeacherSubject
    implements Built<TeacherSubject, TeacherSubjectBuilder> {
  String? get id;

  DateTime? get createdAt;

  DateTime? get updatedAt;

  String? get teacherId;

  String? get stageSubjectId;

  String? get schoolYearId;

  @BuiltValueField(wireName: 'Teacher')
  TeacherModel? get teacher;

  @BuiltValueField(wireName: 'StageSubject')
  StageSubject? get stageSubject;

  @BuiltValueField(wireName: 'Section')
  Section? get section;

  // Constructor
  TeacherSubject._();
  factory TeacherSubject([void Function(TeacherSubjectBuilder) updates]) =
      _$TeacherSubject;

  // Serializer
  static Serializer<TeacherSubject> get serializer =>
      _$teacherSubjectSerializer;

  // fromJson function
  factory TeacherSubject.fromJson(String data) {
    return serializers.deserializeWith(
      TeacherSubject.serializer,
      json.decode(data),
    )!;
  }
}

// StageSubject model
abstract class StageSubject
    implements Built<StageSubject, StageSubjectBuilder> {
  @BuiltValueField(wireName: 'Subject')
  Subject? get subject;

  @BuiltValueField(wireName: 'Stage')
  Stage? get stage;

  // Constructor
  StageSubject._();
  factory StageSubject([void Function(StageSubjectBuilder) updates]) =
      _$StageSubject;

  // Serializer
  static Serializer<StageSubject> get serializer => _$stageSubjectSerializer;
}

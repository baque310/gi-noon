import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/schedule_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/teacher_subject_model.dart';

part 'teacher_section_schedule.g.dart';

abstract class TeacherSectionSchedule
    implements Built<TeacherSectionSchedule, TeacherSectionScheduleBuilder> {
  // Fields
  String get id;
  String? get teacherSubjectId;
  String? get sectionId;
  String? get schoolId;
  String? get schoolYearId;
  String? get scheduleId;

  @BuiltValueField(wireName: 'Schedule')
  ScheduleModel? get schedule;

  @BuiltValueField(wireName: 'teacherSubject')
  TeacherSubject? get teacherSubject;

  TeacherSectionSchedule._();
  factory TeacherSectionSchedule([
    void Function(TeacherSectionScheduleBuilder) updates,
  ]) = _$TeacherSectionSchedule;

  static Serializer<TeacherSectionSchedule> get serializer =>
      _$teacherSectionScheduleSerializer;

  // fromJson method
  factory TeacherSectionSchedule.fromJson(String data) {
    return serializers.deserializeWith(
      TeacherSectionSchedule.serializer,
      json.decode(data),
    )!;
  }
}

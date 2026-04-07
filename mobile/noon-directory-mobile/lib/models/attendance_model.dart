import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/schedule_model.dart';
import 'package:noon/models/school_year_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/student_enrollment_model.dart';

part 'attendance_model.g.dart';

abstract class AttendanceModel
    implements Built<AttendanceModel, AttendanceModelBuilder> {
  String get id;
  DateTime get date;

  @BuiltValueField(wireName: 'Status')
  String get status;

  @BuiltValueField(wireName: 'SectionSchedule')
  SectionScheduleModel get sectionSchedule;

  @BuiltValueField(wireName: 'StudentEnrollment')
  StudentEnrollmentModel get studentEnrollment;

  @BuiltValueField(wireName: 'SchoolYear')
  SchoolYear get schoolYear;

  AttendanceModel._();
  factory AttendanceModel([void Function(AttendanceModelBuilder) updates]) =
      _$AttendanceModel;

  static Serializer<AttendanceModel> get serializer =>
      _$attendanceModelSerializer;

  // Function to deserialize from JSON
  factory AttendanceModel.fromJson(String data) {
    return serializers.deserializeWith(
      AttendanceModel.serializer,
      json.decode(data),
    )!;
  }
}

abstract class SectionScheduleModel
    implements Built<SectionScheduleModel, SectionScheduleModelBuilder> {
  String? get id;

  Section get section;

  @BuiltValueField(wireName: 'Schedule')
  ScheduleModel get schedule;

  @BuiltValueField(wireName: 'teacherSubject')
  TeacherSubject get teacherSubject;

  SectionScheduleModel._();

  factory SectionScheduleModel([
    void Function(SectionScheduleModelBuilder) updates,
  ]) = _$SectionScheduleModel;

  static Serializer<SectionScheduleModel> get serializer =>
      _$sectionScheduleModelSerializer;
}

abstract class EnrollmentSectionModel
    implements Built<EnrollmentSectionModel, EnrollmentSectionModelBuilder> {
  String get name;

  @BuiltValueField(wireName: 'Class')
  ClassInfo get classInfo;

  EnrollmentSectionModel._();

  factory EnrollmentSectionModel([
    void Function(EnrollmentSectionModelBuilder) updates,
  ]) = _$EnrollmentSectionModel;

  static Serializer<EnrollmentSectionModel> get serializer =>
      _$enrollmentSectionModelSerializer;
}

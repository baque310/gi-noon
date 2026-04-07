import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/attendance_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/student_model.dart';

import '../core/enum.dart';

part 'student_enrollment_model.g.dart';

abstract class StudentEnrollmentModel
    implements Built<StudentEnrollmentModel, StudentEnrollmentModelBuilder> {
  String get id;

  @BuiltValueField(wireName: 'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'updatedAt')
  DateTime? get updatedAt;

  String? get studentId;
  StudentStutus? get status;
  String? get schoolId;
  String? get stageId;
  String? get classId;
  String? get sectionId;
  String? get schoolYearId;

  @BuiltValueField(wireName: 'Student')
  StudentModel get student;
  @BuiltValueField(wireName: 'Section')
  EnrollmentSectionModel? get section;

  StudentEnrollmentModel._();

  factory StudentEnrollmentModel([
    void Function(StudentEnrollmentModelBuilder) updates,
  ]) = _$StudentEnrollmentModel;

  static Serializer<StudentEnrollmentModel> get serializer =>
      _$studentEnrollmentModelSerializer;

  // Function to deserialize from JSON
  factory StudentEnrollmentModel.fromJson(String data) {
    return serializers.deserializeWith(
      StudentEnrollmentModel.serializer,
      json.decode(data),
    )!;
  }
}

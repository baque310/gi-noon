import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/enrollment_model.dart';
import 'package:noon/models/school_model.dart';
import 'package:noon/models/serializers.dart';

part 'student_model.g.dart';

abstract class StudentModel
    implements Built<StudentModel, StudentModelBuilder> {
  // Fields
  String get id;
  String get fullName;

  DateTime? get birth;

  DateTime? get enrollmentDate;

  String? get address;

  String? get email;

  String? get phone1;

  String? get phone2;

  String? get photo;

  @BuiltValueField(wireName: 'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'updatedAt')
  DateTime? get updatedAt;

  String? get userId;
  String? get schoolId;

  String? get schoolBusId;

  @BuiltValueField(wireName: 'School')
  SchoolModel? get school;

  @BuiltValueField(wireName: 'StudentEnrollment')
  BuiltList<EnrollmentModel>? get studentEnrollment;

  // Constructor
  StudentModel._();
  factory StudentModel([void Function(StudentModelBuilder) updates]) =
      _$StudentModel;

  // Serializer for JSON support
  static Serializer<StudentModel> get serializer => _$studentModelSerializer;

  // fromJson function
  factory StudentModel.fromJson(String data) {
    return serializers.deserializeWith(
      StudentModel.serializer,
      json.decode(data),
    )!;
  }
}

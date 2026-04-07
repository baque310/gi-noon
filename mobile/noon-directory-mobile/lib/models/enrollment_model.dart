import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/school_year_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/stage_model.dart';

part 'enrollment_model.g.dart';

abstract class EnrollmentModel
    implements Built<EnrollmentModel, EnrollmentModelBuilder> {
  // Fields
  String? get id;

  DateTime? get createdAt;

  DateTime? get updatedAt;

  String? get studentId;

  String? get schoolId;

  String? get stageId;

  String? get schoolYearId;

  @BuiltValueField(wireName: 'SchoolYear')
  SchoolYear? get schoolYear;
  @BuiltValueField(wireName: 'Stage')
  Stage? get stage;
  @BuiltValueField(wireName: 'Class')
  ClassInfo? get classInfo;
  @BuiltValueField(wireName: 'Section')
  Section? get section;

  // Constructor
  EnrollmentModel._();
  factory EnrollmentModel([void Function(EnrollmentModelBuilder) updates]) =
      _$EnrollmentModel;

  // Serializer for JSON support
  static Serializer<EnrollmentModel> get serializer =>
      _$enrollmentModelSerializer;

  // Function to deserialize from a map
  factory EnrollmentModel.fromMap(Map<String, dynamic> data) {
    return serializers.deserializeWith(EnrollmentModel.serializer, data)!;
  }

  // fromJson function
  factory EnrollmentModel.fromJson(String data) {
    return serializers.deserializeWith(
      EnrollmentModel.serializer,
      json.decode(data),
    )!;
  }
}

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/exam_section_model.dart';
import 'package:noon/models/serializers.dart';
import 'dart:convert';

import 'package:noon/models/student_model.dart';

part 'degrees_model.g.dart';

abstract class DegreesModel
    implements Built<DegreesModel, DegreesModelBuilder> {
  String get id;
  int get score;
  String get notes;
  DateTime? get createdAt;
  DateTime? get updatedAt;
  String? get studentId;
  String? get examSectionId;
  @BuiltValueField(wireName: 'Student')
  StudentModel? get student;
  @BuiltValueField(wireName: 'ExamSection')
  ExamSectionModel? get examSection;

  DegreesModel._();
  factory DegreesModel([void Function(DegreesModelBuilder) updates]) =
      _$DegreesModel;

  static Serializer<DegreesModel> get serializer => _$degreesModelSerializer;

  factory DegreesModel.fromJson(String data) {
    return serializers.deserializeWith(
      DegreesModel.serializer,
      json.decode(data),
    )!;
  }
}

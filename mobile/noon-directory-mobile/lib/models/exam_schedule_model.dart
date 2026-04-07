import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/ex_model.dart';
import 'package:noon/models/serializers.dart';

part 'exam_schedule_model.g.dart';

abstract class ExamScheduleModel
    implements Built<ExamScheduleModel, ExamScheduleModelBuilder> {
  // Fields
  BuiltMap<String, BuiltList<ExModel>> get sections;

  // Constructor
  ExamScheduleModel._();
  factory ExamScheduleModel([void Function(ExamScheduleModelBuilder) updates]) =
      _$ExamScheduleModel;

  // Serializer
  static Serializer<ExamScheduleModel> get serializer =>
      _$examScheduleModelSerializer;

  // Function to deserialize from JSON
  factory ExamScheduleModel.fromJson(String data) {
    return serializers.deserializeWith(
      ExamScheduleModel.serializer,
      json.decode(data),
    )!;
  }
}

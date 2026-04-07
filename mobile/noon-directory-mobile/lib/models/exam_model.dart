import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/exam_data_model.dart';
import 'package:noon/models/serializers.dart';

part 'exam_model.g.dart';

abstract class ExamModel implements Built<ExamModel, ExamModelBuilder> {
  BuiltMap<String, BuiltList<ExamDataModel>> get sections;

  ExamModel._();
  factory ExamModel([void Function(ExamModelBuilder) updates]) = _$ExamModel;

  static Serializer<ExamModel> get serializer => _$examModelSerializer;

  // Function to deserialize from JSON
  factory ExamModel.fromJson(String data) {
    return serializers.deserializeWith(
      ExamModel.serializer,
      json.decode(data),
    )!;
  }
}

import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/schedule_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/teacher_subject_model.dart';
part 'ex_model.g.dart';

abstract class ExModel implements Built<ExModel, ExModelBuilder> {
  String get id;

  @BuiltValueField(wireName: 'Schedule')
  ScheduleModel get schedule;

  TeacherSubject get teacherSubject;

  // Constructor
  ExModel._();
  factory ExModel([void Function(ExModelBuilder) updates]) = _$ExModel;

  // Serializer
  static Serializer<ExModel> get serializer => _$exModelSerializer;

  // fromJson method
  factory ExModel.fromJson(String data) {
    return serializers.deserializeWith(ExModel.serializer, json.decode(data))!;
  }
}

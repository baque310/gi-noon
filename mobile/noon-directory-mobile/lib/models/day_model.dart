import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/schedule_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/models/serializers.dart';

part 'day_model.g.dart';

// Main Day Model
abstract class DayModel implements Built<DayModel, DayModelBuilder> {
  String? get id;
  @BuiltValueField(wireName: 'Schedule')
  ScheduleModel? get schedule;

  TeacherSubject? get teacherSubject;

  Section? get section;

  // Constructor
  DayModel._();
  factory DayModel([void Function(DayModelBuilder) updates]) = _$DayModel;

  // Serializer
  static Serializer<DayModel> get serializer => _$dayModelSerializer;

  factory DayModel.fromJson(String data) {
    return serializers.deserializeWith(DayModel.serializer, json.decode(data))!;
  }
}

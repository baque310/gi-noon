import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'dart:convert';
import 'package:noon/models/exam_section_model.dart';
import 'package:noon/models/school_year_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/stage_subject_model.dart';

part 'exam_data_model.g.dart';

abstract class ExamDataModel
    implements Built<ExamDataModel, ExamDataModelBuilder> {
  String get id;
  String get content;
  double get score;

  @BuiltValueField(wireName: 'orignalScore')
  int? get originalScore;

  @BuiltValueField(wireName: 'teacherName')
  String? get teacherName;

  @BuiltValueField(wireName: 'done')
  bool? get done;

  StageSubjectModel get stageSubject;
  BuiltList<ExamSectionModel> get examSections;
  SchoolYear get schoolYear;

  ExamDataModel._();
  factory ExamDataModel([void Function(ExamDataModelBuilder) updates]) =
      _$ExamDataModel;

  static Serializer<ExamDataModel> get serializer => _$examDataModelSerializer;

  // Function to deserialize from JSON
  factory ExamDataModel.fromJson(String data) {
    return serializers.deserializeWith(
      ExamDataModel.serializer,
      json.decode(data),
    )!;
  }
}

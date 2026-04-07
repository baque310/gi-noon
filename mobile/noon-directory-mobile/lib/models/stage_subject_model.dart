import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/subject_model.dart';
import 'package:noon/models/teacher_subject_model.dart';

part 'stage_subject_model.g.dart';

abstract class StageSubjectModel
    implements Built<StageSubjectModel, StageSubjectModelBuilder> {
  String? get id;
  String? get name;

  @BuiltValueField(wireName: 'Stage')
  Stage? get stage;
  @BuiltValueField(wireName: 'Class')
  ClassInfo? get classDetail;
  @BuiltValueField(wireName: 'Subject')
  Subject? get subject;
  @BuiltValueField(wireName: 'TeacherSubject')
  BuiltList<TeacherSubject>? get teachers;

  StageSubjectModel._();
  factory StageSubjectModel([void Function(StageSubjectModelBuilder) updates]) =
      _$StageSubjectModel;

  static Serializer<StageSubjectModel> get serializer =>
      _$stageSubjectModelSerializer;
}

// Using TeacherSubject from teacher_subject_model.dart to match API shape

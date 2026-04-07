import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/homework_model.dart';
import 'package:noon/models/serializers.dart';

part 'homework_subject_model.g.dart';

// Subject model
abstract class HomeworkSubjectModel
    implements Built<HomeworkSubjectModel, HomeworkSubjectModelBuilder> {
  String? get subjectId;
  String? get subjectName;
  int? get homeworkCount;
  BuiltList<HomeworkModel>? get homeworks;

  // Constructor
  HomeworkSubjectModel._();
  factory HomeworkSubjectModel([
    void Function(HomeworkSubjectModelBuilder) updates,
  ]) = _$HomeworkSubjectModel;

  // Serializer
  static Serializer<HomeworkSubjectModel> get serializer =>
      _$homeworkSubjectModelSerializer;

  // fromJson method
  factory HomeworkSubjectModel.fromJson(String data) {
    return serializers.deserializeWith(
      HomeworkSubjectModel.serializer,
      json.decode(data),
    )!;
  }
}

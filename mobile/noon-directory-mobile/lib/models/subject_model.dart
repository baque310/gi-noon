import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'subject_model.g.dart';

// Subject model
abstract class Subject implements Built<Subject, SubjectBuilder> {
  String? get id;
  String? get name;

  // Constructor
  Subject._();
  factory Subject([void Function(SubjectBuilder) updates]) = _$Subject;

  // Serializer
  static Serializer<Subject> get serializer => _$subjectSerializer;

  // fromJson method
  factory Subject.fromJson(String data) {
    return serializers.deserializeWith(Subject.serializer, json.decode(data))!;
  }
}

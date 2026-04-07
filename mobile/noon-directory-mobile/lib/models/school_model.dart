import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'school_model.g.dart';

abstract class SchoolModel implements Built<SchoolModel, SchoolModelBuilder> {
  // Fields
  String? get id;
  String? get name;

  // Constructor
  SchoolModel._();
  factory SchoolModel([void Function(SchoolModelBuilder) updates]) =
      _$SchoolModel;

  // Serializer
  static Serializer<SchoolModel> get serializer => _$schoolModelSerializer;
  // fromJson method
  factory SchoolModel.fromJson(String data) {
    return serializers.deserializeWith(
      SchoolModel.serializer,
      json.decode(data),
    )!;
  }
}

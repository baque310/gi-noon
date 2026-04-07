import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'stage_model.g.dart';

abstract class Stage implements Built<Stage, StageBuilder> {
  String? get id;

  String? get name;
  String? get createdAt;
  String? get updatedAt;
  String? get schoolId;

  Stage._();
  factory Stage([void Function(StageBuilder) updates]) = _$Stage;

  static Serializer<Stage> get serializer => _$stageSerializer;

  // fromJson method
  factory Stage.fromJson(String data) {
    return serializers.deserializeWith(Stage.serializer, json.decode(data))!;
  }
}

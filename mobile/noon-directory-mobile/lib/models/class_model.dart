import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/stage_model.dart';

part 'class_model.g.dart';

abstract class ClassInfo implements Built<ClassInfo, ClassInfoBuilder> {
  String? get id;
  String? get name;
  @BuiltValueField(wireName: 'Stage')
  Stage? get stage;

  ClassInfo._();
  factory ClassInfo([void Function(ClassInfoBuilder) updates]) = _$ClassInfo;

  static Serializer<ClassInfo> get serializer => _$classInfoSerializer;

  // fromJson method
  factory ClassInfo.fromJson(String data) {
    return serializers.deserializeWith(
      ClassInfo.serializer,
      json.decode(data),
    )!;
  }
}

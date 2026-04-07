import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/serializers.dart';
part 'section_model.g.dart';

abstract class Section implements Built<Section, SectionBuilder> {
  String? get id;
  String? get name;

  @BuiltValueField(wireName: 'Class')
  ClassInfo? get classInfo;

  Section._();
  factory Section([void Function(SectionBuilder) updates]) = _$Section;

  static Serializer<Section> get serializer => _$sectionSerializer;
  // fromJson method
  factory Section.fromJson(String data) {
    return serializers.deserializeWith(Section.serializer, json.decode(data))!;
  }
}

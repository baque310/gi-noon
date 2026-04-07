import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/school_model.dart';
import 'package:noon/models/serializers.dart';

part 'banner_model.g.dart';

abstract class BannerModel implements Built<BannerModel, BannerModelBuilder> {
  // Fields
  String get id;
  String? get title;
  String? get description;
  String? get url;

  @BuiltValueField(wireName: 'Status')
  String? get status;

  @BuiltValueField(wireName: 'createdAt')
  DateTime get createdAt;

  @BuiltValueField(wireName: 'updatedAt')
  DateTime get updatedAt;

  @BuiltValueField(wireName: 'schoolId')
  String? get schoolId;

  @BuiltValueField(wireName: 'School')
  SchoolModel? get school;

  // Constructor
  BannerModel._();
  factory BannerModel([void Function(BannerModelBuilder) updates]) =
      _$BannerModel;

  // Serializer
  static Serializer<BannerModel> get serializer => _$bannerModelSerializer;
  // fromJson method
  factory BannerModel.fromJson(String data) {
    return serializers.deserializeWith(
      BannerModel.serializer,
      json.decode(data),
    )!;
  }
}

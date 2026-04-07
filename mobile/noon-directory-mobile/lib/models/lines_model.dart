import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/serializers.dart';

part 'lines_model.g.dart';

abstract class LinesModel implements Built<LinesModel, LinesModelBuilder> {
  // Fields
  String get id;

  String? get fullName;

  String? get carType;

  String? get carColor;

  String? get carNumber;

  String? get address;

  String? get phone1;

  String? get phone2;

  String? get photo;

  DateTime? get createdAt;

  DateTime? get updatedAt;

  String? get schoolId;

  // Constructor
  LinesModel._();
  factory LinesModel([void Function(LinesModelBuilder) updates]) = _$LinesModel;

  // Serializer
  static Serializer<LinesModel> get serializer => _$linesModelSerializer;

  // Function to deserialize from a map
  factory LinesModel.fromMap(Map<String, dynamic> data) {
    return serializers.deserializeWith(LinesModel.serializer, data)!;
  }

  // Function to deserialize from JSON
  factory LinesModel.fromJson(String data) {
    return serializers.deserializeWith(
      LinesModel.serializer,
      json.decode(data),
    )!;
  }
}

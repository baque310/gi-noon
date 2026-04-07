import 'dart:convert';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/parent_model.dart';
import 'package:noon/models/student_model.dart';
import 'package:noon/models/teacher_model.dart';
import 'package:noon/models/serializers.dart';

part 'user_model.g.dart';

abstract class UserModel implements Built<UserModel, UserModelBuilder> {
  // Fields
  String get id;
  String get username;

  @BuiltValueField(wireName: 'isDeleted')
  bool get isDeleted;

  @BuiltValueField(wireName: 'isActive')
  bool get isActive;

  @BuiltValueField(wireName: 'isDefaultPass')
  bool get isDefaultPass;

  DateTime get createdAt;
  DateTime get updatedAt;
  String get schoolId;

  @BuiltValueField(wireName: 'Student')
  StudentModel? get student;
  @BuiltValueField(wireName: 'Teacher')
  TeacherModel? get teacher;
  @BuiltValueField(wireName: 'Parent')
  ParentModel? get parent;

  // Constructor
  UserModel._();
  factory UserModel([void Function(UserModelBuilder) updates]) = _$UserModel;

  // Serializer for JSON support
  static Serializer<UserModel> get serializer => _$userModelSerializer;

  // Function to deserialize from a map
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return serializers.deserializeWith(UserModel.serializer, data)!;
  }

  // Function to serialize to a map
  Map<String, dynamic> toMap() {
    return serializers.serializeWith(UserModel.serializer, this)
        as Map<String, dynamic>;
  }

  // Function to deserialize from a JSON string
  factory UserModel.fromJson(String data) {
    return serializers.deserializeWith(
      UserModel.serializer,
      json.decode(data),
    )!;
  }

  // Function to serialize to a JSON string
  String toJson() {
    return json.encode(serializers.serializeWith(UserModel.serializer, this));
  }
}

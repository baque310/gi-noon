/*
"Parent" : {
"id" : "0d3d0d3b-8a45-4e6c-8cc9-239d6e97a41d",
"fullName" : "نورالدين صباح",
"gender" : "Male",
"birth" : "2025-08-01T00:00:00.000Z",
"address" : "بغداد",
"email" : "tes3t@test.com",
"phone1" : "07765544444",
"phone2" : null,
"photo" : null,
"createdAt" : "2025-08-01T15:19:13.774Z",
"updatedAt" : "2025-08-01T15:19:13.774Z",
"userId" : "7a19db24-e187-4cb3-a23e-8852c6106374",
"schoolId" : "8ef65ebb-eb2d-4259-93a8-8ab273b7cbdc",
"Student" : [ {
"id" : "2179c116-d12f-4b04-a73c-01c55fdc3d08",
"fullName" : "جعفر",
"photo" : null,
"phone1" : "07765656565"
}, {
"id" : "9d87f466-c616-42b3-800d-839d0b69f971",
"fullName" : "محمد علي احمد",
"photo" : null,
"phone1" : "07807419732"
}, {
"id" : "bb03450e-54f2-48d4-9ce8-08625d9d3388",
"fullName" : "رقية محمد علي",
"photo" : "2d795a83c303c95a85e06759ebd6889b.jpg",
"phone1" : "07807419732"
}, {
"id" : "d99bc41f-fa62-468d-a7af-a53c2a8a1fe2",
"fullName" : "محمد علي احمد ",
"photo" : "1b7ad2448b6b25881039fdb2d2afef1ca.jpg",
"phone1" : "07807419732"
} ],
"School" : {
"id" : "8ef65ebb-eb2d-4259-93a8-8ab273b7cbdc",
"name" : "school name"
}
}
},*/

import 'dart:convert';

import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/school_model.dart';
import 'package:noon/models/serializers.dart';
import 'package:noon/models/student_model.dart';

part 'parent_model.g.dart';

abstract class ParentModel implements Built<ParentModel, ParentModelBuilder> {
  // Fields
  String get id;

  String get fullName;

  DateTime? get birth;

  DateTime? get enrollmentDate;

  String? get address;

  String? get email;

  String? get phone1;

  String? get phone2;

  String? get photo;

  @BuiltValueField(wireName: 'createdAt')
  DateTime? get createdAt;

  String? get userId;

  String? get schoolId;

  @BuiltValueField(wireName: 'School')
  SchoolModel? get school;

  @BuiltValueField(wireName: 'Student')
  BuiltList<StudentModel>? get students;

  // Constructor
  ParentModel._();

  factory ParentModel([void Function(ParentModelBuilder) updates]) =
      _$ParentModel;

  // Serializer for JSON support
  static Serializer<ParentModel> get serializer => _$parentModelSerializer;

  // fromJson function
  factory ParentModel.fromJson(String data) {
    return serializers.deserializeWith(
      ParentModel.serializer,
      json.decode(data),
    )!;
  }
}

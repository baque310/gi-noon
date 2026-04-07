import 'dart:convert';

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/school_model.dart';
import 'package:noon/models/serializers.dart';

part 'library_model.g.dart';

abstract class LibraryModel
    implements Built<LibraryModel, LibraryModelBuilder> {
  // Fields
  String get id;
  String? get title;
  String? get description;
  String? get url;
  String? get sectionId;
  String? get classId;

  @BuiltValueField(wireName: 'Status')
  String? get status;

  @BuiltValueField(wireName: 'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'updatedAt')
  DateTime? get updatedAt;

  String? get schoolId;
  String? get authorId;

  @BuiltValueField(wireName: 'School')
  SchoolModel? get school;

  // Constructor
  LibraryModel._();
  factory LibraryModel([void Function(LibraryModelBuilder) updates]) =
      _$LibraryModel;

  // Serializer for JSON support
  static Serializer<LibraryModel> get serializer => _$libraryModelSerializer;

  // Function to deserialize from JSON
  factory LibraryModel.fromJson(String data) {
    return serializers.deserializeWith(
      LibraryModel.serializer,
      json.decode(data),
    )!;
  }
}

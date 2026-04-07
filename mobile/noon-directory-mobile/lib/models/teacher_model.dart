import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:noon/models/school_model.dart';
import 'package:noon/models/school_year_model.dart';
import 'package:noon/models/stage_subject_model.dart';

part 'teacher_model.g.dart';

abstract class TeacherModel
    implements Built<TeacherModel, TeacherModelBuilder> {
  // Fields
  String? get id;
  String get fullName;
  DateTime? get birth;
  DateTime? get hiringDate;
  String? get address;
  String? get email;
  String? get phone1;
  String? get phone2;
  String? get photo;
  String? get userId;
  String? get schoolId;

  @BuiltValueField(wireName: 'Gender')
  String? get gender;
  @BuiltValueField(wireName: 'School')
  SchoolModel? get school;

  @BuiltValueField(wireName: 'createdAt')
  DateTime? get createdAt;

  @BuiltValueField(wireName: 'updatedAt')
  DateTime? get updatedAt;

  @BuiltValueField(wireName: 'TeacherSubject')
  BuiltList<TeacherSubjectModel>? get teacherSubjects;

  // Constructor
  TeacherModel._();
  factory TeacherModel([void Function(TeacherModelBuilder) updates]) =
      _$TeacherModel;

  // Serializer for JSON support
  static Serializer<TeacherModel> get serializer => _$teacherModelSerializer;
}

// TeacherSubject Model
abstract class TeacherSubjectModel
    implements Built<TeacherSubjectModel, TeacherSubjectModelBuilder> {
  String get id;

  @BuiltValueField(wireName: 'SchoolYear')
  SchoolYear get schoolYear;

  @BuiltValueField(wireName: 'StageSubject')
  StageSubjectModel get stageSubject;

  // Constructor
  TeacherSubjectModel._();
  factory TeacherSubjectModel([
    void Function(TeacherSubjectModelBuilder) updates,
  ]) = _$TeacherSubjectModel;

  // Serializer
  static Serializer<TeacherSubjectModel> get serializer =>
      _$teacherSubjectModelSerializer;
}

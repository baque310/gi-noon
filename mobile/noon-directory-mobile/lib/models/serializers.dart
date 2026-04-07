import 'package:built_collection/built_collection.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:built_value/iso_8601_duration_serializer.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:noon/models/attendance_model.dart';
import 'package:noon/models/banner_model.dart';
import 'package:noon/models/class_model.dart';
import 'package:noon/models/day_model.dart';
import 'package:noon/models/degrees_model.dart';
import 'package:noon/models/enrollment_model.dart';
import 'package:noon/models/ex_model.dart';
import 'package:noon/models/exam_data_model.dart';
import 'package:noon/models/exam_model.dart';
import 'package:noon/models/exam_schedule_model.dart';
import 'package:noon/models/exam_section_model.dart';
import 'package:noon/models/exams/exam_teacher_model.dart';
import 'package:noon/models/homework_model.dart';
import 'package:noon/models/lesson_attachment_model.dart';
import 'package:noon/models/lesson_model.dart';
import 'package:noon/models/lesson_subject_model.dart';
import 'package:noon/models/library_model.dart';
import 'package:noon/models/lines_model.dart';
import 'package:noon/models/notification_data_model.dart';
import 'package:noon/models/notification_model.dart';
import 'package:noon/models/parent_model.dart';
import 'package:noon/models/reusable_model.dart';
import 'package:noon/models/schedule_model.dart';
import 'package:noon/models/school_model.dart';
import 'package:noon/models/school_year_model.dart';
import 'package:noon/models/section_model.dart';
import 'package:noon/models/stage_model.dart';
import 'package:noon/models/stage_subject_model.dart';
import 'package:noon/models/student_enrollment_model.dart';
import 'package:noon/models/student_model.dart';
import 'package:noon/models/subject_model.dart';
import 'package:noon/models/teacher_model.dart';
import 'package:noon/models/teacher_section_schedule.dart';
import 'package:noon/models/teacher_subject_model.dart';
import 'package:noon/models/teaching_staff_model.dart';
import 'package:noon/models/user_model.dart';

import 'attachment_model.dart';
import 'attachment_type_model.dart';
import 'user_attachment_model.dart';
import 'chat_room_data.dart';
import 'chat_room_member.dart';
import 'chat_room_last_message.dart';
import 'complaint_model.dart';
import 'homework_subject_model.dart';
import 'message_model.dart';
import 'installment_model.dart';
import 'other_installment_model.dart';
import 'student_homework_model.dart';

part 'serializers.g.dart';

class StringToBoolSerializer implements PrimitiveSerializer<bool> {
  @override
  final Iterable<Type> types = const [bool];
  @override
  final String wireName = 'bool';

  @override
  Object serialize(
    Serializers serializers,
    bool object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return object.toString();
  }

  @override
  bool deserialize(
    Serializers serializers,
    Object? serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    if (serialized is bool) return serialized;
    if (serialized is String) {
      final s = serialized.trim().toLowerCase();
      return s == 'true' || s == '1';
    }
    if (serialized is num) {
      return serialized != 0;
    }
    return false;
  }
}

@SerializersFor([
  UserModel,
  StudentModel,
  TeacherModel,
  TeacherSubjectModel,
  Stage,
  ClassInfo,
  Section,
  EnrollmentModel,
  BannerModel,
  SchoolModel,
  ReusableModel,
  TeachingStaffModel,
  TeacherSubject,
  LinesModel,
  DayModel,
  Subject,
  ScheduleModel,
  LibraryModel,
  ExamModel,
  StageSubjectModel,
  ExamSectionModel,
  SchoolYear,
  HomeworkModel,
  LessonAttachmentModel,
  LessonModel,
  DegreesModel,
  ExamScheduleModel,
  ExModel,
  TeacherSectionSchedule,
  AttendanceModel,
  NotificationModel,
  StudentEnrollmentModel,
  StringToBoolSerializer,
  ComplaintModel,
  AttachmentModel,
  AttachmentTypeModel,
  UserAttachmentModel,
  ParentModel,
  ChatRoomData,
  ChatRoomMember,
  ChatRoomLastMessage,
  MessageModel,
  InstallmentModel,
  InstallmentPaymentModel,
  OtherInstallmentModel,
  PaymentModel,
  ExamDataModel,
  HomeworkSubjectModel,
  LessonSubjectModel,
  ExamTeacherModel,
  StudentHomeworkModel,
])
final Serializers serializers =
    (_$serializers.toBuilder()
          ..add(Iso8601DateTimeSerializer())
          ..add(Iso8601DurationSerializer())
          ..add(StringToBoolSerializer())
          ..addPlugin(StandardJsonPlugin())
          //for this modele ExamScheduleModel
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ExModel)]),
            () => ListBuilder<ExModel>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltMap, [
              FullType(String),
              FullType(BuiltList, [FullType(ExModel)]),
            ]),
            () => MapBuilder<String, BuiltList<ExModel>>(),
          )
          //for this model ExamModel
          ..addBuilderFactory(
            const FullType(BuiltMap, [
              FullType(String),
              FullType(BuiltList, [FullType(ExamDataModel)]),
            ]),
            () => MapBuilder<String, BuiltList<ExamDataModel>>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ExamDataModel)]),
            () => ListBuilder<ExamDataModel>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(TeacherSubject)]),
            () => ListBuilder<TeacherSubject>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(TeacherSubjectModel)]),
            () => ListBuilder<TeacherSubjectModel>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ExamSectionModel)]),
            () => ListBuilder<ExamSectionModel>(),
          )
          ..addBuilderFactory(
            const FullType(BuiltList, [FullType(ExamTeacherModel)]),
            () => ListBuilder<ExamTeacherModel>(),
          ))
        .build();

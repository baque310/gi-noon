import 'package:s_extensions/s_extensions.dart';

class CompletedLessonModel {
  String? id;
  String? lessonTitle;
  String? subject;
  String? classs;
  String? section;
  String? teacher;
  DateTime? createdAt;
  int? attachmentsCount;

  CompletedLessonModel({
    this.id,
    this.lessonTitle,
    this.subject,
    this.classs,
    this.section,
    this.teacher,
    this.createdAt,
    this.attachmentsCount,
  });

  factory CompletedLessonModel.fromJson(Map<String, dynamic> json) =>
      CompletedLessonModel(
        id: json['id'] as String?,
        lessonTitle: json['lessonTitle'] as String?,
        subject: json['subject'] as String?,
        classs: json['classs'] as String?,
        section: json['section'] as String?,
        teacher: json['teacher'] as String?,
        createdAt: (json['createdAt'] as String?)?.toDate,
        attachmentsCount: json['attachmentsCount'] as int?,
      );
}

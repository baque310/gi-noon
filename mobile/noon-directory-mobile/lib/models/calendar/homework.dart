import 'package:s_extensions/s_extensions.dart';

class HomeworkModel {
  String? id;
  String? title;
  DateTime? dueDate;
  String? subject;
  String? classs;
  String? section;
  String? teacher;
  int? attachmentsCount;
  String? status;

  HomeworkModel({
    this.id,
    this.title,
    this.dueDate,
    this.subject,
    this.classs,
    this.section,
    this.teacher,
    this.attachmentsCount,
    this.status,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) => HomeworkModel(
    id: json['id'] as String?,
    title: json['title'] as String?,
    dueDate: (json['dueDate'] as String?)?.toDate,
    subject: json['subject'] as String?,
    classs: json['classs'] as String?,
    section: json['section'] as String?,
    teacher: json['teacher'] as String?,
    attachmentsCount: json['attachmentsCount'] as int?,
    status: json['status'] as String?,
  );
}

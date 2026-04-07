import 'package:s_extensions/s_extensions.dart';

class ExamModel {
  String? id;
  String? examType;
  String? subject;
  String? classs;
  String? section;
  DateTime? date;
  int? totalScore;

  ExamModel({
    this.id,
    this.examType,
    this.subject,
    this.classs,
    this.section,
    this.date,
    this.totalScore,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) => ExamModel(
    id: json['examSectionId'] as String?,
    examType: json['examType'] as String?,
    subject: json['subject'] as String?,
    classs: json['class'] as String?,
    section: json['section'] as String?,
    date: (json['examDate'] as String?)?.toDate,
    totalScore: json['totalScore'] as int?,
  );
}

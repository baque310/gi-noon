import 'package:s_extensions/s_extensions.dart';

class ScheduleModel {
  String? id;
  DateTime? timeFrom;
  DateTime? timeTo;
  String? section;
  String? classs;
  String? stage;
  String? subject;
  String? teacher;

  ScheduleModel({
    this.id,
    this.timeFrom,
    this.timeTo,
    this.section,
    this.classs,
    this.stage,
    this.subject,
    this.teacher,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) => ScheduleModel(
    id: json['scheduleId'] as String?,
    timeFrom: (json['timeFrom'] as String?)?.toDate,
    timeTo: (json['timeTo'] as String?)?.toDate,
    section: json['section'] as String?,
    classs: json['class'] as String?,
    stage: json['stage'] as String?,
    subject: json['subject'] as String?,
    teacher: json['teacher'] as String?,
  );
}

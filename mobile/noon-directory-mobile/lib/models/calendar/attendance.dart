import 'package:s_extensions/s_extensions.dart';

class AttendanceModel {
  String? id;
  DateTime? date;
  String? status;
  DateTime? timeFrom;
  DateTime? timeTo;
  String? subject;
  String? classs;
  String? section;
  String? stage;
  String? teacher;

  AttendanceModel({
    this.id,
    this.date,
    this.status,
    this.timeFrom,
    this.timeTo,
    this.subject,
    this.classs,
    this.section,
    this.stage,
    this.teacher,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) =>
      AttendanceModel(
        id: json['attendanceId'] as String?,
        date: (json['date'] as String?)?.toDate,
        status: json['status'] as String?,
        timeFrom: (json['timeFrom'] as String?)?.toDate,
        timeTo: (json['timeTo'] as String?)?.toDate,
        subject: json['subject'] as String?,
        classs: json['class'] as String?,
        section: json['section'] as String?,
        stage: json['stage'] as String?,
        teacher: json['teacher'] as String?,
      );
}

import 'package:noon/models/behaviors/evaluation_item.dart';

class BehaviorModel {
  final String id;
  final String subjectName;
  final String teacherName;
  final String studentName;
  final DateTime fromDate;
  final DateTime toDate;
  final String className;
  final String sectionName;
  final List<EvaluationItemModel> evaluationItems;
  final String teacherSubjectId;
  final String studentEnrollmentId;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  BehaviorModel({
    required this.id,
    required this.subjectName,
    required this.teacherName,
    required this.studentName,
    required this.fromDate,
    required this.toDate,
    required this.className,
    required this.sectionName,
    required this.evaluationItems,
    required this.teacherSubjectId,
    required this.studentEnrollmentId,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BehaviorModel.fromJson(Map<String, dynamic> json) {
    return BehaviorModel(
      id: json['id'] ?? '',
      subjectName: json['subjectName'] ?? '',
      teacherName: json['teacherName'] ?? '',
      studentName: json['studentName'] ?? '',
      fromDate: DateTime.tryParse(json['fromDate'] ?? '') ?? DateTime.now(),
      toDate: DateTime.tryParse(json['toDate'] ?? '') ?? DateTime.now(),
      className: json['className'] ?? '',
      sectionName: json['sectionName'] ?? '',
      evaluationItems: json['evaluationItems'] != null
          ? List<EvaluationItemModel>.from(
              json['evaluationItems'].map(
                (x) => EvaluationItemModel.fromJson(x),
              ),
            )
          : [],
      teacherSubjectId: json['teacherSubjectId'] ?? '',
      studentEnrollmentId: json['studentEnrollmentId'] ?? '',
      notes: json['notes'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

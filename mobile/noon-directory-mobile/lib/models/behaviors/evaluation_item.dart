import 'package:noon/models/behaviors/behavior_section.dart';
import 'package:noon/models/behaviors/behavior_type.dart';

class EvaluationItemModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String behaviorWeeklyEvaluationId;
  final String behaviorSectionId;
  final String behaviorTypeId;
  final BehaviorSectionModel? behaviorSection;
  final BehaviorTypeModel? behaviorType;

  EvaluationItemModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.behaviorWeeklyEvaluationId,
    required this.behaviorSectionId,
    required this.behaviorTypeId,
    this.behaviorSection,
    this.behaviorType,
  });

  factory EvaluationItemModel.fromJson(Map<String, dynamic> json) {
    return EvaluationItemModel(
      id: json['id'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      behaviorWeeklyEvaluationId: json['behaviorWeeklyEvaluationId'] ?? '',
      behaviorSectionId: json['behaviorSectionId'] ?? '',
      behaviorTypeId: json['behaviorTypeId'] ?? '',
      behaviorSection: json['BehaviorSection'] != null
          ? BehaviorSectionModel.fromJson(json['BehaviorSection'])
          : null,
      behaviorType: json['BehaviorType'] != null
          ? BehaviorTypeModel.fromJson(json['BehaviorType'])
          : null,
    );
  }
}

class BehaviorTypeModel {
  final String id;
  final String name;
  final int order;
  final String schoolId;
  final DateTime createdAt;
  final DateTime updatedAt;

  BehaviorTypeModel({
    required this.id,
    required this.name,
    required this.order,
    required this.schoolId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BehaviorTypeModel.fromJson(Map<String, dynamic> json) {
    return BehaviorTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      order: json['order'] ?? 0,
      schoolId: json['schoolId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

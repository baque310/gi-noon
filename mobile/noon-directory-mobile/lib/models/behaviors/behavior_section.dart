class BehaviorSectionModel {
  final String id;
  final String name;
  final String status;
  final String schoolId;
  final DateTime createdAt;
  final DateTime updatedAt;

  BehaviorSectionModel({
    required this.id,
    required this.name,
    required this.status,
    required this.schoolId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BehaviorSectionModel.fromJson(Map<String, dynamic> json) {
    return BehaviorSectionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? '',
      schoolId: json['schoolId'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

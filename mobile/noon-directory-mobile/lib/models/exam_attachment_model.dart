class ExamAttachmentModel {
  final String id;
  final String url;

  const ExamAttachmentModel({required this.id, required this.url});

  factory ExamAttachmentModel.fromJson(Map<String, dynamic> json) {
    return ExamAttachmentModel(
      id: json['id'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }
}

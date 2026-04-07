import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/print_value.dart';
import '../core/constant/api_urls.dart';
import '../core/failures.dart';
import '../core/localization/language.dart';
import '../data/api_services.dart';
import '../models/exam_attachment_model.dart';
import '../models/exam_data_model.dart';
import '../models/exam_model.dart';
import '../view/widget/alert_dialogs.dart';

class ExamScheduleController extends GetxController {
  RxBool loading = false.obs;
  final ApiService _apiService = ApiService();
  Rxn<String> studentExamValue = Rxn<String>(null);
  Rx<ExamModel> studentExamResults = ExamModel().obs;
  RxList<ExamDataModel> studentExamsData = <ExamDataModel>[].obs;
  RxList<String> studentExams = <String>[].obs;
  Rxn<String> studentId = Rxn<String>(null);
  Rxn<int> index = Rxn<int>(null);

  // Map from examId -> list of attachments (stored separately since built_value model is hard to extend)
  final Map<String, List<ExamAttachmentModel>> examAttachments = {};

  final controller = Get.find<GlobalController>();

  Future getStudentDegrees() async {
    dprint("Get student exam results ........");
    loading(true);
    try {
      final res = await _apiService.get(
        url: controller.isStudent
            ? ApiUrls.studentExamUrl
            : '${ApiUrls.studentExamsForParentUrl}/${controller.selectedStudentIdForParent.value!}',
      );
      final Map<String, dynamic> rawData = res.data['data'];

      if (rawData.isNotEmpty) {
        // Parse attachments from raw data before passing to built_value
        examAttachments.clear();
        rawData.forEach((examTypeName, exams) {
          if (exams is List) {
            for (final exam in exams) {
              if (exam is Map<String, dynamic>) {
                final examId = exam['id'] as String? ?? '';
                final List<ExamAttachmentModel> allAttachments = [];

                // 1) Include the exam's own 'url' field (uploaded via Dashboard)
                final examUrl = exam['url'] as String?;
                if (examUrl != null && examUrl.isNotEmpty) {
                  allAttachments.add(
                    ExamAttachmentModel(id: '${examId}_url', url: examUrl),
                  );
                }

                // 2) Include ExamAttachment records (uploaded via teacher API)
                final rawAttachments = exam['attachments'];
                if (rawAttachments is List && rawAttachments.isNotEmpty) {
                  allAttachments.addAll(
                    rawAttachments
                        .map(
                          (a) => ExamAttachmentModel.fromJson(
                            Map<String, dynamic>.from(a),
                          ),
                        )
                        .toList(),
                  );
                }

                if (allAttachments.isNotEmpty) {
                  examAttachments[examId] = allAttachments;
                }
              }
            }
          }
        });

        final Map<String, List<Map<String, dynamic>>> formattedData = rawData
            .map(
              (key, value) =>
                  MapEntry(key, List<Map<String, dynamic>>.from(value)),
            );

        final jsonString = jsonEncode({'sections': formattedData});

        studentExamResults.value = ExamModel.fromJson(jsonString);

        studentExams.addAll(studentExamResults.value.sections.keys);
        studentExamValue.value = studentExams.first;

        dprint(tag: '[Student Exams]', studentExams);
        dprint(tag: '[Student Exams] [length]', studentExams.length);

        studentExamsData.addAll(
          studentExamResults.value.sections.values.expand((list) => list),
        );
      }
    } catch (e) {
      dprint("Error in Get student exams results ...");
      dprint(e.toString());
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      loading(false);
    }
  }

  List<ExamAttachmentModel> getAttachmentsForExam(String examId) {
    return examAttachments[examId] ?? [];
  }

  @override
  void onInit() {
    super.onInit();
    getStudentDegrees();
  }
}

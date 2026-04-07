import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';

class OnlineExamController extends GetxController {
  final _api = ApiService();

  // States
  final isLoading = false.obs;
  final isSubmitting = false.obs;
  final exams = <Map<String, dynamic>>[].obs;
  final currentExam = Rxn<Map<String, dynamic>>();
  final selectedAnswers = <String, String>{}.obs; // questionId -> answer
  final uploadedFile = Rxn<File>();

  // Timer
  final remainingSeconds = 0.obs;

  /// Fetch student's online exams
  Future<void> fetchExams() async {
    isLoading.value = true;
    try {
      final res = await _api.get(url: ApiUrls.studentOnlineExamsUrl);
      if (res.data is List) {
        exams.value = List<Map<String, dynamic>>.from(res.data);
      } else if (res.data is Map && res.data['data'] is List) {
        exams.value = List<Map<String, dynamic>>.from(res.data['data']);
      }
    } catch (e) {
      dprint('Error fetching online exams: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch single exam details
  Future<void> fetchExamById(String id) async {
    isLoading.value = true;
    try {
      final res = await _api.get(url: '${ApiUrls.studentOnlineExamsUrl}/$id');
      if (res.data is Map) {
        if (res.data['data'] != null && res.data['data'] is Map) {
          currentExam.value = Map<String, dynamic>.from(res.data['data']);
        } else {
          currentExam.value = Map<String, dynamic>.from(res.data);
        }
      }
    } catch (e) {
      dprint('Error fetching exam by id: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Start exam
  Future<bool> startExam(String examId) async {
    try {
      final res = await _api.post(
        url: '${ApiUrls.studentOnlineExamsUrl}/$examId/start',
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        await fetchExamById(examId);
        return true;
      }
    } catch (e) {
      dprint('Error starting exam: $e');
    }
    return false;
  }

  /// Submit MCQ answers
  Future<bool> submitMCQAnswers(String examId) async {
    isSubmitting.value = true;
    try {
      final answers = selectedAnswers.entries.map((e) => {
        'questionId': e.key,
        'selectedOption': e.value,
      }).toList();

      final formData = FormData.fromMap({
        'answers': jsonEncode(answers),
      });

      final res = await _api.post(
        url: '${ApiUrls.studentOnlineExamsUrl}/$examId/submit',
        body: formData,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        selectedAnswers.clear();
        return true;
      }
    } catch (e) {
      dprint('Error submitting MCQ: $e');
    } finally {
      isSubmitting.value = false;
    }
    return false;
  }

  /// Submit paper answer (file upload)
  Future<bool> submitPaperAnswer(String examId, File file) async {
    isSubmitting.value = true;
    try {
      final formData = FormData.fromMap({
        'answers': '[]',
        'answerFiles': await MultipartFile.fromFile(file.path, filename: file.path.split(Platform.pathSeparator).last),
      });

      final res = await _api.post(
        url: '${ApiUrls.studentOnlineExamsUrl}/$examId/submit',
        body: formData,
      );
      if (res.statusCode == 200 || res.statusCode == 201) {
        return true;
      }
    } catch (e) {
      dprint('Error submitting paper: $e');
    } finally {
      isSubmitting.value = false;
    }
    return false;
  }

  /// Pick image for paper upload
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      uploadedFile.value = File(picked.path);
    }
  }

  /// Pick from camera
  Future<void> takePhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (picked != null) {
      uploadedFile.value = File(picked.path);
    }
  }

  /// Select answer for MCQ
  void selectAnswer(String questionId, String answer) {
    selectedAnswers[questionId] = answer;
  }

  /// Get exam status
  String getExamStatus(Map<String, dynamic> exam) {
    final now = DateTime.now();
    final start = DateTime.tryParse(exam['startDate'] ?? '') ?? now;
    final end = DateTime.tryParse(exam['endDate'] ?? '') ?? now;

    if (now.isBefore(start)) return 'upcoming';
    if (now.isAfter(end)) return 'ended';
    return 'active';
  }

  /// Get student status for an exam
  String getStudentStatus(Map<String, dynamic> exam) {
    final studentData = exam['OnlineExamStudent'];
    if (studentData is List && studentData.isNotEmpty) {
      return studentData[0]['status'] ?? 'NOT_STARTED';
    }
    return 'NOT_STARTED';
  }

  /// Get student score
  double? getStudentScore(Map<String, dynamic> exam) {
    final studentData = exam['OnlineExamStudent'];
    if (studentData is List && studentData.isNotEmpty) {
      final score = studentData[0]['totalScore'];
      if (score != null) return (score is int) ? score.toDouble() : score;
    }
    return null;
  }

  /// Reset state
  void resetExam() {
    isLoading.value = true;
    selectedAnswers.clear();
    uploadedFile.value = null;
    currentExam.value = null;
    remainingSeconds.value = 0;
  }
}

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import '../core/constant/api_urls.dart';
import '../core/failures.dart';
import '../core/localization/language.dart';
import '../data/api_services.dart';
import '../models/complaint_model.dart';
import '../view/widget/alert_dialogs.dart';
import 'image_list_controller.dart';

class ComplaintsController extends GetxController
    with StateMixin<List<ComplaintModel>> {
  final apiService = ApiService();

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  onInit() {
    getComplaints();
    super.onInit();
  }

  Future<void> getComplaints() async {
    change(null, status: RxStatus.loading());
    try {
      final res = await apiService.get(
        url: ApiUrls.complaintsUrl,
        queryParameters: {'skip': 1, 'take': 50},
      );

      if (res.data != null) {
        final complaints = List<ComplaintModel>.from(
          res.data['data'].map((e) => ComplaintModel.fromJson(e)),
          growable: false,
        );
        complaints.isNotEmpty
            ? change(complaints, status: RxStatus.success())
            : change(null, status: RxStatus.empty());
        return;
      }
      change(null, status: RxStatus.empty());
    } catch (e) {
      String error = e.toString();
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      change(null, status: RxStatus.error(error));
    }
  }

  Future<void> sendComplaint() async {
    if (formKey.currentState != null && !formKey.currentState!.validate()) {
      return;
    }

    final images = Get.find<ImageListController>().images;

    try {
      final List<MultipartFile> complaintAttachments = [];

      if (images.isNotEmpty) {
        for (File p in images) {
          final file = await MultipartFile.fromFile(p.path);
          complaintAttachments.add(file);
        }
      }

      final formData = FormData.fromMap({
        'title': titleController.text,
        'description': descriptionController.text,
        if (complaintAttachments.isNotEmpty)
          'ComplAttachment': complaintAttachments,
      });

      EasyLoading.show();
      await apiService.post(url: ApiUrls.complaintUrl, body: formData);
      Get.snackbar(
        AppLanguage.success.tr,
        AppLanguage.complaintSendSuccessfully.tr,
      );

      // Clear the text fields and image list after successful submission
      titleController.clear();
      descriptionController.clear();
      Get.find<ImageListController>().images.clear();

      // Go back to home screen
      Get.close(2);
    } catch (e) {
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }
}

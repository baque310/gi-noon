import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/failures.dart';
import 'package:noon/core/image_helper.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/models/attachment_type_model.dart';
import 'package:noon/models/user_attachment_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import 'package:noon/view/widget/bottom_sheet_container.dart';
import 'package:noon/view/widget/bottom_sheet_drag.dart';
import 'package:noon/view/widget/loading_button.dart';

class AttachmentsController extends GetxController {
  final ApiService apiService = ApiService();

  final loading = false.obs;
  final uploading = false.obs;
  final attachments = <UserAttachmentModel>[].obs;
  final attachmentTypes = <AttachmentTypeModel>[].obs;

  final frontImage = Rx<File?>(null);
  final backImage = Rx<File?>(null);
  final selectedTypeId = ''.obs;
  final isTwoSided = false.obs;

  @override
  void onInit() {
    super.onInit();
    getAttachments();
    getAttachmentTypes();
  }

  Future<void> getAttachments() async {
    try {
      loading(true);
      final res = await apiService.get(url: ApiUrls.attachmentGetUrl);

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception();
      }

      final data = res.data is List ? res.data : res.data['data'];

      attachments.value = List<UserAttachmentModel>.from(
        (data as List).map(
          (e) => UserAttachmentModel.fromJson(e is String ? jsonDecode(e) : e),
        ),
      );
    } catch (e) {
      dprint('Error in getAttachments: $e');
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
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

  Future<void> getAttachmentTypes() async {
    try {
      final res = await apiService.get(url: ApiUrls.attachmentTypesUrl);

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception();
      }

      final List rawData = res.data is List ? res.data : res.data['data'] ?? [];

      attachmentTypes.value = List<AttachmentTypeModel>.from(
        rawData.map((e) {
          // Normalize data to ensure types are correct
          final map = Map<String, dynamic>.from(
            e is String ? jsonDecode(e) : e,
          );

          // Force conversion of numberOfSides to int if it's not null
          if (map['numberOfSides'] != null) {
            if (map['numberOfSides'] is String) {
              map['numberOfSides'] = int.tryParse(map['numberOfSides']) ?? 1;
            } else if (map['numberOfSides'] is num) {
              map['numberOfSides'] = (map['numberOfSides'] as num).toInt();
            }
          }

          return AttachmentTypeModel.fromJson(map);
        }),
      );
    } catch (e) {
      dprint('Error in getAttachmentTypes: $e');
    }
  }

  void showAttachmentTypeBottomSheet() {
    Get.bottomSheet(
      BottomSheetContainer(
        child: Column(
          mainAxisSize: .min,
          children: [
            const BottomSheetDragHandle(),

            Text(
              AppLanguage.selectAttachmentTypeStr.tr,
              style: AppTextStyles.bold16,
            ),
            const SizedBox(height: 16),

            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: attachmentTypes.length,
                separatorBuilder: (_, _) =>
                    SizedBox(height: getDynamicHeight(4)),
                itemBuilder: (_, index) {
                  final type = attachmentTypes[index];
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(getDynamicWidth(12)),
                      border: Border.all(color: AppColors.mainColor),
                    ),
                    child: ListTile(
                      title: Text(
                        type.title,
                        style: AppTextStyles.medium16,
                        textAlign: TextAlign.center,
                      ),
                      onTap: () {
                        Get.back();
                        selectedTypeId.value = type.id ?? '';

                        // If two-sided, we use the expanded side logic
                        if (type.numberOfSides == 2) {
                          // Check if there's an existing attachment to update
                          final existing = attachments.firstWhereOrNull(
                            (a) =>
                                a.attType?.id == type.id ||
                                a.attTypeId == type.id,
                          );
                          showImageSourceBottomSheetForSide(
                            typeId: type.id ?? '',
                            isFront: true,
                            attachmentId: existing?.id,
                          );
                        } else {
                          isTwoSided.value = false;
                          showImageSourceBottomSheet(true);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPhotoOptionsBottomSheet() {
    Get.bottomSheet(
      BottomSheetContainer(
        child: Padding(
          padding: const .symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .center,
            children: [
              const BottomSheetDragHandle(pb: 0),
              const SizedBox(height: 16),
              Text(
                AppLanguage.selectAttachmentTypeStr.tr,
                style: AppTextStyles.bold16,
              ),
              const SizedBox(height: 20),

              LoadingButton(
                onPressed: () {
                  Get.back();
                  isTwoSided(false);
                  showImageSourceBottomSheet(true);
                },
                text: AppLanguage.oneSideFrontOnlyStr.tr,
                bgColor: AppColors.mainColor,
              ),
              const SizedBox(height: 12),

              OutlinedButton(
                onPressed: () {
                  Get.back();
                  isTwoSided(true);
                  showImageSourceBottomSheet(true);
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: .circular(14)),
                  side: const BorderSide(color: AppColors.mainColor),
                  fixedSize: Size(Get.width, 48),
                ),
                child: Text(
                  AppLanguage.twoSidesFrontBackStr.tr,
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showImageSourceBottomSheet(bool isFront) {
    Get.bottomSheet(
      BottomSheetContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BottomSheetDragHandle(pb: 0),
              const SizedBox(height: 16),
              Text(
                isFront
                    ? AppLanguage.frontViewStr.tr
                    : AppLanguage.backViewStr.tr,
                style: AppTextStyles.bold16,
              ),
              const SizedBox(height: 20),
              LoadingButton(
                onPressed: () async {
                  Get.back();
                  await pickImage(ImageSource.camera, isFront);
                },
                text: AppLanguage.cameraStr.tr,
                bgColor: AppColors.mainColor,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  Get.back();
                  await pickImage(ImageSource.gallery, isFront);
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: const BorderSide(color: AppColors.mainColor),
                  fixedSize: Size(Get.width, 48),
                ),
                child: Text(
                  AppLanguage.pickImage.tr,
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showImageSourceBottomSheetForSide({
    required String typeId,
    required bool isFront,
    String? attachmentId,
  }) {
    Get.bottomSheet(
      BottomSheetContainer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const BottomSheetDragHandle(pb: 0),
              const SizedBox(height: 16),
              Text(
                isFront
                    ? AppLanguage.frontViewStr.tr
                    : AppLanguage.backViewStr.tr,
                style: AppTextStyles.bold16,
              ),
              const SizedBox(height: 20),
              LoadingButton(
                onPressed: () async {
                  Get.back();
                  await pickImageForSide(
                    ImageSource.camera,
                    typeId: typeId,
                    isFront: isFront,
                    attachmentId: attachmentId,
                  );
                },
                text: AppLanguage.cameraStr.tr,
                bgColor: AppColors.mainColor,
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  Get.back();
                  await pickImageForSide(
                    ImageSource.gallery,
                    typeId: typeId,
                    isFront: isFront,
                    attachmentId: attachmentId,
                  );
                },
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  side: const BorderSide(color: AppColors.mainColor),
                  fixedSize: Size(Get.width, 48),
                ),
                child: Text(
                  AppLanguage.pickImage.tr,
                  style: AppTextStyles.bold14.copyWith(
                    color: AppColors.mainColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> pickImage(ImageSource source, bool isFront) async {
    try {
      final imageFile = await ImageHelper.getImage(source);
      if (imageFile != null) {
        if (isFront) {
          frontImage.value = imageFile;
          if (isTwoSided.value) {
            // Show bottom sheet for back image (Keep original logic for any sequential calls)
            showImageSourceBottomSheet(false);
          } else {
            // Upload immediately for one-sided
            await uploadAttachment();
          }
        } else {
          backImage.value = imageFile;
          // Upload for two-sided
          await uploadAttachment();
        }
      }
    } catch (e) {
      dprint('Error picking image: $e');
    }
  }

  // New method for the "two slots" UI approach
  Future<void> pickImageForSide(
    ImageSource source, {
    required String typeId,
    required bool isFront,
    String? attachmentId,
  }) async {
    try {
      final imageFile = await ImageHelper.getImage(source);
      if (imageFile != null) {
        await uploadSingleSide(
          typeId: typeId,
          image: imageFile,
          isFront: isFront,
          attachmentId: attachmentId,
        );
      }
    } catch (e) {
      dprint('Error picking image for side: $e');
    }
  }

  Future<void> uploadSingleSide({
    required String typeId,
    required File image,
    required bool isFront,
    String? attachmentId,
  }) async {
    try {
      uploading(true);

      final formData = dio.FormData.fromMap({
        isFront ? 'url_face' : 'url_back': await dio.MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
        'attTypeId': typeId,
      });

      final String url = attachmentId != null
          ? '${ApiUrls.attachmentUploadUrl}/$attachmentId'
          : ApiUrls.attachmentUploadUrl;

      final res = await (attachmentId != null
          ? apiService.patch(url: url, body: formData)
          : apiService.post(url: url, body: formData));

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception();
      }

      Get.snackbar(
        AppLanguage.tureOperationStr.tr,
        AppLanguage.uploadSuccessStr.tr,
      );

      // Refresh data
      await getAttachments();
    } catch (e) {
      dprint('Error uploading single side: $e');
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      uploading(false);
    }
  }

  Future<void> uploadAttachment() async {
    if (frontImage.value == null || selectedTypeId.value.isEmpty) {
      return;
    }

    try {
      uploading(true);

      final formData = dio.FormData.fromMap({
        'url_face': await dio.MultipartFile.fromFile(
          frontImage.value!.path,
          filename: frontImage.value!.path.split('/').last,
        ),
        if (backImage.value != null)
          'url_back': await dio.MultipartFile.fromFile(
            backImage.value!.path,
            filename: backImage.value!.path.split('/').last,
          ),
        'attTypeId': selectedTypeId.value,
      });

      final res = await apiService.post(
        url: ApiUrls.attachmentUploadUrl,
        body: formData,
      );

      if (res.statusCode != 200 && res.statusCode != 201) {
        throw Exception();
      }

      Get.snackbar(
        AppLanguage.tureOperationStr.tr,
        AppLanguage.uploadSuccessStr.tr,
      );

      // Clear selections
      frontImage.value = null;
      backImage.value = null;
      selectedTypeId.value = '';
      isTwoSided.value = false;

      // Refresh attachments list
      await getAttachments();
    } catch (e) {
      dprint('Error uploading attachment: $e');
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
        error = ServerFailure.fromDioError(e).message;
      }
      showExceptionAlertDialog(
        title: AppLanguage.errorStr.tr,
        exception: error,
      );
    } finally {
      uploading(false);
    }
  }

  Future<void> deleteAttachment(String id) async {
    try {
      loading(true);
      await apiService.delete(url: '${ApiUrls.attachmentUploadUrl}/$id');

      Get.snackbar(
        AppLanguage.tureOperationStr.tr,
        AppLanguage.deleteSuccessStr.tr,
      );

      await getAttachments();
    } catch (e) {
      dprint('Error deleting attachment: $e');
      String error = AppLanguage.unexpectedErrorStr.tr;
      if (e is dio.DioException) {
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
}

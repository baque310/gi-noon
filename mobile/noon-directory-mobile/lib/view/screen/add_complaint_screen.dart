import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/extensions/from_validators.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/widget/files_list_widget.dart';
import 'package:noon/view/widget/upload_file_widget.dart';
import '../../controllers/complaints_controller.dart';
import '../../controllers/image_list_controller.dart';
import '../../core/constant/app_text_style.dart';
import '../widget/bs_take_picture.dart';
import '../widget/color_button.dart';
import '../widget/custom_appbar.dart';
import '../widget/text_field_with_label.dart';

class AddComplaintScreen extends StatelessWidget {
  final controller = Get.find<ComplaintsController>();
  final _imageListController = Get.put(ImageListController());

  AddComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.complaints.tr,
        isLeading: true,
      ),
      body: Form(
        key: controller.formKey,
        child: ListView(
          padding: const .symmetric(horizontal: 16, vertical: 24),
          children: [
            TextFieldWithLabel(
              label: AppLanguage.complaintRequest.tr,
              controller: controller.titleController,
              validator: (val) => val.isValidText,
            ),
            const SizedBox(height: 8),
            TextFieldWithLabel(
              label: AppLanguage.detailsStr.tr,
              controller: controller.descriptionController,
              maxLines: 4,
              validator: (val) => val.isValidText,
            ),
            const SizedBox(height: 24),
            Text(
              AppLanguage.optionalAddPicture.tr,
              style: AppTextStyles.semiBold14,
            ),
            const SizedBox(height: 8),
            UploadFileWidget(
              title: AppLanguage.pressToAddComplaintPicture.tr,
              onTaped: () => bsTakePicture(
                galleryPress: () {
                  _imageListController.takeImageAndAddToList(.gallery);
                },
                cameraPress: () {
                  _imageListController.takeImageAndAddToList(.camera);
                },
              ),
            ),
            const SizedBox(height: 24),
            GetX<ImageListController>(
              builder: (_) {
                return _imageListController.images.isNotEmpty
                    ? FilesListWidget(
                        files: _imageListController.images,
                        onRemoveFilePressed:
                            _imageListController.removeImageFromList,
                      )
                    : const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 24),
            ColorButton(
              press: controller.sendComplaint,
              text: AppLanguage.send.tr,
            ),
          ],
        ),
      ),
    );
  }
}

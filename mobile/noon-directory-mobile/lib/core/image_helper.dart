import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/print_value.dart';

class ImageHelper {
  static Future<File?> getImage(ImageSource media) async {
    try {
      final ImagePicker picker = ImagePicker();
      final img = await picker.pickImage(source: media);

      if (img == null) {
        return null;
      }

      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: img.path,
        maxWidth: 1024,
        maxHeight: 1024,
        compressQuality: 90,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            statusBarLight: true,
            toolbarColor: AppColors.mainColor,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            // backgroundColor: AppColors.mainColor,
            // dimmedLayerColor: AppColors.mainColor,
            // cropFrameColor: AppColors.mainColor,
            // cropGridColor: AppColors.mainColor,
            hideBottomControls: true,
            lockAspectRatio: false,

            // activeControlsWidgetColor: AppColors.mainColor,
          ),
          IOSUiSettings(
            hidesNavigationBar: true,
            // title: 'Profile Image',
          ),
        ],
      );
      if (croppedFile != null) {
        return File(croppedFile.path);
      }
    } on PlatformException catch (e) {
      dprint('Failed to pick image: $e');
    }
    return null;
  }
}

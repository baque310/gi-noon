import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../core/image_helper.dart';

class ImageListController extends GetxController {
  final RxList<File> images = RxList<File>([]);

  Future<void> takeImageAndAddToList(ImageSource media) async {
    Get.back();
    final imageFile = await ImageHelper.getImage(media);
    if (imageFile != null) {
      images.add(imageFile);
    }
  }

  void removeImageFromList(int index) => images.removeAt(index);
}

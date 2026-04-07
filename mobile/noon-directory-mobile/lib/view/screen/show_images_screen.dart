// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/view/widget/color_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../core/file_helper.dart';
import '../../controllers/library_controller.dart';
import '../../core/localization/language.dart';
import '../../models/lesson_attachment_model.dart';

class ShowImageGalleryScreen extends StatefulWidget {
  final List<String>? img;
  final List<LessonAttachmentModel> images;
  final int initialIndex;
  final bool isLocal;

  const ShowImageGalleryScreen({
    super.key,
    required this.images,
    this.img,
    this.initialIndex = 0,
    this.isLocal = false,
  });

  @override
  State<ShowImageGalleryScreen> createState() => _ShowImageGalleryScreenState();
}

class _ShowImageGalleryScreenState extends State<ShowImageGalleryScreen> {
  late PageController _pageController;
  late int _currentPage;
  final RxBool _isSharing = false.obs;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  int get totalImages => (widget.img != null && widget.images.isEmpty)
      ? widget.img!.length
      : widget.images.length;

  String _getImageUrl(int index) {
    final rawUrl = (widget.img != null && widget.images.isEmpty)
        ? widget.img![index]
        : widget.images[index].url;

    return rawUrl.startsWith('http')
        ? rawUrl
        : rawUrl.imgUrlToFullUrl ?? rawUrl;
  }

  bool _isImageFile(int index) {
    if (widget.img != null && widget.images.isEmpty) return true;
    final extension = widget.images[index].url
        .split('/')
        .last
        .split('.')
        .last
        .toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(extension);
  }

  Future<void> _shareImage(int index) async {
    if (_isSharing.value) return;

    _isSharing.value = true;
    try {
      if (widget.isLocal && widget.img != null && widget.img!.isNotEmpty) {
        final file = File(widget.img![index]);
        if (await file.exists()) {
          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(file.path)],
              text: AppLanguage.showImagesStr.tr,
            ),
          );
        }
      } else {
        final url = _getImageUrl(index);
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final tempDir = await getTemporaryDirectory();
          final fileName = url.split('/').last.split('?').first;
          final file = File('${tempDir.path}/$fileName');
          await file.writeAsBytes(response.bodyBytes);

          await SharePlus.instance.share(
            ShareParams(
              files: [XFile(file.path)],
              text: AppLanguage.showImagesStr.tr,
            ),
          );

          await file.delete();
        }
      }
    } catch (e) {
      Get.snackbar(AppLanguage.errorStr.tr, AppLanguage.unexpectedErrorStr.tr);
    } finally {
      _isSharing.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final libCtrl = Get.put(LibraryController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          '${_currentPage + 1} / $totalImages',
          style: AppTextStyles.medium16.copyWith(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: _isSharing.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.share, color: Colors.white),
              onPressed: _isSharing.value
                  ? null
                  : () => _shareImage(_currentPage),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: totalImages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              if (widget.isLocal &&
                  widget.img != null &&
                  widget.img!.isNotEmpty) {
                return GalleryImageItem(
                  url: widget.img![index],
                  isLocal: true,
                  isCurrent: _currentPage == index,
                );
              } else if (_isImageFile(index)) {
                return GalleryImageItem(
                  url: _getImageUrl(index),
                  isLocal: false,
                  isCurrent: _currentPage == index,
                );
              } else {
                return _buildUnsupportedFileView(index);
              }
            },
          ),

          // Page indicator dots
          if (totalImages > 1)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: .center,
                children: List.generate(
                  totalImages,
                  (index) => Container(
                    margin: const .symmetric(horizontal: 4),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: SafeArea(
              child: ColorButton(
                height: 48,
                text: _isImageFile(_currentPage)
                    ? AppLanguage.saveImageStr.tr
                    : AppLanguage.saveFileStr,
                press: () async {
                  final url = _getImageUrl(_currentPage);
                  if (_isImageFile(_currentPage)) {
                    await FileHelper.saveImageToGallery(url);
                  } else {
                    final fileName = url.split('/').last.split('?').first;
                    await FileHelper.downloadFile(
                      url: url,
                      onComplete: (savedName, path) {
                        if (savedName == fileName ||
                            savedName.contains(fileName)) {
                          libCtrl.addDownloadedFile(savedName, path);
                        }
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnsupportedFileView(int index) {
    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const Icon(Icons.insert_drive_file, color: Colors.white, size: 64),
          const SizedBox(height: 16),
          Text(
            AppLanguage.saveFileStr,
            style: AppTextStyles.medium16.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            widget.images[index].url.split('/').last,
            style: AppTextStyles.regular14.copyWith(color: Colors.white70),
            textAlign: .center,
          ),
        ],
      ),
    );
  }
}

class GalleryImageItem extends StatefulWidget {
  final String url;
  final bool isLocal;
  final bool isCurrent;

  const GalleryImageItem({
    super.key,
    required this.url,
    required this.isLocal,
    required this.isCurrent,
  });

  @override
  State<GalleryImageItem> createState() => _GalleryImageItemState();
}

class _GalleryImageItemState extends State<GalleryImageItem> {
  final _transformationController = TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(GalleryImageItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isCurrent &&
        _transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    }
  }

  void _handleDoubleTap() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    if (currentScale > 1.0) {
      _transformationController.value = Matrix4.identity();
    } else {
      const zoomScale = 2.2;
      _transformationController.value = Matrix4.identity()
        ..translate(
          -context.mediaQuerySize.width * (zoomScale - 1) / 2,
          -context.mediaQuerySize.height * (zoomScale - 1) / 2,
        )
        ..scale(zoomScale);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLocal) {
      return GestureDetector(
        onDoubleTap: _handleDoubleTap,
        child: InteractiveViewer(
          transformationController: _transformationController,
          minScale: 0.5,
          maxScale: 4.0,
          child: Center(
            child: Image.file(File(widget.url), fit: BoxFit.contain),
          ),
        ),
      );
    }

    return GestureDetector(
      onDoubleTap: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformationController,
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: widget.url,
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            errorWidget: (context, url, error) => Center(
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLanguage.errorStr.tr,
                    style: AppTextStyles.medium16.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

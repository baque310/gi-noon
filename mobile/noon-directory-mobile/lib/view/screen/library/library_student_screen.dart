import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/core/extensions/string_extension.dart';
import 'package:noon/core/file_helper.dart';
import 'package:noon/models/library_model.dart';
import 'package:noon/view/screen/library/widgets/student_library_card_widget.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/error_message.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/retry_btn.dart';
import '../../../controllers/library_controller.dart';
import '../../../core/localization/language.dart';
import '../pdf_viewer_screen.dart';
import '../show_images_screen.dart';

class LibraryStudentScreen extends StatelessWidget {
  LibraryStudentScreen({super.key});

  final LibraryController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    final controller = _controller.pagingController;
    final firstPageKey = controller.firstPageKey;
    final nextPageKey = controller.nextPageKey ?? 0;

    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          appBarName: AppLanguage.libraryStr.tr,
          isLeading: true,
          press: () => Get.back(),
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const .only(left: 16, top: 16, bottom: 24, right: 16),
              sliver: PagedSliverList(
                pagingController: controller,
                builderDelegate: PagedChildBuilderDelegate<LibraryModel>(
                  itemBuilder: (context, item, index) {
                    return Obx(() {
                      bool isLoading = _controller.loadingIndex.value == index;

                      String fileName = item.url?.split('/').last ?? '';

                      bool isDownloaded = _controller.downloadedFiles.contains(
                        fileName,
                      );

                      String fileExtension = fileName
                          .split('.')
                          .last
                          .toLowerCase();

                      String? filePath = _controller.downloadedFilesPaths
                          .firstWhereOrNull(
                            (element) => element.contains(fileName),
                          );

                      bool isImage = [
                        'jpg',
                        'jpeg',
                        'png',
                        'gif',
                      ].contains(fileExtension);

                      bool isPdf = fileExtension == 'pdf';

                      void handleDownload() async {
                        if (isDownloaded) {
                          if (isImage) {
                            Get.to(
                              () => ShowImageGalleryScreen(
                                isLocal: true,
                                img: filePath != null ? [filePath] : const [],
                                images: const [],
                              ),
                            );
                          } else if (isPdf) {
                            Get.to(
                              () => PdfViewerScreen(
                                isLocalFile: true,
                                pdfUrl: filePath ?? '',
                              ),
                            );
                          }
                        } else {
                          FileHelper.downloadFile(
                            url: item.url.imgUrlToFullUrl ?? '',
                            onComplete: (savedName, path) {
                              if (savedName == fileName) {
                                _controller.addDownloadedFile(savedName, path);
                              }
                            },
                          );
                        }
                      }

                      return StudentLibraryCard(
                        textBtn: isDownloaded
                            ? AppLanguage.openDownloadFileStr.tr
                            : AppLanguage.downloadFileStr.tr,
                        isLoading: isLoading,
                        title: item.title,
                        desc: item.description,
                        pressDownload: handleDownload,
                        isFile: isPdf,
                        onShare: isDownloaded && filePath != null
                            ? () => FileHelper.shareFile(filePath)
                            : null,
                      );
                    });
                  },
                  firstPageErrorIndicatorBuilder: (_) => ErrorMessage(
                    press: () => _controller.getLibraries(firstPageKey),
                    errorMsg: AppLanguage.errorStr.tr,
                  ),
                  newPageErrorIndicatorBuilder: (_) => RetryBtn(
                    press: () => _controller.getLibraries(nextPageKey),
                  ),
                  firstPageProgressIndicatorBuilder: (_) => const Loading(),
                  newPageProgressIndicatorBuilder: (_) => const Loading(),
                  noItemsFoundIndicatorBuilder: (_) =>
                      NoDataWidget(title: AppLanguage.noInfoAvailable.tr),
                  noMoreItemsIndicatorBuilder: (_) => const SizedBox(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

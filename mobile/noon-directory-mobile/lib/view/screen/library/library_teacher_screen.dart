import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:noon/controllers/library_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/models/library_model.dart';
import 'package:noon/view/screen/library/widgets/teacher_library_card_widget.dart';
import 'package:noon/view/widget/bottom_navbar.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/error_message.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/retry_btn.dart';
import '../../../core/constant/api_urls.dart';
import '../../../core/localization/language.dart';
import '../pdf_viewer_screen.dart';
import '../show_images_screen.dart';

class LibraryTeacherScreen extends StatelessWidget {
  LibraryTeacherScreen({super.key});

  final _controller = Get.find<LibraryController>();

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
                    return LibraryTeacherCard(
                      onTap: () {
                        if (item.url != null) {
                          final fileUrl = item.url.toString().toLowerCase();
                          if (fileUrl.endsWith('.pdf')) {
                            Get.to(
                              () => PdfViewerScreen(
                                pdfUrl: "${ApiUrls.filesUrl}/$fileUrl",
                              ),
                            );
                          } else {
                            Get.to(
                              () => ShowImageGalleryScreen(
                                img: [fileUrl],
                                images: const [],
                              ),
                            );
                          }
                        }
                      },
                      date: item.createdAt?.formatDateToYearMonthDay ?? '',
                      subject: item.title ?? '',
                      title: item.title ?? '',
                      desc: item.description ?? '',
                      img: item.url ?? '',
                      editPress: () async {
                        _controller.title(item.title);
                        _controller.description(item.description);
                        _controller.titleController.text = item.title ?? '';
                        _controller.descController.text =
                            item.description ?? '';
                        _controller.id(item.id);
                        await _controller.prefillEditSelections(
                          classId: item.classId,
                          sectionId: item.sectionId,
                        );

                        Get.toNamed(
                          ScreensUrls.addfileTeacherScreenUrl,
                          arguments: true,
                        );
                      },
                      onPressedDelete: () async {
                        if (!_controller.isWaiting.value) {
                          _controller.deleteLibraryItem(item.id);
                          _controller.isWaiting.value = true;
                          await Future.delayed(const Duration(seconds: 1), () {
                            _controller.isWaiting.value = false;
                          });
                        }
                      },
                    );
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
        bottomNavigationBar: BottomNavbar(
          text: AppLanguage.addFileIntoLibraryStr.tr,
          icon: AppAssets.icAdd,
          onTap: () => Get.toNamed(ScreensUrls.addfileTeacherScreenUrl),
        ),
      ),
    );
  }
}

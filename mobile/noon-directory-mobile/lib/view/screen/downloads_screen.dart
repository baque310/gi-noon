import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:s_extensions/s_extensions.dart';
import 'package:noon/controllers/library_controller.dart';
import 'package:noon/view/screen/pdf_viewer_screen.dart';
import 'package:noon/view/screen/show_images_screen.dart';
import 'package:noon/view/screen/library/widgets/student_library_card_widget.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/file_helper.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/view/widget/alert_dialogs.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LibraryController());
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          appBarName: AppLanguage.downloads.tr,
          isLeading: true,
        ),
        body: Padding(
          padding: const .all(16),
          child: Obx(() {
            final files = controller.downloadedFiles;
            final paths = controller.downloadedFilesPaths;

            if (files.isEmpty) {
              return NoDataWidget(
                title: AppLanguage.noFilesDownloadedYet.tr,
              ).center();
            }

            return ListView.separated(
              itemCount: files.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (_, i) {
                final fileName = files[i];
                final path = paths.firstWhere(
                  (p) => p.contains(fileName),
                  orElse: () => '',
                );
                final ext = fileName.split('.').last.toLowerCase();
                final isImage = ['jpg', 'jpeg', 'png', 'gif'].contains(ext);
                final isPdf = ext == 'pdf';

                return Dismissible(
                  key: ValueKey(fileName),
                  direction: .endToStart,
                  background: Container(
                    alignment: .centerRight,
                    padding: const .only(right: 16),
                    color: AppColors.redColor,
                    child: const Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                    ),
                  ),
                  confirmDismiss: (_) async {
                    final res = await showAlertDialog(
                      title: AppLanguage.warning.tr,
                      content: AppLanguage.deleteMsgDesc.tr,
                      cancelActionText: AppLanguage.cancel.tr,
                      defaultActionText: AppLanguage.deleteStr.tr,
                      defaultActionBg: AppColors.redColor,
                    );
                    return res ?? false;
                  },
                  onDismissed: (_) async {
                    await controller.removeDownloadedFile(fileName);
                  },
                  child: StudentLibraryCard(
                    title: fileName.truncate(12),
                    desc: path.split('/0/').last,
                    isLoading: false,
                    textBtn: AppLanguage.openDownloadFileStr.tr,
                    isFile: isPdf,
                    onShare: () async {
                      final fileExists = await FileHelper.shareFile(path);
                      if (!fileExists) {
                        await controller.removeDownloadedFile(fileName);
                      }
                    },
                    pressDownload: () async {
                      final file = File(path);
                      if (!await file.exists()) {
                        final shouldRemove = await showAlertDialog(
                          title: AppLanguage.fileShareErrorTitle.tr,
                          content: AppLanguage.fileNotFoundError.tr,
                          cancelActionText: AppLanguage.cancel.tr,
                          defaultActionText: AppLanguage.deleteStr.tr,
                          defaultActionBg: AppColors.redColor,
                        );

                        if (shouldRemove == true) {
                          await controller.removeDownloadedFile(fileName);
                        }
                        return;
                      }

                      if (isImage) {
                        Get.to(
                          () => ShowImageGalleryScreen(
                            isLocal: true,
                            img: [path],
                            images: const [],
                          ),
                        );
                      } else if (isPdf) {
                        Get.to(
                          () =>
                              PdfViewerScreen(isLocalFile: true, pdfUrl: path),
                        );
                      }
                    },
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

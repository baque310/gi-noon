import 'dart:io';
import 'package:flutter/material.dart';
import 'package:noon/core/print_value.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:get/get.dart';
import '../../core/localization/language.dart';
import '../widget/custom_appbar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../core/file_helper.dart';
import 'package:noon/controllers/library_controller.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  final bool isLocalFile;

  const PdfViewerScreen({
    super.key,
    required this.pdfUrl,
    this.isLocalFile = false,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  @override
  void initState() {
    super.initState();
    _checkAndDownloadFile();
  }

  Future<void> _checkAndDownloadFile() async {
    if (widget.isLocalFile) return;

    try {
      final fileName = widget.pdfUrl.split('/').last.split('?').first;
      final downloadedFilesBox = Hive.box<String>('downloaded_files');

      // Check if file is already downloaded
      if (!downloadedFilesBox.values.contains(fileName)) {
        await FileHelper.downloadFile(
          url: widget.pdfUrl,
          name: fileName,
          onComplete: (savedName, path) {
            if (savedName == fileName) {
              _updateDownloadedRecords(savedName, path);
            }
          },
        );
      }
    } catch (e) {
      dprint('Error auto-downloading PDF: $e');
    }
  }

  void _updateDownloadedRecords(String fileName, String path) {
    // Update LibraryController if it's alive
    if (Get.isRegistered<LibraryController>()) {
      Get.find<LibraryController>().addDownloadedFile(fileName, path);
    } else {
      // Manually update Hive boxes if controller is not initialized
      try {
        final filesBox = Hive.box<String>('downloaded_files');
        final pathsBox = Hive.box<String>('downloaded_files_paths');

        filesBox.put(fileName, fileName);
        pathsBox.put(fileName, path);
      } catch (e) {
        dprint('Error updating Hive boxes: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    dprint(tag: 'PDF', widget.pdfUrl);
    return Scaffold(
      appBar: CustomAppBar(
        appBarName: AppLanguage.libraryStr.tr,
        isLeading: true,
        press: () => Get.back(),
      ),
      body: widget.isLocalFile
          ? SfPdfViewer.file(File(widget.pdfUrl))
          : SfPdfViewer.network(widget.pdfUrl),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mime/mime.dart';
import 'package:noon/controllers/homework_controller.dart';
import 'package:noon/core/enum.dart';
import 'package:noon/view/widget/images/custom_network_image.dart';

import '../../core/constant/app_assets.dart';
import '../../core/constant/app_colors.dart';

class FilesListWidget extends StatelessWidget {
  const FilesListWidget({
    super.key,
    required this.files,
    required this.onRemoveFilePressed,
  });

  final List<FileOrUrl> files;
  final void Function(int index) onRemoveFilePressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 164,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, i) {
          return Padding(
            padding: const .only(left: 4),
            child: Stack(
              children: [
                DisplayImageWidget(file: files[i]),
                Positioned(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      backgroundColor: AppColors.gray100Color,
                    ),
                    onPressed: () => onRemoveFilePressed(i),
                    child: SvgPicture.asset(AppAssets.icDelete),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: files.length,
      ),
    );
  }

  bool isImage(String path) {
    final mimeType = lookupMimeType(path);
    return mimeType!.startsWith('image/');
  }
}

class DisplayImageWidget extends StatelessWidget {
  const DisplayImageWidget({super.key, this.file});

  final FileOrUrl file;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 172,
      height: 172,
      decoration: BoxDecoration(
        borderRadius: .circular(10),
        border: fileType != FileType.pdf
            ? null
            : .all(color: AppColors.gray500Color, width: 1),
      ),
      child: fileType != FileType.pdf
          ? ClipRRect(
              borderRadius: .circular(10),
              child: fileType == FileType.image
                  ? Image.file(file, fit: BoxFit.cover)
                  : CustomNetworkImage(
                      imageUrl: file,
                      fit: BoxFit.cover,
                      radius: .circular(10),
                    ),
            )
          : Padding(
              padding: const EdgeInsets.all(40.0),
              child: SvgPicture.asset(AppAssets.icPdf),
            ),
    );
  }

  FileType get fileType {
    if (file is String) {
      return FileType.url;
    }
    final localFile = file as File;
    final mimeType = lookupMimeType(localFile.path);
    return mimeType!.startsWith('image/') ? FileType.image : FileType.pdf;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/widget/profile_image.dart';
import 'package:noon/view/screen/show_images_screen.dart';

class StudentCard extends StatelessWidget {
  final CommunicationController comController;
  final String photoUrl;
  final String fullName;
  final String id;

  const StudentCard({
    super.key,
    required this.comController,
    required this.photoUrl,
    required this.fullName,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = AppTextStyles.medium14;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: .circular(getDynamicHeight(12)),
      ),
      child: ListTile(
        contentPadding: .symmetric(
          vertical: getDynamicHeight(12),
          horizontal: getDynamicWidth(12),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: .circular(getDynamicHeight(12)),
        ),
        leading: ProfileImage(
          firstCharFromName: fullName.isNotEmpty
              ? fullName.substring(0, 1)
              : 'S',
          imageUrl: photoUrl,
          onTap: () {
            if (photoUrl.isNotEmpty) {
              Get.to(
                () => ShowImageGalleryScreen(img: [photoUrl], images: const []),
              );
            }
          },
        ),
        title: Text(
          "${AppLanguage.studentStr.tr}: $fullName",
          style: titleStyle.copyWith(
            color: titleStyle.color!.withValues(alpha: 0.87),
          ),
        ),
        subtitle: null,
        trailing: InkWell(
          onTap: () async {
            await comController.createDirectMsgChatWithStudent(studentId: id);
          },
          child: SvgPicture.asset(
            AppAssets.icChatOutlineV3,
            width: 40,
            height: 40,
          ),
        ),
      ),
    );
  }
}

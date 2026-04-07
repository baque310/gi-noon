import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/widget/profile_image.dart';

import '../../core/enum.dart';
import '../../core/localization/language.dart';
import '../screen/show_images_screen.dart';

class TeacherCard extends StatelessWidget {
  final CommunicationController comController;
  final String photoUrl;
  final String fullName;
  final String? gender;
  final List<String?>? subjects;
  final String id;

  const TeacherCard({
    super.key,
    required this.comController,
    required this.photoUrl,
    required this.fullName,
    this.subjects,
    this.gender,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = AppTextStyles.medium14;
    final subtitleStyle = AppTextStyles.medium12;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: .circular(getDynamicHeight(12)),
      ),
      child: ListTile(
        contentPadding: (subjects != null && subjects!.length > 1)
            ? .symmetric(
                vertical: getDynamicHeight(12),
                horizontal: getDynamicWidth(12),
              )
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: .circular(getDynamicHeight(12)),
        ),
        leading: ProfileImage(
          firstCharFromName: fullName.substring(0, 1),
          imageUrl: photoUrl,
          onTap: () {
            if (photoUrl != '') {
              Get.to(
                () => ShowImageGalleryScreen(img: [photoUrl], images: const []),
              );
            }
          },
        ),
        title: Text(
          "${gender == Gender.male.name ? AppLanguage.teacherStr.tr : AppLanguage.teacherFStr.tr}: $fullName",
          style: titleStyle.copyWith(
            color: titleStyle.color!.withValues(alpha: 0.87),
          ),
        ),
        subtitle: subjects != null && subjects!.isNotEmpty
            ? Column(
                crossAxisAlignment: .start,
                children: subjects!.map((subject) {
                  return Padding(
                    padding: .symmetric(vertical: subjects!.length > 1 ? 1 : 0),
                    child: Text(
                      "${AppLanguage.subjectStr.tr}: $subject",
                      style: subtitleStyle.copyWith(
                        color: subtitleStyle.color!.withValues(alpha: 0.60),
                      ),
                    ),
                  );
                }).toList(),
              )
            : Text(
                '',
                style: subtitleStyle.copyWith(
                  color: subtitleStyle.color!.withValues(alpha: 0.60),
                ),
              ),
        trailing: InkWell(
          onTap: () async {
            await comController.createDirectMsgChat(teacherId: id);
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

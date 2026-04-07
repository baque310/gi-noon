import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/login_controller.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/teacher_model.dart';
import 'package:noon/models/user_model.dart';
import 'package:noon/view/widget/app_rating_bottom_sheet.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import 'package:noon/view/widget/bs_take_picture.dart';
import 'package:noon/view/widget/profile_image.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/view/widget/profile_language_item.dart';
import '../../../../../core/enum.dart';
import '../../../show_images_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final loginController = Get.find<LoginController>();
  final controller = Get.find<ProfileController>();
  final gController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top + 20),
            Text(
              "الحساب",
              style: AppTextStyles.bold22.copyWith(
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 10),
            _buildHeader(user, context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  if (gController.isStudent && getSchoolName(user) != '')
                    _buildActionTile(
                      icon: Icons.school_rounded,
                      title: "المدرسة",
                      value: getSchoolName(user),
                    ),

                  if (gController.isStudent && getYear(user) != '')
                    _buildActionTile(
                      icon: Icons.calendar_today_rounded,
                      title: "السنة الدراسية",
                      value: getYear(user),
                    ),

                  _buildActionTile(
                    icon: Icons.cake_rounded,
                    title: "تاريخ الميلاد",
                    value: getBirth(user),
                  ),

                  _buildActionTile(
                    icon: Icons.person_rounded,
                    title: "تعديل الحساب",
                    onTap: () => _showEditDialog(context),
                  ),

                  if (gController.isParent)
                    _buildActionTile(
                      icon: Icons.family_restroom_rounded,
                      title: AppLanguage.chooseAnotherStudent.tr,
                      onTap: () => Get.toNamed(
                        ScreensUrls.selectChildScreenUrl,
                        arguments: {'canPop': true},
                      ),
                    ),

                  if (gController.isStudent)
                    _buildActionTile(
                      icon: Icons.attach_file_rounded,
                      title: AppLanguage.attachmentsStr.tr,
                      onTap: () =>
                          Get.toNamed(ScreensUrls.attachmentsScreenUrl),
                    ),

                  _buildActionTile(
                    icon: Icons.download_rounded,
                    title: AppLanguage.downloads.tr,
                    onTap: () => Get.toNamed(ScreensUrls.downloadsScreenUrl),
                  ),

                  _buildActionTile(
                    icon: Icons.star_rate_rounded, // or Iconsax.star1
                    title: "تقييم التطبيق",
                    onTap: () => Get.bottomSheet(
                      const AppRatingBottomSheet(),
                      isScrollControlled: true,
                    ),
                  ),

                  _buildActionTile(
                    icon: Icons.language_rounded,
                    title: AppLanguage.language.tr.replaceAll(':', '').trim(),
                    onTap: () => Get.bottomSheet(LanguageSelectorBS()),
                  ),

                  _buildActionTile(
                    icon: Icons.logout_rounded,
                    title: AppLanguage.logoutStr.tr,
                    onTap: _onLogout,
                    isDestructive: true,
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(UserModel user, BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 10),
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image with Camera Button
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    width: 3,
                  ),
                ),
                child: ProfileImage(
                  onTap: (getImg(user).isNotEmpty)
                      ? () {
                          Get.to(
                            () => ShowImageGalleryScreen(
                              img: [getImg(user)],
                              images: const [],
                            ),
                          );
                        }
                      : null,
                  firstCharFromName: getNameProfiler(user).length > 2
                      ? getNameProfiler(user).substring(0, 1)
                      : getNameProfiler(user),
                  imageUrl: getImg(user),
                  size: 80,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: InkWell(
                  onTap: () => bsTakePicture(
                    galleryPress: () => controller.getImage(.gallery),
                    cameraPress: () => controller.getImage(.camera),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.edit_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            getNameProfiler(user),
            style: AppTextStyles.bold18.copyWith(
              color: const Color(0xFF1E293B),
              fontSize: 20,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            getPhoneNumber(user).isNotEmpty
                ? getPhoneNumber(user)
                : profileNameByType,
            style: AppTextStyles.medium14.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
          if (gController.isStudent) const SizedBox(height: 16),
          if (gController.isStudent)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (getSection(user).isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warningColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getSection(user).contains('شعبة')
                          ? getSection(user)
                          : 'الشعبة ${getSection(user)}',
                      style: AppTextStyles.bold12.copyWith(
                        color: AppColors.warningColor, // Match orange theme
                      ),
                    ),
                  ),
                if (getClasses(user).isNotEmpty && getSection(user).isNotEmpty)
                  const SizedBox(width: 8),
                if (getClasses(user).isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.warningColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      getClasses(user),
                      style: AppTextStyles.bold12.copyWith(
                        color: AppColors.warningColor, // Match orange theme
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    // Initialize standard values to controller
    controller.updateEditProfileInputs();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: const Color(0xFFF8F9FB),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 450),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(width: 40), // spacer for centering
                      Text(
                        "تعديل معلومات الحساب",
                        style: AppTextStyles.bold16.copyWith(
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                      InkWell(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Color(0xFF2D3142),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFE5E5E5)),

                // Dialog Body
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "تاريخ الميلاد:",
                          style: AppTextStyles.medium14.copyWith(
                            color: Colors.blueGrey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Obx(() {
                          return InkWell(
                            onTap: () => controller.pickDate(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.withValues(alpha: 0.2),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Colors.teal,
                                  ),
                                  Text(
                                    controller.selectedDate.value.isEmpty
                                        ? "اختر التاريخ"
                                        : controller.selectedDate.value,
                                    style: AppTextStyles.medium14.copyWith(
                                      color: const Color(0xFF2D3142),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),

                        const SizedBox(height: 20),

                        Text(
                          "رقم الهاتف:",
                          style: AppTextStyles.medium14.copyWith(
                            color: Colors.blueGrey[400],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: controller.phoneController,
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.end,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            ),
                            onChanged: (val) => controller.phone.value = val,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Dialog Footer
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed:
                          controller.loading.value || !controller.hasChanges
                          ? null
                          : () async {
                              await controller.updateUserById();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BA5B5),
                        disabledBackgroundColor: const Color(
                          0xFF8BA5B5,
                        ).withValues(alpha: 0.5),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: controller.loading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "تعديل",
                              style: AppTextStyles.bold16.copyWith(
                                color: Colors.white,
                              ),
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? value,
    bool isDestructive = false,
    VoidCallback? onTap,
  }) {
    final color = isDestructive ? Colors.red : AppColors.warningColor;
    final textColor = isDestructive ? Colors.red : const Color(0xFF2D3142);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bold14.copyWith(
                    color: textColor,
                    fontSize: 15,
                  ),
                ),
              ),
              if (value != null) ...[
                Text(
                  value,
                  style: AppTextStyles.medium14.copyWith(
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (onTap != null)
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: Color(0xFF64748B),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helpers ---
  void _onLogout() async {
    final confirmed = await showAlertDialog(
      title: AppLanguage.logoutConfirmTitle.tr,
      content: AppLanguage.logoutConfirmMessage.tr,
      cancelActionText: AppLanguage.cancel.tr,
      defaultActionText: AppLanguage.logoutStr.tr,
      defaultActionBg: AppColors.redColor,
    );
    if (confirmed == true) {
      loginController.logout();
    }
  }

  String get profileNameByType {
    if (gController.isStudent) {
      return AppLanguage.studentStr.tr;
    } else if (gController.isTeacher) {
      return controller.user.value!.teacher!.gender == Gender.male.name
          ? AppLanguage.teacherStr.tr
          : AppLanguage.teacherFStr.tr;
    } else {
      return AppLanguage.guardian.tr;
    }
  }

  String getNameProfiler(UserModel? user) {
    if (gController.isTeacher) {
      return user?.teacher?.fullName ?? '';
    } else if (gController.isStudent) {
      return user?.student?.fullName ?? '';
    } else {
      return user?.parent?.fullName ?? '';
    }
  }

  String getYear(UserModel? user) {
    if (gController.isTeacher) {
      if (user?.teacher?.teacherSubjects != null &&
          user!.teacher!.teacherSubjects!.isEmpty) {
        return '';
      }
      final from = user?.teacher?.teacherSubjects?.first.schoolYear.from;
      final to = user?.teacher?.teacherSubjects?.first.schoolYear.to;
      return '$from - $to';
    } else if (gController.isStudent) {
      final from = user?.student?.studentEnrollment?.first.schoolYear?.from;
      final to = user?.student?.studentEnrollment?.first.schoolYear?.to;
      return '$from - $to';
    } else {
      return '';
    }
  }

  String getSchoolName(UserModel? user) {
    if (gController.isTeacher) {
      return user?.teacher?.school?.name ?? '';
    } else if (gController.isStudent) {
      return user?.student?.school?.name ?? '';
    } else {
      return user?.parent?.school?.name ?? '';
    }
  }

  String getClasses(UserModel? user) {
    if (gController.isTeacher) {
      List<String> classes = [];
      if (user?.teacher?.teacherSubjects != null) {
        for (TeacherSubjectModel c in user!.teacher!.teacherSubjects ?? []) {
          classes.add(c.stageSubject.classDetail?.name ?? '');
        }
      }
      return classes.toSet().join('، ');
    } else if (gController.isStudent) {
      return user?.student?.studentEnrollment?.first.classInfo?.name ?? '';
    } else {
      return '';
    }
  }

  String getSection(UserModel? user) {
    if (gController.isStudent) {
      return user?.student?.studentEnrollment?.first.section?.name ?? '';
    } else {
      return '';
    }
  }

  String getBirth(UserModel? user) {
    if (gController.isTeacher) {
      return user?.teacher?.birth?.formatDateToYearMonthDay ?? '';
    } else if (gController.isStudent) {
      return user?.student?.birth?.formatDateToYearMonthDay ?? '';
    } else {
      return user?.parent?.birth?.formatDateToYearMonthDay ?? '';
    }
  }

  String getPhoneNumber(UserModel? user) {
    if (gController.isTeacher) {
      return user?.teacher?.phone1 ?? '';
    } else if (gController.isStudent) {
      return user?.student?.phone1 ?? '';
    } else {
      return user?.parent?.phone1 ?? '';
    }
  }

  String getGmail(UserModel? user) {
    if (gController.isTeacher) {
      return user?.teacher?.email ?? '';
    } else if (gController.isStudent) {
      return user?.student?.email ?? '';
    } else {
      return user?.parent?.email ?? '';
    }
  }

  String getImg(UserModel? user) {
    if (gController.isTeacher) {
      return user?.teacher?.photo ?? '';
    } else if (gController.isStudent) {
      return user?.student?.photo ?? '';
    } else {
      return user?.parent?.photo ?? '';
    }
  }
}

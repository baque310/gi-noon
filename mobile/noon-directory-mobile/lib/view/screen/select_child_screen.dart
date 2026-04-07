import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/models/student_model.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import '../../controllers/profile_controller.dart';
import '../../core/localization/language.dart';
import '../widget/error_message.dart';
import '../widget/profile_image.dart';

class SelectChildScreen extends StatelessWidget {
  SelectChildScreen({super.key});

  final controller = Get.find<ProfileController>();
  final gController = Get.find<GlobalController>();

  final _canPop = Get.arguments != null ? Get.arguments['canPop'] : false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FB),
        appBar: CustomAppBar(
          appBarName: AppLanguage.selectStudent.tr,
          isLeading: _canPop,
        ),
        body: controller.obx(
          (data) {
            final students = data!.parent!.students!;
            return students.isNotEmpty
                ? SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        _buildHeader(),
                        const SizedBox(height: 30),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: students.length,
                          itemBuilder: (_, i) => StudentCard(
                            student: students[i],
                            isOffAllScreens: _canPop,
                          ),
                        ),
                      ],
                    ),
                  )
                : NoDataWidget(title: AppLanguage.studentsNotFound.tr);
          },
          onLoading: const Center(child: Loading()),
          onError: (e) => ErrorMessage(press: controller.getUser, errorMsg: e),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "أهلاً بك مجدداً 👋",
          style: AppTextStyles.bold16.copyWith(
            fontSize: 24,
            color: AppColors.blackColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "يرجى اختيار أحد أبنائك للمتابعة",
          style: AppTextStyles.medium14.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class StudentCard extends StatelessWidget {
  StudentCard({
    super.key,
    required this.student,
    required this.isOffAllScreens,
  });

  final StudentModel student;
  final bool isOffAllScreens;
  final controller = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      end: 0.96,
      onTap: () {
        controller.setSelectedStudentForParent(
          studentId: student.id,
          classId: student.studentEnrollment!.first.classInfo?.id,
        );

        if (isOffAllScreens) {
          Get.offAllNamed(ScreensUrls.homeUrl);
          return;
        }

        Get.offNamed(ScreensUrls.homeUrl);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'student_ava_${student.id}',
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.mainColor.withValues(alpha: 0.2),
                    width: 2,
                  ),
                ),
                child: ProfileImage(
                  size: 60,
                  firstCharFromName: student.fullName.substring(0, 1),
                  imageUrl: student.photo,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              student.fullName,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bold14.copyWith(color: AppColors.blackColor),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.mainColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                studentClassName ?? 'غير محدد',
                textAlign: TextAlign.center,
                style: AppTextStyles.medium10.copyWith(
                  color: AppColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? get studentClassName {
    if (student.studentEnrollment == null ||
        student.studentEnrollment!.isEmpty) {
      return null;
    }
    return student.studentEnrollment?.first.classInfo?.name;
  }
}

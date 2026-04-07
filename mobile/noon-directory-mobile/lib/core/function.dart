import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/controllers/profile_controller.dart';
import 'package:noon/models/notification_model.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/enum.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/view/widget/date_picker_bottom_sheet.dart';

String? userNameValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'لا يمكن أن يكون اسم المستخدم فارغًا';
  }
  if (value.length < 3) {
    return 'اسم المستخدم يجب أن يكون على الأقل 3 أحرف';
  }
  if (value.length > 25) {
    return 'اسم المستخدم يجب أن يكون أقل من 25 حرفًا';
  }
  return null;
}

String? passwordValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'لايمكن ان تكون كلمة المرور فارغة';
  }
  return null;
}

String? updatePasswordValidation(String? value) {
  if (value == null || value.isEmpty) {
    return 'لا يمكن أن تكون كلمة المرور فارغة';
  }
  if (value.length < 8) {
    return 'لا يمكن أن تكون كلمة المرور أقل من 8 أحرف';
  }
  return null;
}

String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'لا يمكن أن يكون البريد الإلكتروني فارغًا';
  }
  final emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  if (!emailRegex.hasMatch(value)) {
    return 'الرجاء إدخال بريد إلكتروني صحيح';
  }
  return null;
}

String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'لا يمكن أن يكون رقم الهاتف فارغًا';
  }
  final phoneRegex = RegExp(r'^0\d{10}$');
  if (!phoneRegex.hasMatch(value)) {
    return 'رقم الهاتف يجب أن يبدأ بـ 0 ويتكون من 11 رقمًا';
  }
  return null;
}

Future<DateTime?> pickDateMethode({bool canPickFutureDate = true}) async {
  final result = await showModalBottomSheet<DateTime>(
    context: Get.context!,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DatePickerBottomSheet(
        initialDate: DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: canPickFutureDate ? DateTime(2100) : DateTime.now(),
      );
    },
  );
  return result;
}

String capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

String translateStage(String stage) {
  final s = stage.toLowerCase();
  if (s == 'primary') return 'الابتدائية';
  if (s == 'intermediate') return 'اعدادي';
  if (s == 'preparatory') return 'المتوسطة';
  if (s == 'secondary') return 'الثانوية';

  // Return the original string if it doesn't match the known english enums.
  // This allows the dashboard to pass dynamic Arabic names safely.
  return stage;
}

String translateStatus(String status) {
  if (status.toLowerCase() == StudentStutus.present.name) {
    return 'حاضر';
  } else if (status.toLowerCase() == StudentStutus.absent.name) {
    return 'غائب';
  } else {
    return 'مجاز';
  }
}

int getTextMaxLines(String value) {
  TextPainter textPainter = TextPainter(
    text: TextSpan(text: value, style: AppTextStyles.medium14),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: Get.width);

  int lines = (textPainter.size.height / textPainter.preferredLineHeight)
      .ceil();
  return lines;
}

void goToTargetPage(String type, {bool isAlert = false}) {
  final globalController = Get.find<GlobalController>();
  dprint('Navigating to target page for type: $type');

  if (type == 'homework') {
    Get.toNamed(ScreensUrls.homeworksScreenUrl);
    return;
  }
  if (type == 'lesson') {
    Get.toNamed(ScreensUrls.lessonsScreenUrl);
    return;
  }
  if (type == 'exam') {
    if (!globalController.isTeacher) {
      Get.toNamed(ScreensUrls.studentExamScheduleUrl);
    }
    return;
  }
  if (type == 'chat_message') {
    Get.toNamed(ScreensUrls.communicationScreenUrl);
    return;
  }
  if (type == 'studentInstallment' ||
      type == 'payment_reminder' ||
      type == 'payment_overdue' ||
      type == 'other_payment') {
    Get.toNamed(ScreensUrls.aqsatiUrl);
    return;
  }
  if (type == 'sectionSchedule') {
    Get.toNamed(ScreensUrls.schoolScheduleUrl);
    return;
  }
  if (type == 'complaints') {
    Get.toNamed(ScreensUrls.complaintsScreenUrl);
    return;
  }
  if (type == 'gallery') {
    Get.toNamed(ScreensUrls.galleryUrl);
    return;
  }
  if (type == 'guidance') {
    Get.toNamed(ScreensUrls.instructionsUrl);
    return;
  }
  if (type == 'attendance') {
    if (globalController.isStudent || globalController.isParent) {
      Get.toNamed(ScreensUrls.studentAttendancesScreenUrl);
    } else {
      Get.toNamed(ScreensUrls.teacherAttendancesScreenUrl);
    }
    return;
  }
  if (type == 'exam_result') {
    Get.toNamed(ScreensUrls.studentDegreesScreenUrl);
    return;
  }
  if (type == 'library') {
    Get.toNamed(ScreensUrls.libraryStudentScreenUrl);
    return;
  }
  if (type == 'behavior') {
    if (globalController.isStudent || globalController.isParent) {
      Get.toNamed(ScreensUrls.studentBehaviorScreenUrl);
    } else {
      Get.toNamed(ScreensUrls.teacherBehaviorScreenUrl);
    }
    return;
  }
  if (isAlert) {
    Get.toNamed(ScreensUrls.announcementsScreenUrl);
    return;
  }
  dprint('Unknown notification type: $type, navigating to notification');
  Get.toNamed(ScreensUrls.notificationUrl);
}

void goToTargetChatPage(String type, NotificationModel notification) {
  try {
    final conversationId = notification.data?.id;

    if (conversationId == null || conversationId.isEmpty) {
      Get.toNamed(ScreensUrls.communicationScreenUrl);
      return;
    }

    final communicationController = Get.put(CommunicationController());
    final profileController = Get.find<ProfileController>();

    final directMessageIndex = communicationController.directMessages
        .indexWhere((chat) => chat.id == conversationId);

    if (directMessageIndex != -1) {
      final chatRoom =
          communicationController.directMessages[directMessageIndex];

      Get.toNamed(
        ScreensUrls.conversationScreenUrl,
        arguments: {
          'roomId': chatRoom.rocketChatId,
          'roomName': chatRoom.name,
          'schoolId': chatRoom.schoolId,
        },
      );
      return;
    }

    final groupMessageIndex = communicationController.groups.indexWhere(
      (chat) => chat.id == conversationId,
    );

    if (groupMessageIndex != -1) {
      final chatRoom = communicationController.groups[groupMessageIndex];

      Get.toNamed(
        ScreensUrls.conversationScreenUrl,
        arguments: {
          'roomId': chatRoom.rocketChatId,
          'roomName': chatRoom.name,
          'schoolId': chatRoom.schoolId,
        },
      );
      return;
    }

    final schoolId = Get.find<GlobalController>().isTeacher
        ? profileController.user.value?.teacher?.schoolId
        : (profileController.user.value?.student?.schoolId ??
              profileController.user.value?.parent?.schoolId);

    if (schoolId != null) {
      Get.toNamed(
        ScreensUrls.conversationScreenUrl,
        arguments: {
          'roomId': conversationId,
          'roomName': notification.title?.split('من').last.trim() ?? 'محادثة',
          'schoolId': schoolId,
        },
      );
      return;
    }

    dprint(
      '❌ Could not determine school ID, falling back to communication screen',
    );
    Get.toNamed(ScreensUrls.communicationScreenUrl);
  } catch (e) {
    dprint('❌ Error handling chat_message notification: $e');
    Get.toNamed(ScreensUrls.communicationScreenUrl);
  }
}

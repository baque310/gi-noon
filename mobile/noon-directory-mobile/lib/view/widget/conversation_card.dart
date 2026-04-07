import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_assets.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/screens_urls.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:noon/models/chat_room_data.dart';
import 'package:noon/models/chat_room_member.dart';

class ConversationCard extends StatelessWidget {
  ConversationCard({super.key, required this.data});

  final ChatRoomData data;
  final _globalController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    dprint(data);

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: getDynamicHeight(6),
        horizontal: getDynamicWidth(16),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Get.toNamed(
              ScreensUrls.conversationScreenUrl,
              arguments: {
                'roomId': data.rocketChatId,
                'roomName': data.name,
                'schoolId': data.schoolId,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Right profile picture and badge
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(
                          0xFFF1F5F9,
                        ), // Light grayish background
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.icProfile,
                          width: 32,
                          height: 32,
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF94A3B8),
                            BlendMode.srcIn,
                          ),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    if (data.unreadCount > 0)
                      PositionedDirectional(
                        top: -6,
                        end: -6,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            data.unreadCount.toString(),
                            style: AppTextStyles.semiBold10.copyWith(
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),

                // Middle text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        _chatName,
                        style: AppTextStyles.bold16.copyWith(
                          color: const Color(0xFF1E293B), // Slate 800
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        data.lastMessageText ?? '',
                        style: AppTextStyles.medium12.copyWith(
                          color: const Color(0xFF64748B), // Slate 500
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                // Left time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(data.lastMessage?.createdAt),
                      style: AppTextStyles.medium12.copyWith(
                        color: data.unreadCount > 0
                            ? AppColors.primary
                            : const Color(0xFF94A3B8), // Slate 400
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? date) {
    if (date == null) return '';
    final d = date.add(const Duration(hours: 3));
    final now = DateTime.now().add(const Duration(hours: 3));
    final diff = now.difference(d);

    if (diff.inMinutes < 2) return 'الآن';
    if (d.isToday) return d.formatDateTimeWithAmPm;
    if (d.isYesterday) return AppLanguage.yesterdayStr.tr;
    if (now.difference(d).inDays < 7) {
      switch (d.weekday) {
        case 1:
          return 'الاثنين';
        case 2:
          return 'الثلاثاء';
        case 3:
          return 'الأربعاء';
        case 4:
          return 'الخميس';
        case 5:
          return 'الجمعة';
        case 6:
          return 'السبت';
        case 7:
          return 'الأحد';
      }
    }
    return d.formatDateTimeWithAmPm;
  }

  String get _chatName {
    if (data.isGroup) return data.name;

    final members = data.chatRoomMember.toList();
    if (members.isEmpty) return data.name;

    final myId = _globalController.userId;
    ChatRoomMember? otherMember;

    if (_globalController.isTeacher) {
      try {
        otherMember = members.firstWhere((m) => m.userType != 'TEACHER');
      } catch (_) {}
      if (otherMember == null) {
        try {
          otherMember = members.firstWhere((m) => m.userId != myId);
        } catch (_) {}
      }
    } else if (_globalController.isStudent || _globalController.isParent) {
      try {
        otherMember = members.firstWhere((m) => m.userType == 'TEACHER');
      } catch (_) {}
      if (otherMember == null) {
        try {
          otherMember = members.firstWhere((m) => m.userType == 'ADMIN');
        } catch (_) {}
      }
      if (otherMember == null) {
        try {
          otherMember = members.firstWhere((m) => m.userId != myId);
        } catch (_) {}
      }
    } else {
      try {
        otherMember = members.firstWhere((m) => m.userId != myId);
      } catch (_) {}
    }

    return otherMember?.memberName ?? data.name;
  }
}

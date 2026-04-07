import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/screen/communications/section_students_page.dart';
import 'package:noon/view/screen/communications/teaching_staff_page.dart';
import 'package:noon/view/widget/conversation_card.dart';
import 'package:noon/view/widget/no_data_widget.dart';

class DirectMessages extends StatelessWidget {
  DirectMessages({super.key});

  final _controller = Get.find<CommunicationController>();
  final _gController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.bottomSheet(
          backgroundColor: AppColors.neutralBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: .vertical(top: .circular(20)),
          ),
          _gController.isTeacher
              ? SectionStudentsPage(comController: _controller)
              : TeachingStaffPage(comController: _controller),
        ),
        backgroundColor: AppColors.mainColor,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => _gController.isTeacher
            ? Column(
                children: [
                  InkWell(
                    onTap: () => _controller.createDirectMsgChatWithAdmin(),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.neutralWhite,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.mainColor.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainColor.withValues(alpha: 0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.mainColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.admin_panel_settings,
                              color: AppColors.mainColor,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLanguage.schoolAdministration.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  AppLanguage.chatWithAdminSubtitle.tr,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColors.neutralMidGrey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.push_pin,
                            color: AppColors.mainColor,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: _controller.directMessages.isEmpty
                        ? NoDataWidget(title: AppLanguage.noConversations.tr)
                        : ListView.builder(
                            itemBuilder: (_, i) => ConversationCard(
                              data: _controller.directMessages[i],
                            ),
                            itemCount: _controller.directMessages.length,
                          ),
                  ),
                ],
              )
            : _controller.directMessages.isEmpty
            ? NoDataWidget(title: AppLanguage.noConversations.tr)
            : ListView.builder(
                itemBuilder: (_, i) =>
                    ConversationCard(data: _controller.directMessages[i]),
                itemCount: _controller.directMessages.length,
              ),
      ),
    );
  }
}

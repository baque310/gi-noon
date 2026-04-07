import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/communication_controller.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/view/widget/no_data_widget.dart';
import 'package:noon/view/widget/conversation_card.dart';

class GroupsPage extends StatelessWidget {
  GroupsPage({super.key});

  final controller = Get.find<CommunicationController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.groups.isEmpty
          ? NoDataWidget(title: AppLanguage.noGroups.tr)
          : ListView.builder(
              itemBuilder: (_, i) =>
                  ConversationCard(data: controller.groups[i]),
              itemCount: controller.groups.length,
            ),
    );
  }
}

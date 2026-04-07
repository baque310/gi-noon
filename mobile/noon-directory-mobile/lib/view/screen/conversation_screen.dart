import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/conversation_controller.dart';
import 'package:noon/controllers/global_controller.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/extensions/date_extension.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/models/message_model.dart';
import 'package:noon/view/widget/alert_dialogs.dart';
import 'package:noon/view/widget/custom_appbar.dart';
import 'package:noon/view/widget/loading.dart';

class ConversationScreen extends StatelessWidget {
  ConversationScreen({super.key});

  final controller = Get.find<ConversationController>();
  final gController = Get.find<GlobalController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        appBarName: Get.arguments['roomName'],
        isLeading: true,
      ),
      body: Column(
        children: [
          controller.obx(
            (messages) {
              return Expanded(
                child: ListView.separated(
                  controller: controller.scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 20,
                  ),
                  itemBuilder: (_, i) {
                    return Column(
                      spacing: 4,
                      children: [
                        if (i == 0 ||
                            _isCurrentDateAfterPrevious(
                              messages![i].createdAt,
                              messages[i - 1].createdAt,
                            ))
                          Text(
                            messages![i].createdAt
                                .toLocal()
                                .formatDateToYearMonthDay,
                            style: AppTextStyles.textSemiBold12.copyWith(
                              color: AppColors.black87Color,
                            ),
                          ),
                        MessageBubble(
                          message: messages[i],
                          isSentByMe: _isSentByMe(messages[i].senderId),
                        ),
                      ],
                    );
                  },
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemCount: messages?.length ?? 0,
                ),
              );
            },
            onLoading: const Expanded(child: Center(child: Loading())),
            // onError: (e) => ErrorMessage(
            //   press: controller.fetchConversationMessages,
            //   errorMsg: e,
            // ),
          ),
          const SendMessageBox(),
        ],
      ),
    );
  }

  bool _isSentByMe(String senderId) => gController.userId == senderId;

  bool _isCurrentDateAfterPrevious(DateTime current, DateTime previous) {
    return current.day > previous.day ||
        current.month > previous.month ||
        current.year > previous.year;
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isSentByMe,
  });

  final MessageModel message;
  final bool isSentByMe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => deleteMessage(context),
      child: Align(
        alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSentByMe ? AppColors.mainColor : AppColors.gray300Color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 2,
            children: [
              Text(
                message.text,
                style: AppTextStyles.textMedium12.copyWith(
                  color: isSentByMe ? Colors.white : Colors.black87,
                ),
              ),
              Row(
                spacing: 4,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.createdAt.toLocal().formatDateTime,
                    style: AppTextStyles.textRegular10.copyWith(
                      color: isSentByMe
                          ? AppColors.gray200Color
                          : AppColors.black60Color,
                    ),
                  ),
                  if (!isSentByMe)
                    Flexible(
                      child: Text(
                        message.senderName,
                        style: AppTextStyles.textRegular10.copyWith(
                          color: isSentByMe
                              ? AppColors.gray200Color
                              : AppColors.black60Color,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteMessage(BuildContext context) async {
    if (!isSentByMe) {
      return;
    }

    final confirmed = await showAlertDialog(
      title: AppLanguage.notify.tr,
      content: AppLanguage.deleteMsgDesc.tr,
      cancelActionText: AppLanguage.cancel.tr,
      defaultActionText: AppLanguage.deleteStr.tr,
    );
    if (confirmed == true) {
      // Implement delete message functionality here
      final controller = Get.find<ConversationController>();
      controller.deleteMessage(message.id);
    }
  }
}

class SendMessageBox extends StatefulWidget {
  const SendMessageBox({super.key});

  @override
  State<SendMessageBox> createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  final messageController = TextEditingController();

  final controller = Get.find<ConversationController>();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: TextField(
        controller: messageController,
        decoration: InputDecoration(
          hintText: AppLanguage.typeYourMessage.tr,
          suffixIcon: IconButton(
            icon: Icon(
              Icons.send,
              color: messageController.text.trim().isNotEmpty
                  ? AppColors.mainColor
                  : AppColors.gray500Color,
            ),
            onPressed: () {
              if (messageController.text.trim().isNotEmpty) {
                // Implement send message functionality here
                controller.sendMessage(messageController.text.trim());
                setState(() => messageController.clear());
              }
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.gray200Color,
        ),
        onChanged: (_) => setState(() {}),
      ),
    );
  }
}

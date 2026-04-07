import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/conversation_controller.dart';

import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/localization/language.dart';
import 'package:noon/core/print_value.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:s_extensions/s_extensions.dart';

class SendMessageBox extends StatefulWidget {
  const SendMessageBox({super.key});

  @override
  State<SendMessageBox> createState() => _SendMessageBoxState();
}

class _SendMessageBoxState extends State<SendMessageBox> {
  final messageController = TextEditingController();
  final controller = Get.find<ConversationController>();
  final audioRecorder = AudioRecorder();

  bool isRecording = false;
  int _recordDuration = 0;
  Timer? _timer;

  @override
  void dispose() {
    messageController.dispose();
    audioRecorder.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path =
            '${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await audioRecorder.start(const RecordConfig(), path: path);

        setState(() {
          isRecording = true;
          _recordDuration = 0;
        });

        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          setState(() {
            _recordDuration++;
          });
        });
      }
    } catch (e) {
      dprint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await audioRecorder.stop();
      _timer?.cancel();

      setState(() {
        isRecording = false;
      });

      if (path != null) {
        // Send audio
        controller.sendAudioMessage(path, _recordDuration.toDouble());
      }
    } catch (e) {
      dprint('Error stopping recording: $e');
    }
  }

  Future<void> _cancelRecording() async {
    try {
      await audioRecorder.stop();
      _timer?.cancel();
      setState(() {
        isRecording = false;
        _recordDuration = 0;
      });
    } catch (e) {
      dprint('Error cancelling recording: $e');
    }
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.neutralWhite,
        borderRadius: .vertical(top: .circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Obx(
        () => Column(
          children: [
            if (controller.pickedFiles.isNotEmpty && !isRecording) ...[
              ...(controller.pickedFiles.length <= 3
                      ? controller.pickedFiles
                      : controller.pickedFiles.sublist(
                          controller.pickedFiles.length - 3,
                        ))
                  .wrapWith(
                    (file) => Padding(
                      padding: const .only(bottom: 8.0),
                      child:
                          Row(
                            children: [
                              Icon(
                                Icons.file_upload_rounded,
                                color: AppColors.mainColor,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                file.path.split('/').last,
                                maxLines: 1,
                                overflow: .ellipsis,
                              ).expanded(),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => controller.removeFile(file),
                              ),
                            ],
                          ).decoration(
                            borderRadius: .circular(12),
                            color: AppColors.neutralLightGrey.withValues(
                              alpha: 0.6,
                            ),
                          ),
                    ),
                  ),
              const SizedBox(height: 8),
            ],

            if (isRecording)
              Row(
                children: [
                  IconButton(
                    onPressed: _cancelRecording,
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                  const SizedBox(width: 8),

                  // Recording Indicator & Timer
                  Expanded(
                    child: Container(
                      padding: const .symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: AppColors.gray200Color,
                        borderRadius: .circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.fiber_manual_record,
                            color: Colors.red,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDuration(_recordDuration),
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "Tap button to send",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Stop/Send Button
                  InkWell(
                    onTap: _stopRecording,
                    child: Container(
                      padding: .all(12),
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: .circle,
                      ),
                      child: Center(
                        child: Icon(
                          Icons
                              .send, // Or a Stop icon? User said "red and a stop sign" then "tap again to send". A send icon on red bg seems appropriate for "Tap to Send".
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => Get.bottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      backgroundColor: AppColors.neutralWhite,
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            spacing: 8,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: const Icon(Icons.photo_library),
                                title: Text(AppLanguage.galleryStr.tr),
                                onTap: () => controller.pickImages(),
                              ).decoration(
                                color: AppColors.gray200Color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              ListTile(
                                leading: const Icon(Icons.photo_album),
                                title: Text(AppLanguage.libraryStr.tr),
                                onTap: () => controller.pickFiles(),
                              ).decoration(
                                color: AppColors.gray200Color,
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF1F5F9),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.attach_file_rounded,
                          color: Color(0xFF64748B),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Directionality(
                      textDirection: Get.locale?.languageCode == 'ar'
                          ? TextDirection.rtl
                          : TextDirection.ltr,
                      child: TextField(
                        controller: messageController,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: AppLanguage.typeYourMessage.tr,
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          suffixIcon: IconButton(
                            icon: const Icon(
                              Icons.sentiment_satisfied_rounded,
                              color: Color(0xFF64748B),
                            ),
                            onPressed: () {},
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF1F5F9),
                        ),
                        onChanged: (value) => setState(() {}),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  (messageController.text.trim().isNotEmpty ||
                          controller.pickedFiles.isNotEmpty)
                      ? InkWell(
                          onTap: () {
                            controller.sendMessage(
                              messageController.text.trim(),
                            );
                            setState(() => messageController.clear());
                          },
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: _startRecording,
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.settings_voice_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget boxButton({
    required String icon,
    required Color iconColor,
    required Color backColor,
    required void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        padding: const .all(12),
        decoration: BoxDecoration(color: backColor, shape: .circle),
        child: SvgPicture.asset(
          icon,
          colorFilter: .mode(iconColor, .srcIn),
          width: 24,
          height: 24,
        ),
      ),
    );
  }
}

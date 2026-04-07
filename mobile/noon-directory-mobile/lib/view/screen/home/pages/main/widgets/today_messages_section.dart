import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/communication_controller.dart';

import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/screens_urls.dart';

class TodayMessagesSection extends StatefulWidget {
  const TodayMessagesSection({super.key});

  @override
  State<TodayMessagesSection> createState() => _TodayMessagesSectionState();
}

class _TodayMessagesSectionState extends State<TodayMessagesSection> {
  final _communicationController = Get.put(CommunicationController());
  bool _isLoading = true;
  List<Map<String, dynamic>> _todaysMessages = [];

  @override
  void initState() {
    super.initState();
    _fetchTodayMessages();
  }

  Future<void> _fetchTodayMessages() async {
    try {
      final messages = await _communicationController.getTodayMessages();

      if (mounted) {
        setState(() {
          _todaysMessages = messages;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'رسائل اليوم',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xff2A3336),
          ),
        ),
        SizedBox(height: getDynamicHeight(12)),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_todaysMessages.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'لا توجد رسائل اليوم',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7A7A7A),
                ),
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _todaysMessages.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: getDynamicHeight(10)),
            itemBuilder: (context, index) {
              final msg = _todaysMessages[index];
              final roomName = msg['roomName'] ?? '';
              final senderName = msg['senderName'] ?? '';
              final formattedTime = msg['time'] ?? '';
              final lastMessage = msg['lastMessage'] ?? '';

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Get.toNamed(ScreensUrls.communicationScreenUrl);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // أيقونة المرسل
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // تفاصيل الرسالة
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // اسم المرسل + الوقت
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      senderName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff2A3336),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time_rounded,
                                        size: 13,
                                        color: Color(0xff9E9E9E),
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        formattedTime,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Color(0xff9E9E9E),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // اسم الغرفة (فقط إذا كان مختلفاً عن اسم المرسل لتجنب التكرار)
                              if (roomName.isNotEmpty && roomName != senderName)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    roomName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              // نص الرسالة مع نقاط اقتطاع
                              Text(
                                lastMessage,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xff6B7280),
                                  fontWeight: FontWeight.w400,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

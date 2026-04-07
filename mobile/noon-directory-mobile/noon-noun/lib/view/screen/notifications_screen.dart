import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/api_services.dart';
import '../../core/constant/api_urls.dart';
import '../../core/constant/app_colors.dart';
import '../../core/constant/app_text_style.dart';
import '../../core/constant/app_strings.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  bool isLoading = true;
  List<dynamic> notifications = [];
  List<String> readList = [];

  @override
  void initState() {
    super.initState();
    _loadReadList();
    _fetchNotifications();
  }

  void _loadReadList() {
    var box = Hive.box(AppStrings.boxKey);
    readList = box.get('read_notifications', defaultValue: <String>[])!.cast<String>();
  }

  void _markAsRead(String id) {
    if (!readList.contains(id)) {
      setState(() {
        readList.add(id);
      });
      var box = Hive.box(AppStrings.boxKey);
      box.put('read_notifications', readList);
    }
  }

  Future<void> _fetchNotifications() async {
    try {
      final response = await ApiService().get(url: ApiUrls.notificationsUrl);
      if (response.data != null && response.data is List) {
        setState(() {
          // Sort by newest first
          notifications = response.data;
          notifications.sort((a, b) {
            DateTime da = DateTime.tryParse(a['createdAt'] ?? '') ?? DateTime.now();
            DateTime db = DateTime.tryParse(b['createdAt'] ?? '') ?? DateTime.now();
            return db.compareTo(da);
          });
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // Groups notifications by a localized date string (e.g. YYYY-MM-DD)
  Map<String, List<dynamic>> _groupNotificationsByDate(List<dynamic> notifs) {
    Map<String, List<dynamic>> grouped = {};
    for (var item in notifs) {
      DateTime date = DateTime.tryParse(item['createdAt'] ?? '') ?? DateTime.now();
      String dateKey = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(item);
    }
    return grouped;
  }

  void _showNotificationDialog(dynamic item) {
    _markAsRead(item['id'].toString());
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(item['title'] ?? 'إشعار', textAlign: TextAlign.center, style: AppTextStyles.bold16),
        content: Text(
          item['body'] ?? '',
          style: AppTextStyles.regular14.copyWith(height: 1.6),
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () => Get.back(),
              child: Text('إغلاق', style: AppTextStyles.bold14.copyWith(color: AppColors.primary)),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedNotifications = _groupNotificationsByDate(notifications);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87, size: 20),
            onPressed: () => Get.back(),
          ),
          title: Text(
            'الاشعارات',
            style: AppTextStyles.bold18.copyWith(color: Colors.black87),
          ),
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined, size: 80, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        Text('لا توجد إشعارات حالياً', style: AppTextStyles.bold16.copyWith(color: Colors.grey)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    itemCount: groupedNotifications.keys.length,
                    itemBuilder: (context, index) {
                      String dateKey = groupedNotifications.keys.elementAt(index);
                      List<dynamic> items = groupedNotifications[dateKey]!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: Text(dateKey, style: AppTextStyles.bold14.copyWith(color: Colors.grey.shade600)),
                          ),
                          ...items.map((item) {
                            bool isRead = readList.contains(item['id'].toString());
                            return GestureDetector(
                              onTap: () => _showNotificationDialog(item),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.shade200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Red Dot for Unread
                                    Column(
                                      children: [
                                        const SizedBox(height: 8),
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: isRead ? Colors.transparent : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    // Texts
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  item['title'] ?? 'إشعار جديد',
                                                  style: AppTextStyles.bold14.copyWith(color: Colors.black87),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Purple / Orange generic icon
                                              Container(
                                                padding: const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Colors.deepPurple.shade50,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.info_outline, color: Colors.deepPurple.shade300, size: 18),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            item['body'] ?? '',
                                            style: AppTextStyles.regular12.copyWith(color: Colors.grey.shade600, height: 1.5),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      );
                    },
                  ),
      ),
    );
  }
}

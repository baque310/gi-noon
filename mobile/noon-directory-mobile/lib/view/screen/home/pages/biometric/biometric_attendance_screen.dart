import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/biometric_attendance_controller.dart';
import 'package:noon/core/constant/app_colors.dart';

class BiometricAttendanceScreen extends StatelessWidget {
  BiometricAttendanceScreen({super.key});

  final controller = Get.put(BiometricAttendanceController());

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC), // Ultra light background
        body: SafeArea(
          child: Obx(() {
            if (controller.loading.value && controller.studentName.value.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            return RefreshIndicator(
              onRefresh: () => controller.fetchBiometricAttendance(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Custom App Bar
                    _buildCustomHeader(context),
                    const SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          // Student Card
                          _buildStudentCard(),
                          const SizedBox(height: 16),

                          // Balance Card
                          _buildBalanceCard(),
                          const SizedBox(height: 24),

                          // Today's Activity
                          _buildTodayCard(),
                          const SizedBox(height: 24),

                          // History
                          _buildHistorySection(),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // leading (Right in RTL) -> Back button and possibly avatar
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.04),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black87),
                ),
              ),
              const SizedBox(width: 12),
              _buildAvatarThumbnail(),
            ],
          ),
          // Center Title
          const Text(
            'سجل البصمة',
            style: TextStyle(
              color: Color(0xFF6735DC), // Purple color
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          // trailing (Left in RTL) -> Calendar icon
          GestureDetector(
            onTap: () => _pickDate(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.calendar_today_outlined, color: Colors.black87, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarThumbnail() {
    return Obx(() {
      final biometricPhoto = controller.biometricPhoto.value;
      final studentPhoto = controller.studentPhoto.value;
      final imageUrl = biometricPhoto ?? studentPhoto;

      return Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: (imageUrl != null && imageUrl.isNotEmpty)
              ? Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _defaultAvatarTiny())
              : _defaultAvatarTiny(),
        ),
      );
    });
  }

  Widget _defaultAvatarTiny() {
    return Container(
      color: AppColors.primary.withValues(alpha: 0.1),
      child: const Icon(Icons.person, color: AppColors.primary, size: 20),
    );
  }

  Widget _buildStudentCard() {
    return Obx(() {
      final name = controller.studentName.value;
      if (name.isEmpty) {
        return const SizedBox();
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EFFF), // Very light purple
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.badge, color: Color(0xFF6735DC), size: 32),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E2128),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Text(
                        'ID: #${controller.biometricEnrollId.value ?? "---"}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8A8D9F),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EFFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${controller.stageName.value} - ${controller.sectionName.value}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF6735DC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildBalanceCard() {
    return Obx(() {
      final allowed = controller.allowedAbsences.value;
      final used = controller.usedAbsences.value;
      final remaining = controller.remainingBalance.value;

      double progress = 0;
      if (allowed > 0) {
        progress = remaining / allowed;
      }

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F9F5), // Ultra light teal
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00C896).withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الرصيد المتبقي للغياب',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF006B56), // Dark teal
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      // Used
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المستخدم',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF006B56),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            used.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF003D31), // Very dark teal
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 32),
                      // Allowed
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'المسموح',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF006B56),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            allowed.toString().padLeft(2, '0'),
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF003D31),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // The Circle
            SizedBox(
              width: 90,
              height: 90,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 9,
                    backgroundColor: const Color(0xFFBBEEDF).withValues(alpha: 0.6), // background circle
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00897B)), // primary circle progress
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          remaining.toString(),
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF003D31),
                            height: 1.1,
                          ),
                        ),
                        const Text(
                          'يوم',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF006B56),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildTodayCard() {
    return Obx(() {
      final record = controller.todayRecord.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 4, bottom: 12),
            child: Text(
              'سجل اليوم',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Color(0xFF494D5A),
              ),
            ),
          ),
          Row(
            children: [
              // Check In
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EFFF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.login_rounded, color: Color(0xFF6735DC), size: 26),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'وقت الدخول',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF494D5A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        record?['checkIn'] ?? '--:--',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Check Out
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFBFBFB), // Very slight grey
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.black.withValues(alpha: 0.03)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F2F6),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.logout_rounded, color: Color(0xFF8A8D9F), size: 26),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'وقت الخروج',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF8A8D9F),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        record?['checkOut'] ?? '--:--',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF8A8D9F),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }

  Widget _buildHistorySection() {
    return Obx(() {
      final records = controller.historyRecords;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 4, left: 4, bottom: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'سجلات سابقة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF494D5A),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to full history if needed
                  },
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF6735DC),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (records.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 1.5, style: BorderStyle.none),
              ),
              child: Stack(
                children: [
                   // Pseudo-dashed border using a custom layout or just soft styling
                   Positioned.fill(
                     child: Container(
                       decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: Colors.black.withValues(alpha: 0.08), width: 2),
                       ),
                     ),
                   ),
                   Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F2F6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.fingerprint_rounded, color: Color(0xFFB1B6C4), size: 40),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد سجلات سابقة',
                            style: TextStyle(
                              color: Color(0xFF1E2128),
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'بمجرد تسجيل الحضور أو الانصراف\nسيظهر السجل هنا',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF8A8D9F),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                   )
                ]
              )
            )
          else
            ...records.map((record) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildHistoryItem(record),
                )),
        ],
      );
    });
  }

  Widget _buildHistoryItem(Map<String, dynamic> record) {
    final status = record['status'] as String?;
    Color statusColor;
    String statusLabel;

    switch (status) {
      case 'Present':
        statusColor = const Color(0xFF00C896);
        statusLabel = 'حاضر';
        break;
      case 'Absent':
        statusColor = const Color(0xFFEE6055);
        statusLabel = 'غائب';
        break;
      case 'Late':
        statusColor = const Color(0xFFFF8811);
        statusLabel = 'متأخر';
        break;
      default:
        statusColor = const Color(0xFF8A8D9F);
        statusLabel = 'غير محدد';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Date
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getDayFromDate(record['date'] ?? ''),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                    height: 1,
                  ),
                ),
                Text(
                  _getMonthFromDate(record['date'] ?? ''),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Times
          Expanded(
            child: Row(
              children: [
                const Icon(Icons.login_rounded, color: Color(0xFFB1B6C4), size: 16),
                const SizedBox(width: 4),
                Text(
                  record['checkIn'] ?? '--:--',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: Color(0xFF1E2128),
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.logout_rounded, color: Color(0xFFB1B6C4), size: 16),
                const SizedBox(width: 4),
                Text(
                  record['checkOut'] ?? '--:--',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'monospace',
                    color: Color(0xFF1E2128),
                  ),
                ),
              ],
            ),
          ),
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w900,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      controller.changeDate(picked);
    }
  }

  String _getDayFromDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      return parts.length >= 3 ? parts[2] : '';
    } catch (_) {
      return '';
    }
  }

  String _getMonthFromDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      if (parts.length < 2) return '';
      final months = [
        'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
      ];
      final month = int.tryParse(parts[1]) ?? 1;
      return months[month - 1];
    } catch (_) {
      return '';
    }
  }
}

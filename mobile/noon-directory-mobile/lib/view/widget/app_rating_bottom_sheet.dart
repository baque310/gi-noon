import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/view/widget/loading.dart';
import 'package:noon/view/widget/simple_button.dart';

class AppRatingBottomSheet extends StatefulWidget {
  const AppRatingBottomSheet({super.key});

  @override
  State<AppRatingBottomSheet> createState() => _AppRatingBottomSheetState();
}

class _AppRatingBottomSheetState extends State<AppRatingBottomSheet> {
  int _rating = 0;
  final TextEditingController _notesController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRating() async {
    if (_rating == 0) {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار التقييم أولاً',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final apiService = ApiService();
      final response = await apiService.post(
        url: ApiUrls.createAppRating,
        body: {'rating': _rating, 'notes': _notesController.text},
      );
      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          'نجاح',
          'تم إرسال تقييمك بنجاح، شكراً لك!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'خطأ',
          'حدث خطأ أثناء إرسال التقييم',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء الاتصال بالخادم',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'تقييم التطبيق',
              style: AppTextStyles.bold18.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 8),
            Text(
              'ما هو تقييمك لتجربتك معنا؟',
              style: AppTextStyles.regular14.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  icon: Icon(
                    index < _rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: index < _rating ? Colors.amber : Colors.grey[300],
                    size: 40,
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'ملاحظاتك ومقترحاتك للتحسين...',
                hintStyle: AppTextStyles.regular12.copyWith(
                  color: Colors.grey[400],
                ),
                filled: true,
                fillColor: const Color(0xFFF1F5F9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Loading()
                : SimpleButton(
                    onPressed: _submitRating,
                    label: 'إرسال التقييم',
                    color: AppColors.primary,
                  ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}

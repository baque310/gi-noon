import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/data/api_services.dart';
import 'package:noon/core/print_value.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  List<dynamic> allJobOffers = [];
  List<dynamic> filteredJobOffers = [];
  bool isLoading = true;
  String selectedCategory = 'ALL';

  final List<Map<String, String>> categories = [
    {'key': 'ALL', 'label': 'الكل'},
    {'key': 'INSTITUTE', 'label': 'معاهد تقوية'},
    {'key': 'PHYSICAL_ACTIVITY', 'label': 'أنشطة بدنية'},
    {'key': 'KINDERGARTEN', 'label': 'رياض أطفال'},
    {'key': 'PRIVATE_SCHOOL', 'label': 'مدارس أهلية'},
    {'key': 'TEACHER', 'label': 'أساتذة'},
    {'key': 'LIBRARY', 'label': 'مكتبات'},
    {'key': 'UNIFORM', 'label': 'زي مدرسي'},
    {'key': 'SMART_TOYS', 'label': 'ألعاب ذكاء'},
    {'key': 'HEALTH_DENTAL', 'label': 'أطباء أسنان'},
    {'key': 'HEALTH_PEDIATRIC', 'label': 'دكاترة أطفال'},
    {'key': 'HEALTH_SPECIALIST', 'label': 'أخصائيين'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchJobOffers();
  }

  Future<void> _fetchJobOffers() async {
    try {
      final response = await ApiService().get(url: '/public/job-offer');
      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          allJobOffers = response.data is List ? response.data : [];
          _applyFilter();
          isLoading = false;
        });
      } else {
        Get.snackbar('API Debug', 'Status: ${response.statusCode}, Data is null', backgroundColor: Colors.orange.shade100);
        setState(() => isLoading = false);
      }
    } catch (e) {
      dprint('Job offers fetch error: $e');
      Get.snackbar('API Error Debug', e.toString(), duration: const Duration(seconds: 5), backgroundColor: Colors.red.shade100);
      setState(() => isLoading = false);
    }
  }

  void _applyFilter() {
    if (selectedCategory == 'ALL') {
      filteredJobOffers = List.from(allJobOffers);
    } else {
      filteredJobOffers = allJobOffers
          .where((offer) => offer['category'] == selectedCategory)
          .toList();
    }
  }

  void _selectCategory(String key) {
    setState(() {
      selectedCategory = key;
      _applyFilter();
    });
  }

  String _timeAgo(String? dateStr) {
    if (dateStr == null) return '';
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      if (diff.inDays < 30) return 'منذ ${diff.inDays} يوم';
      return 'منذ ${(diff.inDays / 30).floor()} شهر';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text('الوظائف', style: AppTextStyles.bold18.copyWith(color: AppColors.primary)),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Category filter chips
            _buildCategoryFilter(),
            // Job offers list
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : filteredJobOffers.isEmpty
                      ? _buildEmptyState()
                      : RefreshIndicator(
                          onRefresh: _fetchJobOffers,
                          child: ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                            itemCount: filteredJobOffers.length,
                            itemBuilder: (context, index) => _buildJobCard(filteredJobOffers[index]),
                          ),
                        ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showSubmitForm(),
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  // ===================== CATEGORY FILTER =====================
  Widget _buildCategoryFilter() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: SizedBox(
        height: 45,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final cat = categories[index];
            final isActive = selectedCategory == cat['key'];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: GestureDetector(
                onTap: () => _selectCategory(cat['key']!),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cat['label']!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                        color: isActive ? AppColors.primary : Colors.grey.shade500,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.fastOutSlowIn,
                      height: 3,
                      width: isActive ? 28 : 0, // The line expands to 28 width when active
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ===================== JOB CARD =====================
  Widget _buildJobCard(dynamic offer) {
    final String? logoPath = offer['companyLogo'];
    final String? logoUrl = logoPath != null && logoPath.toString().isNotEmpty
        ? '${ApiUrls.filesUrl}/$logoPath'
        : null;
    final String timeAgo = _timeAgo(offer['createdAt']);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Logo + Company info + Time
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Company logo
              Container(
                width: 58, height: 58,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                  image: logoUrl != null
                      ? DecorationImage(image: NetworkImage(logoUrl), fit: BoxFit.contain)
                      : null,
                ),
                child: logoUrl == null
                    ? Icon(Icons.business_rounded, color: AppColors.primary.withValues(alpha: 0.3), size: 28)
                    : null,
              ),
              const SizedBox(width: 14),
              // Company info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(offer['companyName'] ?? 'بدون اسم', style: AppTextStyles.regular12.copyWith(color: Colors.grey.shade500, fontSize: 11)),
                    const SizedBox(height: 2),
                    Text(offer['jobTitle'] ?? 'غير محدد', style: AppTextStyles.bold14.copyWith(fontSize: 15, color: Colors.black87)),
                    const SizedBox(height: 2),
                    Text(offer['province'] ?? '', style: AppTextStyles.regular12.copyWith(color: Colors.grey.shade400, fontSize: 11)),
                  ],
                ),
              ),
              // Time + bookmark
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.bookmark_outline_rounded, color: Colors.grey.shade400, size: 24),
                  const SizedBox(height: 12),
                  Text(timeAgo, style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                ],
              ),
            ],
          ),

          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: Colors.grey.shade100, height: 1),
          ),

          // Job title repeated as description headline
          if (offer['description'] != null && offer['description'].toString().isNotEmpty)
            Text(
              '- ${offer['description']}',
              style: AppTextStyles.regular12.copyWith(color: Colors.grey.shade700, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),

          // Salary range
          if (offer['salaryRange'] != null && offer['salaryRange'].toString().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              offer['salaryRange'],
              style: AppTextStyles.semiBold12.copyWith(color: AppColors.primary),
            ),
          ] else ...[
            const SizedBox(height: 6),
            Text(
              'عند المقابلة',
              style: AppTextStyles.regular12.copyWith(color: Colors.grey.shade500),
            ),
          ],

          // Contact button
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _showContactDialog(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                padding: const EdgeInsets.symmetric(vertical: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.phone, size: 16),
              label: Text('للتواصل والتقديم', style: AppTextStyles.semiBold12.copyWith(color: AppColors.primary)),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== EMPTY STATE =====================
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_rounded, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('لا توجد وظائف في هذا القسم', style: AppTextStyles.regular14.copyWith(color: Colors.grey.shade500)),
          const SizedBox(height: 8),
          Text('كن أول من يضيف إعلان توظيف!', style: AppTextStyles.regular12.copyWith(color: Colors.grey.shade400)),
        ],
      ),
    );
  }

  // ===================== CONTACT DIALOG =====================
  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Icon(Icons.support_agent, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('تواصل مع إدارة الدليل', style: AppTextStyles.bold16),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'للحصول على معلومات الاتصال بصاحب العمل، يرجى التواصل مع إدارة دليل نون.',
                style: AppTextStyles.regular14.copyWith(color: Colors.grey.shade700, height: 1.6),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.phone, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Text('0770 000 0000', style: AppTextStyles.bold16.copyWith(color: AppColors.primary)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إغلاق', style: TextStyle(color: Colors.grey.shade600)),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== SUBMIT FORM =====================
  void _showSubmitForm() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                  ),
                ),
                const SizedBox(height: 16),
                Text('إضافة إعلان توظيف', style: AppTextStyles.bold18.copyWith(color: AppColors.primary)),
                const SizedBox(height: 6),
                Text('سيظهر إعلانك بعد موافقة الإدارة.', style: AppTextStyles.regular12.copyWith(color: Colors.grey.shade600)),
                const SizedBox(height: 20),
                _buildJobOfferForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final Map<String, TextEditingController> _controllers = {};

  TextEditingController _ctrl(String key) {
    _controllers[key] ??= TextEditingController();
    return _controllers[key]!;
  }

  Widget _buildJobOfferForm() {
    return Column(
      children: [
        _buildTextField(_ctrl('companyName'), 'اسم المدرسة / المعهد / الشركة', Icons.business),
        _buildTextField(_ctrl('jobTitle'), 'المسمى الوظيفي (مثال: معلم رياضيات)', Icons.work),
        _buildTextField(_ctrl('province'), 'المحافظة', Icons.location_on),
        _buildTextField(_ctrl('description'), 'وصف الوظيفة والمتطلبات', Icons.description, maxLines: 3),
        _buildTextField(_ctrl('salaryRange'), 'نطاق الراتب (اختياري)', Icons.monetization_on),
        _buildTextField(_ctrl('contactPhone'), 'رقم الهاتف للتواصل', Icons.phone),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: _submitJobOffer,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            child: Text('إرسال الطلب', style: AppTextStyles.bold16.copyWith(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyles.regular12.copyWith(color: Colors.grey.shade500),
          prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Future<void> _submitJobOffer() async {
    final data = {
      'companyName': _ctrl('companyName').text.trim(),
      'jobTitle': _ctrl('jobTitle').text.trim(),
      'province': _ctrl('province').text.trim(),
      'description': _ctrl('description').text.trim(),
      'salaryRange': _ctrl('salaryRange').text.trim(),
      'contactPhone': _ctrl('contactPhone').text.trim(),
      'category': 'INSTITUTE',
    };

    if (data['companyName']!.isEmpty || data['jobTitle']!.isEmpty || data['province']!.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى ملء الحقول الإلزامية', backgroundColor: Colors.red.shade50, colorText: Colors.red);
      return;
    }

    try {
      await ApiService().post(url: '/public/job-offer', body: data);
      Navigator.pop(context);
      for (var c in _controllers.values) { c.clear(); }
      Get.snackbar('تم الإرسال ✅', 'سيظهر إعلانك بعد موافقة الإدارة', backgroundColor: Colors.green.shade50, colorText: Colors.green.shade800);
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ أثناء الإرسال', backgroundColor: Colors.red.shade50, colorText: Colors.red);
    }
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/guest_home_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/screen/category_listings_screen.dart';
import 'package:noon/view/screen/listing_detail_screen.dart';
import 'package:noon/core/constant/screens_urls.dart';

class GuestHomeScreen extends GetView<GuestHomeController> {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () async {
                  await controller.fetchDirectory();
                  await controller.fetchBanners();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProvinceSelector(context),
                      _buildSearchBar(),
                      const SizedBox(height: 24),
                      Obx(() => _buildCategoriesGrid(context)),
                      const SizedBox(height: 24),
                      _buildBannersSlider(context),
                      const SizedBox(height: 24),
                      _buildCategorySection(context, 'معاهد تقوية', 'نخبة الأساتذة لضمان تفوقك', 'INSTITUTE', controller.filteredInstitutes, Icons.school, Colors.purple),
                      _buildCategorySection(context, 'أنشطة بدنية', 'أندية ومراكز رياضية', 'PHYSICAL_ACTIVITY', controller.filteredPhysicalActivities, Icons.sports_soccer, Colors.green),
                      _buildCategorySection(context, 'رياض الأطفال', 'مؤسسات تعليمية للأطفال', 'KINDERGARTEN', controller.filteredKindergartens, Icons.child_care, Colors.blue),
                      const SizedBox(height: 16),
                      _buildVerticalBannersSlider(context, title: 'إعلانات مميزة 🌟'),
                      const SizedBox(height: 24),
                      _buildCategorySection(context, 'مدارس أهلية', 'أفضل المدارس في منطقتك', 'PRIVATE_SCHOOL', controller.filteredPrivateSchools, Icons.account_balance, Colors.red),
                      _buildCategorySection(context, 'أساتذة', 'أفضل الأساتذة للدروس الخصوصية', 'TEACHER', controller.filteredTeachers, Icons.person, Colors.indigo),
                      _buildCategorySection(context, 'مكتبات', 'كتب ومراجع تعليمية', 'LIBRARY', controller.filteredLibraries, Icons.library_books, Colors.orange),
                      _buildCategorySection(context, 'الزي المدرسي', 'محلات الزي المدرسي', 'UNIFORM', controller.filteredUniforms, Icons.checkroom, Colors.teal),
                      _buildCategorySection(context, 'ألعاب الذكاء', 'ألعاب تعليمية وذكاء', 'SMART_TOYS', controller.filteredSmartToys, Icons.extension, Colors.pink),
                      _buildCategorySection(context, 'أطباء أسنان', 'أطباء أسنان الأطفال', 'HEALTH_DENTAL', controller.filteredHealthDental, Icons.medical_services, Colors.cyan),
                      _buildCategorySection(context, 'دكاترة أطفال', 'أطباء بمختلف الاختصاصات', 'HEALTH_PEDIATRIC', controller.filteredHealthPediatric, Icons.local_hospital, Colors.amber),
                      _buildCategorySection(context, 'أخصائيين', 'أخصائيين صحة', 'HEALTH_SPECIALIST', controller.filteredHealthSpecialist, Icons.health_and_safety, Colors.deepOrange),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    ));
  }

  void _navigateToCategory(BuildContext context, String categoryKey, String categoryLabel) {
    final items = controller.getItemsByCategory(categoryKey);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryListingsScreen(
          categoryLabel: categoryLabel,
          items: items,
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, dynamic item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListingDetailScreen(item: item),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.grey.shade50,
      elevation: 0,
      centerTitle: false,
      title: Text(
        'دليل نون',
        style: AppTextStyles.bold20.copyWith(color: AppColors.primary),
      ),
      actions: [
        Obx(() {
          final count = controller.unreadNotificationsCount.value;
          return Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.primary),
                onPressed: () {
                   Get.toNamed(ScreensUrls.notificationsUrl)?.then((_) => controller.fetchUnreadNotificationsCount());
                },
              ),
              if (count > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      count > 99 ? '99+' : '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          );
        }),
        IconButton(
          icon: const Icon(Icons.info_outline, color: Colors.black54),
          onPressed: () => _showDisclaimer(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _showDisclaimer() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('إخلاء مسؤولية', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
          'دليل نون هو منصة إعلانية فقط ولا يتحمل أي مسؤولية عن جودة الخدمات أو المنتجات المقدمة من قبل المُعلنين. يتحمل المُعلن المسؤولية الكاملة عن صحة المعلومات المنشورة.',
          style: TextStyle(height: 1.6),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('فهمت')),
        ],
      ),
    );
  }

  Widget _buildProvinceSelector(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: () => _showProvinceBottomSheet(context),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on, color: AppColors.primary, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    controller.selectedProvince.value.isEmpty
                        ? 'كل المحافظات (اضغط للاختيار)'
                        : controller.selectedProvince.value,
                    style: AppTextStyles.semiBold14,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
              ],
            ),
          ),
        ));
  }

  void _showProvinceBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10))),
            const SizedBox(height: 16),
            Text('اختر المحافظة', style: AppTextStyles.bold18),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.public, color: AppColors.primary),
              title: Text('كل المحافظات', style: AppTextStyles.semiBold14),
              trailing: controller.selectedProvince.value.isEmpty ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
              onTap: () { controller.setProvince(''); Navigator.pop(ctx); },
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemCount: GuestHomeController.provinces.length,
                itemBuilder: (context, index) {
                  final province = GuestHomeController.provinces[index];
                  return ListTile(
                    leading: const Icon(Icons.location_city, color: Colors.grey),
                    title: Text(province, style: AppTextStyles.regular14),
                    trailing: controller.selectedProvince.value == province ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                    onTap: () { controller.setProvince(province); Navigator.pop(ctx); },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'ابحث عن معهد، مدرسة، طبيب...',
            hintStyle: AppTextStyles.regular14.copyWith(color: Colors.grey.shade500),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          onChanged: (val) => controller.searchQuery.value = val,
        ),
      ),
    );
  }

  Widget _buildBannersSlider(BuildContext context) {
    if (controller.horizontalBanners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 280,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                controller.currentBannerIndex.value = index;
              },
            ),
            items: controller.horizontalBanners.map((banner) {
              final imageUrl = banner['url'] != null ? '${ApiUrls.filesUrl}/${banner['url']}' : '';
              final String bannerTitle = banner['title'] ?? '';
              final String bannerDesc = banner['description'] ?? '';
              final String bannerLocation = banner['link'] ?? '';

              return GestureDetector(
                onTap: () {
                  if (imageUrl.isNotEmpty) _showFullImage(context, imageUrl);
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Image Part
                      Expanded(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                                color: Colors.grey.shade200,
                              ),
                            ),
                            // Heart Icon
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
                              ),
                            ),
                            // Verified Badge
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.verified, color: Colors.grey, size: 14),
                                    const SizedBox(width: 4),
                                    Text('تم التحقق', style: AppTextStyles.semiBold10.copyWith(color: Colors.grey.shade700)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Bottom Text Part
                      if (bannerTitle.isNotEmpty || bannerDesc.isNotEmpty || bannerLocation.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Fake views count
                              Row(
                                children: [
                                  const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text('1.2k عرض', style: AppTextStyles.regular12.copyWith(color: Colors.grey)),
                                ],
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    if (bannerTitle.isNotEmpty)
                                      Text(
                                        bannerTitle,
                                        style: AppTextStyles.bold16.copyWith(color: Colors.black87),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.right,
                                      ),
                                    if (bannerDesc.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              bannerDesc,
                                              style: AppTextStyles.semiBold12.copyWith(color: Colors.grey.shade600),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.layers_outlined, size: 14, color: Colors.grey.shade600),
                                        ],
                                      ),
                                    ],
                                    if (bannerLocation.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              bannerLocation,
                                              style: AppTextStyles.semiBold12.copyWith(color: Colors.grey.shade600),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.horizontalBanners.asMap().entries.map((entry) {
              return Container(
                width: controller.currentBannerIndex.value == entry.key ? 24.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: controller.currentBannerIndex.value == entry.key ? AppColors.primary : Colors.grey.shade300,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.network(imageUrl, fit: BoxFit.contain)),
            Positioned(
              top: 8, right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle), child: const Icon(Icons.close, color: Colors.white, size: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    final categories = [
      {'key': 'INSTITUTE', 'label': 'معاهد تقوية', 'icon': Icons.school, 'bg': Colors.purple.shade100, 'color': Colors.purple, 'count': controller.institutes.length},
      {'key': 'PHYSICAL_ACTIVITY', 'label': 'أنشطة بدنية', 'icon': Icons.sports_soccer, 'bg': Colors.green.shade100, 'color': Colors.green, 'count': controller.physicalActivities.length},
      {'key': 'KINDERGARTEN', 'label': 'رياض أطفال', 'icon': Icons.child_care, 'bg': Colors.blue.shade100, 'color': Colors.blue, 'count': controller.kindergartens.length},
      {'key': 'PRIVATE_SCHOOL', 'label': 'مدارس أهلية', 'icon': Icons.account_balance, 'bg': Colors.red.shade100, 'color': Colors.red, 'count': controller.privateSchools.length},
      {'key': 'TEACHER', 'label': 'أساتذة', 'icon': Icons.person, 'bg': Colors.indigo.shade100, 'color': Colors.indigo, 'count': controller.teachers.length},
      {'key': 'LIBRARY', 'label': 'مكتبات', 'icon': Icons.library_books, 'bg': Colors.orange.shade100, 'color': Colors.orange, 'count': controller.libraries.length},
      {'key': 'UNIFORM', 'label': 'زي مدرسي', 'icon': Icons.checkroom, 'bg': Colors.teal.shade100, 'color': Colors.teal, 'count': controller.uniforms.length},
      {'key': 'SMART_TOYS', 'label': 'ألعاب ذكاء', 'icon': Icons.extension, 'bg': Colors.pink.shade100, 'color': Colors.pink, 'count': controller.smartToys.length},
      {'key': 'HEALTH_DENTAL', 'label': 'أسنان أطفال', 'icon': Icons.medical_services, 'bg': Colors.cyan.shade100, 'color': Colors.cyan, 'count': controller.healthDental.length},
      {'key': 'HEALTH_PEDIATRIC', 'label': 'دكاترة أطفال', 'icon': Icons.local_hospital, 'bg': Colors.amber.shade100, 'color': Colors.amber, 'count': controller.healthPediatric.length},
      {'key': 'HEALTH_SPECIALIST', 'label': 'أخصائيين', 'icon': Icons.health_and_safety, 'bg': Colors.deepOrange.shade100, 'color': Colors.deepOrange, 'count': controller.healthSpecialist.length},
    ];

    final ScrollController scrollController = ScrollController();
    final RxDouble scrollProgress = 0.0.obs;

    scrollController.addListener(() {
      if (scrollController.hasClients) {
        final maxScroll = scrollController.position.maxScrollExtent;
        if (maxScroll > 0) {
          scrollProgress.value = scrollController.offset / maxScroll;
        }
      }
    });

    return Column(
      children: [
        SizedBox(
          height: 220, // Enough height for two rows
          child: SingleChildScrollView(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              direction: Axis.vertical,
              spacing: 16, // vertical spacing between rows
              runSpacing: 20, // horizontal spacing between items
              children: categories.map((cat) {
                final displayCount = controller.getBadgeDisplayCount(cat['key'] as String, cat['count'] as int);
                return GestureDetector(
                  onTap: () {
                    controller.clearCategoryBadge(cat['key'] as String, cat['count'] as int);
                    _navigateToCategory(context, cat['key'] as String, cat['label'] as String);
                  },
                  child: SizedBox(
                    width: 76,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 65, height: 65,
                              decoration: BoxDecoration(
                                color: (cat['bg'] as Color).withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                                border: Border.all(color: (cat['color'] as Color).withValues(alpha: 0.2), width: 1.5),
                              ),
                              child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 28),
                            ),
                            if (displayCount > 0)
                              Positioned(
                                top: -2, right: -2,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 1.5)),
                                  constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                                  child: Text('$displayCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(cat['label'] as String, style: AppTextStyles.semiBold12, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Scroll Indicator
        Obx(() => Container(
          width: 50,
          height: 5,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Stack(
            children: [
              Positioned(
                left: Directionality.of(context) == TextDirection.rtl ? null : scrollProgress.value * (50 - 24),
                right: Directionality.of(context) == TextDirection.rtl ? scrollProgress.value * (50 - 24) : null,
                child: Container(
                  width: 24,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context, String title, String subtitle, String categoryKey, List<dynamic> items, IconData categoryIcon, Color categoryColor) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: AppTextStyles.bold18),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.regular12.copyWith(color: Colors.grey[600])),
              ])),
              GestureDetector(
                onTap: () => _navigateToCategory(context, categoryKey, title),
                child: Text('عرض الكل >', style: AppTextStyles.semiBold12.copyWith(color: AppColors.primary)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length > 5 ? 5 : items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildSmallCard(context, item, categoryColor);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSmallCard(BuildContext context, dynamic item, Color accentColor) {
    final String? logoPath = item['logo'];
    final String? logoUrl = logoPath != null && logoPath.toString().isNotEmpty ? '${ApiUrls.filesUrl}/$logoPath' : null;

    return GestureDetector(
      onTap: () => _navigateToDetail(context, item),
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100, width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                color: accentColor.withValues(alpha: 0.1),
                image: logoUrl != null ? DecorationImage(image: NetworkImage(logoUrl), fit: BoxFit.cover) : null,
              ),
              child: logoUrl == null ? Center(child: Icon(Icons.business, size: 36, color: accentColor.withValues(alpha: 0.4))) : null,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item['name'] ?? '', style: AppTextStyles.semiBold12, maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  if (item['province'] != null)
                    Row(children: [
                      Icon(Icons.location_on, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 2),
                      Expanded(child: Text(item['province'] ?? '', style: AppTextStyles.regular10.copyWith(color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalBannersSlider(BuildContext context, {required String title, bool reversed = false}) {
    if (controller.verticalBanners.isEmpty) return const SizedBox.shrink();

    final ads = reversed ? controller.verticalBanners.reversed.toList() : controller.verticalBanners.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(title, style: AppTextStyles.bold18),
        ),
        const SizedBox(height: 12),
        CarouselSlider(
          options: CarouselOptions(
            height: 380, // Taller vertical height for the card
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction: 0.75, // Show mostly one card, hint of the next
            aspectRatio: 3 / 4, 
          ),
          items: ads.map((banner) {
            final imageUrl = banner['url'] != null ? '${ApiUrls.filesUrl}/${banner['url']}' : '';
            final String bannerTitle = banner['title'] ?? '';
            final String bannerDesc = banner['description'] ?? '';
            final String bannerLocation = banner['link'] ?? '';

            return GestureDetector(
              onTap: () => _showFullImage(context, imageUrl),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Image Part
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                              color: Colors.grey.shade200,
                            ),
                          ),
                          // Heart Icon
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.favorite_border, color: Colors.white, size: 20),
                            ),
                          ),
                          // Verified Badge
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified, color: Colors.grey, size: 14),
                                  const SizedBox(width: 4),
                                  Text('تم التحقق', style: AppTextStyles.semiBold10.copyWith(color: Colors.grey.shade700)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Bottom Text Part
                    if (bannerTitle.isNotEmpty || bannerDesc.isNotEmpty || bannerLocation.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Fake views count
                            Row(
                              children: [
                                const Icon(Icons.remove_red_eye_outlined, size: 16, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text('1.2k عرض', style: AppTextStyles.regular12.copyWith(color: Colors.grey)),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  if (bannerTitle.isNotEmpty)
                                    Text(
                                      bannerTitle,
                                      style: AppTextStyles.bold16.copyWith(color: Colors.black87),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.right,
                                    ),
                                  if (bannerDesc.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            bannerDesc,
                                            style: AppTextStyles.semiBold12.copyWith(color: Colors.grey.shade600),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.layers_outlined, size: 14, color: Colors.grey.shade600),
                                      ],
                                    ),
                                  ],
                                  if (bannerLocation.isNotEmpty) ...[
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            bannerLocation,
                                            style: AppTextStyles.semiBold12.copyWith(color: Colors.grey.shade600),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.right,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(Icons.location_on_outlined, size: 14, color: Colors.grey.shade600),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}


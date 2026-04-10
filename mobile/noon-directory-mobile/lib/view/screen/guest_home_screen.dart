import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/controllers/guest_home_controller.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/screen/category_listings_screen.dart';
import 'package:noon/view/screen/listing_detail_screen.dart';
import 'package:noon/view/screen/story_viewer_screen.dart';

class GuestHomeScreen extends GetView<GuestHomeController> {
  const GuestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: _buildAppBar(),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: controller.fetchDirectory,
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
                      const SizedBox(height: 16),
                      _buildStoriesStrip(context),
                      const SizedBox(height: 24),
                      _buildCategorySection(
                        context,
                        'مدارس أهلية',
                        'أفضل المدارس الأهلية في منطقتك',
                        'PRIVATE_SCHOOL',
                        controller.privateSchools,
                        Icons.school,
                        Colors.red,
                      ),
                      _buildCategorySection(
                        context,
                        'رياض الأطفال',
                        'مؤسسات تعليمية مميزة قريبة من موقعك',
                        'KINDERGARTEN',
                        controller.kindergartens,
                        Icons.child_care,
                        Colors.blue,
                      ),
                      _buildCategorySection(
                        context,
                        'معاهد التقوية',
                        'نخبة الأساتذة لضمان تفوقك الدراسي',
                        'INSTITUTE',
                        controller.institutes,
                        Icons.book,
                        Colors.purple,
                      ),
                      _buildCategorySection(
                        context,
                        'المكتبات',
                        'كتب ومراجع تعليمية',
                        'LIBRARY',
                        controller.libraries,
                        Icons.library_books,
                        Colors.orange,
                      ),
                      _buildCategorySection(
                        context,
                        'الزي المدرسي',
                        'محلات الزي المدرسي',
                        'UNIFORM',
                        controller.uniforms,
                        Icons.checkroom,
                        Colors.teal,
                      ),
                      _buildCategorySection(
                        context,
                        'أساتذة خصوصي',
                        'أفضل الأساتذة للدروس الخصوصية',
                        'TEACHER',
                        controller.teachers,
                        Icons.person,
                        Colors.indigo,
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
      ),
    );
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
        'Noon Academy',
        style: AppTextStyles.bold20.copyWith(color: AppColors.primary),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black87),
          onPressed: () {},
        ),
        const SizedBox(width: 8),
      ],
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
      builder: (ctx) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),
            Text('اختر المحافظة', style: AppTextStyles.bold18),
            const SizedBox(height: 16),
            // All provinces option
            ListTile(
              leading: const Icon(Icons.public, color: AppColors.primary),
              title: Text('كل المحافظات', style: AppTextStyles.semiBold14),
              trailing: controller.selectedProvince.value.isEmpty
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () {
                controller.setProvince('');
                Navigator.pop(ctx);
              },
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
                    trailing: controller.selectedProvince.value == province
                        ? const Icon(Icons.check_circle, color: AppColors.primary)
                        : null,
                    onTap: () {
                      controller.setProvince(province);
                      Navigator.pop(ctx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
            hintText: 'ابحث عن مدرسة، معهد...',
            hintStyle: AppTextStyles.regular14.copyWith(color: Colors.grey.shade500),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: AppColors.primary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildBannersSlider(BuildContext context) {
    if (controller.banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 180,
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              aspectRatio: 16 / 9,
              onPageChanged: (index, reason) {
                controller.currentBannerIndex.value = index;
              },
            ),
            items: controller.banners.map((banner) {
              final imageUrl = banner['url'] != null ? '${ApiUrls.filesUrl}/${banner['url']}' : '';
              return GestureDetector(
                onTap: () => _showFullImage(context, imageUrl),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
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
            children: controller.banners.asMap().entries.map((entry) {
              return Container(
                width: controller.currentBannerIndex.value == entry.key ? 24.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: controller.currentBannerIndex.value == entry.key
                      ? AppColors.primary
                      : Colors.grey.shade300,
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
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(imageUrl, fit: BoxFit.contain),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoriesStrip(BuildContext context) {
    return Obx(() {
      if (controller.stories.isEmpty) return const SizedBox.shrink();
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('ستوريات إعلانية', style: AppTextStyles.bold16),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: controller.stories.length,
              itemBuilder: (context, index) {
                final story = controller.stories[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryViewerScreen(
                          stories: controller.stories.toList(),
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 110,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFE040FB), Color(0xFF7C4DFF), Color(0xFF536DFE)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.purple.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(2.5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.network(
                                  story['thumbnail'] ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.play_circle_fill, size: 36, color: Colors.grey),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.black.withValues(alpha: 0.0), Colors.black.withValues(alpha: 0.4)],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                                const Center(
                                  child: Icon(Icons.play_circle_fill, color: Colors.white, size: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          story['advertiserName'] ?? story['title'] ?? '',
                          style: AppTextStyles.semiBold10,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    final categories = [
      {'key': 'PRIVATE_SCHOOL', 'label': 'مدارس أهلية', 'icon': Icons.school, 'bg': Colors.red.shade100, 'color': Colors.red, 'count': controller.privateSchools.length},
      {'key': 'KINDERGARTEN', 'label': 'رياض أطفال', 'icon': Icons.child_care, 'bg': Colors.blue.shade100, 'color': Colors.blue, 'count': controller.kindergartens.length},
      {'key': 'INSTITUTE', 'label': 'معاهد تدريس', 'icon': Icons.book, 'bg': Colors.purple.shade100, 'color': Colors.purple, 'count': controller.institutes.length},
      {'key': 'LIBRARY', 'label': 'مكتبات', 'icon': Icons.library_books, 'bg': Colors.orange.shade100, 'color': Colors.orange, 'count': controller.libraries.length},
      {'key': 'UNIFORM', 'label': 'زي مدرسي', 'icon': Icons.checkroom, 'bg': Colors.teal.shade100, 'color': Colors.teal, 'count': controller.uniforms.length},
      {'key': 'TEACHER', 'label': 'أساتذة خصوصي', 'icon': Icons.person, 'bg': Colors.indigo.shade100, 'color': Colors.indigo, 'count': controller.teachers.length},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: categories.map((cat) {
          return GestureDetector(
            onTap: () => _navigateToCategory(
              context,
              cat['key'] as String,
              cat['label'] as String,
            ),
            child: SizedBox(
              width: (MediaQuery.of(context).size.width - 56) / 3,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: cat['bg'] as Color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(cat['icon'] as IconData, color: cat['color'] as Color, size: 28),
                      ),
                      if ((cat['count'] as int) > 0)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: cat['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                            constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                            child: Text(
                              '${cat['count']}',
                              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cat['label'] as String,
                    style: AppTextStyles.semiBold12,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }


  Widget _buildCategorySection(
    BuildContext context,
    String title,
    String subtitle,
    String categoryKey,
    RxList<dynamic> items,
    IconData categoryIcon,
    Color categoryColor,
  ) {
    return Obx(() {
      if (items.isEmpty) return const SizedBox.shrink();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.bold18),
                      const SizedBox(height: 4),
                      Text(subtitle, style: AppTextStyles.regular12.copyWith(color: Colors.grey[600])),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _navigateToCategory(context, categoryKey, title),
                  child: Text('عرض الكل >', style: AppTextStyles.semiBold12.copyWith(color: AppColors.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Horizontal list of cards
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
    });
  }

  Widget _buildSmallCard(BuildContext context, dynamic item, Color accentColor) {
    final String? logoPath = item['logo'];
    final String? logoUrl = logoPath != null && logoPath.toString().isNotEmpty
        ? '${ApiUrls.filesUrl}/$logoPath'
        : null;

    return GestureDetector(
      onTap: () => _navigateToDetail(context, item),
      child: Container(
        width: 170,
        margin: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                color: accentColor.withValues(alpha: 0.1),
                image: logoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(logoUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: logoUrl == null
                  ? Center(child: Icon(Icons.business, size: 36, color: accentColor.withValues(alpha: 0.4)))
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'] ?? '',
                    style: AppTextStyles.semiBold12,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  if (item['province'] != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 12, color: Colors.grey.shade400),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            item['province'] ?? '',
                            style: AppTextStyles.regular10.copyWith(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 2),
                      Text(
                        (item['rating'] ?? 5.0).toString(),
                        style: AppTextStyles.semiBold10,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

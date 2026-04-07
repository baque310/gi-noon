import 'package:flutter/material.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/view/screen/listing_detail_screen.dart';

class CategoryListingsScreen extends StatelessWidget {
  final String categoryLabel;
  final List<dynamic> items;

  const CategoryListingsScreen({
    super.key,
    required this.categoryLabel,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          categoryLabel,
          style: AppTextStyles.bold18.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_rounded, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد بيانات حالياً',
                    style: AppTextStyles.semiBold16.copyWith(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'سيتم إضافة محتوى قريباً',
                    style: AppTextStyles.regular14.copyWith(color: Colors.grey.shade400),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildListingCard(context, item);
              },
            ),
    );
  }

  Widget _buildListingCard(BuildContext context, dynamic item) {
    final String? logoPath = item['logo'];
    final String? logoUrl = logoPath != null && logoPath.toString().isNotEmpty
        ? '${ApiUrls.filesUrl}/$logoPath'
        : null;

    final List<dynamic> images = item['images'] ?? [];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ListingDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image / Logo header
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                color: AppColors.primary.withValues(alpha: 0.1),
                image: logoUrl != null
                    ? DecorationImage(
                        image: NetworkImage(logoUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: logoUrl == null
                  ? Center(
                      child: Icon(
                        Icons.business,
                        size: 50,
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    )
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'] ?? '',
                          style: AppTextStyles.bold16,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              (item['rating'] ?? 5.0).toString(),
                              style: AppTextStyles.semiBold12.copyWith(color: Colors.amber.shade800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Province
                  if (item['province'] != null)
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 16, color: AppColors.primary.withValues(alpha: 0.7)),
                        const SizedBox(width: 4),
                        Text(
                          item['province'] ?? '',
                          style: AppTextStyles.regular12.copyWith(color: Colors.grey[600]),
                        ),
                        if (item['address'] != null && item['address'].toString().isNotEmpty) ...[
                          Text(' • ', style: AppTextStyles.regular12.copyWith(color: Colors.grey[400])),
                          Expanded(
                            child: Text(
                              item['address'] ?? '',
                              style: AppTextStyles.regular12.copyWith(color: Colors.grey[600]),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                  if (item['description'] != null && item['description'].toString().isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      item['description'],
                      style: AppTextStyles.regular12.copyWith(
                        color: Colors.grey[500],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Bottom row: phone + gallery count
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (item['phone'] != null && item['phone'].toString().isNotEmpty)
                        Row(
                          children: [
                            Icon(Icons.phone, size: 14, color: Colors.green.shade600),
                            const SizedBox(width: 4),
                            Text(
                              item['phone'],
                              style: AppTextStyles.semiBold12.copyWith(color: Colors.green.shade700),
                            ),
                          ],
                        ),
                      if (images.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.photo_library, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                              Text(
                                '${images.length} صورة',
                                style: AppTextStyles.semiBold10.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'عرض التفاصيل',
                          style: AppTextStyles.semiBold10.copyWith(color: AppColors.primary),
                        ),
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

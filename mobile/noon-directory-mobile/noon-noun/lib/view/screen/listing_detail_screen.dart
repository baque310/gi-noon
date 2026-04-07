import 'package:flutter/material.dart';
import 'package:noon/core/constant/api_urls.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:noon/data/api_services.dart';

class ListingDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;

  const ListingDetailScreen({super.key, required this.item});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {

  @override
  void initState() {
    super.initState();
    _registerView();
  }

  void _registerView() {
    // Calling the endpoint to increment the view count quietly in background
    if (widget.item['id'] != null) {
      ApiService().get(url: '${ApiUrls.directoryListingUrl}/${widget.item['id']}').catchError((_) => null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> item = widget.item;
    final String? logoPath = item['logo'];
    final String? logoUrl = logoPath != null && logoPath.toString().isNotEmpty
        ? '${ApiUrls.filesUrl}/$logoPath'
        : null;
    final List<dynamic> images = item['images'] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 18),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (logoUrl != null)
                    Image.network(
                      logoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        color: AppColors.primary.withValues(alpha: 0.2),
                        child: const Icon(Icons.business, size: 80, color: Colors.white54),
                      ),
                    )
                  else
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: const Icon(Icons.business, size: 80, color: Colors.white54),
                    ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item['name'] ?? '',
                          style: AppTextStyles.bold20.copyWith(color: Colors.black87),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.amber.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              (item['rating'] ?? 5.0).toString(),
                              style: AppTextStyles.bold14.copyWith(color: Colors.amber.shade800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Province + Address
                  if (item['province'] != null)
                    _buildInfoRow(Icons.location_on, item['province'], AppColors.primary),
                  if (item['address'] != null && item['address'].toString().isNotEmpty)
                    _buildInfoRow(Icons.map, item['address'], Colors.grey.shade600),

                  const SizedBox(height: 20),

                  // Description
                  if (item['description'] != null && item['description'].toString().isNotEmpty) ...[
                    Text('نبذة', style: AppTextStyles.bold16),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Text(
                        item['description'],
                        style: AppTextStyles.regular14.copyWith(
                          color: Colors.grey.shade700,
                          height: 1.6,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Contact Info
                  Text('معلومات التواصل', style: AppTextStyles.bold16),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        if (item['phone'] != null && item['phone'].toString().isNotEmpty)
                          _buildContactTile(
                            Icons.phone,
                            'الهاتف',
                            item['phone'],
                            Colors.green,
                            () => _launchUrl('tel:${item['phone']}'),
                          ),
                        if (item['phone2'] != null && item['phone2'].toString().isNotEmpty)
                          _buildContactTile(
                            Icons.phone_android,
                            'هاتف إضافي',
                            item['phone2'],
                            Colors.teal,
                            () => _launchUrl('tel:${item['phone2']}'),
                          ),
                        if (item['email'] != null && item['email'].toString().isNotEmpty)
                          _buildContactTile(
                            Icons.email,
                            'البريد',
                            item['email'],
                            Colors.blue,
                            () => _launchUrl('mailto:${item['email']}'),
                          ),
                        if (item['website'] != null && item['website'].toString().isNotEmpty)
                          _buildContactTile(
                            Icons.language,
                            'الموقع',
                            item['website'],
                            Colors.indigo,
                            () => _launchUrl(item['website']),
                          ),
                        if ((item['phone'] == null || item['phone'].toString().isEmpty) &&
                            (item['email'] == null || item['email'].toString().isEmpty))
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'لا توجد معلومات تواصل',
                              style: AppTextStyles.regular14.copyWith(color: Colors.grey),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // Gallery
                  if (images.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text('معرض الصور', style: AppTextStyles.bold16),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, index) {
                          final imgUrl = '${ApiUrls.filesUrl}/${images[index]['url']}';
                          return GestureDetector(
                            onTap: () => _showFullImage(context, imgUrl),
                            child: Container(
                              width: 250,
                              margin: const EdgeInsets.only(left: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                                image: DecorationImage(
                                  image: NetworkImage(imgUrl),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),

      // Call button at bottom
      bottomNavigationBar: item['phone'] != null && item['phone'].toString().isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => _launchUrl('tel:${item['phone']}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.phone),
                label: Text('اتصل الآن', style: AppTextStyles.bold16.copyWith(color: Colors.white)),
              ),
            )
          : null,
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.regular14.copyWith(color: Colors.grey.shade700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String label, String value, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTextStyles.regular12.copyWith(color: Colors.grey)),
                  Text(value, style: AppTextStyles.semiBold14),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
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
}

import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/models/banner_model.dart';
import 'package:noon/view/widget/images/custom_network_image.dart';

class BannersSection extends StatefulWidget {
  const BannersSection({super.key, required this.banners});

  final List<BannerModel> banners;

  @override
  State<BannersSection> createState() => _BannersSectionState();
}

class _BannersSectionState extends State<BannersSection> {
  int _currentImageIndex = 0;

  final double _aspectRatio = 343 / 160;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      children: [
        CarouselSlider(
          options: CarouselOptions(
            // height: _height,
            animateToClosest: true,
            viewportFraction: 1,
            aspectRatio: _aspectRatio,
            autoPlay: true,
            onPageChanged: (index, reason) =>
                setState(() => _currentImageIndex = index),
          ),
          items: List.generate(
            widget.banners.length,
            (i) => Builder(
              builder: (BuildContext context) {
                final attachment = widget.banners[i];

                return AspectRatio(
                  aspectRatio: _aspectRatio,
                  child: CustomNetworkImage(
                    imageUrl: attachment.url,
                    radius: .circular(14),
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        PagIndicator(
          itemCount: widget.banners.length,
          currentPage: _currentImageIndex,
        ),
      ],
    );
  }
}

class PagIndicator extends StatelessWidget {
  final int itemCount;
  final int currentPage;

  const PagIndicator({
    super.key,
    required this.itemCount,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      children: List.generate(itemCount, (index) {
        bool isSelected = index == currentPage;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          // Adjust the animation duration as needed
          width: isSelected ? 24 : 12,
          // Initial width is 24, becomes 6 if not selected
          height: 4,
          margin: const .symmetric(horizontal: 4),
          // Adjust the spacing as needed
          decoration: BoxDecoration(
            borderRadius: isSelected
                ? .circular(39)
                : .circular(3), // Circle for width 6
            color: isSelected ? AppColors.primary : AppColors.neutralLightGrey,
          ),
        );
      }),
    );
  }
}

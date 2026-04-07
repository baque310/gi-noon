import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:noon/core/constant/app_colors.dart';
import 'package:noon/core/constant/app_sizes.dart';
import 'package:noon/core/constant/app_text_style.dart';
import 'package:noon/core/localization/language.dart';
import 'package:s_extensions/s_extensions.dart';

class AnimatedTabBar extends StatefulWidget {
  final void Function(String itemSelected, int index) onItemSelected;
  final List<String> items;
  final int? selectedItem;

  const AnimatedTabBar({
    super.key,
    required this.onItemSelected,
    this.items = const [],
    this.selectedItem,
  });

  @override
  State<AnimatedTabBar> createState() => _AnimatedTabBarState();
}

class _AnimatedTabBarState extends State<AnimatedTabBar> {
  final ScrollController _scrollController = ScrollController();

  List<String> _daysOfWeekLocalized = [
    AppLanguage.sunday.tr,
    AppLanguage.monday.tr,
    AppLanguage.tuesday.tr,
    AppLanguage.wednesday.tr,
    AppLanguage.thursday.tr,
    AppLanguage.friday.tr,
    AppLanguage.saturday.tr,
  ];

  final Map<String, String> _daysMap = {
    AppLanguage.sunday.tr: 'Sunday',
    AppLanguage.monday.tr: 'Monday',
    AppLanguage.tuesday.tr: 'Tuesday',
    AppLanguage.wednesday.tr: 'Wednesday',
    AppLanguage.thursday.tr: 'Thursday',
    AppLanguage.friday.tr: 'Friday',
    AppLanguage.saturday.tr: 'Saturday',
  };

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    if (widget.items.isNotEmpty) {
      _daysOfWeekLocalized = widget.items;
    }

    if (widget.selectedItem != null &&
        widget.selectedItem! >= 0 &&
        widget.selectedItem! < _daysOfWeekLocalized.length) {
      _selectedIndex = widget.selectedItem!;
    } else {
      final currentDayEnglish = DateTime.now().formatDay;
      final currentDayLocalized = _daysMap.keys.firstWhere(
        (key) => _daysMap[key] == currentDayEnglish,
        orElse: () => AppLanguage.sunday.tr,
      );
      _selectedIndex = _daysOfWeekLocalized.indexOf(currentDayLocalized);
      if (_selectedIndex < 0) _selectedIndex = 0;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDay();
    });
  }

  @override
  void didUpdateWidget(covariant AnimatedTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedItem != null && widget.selectedItem != _selectedIndex) {
      _selectedIndex = widget.selectedItem!.clamp(
        0,
        _daysOfWeekLocalized.length - 1,
      );
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _scrollToSelectedDay(_selectedIndex),
      );
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCurrentDay() {
    if (_scrollController.hasClients) {
      _scrollToSelectedDay(_selectedIndex);
    }
  }

  void _scrollToSelectedDay(int index) {
    if (_scrollController.hasClients) {
      final itemWidth = getDynamicWidth(80);
      final separatorWidth = getDynamicWidth(8);
      final totalItemWidth = itemWidth + separatorWidth;

      final screenWidth = MediaQuery.of(context).size.width;
      final scrollPosition =
          (index * totalItemWidth) - (screenWidth / 2) + (itemWidth / 2);

      final maxScroll = _scrollController.position.maxScrollExtent;
      final targetPosition = scrollPosition.clamp(0.0, maxScroll);

      _scrollController.animateTo(
        targetPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getDynamicHeight(44),
      child: ListView.separated(
        controller: _scrollController,
        scrollDirection: .horizontal,
        itemCount: _daysOfWeekLocalized.length,
        separatorBuilder: (context, index) =>
            SizedBox(width: getDynamicWidth(8)),
        itemBuilder: (context, index) {
          final day = _daysOfWeekLocalized[index];
          final isSelected = index == _selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
              widget.onItemSelected(
                widget.items.isEmpty ? _daysMap[day]!.toUpperCase() : day,
                index,
              );
              _scrollToSelectedDay(index);
            },
            child: Container(
              padding: .symmetric(
                horizontal: getDynamicWidth(16),
                vertical: getDynamicHeight(10),
              ),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.neutralWhite,
                borderRadius: .circular(25),
                border: .all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.neutralLightGrey,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  day,
                  textAlign: .center,
                  style: AppTextStyles.medium14.copyWith(
                    color: isSelected
                        ? AppColors.neutralWhite
                        : AppColors.neutralMidGrey,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

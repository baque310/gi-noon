import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';

class BottomSheetContainer extends StatelessWidget {
  final Widget child;

  const BottomSheetContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        clipBehavior: .antiAlias,
        padding: const .only(left: 16, right: 16, bottom: 24),
        decoration: const BoxDecoration(
          color: AppColors.gray50Color,
          borderRadius: .only(topLeft: .circular(12), topRight: .circular(12)),
        ),
        child: child,
      ),
    );
  }
}

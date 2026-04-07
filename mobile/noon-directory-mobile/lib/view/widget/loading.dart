import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: const Center(
        child: CircularProgressIndicator(color: AppColors.mainColor),
      ),
    );
  }
}

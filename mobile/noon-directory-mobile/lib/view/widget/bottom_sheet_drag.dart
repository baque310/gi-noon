import 'package:flutter/material.dart';
import '../../core/constant/app_colors.dart';

class BottomSheetDragHandle extends StatelessWidget {
  const BottomSheetDragHandle({super.key, this.pb = 24});

  final double pb;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: .only(top: 24, bottom: pb),
        child: SizedBox(
          width: 72,
          height: 6,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.gray500Color,
              shape: BoxShape.rectangle,
              borderRadius: .circular(32),
            ),
          ),
        ),
      ),
    );
  }
}

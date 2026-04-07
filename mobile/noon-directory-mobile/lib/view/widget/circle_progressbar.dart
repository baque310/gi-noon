import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:s_extensions/s_extensions.dart';

class CircleProgressbar extends StatelessWidget {
  final ValueNotifier<double>? notifier;
  final double progress;
  final double maxProgress;
  final double? height, width;
  final Color? color;
  final Widget Function(BuildContext, double, Widget?)? progressBuilder;

  const CircleProgressbar({
    super.key,
    this.notifier,
    required this.progress,
    required this.maxProgress,
    this.height,
    this.width,
    this.color,
    this.progressBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: DashedCircularProgressBar.aspectRatio(
        aspectRatio: 1,
        valueNotifier: notifier,
        progress: progress,
        maxProgress: maxProgress,
        foregroundColor: color ?? Colors.blue,
        backgroundColor: (color ?? Colors.blue).withValues(alpha: 0.3),
        foregroundStrokeWidth: 6.5,
        backgroundStrokeWidth: 6.5,
        animationDuration: 1.sec,
        animation: true,
        child: notifier != null
            ? Center(
                child: ValueListenableBuilder(
                  valueListenable: notifier!,
                  builder: (context, value, child) => progressBuilder != null
                      ? progressBuilder!(context, value, child)
                      : SizedBox.shrink(),
                ),
              )
            : null,
      ),
    );
  }
}

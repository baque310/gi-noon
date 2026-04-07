import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';

class AppProgress extends StatefulWidget {
  final int? value;
  final int? maxValue;
  final bool maxReached;
  const AppProgress({
    super.key,
    this.value,
    this.maxValue,
    this.maxReached = false,
  });

  @override
  State<AppProgress> createState() => _AppProgressState();
}

class _AppProgressState extends State<AppProgress>
    with SingleTickerProviderStateMixin {
  late Animation<double> _progressAnimation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _progressAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_animationController);

    if (widget.value == null || widget.maxValue == null) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(AppProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value == null || widget.maxValue == null) {
      if (!_animationController.isAnimating) {
        _animationController.forward();
      }
    } else {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double? progressValue;
    if (widget.value != null &&
        widget.maxValue != null &&
        widget.maxValue! > 0) {
      progressValue = (widget.value! / widget.maxValue!).clamp(0.0, 1.0);
    }

    return Container(
      width: .infinity,
      height: 22,
      decoration: BoxDecoration(
        color: AppColors.neutralMidGrey.withValues(alpha: 0.2),
        borderRadius: .circular(12),
      ),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return Align(
            alignment: .centerLeft,
            child: FractionallySizedBox(
              widthFactor: progressValue ?? _animationController.value,
              child: Container(
                height: 22,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.maxReached
                        ? [Colors.orange, Colors.deepOrange]
                        : [
                            AppColors.primary,
                            AppColors.primary.withValues(alpha: 0.7),
                          ],
                  ),
                  borderRadius: .circular(12),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class CustomInkwell extends StatelessWidget {
  const CustomInkwell({
    super.key,
    required this.child,
    this.onTap,
    this.inkwellRadius = 16.0,
    this.showRipple = true,
  });

  final double inkwellRadius;
  final Widget child;
  final VoidCallback? onTap;
  final bool showRipple;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (showRipple)
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: .circular(inkwellRadius),
                onTap: onTap,
              ),
            ),
          ),
      ],
    );
  }
}

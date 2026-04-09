import 'package:flutter/material.dart';
import 'package:noon/core/constant/app_colors.dart';

class CustomAnimatedNavBar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final List<CustomNavItem> items;
  final Color backgroundColor;
  final Color activeColor;
  final Color inactiveColor;
  final int? centerIndex;

  const CustomAnimatedNavBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.items,
    this.backgroundColor = Colors.white,
    this.activeColor = AppColors.primary,
    this.inactiveColor = const Color(0xffBFC5CD),
    this.centerIndex,
  });

  @override
  State<CustomAnimatedNavBar> createState() => _CustomAnimatedNavBarState();
}

class _CustomAnimatedNavBarState extends State<CustomAnimatedNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _previousIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );
    _previousIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant CustomAnimatedNavBar oldWidget) {
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _previousIndex = oldWidget.selectedIndex;
      _animationController.forward(from: 0.0);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final isRTL = Directionality.of(context) == TextDirection.rtl;
        final itemWidth =
            MediaQuery.of(context).size.width / widget.items.length;

        double getPosition(int index) {
          int visualIndex = isRTL ? (widget.items.length - 1 - index) : index;
          return (visualIndex * itemWidth) + (itemWidth / 2);
        }

        final startPosition = getPosition(_previousIndex);
        final endPosition = getPosition(widget.selectedIndex);
        final currentPosition =
            startPosition + ((endPosition - startPosition) * _animation.value);

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            // Custom drawn background with the notch
            CustomPaint(
              size: Size(MediaQuery.of(context).size.width, 80),
              painter: NotchPainter(
                position: currentPosition,
                backgroundColor: widget.backgroundColor,
              ),
            ),

            // Floating active circle
            Positioned(
              bottom: 42,
              left: currentPosition - 25,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: widget.activeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.activeColor.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: widget.items[widget.selectedIndex].activeIcon,
                ),
              ),
            ),

            // Icons and Labels inside the bar
            SizedBox(
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(widget.items.length, (index) {
                  final isSelected = widget.selectedIndex == index;
                  final item = widget.items[index];

                  return GestureDetector(
                    onTap: () {
                      if (widget.selectedIndex != index) {
                        widget.onItemSelected(index);
                      }
                    },
                    behavior: HitTestBehavior.opaque,
                    child: SizedBox(
                      width: itemWidth,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (!isSelected)
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                item.inactiveIcon,
                                if (item.badgeCount != null && item.badgeCount! > 0)
                                  Positioned(
                                    right: -6,
                                    top: -4,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        color: AppColors.redColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.white, width: 1.5),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 18,
                                        minHeight: 18,
                                      ),
                                      child: Text(
                                        item.badgeCount! > 99
                                            ? '99+'
                                            : item.badgeCount.toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  ? widget.activeColor
                                  : widget.inactiveColor,
                              fontSize: 11,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              fontFamily: 'Cairo',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CustomNavItem {
  final Widget activeIcon;
  final Widget inactiveIcon;
  final String label;
  final int? badgeCount;

  CustomNavItem({
    required this.activeIcon,
    required this.inactiveIcon,
    required this.label,
    this.badgeCount,
  });
}

class NotchPainter extends CustomPainter {
  final double position;
  final Color backgroundColor;

  NotchPainter({required this.position, required this.backgroundColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.06)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);

    final path = Path();

    path.moveTo(0, 0);

    final notchCenter = position;
    final notchRadius = 30.0;
    final cornerRadius = 10.0;

    path.lineTo(notchCenter - notchRadius - cornerRadius, 0);

    path.quadraticBezierTo(
      notchCenter - notchRadius,
      0,
      notchCenter - notchRadius,
      cornerRadius,
    );

    path.arcToPoint(
      Offset(notchCenter + notchRadius, cornerRadius),
      radius: Radius.circular(notchRadius),
      clockwise: false,
    );

    path.quadraticBezierTo(
      notchCenter + notchRadius,
      0,
      notchCenter + notchRadius + cornerRadius,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path.shift(const Offset(0, -2)), shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant NotchPainter oldDelegate) {
    return oldDelegate.position != position ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}

import 'package:flutter/material.dart';

/// Reusable page dot indicator for carousels.
class PageDotsIndicator extends StatelessWidget {
  const PageDotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
    this.activeColor,
    this.inactiveColor,
  });

  final int count;
  final int currentIndex;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 8,
          height: isActive ? 10 : 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? (activeColor ?? Colors.white)
                : (inactiveColor ?? Colors.white.withValues(alpha: 0.3)),
          ),
        );
      }),
    );
  }
}

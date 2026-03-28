import 'dart:ui';

import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Navigation bar inside a rounded floating container.
/// Provides premium bottom navigation styling.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.showLabels = true,
    this.margin,
    this.elevation = 0,
  });

  /// Navigation items.
  final List<AppBottomNavItem> items;

  /// Currently selected index.
  final int currentIndex;

  /// Called when an item is tapped.
  final ValueChanged<int> onTap;

  /// Whether to show labels below icons.
  final bool showLabels;

  /// External margin around the container.
  final EdgeInsets? margin;

  /// Shadow elevation.
  final double elevation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final glassColor = (isDark ? AppColors.navContainerDark : AppColors.navContainerLight)
        .withValues(alpha: isDark ? 0.9 : 0.95);
    final shadows = elevation > 0
        ? AppShadows.getElevation(elevation.round(), theme.brightness)
        : AppShadows.none;

    final effectiveMargin = margin ?? const EdgeInsets.fromLTRB(
      AppSpacing.lg,
      0,
      AppSpacing.lg,
      0,
    );
    final isFloating = effectiveMargin != EdgeInsets.zero;
    final borderRadius = isFloating ? AppRadius.bottomNav : BorderRadius.zero;

    return Container(
      margin: effectiveMargin,
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: glassColor,
              borderRadius: borderRadius,
              boxShadow: shadows,
            ),
            child: SafeArea(
              top: false,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (index) {
                    final item = items[index];
                    if (item.isSpecial) {
                      return _TefillinSpecialNavButton(
                        item: item,
                        isSelected: currentIndex == index,
                        showLabel: showLabels,
                        onTap: () => onTap(index),
                      );
                    }
                    return _NavItem(
                      item: item,
                      isSelected: currentIndex == index,
                      showLabel: showLabels,
                      onTap: () => onTap(index),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = AppColors.primary;
    final inactiveColor = isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;

    final color = isSelected ? activeColor : inactiveColor;
    final icon = isSelected ? (item.activeIcon ?? item.icon) : item.icon;
    final iconAsset = item.iconAsset;
    const defaultIconSize = 24.0;
    final iconSize = item.iconSize ?? defaultIconSize;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.sm,
            horizontal: AppSpacing.sm,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: isSelected
              ? BoxDecoration(
                  color: activeColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.15),
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ],
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  if (iconAsset != null)
                    ColorFiltered(
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      child: Image.asset(
                        iconAsset,
                        width: iconSize,
                        height: iconSize,
                        fit: BoxFit.contain,
                      ),
                    )
                  else
                    Icon(icon!, color: color, size: iconSize),
                  if (item.badge != null && item.badge! > 0)
                    Positioned(
                      top: -4,
                      right: -8,
                      child: Container(
                        constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            item.badge! > 99 ? '99+' : item.badge.toString(),
                            style: AppTypography.labelSmall.copyWith(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              if (showLabel) ...[
                AppSpacing.gapVerticalXs,
                Text(
                  item.label,
                  style: AppTypography.navItem.copyWith(
                    color: color,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// כפתור תפילין מיוחד - גדול יותר עם קו מסתובב סביבו.
/// גובה הכפתור לא משפיע על קונטיינר ה-navbar (משתמש ב-OverflowBox).
class _TefillinSpecialNavButton extends StatefulWidget {
  const _TefillinSpecialNavButton({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  State<_TefillinSpecialNavButton> createState() => _TefillinSpecialNavButtonState();
}

class _TefillinSpecialNavButtonState extends State<_TefillinSpecialNavButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = AppColors.primary;
    final inactiveColor = isDark
        ? AppColors.darkTextTertiary
        : AppColors.lightTextTertiary;
    final color = widget.isSelected ? activeColor : inactiveColor;

    // עיגול כחול - צבע האפליקציה
    const circleColor = AppColors.primary;
    // אייקון לבן על רקע כחול
    const iconOnCircleColor = Colors.white;
    // הקשת המסתובבת - כחול
    const rotatingArcColor = AppColors.primary;

    // גובה קבוע תואם לפריטים הרגילים - לא משפיע על גובה הקונטיינר
    const slotHeight = 40.0;
    const buttonSize = 70.0;
    const circleSize = 46.0;
    const iconSize = 28.0;

    return Expanded(
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // OverflowBox - הכפתור גדול אבל הסלוט מדווח על slotHeight בלבד
              SizedBox(
                height: slotHeight,
                child: OverflowBox(
                  maxWidth: buttonSize + 8,
                  maxHeight: buttonSize + 8,
                  alignment: Alignment.center,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      // קשת מסתובבת מסביב - כחול
                      SizedBox(
                        width: buttonSize,
                        height: buttonSize,
                        child: AnimatedBuilder(
                          animation: _rotationController,
                          builder: (context, _) {
                            return CustomPaint(
                              painter: _RotatingArcPainter(
                                progress: _rotationController.value,
                                color: rotatingArcColor,
                                strokeWidth: 4,
                              ),
                            );
                          },
                        ),
                      ),
                      // עיגול כחול מלא - צבע האפליקציה
                      Container(
                        width: circleSize,
                        height: circleSize,
                        decoration: BoxDecoration(
                          color: circleColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: circleColor.withValues(alpha: 0.4),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: widget.item.iconAsset != null
                            ? ColorFiltered(
                                colorFilter: const ColorFilter.mode(
                                  iconOnCircleColor,
                                  BlendMode.srcIn,
                                ),
                                child: Image.asset(
                                  widget.item.iconAsset!,
                                  width: iconSize,
                                  height: iconSize,
                                  fit: BoxFit.contain,
                                ),
                              )
                            : Icon(
                                widget.isSelected
                                    ? (widget.item.activeIcon ?? widget.item.icon)!
                                    : widget.item.icon!,
                                color: iconOnCircleColor,
                                size: iconSize,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              // ללא תווית – כפתור תפילין מיוחד
            ],
          ),
        ),
      ),
    );
  }
}

/// קשת מסתובבת בסגנון מקצועי – קטעים רבים עם גרדיאנט opacity (דוהה בקצות, מלא באמצע).
/// בהשראת _AnimatedBorderPainter מ־customer_barber_nav_bar.
class _RotatingArcPainter extends CustomPainter {
  _RotatingArcPainter({
    required this.progress,
    required this.color,
    this.strokeWidth = 2.0,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  static const _pi = 3.14159265359;
  static const _tau = 2 * _pi;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    // רדיוס גדול יותר = קשת רחוקה יותר מהעיגול. +2 מרחיק את הקשת
    final radius = (size.shortestSide / 2) - strokeWidth + 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    // קטע של 120 מעלות – כמו בדוגמת הברבר
    const segmentAngle = _tau * (120 / 360);
    // מתחילים מלמעלה (-pi/2) ומסתובבים עם progress
    final startAngle = -_pi / 2 + (progress * _tau);

    const numPoints = 40;
    final angleStep = segmentAngle / numPoints;

    for (int i = 0; i < numPoints; i++) {
      final currentAngle = startAngle + (i * angleStep);
      final t = i / numPoints;
      // דוהה בקצות, מלא באמצע – אפקט גרדיאנט חלק
      final opacity = (t < 0.2)
          ? (t / 0.2) * 0.9
          : (t > 0.8)
              ? ((1.0 - t) / 0.2) * 0.9
              : 0.9;

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final path = Path()..addArc(rect, currentAngle, angleStep);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RotatingArcPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Data class for bottom navigation item.
class AppBottomNavItem {
  const AppBottomNavItem({
    this.icon,
    this.activeIcon,
    this.iconAsset,
    required this.label,
    this.badge,
    this.isSpecial = false,
    this.iconSize,
  }) : assert(icon != null || iconAsset != null, 'Either icon or iconAsset must be provided');

  /// Default icon (used when iconAsset is null).
  final IconData? icon;

  /// Icon when selected (used when iconAsset is null).
  final IconData? activeIcon;

  /// Custom image asset path (takes precedence over icon when provided).
  final String? iconAsset;

  /// Label text.
  final String label;

  /// Optional badge count.
  final int? badge;

  /// Whether this item uses special styling (e.g. larger button with rotating border).
  final bool isSpecial;

  /// Optional custom icon size. If null, default 24 is used.
  final double? iconSize;
}

/// Apple-style bottom navigation with floating center FAB.
/// Features a prominent center button that floats above the navigation bar.
class AppAppleBottomNav extends StatelessWidget {
  const AppAppleBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    required this.centerIcon,
    required this.onCenterTap,
    this.centerLabel,
    this.showLabels = true,
  });

  /// Navigation items (will be split around center button).
  final List<AppBottomNavItem> items;

  /// Currently selected index.
  final int currentIndex;

  /// Called when a nav item is tapped.
  final ValueChanged<int> onTap;

  /// Icon for the center floating button.
  final IconData centerIcon;

  /// Called when center button is tapped.
  final VoidCallback onCenterTap;

  /// Optional label for center button.
  final String? centerLabel;

  /// Whether to show labels.
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final glassColor = (isDark ? AppColors.navContainerDark : AppColors.navContainerLight)
        .withValues(alpha: isDark ? 0.9 : 0.95);
    final fabColor = isDark ? Colors.white : Colors.white;
    final fabIconColor = isDark ? AppColors.darkBackground : AppColors.lightTextPrimary;

    final leftItems = items.take((items.length / 2).floor()).toList();
    final rightItems = items.skip((items.length / 2).floor()).toList();

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        // Navigation bar container - starts from bottom with SafeArea
        ClipRRect(
          borderRadius: AppRadius.topExtraLarge,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              decoration: BoxDecoration(
                color: glassColor,
                borderRadius: AppRadius.topExtraLarge,
                boxShadow: isDark ? AppShadows.mdDark : AppShadows.mdLight,
                border: Border(
                  top: BorderSide(
                    color: Colors.white.withValues(alpha: isDark ? 0.15 : 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Container(
                  height: 72,
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: Row(
                    children: [
                      // Left items
                      ...List.generate(leftItems.length, (index) {
                        return Expanded(
                          child: _AppleNavItem(
                            item: leftItems[index],
                            isSelected: currentIndex == index,
                            showLabel: showLabels,
                            onTap: () => onTap(index),
                          ),
                        );
                      }),

                      // Center spacer for FAB
                      const SizedBox(width: 80),

                      // Right items
                      ...List.generate(rightItems.length, (index) {
                        final actualIndex = leftItems.length + index;
                        return Expanded(
                          child: _AppleNavItem(
                            item: rightItems[index],
                            isSelected: currentIndex == actualIndex,
                            showLabel: showLabels,
                            onTap: () => onTap(actualIndex),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),

        // Center floating button
        Positioned(
          top: -28,
          child: GestureDetector(
            onTap: onCenterTap,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: fabColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
                ],
                border: Border.all(
                  color: isDark 
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
                  width: 1,
                ),
              ),
              child: Icon(
                centerIcon,
                color: fabIconColor,
                size: 28,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AppleNavItem extends StatelessWidget {
  const _AppleNavItem({
    required this.item,
    required this.isSelected,
    required this.showLabel,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool isSelected;
  final bool showLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = AppColors.primary;
    final inactiveColor = isDark 
        ? AppColors.darkTextTertiary 
        : AppColors.lightTextTertiary;

    final color = isSelected ? activeColor : inactiveColor;
    final icon = isSelected ? (item.activeIcon ?? item.icon) : item.icon;
    final iconAsset = item.iconAsset;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconAsset != null)
            ColorFiltered(
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
              child: Image.asset(
                iconAsset,
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
            )
          else
            Icon(icon!, color: color, size: 24),
          if (showLabel) ...[
            const SizedBox(height: 4),
            Text(
              item.label,
              style: AppTypography.caption.copyWith(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}

/// Alternative floating action button style bottom nav.
class AppFloatingBottomNav extends StatelessWidget {
  const AppFloatingBottomNav({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
    this.centerItem,
    this.onCenterTap,
  });

  final List<AppBottomNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final IconData? centerItem;
  final VoidCallback? onCenterTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? AppColors.navContainerDark : AppColors.navContainerLight;

    final leftItems = items.take((items.length / 2).floor()).toList();
    final rightItems = items.skip((items.length / 2).floor()).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        0,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Left items
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: AppRadius.bottomNav,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(leftItems.length, (index) {
                    return _FloatingNavItem(
                      item: leftItems[index],
                      isSelected: currentIndex == index,
                      onTap: () => onTap(index),
                    );
                  }),
                ),
              ),
            ),

            // Center button
            if (centerItem != null) ...[
              AppSpacing.gapMd,
              FloatingActionButton(
                onPressed: onCenterTap,
                elevation: 0,
                backgroundColor: AppColors.primary,
                child: Icon(centerItem, color: Colors.white),
              ),
              AppSpacing.gapMd,
            ],

            // Right items
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: containerColor,
                  borderRadius: AppRadius.bottomNav,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(rightItems.length, (index) {
                    final actualIndex = leftItems.length + index;
                    return _FloatingNavItem(
                      item: rightItems[index],
                      isSelected: currentIndex == actualIndex,
                      onTap: () => onTap(actualIndex),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingNavItem extends StatelessWidget {
  const _FloatingNavItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final AppBottomNavItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final activeColor = AppColors.primary;
    final inactiveColor = isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;

    final color = isSelected ? activeColor : inactiveColor;
    final icon = isSelected ? (item.activeIcon ?? item.icon) : item.icon;
    final iconAsset = item.iconAsset;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: iconAsset != null
            ? ColorFiltered(
                colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                child: Image.asset(
                  iconAsset,
                  width: 24,
                  height: 24,
                  fit: BoxFit.contain,
                ),
              )
            : Icon(icon!, color: color, size: 24),
      ),
    );
  }
}

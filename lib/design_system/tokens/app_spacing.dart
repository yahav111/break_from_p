import 'package:flutter/material.dart';

/// Design system spacing tokens following an 8-point grid system.
/// Use these constants for consistent spacing throughout the app.
abstract final class AppSpacing {
  // ============================================
  // BASE SPACING VALUES
  // ============================================

  /// Extra small spacing - 4px
  static const double xs = 4.0;

  /// Small spacing - 8px
  static const double sm = 8.0;

  /// Medium spacing - 12px
  static const double md = 12.0;

  /// Large spacing - 16px
  static const double lg = 16.0;

  /// Extra large spacing - 20px
  static const double xl = 20.0;

  /// 2X Extra large spacing - 24px
  static const double xxl = 24.0;

  /// 3X Extra large spacing - 32px
  static const double xxxl = 32.0;

  /// 4X Extra large spacing - 40px
  static const double xxxxl = 40.0;

  /// 5X Extra large spacing - 48px
  static const double xxxxxl = 48.0;

  /// 6X Extra large spacing - 56px
  static const double xxxxxxl = 56.0;

  /// 7X Extra large spacing - 64px
  static const double xxxxxxxl = 64.0;

  /// 8X Extra large spacing - 72px
  static const double xxxxxxxxl = 300.0;

  // ============================================
  // EDGE INSETS (PADDING/MARGIN SHORTCUTS)
  // ============================================

  /// No padding
  static const EdgeInsets none = EdgeInsets.zero;

  /// Extra small padding all around
  static const EdgeInsets allXs = EdgeInsets.all(xs);

  /// Small padding all around
  static const EdgeInsets allSm = EdgeInsets.all(sm);

  /// Medium padding all around
  static const EdgeInsets allMd = EdgeInsets.all(md);

  /// Large padding all around
  static const EdgeInsets allLg = EdgeInsets.all(lg);

  /// Extra large padding all around
  static const EdgeInsets allXl = EdgeInsets.all(xl);

  /// 2X Extra large padding all around
  static const EdgeInsets allXxl = EdgeInsets.all(xxl);

  /// 3X Extra large padding all around
  static const EdgeInsets allXxxl = EdgeInsets.all(xxxl);

  // ============================================
  // HORIZONTAL PADDING
  // ============================================

  /// Extra small horizontal padding
  static const EdgeInsets horizontalXs = EdgeInsets.symmetric(horizontal: xs);

  /// Small horizontal padding
  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(horizontal: sm);

  /// Medium horizontal padding
  static const EdgeInsets horizontalMd = EdgeInsets.symmetric(horizontal: md);

  /// Large horizontal padding
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(horizontal: lg);

  /// Extra large horizontal padding
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(horizontal: xl);

  /// 2X Extra large horizontal padding
  static const EdgeInsets horizontalXxl = EdgeInsets.symmetric(horizontal: xxl);

  // ============================================
  // VERTICAL PADDING
  // ============================================

  /// Extra small vertical padding
  static const EdgeInsets verticalXs = EdgeInsets.symmetric(vertical: xs);

  /// Small vertical padding
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(vertical: sm);

  /// Medium vertical padding
  static const EdgeInsets verticalMd = EdgeInsets.symmetric(vertical: md);

  /// Large vertical padding
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(vertical: lg);

  /// Extra large vertical padding
  static const EdgeInsets verticalXl = EdgeInsets.symmetric(vertical: xl);

  /// 2X Extra large vertical padding
  static const EdgeInsets verticalXxl = EdgeInsets.symmetric(vertical: xxl);

  // ============================================
  // COMMON SCREEN PADDING
  // ============================================

  /// Standard screen horizontal padding
  static const EdgeInsets screenHorizontal = EdgeInsets.symmetric(horizontal: lg);

  /// Standard screen padding (horizontal + top)
  static const EdgeInsets screenPadding = EdgeInsets.fromLTRB(lg, lg, lg, 0);

  /// Card internal padding
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  /// List item padding
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  // ============================================
  // SIZED BOX SHORTCUTS
  // ============================================

  /// Horizontal gap - extra small
  static const SizedBox gapXs = SizedBox(width: xs);

  /// Horizontal gap - small
  static const SizedBox gapSm = SizedBox(width: sm);

  /// Horizontal gap - medium
  static const SizedBox gapMd = SizedBox(width: md);

  /// Horizontal gap - large
  static const SizedBox gapLg = SizedBox(width: lg);

  /// Horizontal gap - extra large
  static const SizedBox gapXl = SizedBox(width: xl);

  /// Horizontal gap - 2x extra large
  static const SizedBox gapXxl = SizedBox(width: xxl);

  /// Vertical gap - extra small
  static const SizedBox gapVerticalXs = SizedBox(height: xs);

  /// Vertical gap - small
  static const SizedBox gapVerticalSm = SizedBox(height: sm);

  /// Vertical gap - medium
  static const SizedBox gapVerticalMd = SizedBox(height: md);

  /// Vertical gap - large
  static const SizedBox gapVerticalLg = SizedBox(height: lg);

  /// Vertical gap - extra large
  static const SizedBox gapVerticalXl = SizedBox(height: xl);

  /// Vertical gap - 2x extra large
  static const SizedBox gapVerticalXxl = SizedBox(height: xxl);

  /// Vertical gap - 3x extra large
  static const SizedBox gapVerticalXxxl = SizedBox(height: xxxl);
}


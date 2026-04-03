import 'package:flutter/material.dart';

/// Design system border radius tokens.
/// Use these for consistent rounded corners throughout the app.
abstract final class AppRadius {
  // ============================================
  // BASE RADIUS VALUES
  // ============================================

  /// No radius - sharp corners
  static const double none = 0.0;

  /// Extra small radius - 4px
  static const double xs = 4.0;

  /// Small radius - 8px
  static const double small = 8.0;

  /// Medium radius - 12px
  static const double medium = 12.0;

  /// Large radius - 16px
  static const double large = 16.0;

  /// Extra large radius - 20px
  static const double extraLarge = 20.0;

  /// 2X Extra large radius - 24px
  static const double xxl = 24.0;

  /// Pill/Capsule radius - 32px
  static const double pill = 32.0;

  /// Full circular radius - 999px
  static const double circular = 999.0;

  // ============================================
  // BORDER RADIUS (ALL CORNERS)
  // ============================================

  /// No radius
  static const BorderRadius borderNone = BorderRadius.zero;

  /// Extra small border radius all corners
  static const BorderRadius borderXs = BorderRadius.all(Radius.circular(xs));

  /// Small border radius all corners
  static const BorderRadius borderSmall = BorderRadius.all(Radius.circular(small));

  /// Medium border radius all corners
  static const BorderRadius borderMedium = BorderRadius.all(Radius.circular(medium));

  /// Large border radius all corners
  static const BorderRadius borderLarge = BorderRadius.all(Radius.circular(large));

  /// Extra large border radius all corners
  static const BorderRadius borderExtraLarge = BorderRadius.all(Radius.circular(extraLarge));

  /// 2X Extra large border radius all corners
  static const BorderRadius borderXxl = BorderRadius.all(Radius.circular(xxl));

  /// Pill border radius all corners
  static const BorderRadius borderPill = BorderRadius.all(Radius.circular(pill));

  /// Circular border radius
  static const BorderRadius borderCircular = BorderRadius.all(Radius.circular(circular));

  // ============================================
  // TOP ONLY RADIUS (for bottom sheets, modals)
  // ============================================

  /// Large top corners only
  static const BorderRadius topLarge = BorderRadius.only(
    topLeft: Radius.circular(large),
    topRight: Radius.circular(large),
  );

  /// Extra large top corners only
  static const BorderRadius topExtraLarge = BorderRadius.only(
    topLeft: Radius.circular(extraLarge),
    topRight: Radius.circular(extraLarge),
  );

  /// 2X Extra large top corners only
  static const BorderRadius topXxl = BorderRadius.only(
    topLeft: Radius.circular(xxl),
    topRight: Radius.circular(xxl),
  );

  /// Pill top corners only
  static const BorderRadius topPill = BorderRadius.only(
    topLeft: Radius.circular(pill),
    topRight: Radius.circular(pill),
  );

  // ============================================
  // BOTTOM ONLY RADIUS
  // ============================================

  /// Large bottom corners only
  static const BorderRadius bottomLarge = BorderRadius.only(
    bottomLeft: Radius.circular(large),
    bottomRight: Radius.circular(large),
  );

  /// Extra large bottom corners only
  static const BorderRadius bottomExtraLarge = BorderRadius.only(
    bottomLeft: Radius.circular(extraLarge),
    bottomRight: Radius.circular(extraLarge),
  );

  // ============================================
  // COMPONENT SPECIFIC RADIUS
  // ============================================

  /// Card radius - premium rounded cards
  static const BorderRadius card = borderExtraLarge;

  /// Button radius - primary buttons
  static const BorderRadius button = borderMedium;

  /// Input/Search bar radius - full rounded
  static const BorderRadius input = borderPill;

  /// Bottom navigation container
  static const BorderRadius bottomNav = borderExtraLarge;

  /// Modal/Bottom sheet radius
  static const BorderRadius modal = topXxl;

  /// Icon circle radius
  static const BorderRadius iconCircle = borderCircular;

  /// Chip/Tag radius
  static const BorderRadius chip = borderPill;

  /// Avatar radius
  static const BorderRadius avatar = borderCircular;

  /// Stats card radius
  static const BorderRadius statsCard = borderLarge;
}


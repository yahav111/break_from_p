import 'package:flutter/material.dart';

import '../../../../../design_system/design_system.dart';

/// Row of press publication logos (Forbes, TechTimes, LAWeekly).
class PressLogoRow extends StatelessWidget {
  const PressLogoRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLogo('Forbes'),
        const SizedBox(width: AppSpacing.xxl),
        _buildLogo('TECH\nTIMES', fontSize: 10),
        const SizedBox(width: AppSpacing.xxl),
        _buildLogo('LAWEEKLY', fontSize: 11),
      ],
    );
  }

  Widget _buildLogo(String text, {double fontSize = 14}) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.6),
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.2,
        fontFamily: 'serif',
        height: 1.1,
      ),
    );
  }
}

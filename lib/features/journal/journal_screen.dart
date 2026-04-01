import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';

/// Placeholder screen for the Journal tab (Phase 3).
class JournalScreen extends StatelessWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: AppColors.primary,
                size: 48,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Journal',
                style: AppTypography.headlineLarge.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Coming soon',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

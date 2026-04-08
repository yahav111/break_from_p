import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.darkTextTertiary, thickness: 0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Text(
            'or',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextTertiary,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.darkTextTertiary, thickness: 0.5),
        ),
      ],
    );
  }
}

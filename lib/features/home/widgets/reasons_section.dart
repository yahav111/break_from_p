import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/reasons_provider.dart';
import '../../../design_system/design_system.dart';
import '../../reasons/reasons_setup_sheet.dart';

/// Home screen section displaying user's reasons for quitting.
/// Shows a setup prompt when no reasons exist yet.
class ReasonsSection extends ConsumerWidget {
  const ReasonsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reasons = ref.watch(reasonsNotifierProvider)?.reasons ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionTitle(
          title: 'My Reasons',
          actionLabel: reasons.isEmpty ? 'Add' : 'Edit',
          onActionTap: () => ReasonsSetupSheet.show(context),
        ),
        if (reasons.isEmpty)
          _buildSetupPrompt(context)
        else
          _buildReasonsList(reasons),
      ],
    );
  }

  Widget _buildSetupPrompt(BuildContext context) {
    return GestureDetector(
      onTap: () => ReasonsSetupSheet.show(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: AppRadius.borderLarge,
          border: Border.all(
            color: AppColors.darkBorderSubtle,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.primary,
              size: 24,
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                'Add your personal reasons for quitting',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonsList(List<String> reasons) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: reasons.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkCard,
              borderRadius: AppRadius.borderPill,
              border: Border.all(color: AppColors.darkBorderSubtle),
            ),
            child: Text(
              reasons[index],
              style: AppTypography.bodySmall.copyWith(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/reasons_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/reason_chip.dart';
import 'widgets/suggested_reasons.dart';

/// Modal sheet for adding and managing personal reasons for quitting.
class ReasonsSetupSheet extends ConsumerStatefulWidget {
  const ReasonsSetupSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppModalSheet.show(
      context: context,
      title: 'הסיבות שלי להפסיק',
      subtitle: 'הוסף את המניעים האישיים שלך',
      showCloseButton: true,
      maxHeight: 0.85,
      child: const ReasonsSetupSheet(),
    );
  }

  @override
  ConsumerState<ReasonsSetupSheet> createState() => _ReasonsSetupSheetState();
}

class _ReasonsSetupSheetState extends ConsumerState<ReasonsSetupSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addCustomReason() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref.read(reasonsNotifierProvider.notifier).addReason(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final reasons = ref.watch(reasonsNotifierProvider)?.reasons ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Custom reason input.
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'הוסף סיבה מותאמת אישית...',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.darkTextTertiary,
                  ),
                  filled: true,
                  fillColor: AppColors.darkElevated,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.borderPill,
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _addCustomReason(),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            GestureDetector(
              onTap: _addCustomReason,
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xxl),

        // Current reasons.
        if (reasons.isNotEmpty) ...[
          Text(
            'הסיבות שלך',
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: reasons.asMap().entries.map((entry) {
              return ReasonChip(
                text: entry.value,
                onDelete: () => ref
                    .read(reasonsNotifierProvider.notifier)
                    .removeReason(entry.key),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.xxl),
        ],

        // Suggested reasons.
        Text(
          'הצעות',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SuggestedReasons(
          alreadyAdded: reasons,
          onSelected: (reason) {
            ref.read(reasonsNotifierProvider.notifier).addReason(reason);
          },
        ),
      ],
    );
  }
}

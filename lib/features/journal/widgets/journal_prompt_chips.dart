import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/lifetree_provider.dart';
import '../../../core/services/journal_prompts_engine.dart';
import '../../../design_system/design_system.dart';

/// Horizontal scroll of prompt suggestions for journal entries.
/// Merges default prompts with Lifetree-unlocked bonus prompts.
class JournalPromptChips extends ConsumerStatefulWidget {
  const JournalPromptChips({
    super.key,
    required this.onPromptSelected,
  });

  final ValueChanged<String> onPromptSelected;

  @override
  ConsumerState<JournalPromptChips> createState() => _JournalPromptChipsState();
}

class _JournalPromptChipsState extends ConsumerState<JournalPromptChips> {
  String? _selectedPrompt;

  @override
  Widget build(BuildContext context) {
    final lifetreeData = ref.watch(lifetreeNotifierProvider);
    final unlockedIds = lifetreeData?.unlockedNodeIds.toSet() ?? <String>{};
    final prompts = JournalPromptsEngine.allUnlockedPrompts(unlockedIds);

    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: prompts.map((prompt) {
            final isSelected = _selectedPrompt == prompt;
            return Padding(
              padding: EdgeInsets.only(
                right: AppSpacing.sm,
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPrompt = isSelected ? null : prompt;
                  });
                  widget.onPromptSelected(isSelected ? '' : prompt);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: AppRadius.borderPill,
                    border: isSelected
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Text(
                    prompt,
                    style: AppTypography.caption.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.darkTextSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

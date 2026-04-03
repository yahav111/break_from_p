import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Horizontal scroll of prompt suggestions for journal entries.
class JournalPromptChips extends StatefulWidget {
  const JournalPromptChips({
    super.key,
    required this.onPromptSelected,
  });

  final ValueChanged<String> onPromptSelected;

  @override
  State<JournalPromptChips> createState() => _JournalPromptChipsState();
}

class _JournalPromptChipsState extends State<JournalPromptChips> {
  static const _prompts = [
    'What am I grateful for today?',
    'What triggered me today?',
    'How did I cope with urges?',
    'What progress have I noticed?',
    'What would I tell a friend in my situation?',
    'What are my goals for tomorrow?',
  ];

  String? _selectedPrompt;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _prompts.map((prompt) {
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

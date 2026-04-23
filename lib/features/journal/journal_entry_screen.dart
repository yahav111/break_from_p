import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/journal_provider.dart';
import '../../design_system/design_system.dart';
import 'widgets/mood_selector.dart';
import 'widgets/journal_prompt_chips.dart';

/// New journal entry screen. Pushed from the journal list.
class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _contentController = TextEditingController();
  int? _selectedMood;
  String? _selectedPrompt;
  bool _isSaving = false;

  bool get _canSave =>
      !_isSaving &&
      _selectedMood != null &&
      _contentController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.xl),

                      // Mood selector section.
                      Text(
                        'איך אתה מרגיש?',
                        style: AppTypography.titleSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      MoodSelector(
                        selectedMood: _selectedMood,
                        onMoodSelected: (mood) {
                          setState(() => _selectedMood = mood);
                        },
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Prompt chips section.
                      Text(
                        'צריך פרומפט?',
                        style: AppTypography.titleSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      JournalPromptChips(
                        onPromptSelected: _onPromptSelected,
                      ),
                      const SizedBox(height: AppSpacing.xxl),

                      // Content text field.
                      Text(
                        'המחשבות שלך',
                        style: AppTypography.titleSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _buildContentField(),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppColors.overlayWhiteSubtle,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Text(
              'רשומה חדשה',
              style: AppTypography.headlineSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          AppButton(
            label: 'שמור',
            variant: AppButtonVariant.primary,
            size: AppButtonSize.small,
            isLoading: _isSaving,
            onPressed: _canSave ? _saveEntry : null,
          ),
        ],
      ),
    );
  }

  Widget _buildContentField() {
    return TextField(
      controller: _contentController,
      onChanged: (_) => setState(() {}),
      maxLines: null,
      minLines: 8,
      style: AppTypography.bodyMedium.copyWith(color: Colors.white),
      decoration: InputDecoration(
        hintText: 'כתוב את המחשבות שלך...',
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkTextTertiary,
        ),
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.all(AppSpacing.lg),
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderLarge,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderLarge,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderLarge,
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
      ),
    );
  }

  void _onPromptSelected(String prompt) {
    if (prompt.isEmpty) {
      setState(() => _selectedPrompt = null);
      return;
    }

    setState(() => _selectedPrompt = prompt);

    // Insert the prompt as the first line if the field is empty or prepend it.
    final currentText = _contentController.text;
    if (currentText.isEmpty) {
      _contentController.text = '$prompt\n';
    } else {
      // Check if text already starts with a prompt line — replace it.
      final lines = currentText.split('\n');
      // If the first line looks like a prompt (ends with ?), replace it.
      if (lines.first.endsWith('?')) {
        lines[0] = prompt;
        _contentController.text = lines.join('\n');
      } else {
        _contentController.text = '$prompt\n$currentText';
      }
    }
    // Move cursor to end.
    _contentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _contentController.text.length),
    );
  }

  Future<void> _saveEntry() async {
    if (!_canSave) return;

    setState(() => _isSaving = true);

    try {
      await ref.read(journalNotifierProvider.notifier).addEntry(
            content: _contentController.text.trim(),
            mood: _selectedMood!,
            prompt: _selectedPrompt,
          );

      if (mounted) {
        context.pop();
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}

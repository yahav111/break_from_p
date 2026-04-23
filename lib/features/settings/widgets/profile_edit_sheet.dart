import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/streak_provider.dart';
import '../../../core/providers/user_profile_provider.dart';
import '../../../design_system/design_system.dart';

/// Bottom sheet for editing user profile (name and quit date).
class ProfileEditSheet extends ConsumerStatefulWidget {
  const ProfileEditSheet({super.key});

  static Future<void> show(BuildContext context) {
    return AppModalSheet.show(
      context: context,
      title: 'עריכת פרופיל',
      showCloseButton: true,
      child: const ProfileEditSheet(),
    );
  }

  @override
  ConsumerState<ProfileEditSheet> createState() => _ProfileEditSheetState();
}

class _ProfileEditSheetState extends ConsumerState<ProfileEditSheet> {
  late final TextEditingController _nameController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileNotifierProvider);
    _nameController = TextEditingController(text: profile?.name ?? '');
    _selectedDate = profile?.quitDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.primary,
              surface: AppColors.darkSurface,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final profile = ref.read(userProfileNotifierProvider);
    if (profile == null) return;

    await ref.read(userProfileNotifierProvider.notifier).updateProfile(
          profile.copyWith(name: name, quitDate: _selectedDate),
        );

    // If quit date changed, update the streak too.
    if (_selectedDate != profile.quitDate) {
      await ref.read(streakNotifierProvider.notifier).startStreak(_selectedDate);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Name field.
        Text(
          'שם',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextField(
          controller: _nameController,
          style: AppTypography.bodyMedium.copyWith(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.darkElevated,
            border: OutlineInputBorder(
              borderRadius: AppRadius.borderMedium,
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // Quit date.
        Text(
          'תאריך התחלה',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              color: AppColors.darkElevated,
              borderRadius: AppRadius.borderMedium,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: AppTypography.bodyMedium.copyWith(color: Colors.white),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.darkTextSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxxl),

        // Save button.
        AppButton(
          label: 'שמור שינויים',
          variant: AppButtonVariant.primary,
          onPressed: _save,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../design_system/design_system.dart';

/// Combined name + age text input for the final quiz step.
class QuizNameAgeForm extends StatelessWidget {
  const QuizNameAgeForm({
    super.key,
    required this.nameController,
    required this.ageController,
    required this.onNameChanged,
    required this.onAgeChanged,
    required this.canProceed,
    required this.onSubmit,
  });

  final TextEditingController nameController;
  final TextEditingController ageController;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onAgeChanged;
  final bool canProceed;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildField(
          controller: nameController,
          hint: 'Your name',
          onChanged: onNameChanged,
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          autofocus: true,
        ),
        const SizedBox(height: AppSpacing.lg),
        _buildField(
          controller: ageController,
          hint: 'Age',
          onChanged: onAgeChanged,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(3),
          ],
          onSubmitted: canProceed ? (_) => onSubmit() : null,
        ),
        const SizedBox(height: AppSpacing.xxl),
        GradientButton(
          label: 'Complete Quiz',
          isFullWidth: true,
          size: AppButtonSize.large,
          onPressed: canProceed ? onSubmit : null,
        ),
      ],
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required ValueChanged<String> onChanged,
    required TextInputType keyboardType,
    required TextInputAction textInputAction,
    bool autofocus = false,
    List<TextInputFormatter>? inputFormatters,
    ValueChanged<String>? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      autofocus: autofocus,
      style: AppTypography.bodyLarge.copyWith(color: Colors.white),
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTypography.bodyLarge.copyWith(
          color: AppColors.darkTextTertiary,
        ),
        filled: true,
        fillColor: AppColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: AppRadius.borderPill,
          borderSide: BorderSide(
            color: AppColors.darkBorderSubtle,
            width: 0.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderPill,
          borderSide: BorderSide(
            color: AppColors.darkBorderSubtle,
            width: 0.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.borderPill,
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
      ),
    );
  }
}

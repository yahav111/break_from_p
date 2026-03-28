import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../../shared/widgets/star_field.dart';
import 'widgets/quiz_option_card.dart';
import 'widgets/quiz_progress_bar.dart';

/// Interactive quiz screen that presents questions and options.
/// Shows a progress bar and animated selections.
class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // 0 means nothing selected. Normal options are 1, 2, ...
  int? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBackground(),
        const StarField(density: 65), // Stars as requested by the DS palette
        _buildContent(),
      ],
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.darkBackground,
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: AppSpacing.md),
          _buildTopBar(),
          const SizedBox(height: AppSpacing.xxxl),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeadline(),
                  const SizedBox(height: AppSpacing.xxl),
                  _buildQuestionLabel(),
                  const SizedBox(height: AppSpacing.xxxxxl),
                  _buildOptionsList(),
                ],
              ),
            ),
          ),
          _buildFooter(),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildBackButton(),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: QuizProgressBar(progress: 0.25),
            ),
          ),
          _buildLanguageSelector(),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        // Back action (would pop context in real app)
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.overlayWhiteSubtle,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: AppRadius.borderPill,
        border: Border.all(color: AppColors.darkBorderSubtle, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🇺🇸', style: TextStyle(fontSize: 14)),
          const SizedBox(width: AppSpacing.xs),
          Text(
            'EN',
            style: AppTypography.labelLarge.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline() {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Text(
            'Question #4',
            style: AppTypography.displayMedium.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
            ),
          ),
          // Stylized underline
          Positioned(
            bottom: -2, // Just under text
            left: 0,
            child: Container(
              height: 3,
              width: 20, 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppRadius.borderPill,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionLabel() {
    return Text(
      'Have you noticed a shift towards more\nextreme or graphic material?',
      style: AppTypography.bodyLarge.copyWith(
        color: AppColors.lightTextSecondary,
        height: 1.5,
        fontSize: 18,
      ),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildOptionsList() {
    return Column(
      children: [
        QuizOptionCard(
          index: 1,
          label: 'Yes',
          isSelected: _selectedOption == 1,
          onTap: () => setState(() => _selectedOption = 1),
        ),
        QuizOptionCard(
          index: 2,
          label: 'No',
          isSelected: _selectedOption == 2,
          onTap: () => setState(() => _selectedOption = 2),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Align(
        alignment: Alignment.center,
        child: AppButton(
          label: 'Skip',
          isFullWidth: false,
          variant: AppButtonVariant.secondary,
          size: AppButtonSize.small,
          onPressed: () {},
        ),
      ),
    );
  }
}

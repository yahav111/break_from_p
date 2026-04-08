import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../widgets/onboarding_page_template.dart';

/// Animated "Calculating" screen that auto-advances after ~3 seconds.
class CalculatingPage extends StatefulWidget {
  const CalculatingPage({super.key, required this.onComplete});

  final VoidCallback onComplete;

  @override
  State<CalculatingPage> createState() => _CalculatingPageState();
}

class _CalculatingPageState extends State<CalculatingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete();
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final percent = (_controller.value * 100).round();
                return SizedBox(
                  width: 120,
                  height: 120,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: _controller.value,
                          strokeWidth: 6,
                          backgroundColor:
                              AppColors.darkBorderSubtle.withValues(alpha: 0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.lerp(
                              AppColors.error,
                              AppColors.success,
                              _controller.value,
                            )!,
                          ),
                        ),
                      ),
                      Text(
                        '$percent%',
                        style: AppTypography.headlineLarge.copyWith(
                          color: Colors.white,
                          fontWeight: AppTypography.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Text(
              'Calculating',
              style: AppTypography.headlineMedium.copyWith(
                color: Colors.white,
                fontWeight: AppTypography.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Understanding responses',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

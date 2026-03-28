import 'package:flutter/material.dart';

import '../../design_system/design_system.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';
import '../paywall/paywall_screen.dart';
import '../quiz/quiz_screen.dart';
import '../welcome/welcome_screen.dart';

/// Page-view showcase that lets you swipe between all demo screens.
/// Acts as the root of the design-system preview app.
class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({super.key});

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  final _controller = PageController();
  int _current = 0;

  static final _screens = <Widget>[
    const WelcomeScreen(),
    const OnboardingScreen(),
    const HomeScreen(),
    const PaywallScreen(),
    const QuizScreen(),
  ];

  static const _labels = ['Welcome', 'Onboarding', 'Home', 'Paywall', 'Quiz'];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _current = i),
            children: _screens,
          ),
          _buildScreenLabel(),
          _buildDotIndicator(),
        ],
      ),
    );
  }

  Widget _buildScreenLabel() {
    return Positioned(
      top: 56,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.overlayWhiteSubtle,
            borderRadius: AppRadius.borderPill,
          ),
          child: Text(
            '${_labels[_current]}  ${_current + 1}/${_screens.length}',
            style: AppTypography.caption.copyWith(
              color: AppColors.darkTextSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicator() {
    return Positioned(
      bottom: 36,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_screens.length, (i) {
          final active = i == _current;
          return GestureDetector(
            onTap: () => _goTo(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 28 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : AppColors.darkBorder,
                borderRadius: AppRadius.borderCircular,
              ),
            ),
          );
        }),
      ),
    );
  }
}

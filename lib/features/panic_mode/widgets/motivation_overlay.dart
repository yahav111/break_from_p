import 'dart:async';

import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

/// Cycles bold motivational sentences with a fade animation.
/// Displayed as a single-line banner inside the camera card.
class MotivationOverlay extends StatefulWidget {
  const MotivationOverlay({super.key});

  @override
  State<MotivationOverlay> createState() => _MotivationOverlayState();
}

class _MotivationOverlayState extends State<MotivationOverlay>
    with SingleTickerProviderStateMixin {
  static const _messages = [
    'IS THIS REALLY WORTH IT?',
    "YOU'RE BETTER THAN THIS.",
    'THINK ABOUT WHO YOU WANT TO BE.',
    'THIS FEELING WILL PASS.',
    'YOUR FUTURE SELF WILL THANK YOU.',
    "YOU'VE COME TOO FAR TO QUIT.",
  ];

  int _currentIndex = 0;
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();

    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _fadeController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % _messages.length;
          });
          _fadeController.forward();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        _messages[_currentIndex],
        style: AppTypography.titleMedium.copyWith(
          color: Colors.white,
          fontWeight: AppTypography.bold,
          letterSpacing: 0.5,
          shadows: const [
            Shadow(blurRadius: 12, color: Colors.black87),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

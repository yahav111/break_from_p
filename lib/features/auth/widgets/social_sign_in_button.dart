import 'package:flutter/material.dart';

import '../../../design_system/design_system.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return AppButton(
      label: label,
      isFullWidth: true,
      variant: AppButtonVariant.secondary,
      size: AppButtonSize.large,
      icon: icon,
      iconPosition: AppButtonIconPosition.leading,
      onPressed: isLoading ? null : onPressed,
    );
  }
}

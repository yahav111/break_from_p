import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../design_system/design_system.dart';

class SocialSignInButton extends StatelessWidget {
  const SocialSignInButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.svgAsset,
    this.icon,
    this.isLoading = false,
  }) : assert(svgAsset != null || icon != null);

  final String label;
  final String? svgAsset;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final borderColor =
        isDark ? AppColors.overlayWhiteSubtle : AppColors.lightBorder;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final isDisabled = onPressed == null || isLoading;

    final Widget leadingIcon;
    if (isLoading) {
      leadingIcon = const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    } else if (svgAsset != null) {
      leadingIcon = SvgPicture.asset(svgAsset!, width: 20, height: 20);
    } else {
      leadingIcon = Icon(icon, size: 24, color: textColor);
    }

    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isDisabled ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          disabledForegroundColor:
              isDark ? AppColors.darkTextDisabled : AppColors.lightTextDisabled,
          minimumSize: const Size(0, 60),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxxl,
            vertical: AppSpacing.lg,
          ),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderPill),
          side: BorderSide(color: borderColor, width: 1.0),
          textStyle: AppTypography.button
              .copyWith(fontSize: AppTypography.sizeLg),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leadingIcon,
            const SizedBox(width: AppSpacing.md),
            Text(label),
          ],
        ),
      ),
    );
  }
}

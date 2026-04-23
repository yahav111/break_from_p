import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/app_state_provider.dart';
import '../../data/sync/sync_engine.dart';
import '../../design_system/design_system.dart';
import '../../infrastructure/auth/auth_provider.dart';
import '../../infrastructure/auth/auth_state.dart';
import '../../routing/route_names.dart';
import '../../shared/widgets/star_field.dart';
import 'widgets/auth_divider.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/social_sign_in_button.dart';

enum AuthMode { signUp, signIn }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key, this.initialMode = AuthMode.signUp});

  final AuthMode initialMode;

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  late bool _isSignIn;
  bool _wasAnonymous = false;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _navigating = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isSignIn = widget.initialMode == AuthMode.signIn;

    // In sign-up mode (post-paywall), trigger anonymous sign-in so that
    // subsequent auth calls perform account linking and preserve the UID.
    if (!_isSignIn) {
      Future.microtask(() {
        final authState = ref.read(authNotifierProvider);
        if (authState.status == AuthStatus.unauthenticated) {
          ref.read(authNotifierProvider.notifier).signInAnonymously();
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // Listen for auth status change → navigate on success.
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (prev?.status != AuthStatus.authenticated &&
          next.status == AuthStatus.authenticated &&
          !_navigating) {
        _completeAndNavigate();
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          _buildBackground(),
          const StarField(density: 80),
          _buildContent(authState),
        ],
      ),
    );
  }

  // ── Background ──────────────────────────────────────────────

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1A0A40), Color(0xFF0A0D2E), Color(0xFF0A0D2E)],
          stops: [0, 0.5, 1],
        ),
      ),
    );
  }

  // ── Content ──────────────────────────────────────────────────

  Widget _buildContent(AuthState authState) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xxxxxl),
            _buildHeadline(),
            const SizedBox(height: AppSpacing.sm),
            _buildSubtitle(),
            const SizedBox(height: AppSpacing.xxl),
            if (authState.error != null && authState.error!.isNotEmpty)
              _buildError(authState.error!),
            _buildEmailForm(),
            const SizedBox(height: AppSpacing.lg),
            _buildSubmitButton(authState),
            if (_isSignIn) ...[
              const SizedBox(height: AppSpacing.sm),
              _buildForgotPassword(),
            ],
            const SizedBox(height: AppSpacing.xxl),
            const AuthDivider(),
            const SizedBox(height: AppSpacing.xxl),
            _buildSocialButtons(authState),
            const SizedBox(height: AppSpacing.xxl),
            _buildModeToggle(),
            const SizedBox(height: AppSpacing.md),
            _buildSkipButton(authState),
            const SizedBox(height: AppSpacing.xxxxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return Text(
      _isSignIn ? 'ברוך שובך' : 'צור\nחשבון',
      style: AppTypography.displayLarge.copyWith(
        color: Colors.white,
        fontSize: 36,
        height: 1.15,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      _isSignIn
          ? 'התחבר כדי לשחזר את ההתקדמות שלך.'
          : 'אבטח את ההתקדמות שלך\nוגש אליה מכל מכשיר.',
      style: AppTypography.bodyMedium.copyWith(
        color: AppColors.darkTextSecondary,
        height: 1.5,
      ),
    );
  }

  Widget _buildError(String message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Text(
          message,
          style: AppTypography.bodySmall.copyWith(color: AppColors.error),
        ),
      ),
    );
  }

  // ── Form ──────────────────────────────────────────────────

  Widget _buildEmailForm() {
    return Column(
      children: [
        AuthTextField(
          controller: _emailController,
          label: 'אימייל',
          hintText: 'your@email.com',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: AppSpacing.md),
        AuthTextField(
          controller: _passwordController,
          label: 'סיסמה',
          hintText: 'לפחות 8 תווים',
          obscureText: !_isPasswordVisible,
          textInputAction:
              _isSignIn ? TextInputAction.done : TextInputAction.next,
          onToggleObscure: () =>
              setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        if (!_isSignIn) ...[
          const SizedBox(height: AppSpacing.md),
          AuthTextField(
            controller: _confirmPasswordController,
            label: 'אימות סיסמה',
            hintText: 'הזן שוב את הסיסמה',
            obscureText: !_isConfirmPasswordVisible,
            textInputAction: TextInputAction.done,
            onToggleObscure: () => setState(
                () => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
          ),
        ],
      ],
    );
  }

  // ── Buttons ──────────────────────────────────────────────────

  Widget _buildSubmitButton(AuthState authState) {
    return GradientButton(
      label: _isSignIn ? 'התחבר' : 'צור חשבון',
      isFullWidth: true,
      size: AppButtonSize.large,
      onPressed: authState.isLoading ? null : _onSubmit,
    );
  }

  Widget _buildForgotPassword() {
    return Center(
      child: AppButton(
        label: 'שכחת סיסמה?',
        variant: AppButtonVariant.ghost,
        size: AppButtonSize.small,
        onPressed: _showForgotPasswordSheet,
      ),
    );
  }

  Widget _buildSocialButtons(AuthState authState) {
    return Column(
      children: [
        SocialSignInButton(
          label: 'המשך עם Google',
          svgAsset: 'assets/icons/google_logo.svg',
          isLoading: authState.isGoogleLoading,
          onPressed: authState.isLoading ? null : () {
            _wasAnonymous =
                ref.read(authNotifierProvider).status == AuthStatus.anonymous;
            ref.read(authNotifierProvider.notifier).signInWithGoogle();
          },
        ),
        if (Platform.isIOS) ...[
          const SizedBox(height: AppSpacing.md),
          SocialSignInButton(
            label: 'המשך עם Apple',
            svgAsset: 'assets/icons/apple_logo.svg',
            isLoading: authState.isAppleLoading,
            onPressed: authState.isLoading ? null : () {
              _wasAnonymous =
                  ref.read(authNotifierProvider).status == AuthStatus.anonymous;
              ref.read(authNotifierProvider.notifier).signInWithApple();
            },
          ),
        ],
      ],
    );
  }

  Widget _buildModeToggle() {
    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() => _isSignIn = !_isSignIn);
          ref.read(authNotifierProvider.notifier).clearError();
        },
        child: RichText(
          text: TextSpan(
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.darkTextSecondary,
            ),
            children: [
              TextSpan(
                text: _isSignIn ? 'חדש כאן? ' : 'כבר יש לך חשבון? ',
              ),
              TextSpan(
                text: _isSignIn ? 'צור חשבון' : 'התחבר',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: AppTypography.semiBold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkipButton(AuthState authState) {
    return Center(
      child: AppButton(
        label: 'אולי מאוחר יותר',
        variant: AppButtonVariant.ghost,
        size: AppButtonSize.medium,
        onPressed: authState.isLoading
            ? null
            : () async {
                _wasAnonymous = true;
                // Ensure anonymous sign-in has completed before migrating.
                final currentAuth = ref.read(authNotifierProvider);
                if (currentAuth.status == AuthStatus.unauthenticated) {
                  await ref
                      .read(authNotifierProvider.notifier)
                      .signInAnonymously();
                }
                _completeAndNavigate();
              },
      ),
    );
  }

  // ── Actions ──────────────────────────────────────────────────

  void _onSubmit() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || !email.contains('@')) {
      _showValidationError('נא להזין כתובת אימייל תקינה.');
      return;
    }
    if (password.length < 8) {
      _showValidationError('הסיסמה חייבת להכיל לפחות 8 תווים.');
      return;
    }
    if (!_isSignIn) {
      final confirm = _confirmPasswordController.text;
      if (password != confirm) {
        _showValidationError('הסיסמאות אינן תואמות.');
        return;
      }
    }

    _wasAnonymous =
        ref.read(authNotifierProvider).status == AuthStatus.anonymous;

    if (_isSignIn) {
      ref.read(authNotifierProvider.notifier).signInWithEmail(email, password);
    } else {
      ref.read(authNotifierProvider.notifier).signUpWithEmail(email, password);
    }
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _completeAndNavigate() async {
    if (_navigating) return;
    _navigating = true;

    await ref.read(appStateNotifierProvider.notifier).completeOnboarding();

    try {
      if (_wasAnonymous) {
        await ref.read(syncEngineProvider.notifier).migrateLocalToCloud();
      } else {
        await ref.read(syncEngineProvider.notifier).pullFromCloud();
      }
    } catch (_) {
      // Sync failure should not block navigation.
    }

    if (mounted) context.go(Routes.home);
  }

  void _showForgotPasswordSheet() {
    final resetEmailController = TextEditingController();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.darkCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.large),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.xxl,
            AppSpacing.xxl,
            AppSpacing.xxl,
            MediaQuery.of(context).viewInsets.bottom + AppSpacing.xxl,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'איפוס סיסמה',
                style: AppTypography.headlineMedium.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'הזן את האימייל שלך ונשלח לך קישור לאיפוס.',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              AuthTextField(
                controller: resetEmailController,
                label: 'אימייל',
                hintText: 'your@email.com',
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: AppSpacing.lg),
              GradientButton(
                label: 'שלח קישור לאיפוס',
                isFullWidth: true,
                size: AppButtonSize.large,
                onPressed: () async {
                  final email = resetEmailController.text.trim();
                  if (email.isEmpty || !email.contains('@')) return;

                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(this.context);

                  await ref
                      .read(authNotifierProvider.notifier)
                      .sendPasswordResetEmail(email);

                  if (context.mounted) {
                    navigator.pop();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('אימייל לאיפוס סיסמה נשלח. בדוק את תיבת הדואר הנכנס.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }
}

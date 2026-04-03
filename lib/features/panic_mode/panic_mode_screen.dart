import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../core/services/camera_service.dart';
import '../../design_system/design_system.dart';
import 'widgets/camera_mirror.dart';
import 'widgets/coping_tools.dart';
import 'widgets/motivation_overlay.dart';
import 'widgets/reasons_display.dart';
import 'widgets/relapse_flow.dart';
import 'widgets/side_effects_cards.dart';

enum _PanicState { main, coping, relapse }

/// Panic mode intervention shown as a bottom sheet.
/// Header with QUITTR branding + Panic Button title,
/// rounded camera card with motivational text banner,
/// side effects list, and two action buttons.
class PanicModeScreen extends StatefulWidget {
  const PanicModeScreen({super.key});

  /// Show panic mode as a modal bottom sheet.
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const FractionallySizedBox(
        heightFactor: 1,
        child: PanicModeScreen(),
      ),
    );
  }

  @override
  State<PanicModeScreen> createState() => _PanicModeScreenState();
}

class _PanicModeScreenState extends State<PanicModeScreen> {
  final _cameraService = CameraService();
  CameraController? _cameraController;
  bool _cameraLoading = true;
  _PanicState _state = _PanicState.main;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final controller = await _cameraService.initFrontCamera();
      if (mounted) {
        setState(() {
          _cameraController = controller;
          _cameraLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _cameraLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF080B22),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      clipBehavior: Clip.antiAlias,
      child: switch (_state) {
        _PanicState.main => _buildMainView(context),
        _PanicState.coping => _buildCopingView(),
        _PanicState.relapse => _buildRelapseView(),
      },
    );
  }

  Widget _buildMainView(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // ── Drag handle ──
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.3),
                    borderRadius: AppRadius.borderCircular,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Header: QUITTR + X button ──
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Row(
                children: [
                  const Spacer(),
                  Text(
                    'QUITTR',
                    style: AppTypography.titleLarge.copyWith(
                      color: Colors.white,
                      fontWeight: AppTypography.bold,
                      letterSpacing: 3,
                    ),
                  ),
                  const Spacer(),
                  // X button top-right.
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.overlayWhiteMedium,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

              // ── "Panic Button" subtitle ──
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Panic Button',
                style: AppTypography.headlineSmall.copyWith(
                  color: AppColors.error,
                  fontWeight: AppTypography.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // ── Camera card with motivation banner ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: _buildCameraCard(),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Reasons for quitting ──
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: ReasonsDisplay(),
              ),

              // ── Side Effects of Relapsing ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    Center(
                      child: Text(
                        'Side Effects of Relapsing',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.darkTextTertiary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const SideEffectsCards(),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxl),

              // ── Action buttons ──
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  children: [
                    // "I'm thinking of relapsing" — prominent red.
                    GestureDetector(
                      onTap: () =>
                          setState(() => _state = _PanicState.coping),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: AppRadius.borderPill,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.warning_rounded,
                                color: Colors.white, size: 18),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              "I'm thinking of relapsing",
                              style: AppTypography.button
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    // "I Relapsed" — subtle grey.
                    GestureDetector(
                      onTap: () =>
                          setState(() => _state = _PanicState.relapse),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: AppColors.overlayWhiteSubtle,
                          borderRadius: AppRadius.borderPill,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.refresh_rounded,
                                color: AppColors.darkTextSecondary,
                                size: 18),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'I Relapsed',
                              style: AppTypography.button.copyWith(
                                color: AppColors.darkTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xxxxl),
            ],
          ),
        ),
    );
  }

  /// Rounded camera card with motivational text banner at the bottom.
  Widget _buildCameraCard() {
    return ClipRRect(
      borderRadius: AppRadius.borderExtraLarge,
      child: SizedBox(
        height: 420,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Camera feed, simulated mirror, or loading.
            if (_cameraLoading)
              _buildCameraPlaceholder()
            else if (_cameraController != null)
              CameraMirror(controller: _cameraController!)
            else
              _buildSimulatedMirror(),

            // Motivation text banner pinned to the bottom of the card.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.lg,
                  horizontal: AppSpacing.xl,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xDD000000),
                      Color(0x88000000),
                      Colors.transparent,
                    ],
                    stops: [0.0, 0.6, 1.0],
                  ),
                ),
                child: const MotivationOverlay(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPlaceholder() {
    return Container(
      color: AppColors.darkCard,
      child: Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );
  }

  /// Simulated selfie mirror for simulator / no-camera mode.
  Widget _buildSimulatedMirror() {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.2),
          radius: 0.85,
          colors: [
            Color(0xFF4A4260),
            Color(0xFF2A2540),
            Color(0xFF141020),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          size: 200,
          color: Colors.white.withValues(alpha: 0.07),
        ),
      ),
    );
  }

  Widget _buildCopingView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: CopingTools(
            onBack: () => setState(() => _state = _PanicState.main),
          ),
        ),
      ),
    );
  }

  Widget _buildRelapseView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A0D2E), Color(0xFF080B22)],
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: RelapseFlow(
            onBack: () => setState(() => _state = _PanicState.main),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../design_system/design_system.dart';
import 'lesson_player_screen.dart';

/// Instagram-style video preview tile — shows the first frame and a play icon.
/// Tapping opens a full-screen player.
class CourseLessonCard extends StatefulWidget {
  const CourseLessonCard({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.videoAsset,
    required this.durationLabel,
  });

  final int index;
  final String title;
  final String subtitle;
  final String videoAsset;
  final String durationLabel;

  @override
  State<CourseLessonCard> createState() => _CourseLessonCardState();
}

class _CourseLessonCardState extends State<CourseLessonCard> {
  VideoPlayerController? _previewController;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    final c = VideoPlayerController.asset(widget.videoAsset);
    try {
      await c.initialize();
      await c.setVolume(0);
      await c.seekTo(Duration.zero);
    } catch (_) {
      // ignore — fallback will show placeholder
    }
    if (!mounted) {
      c.dispose();
      return;
    }
    _previewController = c;
    setState(() => _ready = true);
  }

  @override
  void dispose() {
    _previewController?.dispose();
    super.dispose();
  }

  void _openPlayer() {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => LessonPlayerScreen(
          videoAsset: widget.videoAsset,
          title: widget.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openPlayer,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildPreview(),
            _buildGradientOverlay(),
            _buildPlayIcon(),
            _buildTextOverlay(),
            _buildIndexBadge(),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    final c = _previewController;
    if (_ready && c != null && c.value.isInitialized) {
      return FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: c.value.size.width,
          height: c.value.size.height,
          child: VideoPlayer(c),
        ),
      );
    }
    return Container(
      color: AppColors.darkElevated,
      alignment: Alignment.center,
      child: const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.15),
            Colors.transparent,
            Colors.black.withValues(alpha: 0.75),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildPlayIcon() {
    return Center(
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.85)),
        ),
        alignment: Alignment.center,
        child: const Padding(
          padding: EdgeInsets.only(left: 3),
          child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  Widget _buildTextOverlay() {
    return Positioned(
      left: AppSpacing.sm,
      right: AppSpacing.sm,
      bottom: AppSpacing.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.titleSmall.copyWith(
              color: Colors.white,
              fontWeight: AppTypography.bold,
              shadows: const [
                Shadow(color: Colors.black54, blurRadius: 4),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            widget.durationLabel,
            style: AppTypography.bodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              shadows: const [
                Shadow(color: Colors.black54, blurRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndexBadge() {
    return Positioned(
      top: AppSpacing.sm,
      left: AppSpacing.sm,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        child: Text(
          '${widget.index + 1}',
          style: AppTypography.bodySmall.copyWith(
            color: Colors.white,
            fontWeight: AppTypography.bold,
          ),
        ),
      ),
    );
  }
}

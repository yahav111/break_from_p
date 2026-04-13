import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../../../design_system/design_system.dart';

/// Full-screen lesson video player.
class LessonPlayerScreen extends StatefulWidget {
  const LessonPlayerScreen({
    super.key,
    required this.videoAsset,
    required this.title,
  });

  final String videoAsset;
  final String title;

  @override
  State<LessonPlayerScreen> createState() => _LessonPlayerScreenState();
}

class _LessonPlayerScreenState extends State<LessonPlayerScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final vc = VideoPlayerController.asset(widget.videoAsset);
    await vc.initialize();
    if (!mounted) {
      vc.dispose();
      return;
    }
    _videoController = vc;
    _chewieController = ChewieController(
      videoPlayerController: vc,
      autoPlay: true,
      looping: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.primary,
        handleColor: AppColors.primary,
        bufferedColor: AppColors.primary.withValues(alpha: 0.3),
        backgroundColor: AppColors.darkElevated,
      ),
    );
    setState(() {});
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _chewieController != null;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(widget.title, style: AppTypography.titleSmall),
        elevation: 0,
      ),
      body: Center(
        child: ready
            ? Chewie(controller: _chewieController!)
            : const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
      ),
    );
  }
}

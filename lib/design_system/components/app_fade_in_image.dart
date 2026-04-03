import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// תמונת רשת או asset שנטענת עם אנימציית fade-in (לא מופיעה מיידית).
class AppFadeInImage extends StatefulWidget {
  const AppFadeInImage({
    super.key,
    this.imageUrl,
    this.imageAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.duration = const Duration(milliseconds: 280),
    this.placeholderColor,
    this.errorBuilder,
  }) : assert(
         imageUrl != null || imageAsset != null,
         'נדרש imageUrl או imageAsset',
       );

  final String? imageUrl;
  final String? imageAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Duration duration;
  final Color? placeholderColor;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  State<AppFadeInImage> createState() => _AppFadeInImageState();
}

class _AppFadeInImageState extends State<AppFadeInImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final placeholderColor = widget.placeholderColor ??
        (isDark ? AppColors.darkBorder : AppColors.lightBorder);

    if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      return Image.network(
        widget.imageUrl!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame == null) {
            return Container(
              width: widget.width,
              height: widget.height,
              color: placeholderColor,
            );
          }
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return _FadeInWrap(
            animation: _animation,
            controller: _controller,
            child: child,
          );
        },
        errorBuilder: widget.errorBuilder,
      );
    }

    if (widget.imageAsset != null && widget.imageAsset!.isNotEmpty) {
      return Image.asset(
        widget.imageAsset!,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (frame == null) {
            return Container(
              width: widget.width,
              height: widget.height,
              color: placeholderColor,
            );
          }
          if (wasSynchronouslyLoaded) {
            return child;
          }
          return _FadeInWrap(
            animation: _animation,
            controller: _controller,
            child: child,
          );
        },
        errorBuilder: widget.errorBuilder,
      );
    }

    return const SizedBox.shrink();
  }
}

class _FadeInWrap extends StatefulWidget {
  const _FadeInWrap({
    required this.animation,
    required this.controller,
    required this.child,
  });

  final Animation<double> animation;
  final AnimationController controller;
  final Widget child;

  @override
  State<_FadeInWrap> createState() => _FadeInWrapState();
}

class _FadeInWrapState extends State<_FadeInWrap> {
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_started) {
      _started = true;
      widget.controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: widget.animation,
      child: widget.child,
    );
  }
}

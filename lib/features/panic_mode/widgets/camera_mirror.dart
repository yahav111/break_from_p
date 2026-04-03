import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Camera preview showing the front camera as a mirrored selfie.
/// Fills all available space via FittedBox cover.
/// Parent is responsible for clipping (ClipRRect).
class CameraMirror extends StatelessWidget {
  const CameraMirror({
    super.key,
    required this.controller,
  });

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: controller.value.previewSize?.height ?? 1,
        height: controller.value.previewSize?.width ?? 1,
        child: Transform.flip(
          flipX: true,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

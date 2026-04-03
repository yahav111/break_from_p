import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

/// Wraps the camera package for Panic Mode's selfie mirror.
/// Returns null if camera is unavailable or permission denied.
class CameraService {
  CameraController? _controller;

  /// Checks if camera permission is granted.
  Future<bool> isPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Requests camera permission.
  Future<bool> requestPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Initializes the front camera and returns the controller.
  /// Returns null if no front camera or permission denied.
  Future<CameraController?> initFrontCamera() async {
    final granted = await requestPermission();
    if (!granted) return null;

    final cameras = await availableCameras();
    final front = cameras.where(
      (c) => c.lensDirection == CameraLensDirection.front,
    );

    if (front.isEmpty) return null;

    _controller = CameraController(
      front.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    return _controller;
  }

  /// Disposes the camera controller.
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }
}

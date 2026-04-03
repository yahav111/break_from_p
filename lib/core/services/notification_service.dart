import 'package:permission_handler/permission_handler.dart';

/// Wraps permission_handler for notification permission requests.
class NotificationService {
  /// Requests notification permission from the OS.
  /// Returns `true` if permission was granted.
  Future<bool> requestPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  /// Checks current notification permission status.
  Future<bool> isGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }
}

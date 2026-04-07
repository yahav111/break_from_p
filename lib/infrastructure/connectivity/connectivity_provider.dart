import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'connectivity_service.dart';

/// Provides the [ConnectivityService] singleton.
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

/// Streams whether the device currently has network connectivity.
final isOnlineProvider = StreamProvider<bool>((ref) {
  final service = ref.read(connectivityServiceProvider);
  return service.onConnectivityChanged.map(
    (results) => !results.contains(ConnectivityResult.none),
  );
});

/// Synchronous snapshot of last-known connectivity state.
/// Falls back to `true` (assume online) if no stream value yet.
final isOnlineValueProvider = Provider<bool>((ref) {
  return ref.watch(isOnlineProvider).valueOrNull ?? true;
});

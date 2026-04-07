enum SyncState {
  /// No sync activity.
  idle,

  /// Sync operation in progress.
  syncing,

  /// Last sync completed successfully.
  synced,

  /// Last sync failed.
  error,

  /// Device is offline.
  offline,
}

class SyncStatus {
  const SyncStatus({
    this.state = SyncState.idle,
    this.lastSyncedAt,
    this.migrationCompleted = false,
    this.error,
  });

  final SyncState state;
  final DateTime? lastSyncedAt;
  final bool migrationCompleted;
  final String? error;

  SyncStatus copyWith({
    SyncState? state,
    DateTime? lastSyncedAt,
    bool? migrationCompleted,
    String? error,
  }) {
    return SyncStatus(
      state: state ?? this.state,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      migrationCompleted: migrationCompleted ?? this.migrationCompleted,
      error: error ?? this.error,
    );
  }
}

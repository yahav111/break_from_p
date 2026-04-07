import '../contracts/data_repository.dart';

/// Composite repository that reads from local (Hive) and writes
/// to both local and remote (Firestore) when online.
///
/// This is the key enabler for offline-first with cloud sync:
/// - [get] always returns from [local] (synchronous, zero latency)
/// - [save] writes to [local] first, then attempts [remote]
/// - [delete] removes from both sources
class SyncedRepository<T> implements DataRepository<T> {
  SyncedRepository({
    required this.local,
    required this.remote,
    required this.isOnline,
  });

  final DataRepository<T> local;
  final DataRepository<T> remote;
  final bool Function() isOnline;

  @override
  T? get() => local.get();

  @override
  Future<void> save(T data) async {
    await local.save(data);
    if (isOnline()) {
      try {
        await remote.save(data);
      } catch (_) {
        // Firestore write failed (offline or transient error).
        // Data is safe in Hive. SyncEngine will push on reconnect.
      }
    }
  }

  @override
  Future<void> delete() async {
    await local.delete();
    if (isOnline()) {
      try {
        await remote.delete();
      } catch (_) {
        // Best-effort remote delete.
      }
    }
  }
}

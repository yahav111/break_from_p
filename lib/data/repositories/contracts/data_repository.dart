/// Abstract contract for data repositories.
///
/// All repository implementations (Hive, Firestore, Synced) must
/// conform to this interface. [get] is synchronous — the SyncedRepository
/// always reads from the local (Hive) cache, so existing Notifiers
/// and UI code require zero changes.
abstract class DataRepository<T> {
  /// Returns the current stored value, or null if none exists.
  /// Always reads from local cache (synchronous).
  T? get();

  /// Persists the value, replacing any existing data.
  Future<void> save(T data);

  /// Deletes the stored value.
  Future<void> delete();
}

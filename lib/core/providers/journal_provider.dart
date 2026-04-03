import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/journal_repository.dart';
import '../models/journal_data.dart';
import '../models/journal_entry.dart';

/// Provided via ProviderScope.overrides at bootstrap.
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  throw UnimplementedError('journalRepositoryProvider must be overridden');
});

final journalNotifierProvider =
    NotifierProvider<JournalNotifier, JournalData?>(JournalNotifier.new);

class JournalNotifier extends Notifier<JournalData?> {
  @override
  JournalData? build() {
    final repo = ref.read(journalRepositoryProvider);
    return repo.get();
  }

  Future<void> addEntry({
    required String content,
    required int mood,
    String? prompt,
  }) async {
    final current = state ?? JournalData();
    final now = DateTime.now();

    final entry = JournalEntry(
      id: now.microsecondsSinceEpoch.toString(),
      date: now,
      content: content,
      mood: mood,
      prompt: prompt,
      createdAt: now,
      updatedAt: now,
    );

    final updated = current.copyWith(
      entries: [entry, ...current.entries],
    );

    final repo = ref.read(journalRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }

  Future<void> updateEntry(
    String id, {
    String? content,
    int? mood,
  }) async {
    final current = state;
    if (current == null) return;

    final entries = current.entries.map((e) {
      if (e.id != id) return e;
      return e.copyWith(
        content: content,
        mood: mood,
        updatedAt: DateTime.now(),
      );
    }).toList();

    final updated = current.copyWith(entries: entries);

    final repo = ref.read(journalRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }

  Future<void> deleteEntry(String id) async {
    final current = state;
    if (current == null) return;

    final entries = current.entries.where((e) => e.id != id).toList();
    final updated = current.copyWith(entries: entries);

    final repo = ref.read(journalRepositoryProvider);
    await repo.save(updated);
    state = updated;
  }
}

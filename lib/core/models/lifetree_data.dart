import 'package:hive/hive.dart';

part 'lifetree_data.g.dart';

/// Persisted state for the Lifetree — tracks which nodes are unlocked.
@HiveType(typeId: 17)
class LifetreeData extends HiveObject {
  LifetreeData({
    this.unlockedNodeIds = const [],
  });

  @HiveField(0)
  final List<String> unlockedNodeIds;

  LifetreeData copyWith({
    List<String>? unlockedNodeIds,
  }) {
    return LifetreeData(
      unlockedNodeIds: unlockedNodeIds ?? this.unlockedNodeIds,
    );
  }
}

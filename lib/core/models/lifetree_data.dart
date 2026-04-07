import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'lifetree_data.g.dart';

/// Persisted state for the Lifetree — tracks which nodes are unlocked.
@HiveType(typeId: 17)
@JsonSerializable()
class LifetreeData extends HiveObject {
  LifetreeData({
    this.unlockedNodeIds = const [],
    this.updatedAt,
  });

  @HiveField(0)
  final List<String> unlockedNodeIds;

  @HiveField(1)
  final DateTime? updatedAt;

  factory LifetreeData.fromJson(Map<String, dynamic> json) =>
      _$LifetreeDataFromJson(json);
  Map<String, dynamic> toJson() => _$LifetreeDataToJson(this);

  LifetreeData copyWith({
    List<String>? unlockedNodeIds,
    DateTime? updatedAt,
  }) {
    return LifetreeData(
      unlockedNodeIds: unlockedNodeIds ?? this.unlockedNodeIds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

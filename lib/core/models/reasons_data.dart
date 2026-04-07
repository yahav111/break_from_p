import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reasons_data.g.dart';

@HiveType(typeId: 6)
@JsonSerializable()
class ReasonsData extends HiveObject {
  ReasonsData({
    this.reasons = const [],
    this.updatedAt,
  });

  /// User's personal reasons for quitting, in display order.
  @HiveField(0)
  final List<String> reasons;

  @HiveField(1)
  final DateTime? updatedAt;

  factory ReasonsData.fromJson(Map<String, dynamic> json) =>
      _$ReasonsDataFromJson(json);
  Map<String, dynamic> toJson() => _$ReasonsDataToJson(this);

  ReasonsData copyWith({
    List<String>? reasons,
    DateTime? updatedAt,
  }) {
    return ReasonsData(
      reasons: reasons ?? this.reasons,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

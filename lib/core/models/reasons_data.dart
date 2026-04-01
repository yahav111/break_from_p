import 'package:hive/hive.dart';

part 'reasons_data.g.dart';

@HiveType(typeId: 6)
class ReasonsData extends HiveObject {
  ReasonsData({
    this.reasons = const [],
  });

  /// User's personal reasons for quitting, in display order.
  @HiveField(0)
  final List<String> reasons;

  ReasonsData copyWith({
    List<String>? reasons,
  }) {
    return ReasonsData(
      reasons: reasons ?? this.reasons,
    );
  }
}

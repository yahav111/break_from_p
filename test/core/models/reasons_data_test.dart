import 'package:flutter_test/flutter_test.dart';
import 'package:quitter/core/models/reasons_data.dart';

void main() {
  group('ReasonsData', () {
    test('default has empty reasons', () {
      final data = ReasonsData();
      expect(data.reasons, isEmpty);
    });

    test('copyWith replaces reasons list', () {
      final data = ReasonsData(reasons: ['a', 'b']);
      final updated = data.copyWith(reasons: ['c']);
      expect(updated.reasons, ['c']);
    });

    test('copyWith preserves reasons when not provided', () {
      final data = ReasonsData(reasons: ['a', 'b']);
      final updated = data.copyWith();
      expect(updated.reasons, ['a', 'b']);
    });
  });
}

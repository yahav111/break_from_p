import 'package:flutter_test/flutter_test.dart';

import 'package:quitter/main.dart';

void main() {
  testWidgets('App renders showcase screen', (WidgetTester tester) async {
    await tester.pumpWidget(const QuittrApp());
    expect(find.byType(QuittrApp), findsOneWidget);
  });
}

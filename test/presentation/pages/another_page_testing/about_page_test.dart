import 'package:ditonton/presentation/pages/about_page/about_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget _createTestableWidget(Widget body) {
    return MaterialApp(
      home: Scaffold(
        body: body,
      ),
    );
  }

  testWidgets(
    'Should showing Stack of Widgets',
    (WidgetTester tester) async {
      await tester.pumpWidget(_createTestableWidget(AboutPage()));
      await tester.pump();

      expect(find.byType(Stack), findsWidgets);
    },
  );
}

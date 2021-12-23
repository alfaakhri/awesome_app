import 'package:awesome_app/awesome_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  group('Module main', () {
    testWidgets('Testing search Awesome App', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MyApp());

        expect(find.text("Awesome App"), findsWidgets);
      });
    });
  });
}

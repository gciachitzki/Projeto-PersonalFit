import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:personalFitApp/main.dart';

void main() {
  testWidgets('PersonalFit app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PersonalFitApp());

    // Verify that the app loads without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

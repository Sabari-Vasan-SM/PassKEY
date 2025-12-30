import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:passkey/main.dart';

void main() {
  testWidgets('PassKEY app launches successfully', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that splash screen appears
    await tester.pump();

    // Wait for potential animations
    await tester.pumpAndSettle();

    // The test passes if the app builds without errors
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

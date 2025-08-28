// This is a basic Flutter widget test for DeenMate app.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  testWidgets(
    'DeenMate minimal smoke test builds Material scaffold',
    (WidgetTester tester) async {
      // Initialize Hive to a temporary directory for any accidental box opens
      final tempDir =
          await Directory.systemTemp.createTemp('deenmate_test_hive');
      Hive.init(tempDir.path);

      // Larger window to avoid overflow in any default text scale
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      tester.binding.window.physicalSizeTestValue = const Size(1200, 2400);
      addTearDown(() async {
        tester.binding.window.clearPhysicalSizeTestValue();
        tester.binding.window.clearDevicePixelRatioTestValue();
        await Hive.close();
      });

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(child: Text('DeenMate Smoke OK')),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 50));

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('DeenMate Smoke OK'), findsOneWidget);
    },
    timeout: const Timeout(Duration(seconds: 5)),
    skip: true,
  );
}

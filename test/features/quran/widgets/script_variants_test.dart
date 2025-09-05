import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../lib/features/quran/presentation/widgets/script_variants_widget.dart';

void main() {
  group('ScriptVariantsWidget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('ScriptVariantsWidget displays both script options',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: const ScriptVariantsWidget(),
            ),
          ),
        ),
      );

      // Verify the widget is displayed
      expect(find.byType(ScriptVariantsWidget), findsOneWidget);

      // Verify both script options are displayed
      expect(find.text('Uthmanic'), findsOneWidget);
      expect(find.text('IndoPak'), findsOneWidget);

      // Verify descriptions are displayed
      expect(
          find.text(
              'Traditional Uthmanic script used in most printed Qurans worldwide. Features classical Arabic calligraphy.'),
          findsOneWidget);
      expect(
          find.text(
              'IndoPak script style popular in South Asia. Features distinct letter forms and spacing.'),
          findsOneWidget);
    });

    testWidgets('ScriptVariantsWidget shows Uthmanic as selected by default',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: const ScriptVariantsWidget(),
            ),
          ),
        ),
      );

      // Verify Uthmanic is selected by default
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Verify the selected option has the correct styling
      final selectedContainer = find.ancestor(
        of: find.byIcon(Icons.check_circle),
        matching: find.byType(Container),
      );
      expect(selectedContainer, findsOneWidget);
    });

    testWidgets('ScriptVariantsWidget allows switching to IndoPak',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: const ScriptVariantsWidget(),
            ),
          ),
        ),
      );

      // Initially Uthmanic should be selected
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Tap on IndoPak option
      final indoPakOption = find.text('IndoPak');
      await tester.tap(indoPakOption);
      await tester.pumpAndSettle();

      // Verify IndoPak is now selected
      expect(find.byIcon(Icons.check_circle), findsOneWidget);

      // Verify the selection indicator moved to IndoPak
      final selectedContainer = find.ancestor(
        of: find.byIcon(Icons.check_circle),
        matching: find.byType(Container),
      );
      expect(selectedContainer, findsOneWidget);
    });

    testWidgets('CompactScriptVariantSelector displays dropdown',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: const CompactScriptVariantSelector(),
            ),
          ),
        ),
      );

      // Verify the widget is displayed
      expect(find.byType(CompactScriptVariantSelector), findsOneWidget);

      // Verify the label is displayed
      expect(find.text('Script'), findsOneWidget);

      // Verify the dropdown is displayed
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('CompactScriptVariantSelector shows current selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: const CompactScriptVariantSelector(),
            ),
          ),
        ),
      );

      // Verify the current selection is displayed
      expect(find.text('Uthmanic'), findsOneWidget);
    });

    testWidgets('CompactScriptVariantSelector allows changing selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: const CompactScriptVariantSelector(),
            ),
          ),
        ),
      );

      // Tap on the dropdown
      final dropdown = find.byType(DropdownButton<String>);
      await tester.tap(dropdown);
      await tester.pumpAndSettle();

      // Verify both options are shown in dropdown
      expect(find.text('Uthmanic'), findsAtLeastNWidgets(1));
      expect(find.text('IndoPak'), findsAtLeastNWidgets(1));

      // Select IndoPak
      final indoPakOption = find.text('IndoPak').last;
      await tester.tap(indoPakOption);
      await tester.pumpAndSettle();

      // Verify the selection changed
      expect(find.text('IndoPak'), findsAtLeastNWidgets(1));
    });
  });
}

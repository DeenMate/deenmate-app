import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deen_mate/features/quran/presentation/widgets/mobile_font_controls.dart';
import 'package:deen_mate/features/quran/presentation/widgets/mobile_font_controls_button.dart';
import 'package:deen_mate/features/quran/presentation/state/providers.dart';
import 'package:deen_mate/l10n/generated/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  group('Mobile Font Controls', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    Widget createTestWidget(Widget child) {
      return UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: child,
          ),
        ),
      );
    }

    testWidgets('MobileFontControls displays correctly in compact mode', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const MobileFontControls(
            isCompact: true,
            showPreview: false,
          ),
        ),
      );

      // Wait for widget to fully render
      await tester.pumpAndSettle();

      // Verify basic elements are present
      expect(find.text('Font Controls'), findsOneWidget);
      expect(find.text('Arabic Text'), findsOneWidget);
      expect(find.text('Translation'), findsOneWidget);
      expect(find.text('Reset Font Sizes'), findsOneWidget);
    });

    testWidgets('MobileFontControls displays correctly in full mode', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const MobileFontControls(
            isCompact: false,
            showPreview: true,
          ),
        ),
      );

      // Wait for widget to fully render
      await tester.pumpAndSettle();

      // Verify full mode elements are present
      expect(find.text('Font Controls'), findsOneWidget);
      expect(find.text('Arabic Text'), findsOneWidget);
      expect(find.text('Translation'), findsOneWidget);
      expect(find.text('Reset Font Sizes'), findsOneWidget);
      expect(find.text('Preview'), findsOneWidget);
      
      // Verify sliders are present
      expect(find.byType(Slider), findsNWidgets(2)); // Arabic and Translation sliders
    });

    testWidgets('Font size adjustment buttons work correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const MobileFontControls(
            isCompact: false,
            showPreview: false,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Get initial Arabic font size
      final initialPrefs = container.read(prefsProvider);
      final initialArabicSize = initialPrefs.arabicFontSize;

      // Find and tap the Arabic font increase button
      final arabicIncreaseButtons = find.descendant(
        of: find.ancestor(
          of: find.text('Arabic Text'),
          matching: find.byType(Column),
        ),
        matching: find.byIcon(Icons.add),
      );

      expect(arabicIncreaseButtons, findsAtLeastNWidgets(1));
      await tester.tap(arabicIncreaseButtons.first);
      await tester.pumpAndSettle();

      // Verify font size increased
      final updatedPrefs = container.read(prefsProvider);
      expect(updatedPrefs.arabicFontSize, greaterThan(initialArabicSize));
    });

    testWidgets('Reset button works correctly', (tester) async {
      // First, modify font sizes
      final prefsNotifier = container.read(prefsProvider.notifier);
      await prefsNotifier.updateArabicFontSize(30.0);
      await prefsNotifier.updateTranslationFontSize(20.0);

      await tester.pumpWidget(
        createTestWidget(
          const MobileFontControls(
            isCompact: true,
            showPreview: false,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify modified sizes
      final modifiedPrefs = container.read(prefsProvider);
      expect(modifiedPrefs.arabicFontSize, equals(30.0));
      expect(modifiedPrefs.translationFontSize, equals(20.0));

      // Tap reset button
      await tester.tap(find.text('Reset Font Sizes'));
      await tester.pumpAndSettle();

      // Verify sizes are reset (assuming default values)
      final resetPrefs = container.read(prefsProvider);
      // Note: Actual default values should be verified based on implementation
      expect(resetPrefs.arabicFontSize, lessThan(30.0));
      expect(resetPrefs.translationFontSize, lessThan(20.0));
    });

    testWidgets('MobileFontControlsButton renders correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const MobileFontControlsButton(
            isVisible: true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify button is present
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byIcon(Icons.format_size), findsOneWidget);
    });

    testWidgets('Font controls button toggles overlay', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const MobileFontControlsButton(
            isVisible: true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the font controls button
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Verify overlay appears (compact font controls)
      expect(find.byType(MobileFontControls), findsOneWidget);
      expect(find.text('Font Controls'), findsOneWidget);

      // Tap close button to dismiss
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      // Verify overlay is dismissed
      expect(find.byType(MobileFontControls), findsNothing);
    });

    testWidgets('QuickFontAdjustmentPanel renders when visible', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const QuickFontAdjustmentPanel(
            isVisible: true,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify panel elements are present
      expect(find.text('Arabic Text'), findsOneWidget);
      expect(find.text('Translation'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNWidgets(2)); // One for each font type
      expect(find.byIcon(Icons.remove), findsNWidgets(2)); // One for each font type
    });

    testWidgets('Font size display updates correctly', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          const MobileFontControls(
            isCompact: true,
            showPreview: false,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Get initial font size display
      final prefs = container.read(prefsProvider);
      expect(find.text('${prefs.arabicFontSize.toInt()}px'), findsOneWidget);
      expect(find.text('${prefs.translationFontSize.toInt()}px'), findsOneWidget);

      // Adjust font size
      final prefsNotifier = container.read(prefsProvider.notifier);
      await prefsNotifier.updateArabicFontSize(32.0);

      await tester.pumpAndSettle();

      // Verify display updates
      expect(find.text('32px'), findsOneWidget);
    });
  });

  group('Font Controls Integration', () {
    testWidgets('Font controls integrate with existing preference system', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Test that font controls properly read from and write to preferences
      final prefsNotifier = container.read(prefsProvider.notifier);
      
      // Set initial values
      await prefsNotifier.updateArabicFontSize(24.0);
      await prefsNotifier.updateTranslationFontSize(16.0);
      
      // Verify values are set
      final prefs = container.read(prefsProvider);
      expect(prefs.arabicFontSize, equals(24.0));
      expect(prefs.translationFontSize, equals(16.0));
      
      // Test font size constraints
      await prefsNotifier.updateArabicFontSize(100.0); // Should be clamped
      await prefsNotifier.updateTranslationFontSize(5.0); // Should be clamped
      
      final constrainedPrefs = container.read(prefsProvider);
      expect(constrainedPrefs.arabicFontSize, lessThanOrEqualTo(48.0));
      expect(constrainedPrefs.translationFontSize, greaterThanOrEqualTo(10.0));
    });
  });
}

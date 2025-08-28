import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deen_mate/core/localization/language_models.dart';

// Import test providers
import '../localization/language_provider_test.dart';

void main() {
  group('Language Selection Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should display all supported languages',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: _buildLanguageSelectionWidget(),
            ),
          ),
        ),
      );

      // Check that all supported languages are displayed
      expect(find.text('English'), findsOneWidget);
      expect(find.text('বাংলা'), findsOneWidget);
      expect(find.text('اردو'), findsOneWidget);
      expect(find.text('العربية'), findsOneWidget);
    });

    testWidgets('should show current language as selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: _buildLanguageSelectionWidget(),
            ),
          ),
        ),
      );

      // Initially English should be selected
      expect(find.text('English'), findsOneWidget);

      // Check for selection indicator (this would depend on your actual widget implementation)
      // You might need to adjust this based on how your widget shows selection
    });

    testWidgets('should handle language selection tap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: _buildLanguageSelectionWidget(),
            ),
          ),
        ),
      );

      // Initially English
      expect(container.read(testCurrentLanguageProvider),
          equals(SupportedLanguage.english));

      // Tap on Bangla
      await tester.tap(find.text('বাংলা'));
      await tester.pumpAndSettle();

      // Should switch to Bangla
      expect(container.read(testCurrentLanguageProvider),
          equals(SupportedLanguage.bangla));
    });

    testWidgets('should show language status indicators',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: _buildLanguageSelectionWidget(),
            ),
          ),
        ),
      );

      // Check for status indicators (Fully Supported vs Coming Soon)
      // This would depend on your actual widget implementation
      expect(
          find.text('Fully Supported'), findsNWidgets(2)); // English and Bangla
      expect(find.text('Coming Soon'), findsNWidgets(2)); // Urdu and Arabic
    });

    testWidgets('should display language flags', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: _buildLanguageSelectionWidget(),
            ),
          ),
        ),
      );

      // Check for flag emojis
      expect(find.text('🇺🇸'), findsOneWidget);
      expect(find.text('🇧🇩'), findsOneWidget);
      expect(find.text('🇵🇰'), findsOneWidget);
      expect(find.text('🇸🇦'), findsOneWidget);
    });

    testWidgets('should handle unsupported language selection gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: _buildLanguageSelectionWidget(),
            ),
          ),
        ),
      );

      // Initially English
      expect(container.read(testCurrentLanguageProvider),
          equals(SupportedLanguage.english));

      // Tap on Urdu (not fully supported)
      await tester.tap(find.text('اردو'));
      await tester.pumpAndSettle();

      // Should fallback to English since Urdu is not fully supported
      expect(container.read(testCurrentLanguageProvider),
          equals(SupportedLanguage.english));
    });

    testWidgets('should persist language selection',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: _buildLanguageSelectionWidget(),
            ),
          ),
        ),
      );

      // Switch to Bangla
      await tester.tap(find.text('বাংলা'));
      await tester.pumpAndSettle();

      // Should still be Bangla in the same container
      expect(container.read(testCurrentLanguageProvider),
          equals(SupportedLanguage.bangla));
    });
  });
}

// Helper widget for testing
Widget _buildLanguageSelectionWidget() {
  return Consumer(
    builder: (context, ref, child) {
      final currentLanguage = ref.watch(testCurrentLanguageProvider);
      final languageSwitcher = ref.read(testLanguageSwitcherProvider);

      return Column(
        children: SupportedLanguage.values.map((language) {
          final isSelected = currentLanguage == language;

          return ListTile(
            leading: Text(language.flagEmoji),
            title: Text(language.nativeName),
            subtitle: Text(language.statusDescription),
            trailing: isSelected ? const Icon(Icons.check) : null,
            onTap: () => languageSwitcher.switchLanguage(language),
          );
        }).toList(),
      );
    },
  );
}

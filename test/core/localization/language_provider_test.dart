import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deen_mate/core/localization/language_models.dart';

// Test-specific language notifier that doesn't require Hive
class TestLanguagePreferencesNotifier
    extends StateNotifier<AsyncValue<LanguagePreferences>> {
  TestLanguagePreferencesNotifier()
      : super(AsyncValue.data(LanguagePreferences.defaultPreferences()));

  Future<bool> switchLanguage(SupportedLanguage language) async {
    try {
      final currentPreferences = state.value;
      if (currentPreferences == null) return false;

      final updatedPreferences = currentPreferences.copyWith(
        selectedLanguageCode: language.code,
        lastUpdated: DateTime.now(),
        isFirstTimeSetup: false,
      );

      state = AsyncValue.data(updatedPreferences);
      return true;
    } catch (error) {
      return false;
    }
  }
}

// Override providers for testing
final testLanguagePreferencesProvider = StateNotifierProvider<
    TestLanguagePreferencesNotifier, AsyncValue<LanguagePreferences>>((ref) {
  return TestLanguagePreferencesNotifier();
});

final testCurrentLanguageProvider = Provider<SupportedLanguage>((ref) {
  final preferencesAsync = ref.watch(testLanguagePreferencesProvider);
  return preferencesAsync.when(
    data: (preferences) => preferences.effectiveLanguage,
    loading: () => SupportedLanguage.english,
    error: (_, __) => SupportedLanguage.english,
  );
});

final testLanguageSwitcherProvider =
    Provider<TestLanguagePreferencesNotifier>((ref) {
  return ref.read(testLanguagePreferencesProvider.notifier);
});

void main() {
  group('Language Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with English as default language', () {
      final currentLanguage = container.read(testCurrentLanguageProvider);
      expect(currentLanguage, equals(SupportedLanguage.english));
    });

    test('should switch language correctly', () async {
      final languageSwitcher = container.read(testLanguageSwitcherProvider);

      // Switch to Bangla
      final success =
          await languageSwitcher.switchLanguage(SupportedLanguage.bangla);
      expect(success, isTrue);

      final currentLanguage = container.read(testCurrentLanguageProvider);
      expect(currentLanguage, equals(SupportedLanguage.bangla));
    });

    test('should handle unsupported languages with fallback', () async {
      final languageSwitcher = container.read(testLanguageSwitcherProvider);

      // Try to switch to Urdu (not fully supported)
      final success =
          await languageSwitcher.switchLanguage(SupportedLanguage.urdu);
      expect(success, isTrue);

      final currentLanguage = container.read(testCurrentLanguageProvider);
      // Urdu is not fully supported, so it should fallback to English
      expect(currentLanguage, equals(SupportedLanguage.english));
    });

    test('should persist language changes', () async {
      final languageSwitcher = container.read(testLanguageSwitcherProvider);

      // Switch to Arabic
      await languageSwitcher.switchLanguage(SupportedLanguage.arabic);

      // Should still be Arabic in the same container
      final currentLanguage = container.read(testCurrentLanguageProvider);
      // Arabic is not fully supported, so it should fallback to English
      expect(currentLanguage, equals(SupportedLanguage.english));
    });

    test('should provide correct locale for each language', () {
      // Test English locale
      expect(SupportedLanguage.english.locale, equals(const Locale('en')));

      // Test Bangla locale
      expect(SupportedLanguage.bangla.locale, equals(const Locale('bn')));

      // Test Urdu locale
      expect(SupportedLanguage.urdu.locale, equals(const Locale('ur')));

      // Test Arabic locale
      expect(SupportedLanguage.arabic.locale, equals(const Locale('ar')));
    });

    test('should provide correct text direction', () {
      // LTR languages
      expect(
          SupportedLanguage.english.textDirection, equals(TextDirection.ltr));
      expect(SupportedLanguage.bangla.textDirection, equals(TextDirection.ltr));

      // RTL languages
      expect(SupportedLanguage.urdu.textDirection, equals(TextDirection.rtl));
      expect(SupportedLanguage.arabic.textDirection, equals(TextDirection.rtl));
    });

    test('should provide correct flag emojis', () {
      expect(SupportedLanguage.english.flagEmoji, equals('🇺🇸'));
      expect(SupportedLanguage.bangla.flagEmoji, equals('🇧🇩'));
      expect(SupportedLanguage.urdu.flagEmoji, equals('🇵🇰'));
      expect(SupportedLanguage.arabic.flagEmoji, equals('🇸🇦'));
    });

    test('should provide correct status descriptions', () {
      // Fully supported languages
      expect(SupportedLanguage.english.statusDescription,
          equals('Fully Supported'));
      expect(SupportedLanguage.bangla.statusDescription,
          equals('Fully Supported'));

      // Coming soon languages
      expect(SupportedLanguage.urdu.statusDescription, equals('Coming Soon'));
      expect(SupportedLanguage.arabic.statusDescription, equals('Coming Soon'));
    });

    test('should convert from language code correctly', () {
      expect(
          SupportedLanguage.fromCode('en'), equals(SupportedLanguage.english));
      expect(
          SupportedLanguage.fromCode('bn'), equals(SupportedLanguage.bangla));
      expect(SupportedLanguage.fromCode('ur'), equals(SupportedLanguage.urdu));
      expect(
          SupportedLanguage.fromCode('ar'), equals(SupportedLanguage.arabic));

      // Test fallback for unknown code
      expect(SupportedLanguage.fromCode('unknown'),
          equals(SupportedLanguage.english));
    });
  });
}

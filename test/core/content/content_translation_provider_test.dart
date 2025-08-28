import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deen_mate/core/localization/language_models.dart';
import 'package:deen_mate/core/content/content_translation_provider.dart';

void main() {
  group('Content Translation Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should provide correct Quran translation IDs', () {
      expect(
          ContentTranslationMapping.getQuranTranslationId(
              SupportedLanguage.english),
          equals(131));
      expect(
          ContentTranslationMapping.getQuranTranslationId(
              SupportedLanguage.bangla),
          equals(95));
      expect(
          ContentTranslationMapping.getQuranTranslationId(
              SupportedLanguage.urdu),
          equals(101));
      expect(
          ContentTranslationMapping.getQuranTranslationId(
              SupportedLanguage.arabic),
          equals(1));
    });

    test('should provide correct Hadith translation IDs', () {
      expect(
          ContentTranslationMapping.getHadithTranslationId(
              SupportedLanguage.english),
          equals(1));
      expect(
          ContentTranslationMapping.getHadithTranslationId(
              SupportedLanguage.bangla),
          equals(2));
      expect(
          ContentTranslationMapping.getHadithTranslationId(
              SupportedLanguage.urdu),
          equals(3));
      expect(
          ContentTranslationMapping.getHadithTranslationId(
              SupportedLanguage.arabic),
          equals(1));
    });

    test('should check Quran translation availability correctly', () {
      expect(
          ContentTranslationMapping.isQuranTranslationAvailable(
              SupportedLanguage.english),
          isTrue);
      expect(
          ContentTranslationMapping.isQuranTranslationAvailable(
              SupportedLanguage.bangla),
          isTrue);
      expect(
          ContentTranslationMapping.isQuranTranslationAvailable(
              SupportedLanguage.urdu),
          isTrue);
      expect(
          ContentTranslationMapping.isQuranTranslationAvailable(
              SupportedLanguage.arabic),
          isTrue);
    });

    test('should check Hadith translation availability correctly', () {
      expect(
          ContentTranslationMapping.isHadithTranslationAvailable(
              SupportedLanguage.english),
          isTrue);
      expect(
          ContentTranslationMapping.isHadithTranslationAvailable(
              SupportedLanguage.bangla),
          isTrue);
      expect(
          ContentTranslationMapping.isHadithTranslationAvailable(
              SupportedLanguage.urdu),
          isTrue);
      expect(
          ContentTranslationMapping.isHadithTranslationAvailable(
              SupportedLanguage.arabic),
          isTrue);
    });

    test('should provide correct Quran translation provider', () {
      final quranTranslationId = container.read(quranTranslationProvider);
      expect(quranTranslationId, equals(131)); // Default English
    });

    test('should provide correct Hadith translation provider', () {
      final hadithTranslationId = container.read(hadithTranslationProvider);
      expect(hadithTranslationId, equals(1)); // Default English
    });

    test('should provide correct translation availability providers', () {
      final quranAvailable = container.read(quranTranslationAvailableProvider);
      final hadithAvailable =
          container.read(hadithTranslationAvailableProvider);

      expect(quranAvailable, isTrue);
      expect(hadithAvailable, isTrue);
    });

    test('should manage content translation preferences correctly', () {
      final preferences =
          container.read(contentTranslationPreferencesProvider.notifier);

      // Set custom translation for Bangla Quran
      preferences.setTranslationId('quran', SupportedLanguage.bangla, 100);

      // Get the translation ID
      final translationId =
          preferences.getTranslationId('quran', SupportedLanguage.bangla);
      expect(translationId, equals(100));

      // Get default for English (should be unchanged)
      final englishTranslationId =
          preferences.getTranslationId('quran', SupportedLanguage.english);
      expect(englishTranslationId, equals(131));
    });

    test('should provide correct user Quran translation provider', () {
      final userQuranTranslationId =
          container.read(userQuranTranslationProvider);
      expect(userQuranTranslationId, equals(131)); // Default English
    });

    test('should provide correct user Hadith translation provider', () {
      final userHadithTranslationId =
          container.read(userHadithTranslationProvider);
      expect(userHadithTranslationId, equals(1)); // Default English
    });

    test('should provide correct available translations for Quran', () {
      final translations =
          ContentTranslationService.getAvailableTranslations('quran');

      expect(translations.length, equals(4));

      // Check English translation
      final englishTranslation =
          translations.firstWhere((t) => t['language'] == 'en');
      expect(englishTranslation['id'], equals(131));
      expect(englishTranslation['name'], equals('Saheeh International'));
      expect(englishTranslation['author'], equals('Saheeh International'));

      // Check Bangla translation
      final banglaTranslation =
          translations.firstWhere((t) => t['language'] == 'bn');
      expect(banglaTranslation['id'], equals(95));
      expect(banglaTranslation['name'], equals('Dr. Abu Bakr Zakaria'));
      expect(banglaTranslation['author'], equals('Dr. Abu Bakr Zakaria'));
    });

    test('should provide correct available translations for Hadith', () {
      final translations =
          ContentTranslationService.getAvailableTranslations('hadith');

      expect(translations.length, equals(4));

      // Check English translation
      final englishTranslation =
          translations.firstWhere((t) => t['language'] == 'en');
      expect(englishTranslation['id'], equals(1));
      expect(englishTranslation['name'], equals('Sahih Bukhari'));
      expect(englishTranslation['author'], equals('Imam Bukhari'));

      // Check Bangla translation
      final banglaTranslation =
          translations.firstWhere((t) => t['language'] == 'bn');
      expect(banglaTranslation['id'], equals(2));
      expect(banglaTranslation['name'], equals('সহীহ বুখারী'));
      expect(banglaTranslation['author'], equals('ইমাম বুখারী'));
    });

    test('should get translation info by ID correctly', () {
      final quranInfo =
          ContentTranslationService.getTranslationInfo('quran', 131);
      expect(quranInfo?['name'], equals('Saheeh International'));
      expect(quranInfo?['author'], equals('Saheeh International'));

      final hadithInfo =
          ContentTranslationService.getTranslationInfo('hadith', 1);
      expect(hadithInfo?['name'], equals('Sahih Bukhari'));
      expect(hadithInfo?['author'], equals('Imam Bukhari'));
    });

    test('should get translation name correctly', () {
      final quranName =
          ContentTranslationService.getTranslationName('quran', 131);
      expect(quranName, equals('Saheeh International'));

      final hadithName =
          ContentTranslationService.getTranslationName('hadith', 1);
      expect(hadithName, equals('Sahih Bukhari'));
    });

    test('should get translation author correctly', () {
      final quranAuthor =
          ContentTranslationService.getTranslationAuthor('quran', 131);
      expect(quranAuthor, equals('Saheeh International'));

      final hadithAuthor =
          ContentTranslationService.getTranslationAuthor('hadith', 1);
      expect(hadithAuthor, equals('Imam Bukhari'));
    });

    test('should handle unknown translation IDs gracefully', () {
      final unknownInfo =
          ContentTranslationService.getTranslationInfo('quran', 999);
      expect(unknownInfo, isNull);

      final unknownName =
          ContentTranslationService.getTranslationName('quran', 999);
      expect(unknownName, equals('Unknown Translation'));

      final unknownAuthor =
          ContentTranslationService.getTranslationAuthor('quran', 999);
      expect(unknownAuthor, equals('Unknown Author'));
    });
  });
}

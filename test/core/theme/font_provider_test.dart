import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deen_mate/core/localization/language_models.dart';
import 'package:deen_mate/core/theme/font_provider.dart' as font_provider;

void main() {
  group('Font Provider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with English font family', () {
      final currentFontFamily =
          container.read(font_provider.fontFamilyProvider);
      expect(currentFontFamily, equals(font_provider.FontFamilies.english));
    });

    test('should provide correct font family for each language', () {
      final fontProvider =
          container.read(font_provider.fontFamilyProvider.notifier);

      // Test English font
      expect(fontProvider.getUIFontFamily(SupportedLanguage.english),
          equals(font_provider.FontFamilies.english));

      // Test Bangla font
      expect(fontProvider.getUIFontFamily(SupportedLanguage.bangla),
          equals(font_provider.FontFamilies.bengali));

      // Test Arabic font
      expect(fontProvider.getUIFontFamily(SupportedLanguage.arabic),
          equals(font_provider.FontFamilies.arabic));

      // Test Urdu font
      expect(fontProvider.getUIFontFamily(SupportedLanguage.urdu),
          equals(font_provider.FontFamilies.urdu));
    });

    test('should provide correct Quran font family', () {
      final fontProvider =
          container.read(font_provider.fontFamilyProvider.notifier);

      final quranFont = fontProvider.getQuranFontFamily();
      expect(quranFont, equals(font_provider.FontFamilies.quran));
    });

    test('should provide correct number font family', () {
      final fontProvider =
          container.read(font_provider.fontFamilyProvider.notifier);

      final numberFont = fontProvider.getNumberFontFamily();
      expect(numberFont, equals(font_provider.FontFamilies.english));
    });

    test('should update font family when language changes', () async {
      final fontProvider =
          container.read(font_provider.fontFamilyProvider.notifier);

      // Initially English
      expect(container.read(font_provider.fontFamilyProvider),
          equals(font_provider.FontFamilies.english));

      // Update to Bangla
      fontProvider.updateFont(SupportedLanguage.bangla);
      expect(container.read(font_provider.fontFamilyProvider),
          equals(font_provider.FontFamilies.bengali));

      // Update to Arabic
      fontProvider.updateFont(SupportedLanguage.arabic);
      expect(container.read(font_provider.fontFamilyProvider),
          equals(font_provider.FontFamilies.arabic));
    });

    test('should provide correct font family constants', () {
      expect(font_provider.FontFamilies.english, equals('Roboto'));
      expect(font_provider.FontFamilies.bengali, equals('NotoSansBengali'));
      expect(font_provider.FontFamilies.arabic, equals('NotoSansArabic'));
      expect(font_provider.FontFamilies.urdu, equals('NotoSansArabic'));
      expect(font_provider.FontFamilies.quran, equals('UthmanicHafs'));
      expect(font_provider.FontFamilies.englishFallback, equals('NotoSans'));
      expect(font_provider.FontFamilies.bengaliFallback, equals('NotoSans'));
      expect(font_provider.FontFamilies.arabicFallback, equals('NotoSans'));
      expect(font_provider.FontFamilies.urduFallback, equals('NotoSans'));
      expect(font_provider.FontFamilies.quranFallback, equals('Amiri'));
    });
  });
}

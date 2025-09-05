import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/language_models.dart';
import '../localization/language_provider.dart';

/// Font family constants for different languages
class FontFamilies {
  // English fonts
  static const String english = 'Roboto';
  static const String englishFallback = 'NotoSans';

  // Bengali fonts
  static const String bengali = 'NotoSansBengali';
  static const String bengaliFallback = 'NotoSans';

  // Arabic fonts
  static const String arabic = 'NotoSansArabic';
  static const String arabicFallback = 'NotoSans';

  // Quran-specific fonts (always Arabic)
  static const String quran = 'UthmanicHafs';
  static const String quranFallback = 'Amiri';
  
  // Quran script variants
  static const String quranUthmanic = 'UthmanicHafs';
  static const String quranIndoPak = 'IndoPak';

  // Urdu fonts (when implemented)
  static const String urdu = 'NotoSansArabic'; // Using Arabic for now
  static const String urduFallback = 'NotoSans';
}

/// Font provider that returns appropriate font family based on current language
class FontProvider extends StateNotifier<String> {
  FontProvider() : super(FontFamilies.english);

  /// Get font family for UI text based on current language
  String getUIFontFamily(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return FontFamilies.english;
      case SupportedLanguage.bangla:
        return FontFamilies.bengali;
      case SupportedLanguage.arabic:
        return FontFamilies.arabic;
      case SupportedLanguage.urdu:
        return FontFamilies.urdu;
    }
  }

  /// Get font family for Quran text (always Arabic)
  String getQuranFontFamily() {
    return FontFamilies.quran;
  }

  /// Get font family for Quran text based on script variant preference
  String getQuranScriptFontFamily(String? scriptVariant) {
    switch (scriptVariant) {
      case 'IndoPak':
        return FontFamilies.quranIndoPak;
      case 'Uthmanic':
      default:
        return FontFamilies.quranUthmanic;
    }
  }

  /// Get font family for numbers (language-agnostic)
  String getNumberFontFamily() {
    return FontFamilies.english; // Use English for consistent number rendering
  }

  /// Update font based on language change
  void updateFont(SupportedLanguage language) {
    state = getUIFontFamily(language);
  }
}

/// Provider for font family based on current language
final fontFamilyProvider = StateNotifierProvider<FontProvider, String>((ref) {
  final provider = FontProvider();

  // Listen to language changes and update font
  ref.listen<SupportedLanguage>(currentLanguageProvider, (previous, next) {
    if (previous != next) {
      provider.updateFont(next);
    }
  });

  return provider;
});

/// Provider for UI text styles with language-aware fonts
final uiTextStyleProvider = Provider<
    TextStyle Function({
      double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      double? height,
      TextDecoration? decoration,
    })>((ref) {
  final currentFontFamily = ref.watch(fontFamilyProvider);

  return ({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: currentFontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  };
});

/// Provider for Quran text styles (always Arabic)
final quranTextStyleProvider = Provider<
    TextStyle Function({
      double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      double? height,
    })>((ref) {
  return ({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontFamily: FontFamilies.quran,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  };
});

/// Provider for number text styles (language-agnostic)
final numberTextStyleProvider = Provider<
    TextStyle Function({
      double? fontSize,
      FontWeight? fontWeight,
      Color? color,
      double? height,
    })>((ref) {
  return ({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontFamily: FontFamilies.english,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  };
});

/// Extension methods for easy font access
extension FontExtensions on BuildContext {
  /// Get current UI font family
  String get currentFontFamily {
    final container = ProviderScope.containerOf(this);
    return container.read(fontFamilyProvider);
  }

  /// Get UI text style with current language font
  TextStyle uiTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
  }) {
    final container = ProviderScope.containerOf(this);
    final styleProvider = container.read(uiTextStyleProvider);
    return styleProvider(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
    );
  }

  /// Get Quran text style (always Arabic)
  TextStyle quranTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    final container = ProviderScope.containerOf(this);
    final styleProvider = container.read(quranTextStyleProvider);
    return styleProvider(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  /// Get number text style (language-agnostic)
  TextStyle numberTextStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
  }) {
    final container = ProviderScope.containerOf(this);
    final styleProvider = container.read(numberTextStyleProvider);
    return styleProvider(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }
}

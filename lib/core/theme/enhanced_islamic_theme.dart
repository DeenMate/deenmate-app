import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'font_provider.dart';
import 'islamic_theme.dart';

/// Enhanced Islamic theme with language-aware typography
class EnhancedIslamicTheme {
  // Inherit all color constants from IslamicTheme
  static const Color islamicGreen = IslamicTheme.islamicGreen;
  static const Color islamicGreenLight = IslamicTheme.islamicGreenLight;
  static const Color prayerBlue = IslamicTheme.prayerBlue;
  static const Color prayerBlueLight = IslamicTheme.prayerBlueLight;
  static const Color zakatGold = IslamicTheme.zakatGold;
  static const Color zakatGoldDark = IslamicTheme.zakatGoldDark;
  static const Color quranPurple = IslamicTheme.quranPurple;
  static const Color quranPurpleLight = IslamicTheme.quranPurpleLight;
  static const Color hadithOrange = IslamicTheme.hadithOrange;
  static const Color hadithOrangeLight = IslamicTheme.hadithOrangeLight;
  static const Color duaBrown = IslamicTheme.duaBrown;
  static const Color duaBrownLight = IslamicTheme.duaBrownLight;
  static const Color backgroundLight = IslamicTheme.backgroundLight;
  static const Color cardBackground = IslamicTheme.cardBackground;
  static const Color surfaceLight = IslamicTheme.surfaceLight;
  static const Color textPrimary = IslamicTheme.textPrimary;
  static const Color textSecondary = IslamicTheme.textSecondary;
  static const Color textHint = IslamicTheme.textHint;

  // Inherit gradients
  static const LinearGradient islamicGreenGradient =
      IslamicTheme.islamicGreenGradient;
  static const LinearGradient prayerBlueGradient =
      IslamicTheme.prayerBlueGradient;
  static const LinearGradient zakatGoldGradient =
      IslamicTheme.zakatGoldGradient;
  static const LinearGradient quranPurpleGradient =
      IslamicTheme.quranPurpleGradient;
  static const LinearGradient hadithOrangeGradient =
      IslamicTheme.hadithOrangeGradient;
  static const LinearGradient duaBrownGradient = IslamicTheme.duaBrownGradient;

  /// Language-aware text theme provider
  static final textThemeProvider = Provider<TextTheme>((ref) {
    final currentFontFamily = ref.watch(fontFamilyProvider);

    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.3,
      ),
      displaySmall: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.4,
      ),

      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      headlineMedium: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      headlineSmall: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),

      // Title styles
      titleLarge: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        height: 1.5,
      ),
      titleMedium: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.5,
      ),

      // Body styles
      bodyLarge: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
        height: 1.6,
      ),

      // Label styles
      labelLarge: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.5,
      ),
      labelMedium: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textSecondary,
        height: 1.5,
      ),
      labelSmall: TextStyle(
        fontFamily: currentFontFamily,
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: textHint,
        height: 1.5,
      ),
    );
  });

  /// Quran text theme provider (always Arabic)
  static final quranTextThemeProvider = Provider<TextTheme>((ref) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: FontFamilies.quran,
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      displayMedium: TextStyle(
        fontFamily: FontFamilies.quran,
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      displaySmall: TextStyle(
        fontFamily: FontFamilies.quran,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      headlineLarge: TextStyle(
        fontFamily: FontFamilies.quran,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      headlineMedium: TextStyle(
        fontFamily: FontFamilies.quran,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      headlineSmall: TextStyle(
        fontFamily: FontFamilies.quran,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontFamily: FontFamilies.quran,
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontFamily: FontFamilies.quran,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontFamily: FontFamilies.quran,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textSecondary,
        height: 1.6,
      ),
    );
  });

  /// Number text theme provider (language-agnostic)
  static final numberTextThemeProvider = Provider<TextTheme>((ref) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: FontFamilies.english,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.2,
      ),
      displayMedium: TextStyle(
        fontFamily: FontFamilies.english,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.3,
      ),
      displaySmall: TextStyle(
        fontFamily: FontFamilies.english,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: textPrimary,
        height: 1.4,
      ),
      headlineLarge: TextStyle(
        fontFamily: FontFamilies.english,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      ),
      headlineMedium: TextStyle(
        fontFamily: FontFamilies.english,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      headlineSmall: TextStyle(
        fontFamily: FontFamilies.english,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.5,
      ),
      bodyLarge: TextStyle(
        fontFamily: FontFamilies.english,
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.6,
      ),
      bodyMedium: TextStyle(
        fontFamily: FontFamilies.english,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: textPrimary,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontFamily: FontFamilies.english,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: textSecondary,
        height: 1.6,
      ),
    );
  });

  // Inherit card decorations
  static BoxDecoration get cardDecoration => IslamicTheme.cardDecoration;
  static BoxDecoration gradientCardDecoration(Gradient gradient) =>
      IslamicTheme.gradientCardDecoration(gradient);
}

/// Extension methods for easy theme access
extension EnhancedThemeExtensions on BuildContext {
  /// Get language-aware text theme
  TextTheme get enhancedTextTheme {
    final container = ProviderScope.containerOf(this);
    return container.read(EnhancedIslamicTheme.textThemeProvider);
  }

  /// Get Quran text theme (always Arabic)
  TextTheme get quranTextTheme {
    final container = ProviderScope.containerOf(this);
    return container.read(EnhancedIslamicTheme.quranTextThemeProvider);
  }

  /// Get number text theme (language-agnostic)
  TextTheme get numberTextTheme {
    final container = ProviderScope.containerOf(this);
    return container.read(EnhancedIslamicTheme.numberTextThemeProvider);
  }
}

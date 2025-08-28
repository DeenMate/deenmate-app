import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/enhanced_islamic_theme.dart';
import '../theme/font_provider.dart' as font_provider;
import '../localization/language_provider.dart';
import '../localization/language_models.dart';

/// Demo widget to showcase the language-aware font system
class FontDemoWidget extends ConsumerWidget {
  const FontDemoWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);
    final currentFontFamily = ref.watch(font_provider.fontFamilyProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Font System Demo',
          style: context.enhancedTextTheme.headlineSmall,
        ),
        backgroundColor: EnhancedIslamicTheme.backgroundLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current language info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Language: ${currentLanguage.nativeName}',
                      style: context.enhancedTextTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Font Family: $currentFontFamily',
                      style: context.enhancedTextTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Language Code: ${currentLanguage.code}',
                      style: context.enhancedTextTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Language-aware text samples
            Text(
              'Language-Aware Typography',
              style: context.enhancedTextTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            _buildTextSample(
              context,
              'Display Large Text',
              context.enhancedTextTheme.displayLarge!,
            ),
            _buildTextSample(
              context,
              'Headline Medium Text',
              context.enhancedTextTheme.headlineMedium!,
            ),
            _buildTextSample(
              context,
              'Body Large Text',
              context.enhancedTextTheme.bodyLarge!,
            ),
            _buildTextSample(
              context,
              'Body Medium Text',
              context.enhancedTextTheme.bodyMedium!,
            ),
            _buildTextSample(
              context,
              'Label Small Text',
              context.enhancedTextTheme.labelSmall!,
            ),

            const SizedBox(height: 32),

            // Quran text sample (always Arabic)
            Text(
              'Quran Text (Always Arabic)',
              style: context.enhancedTextTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            _buildTextSample(
              context,
              'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
              context.quranTextTheme.headlineMedium!,
            ),
            _buildTextSample(
              context,
              'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
              context.quranTextTheme.bodyLarge!,
            ),

            const SizedBox(height: 32),

            // Number text sample (language-agnostic)
            Text(
              'Numbers (Language-Agnostic)',
              style: context.enhancedTextTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            _buildTextSample(
              context,
              '1234567890',
              context.numberTextTheme.headlineMedium!,
            ),
            _buildTextSample(
              context,
              'Prayer Time: 05:30 AM',
              context.numberTextTheme.bodyLarge!,
            ),

            const SizedBox(height: 32),

            // Language switcher
            Text(
              'Switch Language to Test Fonts',
              style: context.enhancedTextTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: SupportedLanguage.values.map((language) {
                return ElevatedButton(
                  onPressed: () {
                    ref.read(languageSwitcherProvider).switchLanguage(language);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentLanguage == language
                        ? EnhancedIslamicTheme.islamicGreen
                        : EnhancedIslamicTheme.surfaceLight,
                    foregroundColor: currentLanguage == language
                        ? Colors.white
                        : EnhancedIslamicTheme.textPrimary,
                  ),
                  child: Text(
                    language.nativeName,
                    style: TextStyle(
                      fontFamily: currentLanguage == language
                          ? currentFontFamily
                          : font_provider.FontFamilies.english,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Font family comparison
            Text(
              'Font Family Comparison',
              style: context.enhancedTextTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            _buildFontComparison(
                context, 'English', font_provider.FontFamilies.english),
            _buildFontComparison(
                context, 'Bengali', font_provider.FontFamilies.bengali),
            _buildFontComparison(
                context, 'Arabic', font_provider.FontFamilies.arabic),
            _buildFontComparison(
                context, 'Quran', font_provider.FontFamilies.quran),
          ],
        ),
      ),
    );
  }

  Widget _buildTextSample(BuildContext context, String text, TextStyle style) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style: style),
            const SizedBox(height: 4),
            Text(
              'Font: ${style.fontFamily}',
              style: context.enhancedTextTheme.bodySmall?.copyWith(
                color: EnhancedIslamicTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFontComparison(
      BuildContext context, String label, String fontFamily) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: context.enhancedTextTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Sample text in $label font',
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: 16,
                color: EnhancedIslamicTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Font Family: $fontFamily',
              style: context.enhancedTextTheme.bodySmall?.copyWith(
                color: EnhancedIslamicTheme.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

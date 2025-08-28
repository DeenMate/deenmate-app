import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../content/content_translation_provider.dart';
import '../localization/language_models.dart';
import '../localization/language_provider.dart';
import '../theme/enhanced_islamic_theme.dart';
import '../theme/font_provider.dart' as font_provider;

/// Demo widget to showcase the content translation system
class ContentTranslationDemo extends ConsumerWidget {
  const ContentTranslationDemo({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);
    final quranTranslationId = ref.watch(userQuranTranslationProvider);
    final hadithTranslationId = ref.watch(userHadithTranslationProvider);
    final quranTranslationAvailable =
        ref.watch(quranTranslationAvailableProvider);
    final hadithTranslationAvailable =
        ref.watch(hadithTranslationAvailableProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Content Translation Demo',
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
                      'Content translations automatically adapt to your language preference.',
                      style: context.enhancedTextTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quran translation demo
            Text(
              'Quran Translation Demo',
              style: context.enhancedTextTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            _buildQuranDemo(context, ref, currentLanguage, quranTranslationId,
                quranTranslationAvailable),

            const SizedBox(height: 32),

            // Hadith translation demo
            Text(
              'Hadith Translation Demo',
              style: context.enhancedTextTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            _buildHadithDemo(context, ref, currentLanguage, hadithTranslationId,
                hadithTranslationAvailable),

            const SizedBox(height: 32),

            // Language switcher
            Text(
              'Switch Language to Test Translations',
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
                          ? ref.read(font_provider.fontFamilyProvider)
                          : font_provider.FontFamilies.english,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 32),

            // Translation info
            _buildTranslationInfo(context, ref, currentLanguage),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranDemo(
    BuildContext context,
    WidgetRef ref,
    SupportedLanguage currentLanguage,
    int quranTranslationId,
    bool quranTranslationAvailable,
  ) {
    final translationInfo = ContentTranslationService.getTranslationInfo(
        'quran', quranTranslationId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book,
                  color: EnhancedIslamicTheme.quranPurple,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Surah Al-Fatiha (1:1-7)',
                        style: context.enhancedTextTheme.headlineMedium,
                      ),
                      Text(
                        'Translation: ${translationInfo?['name'] ?? 'Unknown'}',
                        style: context.enhancedTextTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Arabic text (always the same)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EnhancedIslamicTheme.quranPurple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Arabic Text:',
                    style: context.enhancedTextTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: context.quranTextTheme.headlineMedium,
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Translation text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EnhancedIslamicTheme.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: EnhancedIslamicTheme.quranPurple.withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Translation:',
                    style: context.enhancedTextTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getQuranTranslation(currentLanguage),
                    style: context.enhancedTextTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            if (!quranTranslationAvailable) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Translation not available for ${currentLanguage.nativeName}. Using English fallback.',
                        style: context.enhancedTextTheme.bodySmall?.copyWith(
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHadithDemo(
    BuildContext context,
    WidgetRef ref,
    SupportedLanguage currentLanguage,
    int hadithTranslationId,
    bool hadithTranslationAvailable,
  ) {
    final translationInfo = ContentTranslationService.getTranslationInfo(
        'hadith', hadithTranslationId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.article,
                  color: EnhancedIslamicTheme.hadithOrange,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sahih Bukhari - Book of Faith',
                        style: context.enhancedTextTheme.headlineMedium,
                      ),
                      Text(
                        'Translation: ${translationInfo?['name'] ?? 'Unknown'}',
                        style: context.enhancedTextTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Hadith text
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: EnhancedIslamicTheme.hadithOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hadith Text:',
                    style: context.enhancedTextTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getHadithTranslation(currentLanguage),
                    style: context.enhancedTextTheme.bodyLarge,
                  ),
                ],
              ),
            ),

            if (!hadithTranslationAvailable) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning,
                      color: Colors.orange,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Translation not available for ${currentLanguage.nativeName}. Using English fallback.',
                        style: context.enhancedTextTheme.bodySmall?.copyWith(
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationInfo(
      BuildContext context, WidgetRef ref, SupportedLanguage currentLanguage) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Translation System Info',
              style: context.enhancedTextTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildInfoRow(context, 'Quran Translation ID',
                ref.watch(userQuranTranslationProvider).toString()),
            _buildInfoRow(context, 'Hadith Translation ID',
                ref.watch(userHadithTranslationProvider).toString()),
            _buildInfoRow(context, 'Quran Available',
                ref.watch(quranTranslationAvailableProvider) ? 'Yes' : 'No'),
            _buildInfoRow(context, 'Hadith Available',
                ref.watch(hadithTranslationAvailableProvider) ? 'Yes' : 'No'),
            _buildInfoRow(
                context, 'Current Language', currentLanguage.nativeName),
            _buildInfoRow(context, 'Language Code', currentLanguage.code),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: context.enhancedTextTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.enhancedTextTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  String _getQuranTranslation(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return 'In the name of Allah, the Entirely Merciful, the Especially Merciful.';
      case SupportedLanguage.bangla:
        return 'পরম করুণাময় অতি দয়ালু আল্লাহর নামে।';
      case SupportedLanguage.urdu:
        return 'اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے۔';
      case SupportedLanguage.arabic:
        return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
    }
  }

  String _getHadithTranslation(SupportedLanguage language) {
    switch (language) {
      case SupportedLanguage.english:
        return 'Narrated Abu Huraira: The Prophet said, "Religion is very easy and whoever overburdens himself in his religion will not be able to continue in that way."';
      case SupportedLanguage.bangla:
        return 'আবু হুরায়রা (রা.) থেকে বর্ণিত, নবী (সা.) বলেছেন, "দীন সহজ এবং যে ব্যক্তি নিজের দীনে কঠোরতা অবলম্বন করবে, সে তা পালন করতে পারবে না।"';
      case SupportedLanguage.urdu:
        return 'ابو ہریرہ رضی اللہ عنہ سے روایت ہے کہ نبی صلی اللہ علیہ وسلم نے فرمایا: "دین آسان ہے اور جو شخص اپنے دین میں سختی کرے گا وہ اس پر قائم نہیں رہ سکے گا۔"';
      case SupportedLanguage.arabic:
        return 'عَنْ أَبِي هُرَيْرَةَ قَالَ قَالَ النَّبِيُّ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ إِنَّ الدِّينَ يُسْرٌ وَلَنْ يُشَادَّ الدِّينَ أَحَدٌ إِلَّا غَلَبَهُ';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../content/content_translation_provider.dart';
import '../localization/language_models.dart';
import '../localization/language_provider.dart';
import '../theme/enhanced_islamic_theme.dart';

/// Widget for managing content translation preferences
class ContentTranslationSettings extends ConsumerWidget {
  const ContentTranslationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLanguage = ref.watch(currentLanguageProvider);
    final quranTranslationId = ref.watch(userQuranTranslationProvider);
    final hadithTranslationId = ref.watch(userHadithTranslationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Content Translations',
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
                      'Content translations will automatically switch based on your language preference.',
                      style: context.enhancedTextTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Quran translations section
            Text(
              'Quran Translations',
              style: context.enhancedTextTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            _buildTranslationSection(
              context,
              ref,
              'quran',
              quranTranslationId,
              currentLanguage,
            ),

            const SizedBox(height: 32),

            // Hadith translations section
            Text(
              'Hadith Translations',
              style: context.enhancedTextTheme.headlineLarge,
            ),
            const SizedBox(height: 16),

            _buildTranslationSection(
              context,
              ref,
              'hadith',
              hadithTranslationId,
              currentLanguage,
            ),

            const SizedBox(height: 32),

            // Information section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works',
                      style: context.enhancedTextTheme.headlineMedium,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoItem(
                      context,
                      'Automatic switching',
                      'Translations automatically change when you switch app language',
                    ),
                    _buildInfoItem(
                      context,
                      'Fallback support',
                      'If a translation is not available, English will be used as fallback',
                    ),
                    _buildInfoItem(
                      context,
                      'User preferences',
                      'You can override the default translation for each language',
                    ),
                    _buildInfoItem(
                      context,
                      'Offline support',
                      'Downloaded translations work offline',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslationSection(
    BuildContext context,
    WidgetRef ref,
    String contentType,
    int currentTranslationId,
    SupportedLanguage currentLanguage,
  ) {
    final availableTranslations =
        ContentTranslationService.getAvailableTranslations(contentType);
    final currentTranslation = ContentTranslationService.getTranslationInfo(
        contentType, currentTranslationId);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current translation info
            Row(
              children: [
                Icon(
                  contentType == 'quran' ? Icons.menu_book : Icons.article,
                  color: EnhancedIslamicTheme.islamicGreen,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Translation',
                        style: context.enhancedTextTheme.titleMedium,
                      ),
                      Text(
                        currentTranslation?['name'] ?? 'Unknown',
                        style: context.enhancedTextTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'by ${currentTranslation?['author'] ?? 'Unknown'}',
                        style: context.enhancedTextTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Available translations
            Text(
              'Available Translations',
              style: context.enhancedTextTheme.titleMedium,
            ),
            const SizedBox(height: 12),

            ...availableTranslations.map((translation) {
              final isSelected = translation['id'] == currentTranslationId;
              final isCurrentLanguage =
                  translation['language'] == currentLanguage.code;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                color: isSelected
                    ? EnhancedIslamicTheme.islamicGreen.withOpacity(0.1)
                    : null,
                child: ListTile(
                  leading: Icon(
                    isSelected
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? EnhancedIslamicTheme.islamicGreen
                        : EnhancedIslamicTheme.textSecondary,
                  ),
                  title: Text(
                    translation['name'],
                    style: context.enhancedTextTheme.bodyMedium?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'by ${translation['author']}',
                        style: context.enhancedTextTheme.bodySmall,
                      ),
                      if (isCurrentLanguage)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: EnhancedIslamicTheme.islamicGreen
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Current Language',
                            style:
                                context.enhancedTextTheme.labelSmall?.copyWith(
                              color: EnhancedIslamicTheme.islamicGreen,
                            ),
                          ),
                        ),
                    ],
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: EnhancedIslamicTheme.islamicGreen,
                        )
                      : null,
                  onTap: () {
                    ref
                        .read(contentTranslationPreferencesProvider.notifier)
                        .setTranslationId(
                            contentType, currentLanguage, translation['id']);
                  },
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(
      BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: EnhancedIslamicTheme.islamicGreen,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.enhancedTextTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  description,
                  style: context.enhancedTextTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

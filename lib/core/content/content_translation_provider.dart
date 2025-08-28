import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../localization/language_models.dart';
import '../localization/language_provider.dart';

/// Content translation mapping for different languages
class ContentTranslationMapping {
  // Quran translation resource IDs for different languages
  static const Map<SupportedLanguage, int> quranTranslations = {
    SupportedLanguage.english: 131, // English - Saheeh International
    SupportedLanguage.bangla: 95, // Bengali - Dr. Abu Bakr Zakaria
    SupportedLanguage.urdu: 101, // Urdu - Fateh Muhammad Jalandhri
    SupportedLanguage.arabic:
        1, // Arabic - Original text (no translation needed)
  };

  // Hadith translation resource IDs for different languages
  static const Map<SupportedLanguage, int> hadithTranslations = {
    SupportedLanguage.english: 1, // English - Sahih Bukhari
    SupportedLanguage.bangla: 2, // Bengali - Placeholder
    SupportedLanguage.urdu: 3, // Urdu - Placeholder
    SupportedLanguage.arabic: 1, // Arabic - Original text
  };

  /// Get Quran translation resource ID for current language
  static int getQuranTranslationId(SupportedLanguage language) {
    return quranTranslations[language] ??
        quranTranslations[SupportedLanguage.english]!;
  }

  /// Get Hadith translation resource ID for current language
  static int getHadithTranslationId(SupportedLanguage language) {
    return hadithTranslations[language] ??
        hadithTranslations[SupportedLanguage.english]!;
  }

  /// Check if translation is available for language
  static bool isQuranTranslationAvailable(SupportedLanguage language) {
    return quranTranslations.containsKey(language);
  }

  /// Check if translation is available for language
  static bool isHadithTranslationAvailable(SupportedLanguage language) {
    return hadithTranslations.containsKey(language);
  }
}

/// Provider for Quran translation resource ID based on current language
final quranTranslationProvider = Provider<int>((ref) {
  final currentLanguage = ref.watch(currentLanguageProvider);
  return ContentTranslationMapping.getQuranTranslationId(currentLanguage);
});

/// Provider for Hadith translation resource ID based on current language
final hadithTranslationProvider = Provider<int>((ref) {
  final currentLanguage = ref.watch(currentLanguageProvider);
  return ContentTranslationMapping.getHadithTranslationId(currentLanguage);
});

/// Provider to check if Quran translation is available for current language
final quranTranslationAvailableProvider = Provider<bool>((ref) {
  final currentLanguage = ref.watch(currentLanguageProvider);
  return ContentTranslationMapping.isQuranTranslationAvailable(currentLanguage);
});

/// Provider to check if Hadith translation is available for current language
final hadithTranslationAvailableProvider = Provider<bool>((ref) {
  final currentLanguage = ref.watch(currentLanguageProvider);
  return ContentTranslationMapping.isHadithTranslationAvailable(
      currentLanguage);
});

/// Provider for content translation preferences
class ContentTranslationPreferences extends StateNotifier<Map<String, int>> {
  ContentTranslationPreferences() : super({});

  /// Get translation ID for content type
  int getTranslationId(String contentType, SupportedLanguage language) {
    final key = '${contentType}_${language.code}';
    return state[key] ?? _getDefaultTranslationId(contentType, language);
  }

  /// Set translation ID for content type and language
  void setTranslationId(
      String contentType, SupportedLanguage language, int translationId) {
    final key = '${contentType}_${language.code}';
    state = {...state, key: translationId};
  }

  /// Get default translation ID
  int _getDefaultTranslationId(String contentType, SupportedLanguage language) {
    switch (contentType) {
      case 'quran':
        return ContentTranslationMapping.getQuranTranslationId(language);
      case 'hadith':
        return ContentTranslationMapping.getHadithTranslationId(language);
      default:
        return 1; // Default fallback
    }
  }
}

/// Provider for content translation preferences
final contentTranslationPreferencesProvider =
    StateNotifierProvider<ContentTranslationPreferences, Map<String, int>>(
        (ref) {
  return ContentTranslationPreferences();
});

/// Provider for Quran translation with user preferences
final userQuranTranslationProvider = Provider<int>((ref) {
  final currentLanguage = ref.watch(currentLanguageProvider);
  final preferences = ref.watch(contentTranslationPreferencesProvider);
  final key = 'quran_${currentLanguage.code}';

  return preferences[key] ??
      ContentTranslationMapping.getQuranTranslationId(currentLanguage);
});

/// Provider for Hadith translation with user preferences
final userHadithTranslationProvider = Provider<int>((ref) {
  final currentLanguage = ref.watch(currentLanguageProvider);
  final preferences = ref.watch(contentTranslationPreferencesProvider);
  final key = 'hadith_${currentLanguage.code}';

  return preferences[key] ??
      ContentTranslationMapping.getHadithTranslationId(currentLanguage);
});

/// Content translation service for managing translations
class ContentTranslationService {
  /// Get available translations for content type
  static List<Map<String, dynamic>> getAvailableTranslations(
      String contentType) {
    switch (contentType) {
      case 'quran':
        return [
          {
            'id': 131,
            'name': 'Saheeh International',
            'language': 'en',
            'author': 'Saheeh International'
          },
          {
            'id': 95,
            'name': 'Dr. Abu Bakr Zakaria',
            'language': 'bn',
            'author': 'Dr. Abu Bakr Zakaria'
          },
          {
            'id': 101,
            'name': 'Fateh Muhammad Jalandhri',
            'language': 'ur',
            'author': 'Fateh Muhammad Jalandhri'
          },
          {
            'id': 1,
            'name': 'Original Arabic',
            'language': 'ar',
            'author': 'Original'
          },
        ];
      case 'hadith':
        return [
          {
            'id': 1,
            'name': 'Sahih Bukhari',
            'language': 'en',
            'author': 'Imam Bukhari'
          },
          {
            'id': 2,
            'name': 'সহীহ বুখারী',
            'language': 'bn',
            'author': 'ইমাম বুখারী'
          },
          {
            'id': 3,
            'name': 'صحیح بخاری',
            'language': 'ur',
            'author': 'امام بخاری'
          },
          {
            'id': 1,
            'name': 'صحيح البخاري',
            'language': 'ar',
            'author': 'الإمام البخاري'
          },
        ];
      default:
        return [];
    }
  }

  /// Get translation info by ID
  static Map<String, dynamic>? getTranslationInfo(
      String contentType, int translationId) {
    final translations = getAvailableTranslations(contentType);
    try {
      return translations.firstWhere(
        (translation) => translation['id'] == translationId,
      );
    } catch (e) {
      return null; // Return null if translation not found
    }
  }

  /// Get translation name for display
  static String getTranslationName(String contentType, int translationId) {
    final info = getTranslationInfo(contentType, translationId);
    return info?['name'] ?? 'Unknown Translation';
  }

  /// Get translation author for display
  static String getTranslationAuthor(String contentType, int translationId) {
    final info = getTranslationInfo(contentType, translationId);
    return info?['author'] ?? 'Unknown Author';
  }
}

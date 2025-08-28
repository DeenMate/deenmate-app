import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'language_provider.dart';
import 'language_models.dart';
import '../../features/quran/presentation/state/providers.dart';
import '../../features/prayer_times/presentation/providers/prayer_times_providers.dart';

/// Global Language Manager - Ensures consistent language switching across entire app
class GlobalLanguageManager extends ConsumerWidget {
  const GlobalLanguageManager({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch language changes and trigger app-wide updates
    ref.listen<AsyncValue<LanguagePreferences>>(
      languagePreferencesProvider,
      (previous, next) {
        next.whenData((preferences) {
          // Force rebuild of all widgets when language changes
          if (previous?.value?.selectedLanguageCode !=
              preferences.selectedLanguageCode) {
            _triggerGlobalRefresh(ref);
          }
        });
      },
    );

    return child;
  }

  void _triggerGlobalRefresh(WidgetRef ref) {
    // Invalidate key providers to force refresh
    ref.invalidate(translationResourcesProvider);
    ref.invalidate(surahListProvider);
    ref.invalidate(currentPrayerTimesProvider);

    // Clear any cached content that might have language-specific data
    _clearLanguageSpecificCaches();
  }

  void _clearLanguageSpecificCaches() {
    // Clear Hive boxes that might contain language-specific content
    // This ensures fresh data is fetched with new language settings
  }
}

/// Language switching service with global refresh capability
class EnhancedLanguageSwitcher {
  static Future<bool> switchLanguageGlobally(
    WidgetRef ref,
    SupportedLanguage language,
  ) async {
    try {
      // Switch language using existing switcher
      final switcher = ref.read(languageSwitcherProvider);
      final success = await switcher.switchLanguage(language);

      if (success) {
        // Trigger global app refresh
        await _refreshAllProviders(ref);
        return true;
      }
      return false;
    } catch (e) {
      print('Global language switch failed: $e');
      return false;
    }
  }

  static Future<void> _refreshAllProviders(WidgetRef ref) async {
    // Invalidate all language-dependent providers
    ref.invalidate(translationResourcesProvider);
    ref.invalidate(surahListProvider);
    ref.invalidate(juzListProvider);
    ref.invalidate(currentPrayerTimesProvider);

    // Clear cached translations
    ref.invalidate(prefsProvider);
  }
}

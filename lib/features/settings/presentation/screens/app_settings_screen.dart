import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Legacy notification service removed; notifications are managed via
// prayer notification providers and repository-backed services.
import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/preference_keys.dart';
// Deprecated direct service import removed; use repository-backed providers instead
import '../../../../core/theme/islamic_theme.dart';
import '../../../../core/theme/theme_selector_widget.dart';
import '../../../../core/localization/language_models.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/state/prayer_settings_state.dart';
import '../../../prayer_times/presentation/providers/prayer_times_providers.dart';
import '../../../prayer_times/presentation/providers/notification_providers.dart';
import '../../../prayer_times/domain/entities/athan_settings.dart';

// Demo screen removed per product decision to avoid extra widgets on Home

/// App settings screen for DeenMate
class AppSettingsScreen extends ConsumerStatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  ConsumerState<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends ConsumerState<AppSettingsScreen> {
  bool _prayerNotificationsEnabled = true;
  bool _prayerRemindersEnabled = true;
  bool _dailyVersesEnabled = true;
  bool _islamicMidnightEnabled = true; // Default to Islamic midnight
  int _selectedCalculationMethod = 2; // ISNA
  String _selectedLanguage = 'English';
  String _userName = '';

  // Notifications are managed via providers; no direct service instance here.

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.settingsTitle,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: _buildSettingsList(),
    );
  }

  // _buildAppBar removed (unused)

  Widget _buildSettingsList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildSection(
          AppLocalizations.of(context)!.settingsPrayerSettings,
          [
            _buildNavTile(
              title: AppLocalizations.of(context)!.settingsAthanSettings,
              subtitle: AppLocalizations.of(context)!.settingsAthanSubtitle,
              icon: Icons.volume_up,
              route: '/athan-settings',
            ),
            _buildSwitchTile(
              AppLocalizations.of(context)!.settingsPrayerNotifications,
              AppLocalizations.of(context)!.settingsPrayerNotificationsSubtitle,
              _prayerNotificationsEnabled,
              _setPrayerNotifications,
              Icons.notifications,
            ),
            _buildSwitchTile(
              AppLocalizations.of(context)!.settingsPrayerReminders,
              AppLocalizations.of(context)!.settingsPrayerRemindersSubtitle,
              _prayerRemindersEnabled,
              _setPrayerReminders,
              Icons.alarm,
            ),
            _buildCalculationMethodTile(),
            _buildSwitchTile(
              AppLocalizations.of(context)!.settingsIslamicMidnight,
              AppLocalizations.of(context)!.settingsIslamicMidnightSubtitle,
              _islamicMidnightEnabled,
              _setIslamicMidnight,
              Icons.nightlight_round,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          AppLocalizations.of(context)!.settingsIslamicContent,
          [
            _buildSwitchTile(
              AppLocalizations.of(context)!.settingsDailyVerses,
              AppLocalizations.of(context)!.settingsDailyVersesSubtitle,
              _dailyVersesEnabled,
              _setDailyVerses,
              Icons.menu_book,
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          AppLocalizations.of(context)!.settingsQuranSettings,
          [
            _buildNavTile(
              title: AppLocalizations.of(context)!.settingsReadingPreferences,
              subtitle: AppLocalizations.of(context)!.settingsReadingPreferencesSubtitle,
              icon: Icons.text_fields,
              route: '/quran', // For now, goes to Quran home
            ),
            _buildNavTile(
              title: AppLocalizations.of(context)!.settingsContentTranslations,
              subtitle: AppLocalizations.of(context)!.settingsContentTranslationsSubtitle,
              icon: Icons.translate,
              route: '/settings/content-translations',
            ),
            _buildNavTile(
              title: AppLocalizations.of(context)!.settingsOfflineManagement,
              subtitle: AppLocalizations.of(context)!.settingsOfflineSubtitle,
              icon: Icons.cloud_download,
              route: '/quran/offline-management',
            ),
            _buildNavTile(
              title: AppLocalizations.of(context)!.settingsAudioDownloads,
              subtitle: AppLocalizations.of(context)!.settingsAudioSubtitle,
              icon: Icons.download,
              route: '/quran/audio-downloads',
            ),
            _buildNavTile(
              title: AppLocalizations.of(context)!.settingsAccessibility,
              subtitle: AppLocalizations.of(context)!.settingsAccessibilitySubtitle,
              icon: Icons.accessibility,
              route: '/settings/accessibility',
            ),
          ],
        ),
        const SizedBox(height: 24),
        _buildSection(
          AppLocalizations.of(context)!.settingsAppSettings,
          [
            _buildUserNameTile(),
            _buildLanguageTile(),
            _buildAboutTile(),
            _buildPrivacyTile(),
          ],
        ),
        const SizedBox(height: 24),
        // New theme selector section
        const ThemeSelectorWidget(),
        // User Preferences section temporarily removed until proper route is implemented
        const SizedBox(height: 24),
        _buildSection(
          AppLocalizations.of(context)!.settingsDataStorage,
          [
            _buildClearCacheTile(),
            _buildExportDataTile(),
          ],
        ),
        const SizedBox(height: 40),
        _buildVersionInfo(),
      ],
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Text(
            title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        Card(
          elevation: 1,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildNavTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: () => context.go(route),
    );
  }

  Widget _buildCalculationMethodTile() {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Icon(Icons.calculate, color: theme.colorScheme.primary),
      title: Text(
        AppLocalizations.of(context)!.settingsPrayerCalculationMethodTitle,
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        AppConstants.calculationMethods.values.elementAt(
          _selectedCalculationMethod.clamp(
              0, AppConstants.calculationMethods.length - 1),
        ),
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      onTap: _showCalculationMethodDialog,
    );
  }

  Widget _buildLanguageTile() {
    return Consumer(
      builder: (context, ref, child) {
        final currentLanguage = ref.watch(currentLanguageProvider);

        return ListTile(
          leading: const Icon(Icons.language, color: IslamicTheme.islamicGreen),
          title: Text(AppLocalizations.of(context)!.settingsLanguage),
          subtitle: Text(
            currentLanguage.nativeName,
            style: IslamicTheme.textTheme.bodySmall?.copyWith(
              color: IslamicTheme.textSecondary,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () => _showLanguageDialog(ref),
        );
      },
    );
  }

  Widget _buildUserNameTile() {
    return ListTile(
      leading: const Icon(Icons.person, color: IslamicTheme.islamicGreen),
      title: Text(AppLocalizations.of(context)!.settingsUserName),
      subtitle: Text(
        _userName.isEmpty ? AppLocalizations.of(context)!.settingsUserNameSubtitle : _userName,
        style: IslamicTheme.textTheme.bodySmall?.copyWith(
          color: IslamicTheme.textSecondary,
        ),
      ),
      trailing: const Icon(Icons.edit, size: 16),
      onTap: _showEditNameDialog,
    );
  }

  Future<void> _showEditNameDialog() async {
    final controller = TextEditingController(text: _userName);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.settingsEditName),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.settingsEnterName),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(AppLocalizations.of(context)!.commonCancel),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(AppLocalizations.of(context)!.commonSave),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      final name = controller.text.trim();
      if (name.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(PreferenceKeys.userName, name);
        setState(() => _userName = name);
      }
    }
  }

  Widget _buildAboutTile() {
    return ListTile(
      leading: const Icon(Icons.info, color: IslamicTheme.islamicGreen),
      title: Text(AppLocalizations.of(context)!.settingsAbout),
      subtitle: Text(AppLocalizations.of(context)!.settingsAboutSubtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: _showAboutDialog,
    );
  }

  Widget _buildPrivacyTile() {
    return ListTile(
      leading: const Icon(Icons.privacy_tip, color: IslamicTheme.islamicGreen),
      title: Text(AppLocalizations.of(context)!.settingsPrivacyPolicy),
      subtitle:
          Text(AppLocalizations.of(context)!.settingsPrivacyPolicySubtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: _showPrivacyDialog,
    );
  }

  Widget _buildClearCacheTile() {
    return ListTile(
      leading: const Icon(Icons.delete_sweep, color: Colors.orange),
      title: Text(AppLocalizations.of(context)!.settingsClearCache),
      subtitle: Text(AppLocalizations.of(context)!.settingsClearCacheSubtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: _clearCache,
    );
  }

  Widget _buildExportDataTile() {
    return ListTile(
      leading: const Icon(Icons.download, color: IslamicTheme.prayerBlue),
      title: Text(AppLocalizations.of(context)!.settingsExportData),
      subtitle: Text(AppLocalizations.of(context)!.settingsExportDataSubtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: _exportData,
    );
  }

  Widget _buildVersionInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: IslamicTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            '🌙 DeenMate',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Version 1.0.0',
            style: IslamicTheme.textTheme.bodyMedium?.copyWith(
              color: IslamicTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.settingsAppDescription,
            style: IslamicTheme.textTheme.bodySmall?.copyWith(
              color: IslamicTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Settings actions
  Future<void> _setPrayerNotifications(bool enabled) async {
    setState(() {
      _prayerNotificationsEnabled = enabled;
    });

    // Persist simple flag for UI consistency
    await _saveSettings();

    // Update Athan settings and reschedule notifications
    try {
      final notifier = ref.read(athanSettingsProvider.notifier);
      final currentAsync = ref.read(athanSettingsProvider);
      final current = currentAsync.maybeWhen(
          data: (s) => s, orElse: () => const AthanSettings());
      final updated =
          current.copyWith(isEnabled: enabled, lastUpdated: DateTime.now());
      await notifier.updateSettings(updated);

      // Reschedule notifications to apply changes immediately
      await ref.read(autoNotificationSchedulerProvider).rescheduleAll();
    } catch (e) {
      debugPrint('Error applying prayer notifications toggle: $e');
    }
  }

  Future<void> _setPrayerReminders(bool enabled) async {
    setState(() {
      _prayerRemindersEnabled = enabled;
    });

    await _saveSettings();

    // Map reminder toggle to reminderMinutes (0 disables before-prayer reminders)
    try {
      final notifier = ref.read(athanSettingsProvider.notifier);
      final currentAsync = ref.read(athanSettingsProvider);
      final current = currentAsync.maybeWhen(
          data: (s) => s, orElse: () => const AthanSettings());
      final updated = current.copyWith(
        reminderMinutes: enabled
            ? (current.reminderMinutes == 0 ? 10 : current.reminderMinutes)
            : 0,
        lastUpdated: DateTime.now(),
      );
      await notifier.updateSettings(updated);
      await ref.read(autoNotificationSchedulerProvider).rescheduleAll();
    } catch (e) {
      debugPrint('Error applying prayer reminders toggle: $e');
    }
  }

  Future<void> _setDailyVerses(bool enabled) async {
    setState(() {
      _dailyVersesEnabled = enabled;
    });
    await _saveSettings();
  }

  Future<void> _setIslamicMidnight(bool enabled) async {
    setState(() {
      _islamicMidnightEnabled = enabled;
    });
    await _saveSettings();
    // No-op for scheduler here; midnight display logic handled in UI/calculation
  }

  void _showCalculationMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.settingsPrayerCalculationMethodTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppConstants.calculationMethods.values
                .toList()
                .asMap()
                .entries
                .map((entry) {
              return RadioListTile<int>(
                title: Text(
                  entry.value,
                  style: const TextStyle(fontSize: 12),
                ),
                value: entry.key,
                groupValue: _selectedCalculationMethod,
                onChanged: (value) {
                  context.pop();
                  _setCalculationMethod(value!);
                },
                activeColor: IslamicTheme.islamicGreen,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(WidgetRef ref) {
    final availableLanguages = ref.read(availableLanguagesProvider);
    final currentLanguage = ref.read(currentLanguageProvider);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.settingsSelectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableLanguages.map((languageData) {
            final language = SupportedLanguage.fromCode(languageData.code);

            return RadioListTile<SupportedLanguage>(
              title: Row(
                children: [
                  Text(languageData.flagEmoji),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          languageData.nativeName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          languageData.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!languageData.isFullySupported)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.settingsComingSoon,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.orange[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              value: language,
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context.pop();
                  _setLanguage(value, ref);
                }
              },
              activeColor: IslamicTheme.islamicGreen,
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.settingsAbout),
        content: const Text(
          'DeenMate is a comprehensive Islamic utility app designed to help Muslims in their daily religious practices.\n\n'
          'Features:\n'
          '• Prayer Times with multiple calculation methods\n'
          '• Qibla Compass\n'
          '• Zakat Calculator\n'
          '• Daily Quran verses and Hadith\n'
          '• Islamic Calendar\n'
          '• Prayer tracking and reminders\n\n'
          'May Allah accept our efforts and make this beneficial for the Ummah.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(AppLocalizations.of(context)!.buttonCancel,
                style: const TextStyle(color: IslamicTheme.islamicGreen)),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.settingsPrivacyPolicy),
        content: const Text(
          'Your privacy is important to us. This app:\n\n'
          '• Only uses location for prayer times and Qibla direction\n'
          '• Stores data locally on your device\n'
          '• Does not collect personal information\n'
          '• Does not share data with third parties\n'
          '• Uses prayer time APIs for accuracy\n\n'
          'All data remains on your device and under your control.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(AppLocalizations.of(context)!.commonClose,
                style: TextStyle(color: IslamicTheme.islamicGreen)),
          ),
        ],
      ),
    );
  }

  // _showPermissionDialog removed (unused)

  Future<void> _setCalculationMethod(int method) async {
    setState(() {
      _selectedCalculationMethod = method;
    });
    try {
      // Convert index to method name and persist via centralized state
      final methodName = PreferenceKeys.getCalculationMethodName(method);
      await PrayerSettingsState.instance.setCalculationMethod(methodName);
      // Invalidate providers to recalculate with new settings
      ref.invalidate(prayerSettingsProvider);
      ref.invalidate(currentPrayerTimesProvider);
      // Reschedule notifications to reflect new prayer times
      await ref.read(autoNotificationSchedulerProvider).rescheduleAll();
    } catch (e) {
      debugPrint('Error saving calculation method: $e');
    }

    await _saveSettings();
  }

  Future<void> _setLanguage(SupportedLanguage language, WidgetRef ref) async {
    try {
      // Use the language switcher to change language
      final languageSwitcher = ref.read(languageSwitcherProvider);
      final success = await languageSwitcher.switchLanguage(language);

      if (success) {
        // Show success message for unsupported languages
        if (!language.isFullySupported) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.settingsLanguageComingSoon(language.nativeName),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: const Color(0xFFFF9800),
                duration: const Duration(seconds: 3),
              ),
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.settingsLanguageChanged(language.nativeName),
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: IslamicTheme.islamicGreen,
              ),
            );
          }
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.errorLanguageChangeFailed,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (error) {
      debugPrint('Error changing language: $error');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.errorLanguageChangeGeneric,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.settingsClearCache),
        content: Text(
            AppLocalizations.of(context)!.settingsClearCacheConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(AppLocalizations.of(context)!.buttonCancel),
          ),
          TextButton(
            onPressed: () => context.pop(true),
            child: Text(AppLocalizations.of(context)!.buttonClear,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Clear cache logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text(AppLocalizations.of(context)!.settingsCacheClearedSuccess),
          backgroundColor: IslamicTheme.islamicGreen,
        ),
      );
    }
  }

  Future<void> _exportData() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.settingsExportComingSoon),
        backgroundColor: IslamicTheme.islamicGreen,
      ),
    );
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _prayerNotificationsEnabled =
            prefs.getBool(PreferenceKeys.notificationsEnabled) ?? true;
        _prayerRemindersEnabled =
            prefs.getBool(PreferenceKeys.prayerRemindersEnabled) ?? true;
        _dailyVersesEnabled = prefs.getBool('daily_verses') ?? true;
        _islamicMidnightEnabled = prefs.getBool('islamic_midnight') ?? true;

        // Fix calculation method sync: read stored method name and convert to index
        final storedMethodName =
            prefs.getString(PreferenceKeys.calculationMethod) ?? 'MWL';
        _selectedCalculationMethod =
            PreferenceKeys.getCalculationMethodIndex(storedMethodName);

        _selectedLanguage = prefs.getString('language') ?? 'English';
        _userName = prefs.getString(PreferenceKeys.userName) ?? '';
      });
    } catch (e) {
      debugPrint('Error loading settings: $e');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
          PreferenceKeys.notificationsEnabled, _prayerNotificationsEnabled);
      await prefs.setBool(
          PreferenceKeys.prayerRemindersEnabled, _prayerRemindersEnabled);
      await prefs.setBool('daily_verses', _dailyVersesEnabled);
      await prefs.setBool('islamic_midnight', _islamicMidnightEnabled);

      // Fix calculation method sync: convert index to method name before storing
      final methodName =
          PreferenceKeys.getCalculationMethodName(_selectedCalculationMethod);
      await prefs.setString(PreferenceKeys.calculationMethod, methodName);

      await prefs.setString('language', _selectedLanguage);
      if (_userName.isNotEmpty) {
        await prefs.setString(PreferenceKeys.userName, _userName);
      }
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }
}

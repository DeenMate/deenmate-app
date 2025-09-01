import '../../domain/entities/app_settings.dart';
import '../../domain/entities/accessibility_settings.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

/// Implementation of SettingsRepository
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource localDatasource;

  SettingsRepositoryImpl({
    required this.localDatasource,
  });

  @override
  Future<AppSettings> getAppSettings() async {
    return await localDatasource.getAppSettings();
  }

  @override
  Future<void> updateAppSettings(AppSettings settings) async {
    await localDatasource.saveAppSettings(settings);
  }

  @override
  Stream<AppSettings> watchAppSettings() {
    return localDatasource.watchAppSettings();
  }

  @override
  Future<AccessibilitySettings> getAccessibilitySettings() async {
    return await localDatasource.getAccessibilitySettings();
  }

  @override
  Future<void> updateAccessibilitySettings(AccessibilitySettings settings) async {
    await localDatasource.saveAccessibilitySettings(settings);
  }

  @override
  Stream<AccessibilitySettings> watchAccessibilitySettings() {
    return localDatasource.watchAccessibilitySettings();
  }

  @override
  Future<PrayerSettings> getPrayerSettings() async {
    return await localDatasource.getPrayerSettings();
  }

  @override
  Future<void> updatePrayerSettings(PrayerSettings settings) async {
    await localDatasource.savePrayerSettings(settings);
  }

  @override
  Stream<PrayerSettings> watchPrayerSettings() {
    return localDatasource.watchPrayerSettings();
  }

  @override
  Future<UserPreferences> getUserPreferences() async {
    return await localDatasource.getUserPreferences();
  }

  @override
  Future<void> updateUserPreferences(UserPreferences preferences) async {
    await localDatasource.saveUserPreferences(preferences);
  }

  @override
  Stream<UserPreferences> watchUserPreferences() {
    return localDatasource.watchUserPreferences();
  }

  @override
  Future<void> resetToDefaults() async {
    await localDatasource.clearAllSettings();
  }

  @override
  Future<Map<String, dynamic>> exportSettings() async {
    return await localDatasource.exportAllSettings();
  }

  @override
  Future<void> importSettings(Map<String, dynamic> settings) async {
    await localDatasource.importAllSettings(settings);
  }

  @override
  Future<void> updateTheme(String themeMode) async {
    final currentSettings = await getAppSettings();
    final updatedSettings = currentSettings.copyWith(
      themeMode: themeMode,
      lastUpdated: DateTime.now(),
    );
    await updateAppSettings(updatedSettings);
  }

  @override
  Future<void> updateLanguage(String languageCode) async {
    final currentSettings = await getAppSettings();
    final updatedSettings = currentSettings.copyWith(
      languageCode: languageCode,
      lastUpdated: DateTime.now(),
    );
    await updateAppSettings(updatedSettings);
  }

  @override
  Future<void> updateFontSize(double fontSize) async {
    final currentSettings = await getAppSettings();
    final updatedSettings = currentSettings.copyWith(
      fontSize: fontSize,
      lastUpdated: DateTime.now(),
    );
    await updateAppSettings(updatedSettings);
  }

  @override
  Future<void> updateTextScale(double scaleFactor) async {
    final currentSettings = await getAccessibilitySettings();
    final updatedSettings = currentSettings.copyWith(
      textScaleFactor: scaleFactor,
      lastUpdated: DateTime.now(),
    );
    await updateAccessibilitySettings(updatedSettings);
  }

  @override
  Future<void> updatePrayerNotifications(bool enabled) async {
    final currentSettings = await getPrayerSettings();
    final updatedSettings = currentSettings.copyWith(
      notificationsEnabled: enabled,
      lastUpdated: DateTime.now(),
    );
    await updatePrayerSettings(updatedSettings);
  }

  @override
  Future<void> updateAthanSound(String soundName) async {
    final currentSettings = await getPrayerSettings();
    final updatedSettings = currentSettings.copyWith(
      athanSound: soundName,
      lastUpdated: DateTime.now(),
    );
    await updatePrayerSettings(updatedSettings);
  }

  @override
  Future<bool> validateSettings() async {
    try {
      final appSettings = await getAppSettings();
      final accessibilitySettings = await getAccessibilitySettings();
      final prayerSettings = await getPrayerSettings();
      final userPreferences = await getUserPreferences();

      return appSettings.isValid &&
             accessibilitySettings.isValid &&
             prayerSettings.isValid &&
             userPreferences.isValid;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<String>> getSettingsErrors() async {
    final errors = <String>[];

    try {
      final appSettings = await getAppSettings();
      if (!appSettings.isValid) {
        if (!appSettings.isValidTheme) errors.add('Invalid theme mode');
        if (!appSettings.isValidLanguage) errors.add('Invalid language code');
        if (!appSettings.isValidFontSize) errors.add('Invalid font size');
        if (!appSettings.isValidDateFormat) errors.add('Invalid date format');
      }

      final accessibilitySettings = await getAccessibilitySettings();
      if (!accessibilitySettings.isValid) {
        if (!accessibilitySettings.isValidTextScale) {
          errors.add('Invalid text scale factor');
        }
        if (!accessibilitySettings.isValidFocusStyle) {
          errors.add('Invalid focus style');
        }
      }

      final prayerSettings = await getPrayerSettings();
      if (!prayerSettings.isValid) {
        if (!prayerSettings.isValidVolume) errors.add('Invalid athan volume');
        if (!prayerSettings.isValidCalculationMethod) {
          errors.add('Invalid calculation method');
        }
        if (!prayerSettings.isValidMadhab) errors.add('Invalid madhab');
        if (!prayerSettings.isValidAthanSound) errors.add('Invalid athan sound');
      }

      final userPreferences = await getUserPreferences();
      if (!userPreferences.isValid) {
        if (!userPreferences.isValidBackupFrequency) {
          errors.add('Invalid backup frequency');
        }
      }
    } catch (e) {
      errors.add('Failed to validate settings: $e');
    }

    return errors;
  }
}

import '../entities/app_settings.dart';
import '../entities/accessibility_settings.dart';
import '../entities/prayer_settings.dart';
import '../entities/user_preferences.dart';

/// Abstract repository for settings management
abstract class SettingsRepository {
  // App Settings
  Future<AppSettings> getAppSettings();
  Future<void> updateAppSettings(AppSettings settings);
  Stream<AppSettings> watchAppSettings();

  // Accessibility Settings
  Future<AccessibilitySettings> getAccessibilitySettings();
  Future<void> updateAccessibilitySettings(AccessibilitySettings settings);
  Stream<AccessibilitySettings> watchAccessibilitySettings();

  // Prayer Settings
  Future<PrayerSettings> getPrayerSettings();
  Future<void> updatePrayerSettings(PrayerSettings settings);
  Stream<PrayerSettings> watchPrayerSettings();

  // User Preferences
  Future<UserPreferences> getUserPreferences();
  Future<void> updateUserPreferences(UserPreferences preferences);
  Stream<UserPreferences> watchUserPreferences();

  // Bulk Operations
  Future<void> resetToDefaults();
  Future<Map<String, dynamic>> exportSettings();
  Future<void> importSettings(Map<String, dynamic> settings);

  // Specific Setting Updates
  Future<void> updateTheme(String themeMode);
  Future<void> updateLanguage(String languageCode);
  Future<void> updateFontSize(double fontSize);
  Future<void> updateTextScale(double scaleFactor);
  Future<void> updatePrayerNotifications(bool enabled);
  Future<void> updateAthanSound(String soundName);

  // Validation
  Future<bool> validateSettings();
  Future<List<String>> getSettingsErrors();
}

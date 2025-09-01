import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/accessibility_settings.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/user_preferences.dart';

/// Local data source for settings using SharedPreferences
abstract class SettingsLocalDatasource {
  Future<AppSettings> getAppSettings();
  Future<void> saveAppSettings(AppSettings settings);
  Stream<AppSettings> watchAppSettings();

  Future<AccessibilitySettings> getAccessibilitySettings();
  Future<void> saveAccessibilitySettings(AccessibilitySettings settings);
  Stream<AccessibilitySettings> watchAccessibilitySettings();

  Future<PrayerSettings> getPrayerSettings();
  Future<void> savePrayerSettings(PrayerSettings settings);
  Stream<PrayerSettings> watchPrayerSettings();

  Future<UserPreferences> getUserPreferences();
  Future<void> saveUserPreferences(UserPreferences preferences);
  Stream<UserPreferences> watchUserPreferences();

  Future<void> clearAllSettings();
  Future<Map<String, dynamic>> exportAllSettings();
  Future<void> importAllSettings(Map<String, dynamic> settings);
}

/// Implementation of SettingsLocalDatasource using SharedPreferences
class SettingsLocalDatasourceImpl implements SettingsLocalDatasource {
  static const String _appSettingsKey = 'app_settings';
  static const String _accessibilitySettingsKey = 'accessibility_settings';
  static const String _prayerSettingsKey = 'prayer_settings';
  static const String _userPreferencesKey = 'user_preferences';

  final StreamController<AppSettings> _appSettingsController = 
      StreamController<AppSettings>.broadcast();
  final StreamController<AccessibilitySettings> _accessibilityController = 
      StreamController<AccessibilitySettings>.broadcast();
  final StreamController<PrayerSettings> _prayerController = 
      StreamController<PrayerSettings>.broadcast();
  final StreamController<UserPreferences> _preferencesController = 
      StreamController<UserPreferences>.broadcast();

  @override
  Future<AppSettings> getAppSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_appSettingsKey);
    
    if (settingsJson != null) {
      try {
        final json = jsonDecode(settingsJson) as Map<String, dynamic>;
        return AppSettings.fromJson(json);
      } catch (e) {
        // If parsing fails, return default settings
        return AppSettings.defaultSettings();
      }
    }
    
    return AppSettings.defaultSettings();
  }

  @override
  Future<void> saveAppSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = jsonEncode(settings.toJson());
    await prefs.setString(_appSettingsKey, settingsJson);
    
    // Notify watchers
    _appSettingsController.add(settings);
  }

  @override
  Stream<AppSettings> watchAppSettings() => _appSettingsController.stream;

  @override
  Future<AccessibilitySettings> getAccessibilitySettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_accessibilitySettingsKey);
    
    if (settingsJson != null) {
      try {
        final json = jsonDecode(settingsJson) as Map<String, dynamic>;
        return AccessibilitySettings.fromJson(json);
      } catch (e) {
        return AccessibilitySettings.defaultSettings();
      }
    }
    
    return AccessibilitySettings.defaultSettings();
  }

  @override
  Future<void> saveAccessibilitySettings(AccessibilitySettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = jsonEncode(settings.toJson());
    await prefs.setString(_accessibilitySettingsKey, settingsJson);
    
    // Notify watchers
    _accessibilityController.add(settings);
  }

  @override
  Stream<AccessibilitySettings> watchAccessibilitySettings() => 
      _accessibilityController.stream;

  @override
  Future<PrayerSettings> getPrayerSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString(_prayerSettingsKey);
    
    if (settingsJson != null) {
      try {
        final json = jsonDecode(settingsJson) as Map<String, dynamic>;
        return PrayerSettings.fromJson(json);
      } catch (e) {
        return PrayerSettings.defaultSettings();
      }
    }
    
    return PrayerSettings.defaultSettings();
  }

  @override
  Future<void> savePrayerSettings(PrayerSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = jsonEncode(settings.toJson());
    await prefs.setString(_prayerSettingsKey, settingsJson);
    
    // Notify watchers
    _prayerController.add(settings);
  }

  @override
  Stream<PrayerSettings> watchPrayerSettings() => _prayerController.stream;

  @override
  Future<UserPreferences> getUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final preferencesJson = prefs.getString(_userPreferencesKey);
    
    if (preferencesJson != null) {
      try {
        final json = jsonDecode(preferencesJson) as Map<String, dynamic>;
        return UserPreferences.fromJson(json);
      } catch (e) {
        return UserPreferences.defaultPreferences();
      }
    }
    
    return UserPreferences.defaultPreferences();
  }

  @override
  Future<void> saveUserPreferences(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    final preferencesJson = jsonEncode(preferences.toJson());
    await prefs.setString(_userPreferencesKey, preferencesJson);
    
    // Notify watchers
    _preferencesController.add(preferences);
  }

  @override
  Stream<UserPreferences> watchUserPreferences() => _preferencesController.stream;

  @override
  Future<void> clearAllSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_appSettingsKey);
    await prefs.remove(_accessibilitySettingsKey);
    await prefs.remove(_prayerSettingsKey);
    await prefs.remove(_userPreferencesKey);
    
    // Notify watchers with default settings
    _appSettingsController.add(AppSettings.defaultSettings());
    _accessibilityController.add(AccessibilitySettings.defaultSettings());
    _prayerController.add(PrayerSettings.defaultSettings());
    _preferencesController.add(UserPreferences.defaultPreferences());
  }

  @override
  Future<Map<String, dynamic>> exportAllSettings() async {
    final appSettings = await getAppSettings();
    final accessibilitySettings = await getAccessibilitySettings();
    final prayerSettings = await getPrayerSettings();
    final userPreferences = await getUserPreferences();

    return {
      'appSettings': appSettings.toJson(),
      'accessibilitySettings': accessibilitySettings.toJson(),
      'prayerSettings': prayerSettings.toJson(),
      'userPreferences': userPreferences.toExportJson(),
    };
  }

  @override
  Future<void> importAllSettings(Map<String, dynamic> settings) async {
    try {
      if (settings.containsKey('appSettings')) {
        final appSettings = AppSettings.fromJson(settings['appSettings']);
        await saveAppSettings(appSettings);
      }

      if (settings.containsKey('accessibilitySettings')) {
        final accessibilitySettings = 
            AccessibilitySettings.fromJson(settings['accessibilitySettings']);
        await saveAccessibilitySettings(accessibilitySettings);
      }

      if (settings.containsKey('prayerSettings')) {
        final prayerSettings = PrayerSettings.fromJson(settings['prayerSettings']);
        await savePrayerSettings(prayerSettings);
      }

      if (settings.containsKey('userPreferences')) {
        final userPreferences = UserPreferences.fromJson(settings['userPreferences']);
        await saveUserPreferences(userPreferences);
      }
    } catch (e) {
      throw Exception('Failed to import settings: $e');
    }
  }

  void dispose() {
    _appSettingsController.close();
    _accessibilityController.close();
    _prayerController.close();
    _preferencesController.close();
  }
}

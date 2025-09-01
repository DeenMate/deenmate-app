import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/accessibility_settings.dart';
import '../../domain/entities/prayer_settings.dart';
import '../../domain/entities/user_preferences.dart';
import '../../domain/repositories/settings_repository.dart';
import '../../domain/usecases/get_app_settings.dart';
import '../../domain/usecases/update_app_settings.dart';
import '../../domain/usecases/get_accessibility_settings.dart';
import '../../domain/usecases/update_accessibility_settings.dart';
import '../../domain/usecases/reset_settings.dart';
import '../../domain/usecases/export_settings.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../data/datasources/settings_local_datasource.dart';

// Data Source Provider
final settingsLocalDatasourceProvider = Provider<SettingsLocalDatasource>((ref) {
  return SettingsLocalDatasourceImpl();
});

// Repository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    localDatasource: ref.read(settingsLocalDatasourceProvider),
  );
});

// Use Case Providers
final getAppSettingsProvider = Provider<GetAppSettings>((ref) {
  return GetAppSettings(ref.read(settingsRepositoryProvider));
});

final updateAppSettingsProvider = Provider<UpdateAppSettings>((ref) {
  return UpdateAppSettings(ref.read(settingsRepositoryProvider));
});

final getAccessibilitySettingsProvider = Provider<GetAccessibilitySettings>((ref) {
  return GetAccessibilitySettings(ref.read(settingsRepositoryProvider));
});

final updateAccessibilitySettingsProvider = Provider<UpdateAccessibilitySettings>((ref) {
  return UpdateAccessibilitySettings(ref.read(settingsRepositoryProvider));
});

final resetSettingsProvider = Provider<ResetSettings>((ref) {
  return ResetSettings(ref.read(settingsRepositoryProvider));
});

final exportSettingsProvider = Provider<ExportSettings>((ref) {
  return ExportSettings(ref.read(settingsRepositoryProvider));
});

// App Settings Provider
final appSettingsProvider = StateNotifierProvider<AppSettingsNotifier, AsyncValue<AppSettings>>((ref) {
  return AppSettingsNotifier(ref.read(settingsRepositoryProvider));
});

class AppSettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final SettingsRepository _repository;
  StreamSubscription? _subscription;

  AppSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  void _loadSettings() async {
    try {
      final settings = await _repository.getAppSettings();
      state = AsyncValue.data(settings);
      
      // Watch for changes
      _subscription = _repository.watchAppSettings().listen((settings) {
        state = AsyncValue.data(settings);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateTheme(String themeMode) async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        themeMode: themeMode,
        lastUpdated: DateTime.now(),
      );
      
      state = const AsyncValue.loading();
      try {
        await _repository.updateAppSettings(updatedSettings);
        state = AsyncValue.data(updatedSettings);
      } catch (e, stackTrace) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  Future<void> updateLanguage(String languageCode) async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        languageCode: languageCode,
        lastUpdated: DateTime.now(),
      );
      
      state = const AsyncValue.loading();
      try {
        await _repository.updateAppSettings(updatedSettings);
        state = AsyncValue.data(updatedSettings);
      } catch (e, stackTrace) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  Future<void> updateFontSize(double fontSize) async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        fontSize: fontSize,
        lastUpdated: DateTime.now(),
      );
      
      state = const AsyncValue.loading();
      try {
        await _repository.updateAppSettings(updatedSettings);
        state = AsyncValue.data(updatedSettings);
      } catch (e, stackTrace) {
        state = AsyncValue.error(e, stackTrace);
      }
    }
  }

  Future<void> toggleAnimations() async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        animationsEnabled: !currentSettings.animationsEnabled,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateAppSettings(updatedSettings);
    }
  }

  Future<void> updateDateFormat(String dateFormat) async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        dateFormat: dateFormat,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateAppSettings(updatedSettings);
    }
  }

  Future<void> toggleHijriCalendar() async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        hijriCalendar: !currentSettings.hijriCalendar,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateAppSettings(updatedSettings);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// Accessibility Settings Provider
final accessibilitySettingsProvider = StateNotifierProvider<AccessibilitySettingsNotifier, AsyncValue<AccessibilitySettings>>((ref) {
  return AccessibilitySettingsNotifier(ref.read(settingsRepositoryProvider));
});

class AccessibilitySettingsNotifier extends StateNotifier<AsyncValue<AccessibilitySettings>> {
  final SettingsRepository _repository;
  StreamSubscription? _subscription;

  AccessibilitySettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  void _loadSettings() async {
    try {
      final settings = await _repository.getAccessibilitySettings();
      state = AsyncValue.data(settings);
      
      // Watch for changes
      _subscription = _repository.watchAccessibilitySettings().listen((settings) {
        state = AsyncValue.data(settings);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateTextScale(double scaleFactor) async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        textScaleFactor: scaleFactor,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateAccessibilitySettings(updatedSettings);
    }
  }

  Future<void> toggleHighContrast() async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        highContrastMode: !currentSettings.highContrastMode,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateAccessibilitySettings(updatedSettings);
    }
  }

  Future<void> toggleReducedMotion() async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        reducedMotion: !currentSettings.reducedMotion,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateAccessibilitySettings(updatedSettings);
    }
  }

  Future<void> toggleScreenReaderMode() async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        screenReaderMode: !currentSettings.screenReaderMode,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateAccessibilitySettings(updatedSettings);
    }
  }

  Future<void> toggleLargeTextMode() async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        largeTextMode: !currentSettings.largeTextMode,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateAccessibilitySettings(updatedSettings);
    }
  }

  Future<void> optimizeForScreenReader() async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final optimizedSettings = currentSettings.optimizedForScreenReader;
      
      await _repository.updateAccessibilitySettings(optimizedSettings);
    }
  }

  Future<void> optimizeForLowVision() async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final optimizedSettings = currentSettings.optimizedForLowVision;
      
      await _repository.updateAccessibilitySettings(optimizedSettings);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// Prayer Settings Provider
final prayerSettingsProvider = StateNotifierProvider<PrayerSettingsNotifier, AsyncValue<PrayerSettings>>((ref) {
  return PrayerSettingsNotifier(ref.read(settingsRepositoryProvider));
});

class PrayerSettingsNotifier extends StateNotifier<AsyncValue<PrayerSettings>> {
  final SettingsRepository _repository;
  StreamSubscription? _subscription;

  PrayerSettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  void _loadSettings() async {
    try {
      final settings = await _repository.getPrayerSettings();
      state = AsyncValue.data(settings);
      
      // Watch for changes
      _subscription = _repository.watchPrayerSettings().listen((settings) {
        state = AsyncValue.data(settings);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> toggleNotifications() async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        notificationsEnabled: !currentSettings.notificationsEnabled,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updatePrayerSettings(updatedSettings);
    }
  }

  Future<void> updateAthanSound(String soundName) async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        athanSound: soundName,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updatePrayerSettings(updatedSettings);
    }
  }

  Future<void> updateVolume(double volume) async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        athanVolume: volume,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updatePrayerSettings(updatedSettings);
    }
  }

  Future<void> updateCalculationMethod(int method) async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.copyWith(
        calculationMethod: method,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updatePrayerSettings(updatedSettings);
    }
  }

  Future<void> updatePrayerAdjustment(String prayer, int minutes) async {
    if (state.hasValue) {
      final currentSettings = state.value!;
      final updatedSettings = currentSettings.setAdjustment(prayer, minutes);
      
      await _repository.updatePrayerSettings(updatedSettings);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

// User Preferences Provider
final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, AsyncValue<UserPreferences>>((ref) {
  return UserPreferencesNotifier(ref.read(settingsRepositoryProvider));
});

class UserPreferencesNotifier extends StateNotifier<AsyncValue<UserPreferences>> {
  final SettingsRepository _repository;
  StreamSubscription? _subscription;

  UserPreferencesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  void _loadSettings() async {
    try {
      final preferences = await _repository.getUserPreferences();
      state = AsyncValue.data(preferences);
      
      // Watch for changes
      _subscription = _repository.watchUserPreferences().listen((preferences) {
        state = AsyncValue.data(preferences);
      });
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateProfileName(String name) async {
    if (state.hasValue) {
      final currentPreferences = state.value!;
      final updatedPreferences = currentPreferences.copyWith(
        profileName: name,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateUserPreferences(updatedPreferences);
    }
  }

  Future<void> toggleAnalytics() async {
    if (state.hasValue) {
      final currentPreferences = state.value!;
      final updatedPreferences = currentPreferences.copyWith(
        analyticsEnabled: !currentPreferences.analyticsEnabled,
        lastUpdated: DateTime.now(),
      );
      
      await _repository.updateUserPreferences(updatedPreferences);
    }
  }

  Future<void> toggleFeatureFlag(String flagName) async {
    if (state.hasValue) {
      final currentPreferences = state.value!;
      final currentValue = currentPreferences.getFeatureFlag(flagName);
      final updatedPreferences = currentPreferences.setFeatureFlag(flagName, !currentValue);
      
      await _repository.updateUserPreferences(updatedPreferences);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

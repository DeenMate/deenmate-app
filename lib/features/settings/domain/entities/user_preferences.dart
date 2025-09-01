import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';
part 'user_preferences.g.dart';

/// User preferences and profile settings entity
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    required String profileName,         // User display name
    required bool analyticsEnabled,      // Usage analytics consent
    required bool crashReportingEnabled, // Crash reporting consent
    required bool backupEnabled,         // Settings backup enabled
    required String backupFrequency,     // daily, weekly, monthly
    required bool syncAcrossDevices,     // Cross-device sync
    required Map<String, bool> featureFlags, // Experimental features
    required Map<String, dynamic> customPreferences, // Custom settings
    required DateTime lastUpdated,       // Last modification time
  }) = _UserPreferences;

  factory UserPreferences.fromJson(Map<String, dynamic> json) =>
      _$UserPreferencesFromJson(json);

  /// Default user preferences
  factory UserPreferences.defaultPreferences() => UserPreferences(
    profileName: '',
    analyticsEnabled: false,
    crashReportingEnabled: true,
    backupEnabled: true,
    backupFrequency: 'weekly',
    syncAcrossDevices: true,
    featureFlags: {},
    customPreferences: {},
    lastUpdated: DateTime.now(),
  );

  /// Validate user preferences
  const UserPreferences._();

  bool get isValidBackupFrequency => [
    'daily', 'weekly', 'monthly', 'never'
  ].contains(backupFrequency);

  bool get hasValidProfileName => profileName.isNotEmpty && profileName.length <= 50;

  /// Check if all user preferences are valid
  bool get isValid => isValidBackupFrequency;

  /// Get feature flag value
  bool getFeatureFlag(String flagName) => featureFlags[flagName] ?? false;

  /// Set feature flag
  UserPreferences setFeatureFlag(String flagName, bool enabled) => copyWith(
    featureFlags: {...featureFlags, flagName: enabled},
    lastUpdated: DateTime.now(),
  );

  /// Get custom preference
  T? getCustomPreference<T>(String key) => customPreferences[key] as T?;

  /// Set custom preference
  UserPreferences setCustomPreference<T>(String key, T value) => copyWith(
    customPreferences: {...customPreferences, key: value},
    lastUpdated: DateTime.now(),
  );

  /// Privacy-focused settings
  UserPreferences get privacyFocused => copyWith(
    analyticsEnabled: false,
    crashReportingEnabled: false,
    syncAcrossDevices: false,
    backupEnabled: false,
    lastUpdated: DateTime.now(),
  );

  /// Development-friendly settings
  UserPreferences get developmentMode => copyWith(
    analyticsEnabled: true,
    crashReportingEnabled: true,
    featureFlags: {
      'debug_mode': true,
      'performance_overlay': true,
      'beta_features': true,
      ...featureFlags,
    },
    lastUpdated: DateTime.now(),
  );

  /// Export safe preferences (without sensitive data)
  Map<String, dynamic> toExportJson() => {
    'profileName': profileName,
    'backupFrequency': backupFrequency,
    'featureFlags': featureFlags,
    'customPreferences': customPreferences,
    'lastUpdated': lastUpdated.toIso8601String(),
  };
}

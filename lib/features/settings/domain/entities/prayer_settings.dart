import 'package:freezed_annotation/freezed_annotation.dart';

part 'prayer_settings.freezed.dart';
part 'prayer_settings.g.dart';

/// Prayer-specific settings entity
@freezed
class PrayerSettings with _$PrayerSettings {
  const factory PrayerSettings({
    required bool notificationsEnabled,  // Prayer notifications
    required bool remindersEnabled,      // Prayer reminders
    required String athanSound,          // Selected athan audio
    required double athanVolume,         // 0.0 - 1.0
    required bool vibrateOnAzan,         // Vibration on athan
    required int calculationMethod,      // Prayer calculation method
    required Map<String, int> adjustments, // Prayer time adjustments in minutes
    required bool qiblaInNotification,   // Show Qibla in notification
    required String madhab,              // Jurisprudence school
    required bool islamicMidnight,       // Islamic vs standard midnight
    required DateTime lastUpdated,       // Last modification time
  }) = _PrayerSettings;

  factory PrayerSettings.fromJson(Map<String, dynamic> json) =>
      _$PrayerSettingsFromJson(json);

  /// Default prayer settings
  factory PrayerSettings.defaultSettings() => PrayerSettings(
    notificationsEnabled: true,
    remindersEnabled: true,
    athanSound: 'madinah',
    athanVolume: 0.8,
    vibrateOnAzan: true,
    calculationMethod: 2, // ISNA
    adjustments: {
      'fajr': 0,
      'dhuhr': 0,
      'asr': 0,
      'maghrib': 0,
      'isha': 0,
    },
    qiblaInNotification: true,
    madhab: 'hanafi',
    islamicMidnight: true,
    lastUpdated: DateTime.now(),
  );

  /// Validate prayer settings
  const PrayerSettings._();

  bool get isValidVolume => athanVolume >= 0.0 && athanVolume <= 1.0;
  bool get isValidCalculationMethod => calculationMethod >= 0 && calculationMethod <= 10;
  bool get isValidMadhab => ['hanafi', 'shafi', 'maliki', 'hanbali'].contains(madhab);
  bool get isValidAthanSound => [
    'madinah', 'makkah', 'egypt', 'turkey', 'syria', 'custom'
  ].contains(athanSound);

  /// Check if all prayer settings are valid
  bool get isValid => 
    isValidVolume && 
    isValidCalculationMethod && 
    isValidMadhab && 
    isValidAthanSound;

  /// Get adjustment for specific prayer
  int getAdjustment(String prayer) => adjustments[prayer.toLowerCase()] ?? 0;

  /// Update adjustment for specific prayer
  PrayerSettings setAdjustment(String prayer, int minutes) {
    final newAdjustments = Map<String, int>.from(adjustments);
    newAdjustments[prayer.toLowerCase()] = minutes.clamp(-30, 30);
    return copyWith(
      adjustments: newAdjustments,
      lastUpdated: DateTime.now(),
    );
  }

  /// Reset all adjustments to zero
  PrayerSettings resetAdjustments() => copyWith(
    adjustments: {
      'fajr': 0,
      'dhuhr': 0,
      'asr': 0,
      'maghrib': 0,
      'isha': 0,
    },
    lastUpdated: DateTime.now(),
  );

  /// Get settings optimized for silent mode
  PrayerSettings get silentMode => copyWith(
    athanVolume: 0.0,
    vibrateOnAzan: true,
    lastUpdated: DateTime.now(),
  );

  /// Get settings optimized for maximum alerts
  PrayerSettings get maximumAlerts => copyWith(
    notificationsEnabled: true,
    remindersEnabled: true,
    athanVolume: 1.0,
    vibrateOnAzan: true,
    qiblaInNotification: true,
    lastUpdated: DateTime.now(),
  );
}

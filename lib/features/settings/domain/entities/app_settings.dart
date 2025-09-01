import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';
part 'app_settings.g.dart';

/// Core application settings entity
@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required String themeMode,          // light, dark, system, islamic
    required String languageCode,       // en, bn, ar
    required String fontFamily,         // system, islamic, custom
    required double fontSize,           // 12.0 - 24.0
    required bool animationsEnabled,    // true/false
    required String dateFormat,         // dd/mm/yyyy, mm/dd/yyyy, islamic
    required bool hijriCalendar,        // true for Hijri primary
    required Map<String, dynamic> customizations, // User customizations
    required DateTime lastUpdated,      // Last modification time
  }) = _AppSettings;

  factory AppSettings.fromJson(Map<String, dynamic> json) =>
      _$AppSettingsFromJson(json);

  /// Default app settings
  factory AppSettings.defaultSettings() => AppSettings(
    themeMode: 'system',
    languageCode: 'en',
    fontFamily: 'system',
    fontSize: 16.0,
    animationsEnabled: true,
    dateFormat: 'dd/mm/yyyy',
    hijriCalendar: false,
    customizations: {},
    lastUpdated: DateTime.now(),
  );

  /// Validate settings values
  const AppSettings._();

  bool get isValidTheme => ['light', 'dark', 'system', 'islamic'].contains(themeMode);
  bool get isValidLanguage => ['en', 'bn', 'ar'].contains(languageCode);
  bool get isValidFontSize => fontSize >= 12.0 && fontSize <= 24.0;
  bool get isValidDateFormat => ['dd/mm/yyyy', 'mm/dd/yyyy', 'islamic'].contains(dateFormat);

  /// Check if all settings are valid
  bool get isValid => isValidTheme && isValidLanguage && isValidFontSize && isValidDateFormat;
}

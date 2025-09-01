import 'package:freezed_annotation/freezed_annotation.dart';

part 'accessibility_settings.freezed.dart';
part 'accessibility_settings.g.dart';

/// Accessibility configuration settings entity
@freezed
class AccessibilitySettings with _$AccessibilitySettings {
  const factory AccessibilitySettings({
    required double textScaleFactor,    // 0.5 - 2.0
    required bool highContrastMode,     // Enhanced visibility
    required bool reducedMotion,        // Reduced animations
    required bool screenReaderMode,     // Screen reader optimization
    required bool largeTextMode,        // Large text support
    required bool colorBlindSupport,    // Color blind friendly
    required String focusStyle,         // focus indicator style
    required bool hapticFeedback,       // Vibration feedback
    required bool audioDescriptions,    // Audio content descriptions
    required Map<String, bool> assistiveFeatures, // Custom accessibility
    required DateTime lastUpdated,      // Last modification time
  }) = _AccessibilitySettings;

  factory AccessibilitySettings.fromJson(Map<String, dynamic> json) =>
      _$AccessibilitySettingsFromJson(json);

  /// Default accessibility settings
  factory AccessibilitySettings.defaultSettings() => AccessibilitySettings(
    textScaleFactor: 1.0,
    highContrastMode: false,
    reducedMotion: false,
    screenReaderMode: false,
    largeTextMode: false,
    colorBlindSupport: false,
    focusStyle: 'standard',
    hapticFeedback: true,
    audioDescriptions: false,
    assistiveFeatures: {},
    lastUpdated: DateTime.now(),
  );

  /// Validate accessibility settings
  const AccessibilitySettings._();

  bool get isValidTextScale => textScaleFactor >= 0.5 && textScaleFactor <= 2.0;
  bool get isValidFocusStyle => ['standard', 'enhanced', 'high-contrast'].contains(focusStyle);

  /// Check if all accessibility settings are valid
  bool get isValid => isValidTextScale && isValidFocusStyle;

  /// Get recommended settings for screen readers
  AccessibilitySettings get optimizedForScreenReader => copyWith(
    screenReaderMode: true,
    reducedMotion: true,
    audioDescriptions: true,
    hapticFeedback: true,
    focusStyle: 'enhanced',
    lastUpdated: DateTime.now(),
  );

  /// Get recommended settings for low vision
  AccessibilitySettings get optimizedForLowVision => copyWith(
    highContrastMode: true,
    largeTextMode: true,
    textScaleFactor: 1.5,
    focusStyle: 'high-contrast',
    lastUpdated: DateTime.now(),
  );

  /// Get recommended settings for motor impairments
  AccessibilitySettings get optimizedForMotorImpairment => copyWith(
    reducedMotion: true,
    hapticFeedback: true,
    focusStyle: 'enhanced',
    lastUpdated: DateTime.now(),
  );
}

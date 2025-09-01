# Settings Module - Technical Specification

**Module**: Settings  
**Purpose**: Comprehensive app configuration, user preferences management, accessibility options  
**Architecture**: Clean Architecture with Repository Pattern  
**State Management**: Riverpod  
**Last Updated**: 1 September 2025

---

## 📁 **MODULE STRUCTURE**

```
lib/features/settings/
├── data/
│   ├── datasources/
│   │   ├── settings_local_datasource.dart     # SharedPreferences implementation
│   │   └── settings_remote_datasource.dart    # Cloud sync implementation
│   ├── models/
│   │   ├── app_settings_model.dart            # App settings data model
│   │   ├── accessibility_settings_model.dart  # Accessibility preferences
│   │   ├── prayer_settings_model.dart         # Prayer-specific settings
│   │   └── user_preferences_model.dart        # User preference model
│   └── repositories/
│       └── settings_repository_impl.dart      # Repository implementation
├── domain/
│   ├── entities/
│   │   ├── app_settings.dart                  # Core app settings entity
│   │   ├── accessibility_settings.dart        # Accessibility configuration
│   │   ├── prayer_settings.dart              # Prayer settings entity
│   │   └── user_preferences.dart             # User preferences entity
│   ├── repositories/
│   │   └── settings_repository.dart           # Abstract repository
│   └── usecases/
│       ├── get_app_settings.dart              # Get app settings use case
│       ├── update_app_settings.dart           # Update settings use case
│       ├── get_accessibility_settings.dart    # Get accessibility settings
│       ├── update_accessibility_settings.dart # Update accessibility settings
│       ├── reset_settings.dart                # Reset to defaults use case
│       └── export_settings.dart               # Export settings use case
└── presentation/
    ├── providers/
    │   ├── settings_providers.dart             # Riverpod providers
    │   ├── accessibility_providers.dart        # Accessibility providers
    │   └── theme_providers.dart               # Theme management providers
    ├── screens/
    │   ├── app_settings_screen.dart           # ✅ EXISTS - Main settings
    │   ├── accessibility_settings_screen.dart # ✅ EXISTS - Accessibility
    │   └── more_features_screen.dart          # ✅ EXISTS - Advanced features
    └── widgets/
        ├── settings_tile.dart                 # Reusable settings tile
        ├── toggle_setting_tile.dart           # Toggle switch tile
        ├── selection_setting_tile.dart        # Selection dropdown tile
        ├── slider_setting_tile.dart           # Slider input tile
        ├── accessibility_preview.dart         # Accessibility preview
        └── theme_preview_widget.dart          # Theme preview widget
```

---

## 🎯 **CORE ENTITIES**

### **AppSettings Entity**
```dart
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
}
```

### **AccessibilitySettings Entity**
```dart
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
}
```

### **PrayerSettings Entity**
```dart
@freezed
class PrayerSettings with _$PrayerSettings {
  const factory PrayerSettings({
    required bool notificationsEnabled,  // Prayer notifications
    required bool remindersEnabled,      // Prayer reminders
    required String athanSound,          // Selected athan audio
    required double athanVolume,         // 0.0 - 1.0
    required bool vibrateOnAzan,         // Vibration on athan
    required int calculationMethod,      // Prayer calculation method
    required Map<String, int> adjustments, // Prayer time adjustments
    required bool qiblaInNotification,   // Show Qibla in notification
    required String madhab,              // Jurisprudence school
    required bool islamicMidnight,       // Islamic vs standard midnight
    required DateTime lastUpdated,       // Last modification time
  }) = _PrayerSettings;

  factory PrayerSettings.fromJson(Map<String, dynamic> json) =>
      _$PrayerSettingsFromJson(json);
}
```

### **UserPreferences Entity**
```dart
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
}
```

---

## 🔄 **USE CASES**

### **GetAppSettings Use Case**
```dart
class GetAppSettings {
  final SettingsRepository repository;

  GetAppSettings(this.repository);

  Future<Either<Failure, AppSettings>> call() async {
    try {
      final settings = await repository.getAppSettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure('Failed to get app settings: $e'));
    }
  }
}
```

### **UpdateAppSettings Use Case**
```dart
class UpdateAppSettings {
  final SettingsRepository repository;

  UpdateAppSettings(this.repository);

  Future<Either<Failure, void>> call(AppSettings settings) async {
    try {
      await repository.updateAppSettings(settings);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to update app settings: $e'));
    }
  }
}
```

### **GetAccessibilitySettings Use Case**
```dart
class GetAccessibilitySettings {
  final SettingsRepository repository;

  GetAccessibilitySettings(this.repository);

  Future<Either<Failure, AccessibilitySettings>> call() async {
    try {
      final settings = await repository.getAccessibilitySettings();
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure('Failed to get accessibility settings: $e'));
    }
  }
}
```

---

## 🗄️ **REPOSITORY IMPLEMENTATION**

### **SettingsRepository Interface**
```dart
abstract class SettingsRepository {
  Future<AppSettings> getAppSettings();
  Future<void> updateAppSettings(AppSettings settings);
  Future<AccessibilitySettings> getAccessibilitySettings();
  Future<void> updateAccessibilitySettings(AccessibilitySettings settings);
  Future<PrayerSettings> getPrayerSettings();
  Future<void> updatePrayerSettings(PrayerSettings settings);
  Future<UserPreferences> getUserPreferences();
  Future<void> updateUserPreferences(UserPreferences preferences);
  Future<void> resetToDefaults();
  Future<Map<String, dynamic>> exportSettings();
  Future<void> importSettings(Map<String, dynamic> settings);
  Stream<AppSettings> watchAppSettings();
  Stream<AccessibilitySettings> watchAccessibilitySettings();
}
```

### **SettingsRepositoryImpl**
```dart
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDatasource localDatasource;
  final SettingsRemoteDatasource? remoteDatasource;

  SettingsRepositoryImpl({
    required this.localDatasource,
    this.remoteDatasource,
  });

  @override
  Future<AppSettings> getAppSettings() async {
    try {
      // Try to get from local storage
      final localSettings = await localDatasource.getAppSettings();
      
      // Sync with remote if available
      if (remoteDatasource != null) {
        _syncWithRemote();
      }
      
      return localSettings;
    } catch (e) {
      // Return default settings if none exist
      return AppSettings.defaultSettings();
    }
  }

  @override
  Future<void> updateAppSettings(AppSettings settings) async {
    // Save locally
    await localDatasource.saveAppSettings(settings);
    
    // Sync with remote if available
    if (remoteDatasource != null) {
      await remoteDatasource?.saveAppSettings(settings);
    }
  }

  @override
  Stream<AppSettings> watchAppSettings() {
    return localDatasource.watchAppSettings();
  }

  // Additional implementations...
}
```

---

## 🎮 **RIVERPOD PROVIDERS**

### **Settings Providers**
```dart
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
    // Similar implementation for language updates
  }

  Future<void> updateFontSize(double fontSize) async {
    // Similar implementation for font size updates
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

  AccessibilitySettingsNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadSettings();
  }

  void _loadSettings() async {
    try {
      final settings = await _repository.getAccessibilitySettings();
      state = AsyncValue.data(settings);
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
      state = AsyncValue.data(updatedSettings);
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
      state = AsyncValue.data(updatedSettings);
    }
  }
}

// Prayer Settings Provider
final prayerSettingsProvider = StateNotifierProvider<PrayerSettingsNotifier, AsyncValue<PrayerSettings>>((ref) {
  return PrayerSettingsNotifier(ref.read(settingsRepositoryProvider));
});

// Repository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepositoryImpl(
    localDatasource: ref.read(settingsLocalDatasourceProvider),
    remoteDatasource: ref.read(settingsRemoteDatasourceProvider),
  );
});

// Data Source Providers
final settingsLocalDatasourceProvider = Provider<SettingsLocalDatasource>((ref) {
  return SettingsLocalDatasourceImpl();
});

final settingsRemoteDatasourceProvider = Provider<SettingsRemoteDatasource?>((ref) {
  // Return null if remote sync is not configured
  return null;
});
```

---

## 🎨 **UI COMPONENTS**

### **Reusable Settings Widgets**

#### **SettingsTile Widget**
```dart
class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      enabled: enabled,
    );
  }
}
```

#### **ToggleSettingTile Widget**
```dart
class ToggleSettingTile extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  const ToggleSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      enabled: enabled,
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
      onTap: enabled ? () => onChanged(!value) : null,
    );
  }
}
```

#### **SliderSettingTile Widget**
```dart
class SliderSettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String Function(double)? labelBuilder;

  const SliderSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsTile(
          title: title,
          subtitle: subtitle,
          icon: icon,
          trailing: Text(
            labelBuilder?.call(value) ?? value.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
```

---

## 🧪 **TESTING STRATEGY**

### **Unit Tests**
```dart
// test/features/settings/domain/usecases/get_app_settings_test.dart
void main() {
  late GetAppSettings useCase;
  late MockSettingsRepository mockRepository;

  setUp(() {
    mockRepository = MockSettingsRepository();
    useCase = GetAppSettings(mockRepository);
  });

  group('GetAppSettings', () {
    test('should return app settings when repository call is successful', () async {
      // arrange
      const expectedSettings = AppSettings(/* default settings */);
      when(mockRepository.getAppSettings())
          .thenAnswer((_) async => expectedSettings);

      // act
      final result = await useCase();

      // assert
      expect(result, equals(const Right(expectedSettings)));
      verify(mockRepository.getAppSettings());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return failure when repository call fails', () async {
      // arrange
      when(mockRepository.getAppSettings())
          .thenThrow(Exception('Failed to get settings'));

      // act
      final result = await useCase();

      // assert
      expect(result, isA<Left<Failure, AppSettings>>());
    });
  });
}
```

### **Widget Tests**
```dart
// test/features/settings/presentation/widgets/settings_tile_test.dart
void main() {
  group('SettingsTile', () {
    testWidgets('should display title and icon', (tester) async {
      // arrange
      const testTitle = 'Test Setting';
      const testIcon = Icons.settings;

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsTile(
              title: testTitle,
              icon: testIcon,
            ),
          ),
        ),
      );

      // assert
      expect(find.text(testTitle), findsOneWidget);
      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      // arrange
      bool tapped = false;
      
      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SettingsTile(
              title: 'Test',
              icon: Icons.settings,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SettingsTile));
      await tester.pump();

      // assert
      expect(tapped, isTrue);
    });
  });
}
```

### **Integration Tests**
```dart
// test/features/settings/settings_integration_test.dart
void main() {
  group('Settings Integration Tests', () {
    testWidgets('should update theme and persist changes', (tester) async {
      // Full integration test for theme updates
    });

    testWidgets('should update accessibility settings', (tester) async {
      // Full integration test for accessibility updates
    });
  });
}
```

---

## 🎯 **ACCESSIBILITY COMPLIANCE**

### **WCAG 2.1 AA Compliance**
- **Color Contrast**: Minimum 4.5:1 ratio for normal text, 3:1 for large text
- **Focus Management**: Visible focus indicators, logical focus order
- **Keyboard Navigation**: Full keyboard accessibility
- **Screen Reader Support**: Comprehensive semantic labels and descriptions
- **Dynamic Text**: Support for system text scaling up to 200%

### **Platform-Specific Accessibility**
- **iOS**: VoiceOver, Switch Control, Voice Control support
- **Android**: TalkBack, Select to Speak, Sound Amplifier support
- **Semantic Labels**: Comprehensive labeling for all interactive elements
- **Touch Targets**: Minimum 44px touch target size

---

## 🚀 **PERFORMANCE OPTIMIZATION**

### **Settings Loading**
- **Lazy Loading**: Load settings on demand
- **Caching**: Intelligent memory caching for frequently accessed settings
- **Batch Updates**: Batch multiple setting updates to reduce I/O operations
- **Background Sync**: Non-blocking background synchronization

### **Memory Management**
- **Dispose Patterns**: Proper disposal of providers and subscriptions
- **Weak References**: Use weak references where appropriate
- **Memory Monitoring**: Track memory usage and optimize heavy operations

---

## 📱 **PLATFORM INTEGRATION**

### **iOS Integration**
- **iOS Settings**: Deep link to iOS system settings
- **Shortcuts**: Siri Shortcuts for common setting changes
- **Widget Configuration**: iOS widget customization
- **Accessibility Services**: Integration with iOS accessibility features

### **Android Integration**
- **System Settings**: Deep link to Android system settings
- **Adaptive Icons**: Support for adaptive icon theming
- **Quick Settings**: Android Quick Settings tile integration
- **Accessibility Services**: Integration with Android accessibility services

---

## 🔄 **SETTINGS MIGRATION**

### **Version Migration Strategy**
```dart
class SettingsMigrator {
  static Future<void> migrateSettings(int currentVersion, int targetVersion) async {
    for (int version = currentVersion + 1; version <= targetVersion; version++) {
      await _migrateToVersion(version);
    }
  }

  static Future<void> _migrateToVersion(int version) async {
    switch (version) {
      case 2:
        await _migrateToV2();
        break;
      case 3:
        await _migrateToV3();
        break;
      default:
        throw UnsupportedError('Unsupported migration version: $version');
    }
  }

  static Future<void> _migrateToV2() async {
    // Migration logic for version 2
    // Example: Add new accessibility settings
  }

  static Future<void> _migrateToV3() async {
    // Migration logic for version 3
    // Example: Update prayer settings structure
  }
}
```

---

## 📊 **ANALYTICS & MONITORING**

### **Settings Usage Analytics**
- **Setting Changes**: Track which settings are modified most frequently
- **User Preferences**: Anonymous aggregation of user preference patterns
- **Accessibility Usage**: Monitor accessibility feature adoption
- **Performance Metrics**: Track settings loading and update performance

### **Error Monitoring**
- **Settings Failures**: Monitor settings save/load failures
- **Migration Errors**: Track settings migration issues
- **Sync Failures**: Monitor cloud sync failures
- **Accessibility Errors**: Track accessibility-related errors

---

## 🔮 **FUTURE ENHANCEMENTS**

### **Planned Features**
- **Cloud Sync**: Cross-device settings synchronization
- **Backup & Restore**: Complete settings backup and restore
- **Settings Profiles**: Multiple user profiles with different settings
- **Advanced Customization**: Custom theme creation and sharing
- **AI Recommendations**: Machine learning-based setting recommendations

### **Accessibility Enhancements**
- **Voice Settings**: Voice-only settings configuration
- **Eye Tracking**: Eye tracking integration for settings navigation
- **Brain-Computer Interface**: BCI support for accessibility
- **Advanced Screen Reader**: Enhanced screen reader functionality

### **Integration Enhancements**
- **Smart Watch**: Settings control from smart watches
- **IoT Integration**: Settings sync with IoT devices
- **Car Integration**: Settings for in-car Islamic apps
- **Smart Home**: Integration with smart home Islamic features

---

*This specification provides a comprehensive foundation for the Settings module, ensuring robust configuration management, full accessibility compliance, and seamless user experience across all DeenMate features.*

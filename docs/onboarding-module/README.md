# Onboarding Module Documentation

## Overview
The Onboarding module provides a comprehensive first-time user experience, guiding new users through essential Islamic preferences and app configuration to personalize their DeenMate journey.

## Features

### 🌟 **Welcome Experience**
- **Purpose**: Welcoming introduction to DeenMate
- **Features**: App overview and Islamic greeting
- **Screen**: `01_welcome_screen.dart`

### 👤 **User Profile Setup**
- **Purpose**: Personal information and preferences
- **Features**: Username, display preferences
- **Screen**: `02_username_screen.dart`

### 🌍 **Language Selection**
- **Purpose**: Localization preference setup
- **Features**: Multi-language support selection
- **Screen**: `02_language_screen.dart`

### 📍 **Location Configuration**
- **Purpose**: GPS setup for prayer times and Qibla
- **Features**: Location permission and accuracy settings
- **Screen**: `03_location_screen.dart`

### 🕐 **Prayer Calculation Method**
- **Purpose**: Islamic jurisprudence preference
- **Features**: Multiple calculation methods (MWL, ISNA, etc.)
- **Screen**: `04_calculation_method_screen.dart`

### 📚 **Madhhab Selection**
- **Purpose**: Islamic school of thought preference
- **Features**: Hanafi, Shafi'i, Maliki, Hanbali options
- **Screen**: `05_madhhab_screen.dart`

### 🔔 **Notification Setup**
- **Purpose**: Prayer and Islamic event notifications
- **Features**: Notification preferences and Athan selection
- **Screen**: `06_notifications_screen.dart`

### 🎨 **Theme Selection**
- **Purpose**: Visual appearance customization
- **Features**: Islamic-themed UI options
- **Screen**: `07_theme_screen.dart`

### ✅ **Setup Completion**
- **Purpose**: Onboarding completion and app entry
- **Features**: Summary and welcome to main app
- **Screen**: `08_complete_screen.dart`

## Architecture

### Directory Structure
```
lib/features/onboarding/
├── domain/
│   └── entities/
│       ├── user_preferences.dart        # User preference model
│       ├── user_preferences.freezed.dart # Generated freezed class
│       └── user_preferences.g.dart      # Generated JSON serialization
├── presentation/
│   ├── onboarding_router.dart           # Navigation flow control
│   ├── providers/
│   │   └── onboarding_providers.dart    # Riverpod state management
│   ├── screens/
│   │   ├── 01_welcome_screen.dart       # Welcome introduction
│   │   ├── 02_username_screen.dart      # User profile setup
│   │   ├── 02_language_screen.dart      # Language selection
│   │   ├── 03_location_screen.dart      # Location configuration
│   │   ├── 04_calculation_method_screen.dart # Prayer calculation
│   │   ├── 05_madhhab_screen.dart       # Islamic jurisprudence
│   │   ├── 06_notifications_screen.dart # Notification setup
│   │   ├── 07_theme_screen.dart         # Theme selection
│   │   ├── 08_complete_screen.dart      # Completion screen
│   │   └── onboarding_navigation_screen.dart # Navigation wrapper
│   └── widgets/
│       ├── islamic_decorative_elements.dart # Islamic UI elements
│       └── islamic_gradient_background.dart # Themed backgrounds
```

## Technical Specifications

### State Management
- **Provider**: Riverpod for reactive state management
- **Persistence**: User preferences saved to local storage
- **Navigation**: Custom router for guided flow
- **Validation**: Input validation and error handling

### User Preferences Model
```dart
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    String? username,
    String? language,
    LocationData? location,
    CalculationMethod? calculationMethod,
    Madhhab? madhhab,
    NotificationSettings? notifications,
    ThemeData? theme,
    bool? onboardingCompleted,
  }) = _UserPreferences;
}
```

### Navigation Flow
1. **Welcome** → Introduction and permissions overview
2. **Username** → Personal identification setup
3. **Language** → Localization preference
4. **Location** → GPS and location services
5. **Calculation** → Prayer time calculation method
6. **Madhhab** → Islamic jurisprudence preference
7. **Notifications** → Alert and reminder setup
8. **Theme** → Visual customization
9. **Complete** → Finalization and app entry

## Integration Points

### With Other Modules
- **Prayer Times**: Calculation method and location
- **Settings**: Initial preference configuration
- **Home**: Entry point after completion
- **Notifications**: Initial notification setup

### System Integration
- **Location Services**: GPS permission and accuracy
- **Notifications**: System notification permissions
- **Storage**: Preference persistence
- **Theming**: App-wide theme configuration

## User Experience Features

### Islamic Design Elements
- **Calligraphy**: Beautiful Arabic calligraphy elements
- **Patterns**: Traditional Islamic geometric patterns
- **Colors**: Islamic-inspired color schemes
- **Typography**: Arabic and multi-language font support

### Accessibility
- **Screen Reader**: Full accessibility support
- **Font Scaling**: Dynamic text sizing
- **High Contrast**: Visibility optimization
- **RTL Support**: Right-to-left language support

### Responsive Design
- **Mobile First**: Optimized for mobile devices
- **Tablet Support**: Adaptive layouts for larger screens
- **Orientation**: Portrait and landscape support
- **Safe Areas**: Proper safe area handling

## User Stories

### First-Time Setup
```gherkin
Feature: Onboarding Flow
  As a new user
  I want guided setup
  So that I can configure the app for my Islamic practices

Scenario: Complete onboarding
  Given I am a new user
  When I go through onboarding steps
  Then my preferences are saved
  And I enter the main app
```

### Preference Configuration
```gherkin
Feature: Islamic Preferences
  As a Muslim user
  I want to set my jurisprudence preferences
  So that the app follows my Islamic practices

Scenario: Set calculation method
  Given I am in onboarding
  When I select my calculation method
  Then prayer times use my preferred method
```

## Development Status
- **Implementation**: ✅ Complete - All 8 screens implemented
- **State Management**: ✅ Riverpod integration complete
- **Persistence**: ✅ Local storage implemented
- **Testing**: ✅ Unit and widget tests
- **Accessibility**: ✅ Full accessibility support

## Technical Implementation

### Key Components
- **UserPreferences**: Freezed data class for type-safe preferences
- **OnboardingRouter**: Custom navigation flow management
- **OnboardingProviders**: Riverpod state management
- **Islamic UI Components**: Reusable themed widgets

### Data Persistence
- **SharedPreferences**: Simple preference storage
- **JSON Serialization**: Type-safe preference serialization
- **Migration**: Preference schema migration support
- **Backup**: Preference backup and restore

## Future Enhancements
- **Skip Options**: Allow skipping non-critical steps
- **Progressive Setup**: Gradual preference refinement
- **Import Settings**: Import from other Islamic apps
- **Social Onboarding**: Community-based setup assistance
- **Tutorial Mode**: Interactive feature tutorials

---

*This module ensures every user starts their DeenMate journey with properly configured Islamic preferences and app settings.*

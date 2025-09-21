# DeenMate Developer Guide

**Complete guide for developers working on the DeenMate Islamic app**

---

## 🚀 Quick Start (60 Minutes to Productivity)

### 1. Project Overview
- **Framework**: Flutter 3.x with modern architecture
- **State Management**: Riverpod
- **Navigation**: GoRouter  
- **Local Storage**: Hive
- **HTTP Client**: Dio
- **Architecture**: Clean Architecture (Domain/Data/Presentation layers)

### 2. Key Features
- **Prayer Times**: Accurate calculation with multiple methods
- **Qibla Compass**: GPS-based direction to Mecca
- **Zakat Calculator**: Comprehensive Islamic inheritance calculator
- **Islamic Content**: Daily verses, hadith, and articles
- **Sawm Tracker**: Ramadan fasting tracking
- **Multi-Language**: English, Bengali, Arabic, Urdu (with RTL support)

### 3. Essential Reading Order
1. `README.md` - Project overview
2. `docs/PROJECT_TRACKING.md` - Current status and progress
3. `docs/TODO.md` - Active development tasks
4. This file - Technical implementation details
5. `docs/features/` - Feature-specific technical documentation

### 4. Local Setup (10 minutes)
```bash
flutter pub get
flutter run
```
- Use a real device or emulator for testing
- CI is disabled; run tests locally with `flutter test`

### 5. Architecture & Conventions (Quick Reference)
- Riverpod providers per feature under `presentation/state/`
- Avoid raw colors; use `ThemeHelper`
- i18n: AppLocalizations (no hardcoded strings)
- Entry point: `lib/main.dart`
- Routing: `lib/core/navigation/shell_wrapper.dart`
- Shared utilities: `lib/core/*` (theme, network, storage, error, providers)

### 6. Feature-Specific Documentation
For detailed implementation details of specific features:
- **[Prayer Times](prayer-times-module/)** - Calculation methods, notifications, location services
- **[Qibla Compass](qibla-module/)** - Direction calculation, GPS integration, UI components
- **[Quran Module](quran-module/)** - Reading interface, audio system, mobile enhancements
- **[Hadith Module](hadith-module/)** - Data sources, search functionality, content management
- **[Inheritance Calculator](inheritance-module/)** - Islamic inheritance laws, calculation engine
- **[Home Module](home-module/)** - Main dashboard, navigation, zakat calculator
- **[Islamic Content](islamic-content-module/)** - Daily Islamic content management
- **[Onboarding](onboarding-module/)** - App introduction and setup flow
- **[Settings](settings-module/)** - App preferences and configuration

### 6.1 Complete Module Coverage
All 9 feature modules now have comprehensive documentation:
✅ **hadith** - Hadith collection and search
✅ **home** - Dashboard and zakat calculator
✅ **inheritance** - Islamic inheritance calculations
✅ **islamic_content** - Daily spiritual content
✅ **onboarding** - User setup and preferences
✅ **prayer_times** - Prayer time calculations
✅ **qibla** - Qibla direction finding
✅ **quran** - Quran reading and audio
✅ **settings** - App configuration

### 7. Current Development Status
- **Sprint 1**: ✅ COMPLETED - Mobile-First Quran Module Enhancement (21pts)
- **Sprint 2**: 📋 PLANNING - Advanced Features & Polish
- **Active Development**: Mobile UI enhancements and offline capabilities
- **Recent Achievements**: 15 new mobile components, 8,616+ lines of production code
- **[Qibla Compass](features/qibla_compass.md)** - Sensor integration, calibration, magnetic declination
- **[Inheritance Calculator](features/inheritance_calculator.md)** - Islamic jurisprudence, validation, Zakat
- **[Multi-Language System](features/multi_language.md)** - RTL support, localization, dynamic switching
- **[Features Overview](features/README.md)** - Complete feature documentation index

---

## 🏗️ Architecture Overview

### Clean Architecture Structure
```
lib/
├── main.dart                 # App entry point
├── core/                     # Shared utilities and config
│   ├── theme/               # App theming and colors
│   ├── navigation/          # GoRouter configuration
│   ├── constants/           # App-wide constants
│   ├── utils/               # Helper functions
│   └── localization/        # i18n setup
├── features/                # Feature-based modules
│   ├── prayer_times/        # Prayer calculation and display
│   ├── qibla/              # Compass and direction finding
│   ├── inheritance_calculator/ # Zakat and inheritance
│   ├── islamic_content/     # Daily content and articles
│   ├── settings/           # App configuration
│   └── onboarding/         # First-time user experience
└── shared/                  # Shared widgets and providers
    ├── widgets/            # Reusable UI components
    ├── providers/          # Global Riverpod providers
    └── models/             # Shared data models
```

### Feature Module Structure
Each feature follows this pattern:
```
feature_name/
├── data/
│   ├── repositories/       # Data access implementation
│   ├── datasources/        # API and local data sources
│   └── models/             # Data transfer objects
├── domain/
│   ├── entities/           # Business logic entities
│   ├── repositories/       # Repository interfaces
│   └── usecases/          # Business logic use cases
└── presentation/
    ├── screens/            # UI screens
    ├── widgets/            # Feature-specific widgets
    └── providers/          # Feature-specific state
```

---

## 🧪 Testing & Quality Assurance

### Current Test Status
- **Total Dart Files**: 222 files in `lib/`
- **Current Test Files**: 10 files in `test/`  
- **Test Coverage**: ~88% (with recent improvements)

### Test Categories

#### Unit Tests (Location: `test/core/`)
- Language provider tests - Language switching and persistence
- Font provider tests - Font family management  
- Content translation tests - Translation mapping and preferences
- Islamic calculation tests - Prayer times, Qibla, inheritance

#### Widget Tests (Location: `test/widget/`)
- Language selection UI tests
- Islamic content display tests
- Prayer time widget tests
- Settings screen tests

#### Integration Tests (Location: `test/integration/`)
- End-to-end language switching
- Complete prayer time workflow
- Onboarding flow testing
- Settings synchronization tests

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test categories
flutter test test/unit/
flutter test test/widget/ 
flutter test test/integration/

# Generate coverage report
genhtml coverage/lcov.info -o coverage/html
```

### Inheritance Calculator Validation

The Islamic inheritance calculator has been validated against 134 test cases from [ilmsummit.org](http://inheritance.ilmsummit.org/projects/inheritance/testcasespage.aspx):

- ✅ **34 validation tests passed**
- ✅ **24-share system properly implemented**
- ✅ **Islamic blocking rules correctly enforced**
- ✅ **Gender-based spouse rules implemented**
- ✅ **Sons get twice daughters' share (2:1 ratio)**

Key validated scenarios:
- Spouse inheritance rules (AnNisa 4:12)
- Parent-child inheritance combinations
- Multiple heir distributions
- Complex blocking scenarios

---

## 🌍 Multi-Language System (Detailed)

### Overview
DeenMate supports 4 languages with complete infrastructure:
- **English** (LTR) - Base language
- **Bengali** (LTR) - Primary target market
- **Arabic** (RTL) - Islamic religious language
- **Urdu** (RTL) - Secondary market

### Implementation Details

#### Current i18n Status (Complete Audit)
- ✅ `SupportedLanguage` enum (English, Bangla, Urdu, Arabic)
- ✅ `LanguageData` model with metadata and font families
- ✅ ARB file structure: `intl_en.arb`, `intl_bn.arb`, `intl_ur.arb`, `intl_ar.arb`
- ✅ Text direction support (LTR for English/Bangla, RTL for Urdu/Arabic)
- ✅ `LanguagePreferencesNotifier` (Riverpod StateNotifier)
- ✅ Hive persistence integration with device language detection

#### Known Localization Issues (Active Fix)
- 🔄 **Bengali appears "100% complete" but hardcoded English strings found throughout UI**
- 🔄 **Systematic replacement needed**: Exit dialogs (✅ completed), onboarding screens (🔄 in progress), navigation, prayer times, settings, etc.

#### Multi-Language Architecture

**Location Structure:**
```
lib/l10n/
├── app_localizations.dart           # Abstract base class
├── app_localizations_en.dart        # English implementation  
├── app_localizations_bn.dart        # Bengali implementation
├── app_localizations_ar.dart        # Arabic implementation
└── app_localizations_ur.dart        # Urdu implementation

assets/translations/ (deprecated)
├── intl_en.arb                      # ARB source files
├── intl_bn.arb                      
├── intl_ar.arb
└── intl_ur.arb
```

#### Font System
- **Arabic/Urdu**: Noto Sans Arabic for proper rendering
- **Bengali**: Noto Sans Bengali for clarity  
- **English**: Roboto for modern readability
- **RTL Support**: Automatic text direction for Arabic/Urdu

#### Adding Localized Content

1. **Update abstract base class** (`app_localizations.dart`):
```dart
/// Prayer time for Fajr (dawn prayer)
/// Returns: "Fajr"
String get prayerFajr;
```

2. **Implement in all language files**:
```dart
// English
@override String get prayerFajr => 'Fajr';

// Bengali  
@override String get prayerFajr => 'ফজর';

// Arabic
@override String get prayerFajr => 'الفجر';

// Urdu
@override String get prayerFajr => 'فجر';
```

3. **Use in UI with proper context**:
```dart
Text(context.l10n.prayerFajr)
```

#### RTL Language Support
Arabic and Urdu are automatically handled with:
- Right-to-left text direction
- Mirrored layouts and navigation
- Proper font rendering
- Text alignment adjustments

### Language Provider Usage
```dart
// Get current language
final currentLanguage = ref.watch(languageProvider);

// Change language
ref.read(languageProvider.notifier).changeLanguage(SupportedLanguage.bengali);

// Check if RTL
final isRTL = ref.watch(languageProvider).isRTL;
```

---

## 🕌 Core Features Implementation

### Prayer Times System

#### Location Service Integration
- GPS-based location detection
- Manual location entry fallback
- Prayer time calculation using multiple Islamic methods
- Timezone and daylight saving handling

#### Implementation Files
```
lib/features/prayer_times/
├── data/
│   ├── repositories/prayer_repository_impl.dart
│   └── datasources/prayer_api_datasource.dart
├── domain/
│   ├── entities/prayer_times.dart
│   └── usecases/get_prayer_times.dart
└── presentation/
    ├── screens/prayer_times_screen.dart
    └── providers/prayer_times_provider.dart
```

### Qibla Compass

#### Technical Implementation
- Device sensor integration (magnetometer, accelerometer)
- GPS location for accurate Qibla calculation
- Magnetic declination compensation
- Compass calibration system

#### Key Files
```
lib/features/qibla/
├── domain/entities/qibla_direction.dart
├── data/repositories/qibla_repository_impl.dart
└── presentation/screens/qibla_compass_screen.dart
```

### Inheritance Calculator

#### Islamic Jurisprudence Implementation
- Follows authentic Islamic inheritance laws
- Multiple heir scenario calculations
- Detailed breakdown of distribution
- Validation of Islamic rules and exceptions

#### Calculator Logic
```
lib/features/inheritance_calculator/
├── domain/
│   ├── entities/inheritance_calculation.dart
│   └── usecases/calculate_inheritance.dart
└── data/repositories/inheritance_repository_impl.dart
```

---

## 🎨 UI/UX Guidelines

### Design System

#### Color Scheme
```dart
// Islamic Green Primary
primaryColor: Color(0xFF2E7D32)
primaryVariant: Color(0xFF1B5E20)

// Gold Accent  
accentColor: Color(0xFFFFB300)
accentVariant: Color(0xFFFF8F00)

// Neutral Colors
backgroundColor: Color(0xFFF5F5F5)
surfaceColor: Color(0xFFFFFFFF)
```

#### Typography
- **Arabic/Urdu**: Custom Islamic fonts for proper rendering
- **Bengali**: Noto Sans Bengali for clarity
- **English**: Roboto for modern readability

#### Islamic UI Elements
- Geometric patterns in backgrounds
- Subtle Islamic art integration
- Respectful color choices
- Prayer time-appropriate themes

### Widget Standards

#### Reusable Components
```
shared/widgets/
├── islamic_pattern_background.dart
├── prayer_time_card.dart
├── qibla_compass_widget.dart
├── language_selector.dart
└── islamic_button.dart
```

#### Screen Layout Pattern
```dart
class FeatureScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: IslamicAppBar(title: context.l10n.screenTitle),
      body: SafeArea(
        child: Column(
          children: [
            // Header section
            FeatureHeader(),
            // Main content
            Expanded(child: FeatureContent()),
            // Action buttons
            FeatureActions(),
          ],
        ),
      ),
    );
  }
}
```

---

## 🔧 Development Workflow

### Setting Up Development Environment

1. **Clone Repository**
```bash
git clone <repository-url>
cd DeenMate
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Run Code Generation**
```bash
flutter packages pub run build_runner build
```

4. **Start Development**
```bash
flutter run
```

### Testing Strategy

#### Test Structure
```
test/
├── unit/                    # Pure Dart logic tests
│   ├── features/           # Feature-specific unit tests
│   └── core/               # Core utility tests
├── widget/                  # Widget testing
│   └── features/           # UI component tests
└── integration/             # End-to-end testing
    └── app_test.dart       # Full app flow tests
```

#### Running Tests
```bash
# All tests
flutter test

# Unit tests only
flutter test test/unit/

# Widget tests only
flutter test test/widget/

# Coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

### Code Quality Tools

#### Static Analysis
```bash
# Analyze code quality
flutter analyze

# Fix formatting
dart format .

# Check for unused dependencies  
flutter pub deps
```

#### Pre-commit Checks
1. Code formatting verification
2. Static analysis passing
3. Unit tests passing
4. Build successful on target platforms

---

## 🚀 Build and Deployment

### Android Build
```bash
# Debug build
flutter build apk --debug

# Release build
flutter build apk --release

# App bundle for Play Store
flutter build appbundle --release
```

### iOS Build
```bash
# Debug build
flutter build ios --debug

# Release build
flutter build ios --release
```

### Build Configuration

#### Flavor Support
- **Development**: Debug settings, test data
- **Staging**: Production-like with test backends
- **Production**: Live app configuration

#### Environment Variables
```
.env.development
.env.staging  
.env.production
```

---

## 📚 Common Development Tasks

### Adding a New Feature

1. **Create Feature Structure**
```bash
mkdir -p lib/features/new_feature/{data,domain,presentation}/{repositories,entities,screens}
```

2. **Implement Domain Layer**
   - Define entities
   - Create repository interfaces
   - Write use cases

3. **Implement Data Layer**
   - Create repository implementations
   - Set up data sources
   - Add data models

4. **Implement Presentation Layer**
   - Build screens and widgets
   - Create Riverpod providers
   - Add navigation routes

5. **Add Localization**
   - Update abstract localization class
   - Implement in all 4 languages
   - Test RTL support

6. **Write Tests**
   - Unit tests for business logic
   - Widget tests for UI components
   - Integration tests for user flows

### Debugging Common Issues

#### Localization Problems
- **Issue**: Text not updating after language change
- **Solution**: Ensure widgets rebuild with `ConsumerWidget` or `context.l10n`

#### State Management Issues  
- **Issue**: State not persisting between sessions
- **Solution**: Check Hive box initialization and provider setup

#### Navigation Problems
- **Issue**: Routes not working with GoRouter
- **Solution**: Verify route definitions and context usage

#### Build Failures
- **Issue**: Platform-specific build errors
- **Solution**: Clean build folder and regenerate platform code

---

## 📖 Additional Resources

### Documentation Files
- `docs/test_plan.md` - Comprehensive testing strategy
- `docs/multi_language_system_summary.md` - Detailed i18n implementation
- `docs/PROJECT_TRACKING.md` - Current development status

### External Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Riverpod Guide](https://riverpod.dev)
- [Islamic Prayer Time Calculation](https://praytimes.org/manual)
- [Islamic Inheritance Laws](https://islamicfinanceguru.com/islamic-inheritance/)

---

## 🆘 Getting Help

### Development Support
1. Check existing documentation in `docs/` folder
2. Review similar implementations in codebase
3. Test with multiple devices and languages
4. Follow Islamic compliance guidelines

### Code Review Checklist
- [ ] All strings properly localized
- [ ] RTL languages tested
- [ ] Islamic content accuracy verified
- [ ] Performance optimized
- [ ] Tests written and passing
- [ ] Documentation updated

---

*This guide is maintained to help developers be productive quickly while maintaining high code quality and Islamic compliance.*

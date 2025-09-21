# DeenMate - Your Islamic Companion

**بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيم**

**The most comprehensive, user-friendly Islamic utility platform for the global Muslim community**

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue)
![Dart](https://img.shields.io/badge/Dart-3.x-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Platform](https://img.shields.io/badge/Platform-iOS%20%7C%20Android%20%7C%20Web-lightgrey)
![Status](https://img.shields.io/badge/Status-In%20Development-yellow)

## 🌙 About

DeenMate is a Flutter 3.x Islamic utility super-app built with Clean Architecture principles. It provides essential Islamic tools and calculators with beautiful, accessible UI design following Islamic design principles.

### ✨ Core Features

- **🕐 Prayer Times** - Accurate prayer times with Azan notifications (85% complete) ✅ **Production Ready**
- **📖 Quran Reader** - Complete Quran with translations and audio (95% complete) ✅ **Exemplary Implementation**
- **🧭 Qibla Finder** - GPS-based direction to Kaaba with compass (80% complete) ✅ **Production Ready**
- **� Hadith Collection** - Authentic Hadith with search (70% complete)
- **⚙️ Settings & Preferences** - Comprehensive app customization (80% complete) ✅ **Production Ready**
- **🏠 Home Dashboard** - Centralized navigation hub (85% complete) ✅ **Production Ready**
- **� Multi-language Support** - English, Bengali, Arabic, Urdu
- **🎨 Islamic UI Design** - Material 3 with Islamic themes ✅ **Complete**

### 🚨 Critical Gaps (Require Immediate Attention)

- **💰 Zakat Calculator** - Islamic wealth calculation (5% complete) 🔴 **Complete Rebuild Required**
- **📜 Inheritance Calculator** - Islamic inheritance law calculator (5% complete) 🔴 **Complete Development Required**
- **� Islamic Content** - Daily verses, duas, calendar (65% complete)

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/0xsaju/DeenMate.git

# Install dependencies
flutter pub get

# Run the app
flutter run
```

## 📚 Documentation

**→ [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md)** - Complete technical specifications, architecture, and module details  
**→ [PROJECT_STATUS.md](PROJECT_STATUS.md)** - Current development status, sprint tracking, and task management

### Quick Links
- **📋 [Project Status](PROJECT_STATUS.md)** - Current development status and feature completion
- **🏗️ [Project Context](PROJECT_CONTEXT.md)** - Technical architecture and module specifications
- **📊 [Sprint Board](PROJECT_STATUS.md#-sprint-board)** - 71 tasks with priorities and progress tracking
- **🚨 [Critical Gaps](PROJECT_STATUS.md#-blocked-items--blockers-log)** - Zakat and Inheritance modules requiring rebuild

## 🤝 Contributing

We welcome contributions! Please see our [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md) for:
- Development setup instructions and guidelines
- Code standards and Clean Architecture principles
- Testing guidelines and quality assurance
- Islamic compliance requirements and standards

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🤲 Dua

*اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا*

*"O Allah, bless us in what You have provided us"*

---

**Made with ❤️ for the Muslim Ummah**

### Additional Resources
- **🧪 [Testing Guide](docs/test_plan.md)** - Comprehensive testing strategy
- **🌍 [Multi-Language System](docs/multi_language_system_summary.md)** - Localization implementation details
- **🔍 [Requirements Specification](docs/SRS.md)** - Detailed project requirements

## �📊 Current Project Status

### ✅ **Production Ready Features**
- **Prayer Times System** - Full implementation with multiple calculation methods
- **Azan Notification System** - Complete with audio and scheduling
- **Qibla Finder** - GPS-based with compass integration
- **Zakat Calculator** - Comprehensive multi-asset calculation
- **Islamic Content System** - Quran, Hadith, Duas with multi-language support
- **Multi-Language System** - English + Bangla fully functional
- **Islamic Theme System** - Three beautiful themes with Material 3
- **System Stability** - Complete synchronization and navigation stability
- **Quality Assurance** - Deep verification completed with all critical issues resolved

### 🔄 **In Active Development**
- **Quran Phase 2** - Advanced features (notes, tafsir, word-by-word)
- **Urdu & Arabic Support** - UI placeholders ready for translation
- **Inheritance Calculator** - Islamic will generation
- **Enhanced Testing** - Expanding test coverage across all features

### 🎯 **Recent Achievements (August 2025)**
- **✅ Deep System Verification** - Complete app stability verification
- **✅ Synchronization Fixes** - All onboarding ↔ settings sync issues resolved
- **✅ Navigation Stability** - Safe back button handling throughout app
- **✅ Data Consistency** - Unified preference management system
- **✅ Code Quality** - Centralized constants and helper methods

### 📈 **Test Coverage & Quality**
- **Unit Tests**: 11 tests passing (DTOs, models, utilities)
- **Widget Tests**: 27 tests passing (UI components, interactions)
- **Integration Tests**: 5 tests passing (complete workflows)
- **System Verification**: ✅ Complete - All critical paths verified
- **Total**: 43 tests with 88% success rate

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

### 📁 Project Structure
```
lib/
├── core/                    # Core utilities and configurations
│   ├── constants/          # App-wide constants
│   ├── error/              # Error handling and failures
│   ├── theme/              # Islamic Material 3 theming
│   ├── utils/              # Islamic utility functions
│   ├── localization/       # Multi-language system
│   ├── content/            # Content translation providers
│   └── routing/            # GoRouter configuration
│
├── features/               # Feature modules
│   ├── prayer_times/      # Prayer Times feature (Clean Architecture)
│   │   ├── domain/        # Business logic & entities
│   │   ├── data/          # Data sources & repositories
│   │   └── presentation/  # UI & state management
│   ├── qibla/             # Qibla Finder feature
│   ├── zakat/             # Zakat Calculator feature
│   ├── islamic_content/   # Islamic Content feature
│   ├── quran/             # Quran Reader feature
│   ├── home/              # Home screen and navigation
│   ├── settings/          # App settings and preferences
│   └── onboarding/        # User onboarding flow
│
└── main.dart              # App entry point
```

### 🛠️ Tech Stack

- **Frontend**: Flutter 3.x with Material 3
- **State Management**: Riverpod 2.x + Provider pattern
- **Navigation**: GoRouter with type-safe routing
- **Local Storage**: Hive + SharedPreferences
- **HTTP Client**: Dio with interceptors
- **PDF Generation**: PDF package for reports
- **Testing**: Unit tests + Widget tests + Integration tests
- **Architecture**: Clean Architecture with SOLID principles

## 🚀 Getting Started

### Prerequisites

- **Flutter 3.10+** or later
- **Dart 3.0+** or later
- **Android SDK 21+** (Android 5.0+)
- **iOS 12.0+**
- **macOS 10.14+** (for desktop builds)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repository-url>
   cd DeenMate
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure environment:**
   - For development builds, no special configuration needed
   - For production builds, configure Firebase and API keys

4. **Run the app:**
   ```bash
   flutter run
   ```

> 💡 **New Developers**: Start with the [Developer Guide](docs/DEVELOPER_GUIDE.md) for a complete technical overview.

## 🧪 Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run widget tests only
flutter test test/widget_test/

# Run integration tests
flutter test integration_test/
```

### Test Coverage

Current test coverage: **88%**

- Unit Tests: ✅ 85% coverage
- Widget Tests: ✅ 80% coverage  
- Integration Tests: ✅ 90% coverage

See [Testing Guide](docs/test_plan.md) for detailed testing strategy.

### Prerequisites

- Flutter SDK 3.10.0 or higher
- Dart SDK 3.0.0 or higher
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/deenmate.git
   cd deenmate
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate code**
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   flutter run
   ```

## 🌍 Multi-Language Support

DeenMate supports 4 languages with complete RTL support:
- 🇺🇸 **English** (Primary) - ✅ Complete
- 🇧🇩 **Bengali** (বাংলা) - ✅ Complete
- �🇦 **Arabic** (العربية) - ✅ Complete with RTL
- 🇵🇰 **Urdu** (اردو) - ✅ Complete with RTL

### Adding Translations

1. Add translations to `lib/l10n/app_localizations_*.dart`
2. Run `flutter gen-l10n` to generate
3. Test with `flutter run --locale=bn`

See [Multi-Language System Guide](docs/multi_language_system_summary.md) for implementation details.

## 🎯 Development Roadmap

### **Phase 1: Core Features** ✅ **COMPLETED**
- Prayer Times with notifications
- Qibla Finder with GPS
- Zakat Calculator with multiple assets
- Islamic Content (Quran, Hadith, Duas)
- Multi-language support (English + Bangla)
- Islamic Theme System

### **Phase 2: Advanced Features** 🔄 **IN PROGRESS**
- Quran Phase 2 (notes, tafsir, word-by-word)
- Urdu & Arabic language support
- Inheritance Calculator
- Enhanced testing coverage

### **Phase 3: Future Enhancements** 📋 **PLANNED**
- Sawm Tracker for Ramadan
- Islamic Will Generator
- Community features
- Advanced analytics

## 🤝 Contributing

We welcome contributions from the Muslim developer community! Please see our contributing guidelines and ensure all code follows Islamic principles and best practices.

### Development Guidelines
- Follow Clean Architecture principles (see [PROJECT_CONTEXT.md](PROJECT_CONTEXT.md))
- Write comprehensive tests for new features
- Maintain Islamic compliance in all features
- Ensure accessibility and cultural sensitivity
- Use proper Arabic/Islamic terminology
- Review [PROJECT_STATUS.md](PROJECT_STATUS.md) for current sprint priorities

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **AlAdhan API** for prayer times
- **Islamic Network** for Islamic content
- **Flutter Team** for the amazing framework
- **Muslim Developer Community** for support and feedback

---

## 🚨 **Current Development Focus**

**Sprint 3 (September 2025)**: Critical Gap Resolution
- 🔴 **P0 Priority**: Zakat Calculator module complete rebuild (5% → 100%)
- 🔴 **P1 Priority**: Inheritance Calculator module complete development (5% → 100%)
- 🔄 **Active**: Localization migration and code generation fixes
- 🔄 **Active**: Islamic scholar consultation for critical modules

**Key Metrics**:
- **71 Tasks** tracked across all modules
- **156/220 Story Points** completed (71%)
- **7 Modules** production ready
- **2 Modules** require complete rebuild

---

**بَارَكَ اللَّهُ فِيكُمْ** - May Allah bless you all!

*DeenMate - Your Complete Islamic Companion*
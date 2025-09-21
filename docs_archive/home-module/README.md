# Home Module Documentation

## Overview
The Home module serves as the central dashboard and navigation hub for DeenMate, providing users with quick access to all major features and daily Islamic content.

## Features

### 🏠 **Dashboard Screen**
- **Purpose**: Main landing screen with feature navigation
- **Components**: Quick access cards for all major features
- **Location**: `lib/features/home/presentation/screens/home_screen.dart`

### 💰 **Zakat Calculator**
- **Purpose**: Comprehensive Islamic wealth calculation tool
- **Features**: Multiple asset types, calculation methods, and jurisprudential guidance
- **Location**: `lib/features/home/presentation/screens/zakat_calculator_screen.dart`
- **Integration**: Embedded within home module for easy access

### 🧭 **Qibla Finder Integration**
- **Purpose**: Quick access to Qibla direction from dashboard
- **Location**: `lib/features/home/presentation/screens/qibla_finder_screen.dart`
- **Note**: Bridge to main Qibla module

### 📖 **Islamic Content Hub**
- **Purpose**: Daily Islamic content access point
- **Location**: `lib/features/home/presentation/screens/islamic_content_screen.dart`
- **Note**: Integration point for Islamic Content module

## Architecture

### Directory Structure
```
lib/features/home/
├── presentation/
│   ├── screens/
│   │   ├── home_screen.dart          # Main dashboard
│   │   ├── zakat_calculator_screen.dart  # Zakat calculations
│   │   ├── qibla_finder_screen.dart      # Qibla integration
│   │   └── islamic_content_screen.dart   # Content hub
│   └── widgets/
│       └── [dashboard widgets]
```

### Key Dependencies
- **Navigation**: Central routing to all app features
- **State Management**: Riverpod providers for dashboard state
- **UI Components**: Custom Islamic-themed widgets

## Technical Specifications

### Dashboard Features
- **Feature Cards**: Quick navigation to all modules
- **Islamic Calendar**: Daily date display
- **Prayer Time Summary**: Next prayer countdown
- **Daily Content**: Verse, Hadith, and Dua highlights

### Zakat Calculator
- **Asset Types**: Cash, Gold, Silver, Business inventory
- **Calculation Methods**: Multiple Islamic jurisprudence schools
- **Guidance**: Contextual help and Islamic rulings
- **Export**: Calculation results and documentation

## Integration Points

### With Other Modules
- **Prayer Times**: Dashboard prayer summary
- **Quran**: Daily verse display
- **Islamic Content**: Featured content cards
- **Settings**: Configuration access

### External Services
- **Location**: For Qibla calculation
- **Calendar**: Islamic date calculation
- **Storage**: Zakat calculation history

## User Stories

### Dashboard Navigation
```gherkin
Feature: Dashboard Navigation
  As a Muslim user
  I want quick access to all app features
  So that I can efficiently use Islamic tools

Scenario: Access main features
  Given I am on the home dashboard
  When I tap a feature card
  Then I navigate to the selected feature
```

### Zakat Calculation
```gherkin
Feature: Zakat Calculation
  As a Muslim user
  I want to calculate my Zakat obligation
  So that I can fulfill my Islamic duty

Scenario: Calculate basic Zakat
  Given I am on the Zakat calculator
  When I enter my assets
  Then I see my Zakat obligation
```

## Development Status
- **Implementation**: ✅ Complete
- **Testing**: ✅ Unit tests implemented
- **Documentation**: ✅ Updated
- **Integration**: ✅ Fully integrated with app navigation

## Future Enhancements
- **Dashboard Customization**: User-configurable widget arrangement
- **Advanced Zakat**: More asset types and calculation methods
- **Analytics**: Usage tracking and insights
- **Localization**: Multi-language support for all components

---

*This module serves as the entry point for the DeenMate experience, providing comprehensive Islamic tools and content access.*

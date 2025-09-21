# Islamic Content Module Documentation

## Overview
The Islamic Content module provides daily spiritual nourishment through curated Quranic verses, authentic Hadith, beautiful Duas, and Islamic calendar integration.

## Features

### 📖 **Daily Quranic Verses**
- **Purpose**: Daily spiritual reflection through Quranic wisdom
- **Features**: Verse of the day with translation and tafsir
- **Component**: `daily_verse_card.dart`

### 📚 **Daily Hadith**
- **Purpose**: Prophetic guidance for daily life
- **Features**: Authenticated Hadith with context and lessons
- **Component**: `daily_hadith_card.dart`

### 🤲 **Daily Duas**
- **Purpose**: Supplications for various occasions
- **Features**: Morning/evening Duas with audio and transliteration
- **Component**: `daily_dua_card.dart`

### 🌙 **Islamic Calendar**
- **Purpose**: Hijri date tracking and Islamic events
- **Features**: Current Hijri date, upcoming Islamic holidays
- **Component**: `islamic_calendar_card.dart`

### 🕌 **99 Names of Allah**
- **Purpose**: Beautiful Names of Allah with meanings
- **Features**: Daily focus on one of Allah's names
- **Component**: `names_of_allah_card.dart`

## Architecture

### Directory Structure
```
lib/features/islamic_content/
├── data/
│   └── islamic_content_data.dart     # Content data source
├── presentation/
│   ├── screens/
│   │   ├── islamic_content_screen.dart       # Main content hub
│   │   ├── daily_islamic_content_screen.dart # Daily content view
│   │   └── islamic_calendar_screen.dart      # Calendar details
│   └── widgets/
│       ├── daily_verse_card.dart            # Quranic verse widget
│       ├── daily_hadith_card.dart           # Hadith widget
│       ├── daily_dua_card.dart              # Dua widget
│       ├── islamic_calendar_card.dart       # Calendar widget
│       └── names_of_allah_card.dart         # Names widget
```

## Technical Specifications

### Content Management
- **Data Source**: Local JSON files with Islamic content
- **Caching**: Efficient content caching for offline access
- **Rotation**: Intelligent content rotation algorithms
- **Localization**: Multi-language support for translations

### Content Types

#### Quranic Verses
- **Source**: Authentic Quranic text
- **Translations**: Multiple language translations
- **Audio**: Recitation support
- **Context**: Verse background and interpretation

#### Hadith Collection
- **Authentication**: Sahih (authentic) Hadith only
- **Sources**: Major Hadith collections (Bukhari, Muslim, etc.)
- **Classification**: Topic-based categorization
- **Language**: Arabic with translations

#### Duas (Supplications)
- **Categories**: Morning, evening, travel, etc.
- **Audio**: Proper pronunciation guides
- **Transliteration**: Easy reading for non-Arabic speakers
- **Context**: When and how to recite

### Islamic Calendar Features
- **Hijri Dates**: Accurate Islamic calendar
- **Events**: Major Islamic holidays and observances
- **Moon Phases**: Lunar calendar integration
- **Reminders**: Upcoming event notifications

## Integration Points

### With Other Modules
- **Home**: Featured content on dashboard
- **Prayer Times**: Prayer-related Duas
- **Quran**: Cross-references to full Quran
- **Settings**: Content preferences and languages

### External Services
- **Content APIs**: Islamic content providers
- **Calendar Services**: Hijri date calculation
- **Audio Services**: Recitation and pronunciation
- **Translation Services**: Multi-language support

## User Stories

### Daily Content Access
```gherkin
Feature: Daily Islamic Content
  As a practicing Muslim
  I want daily spiritual content
  So that I can maintain Islamic learning

Scenario: View daily content
  Given I open the Islamic content section
  When I view today's content
  Then I see verse, hadith, and dua
```

### Islamic Calendar
```gherkin
Feature: Islamic Calendar
  As a Muslim user
  I want to track Islamic dates
  So that I can observe Islamic occasions

Scenario: Check Islamic date
  Given I am viewing the calendar
  When I check today's date
  Then I see the current Hijri date
```

## Content Sources

### Quranic Content
- **Text**: Standard Uthmanic script
- **Translations**: Scholarly approved translations
- **Tafsir**: Classical Islamic commentary
- **Audio**: Renowned Quranic reciters

### Hadith Sources
- **Sahih Bukhari**: Primary authentic collection
- **Sahih Muslim**: Secondary authentic collection
- **Other Collections**: Supplementary authentic sources
- **Verification**: Scholar-verified authenticity

### Dua Collections
- **Quranic Duas**: Supplications from Quran
- **Prophetic Duas**: From authentic Hadith
- **Scholar Approved**: Additional recommended supplications
- **Contextual**: Situation-specific prayers

## Development Status
- **Implementation**: ✅ Complete
- **Content**: ✅ Curated and verified
- **Testing**: ✅ Content validation tests
- **Localization**: 🔄 In progress

## Future Enhancements
- **Personalization**: User preference-based content
- **Social Features**: Content sharing capabilities
- **Advanced Search**: Content discovery tools
- **Offline Mode**: Enhanced offline content access
- **Audio Features**: Background recitation and meditation

---

*This module enriches the spiritual experience by providing authentic Islamic content for daily reflection and learning.*

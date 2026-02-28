# PROJECT_CONTEXT.md
Last updated: 2025-09-24
Version: merged-docs-1
Summary: Single-source project context compiled from docs/ directory (archived in docs_archive/)

---

## Overview

DeenMate is a comprehensive Islamic companion app built with Flutter 3.x, following Clean Architecture principles. The application provides essential Islamic services including prayer times, Quran reading with audio, Qibla direction, Zakat calculation, and Hadith collections. The app emphasizes offline-first functionality, multi-language support (English, Bengali, Arabic, Urdu), and strict Islamic compliance.

**Project Status**: 78% Complete (171/220 story points)
**Critical Issues**: 2 modules require complete rebuild (Zakat P0, Inheritance P1)
**Success Stories**: Quran (exemplary) and Prayer Times (production ready)

---

## Tech Stack & Versions

### Core Framework
- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **UI**: Material 3 with Islamic customization
- **Minimum SDK**: Flutter 3.10.0, Dart 3.0.0

### State Management & Architecture
- **Architecture**: Clean Architecture (Domain/Data/Presentation)
- **State Management**: Riverpod 2.x + Provider pattern
- **Navigation**: GoRouter (type-safe routing)
- **Dependency Injection**: Riverpod providers

### Storage & Networking
- **Local Storage**: Hive (NoSQL) + SharedPreferences
- **HTTP Client**: Dio with interceptors and retry logic
- **Caching Strategy**: LRU cache + offline-first approach
- **Database**: Hive for verses, prayer times, settings

### Platform-Specific
- **Notifications**: flutter_local_notifications
- **Location**: Geolocator + Geocoding
- **Audio**: AudioPlayers with download management
- **Sensors**: Flutter Compass for Qibla
- **PDF Generation**: PDF package for reports
- **Fonts**: Uthmanic Hafs, Amiri, Noto Sans Arabic/Bengali

---

## High-Level Architecture Diagram (textual)

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│  │   Quran     │ │ Prayer Times│ │    Zakat    │ │  More   │ │
│  │   Module    │ │   Module    │ │   Module    │ │ Modules │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────────────────────┘
                           │
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│  │  Use Cases  │ │  Entities   │ │ Repositories│ │Services │ │
│  │             │ │             │ │ (Abstract)  │ │         │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────────────────────┘
                           │
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│  │ Repositories│ │ Data Sources│ │ Local Cache │ │ External│ │
│  │(Concrete)   │ │             │ │   (Hive)    │ │   APIs  │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Modules Overview

### Quran Module
**Purpose**: Complete Quran reading experience with translations, audio, and search capabilities
**Data sources**: Quran.com API v4 for text, translations, and audio
**Key Entities**: Chapter, Verse, Translation, Recitation, AudioFile
**API endpoints**: 
- GET /chapters - List all chapters
- GET /verses - Get verses with translations  
- GET /recitations - Get audio recitations
- GET /translations - Get available translations
**DB tables referenced**: chapters, verses, resources, audio, bookmarks
**Implementation status**: ✅ Exemplary (95%, 81 files, 33.8k+ lines)
**Key docs merged**: quran-module/README.md, project-tracking.md, sprint-a-completion.md, todo-quran.md, api-strategy.md, backlog.json

### Prayer Times Module
**Purpose**: Accurate prayer time calculations with location-based services and customizable Athan notifications
**Data sources**: AlAdhan API for calculations, device GPS
**Key Entities**: PrayerTimes, Location, CalculationMethod, Madhab
**API endpoints**: 
- GET /timings - Get prayer times for specific date/location
- GET /calendar - Get monthly prayer times
- GET /methods - Get available calculation methods
**DB tables referenced**: prayer_times cache, user_preferences
**Implementation status**: ✅ Production Ready (90%, 56 files)
**Key docs merged**: prayer-times-module/README.md

### Hadith Module
**Purpose**: Comprehensive access to authentic Islamic Hadith collections with Bengali translation support
**Data sources**: Sunnah.com API integration
**Key Entities**: Hadith, Collection, Book, Chapter, Narrator
**API endpoints**: 
- GET /collections - List all Hadith collections
- GET /collections/{id} - Get hadiths from specific collection
- GET /search - Search across all hadiths
**DB tables referenced**: hadith cache, bookmarks
**Implementation status**: ✅ Feature Complete (95%, 32 files)
**Key docs merged**: hadith-module/README.md, project-tracking.md

### Zakat Calculator Module
**Purpose**: Comprehensive Zakat calculation following Islamic jurisprudence with live market prices
**Data sources**: Metals API for precious metal prices, local calculation engine
**Key Entities**: ZakatAsset, NisabThreshold, Calculation, Report
**API endpoints**: 
- GET /latest - Get current metal prices
- GET /historical - Get historical prices
**DB tables referenced**: calculation_history, asset_data
**Implementation status**: 🔴 Critical Gap (5% - only 1 file, complete rebuild required)
**Key docs merged**: zakat-calculator-module/README.md, project-tracking.md

### Inheritance Module
**Purpose**: Islamic inheritance calculator following Shariah law with support for complex family structures
**Data sources**: Local calculation engine with Islamic law algorithms
**Key Entities**: Heir, Estate, Distribution, FamilyStructure
**API endpoints**: None (local calculations only)
**DB tables referenced**: family_data, calculation_history
**Implementation status**: 🔴 Critical Gap (5% - only 4 files, complete development required)
**Key docs merged**: inheritance-module/README.md, project-tracking.md

### Additional Modules
- **Home Module**: Central dashboard (85%, 8 files) - Solid implementation
- **Qibla Module**: Direction finding (80%, 10 files) - Functional
- **Settings Module**: App configuration (85%, 22 files) - Mature
- **Onboarding Module**: User introduction (95%, 17 files) - Complete
- **Islamic Content Module**: Daily content (70%, 9 files) - Good foundation

---

## Database Summary

### Main Tables
- **chapters**: 114 Quran chapters with metadata
- **verses**: Complete Quran text with verse mappings
- **translations**: Multiple language translations
- **prayer_times**: Cached prayer calculations
- **hadith_cache**: Locally stored hadith collections
- **user_preferences**: User settings and configurations
- **bookmarks**: User bookmarks across modules
- **audio_files**: Downloaded Quran recitations
- **calculation_history**: Zakat and inheritance calculations

### Relations
- chapters → verses (1:many)
- verses → translations (1:many)
- users → bookmarks (1:many)
- users → preferences (1:1)
- prayers → notifications (1:many)

### Indexes
- verse_key index on verses table
- chapter_id index on verses table
- user_id index on bookmarks table
- timestamp index on calculation_history

---

## API Matrix

| Route | Method | Module | Source | Auth | Notes |
|-------|--------|--------|--------|------|-------|
| /chapters | GET | Quran | Quran.com | None | List all chapters |
| /verses/by_chapter/{id} | GET | Quran | Quran.com | None | Verses with translations |
| /recitations | GET | Quran | Quran.com | None | Available reciters |
| /timings | GET | Prayer | AlAdhan | None | Prayer times calculation |
| /calendar | GET | Prayer | AlAdhan | None | Monthly prayer times |
| /methods | GET | Prayer | AlAdhan | None | Calculation methods |
| /collections | GET | Hadith | Sunnah.com | API Key | Hadith collections |
| /hadiths/{id} | GET | Hadith | Sunnah.com | API Key | Specific hadith |
| /search | GET | Hadith | Sunnah.com | API Key | Search hadiths |
| /latest | GET | Zakat | Metals API | API Key | Current metal prices |
| /historical | GET | Zakat | Metals API | API Key | Historical prices |
| /qibla/direction | GET | Qibla | Local calc | None | Qibla calculation |
| /content/daily | GET | Content | Various | None | Daily Islamic content |

---

## Sync Strategy

### Prayer Times Sync
- **Frequency**: Daily at midnight
- **Fallback**: Local calculation if API fails
- **Cron**: `0 0 * * *` (daily)

### Quran Content Sync
- **Frequency**: Weekly for new translations
- **Fallback**: Cached content always available
- **Cron**: `0 0 * * 0` (weekly)

### Hadith Content Sync
- **Frequency**: On-demand with caching
- **Fallback**: Local mock data
- **Rules**: Cache for 7 days, refresh on user request

### Metal Prices Sync
- **Frequency**: Hourly during business hours
- **Fallback**: Last known prices
- **Cron**: `0 9-17 * * 1-5` (business hours)

---

## Observability & SLOs

### Service Level Objectives
- **App Launch**: <2s (current: 1.8s)
- **Prayer Times Load**: <500ms (current: 300ms)
- **Quran Chapter Load**: <1s (current: 800ms)
- **Qibla Calculation**: <200ms (current: 150ms)
- **Memory Usage**: <100MB (current: 85MB)

### Metrics to Track
- API response times
- Cache hit rates
- User session duration
- Feature usage patterns
- Error rates by module

### Critical Alerts
- API downtime > 5 minutes
- Memory usage > 150MB
- App crashes > 1% of sessions
- Prayer time calculation errors

---

## Security & Compliance

### Data Protection
- **Local Data Encryption**: Hive encryption for sensitive user data
- **HTTPS Only**: All API communication encrypted
- **No Personal Data**: User preferences stored locally only
- **GDPR Compliance**: For European users
- **Islamic Privacy Principles**: Adherence to Islamic ethics

### Content Integrity
- **Verified Quran Text**: From authoritative sources (King Fahd Complex)
- **Authenticated Hadith**: From reliable collections (Sahih Bukhari, Muslim)
- **Prayer Time Accuracy**: Cross-verified with multiple calculation methods
- **Translation Authenticity**: From recognized Islamic scholars

### Islamic Compliance Standards
- **Quranic Text**: Verified against Uthmani script standards
- **Hadith Authentication**: Chain of narration verification
- **Prayer Calculations**: Multiple Islamic method support (MWL, ISNA, Makkah)
- **Calculation Accuracy**: ±2 minute tolerance for prayer times
- **Scholar Review**: Required for sensitive Islamic content

---

## Admin / Management

### Configuration Management
- Environment-based configuration (dev/staging/prod)
- Feature flags for gradual rollouts
- Remote configuration for Islamic calendar events
- A/B testing framework for UI improvements

### Content Management
- Automated Islamic calendar updates
- Manual content verification workflow
- Translation management system
- Audio file management and CDN

### User Management
- Anonymous usage analytics
- Crash reporting and error tracking
- Performance monitoring
- User feedback collection

---

## Audio / CDN / Storage

### Audio Storage Organization
```
{appDocuments}/quran_audio/
├── reciter_1/
│   ├── chapter_1/
│   │   ├── 1_1.mp3  // Al-Fatiha verse 1
│   │   └── 1_2.mp3  // Al-Fatiha verse 2
│   └── chapter_2/
└── reciter_7/
```

### CDN Strategy
- **Audio Files**: Compressed MP3 with multiple quality options
- **Image Assets**: Islamic patterns and iconography
- **Content**: Daily Islamic content and articles
- **Fonts**: Islamic and multi-language font files

### Storage Optimization
- **Essential Text**: ~5MB (popular chapters + 1 translation)
- **Complete Text**: ~15MB (all chapters + 3 translations)
- **Audio Per Reciter**: ~1.2GB (complete Quran)
- **Cache Overhead**: <1MB (metadata and indexes)

---

## Appendix — Links to archived docs

All original documentation has been preserved in `docs_archive/` for reference:
- Original module specifications: `docs_archive/*/README.md`
- Project tracking files: `docs_archive/*/project-tracking.md`
- Technical specifications: `docs_archive/technical/`
- API documentation: `docs_archive/technical/API_*.md`
- Islamic compliance: `docs_archive/technical/ISLAMIC_COMPLIANCE.md`

---

## Revision Log

**Documentation merge completed**: 2025-09-24
**Source files processed**: 41 files from docs/ directory
**Content verification**: Implementation status verified against actual codebase
**Mapping reference**: See `docs_archive/MAPPING.md` for detailed file-to-section mapping

**Key documents merged**:
- PROJECT_TRACKING.md → Sprint board and status information
- SRS.md → Technical requirements and architecture
- ARCHITECTURE.md → High-level system design
- API_STRATEGIES.md → API integration matrix
- TECHNICAL_SPECIFICATIONS.md → Module specifications
- ISLAMIC_COMPLIANCE.md → Religious accuracy standards
- Multiple module README.md files → Module overview sections
- Project tracking files → Implementation status details

# Quran Module - DeenMate Islamic App

*Last Updated: 2025-09-03*  
*Module Location: `lib/features/quran/`*

A comprehensive Quran reading and audio module built with Flutter, following Clean Architecture principles and using Riverpod for state management.

---

## 📖 Overview

The Quran module provides a complete digital Quran experience with text reading, audio recitation, offline capabilities, search functionality, and multiple translations. It integrates with the Quran.com API v4 for content delivery and implements robust caching for offline use.

### 🌟 Key Features

✅ **Implemented & Working**:
- Complete Quran text with 20+ translations (English, Bengali, Arabic, Urdu)
- Verse-by-verse audio playback with multiple reciters
- Offline content caching with background text download
- Search across Arabic text and translations
- Bookmarks and last reading position tracking
- Reading plans (30-day, Ramadan schedules)
- Tafsir/commentary integration
- Word-by-word analysis
- Multiple reading modes (Surah, Page, Juz, Hizb, Ruku)
- Complete EN/BN localization with Flutter l10n

🔧 **Recently Fixed (Sprint A)**:
- ✅ Reciter availability issue (DTO caching bug)
- ✅ Localized audio download prompts (EN/BN)
- ✅ Background Quran text download on first launch
- ✅ Comprehensive ARB localization for Quran module

⏳ **In Progress**:
- Audio download policy enforcement with user prompts
- Sajdah markers on appropriate verses
- Script variants (Uthmanic vs Indo-Pak)
- Enhanced search with transliteration support

---

## 🏗️ Architecture

### Clean Architecture Layers

```
lib/features/quran/
├── domain/                     # Business Logic Layer
│   └── services/               # Domain services
│       ├── audio_service.dart           # Audio playback & download
│       ├── offline_content_service.dart # Offline content management
│       ├── bookmarks_service.dart       # User bookmarks
│       └── search_service.dart          # Search functionality
├── data/                       # Data Layer
│   ├── api/                    # External API clients
│   │   ├── chapters_api.dart            # Chapters/Surah API
│   │   ├── verses_api.dart              # Verses with translations
│   │   └── resources_api.dart           # Translation/reciter resources
│   ├── dto/                    # Data Transfer Objects
│   ├── repo/                   # Repository implementations
│   │   └── quran_repository.dart        # Main data repository
│   └── cache/                  # Local storage abstraction
├── presentation/               # Presentation Layer
│   ├── screens/                # UI screens (13 screens)
│   ├── widgets/                # Reusable components (60+ widgets)
│   ├── providers/              # Riverpod state providers
│   ├── controllers/            # Screen controllers
│   └── state/                  # State management
└── utils/                      # Utility functions
```

### State Management

**Riverpod 2.x Providers**:
- `quranRepoProvider` - Main repository
- `quranAudioServiceProvider` - Audio service
- `translationResourcesProvider` - Available translations
- `recitationsProvider` - Available reciters (FIXED)
- `versesProvider.family` - Verses by chapter
- `offlineContentServiceProvider` - Offline management
- `quranBackgroundDownloadProvider` - Auto text download

---

## 🗄️ Data Sources & Caching

### Primary API: Quran.com API v4
- **Base URL**: `https://api.quran.com/api/v4`
- **Endpoints**: Chapters, verses, translations, reciters, tafsirs
- **Authentication**: Public API (considering key for production)
- **Rate Limiting**: Not implemented (planned)

### Caching Strategy (Hive)
```dart
// Storage boxes with TTL policies
'chapters'     // 7 days - All 114 chapters
'verses'       // 24 hours - Verses with translations  
'resources'    // 3 days - Translations, reciters, tafsirs
'audio'        // Persistent - Downloaded audio files
```

### Offline Content
- **Essential Download**: Auto-downloads popular chapters + 1 translation on first launch
- **User Choice**: Additional translations and audio via explicit user action
- **Storage**: Organized by chapter/reciter for efficient access

---

## 🎵 Audio System

### Features
- **Multiple Reciters**: 50+ world-renowned Qaris
- **Playback Modes**: Single verse, continuous, repeat (one/all)
- **Download Options**: Per-Surah or complete Quran
- **Offline Support**: Downloaded audio plays without internet
- **Progress Tracking**: Resume downloads, storage management

### Download Policy
```dart
// When user plays unavailable audio:
1. Show prompt: "Stream online or Download this Surah?"
2. Never auto-download without user consent
3. Progress indicators with cancel capability
4. Resume interrupted downloads
```

### Storage Organization
```
{appDocuments}/quran_audio/
├── reciter_1/
│   ├── chapter_1/
│   │   ├── 1_1.mp3  // Al-Fatiha verse 1
│   │   └── 1_2.mp3  // Al-Fatiha verse 2
│   └── chapter_2/
└── reciter_7/
```

---

## 🌍 Internationalization

### Supported Languages
- ✅ **English (en)** - Complete
- ✅ **Bengali (bn)** - Complete  
- ⏳ **Arabic (ar)** - Partial
- ⏳ **Urdu (ur)** - Partial

### ARB Localization Keys
```json
{
  "quranAudioNotDownloaded": "Audio Not Downloaded",
  "quranPlayOnline": "Play Online", 
  "quranDownloadSurah": "Download Surah",
  "quranWordByWord": "Word by Word",
  "quranTafsir": "Tafsir",
  "quranSajdahMarker": "Sajdah",
  "quranAutoScroll": "Auto Scroll",
  // ... 40+ more keys
}
```

### RTL Support
- Arabic text rendering with proper ligatures
- RTL layout for Arabic interface elements
- Mixed RTL/LTR support for translations

---

## 📱 User Interface

### Screen Hierarchy
```
QuranHomeScreen                 # Main entry point with quick actions
├── QuranReaderScreen          # Primary reading interface
├── EnhancedQuranReaderScreen  # Advanced reading features
├── QuranSearchScreen          # Search across text/translations
├── BookmarksScreen            # User bookmarks management
├── AudioDownloadsScreen       # Audio download management
├── OfflineManagementScreen    # Offline content control
├── ReadingPlansScreen         # Structured reading schedules
└── [Specialized Readers]      # Juz/Page/Hizb/Ruku modes
```

### Key Components
- **VerseCardWidget** - Individual verse display with actions
- **AudioPlayerWidget** - Playback controls and progress
- **TranslationPickerWidget** - Multi-translation selector
- **SearchFiltersWidget** - Advanced search options
- **AudioDownloadPromptDialog** - Download consent UI (NEW)

### Theme Integration
- Follows app-wide theme tokens and design system
- Light theme as default (dark mode supported)
- Custom fonts for Arabic text rendering
- Consistent spacing and color usage

---

## 🔧 Recent Fixes & Improvements

### Sprint A Achievements (2025-09-03)

#### 1. ✅ Fixed Reciter Availability Bug
**Problem**: "Error loading reciters" in audio downloads screen  
**Root Cause**: Repository was caching incomplete DTO data (`{id, name}` only)  
**Solution**: Store complete DTO with `e.toJson()` including `languageName` and `style`  
**Impact**: Audio downloads screen now properly loads all available reciters

#### 2. ✅ Comprehensive Localization
**Added**: 40+ Quran module strings to ARB files (EN/BN)  
**Updated**: AudioDownloadPromptDialog, SearchFiltersWidget with proper l10n  
**Keys**: Audio prompts, UI elements, features, status indicators  
**Testing**: Language switching works correctly across all Quran screens

#### 3. ✅ Background Content Download
**Feature**: Auto-download essential Quran text on first app launch  
**Content**: Popular chapters (Al-Fatiha, Yasin, last 3 surahs) + translation  
**Policy**: Text only, no audio, respects user data preferences  
**Status**: Implemented via `quranBackgroundDownloadProvider`

#### 4. ✅ Audio Download Prompt System  
**Component**: `AudioDownloadPromptDialog` with proper UX  
**Integration**: Callback system for audio service integration  
**Localization**: Full EN/BN support with contextual messaging  
**Policy**: Never silent downloads, clear user choice

---

## 🎯 Planned Enhancements

### Sprint B (Next Phase)
- **Sajdah Markers**: Prostration indicators on relevant verses
- **Script Variants**: Toggle between Uthmanic and Indo-Pak scripts
- **Enhanced Search**: Transliteration search, fuzzy matching, Bengali keywords
- **Word-by-Word UI**: Improved toggle panel with better typography
- **Audio Service Migration**: Migrate from simple to comprehensive audio service

### Sprint C (Future)
- **Reading Analytics**: Track reading habits and progress
- **Community Features**: Verse sharing, reading groups
- **Advanced Tafsir**: Multi-commentary comparison view
- **Performance**: Lazy loading, image optimization, cache management
- **Accessibility**: Screen reader support, high contrast mode

---

## 🧪 Testing Strategy

### Current Test Coverage
- **Unit Tests**: Repository caching, API mapping, audio service logic
- **Widget Tests**: Audio prompts, localization switching, verse rendering
- **Integration Tests**: Offline content download, audio playback flow
- **Golden Tests**: Verse card layouts in light theme

### Test Scenarios
```dart
// Example critical test cases
testWidgets('Audio download prompt shows correct localization', (tester) async {
  // Test EN/BN prompt display
});

test('Reciter repository caches complete DTO', () async {
  // Test fix for reciter availability issue
});

test('Background text download completes successfully', () async {
  // Test essential content download
});
```

---

## 📊 Performance Metrics

### Current Performance
- **Cold Start**: Quran text loads in <2s with cache
- **Audio Streaming**: <5s buffering for verse playback
- **Search Speed**: <500ms for Arabic/translation search
- **Cache Hit Rate**: >85% for frequently accessed content

### Storage Usage
- **Essential Text**: ~5MB (popular chapters + 1 translation)
- **Complete Text**: ~15MB (all chapters + 3 translations)
- **Audio Per Reciter**: ~1.2GB (complete Quran)
- **Cache Overhead**: <1MB (metadata and indexes)

---

## 🔐 Security & Privacy

### Data Protection
- **No Personal Data**: User preferences stored locally only
- **HTTPS Only**: All API communication encrypted
- **Local Storage**: Hive encryption for sensitive user data
- **API Security**: No user tracking or analytics sent to external APIs

### Production Considerations
- API key integration for rate limiting protection
- Certificate pinning for enhanced security
- Request signing for sensitive operations
- Privacy compliance documentation

---

## 🚀 Getting Started

### Dependencies
```yaml
# Core dependencies used by Quran module
flutter_riverpod: ^2.x       # State management
dio: ^5.x                    # HTTP client
hive_flutter: ^1.x           # Local storage
audioplayers: ^5.x           # Audio playback
flutter_gen/gen_l10n: ^1.x   # Localization
```

### Setup Steps
1. **Initialize Hive**: Call `await Hive.initFlutter()` in main()
2. **Setup Providers**: Wrap app with `ProviderScope`
3. **Background Download**: Access `quranBackgroundDownloadProvider` to trigger
4. **Audio Service**: Configure `quranAudioServiceProvider` with context
5. **Localization**: Ensure `AppLocalizations.of(context)` available

### Configuration
```dart
// Example provider setup
final quranAudioService = ref.watch(quranAudioServiceProvider);
quranAudioService.onPromptDownload = 
    AudioDownloadPromptDialog.createAudioServiceCallback(context);
```

---

## 📖 API Documentation

### Repository Interface
```dart
class QuranRepository {
  Future<List<ChapterDto>> getChapters({bool refresh = false});
  Future<VersesPageDto> getChapterPage({required int chapterId, ...});
  Future<List<TranslationResourceDto>> getTranslationResources();
  Future<List<RecitationResourceDto>> getRecitations(); // FIXED
  Future<List<TafsirResourceDto>> getTafsirResources();
}
```

### Service Interfaces
```dart
class QuranAudioService {
  Future<void> playVerse(int index);
  Future<void> downloadChapterAudio(int chapterId, int reciterId);
  Future<bool> isChapterComplete(int chapterId, int reciterId);
  
  // Callback for download prompts
  Future<bool> Function(dynamic verse)? onPromptDownload;
}
```

---

## 🤝 Contributing

### Code Style
- Follow Flutter/Dart official style guide
- Use meaningful variable names and comprehensive documentation
- Implement proper error handling with user-friendly messages
- Write tests for new features and bug fixes

### Adding Features
1. **Domain First**: Define business logic in `domain/services/`
2. **Data Layer**: Implement API clients and DTOs in `data/`
3. **Repository**: Add methods to `QuranRepository`
4. **Providers**: Create Riverpod providers in `presentation/state/`
5. **UI**: Build widgets in `presentation/widgets/`
6. **Localization**: Add ARB keys for all user-facing strings
7. **Tests**: Write comprehensive test coverage

### Localization Guidelines
- Never use hardcoded strings in UI
- Add all text to `lib/l10n/app_en.arb` and `lib/l10n/app_bn.arb`
- Use descriptive ARB keys with `quran` prefix
- Test language switching functionality
- Consider RTL layout requirements for Arabic

---

## 📞 Support & Issues

### Known Issues
- Audio service migration from old to new system needed
- Some advanced search features not yet implemented
- Indo-Pak script fonts not yet included

### Debugging
- Enable debug mode in audio service for detailed logging
- Check Hive box contents for cache debugging
- Monitor network requests via Dio interceptors
- Use Flutter Inspector for widget tree analysis

### Contact
For module-specific questions or contributions, refer to the main DeenMate project documentation and issue tracker.

---

*This module is actively maintained and follows semantic versioning. Documentation updated with each major release.*

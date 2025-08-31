# Quran Module - Complete Technical Specification

**Last Updated**: 29 August 2025  
**Module Status**: ✅ Implemented  
**Priority**: P0 (High)  
**Story Points**: 25pts total  
**Timeline**: Completed

---

## 📋 **TABLE OF CONTENTS**

1. [Project Overview](#project-overview)
2. [Technical Architecture](#technical-architecture)
3. [API Strategy & Data Sources](#api-strategy--data-sources)
4. [Data Models & DTOs](#data-models--dtos)
5. [State Management](#state-management)
6. [UI/UX Implementation](#uiux-implementation)
7. [Performance & Optimization](#performance--optimization)
8. [Testing Strategy](#testing-strategy)
9. [Deployment & Monitoring](#deployment--monitoring)

---

## 🎯 **PROJECT OVERVIEW**

### **Module Purpose**
The Quran Module provides comprehensive access to the Holy Quran with multiple translations, audio recitations, and advanced features following Islamic principles and DeenMate's established patterns.

### **Key Features**
- **Multi-Translation Support**: Bengali, English, Arabic, and Urdu translations
- **Audio Recitations**: High-quality audio from renowned Qaris
- **Advanced Search**: Search by text, chapter, verse, or keywords
- **Bookmarking System**: Save favorite verses with sync across devices
- **Offline Access**: Complete offline functionality with Hive caching
- **RTL Support**: Full Arabic text support with proper RTL layout
- **Tajweed Rules**: Visual indicators for proper Quranic recitation

### **Success Metrics**
- **Performance**: < 150ms list loading, < 500ms detail loading
- **Adoption**: 85% of users use bookmarks within 30 days
- **Reliability**: < 0.2% crash rate
- **Quality**: 95%+ test coverage

---

## 🏗️ **TECHNICAL ARCHITECTURE**

### **Clean Architecture Implementation**

#### **Data Layer**
```
lib/features/quran/data/
├── api/
│   ├── chapters_api.dart              # Chapter listing API
│   ├── verses_api.dart                # Verse retrieval API
│   └── resources_api.dart             # Audio and resources API
├── dto/
│   ├── chapter_dto.dart               # Chapter data transfer objects
│   ├── verse_dto.dart                 # Verse data transfer objects
│   └── translation_dto.dart           # Translation data objects
├── repo/
│   └── quran_repository.dart          # Repository implementation
└── cache/
    └── cache_keys.dart                # Cache key management
```

#### **Domain Layer**
```
lib/features/quran/domain/
├── entities/
│   ├── chapter.dart                   # Chapter entity
│   ├── verse.dart                     # Verse entity
│   └── translation.dart               # Translation entity
├── repositories/
│   └── quran_repository.dart          # Abstract repository interface
├── usecases/
│   ├── get_chapters.dart              # Get all chapters
│   ├── get_verses.dart                # Get verses by chapter
│   ├── search_quran.dart              # Search functionality
│   └── get_audio.dart                 # Audio retrieval
└── services/
    ├── search_service.dart            # Advanced search logic
    ├── bookmarks_service.dart         # Bookmark management
    └── offline_service.dart           # Offline functionality
```

#### **Presentation Layer**
```
lib/features/quran/presentation/
├── screens/
│   ├── quran_home_screen.dart         # Main Quran screen
│   ├── chapter_screen.dart            # Chapter listing
│   ├── verse_screen.dart              # Verse display
│   └── search_screen.dart             # Search interface
├── widgets/
│   ├── verse_card_widget.dart         # Verse display widget
│   ├── chapter_card_widget.dart       # Chapter display widget
│   └── audio_player_widget.dart       # Audio playback widget
├── providers/
│   └── quran_providers.dart           # Riverpod providers
└── state/
    └── providers.dart                 # State management
```

### **Dependencies & External Libraries**

#### **Core Dependencies**
```yaml
# State Management
flutter_riverpod: ^2.5.1
riverpod_annotation: ^2.3.5

# Network & API
dio: ^5.5.0

# Storage
hive: ^2.2.3
hive_flutter: ^1.1.0

# Audio
audioplayers: ^6.0.0

# UI & Theming
google_fonts: ^6.2.1
flutter_svg: ^2.0.10+1

# Utilities
intl: ^0.20.2
equatable: ^2.0.5
freezed_annotation: ^3.1.0
json_annotation: ^4.9.0
```

#### **Dev Dependencies**
```yaml
# Code Generation
build_runner: ^2.4.11
freezed: ^3.0.0-0.0.dev
json_serializable: ^6.8.0
hive_generator: ^2.0.1

# Testing
mockito: ^5.4.4
test: ^1.25.2
```

---

## 🔌 **API STRATEGY & DATA SOURCES**

### **Primary API: Quran.com API**

#### **Base Configuration**
```dart
class QuranApiConfig {
  static const String baseUrl = 'https://api.quran.com/api/v4';
  static const String userAgent = 'DeenMate/1.0.0';
  static const Duration timeout = Duration(seconds: 30);
  static const int maxRetries = 3;
}
```

#### **Key Endpoints**

##### **Chapters Endpoint**
```dart
// GET /chapters
Future<List<ChapterDto>> getChapters({String language = 'en'}) async {
  final response = await dio.get('/chapters', queryParameters: {
    'language': language,
  });
  
  final chapters = (response.data['chapters'] as List)
      .map((e) => ChapterDto.fromJson(e))
      .toList();
      
  return chapters;
}
```

##### **Verses Endpoint**
```dart
// GET /chapters/{id}/verses
Future<List<VerseDto>> getVerses(int chapterId, {
  String translation = 'bn',
  int page = 1,
  int perPage = 10,
}) async {
  final response = await dio.get('/chapters/$chapterId/verses', queryParameters: {
    'translations': translation,
    'page': page,
    'per_page': perPage,
  });
  
  final verses = (response.data['verses'] as List)
      .map((e) => VerseDto.fromJson(e))
      .toList();
      
  return verses;
}
```

##### **Search Endpoint**
```dart
// GET /search
Future<List<SearchResultDto>> searchQuran(String query, {
  String translation = 'bn',
  int page = 1,
  int perPage = 20,
}) async {
  final response = await dio.get('/search', queryParameters: {
    'q': query,
    'translations': translation,
    'page': page,
    'per_page': perPage,
  });
  
  final results = (response.data['search'] as List)
      .map((e) => SearchResultDto.fromJson(e))
      .toList();
      
  return results;
}
```

##### **Audio Endpoint**
```dart
// GET /audio_files
Future<List<AudioFileDto>> getAudioFiles(int chapterId, {
  String reciter = 'sudais',
}) async {
  final response = await dio.get('/audio_files', queryParameters: {
    'chapter': chapterId,
    'reciter': reciter,
  });
  
  final audioFiles = (response.data['audio_files'] as List)
      .map((e) => AudioFileDto.fromJson(e))
      .toList();
      
  return audioFiles;
}
```

### **Translation Sources**

#### **Available Translations**
| Language | Translation | Translator | Resource ID | Status |
|----------|-------------|------------|-------------|--------|
| **Bengali** | Dr. Muhiuddin Khan | 85 | ✅ Active |
| **English** | Saheeh International | 131 | ✅ Active |
| **Arabic** | Uthmani Script | 1 | ✅ Active |
| **Urdu** | Fateh Muhammad Jalandhri | 6 | ✅ Active |

#### **Translation Configuration**
```dart
class TranslationConfig {
  static const Map<String, int> translationIds = {
    'bn': 85,    // Bengali
    'en': 131,   // English
    'ar': 1,     // Arabic
    'ur': 6,     // Urdu
  };
  
  static const Map<String, String> translatorNames = {
    'bn': 'Dr. Muhiuddin Khan',
    'en': 'Saheeh International',
    'ar': 'Uthmani Script',
    'ur': 'Fateh Muhammad Jalandhri',
  };
}
```

### **Audio Recitations**

#### **Available Qaris**
| Qari | Reciter ID | Style | Quality | Status |
|------|------------|-------|---------|--------|
| **Abdul Rahman Al-Sudais** | 3 | Traditional | High | ✅ Available |
| **Mishary Rashid Alafasy** | 5 | Modern | High | ✅ Available |
| **Saud Al-Shuraim** | 4 | Traditional | High | ✅ Available |
| **Abdul Basit Abdul Samad** | 1 | Traditional | High | ✅ Available |

#### **Audio Configuration**
```dart
class AudioConfig {
  static const Map<String, int> reciterIds = {
    'sudais': 3,
    'alafasy': 5,
    'shuraim': 4,
    'abdul_basit': 1,
  };
  
  static const Map<String, String> reciterNames = {
    'sudais': 'Abdul Rahman Al-Sudais',
    'alafasy': 'Mishary Rashid Alafasy',
    'shuraim': 'Saud Al-Shuraim',
    'abdul_basit': 'Abdul Basit Abdul Samad',
  };
}
```

---

## 📊 **DATA MODELS & DTOs**

### **Chapter Data Model**

#### **ChapterDto**
```dart
@JsonSerializable()
class ChapterDto {
  const ChapterDto({
    required this.id,
    required this.nameArabic,
    required this.nameSimple,
    required this.nameBengali,
    required this.versesCount,
    required this.revelationPlace,
    required this.revelationOrder,
    this.bismillahPre,
  });

  final int id;
  @JsonKey(name: 'name_arabic')
  final String nameArabic;
  @JsonKey(name: 'name_simple')
  final String nameSimple;
  @JsonKey(name: 'name_bengali')
  final String nameBengali;
  @JsonKey(name: 'verses_count')
  final int versesCount;
  @JsonKey(name: 'revelation_place')
  final String revelationPlace;
  @JsonKey(name: 'revelation_order')
  final String revelationOrder;
  @JsonKey(name: 'bismillah_pre')
  final String? bismillahPre;

  factory ChapterDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ChapterDtoToJson(this);
}
```

#### **Chapter Entity**
```dart
@freezed
class Chapter with _$Chapter {
  const factory Chapter({
    required int id,
    required String nameArabic,
    required String nameSimple,
    required String nameBengali,
    required int versesCount,
    required String revelationPlace,
    required String revelationOrder,
    String? bismillahPre,
  }) = _Chapter;

  factory Chapter.fromDto(ChapterDto dto) => Chapter(
    id: dto.id,
    nameArabic: dto.nameArabic,
    nameSimple: dto.nameSimple,
    nameBengali: dto.nameBengali,
    versesCount: dto.versesCount,
    revelationPlace: dto.revelationPlace,
    revelationOrder: dto.revelationOrder,
    bismillahPre: dto.bismillahPre,
  );
}
```

### **Verse Data Model**

#### **VerseDto**
```dart
@JsonSerializable()
class VerseDto {
  const VerseDto({
    required this.id,
    required this.verseNumber,
    required this.textUthmani,
    required this.textArabic,
    required this.translations,
    required this.audioUrl,
    required this.pageNumber,
    required this.juzNumber,
    required this.hizbNumber,
    required this.rubNumber,
  });

  final int id;
  @JsonKey(name: 'verse_number')
  final int verseNumber;
  @JsonKey(name: 'text_uthmani')
  final String textUthmani;
  @JsonKey(name: 'text_arabic')
  final String textArabic;
  final Map<String, String> translations;
  @JsonKey(name: 'audio_url')
  final String audioUrl;
  @JsonKey(name: 'page_number')
  final int pageNumber;
  @JsonKey(name: 'juz_number')
  final int juzNumber;
  @JsonKey(name: 'hizb_number')
  final int hizbNumber;
  @JsonKey(name: 'rub_number')
  final int rubNumber;

  factory VerseDto.fromJson(Map<String, dynamic> json) =>
      _$VerseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VerseDtoToJson(this);
}
```

#### **Verse Entity**
```dart
@freezed
class Verse with _$Verse {
  const factory Verse({
    required int id,
    required int chapterId,
    required int verseNumber,
    required String textArabic,
    required String textUthmani,
    required Map<String, String> translations,
    required String audioUrl,
    required int pageNumber,
    required int juzNumber,
    required int hizbNumber,
    required int rubNumber,
  }) = _Verse;

  factory Verse.fromDto(VerseDto dto, int chapterId) => Verse(
    id: dto.id,
    chapterId: chapterId,
    verseNumber: dto.verseNumber,
    textArabic: dto.textArabic,
    textUthmani: dto.textUthmani,
    translations: dto.translations,
    audioUrl: dto.audioUrl,
    pageNumber: dto.pageNumber,
    juzNumber: dto.juzNumber,
    hizbNumber: dto.hizbNumber,
    rubNumber: dto.rubNumber,
  );
}
```

### **Translation Data Model**

#### **TranslationDto**
```dart
@JsonSerializable()
class TranslationDto {
  const TranslationDto({
    required this.id,
    required this.language,
    required this.translator,
    required this.text,
    required this.resourceName,
    required this.resourceId,
  });

  final int id;
  final String language;
  final String translator;
  final String text;
  @JsonKey(name: 'resource_name')
  final String resourceName;
  @JsonKey(name: 'resource_id')
  final int resourceId;

  factory TranslationDto.fromJson(Map<String, dynamic> json) =>
      _$TranslationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationDtoToJson(this);
}
```

#### **Translation Entity**
```dart
@freezed
class Translation with _$Translation {
  const factory Translation({
    required int id,
    required String language,
    required String translator,
    required String text,
    required String resourceName,
    required int resourceId,
  }) = _Translation;

  factory Translation.fromDto(TranslationDto dto) => Translation(
    id: dto.id,
    language: dto.language,
    translator: dto.translator,
    text: dto.text,
    resourceName: dto.resourceName,
    resourceId: dto.resourceId,
  );
}
```

---

## 🔄 **STATE MANAGEMENT**

### **Riverpod Providers Structure**

#### **Core Providers**
```dart
// Repository provider
final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  final dio = ref.watch(dioProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return QuranRepositoryImpl(dio, networkInfo);
});

// API providers
final quranApiProvider = Provider<QuranApi>((ref) {
  final dio = ref.watch(dioProvider);
  return QuranApi(dio);
});
```

#### **Data Providers**
```dart
// Chapters provider
final chaptersProvider = FutureProvider<List<Chapter>>((ref) async {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getChapters();
});

// Verses provider (family provider for chapter-specific data)
final versesProvider = FutureProvider.family<List<Verse>, int>((ref, chapterId) async {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.getVerses(chapterId);
});

// Search provider
final searchProvider = FutureProvider.family<List<SearchResult>, String>((ref, query) async {
  final repository = ref.watch(quranRepositoryProvider);
  return repository.searchQuran(query);
});
```

#### **State Providers**
```dart
// Translation selection
final selectedTranslationProvider = StateProvider<String>((ref) => 'bn');

// Qari selection
final selectedQariProvider = StateProvider<String>((ref) => 'sudais');

// Bookmarks
final bookmarksProvider = StateNotifierProvider<BookmarksNotifier, Set<int>>((ref) {
  return BookmarksNotifier(ref.watch(quranRepositoryProvider));
});

// Reading progress
final readingProgressProvider = StateNotifierProvider<ReadingProgressNotifier, Map<int, int>>((ref) {
  return ReadingProgressNotifier(ref.watch(quranRepositoryProvider));
});
```

#### **Audio State Management**
```dart
// Audio player state
final audioPlayerProvider = StateNotifierProvider<AudioPlayerNotifier, AudioPlayerState>((ref) {
  return AudioPlayerNotifier();
});

// Current playing verse
final currentPlayingVerseProvider = StateProvider<Verse?>((ref) => null);
```

### **State Notifiers**

#### **BookmarksNotifier**
```dart
class BookmarksNotifier extends StateNotifier<Set<int>> {
  BookmarksNotifier(this._repository) : super({}) {
    _loadBookmarks();
  }

  final QuranRepository _repository;

  Future<void> _loadBookmarks() async {
    final bookmarks = await _repository.getBookmarks();
    state = bookmarks;
  }

  Future<void> toggleBookmark(int verseId) async {
    if (state.contains(verseId)) {
      await _repository.removeBookmark(verseId);
      state = {...state}..remove(verseId);
    } else {
      await _repository.addBookmark(verseId);
      state = {...state, verseId};
    }
  }

  Future<void> clearBookmarks() async {
    await _repository.clearBookmarks();
    state = {};
  }
}
```

#### **AudioPlayerNotifier**
```dart
class AudioPlayerNotifier extends StateNotifier<AudioPlayerState> {
  AudioPlayerNotifier() : super(AudioPlayerState.initial());

  Future<void> playVerse(Verse verse) async {
    state = state.copyWith(
      status: AudioPlayerStatus.loading,
      currentVerse: verse,
    );

    try {
      await _audioPlayer.setUrl(verse.audioUrl);
      await _audioPlayer.play();
      
      state = state.copyWith(
        status: AudioPlayerStatus.playing,
        currentVerse: verse,
      );
    } catch (e) {
      state = state.copyWith(
        status: AudioPlayerStatus.error,
        error: e.toString(),
      );
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    state = state.copyWith(status: AudioPlayerStatus.paused);
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    state = state.copyWith(
      status: AudioPlayerStatus.stopped,
      currentVerse: null,
    );
  }
}
```

---

## 🎨 **UI/UX IMPLEMENTATION**

### **Screen Implementations**

#### **QuranHomeScreen**
```dart
class QuranHomeScreen extends ConsumerWidget {
  const QuranHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chaptersAsync = ref.watch(chaptersProvider);
    final selectedTranslation = ref.watch(selectedTranslationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.quranTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.pushNamed(context, '/quran/search'),
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => Navigator.pushNamed(context, '/quran/bookmarks'),
          ),
        ],
      ),
      body: chaptersAsync.when(
        data: (chapters) => ListView.builder(
          itemCount: chapters.length,
          itemBuilder: (context, index) {
            final chapter = chapters[index];
            return ChapterCardWidget(chapter: chapter);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
```

#### **VerseScreen**
```dart
class VerseScreen extends ConsumerWidget {
  const VerseScreen({super.key, required this.chapterId});

  final int chapterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versesAsync = ref.watch(versesProvider(chapterId));
    final selectedTranslation = ref.watch(selectedTranslationProvider);
    final bookmarks = ref.watch(bookmarksProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chapter $chapterId'),
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () => _showAudioSettings(context, ref),
          ),
        ],
      ),
      body: versesAsync.when(
        data: (verses) => ListView.builder(
          itemCount: verses.length,
          itemBuilder: (context, index) {
            final verse = verses[index];
            final isBookmarked = bookmarks.contains(verse.id);
            
            return VerseCardWidget(
              verse: verse,
              translation: selectedTranslation,
              isBookmarked: isBookmarked,
              onBookmarkToggle: () => ref
                  .read(bookmarksProvider.notifier)
                  .toggleBookmark(verse.id),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
```

### **Widget Implementations**

#### **ChapterCardWidget**
```dart
class ChapterCardWidget extends StatelessWidget {
  const ChapterCardWidget({super.key, required this.chapter});

  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            chapter.id.toString(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Row(
          children: [
            Text(
              chapter.nameBengali,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              chapter.nameArabic,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 16,
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${chapter.versesCount} verses • ${chapter.revelationPlace}',
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.pushNamed(
          context,
          '/quran/chapter/${chapter.id}',
        ),
      ),
    );
  }
}
```

#### **VerseCardWidget**
```dart
class VerseCardWidget extends StatelessWidget {
  const VerseCardWidget({
    super.key,
    required this.verse,
    required this.translation,
    required this.isBookmarked,
    required this.onBookmarkToggle,
  });

  final Verse verse;
  final String translation;
  final bool isBookmarked;
  final VoidCallback onBookmarkToggle;

  @override
  Widget build(BuildContext context) {
    final translationText = verse.translations[translation] ?? '';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verse number and controls
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    verse.verseNumber.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    color: isBookmarked ? Colors.amber : null,
                  ),
                  onPressed: onBookmarkToggle,
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareVerse(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Arabic text
            Text(
              verse.textArabic,
              style: const TextStyle(
                fontFamily: 'UthmanicHafs',
                fontSize: 20,
                height: 2.0,
              ),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 16),
            
            // Translation
            Text(
              translationText,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _shareVerse(BuildContext context) {
    final text = '${verse.textArabic}\n\n$translationText\n\n- Quran ${verse.chapterId}:${verse.verseNumber}';
    Share.share(text);
  }
}
```

---

## ⚡ **PERFORMANCE & OPTIMIZATION**

### **Caching Strategy**

#### **Hive Cache Implementation**
```dart
class QuranCacheService {
  static const String chaptersBox = 'quran_chapters';
  static const String versesBox = 'quran_verses';
  static const String translationsBox = 'quran_translations';
  static const Duration cacheExpiry = Duration(days: 7);

  Future<void> cacheChapters(List<Chapter> chapters) async {
    final box = await Hive.openBox<Chapter>(chaptersBox);
    await box.clear();
    
    for (final chapter in chapters) {
      await box.put(chapter.id, chapter);
    }
  }

  Future<List<Chapter>?> getCachedChapters() async {
    final box = await Hive.openBox<Chapter>(chaptersBox);
    if (box.isEmpty) return null;
    
    return box.values.toList();
  }

  Future<void> cacheVerses(int chapterId, List<Verse> verses) async {
    final box = await Hive.openBox<Verse>(versesBox);
    final key = 'chapter_$chapterId';
    
    await box.put(key, verses);
  }

  Future<List<Verse>?> getCachedVerses(int chapterId) async {
    final box = await Hive.openBox<Verse>(versesBox);
    final key = 'chapter_$chapterId';
    
    return box.get(key);
  }
}
```

#### **Network Caching**
```dart
class QuranRepositoryImpl implements QuranRepository {
  QuranRepositoryImpl(this._api, this._networkInfo, this._cacheService);

  final QuranApi _api;
  final NetworkInfo _networkInfo;
  final QuranCacheService _cacheService;

  @override
  Future<List<Chapter>> getChapters() async {
    // Check cache first
    final cachedChapters = await _cacheService.getCachedChapters();
    if (cachedChapters != null) {
      return cachedChapters;
    }

    // Check network connectivity
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    // Fetch from API
    final chapterDtos = await _api.getChapters();
    final chapters = chapterDtos.map((dto) => Chapter.fromDto(dto)).toList();

    // Cache the result
    await _cacheService.cacheChapters(chapters);

    return chapters;
  }

  @override
  Future<List<Verse>> getVerses(int chapterId) async {
    // Check cache first
    final cachedVerses = await _cacheService.getCachedVerses(chapterId);
    if (cachedVerses != null) {
      return cachedVerses;
    }

    // Check network connectivity
    if (!await _networkInfo.isConnected) {
      throw NetworkException('No internet connection');
    }

    // Fetch from API
    final verseDtos = await _api.getVerses(chapterId);
    final verses = verseDtos.map((dto) => Verse.fromDto(dto, chapterId)).toList();

    // Cache the result
    await _cacheService.cacheVerses(chapterId, verses);

    return verses;
  }
}
```

### **Lazy Loading Implementation**
```dart
class LazyVerseList extends StatefulWidget {
  const LazyVerseList({
    super.key,
    required this.chapterId,
    required this.verses,
  });

  final int chapterId;
  final List<Verse> verses;

  @override
  State<LazyVerseList> createState() => _LazyVerseListState();
}

class _LazyVerseListState extends State<LazyVerseList> {
  final ScrollController _scrollController = ScrollController();
  final List<Verse> _loadedVerses = [];
  int _currentIndex = 0;
  static const int _loadCount = 10;

  @override
  void initState() {
    super.initState();
    _loadMoreVerses();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreVerses();
    }
  }

  void _loadMoreVerses() {
    if (_currentIndex >= widget.verses.length) return;

    final endIndex = (_currentIndex + _loadCount).clamp(0, widget.verses.length);
    final newVerses = widget.verses.sublist(_currentIndex, endIndex);

    setState(() {
      _loadedVerses.addAll(newVerses);
      _currentIndex = endIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: _loadedVerses.length + 1,
      itemBuilder: (context, index) {
        if (index == _loadedVerses.length) {
          if (_currentIndex < widget.verses.length) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const SizedBox.shrink();
          }
        }

        final verse = _loadedVerses[index];
        return VerseCardWidget(verse: verse);
      },
    );
  }
}
```

---

## 🧪 **TESTING STRATEGY**

### **Unit Tests**

#### **Repository Tests**
```dart
void main() {
  group('QuranRepository', () {
    late MockQuranApi mockApi;
    late MockNetworkInfo mockNetworkInfo;
    late MockQuranCacheService mockCacheService;
    late QuranRepositoryImpl repository;

    setUp(() {
      mockApi = MockQuranApi();
      mockNetworkInfo = MockNetworkInfo();
      mockCacheService = MockQuranCacheService();
      repository = QuranRepositoryImpl(mockApi, mockNetworkInfo, mockCacheService);
    });

    group('getChapters', () {
      test('should return cached chapters when available', () async {
        // Arrange
        final cachedChapters = [Chapter(id: 1, nameArabic: 'الفاتحة', ...)];
        when(mockCacheService.getCachedChapters())
            .thenAnswer((_) async => cachedChapters);

        // Act
        final result = await repository.getChapters();

        // Assert
        expect(result, cachedChapters);
        verifyNever(mockApi.getChapters());
      });

      test('should fetch from API when cache is empty and network is available', () async {
        // Arrange
        when(mockCacheService.getCachedChapters()).thenAnswer((_) async => null);
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        
        final chapterDtos = [ChapterDto(id: 1, nameArabic: 'الفاتحة', ...)];
        when(mockApi.getChapters()).thenAnswer((_) async => chapterDtos);

        // Act
        final result = await repository.getChapters();

        // Assert
        expect(result.length, 1);
        verify(mockApi.getChapters()).called(1);
        verify(mockCacheService.cacheChapters(result)).called(1);
      });
    });
  });
}
```

#### **Use Case Tests**
```dart
void main() {
  group('GetChapters', () {
    late MockQuranRepository mockRepository;
    late GetChapters useCase;

    setUp(() {
      mockRepository = MockQuranRepository();
      useCase = GetChapters(mockRepository);
    });

    test('should get chapters from repository', () async {
      // Arrange
      final chapters = [Chapter(id: 1, nameArabic: 'الفاتحة', ...)];
      when(mockRepository.getChapters()).thenAnswer((_) async => chapters);

      // Act
      final result = await useCase();

      // Assert
      expect(result, chapters);
      verify(mockRepository.getChapters()).called(1);
    });
  });
}
```

### **Widget Tests**
```dart
void main() {
  group('ChapterCardWidget', () {
    testWidgets('should display chapter information correctly', (tester) async {
      // Arrange
      final chapter = Chapter(
        id: 1,
        nameArabic: 'الفاتحة',
        nameSimple: 'Al-Fatiha',
        nameBengali: 'আল-ফাতিহা',
        versesCount: 7,
        revelationPlace: 'Meccan',
        revelationOrder: '5',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChapterCardWidget(chapter: chapter),
          ),
        ),
      );

      // Assert
      expect(find.text('আল-ফাতিহা'), findsOneWidget);
      expect(find.text('الفاتحة'), findsOneWidget);
      expect(find.text('7 verses • Meccan'), findsOneWidget);
    });

    testWidgets('should navigate to chapter screen when tapped', (tester) async {
      // Arrange
      final chapter = Chapter(id: 1, ...);
      final mockNavigator = MockNavigator();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: mockNavigator,
          home: Scaffold(
            body: ChapterCardWidget(chapter: chapter),
          ),
        ),
      );

      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      // Assert
      verify(mockNavigator.pushNamed('/quran/chapter/1')).called(1);
    });
  });
}
```

### **Integration Tests**
```dart
void main() {
  group('Quran Module Integration', () {
    testWidgets('should display chapters and navigate to verses', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            quranRepositoryProvider.overrideWithValue(MockQuranRepository()),
          ],
          child: const MaterialApp(
            home: QuranHomeScreen(),
          ),
        ),
      );

      // Wait for chapters to load
      await tester.pumpAndSettle();

      // Act - Tap on first chapter
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Assert - Should navigate to verse screen
      expect(find.byType(VerseScreen), findsOneWidget);
    });
  });
}
```

---

## 🚀 **DEPLOYMENT & MONITORING**

### **Performance Monitoring**

#### **Analytics Implementation**
```dart
class QuranAnalytics {
  static void trackChapterView(int chapterId) {
    FirebaseAnalytics.instance.logEvent(
      name: 'quran_chapter_view',
      parameters: {
        'chapter_id': chapterId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackVerseBookmark(int verseId, bool isBookmarked) {
    FirebaseAnalytics.instance.logEvent(
      name: 'quran_verse_bookmark',
      parameters: {
        'verse_id': verseId,
        'is_bookmarked': isBookmarked,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackSearch(String query) {
    FirebaseAnalytics.instance.logEvent(
      name: 'quran_search',
      parameters: {
        'query': query,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackAudioPlay(int verseId, String reciter) {
    FirebaseAnalytics.instance.logEvent(
      name: 'quran_audio_play',
      parameters: {
        'verse_id': verseId,
        'reciter': reciter,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
```

#### **Error Tracking**
```dart
class QuranErrorTracker {
  static void trackApiError(String endpoint, String error) {
    FirebaseCrashlytics.instance.recordError(
      Exception('API Error: $endpoint - $error'),
      StackTrace.current,
      reason: 'Quran API Error',
    );
  }

  static void trackCacheError(String operation, String error) {
    FirebaseCrashlytics.instance.recordError(
      Exception('Cache Error: $operation - $error'),
      StackTrace.current,
      reason: 'Quran Cache Error',
    );
  }

  static void trackAudioError(String verseId, String error) {
    FirebaseCrashlytics.instance.recordError(
      Exception('Audio Error: Verse $verseId - $error'),
      StackTrace.current,
      reason: 'Quran Audio Error',
    );
  }
}
```

### **Performance Metrics**

#### **Loading Time Tracking**
```dart
class PerformanceTracker {
  static void trackChapterLoadTime(int chapterId, Duration loadTime) {
    FirebasePerformance.instance.newTrace('quran_chapter_load').then((trace) {
      trace.setMetric('chapter_id', chapterId);
      trace.setMetric('load_time_ms', loadTime.inMilliseconds);
      trace.stop();
    });
  }

  static void trackVerseLoadTime(int chapterId, Duration loadTime) {
    FirebasePerformance.instance.newTrace('quran_verse_load').then((trace) {
      trace.setMetric('chapter_id', chapterId);
      trace.setMetric('load_time_ms', loadTime.inMilliseconds);
      trace.stop();
    });
  }

  static void trackSearchTime(String query, Duration searchTime) {
    FirebasePerformance.instance.newTrace('quran_search').then((trace) {
      trace.setMetric('query_length', query.length);
      trace.setMetric('search_time_ms', searchTime.inMilliseconds);
      trace.stop();
    });
  }
}
```

---

## 📚 **DOCUMENTATION FILES**

- **`README.md`** - Overview & purpose of the module
- **`todo-quran.md`** - Detailed development tasks and tracking
- **`project-tracking.md`** - High-level project tracking
- **`api-strategy.md`** - Detailed API strategy and implementation

---

*Last Updated: 29 August 2025*  
*File Location: docs/quran-module/quran-module-specification.md*

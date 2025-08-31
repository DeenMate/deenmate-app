# Quran Module - API Strategy & Implementation

**Last Updated**: 29 August 2025  
**Module Status**: ✅ Implemented  
**Priority**: P0 (High)

---

## 📋 **API OVERVIEW**

### **Primary API: Quran.com API**
The Quran module uses the Quran.com API v4 as the primary data source for Quranic content, translations, and audio files.

**Base URL**: `https://api.quran.com/api/v4/`  
**Documentation**: [Quran.com API Docs](https://quran.api-docs.io/)  
**Rate Limits**: 1000 requests per hour per IP  
**Authentication**: Not required for public endpoints

---

## 🔌 **API ENDPOINTS**

### **Chapters Endpoint**
```http
GET /chapters
```

**Purpose**: Retrieve all 114 chapters of the Quran  
**Parameters**:
- `language` (optional): Language code for chapter names (default: 'en')

**Response Example**:
```json
{
  "chapters": [
    {
      "id": 1,
      "name_arabic": "الفاتحة",
      "name_simple": "Al-Fatiha",
      "name_bengali": "আল-ফাতিহা",
      "verses_count": 7,
      "revelation_place": "Meccan",
      "revelation_order": "5",
      "bismillah_pre": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ"
    }
  ]
}
```

**Implementation**:
```dart
class ChaptersApi {
  Future<List<ChapterDto>> getChapters({String language = 'en'}) async {
    final response = await dio.get('/chapters', queryParameters: {
      'language': language,
    });
    
    final chapters = (response.data['chapters'] as List)
        .map((e) => ChapterDto.fromJson(e))
        .toList();
        
    return chapters;
  }
}
```

### **Verses Endpoint**
```http
GET /chapters/{id}/verses
```

**Purpose**: Retrieve verses for a specific chapter  
**Parameters**:
- `id`: Chapter ID (1-114)
- `translations`: Translation resource IDs (comma-separated)
- `page`: Page number for pagination
- `per_page`: Number of verses per page (max: 50)

**Response Example**:
```json
{
  "verses": [
    {
      "id": 1,
      "verse_number": 1,
      "text_uthmani": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "text_arabic": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
      "translations": {
        "85": "পরম করুণাময় অতি দয়ালু আল্লাহর নামে",
        "131": "In the name of Allah, the Entirely Merciful, the Especially Merciful"
      },
      "audio_url": "https://audio.quran.com/1/1.mp3",
      "page_number": 1,
      "juz_number": 1,
      "hizb_number": 1,
      "rub_number": 1
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 1,
    "total_records": 7,
    "per_page": 50
  }
}
```

**Implementation**:
```dart
class VersesApi {
  Future<List<VerseDto>> getVerses(
    int chapterId, {
    String translations = '85,131',
    int page = 1,
    int perPage = 50,
  }) async {
    final response = await dio.get('/chapters/$chapterId/verses', queryParameters: {
      'translations': translations,
      'page': page,
      'per_page': perPage,
    });
    
    final verses = (response.data['verses'] as List)
        .map((e) => VerseDto.fromJson(e))
        .toList();
        
    return verses;
  }
}
```

### **Search Endpoint**
```http
GET /search
```

**Purpose**: Search across all translations and Arabic text  
**Parameters**:
- `q`: Search query
- `translations`: Translation resource IDs to search in
- `page`: Page number for pagination
- `per_page`: Number of results per page (max: 20)

**Response Example**:
```json
{
  "search": [
    {
      "verse_id": 1,
      "verse_key": "1:1",
      "text": "পরম করুণাময় অতি দয়ালু আল্লাহর নামে",
      "resource_name": "Dr. Muhiuddin Khan",
      "resource_id": 85,
      "language": "bn"
    }
  ],
  "pagination": {
    "current_page": 1,
    "total_pages": 1,
    "total_records": 1,
    "per_page": 20
  }
}
```

**Implementation**:
```dart
class SearchApi {
  Future<List<SearchResultDto>> searchQuran(
    String query, {
    String translations = '85,131',
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await dio.get('/search', queryParameters: {
      'q': query,
      'translations': translations,
      'page': page,
      'per_page': perPage,
    });
    
    final results = (response.data['search'] as List)
        .map((e) => SearchResultDto.fromJson(e))
        .toList();
        
    return results;
  }
}
```

### **Audio Files Endpoint**
```http
GET /audio_files
```

**Purpose**: Retrieve audio recitation files  
**Parameters**:
- `chapter`: Chapter ID
- `reciter`: Reciter ID
- `segments`: Include verse segments (optional)

**Response Example**:
```json
{
  "audio_files": [
    {
      "id": 1,
      "chapter_id": 1,
      "verse_number": 1,
      "audio_url": "https://audio.quran.com/1/1.mp3",
      "format": "mp3",
      "reciter_id": 3,
      "reciter_name": "Abdul Rahman Al-Sudais"
    }
  ]
}
```

**Implementation**:
```dart
class AudioApi {
  Future<List<AudioFileDto>> getAudioFiles(
    int chapterId, {
    int reciter = 3,
    bool segments = false,
  }) async {
    final response = await dio.get('/audio_files', queryParameters: {
      'chapter': chapterId,
      'reciter': reciter,
      if (segments) 'segments': true,
    });
    
    final audioFiles = (response.data['audio_files'] as List)
        .map((e) => AudioFileDto.fromJson(e))
        .toList();
        
    return audioFiles;
  }
}
```

---

## 🌐 **TRANSLATION RESOURCES**

### **Available Translations**

| Language | Translation | Resource ID | Translator | Status |
|----------|-------------|-------------|------------|--------|
| **Bengali** | Dr. Muhiuddin Khan | 85 | Dr. Muhiuddin Khan | ✅ Active |
| **English** | Saheeh International | 131 | Saheeh International | ✅ Active |
| **Arabic** | Uthmani Script | 1 | Uthmani Script | ✅ Active |
| **Urdu** | Fateh Muhammad Jalandhri | 6 | Fateh Muhammad Jalandhri | ✅ Active |
| **English** | Dr. Mustafa Khattab | 101 | Dr. Mustafa Khattab | ✅ Active |
| **English** | The Clear Quran | 149 | Dr. Mustafa Khattab | ✅ Active |

### **Translation Configuration**
```dart
class TranslationConfig {
  static const Map<String, int> translationIds = {
    'bn': 85,    // Bengali - Dr. Muhiuddin Khan
    'en': 131,   // English - Saheeh International
    'ar': 1,     // Arabic - Uthmani Script
    'ur': 6,     // Urdu - Fateh Muhammad Jalandhri
  };
  
  static const Map<String, String> translatorNames = {
    'bn': 'Dr. Muhiuddin Khan',
    'en': 'Saheeh International',
    'ar': 'Uthmani Script',
    'ur': 'Fateh Muhammad Jalandhri',
  };
  
  static const Map<String, String> languageNames = {
    'bn': 'বাংলা',
    'en': 'English',
    'ar': 'العربية',
    'ur': 'اردو',
  };
}
```

---

## 🎵 **AUDIO RECITATIONS**

### **Available Reciters**

| Reciter | Reciter ID | Style | Quality | Status |
|---------|------------|-------|---------|--------|
| **Abdul Rahman Al-Sudais** | 3 | Traditional | High | ✅ Available |
| **Mishary Rashid Alafasy** | 5 | Modern | High | ✅ Available |
| **Saud Al-Shuraim** | 4 | Traditional | High | ✅ Available |
| **Abdul Basit Abdul Samad** | 1 | Traditional | High | ✅ Available |
| **Maher Al Mueaqly** | 2 | Modern | High | ✅ Available |
| **Ali Abdur-Rahman Al-Huthayfi** | 6 | Traditional | High | ✅ Available |

### **Audio Configuration**
```dart
class AudioConfig {
  static const Map<String, int> reciterIds = {
    'sudais': 3,      // Abdul Rahman Al-Sudais
    'alafasy': 5,     // Mishary Rashid Alafasy
    'shuraim': 4,     // Saud Al-Shuraim
    'abdul_basit': 1, // Abdul Basit Abdul Samad
    'maher': 2,       // Maher Al Mueaqly
    'huthayfi': 6,    // Ali Abdur-Rahman Al-Huthayfi
  };
  
  static const Map<String, String> reciterNames = {
    'sudais': 'Abdul Rahman Al-Sudais',
    'alafasy': 'Mishary Rashid Alafasy',
    'shuraim': 'Saud Al-Shuraim',
    'abdul_basit': 'Abdul Basit Abdul Samad',
    'maher': 'Maher Al Mueaqly',
    'huthayfi': 'Ali Abdur-Rahman Al-Huthayfi',
  };
  
  static const Map<String, String> reciterStyles = {
    'sudais': 'Traditional',
    'alafasy': 'Modern',
    'shuraim': 'Traditional',
    'abdul_basit': 'Traditional',
    'maher': 'Modern',
    'huthayfi': 'Traditional',
  };
}
```

---

## 🔄 **CACHING STRATEGY**

### **Cache Configuration**
```dart
class QuranCacheConfig {
  // Cache expiry times
  static const Duration chaptersCacheExpiry = Duration(days: 30);
  static const Duration versesCacheExpiry = Duration(days: 7);
  static const Duration searchCacheExpiry = Duration(hours: 24);
  static const Duration audioCacheExpiry = Duration(days: 30);
  
  // Cache keys
  static const String chaptersCacheKey = 'quran_chapters';
  static const String versesCacheKey = 'quran_verses';
  static const String searchCacheKey = 'quran_search';
  static const String audioCacheKey = 'quran_audio';
  
  // Cache size limits
  static const int maxCachedChapters = 114;
  static const int maxCachedVerses = 1000;
  static const int maxCachedSearches = 100;
  static const int maxCachedAudioFiles = 500;
}
```

### **Hive Cache Implementation**
```dart
class QuranCacheService {
  static const String chaptersBox = 'quran_chapters';
  static const String versesBox = 'quran_verses';
  static const String searchBox = 'quran_search';
  static const String audioBox = 'quran_audio';

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

  Future<void> cacheSearchResults(String query, List<SearchResult> results) async {
    final box = await Hive.openBox<SearchResult>(searchBox);
    final key = 'search_${query.hashCode}';
    
    await box.put(key, results);
  }

  Future<List<SearchResult>?> getCachedSearchResults(String query) async {
    final box = await Hive.openBox<SearchResult>(searchBox);
    final key = 'search_${query.hashCode}';
    
    return box.get(key);
  }
}
```

---

## 🚀 **OFFLINE STRATEGY**

### **Offline Data Management**
```dart
class QuranOfflineService {
  final QuranCacheService _cacheService;
  final NetworkInfo _networkInfo;

  QuranOfflineService(this._cacheService, this._networkInfo);

  Future<List<Chapter>> getChapters() async {
    // Always try cache first
    final cachedChapters = await _cacheService.getCachedChapters();
    if (cachedChapters != null) {
      return cachedChapters;
    }

    // If no cache and no network, throw offline exception
    if (!await _networkInfo.isConnected) {
      throw OfflineException('No cached data available and no internet connection');
    }

    // Fetch from API and cache
    final chapters = await _fetchChaptersFromApi();
    await _cacheService.cacheChapters(chapters);
    return chapters;
  }

  Future<List<Verse>> getVerses(int chapterId) async {
    // Try cache first
    final cachedVerses = await _cacheService.getCachedVerses(chapterId);
    if (cachedVerses != null) {
      return cachedVerses;
    }

    // If no cache and no network, throw offline exception
    if (!await _networkInfo.isConnected) {
      throw OfflineException('No cached data available and no internet connection');
    }

    // Fetch from API and cache
    final verses = await _fetchVersesFromApi(chapterId);
    await _cacheService.cacheVerses(chapterId, verses);
    return verses;
  }

  Future<void> preloadPopularChapters() async {
    if (!await _networkInfo.isConnected) return;

    // Preload first 10 chapters
    for (int i = 1; i <= 10; i++) {
      try {
        final verses = await _fetchVersesFromApi(i);
        await _cacheService.cacheVerses(i, verses);
      } catch (e) {
        // Continue with next chapter if one fails
        continue;
      }
    }
  }
}
```

---

## 🔒 **SECURITY & RATE LIMITING**

### **Rate Limiting Strategy**
```dart
class QuranApiRateLimiter {
  static const int maxRequestsPerHour = 1000;
  static const int maxRequestsPerMinute = 60;
  
  final Map<String, List<DateTime>> _requestHistory = {};
  
  Future<void> checkRateLimit(String endpoint) async {
    final now = DateTime.now();
    final key = endpoint;
    
    if (!_requestHistory.containsKey(key)) {
      _requestHistory[key] = [];
    }
    
    final requests = _requestHistory[key]!;
    
    // Remove requests older than 1 hour
    requests.removeWhere((time) => now.difference(time).inHours > 0);
    
    // Check hourly limit
    if (requests.length >= maxRequestsPerHour) {
      throw RateLimitException('Hourly rate limit exceeded');
    }
    
    // Remove requests older than 1 minute
    requests.removeWhere((time) => now.difference(time).inMinutes > 0);
    
    // Check minute limit
    if (requests.length >= maxRequestsPerMinute) {
      throw RateLimitException('Minute rate limit exceeded');
    }
    
    // Add current request
    requests.add(now);
  }
}
```

### **Error Handling**
```dart
class QuranApiErrorHandler {
  static String handleApiError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 404:
              return 'Requested resource not found.';
            case 429:
              return 'Too many requests. Please try again later.';
            case 500:
              return 'Server error. Please try again later.';
            default:
              return 'Network error occurred.';
          }
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        default:
          return 'Network error occurred.';
      }
    }
    
    return 'An unexpected error occurred.';
  }
}
```

---

## 📊 **MONITORING & ANALYTICS**

### **API Usage Tracking**
```dart
class QuranApiAnalytics {
  static void trackApiCall(String endpoint, Duration responseTime, bool success) {
    FirebaseAnalytics.instance.logEvent(
      name: 'quran_api_call',
      parameters: {
        'endpoint': endpoint,
        'response_time_ms': responseTime.inMilliseconds,
        'success': success,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackCacheHit(String cacheType) {
    FirebaseAnalytics.instance.logEvent(
      name: 'quran_cache_hit',
      parameters: {
        'cache_type': cacheType,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackOfflineUsage(String feature) {
    FirebaseAnalytics.instance.logEvent(
      name: 'quran_offline_usage',
      parameters: {
        'feature': feature,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
```

### **Performance Monitoring**
```dart
class QuranPerformanceTracker {
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

## 🔄 **FALLBACK STRATEGIES**

### **API Fallback Chain**
1. **Primary**: Quran.com API v4
2. **Secondary**: Local JSON datasets
3. **Tertiary**: Offline cached data

### **Translation Fallback**
```dart
class TranslationFallbackService {
  static String getFallbackTranslation(String language) {
    switch (language) {
      case 'bn':
        return 'bn'; // Bengali
      case 'en':
        return '131'; // Saheeh International
      case 'ar':
        return '1'; // Uthmani Script
      case 'ur':
        return '6'; // Urdu
      default:
        return '131'; // Default to English
    }
  }

  static List<String> getFallbackTranslations(String primaryLanguage) {
    switch (primaryLanguage) {
      case 'bn':
        return ['bn', '131', '1']; // Bengali, English, Arabic
      case 'en':
        return ['131', 'bn', '1']; // English, Bengali, Arabic
      case 'ar':
        return ['1', '131', 'bn']; // Arabic, English, Bengali
      case 'ur':
        return ['6', '131', 'bn']; // Urdu, English, Bengali
      default:
        return ['131', 'bn', '1']; // Default fallback chain
    }
  }
}
```

---

## 📚 **DOCUMENTATION FILES**

- **`README.md`** - Overview & purpose of the module
- **`quran-module-specification.md`** - Complete technical specification
- **`todo-quran.md`** - Detailed development tasks and tracking
- **`project-tracking.md`** - High-level project tracking

---

*Last Updated: 29 August 2025*  
*File Location: docs/quran-module/api-strategy.md*

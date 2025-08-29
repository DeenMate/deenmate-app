# Hadith Module - Complete Specification & Implementation Guide

**Last Updated**: 29 August 2025  
**Module Status**: 🔄 Ready to Start  
**Priority**: P0 (High)  
**Story Points**: 21pts total  
**Timeline**: 6 weeks

---

## 📋 **TABLE OF CONTENTS**

1. [Project Overview](#project-overview)
2. [iHadis.com Analysis & Insights](#ihadiscom-analysis--insights)
3. [DeenMate Architecture Alignment](#deenmate-architecture-alignment)
4. [API Strategy & Data Sources](#api-strategy--data-sources)
5. [Implementation Plan](#implementation-plan)
6. [Technical Architecture](#technical-architecture)
7. [UI/UX Design Strategy](#uiux-design-strategy)
8. [Development Timeline](#development-timeline)
9. [Acceptance Criteria](#acceptance-criteria)

---

## 🎯 **PROJECT OVERVIEW**

### **Module Purpose**
The Hadith Module will provide comprehensive access to authentic Islamic Hadith collections, following DeenMate's established patterns and incorporating insights from [ihadis.com](https://ihadis.com/).

### **Key Features**
- **Bengali-First Approach**: Prioritize Bengali language and Islamic terminology
- **Sahih Collections**: Start with Bukhari (7,544) and Muslim (7,452) hadiths
- **Search & Discovery**: Global search with keyboard shortcuts
- **Offline Access**: Hive-based caching with 7-day TTL
- **Multi-language**: Bengali, English, Arabic with RTL support
- **Topic-Based Navigation**: Islamic topics (Aqeedah, Iman, Prayer, etc.)

### **Success Metrics**
- **Performance**: < 200ms list loading, < 800ms detail loading
- **Adoption**: 25% of users use bookmarks within 30 days
- **Reliability**: < 0.5% crash rate
- **Quality**: 90%+ test coverage

---

## 🔍 **IHADIS.COM ANALYSIS & INSIGHTS**

### **Site Analysis Summary**
Based on analysis of [ihadis.com](https://ihadis.com/):

#### **Key Observations**
- **Bengali-First Approach**: All navigation and content in Bengali
- **Global Search**: "হাদিস সার্চ করুন" with Ctrl+K shortcut
- **Quick Collection Access**: Popular collections with letter icons (B, M, N, A, T, I)
- **Featured Content**: Daily rotating hadiths from different collections
- **Topic-Based Organization**: Islamic topics (Aqeedah, Iman, Purification, Prayer, etc.)
- **Clean Design**: Islamic aesthetics with proper typography

#### **Navigation Structure**
```
হোম (Home) → হাদিস গ্রন্থসমূহ (Hadith Books) → বিষয়ভিত্তিক (Topic-based)
```

#### **Collection Quick Access**
```
বুখারী | মুসলিম | নাসায়ী | আবু দাউদ | তিরমিজি | ইবনে মাজাহ
```

#### **Featured Content System**
- **Daily Rotation**: Different hadiths each day
- **Multiple Sources**: Mix of collections (Bukhari, Muslim, Abu Dawud, etc.)
- **Practical Focus**: Hadiths relevant to daily Islamic life
- **Full Translation**: Complete Bengali translations

#### **Topic-Based Organization**
```
বিষয়ভিত্তিক হাদিস (Topic-based Hadith):
- আকিদা (Aqeedah) - 07 hadiths
- ঈমান (Iman) - 05 hadiths  
- পবিত্রতা (Purification) - 12 hadiths
- সালাত (Prayer) - 44 hadiths
- দান সদকাহ (Charity) - 01 hadith
- বিবাহ সম্পর্কে (Marriage) - 05 hadiths
```

### **Hadith Collections Available**
| Collection | Bengali Name | Hadith Count | Priority for DeenMate |
|------------|--------------|--------------|----------------------|
| **Sahih Bukhari** | সহিহ বুখারী | 7,544 | P0 (Phase 1) |
| **Sahih Muslim** | সহিহ মুসলিম | 7,452 | P0 (Phase 1) |
| **Sunan an-Nasai** | সুনানে আন-নাসায়ী | 5,757 | P1 (Phase 2) |
| **Sunan Abu Dawud** | সুনানে আবু দাউদ | 5,274 | P1 (Phase 2) |
| **Jami' at-Tirmidhi** | জামে' আত-তিরমিজি | 3,941 | P1 (Phase 2) |
| **Sunan Ibn Majah** | সুনানে ইবনে মাজাহ | 4,341 | P1 (Phase 2) |
| **Muwatta Imam Malik** | মুয়াত্তা ইমাম মালিক | 1,853 | P2 (Phase 3) |
| **Riyadus Saliheen** | রিয়াদুস সালেহিন | 1,905 | P2 (Phase 3) |
| **Bulughul Maram** | বুলুগুল মারাম | 1,567 | P2 (Phase 3) |

### **Key Insights for DeenMate**

#### **1. Bengali Market Focus**
- Prioritize Bengali translations in our Hadith module
- Use proper Islamic terminology in Bengali
- Ensure RTL support for Arabic text within Bengali interface
- Consider Bengali-first UI for Bangladesh market

#### **2. User Experience Patterns**
- **Search-First Approach**: Prominent search functionality with keyboard shortcuts
- **Collection-Based Navigation**: Primary navigation by collection
- **Topic-Based Organization**: Secondary navigation by Islamic topics
- **Featured Content**: Daily rotating hadiths
- **Quick Access**: Most popular collections at top

#### **3. Content Strategy**
- **Daily Rotation**: Different hadith each day
- **Collection Mix**: Include hadiths from various collections
- **Practical Focus**: Hadiths relevant to daily Islamic life
- **Full Translation**: Complete Bengali translations
- **Contextual Display**: Show relevant hadiths based on time/occasion

---

## 🏗️ **DEENMATE ARCHITECTURE ALIGNMENT**

### **Current DeenMate Structure**
```
lib/
├── main.dart                 # App entry point
├── core/                     # Shared utilities and config
│   ├── theme/               # App theming and colors
│   ├── navigation/          # GoRouter configuration
│   ├── constants/           # App-wide constants
│   ├── utils/               # Helper functions
│   ├── localization/        # i18n setup
│   ├── net/                 # Dio client and networking
│   ├── storage/             # Hive boxes and storage
│   └── error/               # Error handling and failures
├── features/                # Feature-based modules
│   ├── prayer_times/        # Prayer calculation and display
│   ├── quran/              # Quran reading and audio
│   ├── qibla/              # Compass and direction finding
│   ├── islamic_content/     # Daily content and articles
│   ├── settings/           # App configuration
│   └── onboarding/         # First-time user experience
└── shared/                  # Shared widgets and providers
    ├── widgets/            # Reusable UI components
    ├── providers/          # Global Riverpod providers
    └── models/             # Shared data models
```

### **Quran Module Reference Implementation**
```
lib/features/quran/
├── data/
│   ├── api/
│   │   ├── chapters_api.dart
│   │   ├── verses_api.dart
│   │   └── resources_api.dart
│   ├── dto/
│   │   ├── chapter_dto.dart
│   │   ├── verse_dto.dart
│   │   ├── translation_resource_dto.dart
│   │   └── recitation_resource_dto.dart
│   ├── repo/
│   │   └── quran_repository.dart
│   └── cache/
│       └── cache_keys.dart
├── domain/
│   └── services/
│       ├── audio_service.dart
│       ├── offline_content_service.dart
│       ├── bookmarks_service.dart
│       └── search_service.dart
└── presentation/
    ├── screens/
    │   ├── quran_reader_screen.dart
    │   ├── enhanced_quran_reader_screen.dart
    │   └── audio_downloads_screen.dart
    ├── widgets/
    │   ├── verse_card_widget.dart
    │   ├── audio_player_widget.dart
    │   └── navigation_widget.dart
    ├── providers/
    │   └── quran_providers.dart
    └── state/
        └── providers.dart
```

### **Hadith Module Structure (Following Quran Pattern)**
```
lib/features/hadith/
├── data/
│   ├── api/
│   │   └── sunnah_api.dart              # Follow Quran API pattern
│   ├── dto/
│   │   ├── hadith_dto.dart
│   │   ├── collection_dto.dart
│   │   ├── book_dto.dart
│   │   └── chapter_dto.dart
│   ├── repo/
│   │   └── hadith_repository.dart       # Follow Quran repo pattern
│   └── cache/
│       └── cache_keys.dart              # Follow Quran cache pattern
├── domain/
│   ├── entities/
│   │   ├── hadith.dart
│   │   ├── collection.dart
│   │   ├── book.dart
│   │   └── chapter.dart
│   ├── repositories/
│   │   └── hadith_repository.dart       # Abstract interface
│   ├── usecases/
│   │   ├── get_collections.dart
│   │   ├── get_books.dart
│   │   ├── get_hadiths.dart
│   │   └── search_hadith.dart
│   └── services/
│       ├── search_service.dart          # Follow Quran search pattern
│       ├── bookmarks_service.dart       # Follow Quran bookmarks pattern
│       └── offline_service.dart         # Follow Quran offline pattern
└── presentation/
    ├── screens/
    │   ├── hadith_home_screen.dart
    │   ├── hadith_collection_screen.dart
    │   ├── hadith_book_screen.dart
    │   ├── hadith_chapter_screen.dart
    │   └── hadith_detail_screen.dart
    ├── widgets/
    │   ├── hadith_card_widget.dart      # Follow verse_card pattern
    │   ├── collection_card_widget.dart
    │   ├── search_bar_widget.dart
    │   └── bookmark_button_widget.dart
    ├── providers/
    │   └── hadith_providers.dart        # Follow Quran providers pattern
    └── state/
        └── providers.dart               # Follow Quran state pattern
```

### **Key Patterns to Follow**

#### **1. API Integration Pattern**
```dart
// API classes using Dio client
class SunnahApi {
  SunnahApi(this.dio);
  final Dio dio;
  
  Future<List<HadithCollectionDto>> getCollections() async {
    final response = await dio.get('/collections');
    // Error handling and response mapping
  }
}

// Provider setup
final sunnahApiProvider = Provider((ref) => SunnahApi(ref.watch(dioQfProvider)));
```

#### **2. Repository Pattern**
```dart
class HadithRepository {
  HadithRepository(this._sunnahApi, this._hive);
  
  Future<List<HadithCollectionDto>> getCollections({bool refresh = true}) async {
    final box = await _hive.openBox(boxes.Boxes.hadithCollections);
    final cached = box.get('all');
    
    if (cached != null) {
      if (refresh) _refreshCollections(box);
      return cached.cast<Map>().map((e) => HadithCollectionDto.fromJson(e)).toList();
    }
    
    final fresh = await _sunnahApi.getCollections();
    await box.put('all', fresh.map((e) => e.toJson()).toList());
    return fresh;
  }
}
```

#### **3. State Management Pattern**
```dart
// Providers for different data types
final hadithRepoProvider = Provider((ref) => HadithRepository(...));
final hadithCollectionsProvider = FutureProvider((ref) => ref.watch(hadithRepoProvider).getCollections());
final currentCollectionProvider = StateProvider<HadithCollectionDto?>((ref) => null);
```

#### **4. Caching Strategy**
```dart
// Hive-based caching with TTL
final box = await _hive.openBox(boxes.Boxes.hadithCollections);
final cached = box.get('all');
if (cached != null) {
  // Use cached data
  if (refresh) _refreshCollections(box); // Background refresh
}
```

---

## 🔌 **API STRATEGY & DATA SOURCES**

### **API Strategy Overview**

#### **Option 1: Sunnah.com API (Recommended)**
**Status**: ✅ **RECOMMENDED** - Most comprehensive and reliable

**Advantages**:
- **Comprehensive Coverage**: All major Hadith collections (Bukhari, Muslim, etc.)
- **Multiple Languages**: English, Arabic, and some Bengali translations
- **Well-Documented**: Clear API documentation and examples
- **Reliable**: High uptime and good performance
- **Free Tier**: Available for non-commercial use
- **Structured Data**: Clean JSON responses with proper metadata

**API Endpoints**:
```
Base URL: https://api.sunnah.com/v1/
Endpoints:
- GET /collections - List all Hadith collections
- GET /collections/{collection}/books - Get books in a collection
- GET /collections/{collection}/books/{book}/hadiths - Get hadiths in a book
- GET /hadiths/{hadith_number} - Get specific hadith details
- GET /search - Search across all hadiths
```

**Example Response Structure**:
```json
{
  "collection": "bukhari",
  "bookNumber": 1,
  "hadithNumber": 1,
  "arabic": "إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ...",
  "english": "Actions are but by intention...",
  "reference": "Sahih al-Bukhari 1:1",
  "grade": "Sahih",
  "narrator": "Umar ibn al-Khattab"
}
```

#### **Option 2: Local JSON Datasets**
**Status**: 🔄 **FALLBACK** - For offline access and Bengali translations

**Advantages**:
- **Offline Access**: Works without internet connection
- **Bengali Support**: Can include Bengali translations
- **Custom Control**: Full control over data structure and content
- **No API Limits**: No rate limiting or usage restrictions

#### **Option 3: Hybrid Approach (Recommended)**
**Status**: ✅ **RECOMMENDED** - Best of both worlds

**Strategy**:
1. **Primary**: Sunnah.com API for real-time data
2. **Fallback**: Local JSON datasets for offline access
3. **Bengali**: Local Bengali translations where API doesn't provide them
4. **Caching**: Hive-based caching with 7-day TTL

### **Data Model Structure**

#### **Collection Metadata**
```dart
class HadithCollectionDTO {
  final String id;           // 'bukhari', 'muslim'
  final String name;         // 'Sahih Bukhari'
  final String bengaliName;  // 'সহিহ বুখারী'
  final String arabicName;   // 'صحيح البخاري'
  final int hadithCount;     // 7544
  final String type;         // 'Sahih', 'Sunan', 'Jami'
  final String description;  // Brief description
  final bool isAvailable;    // Whether collection is loaded
}
```

#### **Hadith Data Structure**
```dart
class HadithDTO {
  final String id;                    // "bukhari_1_1"
  final String collection;            // "bukhari"
  final int bookNumber;               // 1
  final int hadithNumber;             // 1
  final String arabicText;            // Arabic text
  final Map<String, String> translations; // {"en": "...", "bn": "..."}
  final String reference;             // "Sahih al-Bukhari 1:1"
  final String grade;                 // "Sahih"
  final String narrator;              // "Umar ibn al-Khattab"
}
```

### **Caching Strategy**
```dart
// Cache keys following existing patterns
final hadithCacheKeys = {
  'collections': 'hadith_collections',
  'books': 'hadith_books_{collection}',
  'hadiths': 'hadith_list_{collection}_{book}',
  'detail': 'hadith_detail_{hadith_id}',
  'bookmarks': 'hadith_bookmarks',
};

// Cache TTL: 7 days (following existing patterns)
const Duration hadithCacheTTL = Duration(days: 7);
```

---

## 🚀 **IMPLEMENTATION PLAN**

### **Phase 1: Foundation & Data Layer** (Week 1-2)
**Priority**: P0 | **Story Points**: 8pts | **Status**: 🔄 Ready to Start

#### **HADITH-101: API Integration & Data Models (3pts)**
**Tasks**:
- [ ] **Create SunnahApi Service**
  - [ ] Implement `SunnahApi` using existing `DioClient` pattern
  - [ ] Add base URL: `https://api.sunnah.com/v1/`
  - [ ] Implement endpoints: `/collections`, `/collections/{collection}/books`, `/collections/{collection}/books/{book}/hadiths`
  - [ ] Implement error handling with `Failure` types
  - [ ] Add retry logic and timeout handling
  - [ ] **Priority**: Focus on Sahih Bukhari (7,544) and Sahih Muslim (7,452) first

- [ ] **Data Models & DTOs**
  - [ ] Create `HadithDTO` with JSON serialization using `json_annotation`
  - [ ] Create `HadithCollectionDTO`, `HadithBookDTO`, `HadithChapterDTO`
  - [ ] Implement Hive adapters for offline caching using `hive_generator`
  - [ ] Add proper null safety and validation
  - [ ] **Bengali Support**: Include Bengali names and translations in DTOs
  - [ ] **Collection Metadata**: Add hadith counts and collection types

- [ ] **Repository Layer**
  - [ ] Create `HadithRepository` interface
  - [ ] Implement `HadithRepositoryImpl` with remote/local sources
  - [ ] Add caching strategy (7-day TTL, versioned keys)
  - [ ] Implement offline fallback mechanisms

#### **HADITH-102: Domain Layer & Use Cases (2pts)**
**Tasks**:
- [ ] **Entities**
  - [ ] Create `Hadith` entity with domain logic using `freezed`
  - [ ] Create `Book`, `Chapter` entities
  - [ ] Add proper equality and toString methods

- [ ] **Use Cases**
  - [ ] `GetHadithCollections` - List available collections
  - [ ] `GetHadithBooks` - Get books for a collection
  - [ ] `GetHadithChapters` - Get chapters for a book
  - [ ] `GetHadithList` - Get hadith list for a chapter
  - [ ] `GetHadithDetail` - Get detailed hadith
  - [ ] `SearchHadith` - Client-side search functionality
  - [ ] `ToggleBookmark` - Bookmark management

#### **HADITH-103: State Management & Providers (3pts)**
**Tasks**:
- [ ] **Riverpod Providers**
  - [ ] `hadithRepositoryProvider` - Repository instance
  - [ ] `hadithCollectionsProvider` - Available collections
  - [ ] `hadithBooksProvider(collection, lang)` - Books for collection
  - [ ] `hadithChaptersProvider(collection, book, lang)` - Chapters for book
  - [ ] `hadithListProvider(collection, book, chapter, lang, page)` - Hadith list
  - [ ] `hadithDetailProvider(collection, id, lang)` - Hadith detail
  - [ ] `hadithSearchProvider(query, collection, lang, page)` - Search results
  - [ ] `hadithBookmarksProvider` - Bookmarked hadith (StreamProvider)

- [ ] **State Management**
  - [ ] Create `HadithState` with loading, success, error states
  - [ ] Implement `HadithNotifier` for state management
  - [ ] Add language reactivity (derive from current l10n)
  - [ ] Implement bookmark state management

### **Phase 2: Presentation Layer** (Week 3-4)
**Priority**: P0 | **Story Points**: 6pts | **Status**: 🔄 Waiting for Phase 1

#### **HADITH-201: Core UI Screens (4pts)**
**Tasks**:
- [ ] **HadithHomeScreen**
  - [ ] Collection overview with counts (inspired by iHadis layout)
  - [ ] Search functionality with Ctrl+K shortcut
  - [ ] Recent/bookmarked hadith
  - [ ] **Bengali-First UI**: Show Bengali names prominently
  - [ ] **Collection Groups**: Group by Sahih, Sunan, Special collections
  - [ ] **Featured Content**: Daily rotating hadiths

- [ ] **HadithCollectionScreen**
  - [ ] Book list with navigation
  - [ ] Chapter overview
  - [ ] Search within collection
  - [ ] RTL support for Arabic content

- [ ] **HadithBookScreen**
  - [ ] Chapter list with counts
  - [ ] Navigation to chapters
  - [ ] Book metadata display
  - [ ] Responsive layout

- [ ] **HadithChapterScreen**
  - [ ] Hadith list with pagination
  - [ ] Search within chapter
  - [ ] Quick navigation
  - [ ] Loading states and error handling

- [ ] **HadithDetailScreen**
  - [ ] Arabic text with RTL layout
  - [ ] Translation display (Bengali first, English fallback)
  - [ ] Metadata (reference, grade, narrator)
  - [ ] Actions (bookmark, share, copy)
  - [ ] Source attribution

#### **HADITH-202: Navigation & Routing (2pts)**
**Tasks**:
- [ ] **GoRouter Integration**
  - [ ] Add hadith routes to `lib/core/navigation/shell_wrapper.dart`
  - [ ] `/hadith` → `HadithHomeScreen`
  - [ ] `/hadith/:collection` → `HadithCollectionScreen`
  - [ ] `/hadith/:collection/book/:book` → `HadithBookScreen`
  - [ ] `/hadith/:collection/book/:book/chapter/:chapter` → `HadithChapterScreen`
  - [ ] `/hadith/:collection/item/:id` → `HadithDetailScreen`

- [ ] **Navigation Integration**
  - [ ] Add to bottom navigation (More screen)
  - [ ] Implement deep linking for shared hadith
  - [ ] Add breadcrumb navigation
  - [ ] Preserve scroll position per route

### **Phase 3: Localization & Polish** (Week 4-5)
**Priority**: P1 | **Story Points**: 4pts | **Status**: 🔄 Waiting for Phase 2

#### **HADITH-301: Multi-language Support (2pts)**
**Tasks**:
- [ ] **ARB Keys**
  - [ ] Add hadith-specific keys to `lib/l10n/intl_en.arb`
  - [ ] Add Bengali translations to `lib/l10n/intl_bn.arb` (priority)
  - [ ] Add Arabic translations to `lib/l10n/intl_ar.arb`
  - [ ] Keys: `hadithTitle`, `hadithCollections`, `hadithSearch`
  - [ ] Keys: `hadithBook`, `hadithChapter`, `hadithReference`
  - [ ] Keys: `hadithNarrator`, `hadithGrade`, `hadithSource`
  - [ ] Keys: `hadithBookmarks`, `hadithNoResults`
  - [ ] **Collection Names**: Add proper Bengali names for all collections
  - [ ] **Islamic Terms**: Use proper Islamic terminology in Bengali

- [ ] **RTL Support**
  - [ ] Implement proper RTL layout for Arabic content
  - [ ] Test Arabic font rendering with existing fonts
  - [ ] Ensure proper text direction handling
  - [ ] Add Urdu RTL support

- [ ] **Language Fallback**
  - [ ] Implement fallback strategy (user → English → Arabic)
  - [ ] Handle missing translations gracefully
  - [ ] Add "translation unavailable" notes

#### **HADITH-302: Testing & Quality Assurance (2pts)**
**Tasks**:
- [ ] **Unit Tests**
  - [ ] Test DTO ↔ Entity mapping
  - [ ] Test repository behaviors
  - [ ] Test use cases
  - [ ] Test state management

- [ ] **Widget Tests**
  - [ ] Test hadith list rendering
  - [ ] Test detail screen layout
  - [ ] Test bookmark functionality
  - [ ] Test RTL rendering

- [ ] **Integration Tests**
  - [ ] Test navigation flow
  - [ ] Test search functionality
  - [ ] Test offline fallback
  - [ ] Test language switching

### **Phase 4: Advanced Features** (Week 5-6)
**Priority**: P2 | **Story Points**: 3pts | **Status**: 🔄 Future Enhancement

#### **HADITH-401: Enhanced Features (3pts)**
**Tasks**:
- [ ] **Advanced Search**
  - [ ] Search by narrator
  - [ ] Search by grade/authenticity
  - [ ] Search by topic/theme
  - [ ] Search filters and sorting

- [ ] **Bookmark Management**
  - [ ] Bookmark collections
  - [ ] Bookmark sync across devices
  - [ ] Bookmark export/import
  - [ ] Bookmark organization

- [ ] **Sharing & Export**
  - [ ] Share hadith with attribution
  - [ ] Export hadith collections
  - [ ] Generate hadith reports
  - [ ] Social media integration

---

## 🔧 **TECHNICAL ARCHITECTURE**

### **Integration with Existing System**
- **State Management**: Riverpod (following prayer_times patterns)
- **Navigation**: GoRouter (integrate with shell_wrapper.dart)
- **Storage**: Hive + SharedPreferences (use existing patterns)
- **Networking**: Dio client (use existing dio_client.dart)
- **Theming**: Islamic theme system (use existing core/theme/)
- **Localization**: l10n system (use existing lib/l10n/)

### **Data Flow**
```
API → DTO → Repository → Use Case → Provider → UI
  ↓      ↓        ↓         ↓         ↓       ↓
Cache → Hive → Entity → State → Notifier → Widget
```

### **Performance Targets**
- **List Loading**: < 200ms first frame
- **Detail Loading**: < 800ms cached, < 1500ms network
- **Search**: < 500ms client-side
- **Offline**: 100% functionality

### **Error Handling**
```dart
// Use existing failure types from lib/core/error/failures.dart
try {
  final response = await dio.get('/collections');
  // Process response
} on DioException catch (e) {
  if (e.type == DioExceptionType.connectionTimeout) {
    throw const Failure.timeoutFailure();
  } else if (e.response?.statusCode != null) {
    throw Failure.serverFailure(
      message: 'Sunnah API error: ${e.message}',
      statusCode: e.response!.statusCode!,
    );
  } else {
    throw Failure.networkFailure(
      message: 'Network error while fetching hadith: ${e.message}',
    );
  }
}
```

---

## 🎨 **UI/UX DESIGN STRATEGY**

### **Design Principles from iHadis**
1. **Clean Layout**: Minimal clutter, focus on content
2. **Islamic Aesthetics**: Respectful design with proper Islamic elements
3. **Bengali Typography**: Clear, readable Bengali text
4. **Easy Navigation**: Simple hierarchy and clear categories
5. **Visual Icons**: Letter-based collection icons (B, M, N, A, T, I)

### **Enhanced Navigation Structure**
```
Hadith Home
├── Quick Search (Global search with Ctrl+K)
├── Popular Collections
│   ├── Sahih Bukhari (B)
│   ├── Sahih Muslim (M)
│   ├── Sunan an-Nasai (N)
│   ├── Sunan Abu Dawud (A)
│   ├── Jami' at-Tirmidhi (T)
│   └── Sunan Ibn Majah (I)
├── All Collections
├── Topic-Based Browse
└── Featured Content
```

### **UI Components**

#### **Collection Card Design**
```dart
class HadithCollectionCard extends StatelessWidget {
  final String name;         // 'Sahih Bukhari'
  final String bengaliName;  // 'সহিহ বুখারী'
  final String arabicName;   // 'صحيح البخاري'
  final int hadithCount;     // 7544
  final String type;         // 'Sahih', 'Sunan', etc.
  
  // Design: Clean layout with prominent Bengali name and count
}
```

#### **Featured Hadith Card**
```dart
class FeaturedHadithCard extends StatelessWidget {
  final Hadith hadith;
  final String collectionName;
  final String bengaliTranslation;
  
  // Design: Prominent display with collection reference
}
```

#### **Topic Navigation**
```dart
class HadithTopicGrid extends StatelessWidget {
  final List<HadithTopic> topics;
  
  // Design: Grid layout with topic icons and counts
}
```

### **Theme Integration**
```dart
// Use existing theme system from lib/core/theme/
class HadithTheme {
  static Color get primaryColor => AppColors.islamicGreen;
  static Color get secondaryColor => AppColors.islamicGold;
  static Color get backgroundColor => AppColors.creamWhite;
  
  static TextStyle get arabicTextStyle => AppFonts.arabicText;
  static TextStyle get bengaliTextStyle => AppFonts.bengaliText;
  static TextStyle get englishTextStyle => AppFonts.englishText;
}
```

### **Material 3 Design System**
```dart
// Follow existing Material 3 patterns
class HadithCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.surface,
              theme.colorScheme.surfaceVariant,
            ],
          ),
        ),
        child: // Content
      ),
    );
  }
}
```

---

## 📅 **DEVELOPMENT TIMELINE**

### **Overall Progress**
| Phase | Progress | Status | Story Points | Timeline |
|-------|----------|--------|--------------|----------|
| **Phase 1: Foundation** | 0% | 🔄 Ready to Start | 8pts | Week 1-2 |
| **Phase 2: UI Layer** | 0% | ⏳ Waiting | 6pts | Week 3-4 |
| **Phase 3: Polish** | 0% | ⏳ Waiting | 4pts | Week 4-5 |
| **Phase 4: Advanced** | 0% | ⏳ Future | 3pts | Week 5-6 |

**Total Progress**: 0/21pts (0%)  
**Current Sprint**: Sprint 1 - Foundation  
**Next Milestone**: Complete data layer and basic state management

### **Milestones**
| Date | Milestone | Deliverables |
|------|-----------|--------------|
| Week 2 | Foundation Complete | Data layer, models, repository |
| Week 4 | UI Complete | All screens, navigation |
| Week 5 | Polish Complete | Localization, testing |
| Week 6 | Advanced Complete | Enhanced features |

### **Current Sprint Status**

#### **Sprint 1: Hadith Foundation** (Week 1-2)
**Goal**: Complete data layer and basic state management  
**Points**: 8/21 (38%)  
**Status**: 🔄 Ready to Start

**Active Tasks**:
- **HADITH-101: API Integration & Data Models (3pts)** - ⏳ Not Started
- **HADITH-102: Domain Layer & Use Cases (2pts)** - ⏳ Not Started
- **HADITH-103: State Management & Providers (3pts)** - ⏳ Not Started

**Definition of Done**:
- [ ] All data models created and tested
- [ ] Repository layer implemented
- [ ] Basic providers working
- [ ] Unit tests passing
- [ ] Code review completed

---

## 📋 **ACCEPTANCE CRITERIA**

### **Functional Requirements**
- [ ] Browse Bukhari/Muslim collections
- [ ] Navigate book → chapter → hadith hierarchy
- [ ] View hadith detail with Arabic + translation
- [ ] Search hadith by text
- [ ] Bookmark/unbookmark hadith
- [ ] Share hadith with attribution
- [ ] Offline access to cached content
- [ ] Language switching (EN/BN/AR)

### **Non-Functional Requirements**
- [ ] Performance targets met
- [ ] Accessibility compliance
- [ ] RTL layout support
- [ ] Offline functionality
- [ ] Error handling
- [ ] Loading states

### **Success Metrics**
- **Performance**: Meet loading time targets
- **Reliability**: < 0.5% crash rate
- **Quality**: 90%+ test coverage
- **Offline**: 100% functionality
- **Adoption**: 25% of users use bookmarks
- **Engagement**: Average session time > 5 minutes
- **Retention**: 70% of users return within 7 days

---

## ⚠️ **RISKS & MITIGATION**

### **Technical Risks**
- **API Reliability**: Robust caching and fallbacks
- **Performance**: Pagination and lazy loading
- **Localization**: Thorough RTL testing
- **Storage**: Cache size management

### **Timeline Risks**
- **Scope Creep**: Strict adherence to Phase 1 requirements
- **Integration Issues**: Early testing with existing modules
- **Resource Constraints**: Clear task breakdown and dependencies

### **Content Risks**
- **Translation Quality**: Source authentic Bengali translations
- **Data Accuracy**: Validate API responses and add data cleaning
- **Storage Size**: Implement data compression and cleanup

---

## 🔄 **NEXT STEPS**

1. **Immediate** (This Week):
   - [ ] Start HADITH-101: API Integration
   - [ ] Create basic data structures
   - [ ] Set up repository layer

2. **Next Week**:
   - [ ] Complete HADITH-101
   - [ ] Start HADITH-102: Domain Layer
   - [ ] Begin unit testing

3. **Following Weeks**:
   - [ ] Complete Phase 1
   - [ ] Start Phase 2: UI Development
   - [ ] Begin integration testing

---

*Last Updated: 29 August 2025*  
*File Location: docs/hadith-module/hadith-module-specification.md*

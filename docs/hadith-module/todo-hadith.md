# Hadith Module Development TODO

**Last Updated**: 29 August 2025  
**Current Focus**: Hadith Module Implementation  
**Status**: 🔄 Ready to Start  
**Priority**: P0 (High)  
**Story Points**: 21pts total

---

## 🎯 **HADITH MODULE DEVELOPMENT PLAN**

### **Phase 1: Foundation & Data Layer** (Week 1-2)
**Priority**: P0 | **Story Points**: 8pts | **Status**: 🔄 Ready to Start

#### **HADITH-101: API Integration & Data Models (3pts)**
**Status**: ⏳ Not Started | **Assignee**: TBD | **Dependencies**: None

**Tasks**:
- [ ] **Create SunnahApi Service**
  - [ ] Implement `SunnahApi` using existing `DioClient` pattern from `lib/core/net/dio_client.dart`
  - [ ] Add base URL: `https://api.sunnah.com/v1/`
  - [ ] Implement endpoints: `/collections`, `/collections/{collection}/books`, `/collections/{collection}/books/{book}/hadiths`
  - [ ] Implement error handling with `Failure` types from `lib/core/error/`
  - [ ] Add retry logic and timeout handling
  - [ ] Follow existing API patterns from Quran module
  - [ ] **Priority**: Focus on Sahih Bukhari (7,544) and Sahih Muslim (7,452) first

- [ ] **Data Models & DTOs**
  - [ ] Create `HadithDTO` with JSON serialization using `json_annotation`
  - [ ] Create `HadithCollectionDTO`, `HadithBookDTO`, `HadithChapterDTO`
  - [ ] Implement Hive adapters for offline caching using `hive_generator`
  - [ ] Add proper null safety and validation
  - [ ] Follow existing DTO patterns from Quran module
  - [ ] **Bengali Support**: Include Bengali names and translations in DTOs
  - [ ] **Collection Metadata**: Add hadith counts and collection types (Sahih, Sunan, etc.)

- [ ] **Repository Layer**
  - [ ] Create `HadithRepository` interface
  - [ ] Implement `HadithRepositoryImpl` with remote/local sources
  - [ ] Add caching strategy (7-day TTL, versioned keys)
  - [ ] Implement offline fallback mechanisms
  - [ ] Follow existing repository patterns from prayer_times module

**Files to Create**:
```
lib/features/hadith/
├── data/
│   ├── api/
│   │   └── sunnah_api.dart
│   ├── datasources/
│   │   ├── hadith_remote_datasource.dart
│   │   └── hadith_local_datasource.dart
│   ├── repositories/
│   │   └── hadith_repository_impl.dart
│   └── models/
│       ├── hadith_dto.dart
│       ├── book_dto.dart
│       ├── chapter_dto.dart
│       └── collection_dto.dart
```

**Data Structure (inspired by iHadis)**:
```dart
// Collection metadata with Bengali support
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

**Integration Points**:
- Use `DioClient` from `lib/core/net/dio_client.dart`
- Follow error handling from `lib/core/error/failures.dart`
- Use Hive patterns from `lib/core/storage/hive_boxes.dart`
- Follow API patterns from `lib/features/quran/data/api/` (Quran.com API v4)
- Use `AppConfig` for base URL configuration like Quran module

#### **HADITH-102: Domain Layer & Use Cases (2pts)**
**Status**: ⏳ Not Started | **Assignee**: TBD | **Dependencies**: HADITH-101

**Tasks**:
- [ ] **Entities**
  - [ ] Create `Hadith` entity with domain logic using `freezed`
  - [ ] Create `Book`, `Chapter` entities
  - [ ] Add proper equality and toString methods
  - [ ] Follow existing entity patterns from other modules

- [ ] **Use Cases**
  - [ ] `GetHadithCollections` - List available collections
  - [ ] `GetHadithBooks` - Get books for a collection
  - [ ] `GetHadithChapters` - Get chapters for a book
  - [ ] `GetHadithList` - Get hadith list for a chapter
  - [ ] `GetHadithDetail` - Get detailed hadith
  - [ ] `SearchHadith` - Client-side search functionality
  - [ ] `ToggleBookmark` - Bookmark management
  - [ ] Follow existing use case patterns from prayer_times module

**Files to Create**:
```
lib/features/hadith/
├── domain/
│   ├── entities/
│   │   ├── hadith.dart
│   │   ├── book.dart
│   │   └── chapter.dart
│   ├── repositories/
│   │   └── hadith_repository.dart
│   └── usecases/
│       ├── get_hadith_collections.dart
│       ├── get_hadith_books.dart
│       ├── get_hadith_chapters.dart
│       ├── get_hadith_list.dart
│       ├── get_hadith_detail.dart
│       ├── search_hadith.dart
│       └── toggle_bookmark.dart
```

#### **HADITH-103: State Management & Providers (3pts)**
**Status**: ⏳ Not Started | **Assignee**: TBD | **Dependencies**: HADITH-102

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
  - [ ] Follow existing provider patterns from prayer_times module

**Files to Create**:
```
lib/features/hadith/
├── presentation/
│   └── providers/
│       ├── hadith_providers.dart
│       ├── hadith_state.dart
│       └── hadith_notifier.dart
```

**Integration Points**:
- Use language provider from `lib/core/localization/language_provider.dart`
- Follow provider patterns from `lib/features/prayer_times/presentation/providers/`

### **Phase 2: Presentation Layer** (Week 3-4)
**Priority**: P0 | **Story Points**: 6pts | **Status**: 🔄 Waiting for Phase 1

#### **HADITH-201: Core UI Screens (4pts)**
**Status**: ⏳ Not Started | **Assignee**: TBD | **Dependencies**: HADITH-103

**Tasks**:
- [ ] **HadithHomeScreen**
  - [ ] Collection overview with counts (inspired by iHadis layout)
  - [ ] Search functionality
  - [ ] Recent/bookmarked hadith
  - [ ] Responsive design for mobile/tablet
  - [ ] Follow existing screen patterns from islamic_content module
  - [ ] **Bengali-First UI**: Show Bengali names prominently with English/Arabic
  - [ ] **Collection Groups**: Group by Sahih, Sunan, Special collections
  - [ ] **Hadith Counts**: Display counts prominently like iHadis

- [ ] **HadithCollectionScreen**
  - [ ] Book list with navigation
  - [ ] Chapter overview
  - [ ] Search within collection
  - [ ] RTL support for Arabic content
  - [ ] Use existing theme system from `lib/core/theme/`

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
  - [ ] Use existing Arabic fonts from `assets/fonts/`
  - [ ] **Bengali Translation**: Prioritize Bengali translations like iHadis
  - [ ] **Clean Layout**: Follow iHadis clean, respectful design

**Files to Create**:
```
lib/features/hadith/
├── presentation/
│   ├── screens/
│   │   ├── hadith_home_screen.dart
│   │   ├── hadith_collection_screen.dart
│   │   ├── hadith_book_screen.dart
│   │   ├── hadith_chapter_screen.dart
│   │   └── hadith_detail_screen.dart
│   └── widgets/
│       ├── hadith_collection_card.dart (inspired by iHadis layout)
│       ├── hadith_card.dart
│       ├── hadith_list_item.dart
│       ├── hadith_detail_view.dart
│       ├── hadith_search_bar.dart
│       └── hadith_bookmark_button.dart
```

**UI Components (inspired by iHadis)**:
```dart
// Collection card with Bengali support
class HadithCollectionCard extends StatelessWidget {
  final String name;         // 'Sahih Bukhari'
  final String bengaliName;  // 'সহিহ বুখারী'
  final String arabicName;   // 'صحيح البخاري'
  final int hadithCount;     // 7544
  final String type;         // 'Sahih', 'Sunan', etc.
  
  // Design: Clean layout with prominent Bengali name and count
}
```

#### **HADITH-202: Navigation & Routing (2pts)**
**Status**: ⏳ Not Started | **Assignee**: TBD | **Dependencies**: HADITH-201

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
  - [ ] Follow existing navigation patterns

### **Phase 3: Localization & Polish** (Week 4-5)
**Priority**: P1 | **Story Points**: 4pts | **Status**: 🔄 Waiting for Phase 2

#### **HADITH-301: Multi-language Support (2pts)**
**Status**: ⏳ Not Started | **Assignee**: TBD | **Dependencies**: HADITH-202

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
  - [ ] Use existing RTL patterns from Quran module

- [ ] **Language Fallback**
  - [ ] Implement fallback strategy (user → English → Arabic)
  - [ ] Handle missing translations gracefully
  - [ ] Add "translation unavailable" notes
  - [ ] Use existing language provider patterns

#### **HADITH-302: Testing & Quality Assurance (2pts)**
**Status**: ⏳ Not Started | **Assignee**: TBD | **Dependencies**: HADITH-301

**Tasks**:
- [ ] **Unit Tests**
  - [ ] Test DTO ↔ Entity mapping
  - [ ] Test repository behaviors
  - [ ] Test use cases
  - [ ] Test state management
  - [ ] Follow existing test patterns from other modules

- [ ] **Widget Tests**
  - [ ] Test hadith list rendering
  - [ ] Test detail screen layout
  - [ ] Test bookmark functionality
  - [ ] Test RTL rendering
  - [ ] Use existing test utilities

- [ ] **Integration Tests**
  - [ ] Test navigation flow
  - [ ] Test search functionality
  - [ ] Test offline fallback
  - [ ] Test language switching
  - [ ] Follow existing integration test patterns

**Files to Create**:
```
test/features/hadith/
├── unit/
│   ├── hadith_repository_test.dart
│   ├── hadith_use_cases_test.dart
│   └── hadith_state_test.dart
├── widget/
│   ├── hadith_screens_test.dart
│   └── hadith_widgets_test.dart
└── integration/
    └── hadith_flow_test.dart
```

### **Phase 4: Advanced Features** (Week 5-6)
**Priority**: P2 | **Story Points**: 3pts | **Status**: 🔄 Future Enhancement

#### **HADITH-401: Enhanced Features (3pts)**
**Status**: ⏳ Future | **Assignee**: TBD | **Dependencies**: HADITH-302

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

## 🔧 **TECHNICAL REQUIREMENTS**

### **Architecture Patterns**
- **Clean Architecture**: Domain/Data/Presentation layers (follow existing patterns)
- **Riverpod State Management**: Providers, Notifiers, StateNotifiers (use existing setup)
- **Repository Pattern**: Remote/Local data sources (follow prayer_times pattern)
- **Use Case Pattern**: Business logic encapsulation (follow existing use cases)

### **Data Sources**
- **Primary**: Public JSON datasets (Bukhari, Muslim)
- **Fallback**: Local bootstrap assets in `assets/data/hadith/`
- **Caching**: Hive with 7-day TTL (use existing Hive setup)
- **Offline**: Graceful degradation (follow existing offline patterns)

### **Performance Requirements**
- **List Loading**: < 200ms first frame
- **Detail Loading**: < 800ms cached, < 1500ms network
- **Search**: < 500ms client-side
- **Offline**: 100% functionality

### **Accessibility**
- **Screen Reader**: Semantic labels
- **Text Scaling**: Responsive typography
- **Contrast**: WCAG 2.1 AA compliance
- **Navigation**: Keyboard support

---

## 📊 **ACCEPTANCE CRITERIA**

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

---

## 🚀 **IMPLEMENTATION NOTES**

### **Integration Points**
- **Existing Patterns**: Follow Quran module patterns
- **State Management**: Use existing Riverpod setup from prayer_times
- **Navigation**: Integrate with GoRouter in shell_wrapper.dart
- **Theming**: Use existing Islamic theme system from core/theme/
- **Localization**: Use existing l10n system from lib/l10n/

### **Risk Mitigation**
- **API Reliability**: Robust caching and fallbacks
- **Performance**: Pagination and lazy loading
- **Localization**: Thorough RTL testing
- **Storage**: Cache size management

### **Success Metrics**
- **Performance**: Meet loading time targets
- **Reliability**: < 0.5% crash rate
- **Adoption**: 25% of users use bookmarks
- **Quality**: 90%+ test coverage

---

## 📅 **DEVELOPMENT TIMELINE**

| Week | Phase | Focus | Deliverables |
|------|-------|-------|--------------|
| 1-2 | Phase 1 | Foundation | API, Models, Repository |
| 3-4 | Phase 2 | UI | Screens, Navigation |
| 4-5 | Phase 3 | Polish | Localization, Testing |
| 5-6 | Phase 4 | Advanced | Enhanced Features |

**Total Duration**: 6 weeks  
**Total Story Points**: 21pts  
**Team Size**: 1-2 developers  
**Risk Level**: Medium

---

## 🔄 **CURRENT SPRINT STATUS**

### **Sprint 1: Hadith Foundation** (Week 1-2)
**Goal**: Complete data layer and basic state management  
**Points**: 8/21 (38%)  
**Status**: 🔄 Ready to Start

**Tasks**:
- [ ] HADITH-101: API Integration & Data Models (3pts)
- [ ] HADITH-102: Domain Layer & Use Cases (2pts)  
- [ ] HADITH-103: State Management & Providers (3pts)

**Definition of Done**:
- [ ] All data models created and tested
- [ ] Repository layer implemented
- [ ] Basic providers working
- [ ] Unit tests passing
- [ ] Code review completed

---

## 📋 **NEXT STEPS**

1. **Start with HADITH-101**: API Integration & Data Models
   - Focus on Sahih Bukhari (7,544) and Sahih Muslim (7,452) first
   - Include Bengali translations and collection metadata
   - Follow iHadis data structure patterns

2. **Create basic data structures** following existing patterns
   - Add Bengali support in DTOs
   - Include hadith counts and collection types
   - Prepare for progressive loading

3. **Implement repository layer** with caching
   - Hive-based caching for offline access
   - Progressive collection loading
   - Bengali-first content strategy

4. **Add unit tests** for data layer
   - Test Bengali translation handling
   - Test collection metadata
   - Test offline caching

5. **Move to HADITH-102**: Domain layer implementation
   - Create entities with Bengali support
   - Implement use cases for collection browsing
   - Add search functionality

## 🎯 **INSPIRATION FROM IHADIS**

- **Bengali-First Approach**: Prioritize Bengali language and Islamic terminology
- **Clean Design**: Simple, respectful Islamic aesthetics
- **Collection Hierarchy**: Clear categorization with proper counts
- **User Experience**: Easy navigation and prominent hadith counts
- **Content Strategy**: Start with Sahih collections, expand progressively

---

*Last Updated: 29 August 2025*  
*Next Review: Weekly sprint planning*  
*File Location: docs/hadith-module/todo-hadith.md*
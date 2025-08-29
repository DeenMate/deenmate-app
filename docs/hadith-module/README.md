# Hadith Module - Complete Implementation Guide

**Last Updated**: 29 August 2025  
**Module Status**: 🔄 Ready to Start  
**Priority**: P0 (High)  
**Story Points**: 21pts total  
**Timeline**: 6 weeks

---

## 📋 **QUICK OVERVIEW**

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

## 🔍 **IHADIS.COM INSIGHTS**

### **Key Observations from [ihadis.com](https://ihadis.com/)**
- **Bengali-First Approach**: All navigation and content in Bengali
- **Global Search**: "হাদিস সার্চ করুন" with Ctrl+K shortcut
- **Quick Collection Access**: Popular collections with letter icons (B, M, N, A, T, I)
- **Featured Content**: Daily rotating hadiths from different collections
- **Topic-Based Organization**: Islamic topics (Aqeedah, Iman, Purification, Prayer, etc.)
- **Clean Design**: Islamic aesthetics with proper typography

### **Navigation Structure**
```
হোম (Home) → হাদিস গ্রন্থসমূহ (Hadith Books) → বিষয়ভিত্তিক (Topic-based)
```

### **Collection Quick Access**
```
বুখারী | মুসলিম | নাসায়ী | আবু দাউদ | তিরমিজি | ইবনে মাজাহ
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

---

## 🏗️ **ARCHITECTURE ALIGNMENT**

### **Following Quran Module Pattern**
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

---

## 🔌 **API STRATEGY**

### **Sunnah.com API (Recommended)**
**Base URL**: `https://api.sunnah.com/v1/`

**Endpoints**:
- `GET /collections` - List all Hadith collections
- `GET /collections/{collection}/books` - Get books in a collection
- `GET /collections/{collection}/books/{book}/hadiths` - Get hadiths in a book
- `GET /hadiths/{hadith_number}` - Get specific hadith details
- `GET /search` - Search across all hadiths

**Example Response**:
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

### **Hybrid Approach**
1. **Primary**: Sunnah.com API for real-time data
2. **Fallback**: Local JSON datasets for offline access
3. **Bengali**: Local Bengali translations where API doesn't provide them
4. **Caching**: Hive-based caching with 7-day TTL

---

## 🚀 **IMPLEMENTATION PLAN**

### **Phase 1: Foundation & Data Layer** (Week 1-2)
**Priority**: P0 | **Story Points**: 8pts | **Status**: 🔄 Ready to Start

#### **HADITH-101: API Integration & Data Models (3pts)**
- [ ] Create SunnahApi Service following Quran API pattern
- [ ] Implement Data Models & DTOs with Bengali support
- [ ] Create Repository Layer with caching strategy

#### **HADITH-102: Domain Layer & Use Cases (2pts)**
- [ ] Create Entities using freezed
- [ ] Implement Use Cases for all operations

#### **HADITH-103: State Management & Providers (3pts)**
- [ ] Create Riverpod Providers following Quran pattern
- [ ] Implement State Management with language reactivity

### **Phase 2: Presentation Layer** (Week 3-4)
**Priority**: P0 | **Story Points**: 6pts | **Status**: 🔄 Waiting for Phase 1

#### **HADITH-201: Core UI Screens (4pts)**
- [ ] HadithHomeScreen with Bengali-first UI
- [ ] HadithCollectionScreen with RTL support
- [ ] HadithBookScreen with responsive layout
- [ ] HadithChapterScreen with pagination
- [ ] HadithDetailScreen with Arabic text and translations

#### **HADITH-202: Navigation & Routing (2pts)**
- [ ] GoRouter Integration with deep linking
- [ ] Navigation Integration with bottom navigation

### **Phase 3: Localization & Polish** (Week 4-5)
**Priority**: P1 | **Story Points**: 4pts | **Status**: 🔄 Waiting for Phase 2

#### **HADITH-301: Multi-language Support (2pts)**
- [ ] ARB Keys for Bengali, English, Arabic
- [ ] RTL Support for Arabic content
- [ ] Language Fallback strategy

#### **HADITH-302: Testing & Quality Assurance (2pts)**
- [ ] Unit Tests for data layer
- [ ] Widget Tests for UI components
- [ ] Integration Tests for complete flows

### **Phase 4: Advanced Features** (Week 5-6)
**Priority**: P2 | **Story Points**: 3pts | **Status**: 🔄 Future Enhancement

#### **HADITH-401: Enhanced Features (3pts)**
- [ ] Advanced Search with filters
- [ ] Bookmark Management with sync
- [ ] Sharing & Export functionality

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

## 📚 **DOCUMENTATION FILES**

- **`hadith-module-specification.md`** - Complete technical specification
- **`todo-hadith.md`** - Detailed development tasks and tracking
- **`project-tracking.md`** - High-level project tracking
- **`api-strategy.md`** - Detailed API strategy and implementation

---

*Last Updated: 29 August 2025*  
*File Location: docs/hadith-module/README.md*

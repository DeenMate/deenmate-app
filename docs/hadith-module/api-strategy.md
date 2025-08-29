# Hadith Module API Strategy

**Last Updated**: 29 August 2025  
**Purpose**: Define API strategy for Hadith module implementation  
**Status**: 🔄 Planning Phase

---

## 🎯 **API STRATEGY OVERVIEW**

### **Current DeenMate API Usage**
Based on the codebase analysis, DeenMate currently uses:
- **Quran.com API v4**: For Quran text, translations, audio, and resources
- **AlAdhan API**: For prayer times calculation
- **Metals API**: For live gold/silver prices in Zakat calculator

### **Hadith API Options**

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

**Implementation**:
```
assets/data/hadith/
├── bukhari/
│   ├── index.json          # Collection metadata
│   ├── books.json          # Book structure
│   └── hadiths/
│       ├── book_1.json     # Hadiths by book
│       └── book_2.json
├── muslim/
│   └── ...
└── translations/
    ├── bn_bukhari.json     # Bengali translations
    └── bn_muslim.json
```

#### **Option 3: Hybrid Approach (Recommended)**
**Status**: ✅ **RECOMMENDED** - Best of both worlds

**Strategy**:
1. **Primary**: Sunnah.com API for real-time data
2. **Fallback**: Local JSON datasets for offline access
3. **Bengali**: Local Bengali translations where API doesn't provide them
4. **Caching**: Hive-based caching with 7-day TTL

---

## 🔧 **IMPLEMENTATION PLAN**

### **Phase 1: Sunnah.com API Integration (Week 1)**
**Priority**: P0 - Primary API implementation

**Tasks**:
- [ ] **API Client Setup**
  - [ ] Create `SunnahApi` class using existing `DioClient` pattern
  - [ ] Add base URL: `https://api.sunnah.com/v1/`
  - [ ] Implement error handling with `Failure` types
  - [ ] Add retry logic and timeout handling

- [ ] **Core Endpoints**
  - [ ] `/collections` - Get all available collections
  - [ ] `/collections/{collection}/books` - Get books in collection
  - [ ] `/collections/{collection}/books/{book}/hadiths` - Get hadiths
  - [ ] `/hadiths/{hadith_number}` - Get specific hadith

- [ ] **Data Mapping**
  - [ ] Map Sunnah.com response to our DTOs
  - [ ] Handle Arabic text with proper encoding
  - [ ] Extract metadata (reference, grade, narrator)
  - [ ] Support multiple translations

**Files to Create**:
```dart
// lib/features/hadith/data/api/sunnah_api.dart
class SunnahApi {
  final Dio _dio;
  
  Future<List<HadithCollectionDto>> getCollections();
  Future<List<HadithBookDto>> getBooks(String collection);
  Future<List<HadithDto>> getHadiths(String collection, int book);
  Future<HadithDto> getHadith(String hadithNumber);
}
```

### **Phase 2: Local Fallback System (Week 2)**
**Priority**: P1 - Offline support

**Tasks**:
- [ ] **Local Data Structure**
  - [ ] Create JSON schema for local datasets
  - [ ] Prepare sample data for Bukhari and Muslim
  - [ ] Include Bengali translations where available
  - [ ] Add collection metadata and book structure

- [ ] **Fallback Logic**
  - [ ] Implement `HadithLocalDataSource`
  - [ ] Add offline detection and fallback
  - [ ] Cache API responses locally
  - [ ] Sync local data with API data

- [ ] **Bengali Translations**
  - [ ] Source Bengali translations for Sahih collections
  - [ ] Create translation mapping system
  - [ ] Merge Bengali translations with API data
  - [ ] Handle missing translations gracefully

### **Phase 3: Hybrid Integration (Week 3)**
**Priority**: P1 - Complete system

**Tasks**:
- [ ] **Repository Layer**
  - [ ] Implement `HadithRepository` with both sources
  - [ ] Add intelligent source selection
  - [ ] Implement caching strategy
  - [ ] Add data synchronization

- [ ] **Error Handling**
  - [ ] Handle API failures gracefully
  - [ ] Implement offline fallback
  - [ ] Add user-friendly error messages
  - [ ] Log API usage and errors

---

## 📊 **API RESPONSE MAPPING**

### **Sunnah.com API Response to Our DTOs**

```dart
// Sunnah.com API Response
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

// Our HadithDTO
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

### **Collection Metadata**
```dart
// Sunnah.com Collections Response
[
  {
    "name": "bukhari",
    "title": "Sahih al-Bukhari",
    "hadithCount": 7563
  }
]

// Our HadithCollectionDTO
class HadithCollectionDTO {
  final String id;           // "bukhari"
  final String name;         // "Sahih al-Bukhari"
  final String bengaliName;  // "সহিহ বুখারী" (from local data)
  final String arabicName;   // "صحيح البخاري"
  final int hadithCount;     // 7563
  final String type;         // "Sahih"
}
```

---

## 🔄 **CACHING STRATEGY**

### **Hive Cache Structure**
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

### **Cache Implementation**
```dart
class HadithCacheService {
  Future<void> cacheCollections(List<HadithCollectionDto> collections);
  Future<List<HadithCollectionDto>?> getCachedCollections();
  Future<void> cacheHadiths(String collection, int book, List<HadithDto> hadiths);
  Future<List<HadithDto>?> getCachedHadiths(String collection, int book);
  Future<void> clearExpiredCache();
}
```

---

## 🎯 **SUCCESS METRICS**

### **API Performance**
- **Response Time**: < 500ms for collection lists, < 1000ms for hadith details
- **Uptime**: > 99% API availability
- **Cache Hit Rate**: > 80% for frequently accessed data
- **Offline Functionality**: 100% for cached collections

### **User Experience**
- **Seamless Switching**: Users don't notice API vs local data
- **Fast Loading**: < 200ms for cached data
- **Reliable**: No data loss during API failures
- **Bengali Support**: Complete Bengali translations for core collections

---

## ⚠️ **RISKS & MITIGATION**

### **API Risks**
- **Rate Limiting**: Implement request throttling and caching
- **API Changes**: Version API endpoints and add backward compatibility
- **Service Outages**: Robust offline fallback system
- **Data Quality**: Validate API responses and add data cleaning

### **Local Data Risks**
- **Storage Size**: Implement data compression and cleanup
- **Data Sync**: Version control for local datasets
- **Translation Quality**: Source authentic Bengali translations
- **Maintenance**: Regular updates for new collections

---

## 📋 **NEXT STEPS**

1. **Immediate** (This Week):
   - [ ] Set up Sunnah.com API client
   - [ ] Test API endpoints and response mapping
   - [ ] Create basic DTOs for API responses
   - [ ] Implement error handling

2. **Next Week**:
   - [ ] Create local fallback system
   - [ ] Source Bengali translations
   - [ ] Implement caching strategy
   - [ ] Add offline detection

3. **Following Week**:
   - [ ] Complete hybrid integration
   - [ ] Add comprehensive error handling
   - [ ] Test offline functionality
   - [ ] Performance optimization

---

*Last Updated: 29 August 2025*  
*File Location: docs/hadith-module/api-strategy.md*

# Quran Module - API Strategy & Integration Guide

*Last Updated: 2025-09-03*  
*Module Location: `lib/features/quran/`*

This document outlines the API integration strategy, caching policies, and data flow architecture for the Quran module.

---

## 📡 Current API Integration

### Primary API Source: Quran.com API v4
- **Base URL**: `https://api.quran.com/api/v4`
- **Documentation**: https://api.docs.quran.com/
- **Authentication**: Currently bypassed for development (consider API key for production)
- **Rate Limiting**: Not currently implemented (should add for production)

### Key Endpoints Used

| Endpoint | Purpose | Cache TTL | Fallback Strategy |
|----------|---------|-----------|-------------------|
| `GET /chapters` | Chapter/Surah metadata | 7 days | Static list of 114 chapters |
| `GET /chapters/{id}/verses` | Paginated verses with translations | 24 hours | Cached verses, offline content |
| `GET /resources/translations` | Available translation resources | 3 days | Hardcoded popular translations |
| `GET /resources/recitations` | Available reciters | 3 days | Default reciter list |
| `GET /resources/tafsirs` | Commentary resources | 7 days | Popular tafsir list |
| `GET /tafsirs/{id}/by_ayah/{verse}` | Verse commentary | 30 days | None (feature disabled) |

### API Response Quality Assessment

✅ **Reliable Endpoints**:
- `/chapters` - Consistent, rarely changes
- `/chapters/{id}/verses` - Stable pagination, good caching
- `/resources/translations` - Large dataset, stable structure

⚠️ **Areas of Concern**:
- **Recitation Resources**: Some reciters marked as unavailable intermittently
- **Audio URLs**: URL construction inconsistent between endpoints  
- **Tafsir Availability**: Limited coverage for non-Arabic tafsirs
- **Rate Limiting**: No current protection against API abuse

---

## 🗄️ Caching Strategy

### Hive Box Structure
```dart
// Box: 'chapters' - TTL: 7 days
{
  'chapters': List<ChapterDto> // All 114 chapters
}

// Box: 'verses' - TTL: 24 hours  
{
  'chapter_{id}_page_{page}_trans_{ids}_rec_{id}': VersesPageDto,
  'tafsir_{resourceId}_{verseKey}': TafsirDto
}

// Box: 'resources' - TTL: 3 days
{
  'translation_resources': List<TranslationResourceDto>,
  'recitations': List<RecitationResourceDto>, // FIXED: Now stores full DTO
  'tafsir_resources': List<TafsirResourceDto>
}
```

### Cache Invalidation Rules
1. **Manual Refresh**: User can trigger refresh via pull-to-refresh
2. **Automatic Refresh**: Background refresh every 24 hours for active content
3. **Failure Fallback**: Always serve cached content if API fails
4. **Storage Cleanup**: Remove unused cached pages after 7 days

### Optimizations Implemented
- **Pagination**: Verses loaded in chunks of 20 per page
- **Selective Refresh**: Only refresh specific content types when needed
- **Background Caching**: Pre-load popular content during idle time
- **Compression**: Store JSON strings for large datasets

---

## 📱 Offline Content Strategy

### Essential Content Download
Triggered automatically on first app launch:

```dart
// Essential chapters for offline reading
final essentialChapters = [
  1,   // Al-Fatiha (The Opening)
  18,  // Al-Kahf (The Cave) - Friday reading
  36,  // Yasin (Heart of Quran)  
  55,  // Ar-Rahman (The Beneficent)
  67,  // Al-Mulk (The Dominion)
  112, // Al-Ikhlas (The Sincerity)
  113, // Al-Falaq (The Daybreak)
  114, // An-Nas (Mankind)
];
```

**Download Policy**:
- **Text Only**: No audio included in essential download
- **Single Translation**: Saheeh International (ID: 131) as default
- **Progressive**: Al-Baqarah limited to first 3 pages (size management)
- **Constraints**: WiFi-only by default, respect user data preferences

### Content Prioritization
1. **Tier 1**: Essential chapters + 1 translation (Auto-download)
2. **Tier 2**: Popular chapters + multiple translations (User-initiated)  
3. **Tier 3**: Complete Quran + tafsir (Manual selection)
4. **Tier 4**: Audio content (Explicit user choice only)

---

## 🎵 Audio Integration

### Audio URL Construction
Current pattern varies by endpoint - needs standardization:

```dart
// Primary pattern (most reliable):
'https://audio.qurancdn.com/{recitationId}/{verseKey}.mp3'

// Fallback patterns:
'https://audio.qurancdn.com/{recitationId}/{chapterId}_{verseNumber}.mp3'
'https://verses.quran.com/{recitationId}/{verseKey}.mp3'
```

### Audio Download Strategy
- **Per-Surah Downloads**: Complete chapter audio as single operation
- **Progress Tracking**: Verse-by-verse progress with resume capability
- **Storage Organization**: `{appDocuments}/quran_audio/reciter_{id}/chapter_{id}/`
- **Quality Options**: Default to 64kbps for bandwidth efficiency

### Download Triggers
1. **User Explicit Choice**: Via download prompt when playing unavailable audio
2. **Bulk Downloads**: Via Audio Downloads screen for popular/all content
3. **Never Silent**: No automatic audio downloads without user consent

---

## 🔄 Error Handling & Resilience

### Network Error Patterns
```dart
// Repository error handling strategy
try {
  final fresh = await _api.getResource();
  await _cache.store(fresh);
  return fresh;
} catch (e) {
  final cached = await _cache.get();
  if (cached != null) {
    // Serve stale content with warning
    return cached;
  }
  // Only fail if no cached fallback exists
  throw ServiceException('Content unavailable', originalError: e);
}
```

### Retry Policies
- **Transient Errors**: Exponential backoff (1s, 2s, 4s) up to 3 retries
- **Rate Limiting**: Respect 429 responses with backoff
- **Network Timeout**: 15 seconds for API calls, 60 seconds for downloads
- **User Guidance**: Clear error messages with actionable next steps

---

## 🚀 Performance Optimizations

### Current Optimizations
1. **Dio Interceptors**: Request/response logging in debug mode
2. **Connection Pooling**: Reuse HTTP connections for multiple requests
3. **JSON Streaming**: Large responses processed incrementally
4. **Image Caching**: Chapter thumbnails cached separately

### Planned Improvements
1. **Request Deduplication**: Prevent multiple identical API calls
2. **Prefetching**: Load next chapter content based on reading patterns
3. **Delta Updates**: Only download changed translations/tafsirs
4. **CDN Integration**: Utilize Quran.com CDN for faster asset delivery

---

## 🔒 Security & Privacy

### Current Measures
- **HTTPS Only**: All API communication encrypted
- **No Personal Data**: No user information sent to external APIs
- **Local Storage**: All user preferences stored locally via Hive

### Production Recommendations
1. **API Key Integration**: Register for official Quran.com API key
2. **Certificate Pinning**: Pin Quran.com SSL certificates
3. **Request Signing**: Implement request signatures for sensitive operations
4. **Privacy Compliance**: Document what data (if any) is transmitted

---

## 📊 Monitoring & Analytics

### Metrics to Track
- **API Response Times**: Monitor endpoint performance
- **Cache Hit Rates**: Measure offline capability effectiveness  
- **Download Success Rates**: Track audio/content download reliability
- **Error Frequencies**: Identify common failure patterns

### Health Checks
```dart
// Implement API health monitoring
class QuranApiHealthMonitor {
  Future<bool> checkApiHealth() async {
    try {
      final chapters = await _api.getChapters();
      return chapters.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
```

---

## 🎯 Future API Strategy

### Potential Improvements
1. **Multi-Source Support**: Integrate additional Quran APIs for redundancy
2. **GraphQL Migration**: Consider GraphQL for more efficient data fetching
3. **WebSocket Integration**: Real-time updates for community features
4. **Progressive Web App**: API-first design for cross-platform consistency

### Migration Considerations
- **Backwards Compatibility**: Maintain current API contracts during transitions
- **Feature Flags**: Use feature toggles for testing new API integrations
- **A/B Testing**: Compare API performance across different endpoints
- **Rollback Strategy**: Quick revert capability if new APIs fail

---

## 📋 Testing Strategy

### API Integration Tests
```dart
// Example integration test structure
group('Quran API Integration', () {
  test('should load chapters with proper caching', () async {
    // Test both API and cache scenarios
  });
  
  test('should handle network failures gracefully', () async {
    // Test offline behavior
  });
  
  test('should respect rate limiting', () async {
    // Test API abuse protection
  });
});
```

### Mock Strategy for Development
- **Local JSON Files**: Static responses for common endpoints
- **Network Simulation**: Simulate slow/failed connections
- **Cache Testing**: Verify cache hit/miss scenarios
- **Offline Testing**: Ensure full functionality without network

---

*This API strategy evolves based on usage patterns and API provider changes. Regular reviews recommended every 3 months.*

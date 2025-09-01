import '../../domain/entities/hadith_simple.dart';

/// Local Data Source Interface for Hadith caching
/// Uses Hive for local storage following our documented strategy
abstract class HadithLocalDataSource {
  /// Cache Hadith locally
  Future<void> cacheHadith(Hadith hadith);

  /// Get cached Hadith
  Future<Hadith?> getCachedHadith(String hadithId);

  /// Check if Hadith is cached
  Future<bool> isHadithCached(String hadithId);

  /// Cache multiple Hadiths
  Future<void> cacheHadiths(List<Hadith> hadiths);

  /// Get all cached Hadiths
  Future<List<Hadith>> getAllCachedHadiths();

  /// Cache Hadith collection
  Future<void> cacheCollection(HadithCollection collection);

  /// Get cached collection
  Future<HadithCollection?> getCachedCollection(String collectionId);

  /// Cache search results
  Future<void> cacheSearchResults(String query, HadithSearchResult results);

  /// Get cached search results
  Future<HadithSearchResult?> getCachedSearchResults(String query);

  /// Update Hadith bookmark status
  Future<void> updateBookmarkStatus(String hadithId, bool isBookmarked);

  /// Get bookmarked Hadiths
  Future<List<Hadith>> getBookmarkedHadiths();

  /// Update Hadith read stats
  Future<void> updateReadStats(
      String hadithId, DateTime lastReadAt, int readCount);

  /// Get recently read Hadiths
  Future<List<Hadith>> getRecentlyReadHadiths({int limit = 10});

  /// Get popular Hadiths (based on read count)
  Future<List<Hadith>> getPopularHadiths({int limit = 10});

  /// Clear all cached data
  Future<void> clearAllCache();

  /// Clear expired cache entries
  Future<void> clearExpiredCache();

  /// Get cache statistics
  Future<Map<String, dynamic>> getCacheStats();

  /// Get cache size in bytes
  Future<int> getCacheSize();

  /// Check if cache is available
  Future<bool> isCacheAvailable();
}

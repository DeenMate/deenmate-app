import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/entities/hadith_simple.dart';
import 'hadith_local_data_source.dart';

/// Implementation of Hadith Local Data Source
/// Uses Hive for local caching following our documented strategy
class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  static const String _hadithBoxName = 'hadiths';
  static const String _collectionBoxName = 'collections';
  static const String _searchBoxName = 'search_results';
  static const String _bookmarksBoxName = 'bookmarks';
  static const String _readStatsBoxName = 'read_stats';

  late Box<Map> _hadithBox;
  late Box<Map> _collectionBox;
  late Box<Map> _searchBox;
  late Box<String> _bookmarksBox;
  late Box<Map> _readStatsBox;

  /// Initialize Hive boxes
  Future<void> initialize() async {
    _hadithBox = await Hive.openBox<Map>(_hadithBoxName);
    _collectionBox = await Hive.openBox<Map>(_collectionBoxName);
    _searchBox = await Hive.openBox<Map>(_searchBoxName);
    _bookmarksBox = await Hive.openBox<String>(_bookmarksBoxName);
    _readStatsBox = await Hive.openBox<Map>(_readStatsBoxName);
  }

  @override
  Future<void> cacheHadith(Hadith hadith) async {
    await _hadithBox.put(hadith.id, hadith.toJson());
  }

  @override
  Future<Hadith?> getCachedHadith(String hadithId) async {
    final data = _hadithBox.get(hadithId);
    if (data != null) {
      return Hadith.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  @override
  Future<bool> isHadithCached(String hadithId) async {
    return _hadithBox.containsKey(hadithId);
  }

  @override
  Future<void> cacheHadiths(List<Hadith> hadiths) async {
    final batch = _hadithBox.toMap();
    for (final hadith in hadiths) {
      batch[hadith.id] = hadith.toJson();
    }
    await _hadithBox.putAll(batch);
  }

  @override
  Future<List<Hadith>> getAllCachedHadiths() async {
    final hadiths = <Hadith>[];
    for (final key in _hadithBox.keys) {
      try {
        final data = _hadithBox.get(key);
        if (data != null) {
          final hadith = Hadith.fromJson(Map<String, dynamic>.from(data));
          hadiths.add(hadith);
        }
      } catch (e) {
        // Skip corrupted entries
        continue;
      }
    }
    return hadiths;
  }

  @override
  Future<void> cacheCollection(HadithCollection collection) async {
    await _collectionBox.put(collection.id, collection.toJson());
  }

  @override
  Future<HadithCollection?> getCachedCollection(String collectionId) async {
    final data = _collectionBox.get(collectionId);
    if (data != null) {
      return HadithCollection.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  @override
  Future<void> cacheSearchResults(
      String query, HadithSearchResult results) async {
    final key = _generateSearchKey(query);
    await _searchBox.put(key, {
      'query': query,
      'results': results.toJson(),
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<HadithSearchResult?> getCachedSearchResults(String query) async {
    final key = _generateSearchKey(query);
    final data = _searchBox.get(key);
    if (data != null) {
      final timestamp = DateTime.parse(data['timestamp'] as String);
      final now = DateTime.now();

      // Cache expires after 1 hour
      if (now.difference(timestamp).inHours < 1) {
        final resultsData = data['results'] as Map<String, dynamic>;
        return HadithSearchResult.fromJson(resultsData);
      } else {
        // Remove expired cache
        await _searchBox.delete(key);
      }
    }
    return null;
  }

  @override
  Future<void> updateBookmarkStatus(String hadithId, bool isBookmarked) async {
    if (isBookmarked) {
      await _bookmarksBox.put(hadithId, hadithId);
    } else {
      await _bookmarksBox.delete(hadithId);
    }
  }

  @override
  Future<List<Hadith>> getBookmarkedHadiths() async {
    final bookmarkedIds = _bookmarksBox.values.toSet();
    final hadiths = <Hadith>[];

    for (final hadithId in bookmarkedIds) {
      final hadith = await getCachedHadith(hadithId);
      if (hadith != null) {
        hadiths.add(hadith.copyWith(isBookmarked: true));
      }
    }

    return hadiths;
  }

  @override
  Future<void> updateReadStats(
      String hadithId, DateTime lastReadAt, int readCount) async {
    await _readStatsBox.put(hadithId, {
      'last_read_at': lastReadAt.toIso8601String(),
      'read_count': readCount,
    });
  }

  @override
  Future<List<Hadith>> getRecentlyReadHadiths({int limit = 10}) async {
    final allHadiths = await getAllCachedHadiths();
    final hadithsWithStats = <MapEntry<Hadith, DateTime>>[];

    for (final hadith in allHadiths) {
      final stats = _readStatsBox.get(hadith.id);
      if (stats != null) {
        final lastReadAt = DateTime.parse(stats['last_read_at'] as String);
        hadithsWithStats.add(MapEntry(hadith, lastReadAt));
      }
    }

    // Sort by last read time (most recent first)
    hadithsWithStats.sort((a, b) => b.value.compareTo(a.value));

    return hadithsWithStats.take(limit).map((entry) => entry.key).toList();
  }

  @override
  Future<List<Hadith>> getPopularHadiths({int limit = 10}) async {
    final allHadiths = await getAllCachedHadiths();
    final hadithsWithStats = <MapEntry<Hadith, int>>[];

    for (final hadith in allHadiths) {
      final stats = _readStatsBox.get(hadith.id);
      if (stats != null) {
        final readCount = stats['read_count'] as int? ?? 0;
        hadithsWithStats.add(MapEntry(hadith, readCount));
      }
    }

    // Sort by read count (highest first)
    hadithsWithStats.sort((a, b) => b.value.compareTo(a.value));

    return hadithsWithStats.take(limit).map((entry) => entry.key).toList();
  }

  @override
  Future<void> clearAllCache() async {
    await _hadithBox.clear();
    await _collectionBox.clear();
    await _searchBox.clear();
    await _bookmarksBox.clear();
    await _readStatsBox.clear();
  }

  @override
  Future<void> clearExpiredCache() async {
    final now = DateTime.now();
    final keysToDelete = <String>[];

    // Clear expired search results
    for (final key in _searchBox.keys) {
      final data = _searchBox.get(key);
      if (data != null) {
        final timestamp = DateTime.parse(data['timestamp'] as String);
        if (now.difference(timestamp).inHours >= 1) {
          keysToDelete.add(key);
        }
      }
    }

    for (final key in keysToDelete) {
      await _searchBox.delete(key);
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    return {
      'hadiths_count': _hadithBox.length,
      'collections_count': _collectionBox.length,
      'search_results_count': _searchBox.length,
      'bookmarks_count': _bookmarksBox.length,
      'read_stats_count': _readStatsBox.length,
      'total_size_bytes': await getCacheSize(),
      'last_updated': DateTime.now().toIso8601String(),
    };
  }

  @override
  Future<int> getCacheSize() async {
    int totalSize = 0;

    // Calculate size of all boxes
    totalSize += _hadithBox.length * 1024; // Approximate size per hadith
    totalSize += _collectionBox.length * 512; // Approximate size per collection
    totalSize += _searchBox.length * 2048; // Approximate size per search result
    totalSize += _bookmarksBox.length * 64; // Approximate size per bookmark
    totalSize += _readStatsBox.length * 128; // Approximate size per read stat

    return totalSize;
  }

  @override
  Future<bool> isCacheAvailable() async {
    try {
      return _hadithBox.isOpen &&
          _collectionBox.isOpen &&
          _searchBox.isOpen &&
          _bookmarksBox.isOpen &&
          _readStatsBox.isOpen;
    } catch (e) {
      return false;
    }
  }

  /// Generate a unique key for search results
  String _generateSearchKey(String query) {
    return 'search_${query.toLowerCase().replaceAll(RegExp(r'\s+'), '_')}';
  }

  /// Close all Hive boxes
  Future<void> close() async {
    await _hadithBox.close();
    await _collectionBox.close();
    await _searchBox.close();
    await _bookmarksBox.close();
    await _readStatsBox.close();
  }
}

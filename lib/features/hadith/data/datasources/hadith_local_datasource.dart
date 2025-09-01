import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/collection_dto.dart';
import '../models/book_dto.dart';
import '../models/chapter_dto.dart';
import '../models/hadith_dto.dart';

/// Local data source for Hadith data
/// Handles caching and local storage using Hive
abstract class HadithLocalDataSource {
  // Collections
  Future<List<CollectionDto>> getCachedCollections();
  Future<void> cacheCollections(List<CollectionDto> collections);

  // Books
  Future<List<BookDto>> getCachedBooks(String collectionId);
  Future<void> cacheBooks(String collectionId, List<BookDto> books);

  // Chapters
  Future<List<ChapterDto>> getCachedChapters(
      String collectionId, String bookId);
  Future<void> cacheChapters(
      String collectionId, String bookId, List<ChapterDto> chapters);

  // Hadiths
  Future<List<HadithDto>> getCachedHadiths(
      String collectionId, String bookId, String chapterId);
  Future<void> cacheHadiths(String collectionId, String bookId,
      String chapterId, List<HadithDto> hadiths);
  Future<HadithDto?> getCachedHadith(String collectionId, String hadithId);
  Future<void> cacheHadith(
      String collectionId, String hadithId, HadithDto hadith);

  // Search
  Future<List<HadithDto>> getCachedSearchResults(String query,
      {String? collectionId});
  Future<void> cacheSearchResults(String query,
      {String? collectionId, required List<HadithDto> results});

  // Topics
  Future<List<String>> getCachedTopics();
  Future<void> cacheTopics(List<String> topics);
  Future<List<HadithDto>> getCachedHadithsByTopic(String topic);
  Future<void> cacheHadithsByTopic(String topic, List<HadithDto> hadiths);

  // Cache management
  Future<void> clearCache();
  Future<void> clearExpiredCache();
  Future<Map<String, dynamic>> getCacheStats();
  Future<bool> isCacheValid(String key);
}

/// Implementation of local data source using Hive
class HadithLocalDataSourceImpl implements HadithLocalDataSource {
  static const String _collectionsBox = 'hadith_collections';
  static const String _booksBox = 'hadith_books';
  static const String _chaptersBox = 'hadith_chapters';
  static const String _hadithsBox = 'hadith_hadiths';
  static const String _searchBox = 'hadith_search';
  static const String _topicsBox = 'hadith_topics';

  static const Duration _cacheTtl = Duration(days: 7);

  @override
  Future<List<CollectionDto>> getCachedCollections() async {
    try {
      final box = await Hive.openBox<CollectionDto>(_collectionsBox);
      final collections = box.values.toList();

      // Filter out expired cache
      final validCollections = collections
          .where((collection) => _isCacheValid('collections_${collection.id}'))
          .toList();

      return validCollections;
    } catch (e) {
      throw CacheException('Failed to get cached collections: $e');
    }
  }

  @override
  Future<void> cacheCollections(List<CollectionDto> collections) async {
    try {
      final box = await Hive.openBox<CollectionDto>(_collectionsBox);
      await box.clear();

      for (final collection in collections) {
        await box.put(collection.id, collection);
        await _setCacheTimestamp('collections_${collection.id}');
      }
    } catch (e) {
      throw CacheException('Failed to cache collections: $e');
    }
  }

  @override
  Future<List<BookDto>> getCachedBooks(String collectionId) async {
    try {
      final box = await Hive.openBox<BookDto>(_booksBox);
      final books = box.values
          .where((book) =>
              book.collectionId == collectionId &&
              _isCacheValid('books_${collectionId}_${book.id}'))
          .toList();

      return books;
    } catch (e) {
      throw CacheException('Failed to get cached books: $e');
    }
  }

  @override
  Future<void> cacheBooks(String collectionId, List<BookDto> books) async {
    try {
      final box = await Hive.openBox<BookDto>(_booksBox);

      // Remove old books for this collection
      final existingBooks = box.values
          .where((book) => book.collectionId == collectionId)
          .toList();
      for (final book in existingBooks) {
        await box.delete(book.id);
      }

      // Add new books
      for (final book in books) {
        await box.put(book.id, book);
        await _setCacheTimestamp('books_${collectionId}_${book.id}');
      }
    } catch (e) {
      throw CacheException('Failed to cache books: $e');
    }
  }

  @override
  Future<List<ChapterDto>> getCachedChapters(
      String collectionId, String bookId) async {
    try {
      final box = await Hive.openBox<ChapterDto>(_chaptersBox);
      final chapters = box.values
          .where((chapter) =>
              chapter.collectionId == collectionId &&
              chapter.bookId == bookId &&
              _isCacheValid('chapters_${collectionId}_${bookId}_${chapter.id}'))
          .toList();

      return chapters;
    } catch (e) {
      throw CacheException('Failed to get cached chapters: $e');
    }
  }

  @override
  Future<void> cacheChapters(
      String collectionId, String bookId, List<ChapterDto> chapters) async {
    try {
      final box = await Hive.openBox<ChapterDto>(_chaptersBox);

      // Remove old chapters for this book
      final existingChapters = box.values
          .where((chapter) =>
              chapter.collectionId == collectionId && chapter.bookId == bookId)
          .toList();
      for (final chapter in existingChapters) {
        await box.delete(chapter.id);
      }

      // Add new chapters
      for (final chapter in chapters) {
        await box.put(chapter.id, chapter);
        await _setCacheTimestamp(
            'chapters_${collectionId}_${bookId}_${chapter.id}');
      }
    } catch (e) {
      throw CacheException('Failed to cache chapters: $e');
    }
  }

  @override
  Future<List<HadithDto>> getCachedHadiths(
      String collectionId, String bookId, String chapterId) async {
    try {
      final box = await Hive.openBox<HadithDto>(_hadithsBox);
      final hadiths = box.values
          .where((hadith) =>
              hadith.collectionId == collectionId &&
              hadith.bookId == bookId &&
              hadith.chapterId == chapterId &&
              _isCacheValid(
                  'hadiths_${collectionId}_${bookId}_${chapterId}_${hadith.id}'))
          .toList();

      return hadiths;
    } catch (e) {
      throw CacheException('Failed to get cached hadiths: $e');
    }
  }

  @override
  Future<void> cacheHadiths(String collectionId, String bookId,
      String chapterId, List<HadithDto> hadiths) async {
    try {
      final box = await Hive.openBox<HadithDto>(_hadithsBox);

      // Remove old hadiths for this chapter
      final existingHadiths = box.values
          .where((hadith) =>
              hadith.collectionId == collectionId &&
              hadith.bookId == bookId &&
              hadith.chapterId == chapterId)
          .toList();
      for (final hadith in existingHadiths) {
        await box.delete(hadith.id);
      }

      // Add new hadiths
      for (final hadith in hadiths) {
        await box.put(hadith.id, hadith);
        await _setCacheTimestamp(
            'hadiths_${collectionId}_${bookId}_${chapterId}_${hadith.id}');
      }
    } catch (e) {
      throw CacheException('Failed to cache hadiths: $e');
    }
  }

  @override
  Future<HadithDto?> getCachedHadith(
      String collectionId, String hadithId) async {
    try {
      final box = await Hive.openBox<HadithDto>(_hadithsBox);
      final hadith = box.get(hadithId);

      if (hadith != null &&
          _isCacheValid('hadith_${collectionId}_${hadithId}')) {
        return hadith;
      }

      return null;
    } catch (e) {
      throw CacheException('Failed to get cached hadith: $e');
    }
  }

  @override
  Future<void> cacheHadith(
      String collectionId, String hadithId, HadithDto hadith) async {
    try {
      final box = await Hive.openBox<HadithDto>(_hadithsBox);
      await box.put(hadithId, hadith);
      await _setCacheTimestamp('hadith_${collectionId}_${hadithId}');
    } catch (e) {
      throw CacheException('Failed to cache hadith: $e');
    }
  }

  @override
  Future<List<HadithDto>> getCachedSearchResults(String query,
      {String? collectionId}) async {
    try {
      final box = await Hive.openBox<List<HadithDto>>(_searchBox);
      final key = collectionId != null ? '${query}_$collectionId' : query;

      if (_isCacheValid('search_$key')) {
        final results = box.get(key);
        return results ?? [];
      }

      return [];
    } catch (e) {
      throw CacheException('Failed to get cached search results: $e');
    }
  }

  @override
  Future<void> cacheSearchResults(String query,
      {String? collectionId, required List<HadithDto> results}) async {
    try {
      final box = await Hive.openBox<List<HadithDto>>(_searchBox);
      final key = collectionId != null ? '${query}_$collectionId' : query;

      await box.put(key, results);
      await _setCacheTimestamp('search_$key');
    } catch (e) {
      throw CacheException('Failed to cache search results: $e');
    }
  }

  @override
  Future<List<String>> getCachedTopics() async {
    try {
      final box = await Hive.openBox<String>(_topicsBox);

      if (_isCacheValid('topics')) {
        return box.values.toList();
      }

      return [];
    } catch (e) {
      throw CacheException('Failed to get cached topics: $e');
    }
  }

  @override
  Future<void> cacheTopics(List<String> topics) async {
    try {
      final box = await Hive.openBox<String>(_topicsBox);
      await box.clear();

      for (final topic in topics) {
        await box.add(topic);
      }
      await _setCacheTimestamp('topics');
    } catch (e) {
      throw CacheException('Failed to cache topics: $e');
    }
  }

  @override
  Future<List<HadithDto>> getCachedHadithsByTopic(String topic) async {
    try {
      final box = await Hive.openBox<List<HadithDto>>('hadith_topic_hadiths');

      if (_isCacheValid('topic_hadiths_$topic')) {
        final hadiths = box.get('topic_$topic');
        return hadiths ?? [];
      }

      return [];
    } catch (e) {
      throw CacheException('Failed to get cached hadiths by topic: $e');
    }
  }

  @override
  Future<void> cacheHadithsByTopic(
      String topic, List<HadithDto> hadiths) async {
    try {
      final box = await Hive.openBox<List<HadithDto>>('hadith_topic_hadiths');
      await box.put('topic_$topic', hadiths);
      await _setCacheTimestamp('topic_hadiths_$topic');
    } catch (e) {
      throw CacheException('Failed to cache hadiths by topic: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await Hive.deleteBoxFromDisk(_collectionsBox);
      await Hive.deleteBoxFromDisk(_booksBox);
      await Hive.deleteBoxFromDisk(_chaptersBox);
      await Hive.deleteBoxFromDisk(_hadithsBox);
      await Hive.deleteBoxFromDisk(_searchBox);
      await Hive.deleteBoxFromDisk(_topicsBox);
    } catch (e) {
      throw CacheException('Failed to clear cache: $e');
    }
  }

  @override
  Future<void> clearExpiredCache() async {
    try {
      // This would iterate through all cached items and remove expired ones
      // Implementation depends on how we store cache timestamps
      // For now, we'll rely on the TTL check in get methods
    } catch (e) {
      throw CacheException('Failed to clear expired cache: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final collectionsBox = await Hive.openBox<CollectionDto>(_collectionsBox);
      final booksBox = await Hive.openBox<BookDto>(_booksBox);
      final chaptersBox = await Hive.openBox<ChapterDto>(_chaptersBox);
      final hadithsBox = await Hive.openBox<HadithDto>(_hadithsBox);
      final searchBox = await Hive.openBox<HadithDto>(_searchBox);
      final topicsBox = await Hive.openBox<String>(_topicsBox);

      return {
        'collections': collectionsBox.length,
        'books': booksBox.length,
        'chapters': chaptersBox.length,
        'hadiths': hadithsBox.length,
        'search_results': searchBox.length,
        'topics': topicsBox.length,
      };
    } catch (e) {
      throw CacheException('Failed to get cache stats: $e');
    }
  }

  @override
  Future<bool> isCacheValid(String key) async {
    return _isCacheValid(key);
  }

  // Helper methods for cache timestamp management
  Future<void> _setCacheTimestamp(String key) async {
    try {
      final timestampBox = await Hive.openBox<int>('hadith_cache_timestamps');
      await timestampBox.put(key, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // Ignore timestamp errors, cache will be considered invalid
    }
  }

  bool _isCacheValid(String key) {
    try {
      final timestampBox = Hive.box<int>('hadith_cache_timestamps');
      final timestamp = timestampBox.get(key);

      if (timestamp == null) return false;

      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();

      return now.difference(cacheTime) < _cacheTtl;
    } catch (e) {
      return false;
    }
  }
}

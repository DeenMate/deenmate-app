import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/hadith_simple.dart';

/// Hadith Repository Interface
/// Defines the contract for Hadith data operations
abstract class HadithRepository {
  /// Get all available Hadith collections
  Future<Either<Failure, List<HadithCollection>>> getCollections();

  /// Get Hadiths by collection
  Future<Either<Failure, List<Hadith>>> getHadithsByCollection(
      String collectionId,
      {int page = 1,
      int limit = 20});

  /// Get Hadith by ID
  Future<Either<Failure, Hadith?>> getHadithById(
      String collectionId, String hadithId);

  /// Search Hadiths with Bengali-first approach
  Future<Either<Failure, List<Hadith>>> searchHadiths(
    String query, {
    String? collectionId,
    int page = 1,
    int limit = 20,
  });

  /// Get Hadiths by topic
  Future<Either<Failure, List<Hadith>>> getHadithsByTopic(String topic,
      {int page = 1, int limit = 20});

  /// Get popular Hadiths
  Future<Either<Failure, List<Hadith>>> getPopularHadiths({int limit = 10});

  /// Get recently read Hadiths
  Future<Either<Failure, List<Hadith>>> getRecentlyReadHadiths(
      {int limit = 10});

  /// Get bookmarked Hadiths
  Future<Either<Failure, List<Hadith>>> getBookmarkedHadiths({int limit = 10});

  /// Bookmark/Unbookmark a Hadith
  Future<Either<Failure, bool>> toggleBookmark(String hadithId);

  /// Update read count and last read time
  Future<Either<Failure, void>> updateReadStats(String hadithId);

  /// Check if Hadith is cached locally
  Future<Either<Failure, bool>> isHadithCached(String hadithId);

  /// Cache Hadith locally
  Future<Either<Failure, void>> cacheHadith(Hadith hadith);

  /// Get cached Hadith
  Future<Either<Failure, Hadith?>> getCachedHadith(String hadithId);

  /// Clear cache
  Future<Either<Failure, void>> clearCache();

  /// Get cache statistics
  Future<Either<Failure, Map<String, dynamic>>> getCacheStats();
}

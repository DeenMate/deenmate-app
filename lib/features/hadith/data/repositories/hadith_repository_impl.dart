import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/hadith_simple.dart';
import '../../domain/repositories/hadith_repository.dart';
import '../datasources/hadith_remote_datasource.dart';
import '../datasources/hadith_local_datasource.dart';
import '../models/collection_dto.dart';
import '../models/book_dto.dart';
import '../models/chapter_dto.dart';
import '../models/hadith_dto.dart';

/// Implementation of HadithRepository
/// Implements cache-first strategy with offline fallback
class HadithRepositoryImpl implements HadithRepository {
  final HadithRemoteDataSource _remoteDataSource;
  final HadithLocalDataSource _localDataSource;

  HadithRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, List<HadithCollection>>> getCollections() async {
    try {
      // Try to get from cache first
      final cachedCollections = await _localDataSource.getCachedCollections();
      if (cachedCollections.isNotEmpty) {
        return Right(cachedCollections
            .map((dto) => _mapCollectionDtoToEntity(dto))
            .toList());
      }

      // If no cache, fetch from remote
      final remoteCollections = await _remoteDataSource.getCollections();

      // Cache the results
      await _localDataSource.cacheCollections(remoteCollections);

      return Right(remoteCollections
          .map((dto) => _mapCollectionDtoToEntity(dto))
          .toList());
    } on ServerException catch (e) {
      return Left(Failure.serverFailure(message: e.message, statusCode: 500));
    } on CacheException catch (e) {
      return Left(Failure.hadithDataFailure(message: e.message));
    } catch (e) {
      return Left(Failure.serverFailure(
          message: 'Unexpected error: $e', statusCode: 500));
    }
  }

  @override
  Future<Either<Failure, List<Hadith>>> getHadithsByCollection(
      String collectionId,
      {int page = 1,
      int limit = 20}) async {
    try {
      // For now, we'll return empty list as we need to implement book/chapter navigation
      // This will be implemented when we add the book and chapter screens
      return const Right([]);
    } on ServerException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(Failure.hadithDataFailure(message: e.message));
    } catch (e) {
      return Left(Failure.serverFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Hadith?>> getHadithById(
      String collectionId, String hadithId) async {
    try {
      // Try to get from cache first
      final cachedHadith =
          await _localDataSource.getCachedHadith(collectionId, hadithId);
      if (cachedHadith != null) {
        return Right(_mapHadithDtoToEntity(cachedHadith));
      }

      // If not in cache, fetch from remote
      final remoteHadith =
          await _remoteDataSource.getHadith(collectionId, hadithId);

      // Cache the result
      await _localDataSource.cacheHadith(collectionId, hadithId, remoteHadith);

      return Right(_mapHadithDtoToEntity(remoteHadith));
    } on ServerException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(Failure.hadithDataFailure(message: e.message));
    } catch (e) {
      return Left(Failure.serverFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Hadith>>> searchHadiths(String query,
      {String? collectionId, int page = 1, int limit = 20}) async {
    try {
      // Try to get from cache first
      final cachedResults = await _localDataSource.getCachedSearchResults(query,
          collectionId: collectionId);
      if (cachedResults.isNotEmpty) {
        return Right(
            cachedResults.map((dto) => _mapHadithDtoToEntity(dto)).toList());
      }

      // If no cache, search from remote
      final remoteResults = await _remoteDataSource.searchHadiths(query,
          collectionId: collectionId, page: page, limit: limit);

      // Cache the results
      await _localDataSource.cacheSearchResults(query,
          collectionId: collectionId, results: remoteResults);

      return Right(
          remoteResults.map((dto) => _mapHadithDtoToEntity(dto)).toList());
    } on ServerException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(Failure.hadithDataFailure(message: e.message));
    } catch (e) {
      return Left(Failure.serverFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> toggleBookmark(String hadithId) async {
    try {
      // This will be implemented when we add bookmark functionality
      // For now, return success
      return const Right(true);
    } catch (e) {
      return Left(
          Failure.serverFailure(message: 'Failed to toggle bookmark: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateReadStats(String hadithId) async {
    try {
      // This will be implemented when we add read statistics
      // For now, do nothing
      return const Right(null);
    } catch (e) {
      return Left(
          Failure.serverFailure(message: 'Failed to update read stats: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Hadith>>> getHadithsByTopic(String topic,
      {int page = 1, int limit = 20}) async {
    try {
      // Try to get from cache first
      final cachedResults =
          await _localDataSource.getCachedHadithsByTopic(topic);
      if (cachedResults.isNotEmpty) {
        return Right(
            cachedResults.map((dto) => _mapHadithDtoToEntity(dto)).toList());
      }

      // If no cache, fetch from remote
      final remoteResults = await _remoteDataSource.getHadithsByTopic(topic,
          page: page, limit: limit);

      // Cache the results
      await _localDataSource.cacheHadithsByTopic(topic, remoteResults);

      return Right(
          remoteResults.map((dto) => _mapHadithDtoToEntity(dto)).toList());
    } on ServerException catch (e) {
      return Left(Failure.serverFailure(message: e.message));
    } on CacheException catch (e) {
      return Left(Failure.hadithDataFailure(message: e.message));
    } catch (e) {
      return Left(Failure.serverFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Hadith>>> getPopularHadiths(
      {int limit = 10}) async {
    try {
      // For now, return empty list
      // This will be implemented when we add popularity tracking
      return const Right([]);
    } catch (e) {
      return Left(
          Failure.serverFailure(message: 'Failed to get popular hadiths: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Hadith>>> getRecentlyReadHadiths(
      {int limit = 10}) async {
    try {
      // For now, return empty list
      // This will be implemented when we add read history tracking
      return const Right([]);
    } catch (e) {
      return Left(Failure.serverFailure(
          message: 'Failed to get recently read hadiths: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Hadith>>> getBookmarkedHadiths(
      {int limit = 10}) async {
    try {
      // For now, return empty list
      // This will be implemented when we add bookmark functionality
      return const Right([]);
    } catch (e) {
      return Left(Failure.serverFailure(
          message: 'Failed to get bookmarked hadiths: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> isHadithCached(String hadithId) async {
    try {
      // This will be implemented when we add cache checking
      return const Right(false);
    } catch (e) {
      return Left(Failure.serverFailure(message: 'Failed to check cache: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> cacheHadith(Hadith hadith) async {
    try {
      // This will be implemented when we add individual hadith caching
      return const Right(null);
    } catch (e) {
      return Left(Failure.serverFailure(message: 'Failed to cache hadith: $e'));
    }
  }

  @override
  Future<Either<Failure, Hadith?>> getCachedHadith(String hadithId) async {
    try {
      // This will be implemented when we add individual hadith retrieval
      return const Right(null);
    } catch (e) {
      return Left(
          Failure.serverFailure(message: 'Failed to get cached hadith: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await _localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(Failure.serverFailure(message: 'Failed to clear cache: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCacheStats() async {
    try {
      final stats = await _localDataSource.getCacheStats();
      return Right(stats);
    } catch (e) {
      return Left(
          Failure.serverFailure(message: 'Failed to get cache stats: $e'));
    }
  }

  // Helper methods to map DTOs to entities
  HadithCollection _mapCollectionDtoToEntity(CollectionDto dto) {
    return HadithCollection(
      id: dto.id,
      name: dto.name,
      nameBengali: dto.bengaliName ?? dto.name,
      nameArabic: dto.arabicName ?? dto.name,
      nameEnglish: dto.englishName ?? dto.name,
      nameUrdu: dto.urduName ?? dto.name,
      description: dto.description ?? '',
      descriptionBengali: dto.bengaliDescription ?? dto.description ?? '',
      totalHadiths: dto.hadithCount ?? 0,
      author: dto.author ?? '',
      authorBengali: dto.bengaliAuthor ?? dto.author ?? '',
      grade: dto.type ?? '',
      gradeBengali: dto.type ?? '',
      books: [],
      booksBengali: [],
      coverImage: dto.coverImage ?? '',
      isAvailable: dto.isAvailable ?? true,
    );
  }

  Hadith _mapHadithDtoToEntity(HadithDto dto) {
    return Hadith(
      id: dto.id,
      hadithNumber: dto.hadithNumber,
      arabicText: dto.arabicText,
      bengaliText: dto.bengaliText ?? dto.englishText ?? '',
      englishText: dto.englishText ?? '',
      urduText: dto.urduText ?? '',
      collection: dto.collectionId,
      bookName: dto.bookName ?? '',
      bookNameBengali: dto.bookNameBengali ?? dto.bookName ?? '',
      chapterName: dto.chapterName ?? '',
      chapterNameBengali: dto.chapterNameBengali ?? dto.chapterName ?? '',
      narrator: dto.narrator ?? '',
      narratorBengali: dto.narratorBengali ?? dto.narrator ?? '',
      grade: dto.grade ?? '',
      gradeBengali: dto.gradeBengali ?? dto.grade ?? '',
      topics: dto.topics ?? [],
      topicsBengali: dto.topicsBengali ?? dto.topics ?? [],
      explanation: dto.explanation ?? '',
      explanationBengali: dto.explanationBengali ?? dto.explanation ?? '',
      isBookmarked: false,
      lastReadAt: DateTime.now(),
      readCount: 0,
      audioUrl: dto.audioUrl ?? '',
      arabicAudioUrl: dto.arabicAudioUrl ?? '',
      bengaliAudioUrl: dto.bengaliAudioUrl ?? '',
      englishAudioUrl: dto.englishAudioUrl ?? '',
      urduAudioUrl: dto.urduAudioUrl ?? '',
      metadata: dto.metadata ?? {},
    );
  }
}

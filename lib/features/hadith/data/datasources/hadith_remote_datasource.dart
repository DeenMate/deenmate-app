import '../../../../core/error/exceptions.dart';
import '../api/sunnah_api.dart';
import '../models/collection_dto.dart';
import '../models/book_dto.dart';
import '../models/chapter_dto.dart';
import '../models/hadith_dto.dart';

/// Remote data source for Hadith data
/// Handles all API calls to Sunnah.com
abstract class HadithRemoteDataSource {
  Future<List<CollectionDto>> getCollections();
  Future<List<BookDto>> getBooks(String collectionId);
  Future<List<ChapterDto>> getChapters(String collectionId, String bookId);
  Future<List<HadithDto>> getHadiths(
      String collectionId, String bookId, String chapterId,
      {int page, int limit});
  Future<HadithDto> getHadith(String collectionId, String hadithId);
  Future<List<HadithDto>> searchHadiths(String query,
      {String? collectionId, int page, int limit});
  Future<List<String>> getTopics();
  Future<List<HadithDto>> getHadithsByTopic(String topic,
      {int page, int limit});
}

/// Implementation of remote data source using SunnahApi
class HadithRemoteDataSourceImpl implements HadithRemoteDataSource {
  final SunnahApi _sunnahApi;

  HadithRemoteDataSourceImpl(this._sunnahApi);

  @override
  Future<List<CollectionDto>> getCollections() async {
    try {
      return await _sunnahApi.getCollections();
    } catch (e) {
      throw ServerException('Failed to fetch collections: $e');
    }
  }

  @override
  Future<List<BookDto>> getBooks(String collectionId) async {
    try {
      return await _sunnahApi.getBooks(collectionId);
    } catch (e) {
      throw ServerException(
          'Failed to fetch books for collection $collectionId: $e');
    }
  }

  @override
  Future<List<ChapterDto>> getChapters(
      String collectionId, String bookId) async {
    try {
      return await _sunnahApi.getChapters(collectionId, bookId);
    } catch (e) {
      throw ServerException('Failed to fetch chapters for book $bookId: $e');
    }
  }

  @override
  Future<List<HadithDto>> getHadiths(
      String collectionId, String bookId, String chapterId,
      {int page = 1, int limit = 20}) async {
    try {
      return await _sunnahApi.getHadiths(collectionId, bookId, chapterId,
          page: page, limit: limit);
    } catch (e) {
      throw ServerException(
          'Failed to fetch hadiths for chapter $chapterId: $e');
    }
  }

  @override
  Future<HadithDto> getHadith(String collectionId, String hadithId) async {
    try {
      return await _sunnahApi.getHadith(collectionId, hadithId);
    } catch (e) {
      throw ServerException('Failed to fetch hadith $hadithId: $e');
    }
  }

  @override
  Future<List<HadithDto>> searchHadiths(String query,
      {String? collectionId, int page = 1, int limit = 20}) async {
    try {
      return await _sunnahApi.searchHadiths(query,
          collectionId: collectionId, page: page, limit: limit);
    } catch (e) {
      throw ServerException('Failed to search hadiths for query "$query": $e');
    }
  }

  @override
  Future<List<String>> getTopics() async {
    try {
      return await _sunnahApi.getTopics();
    } catch (e) {
      throw ServerException('Failed to fetch topics: $e');
    }
  }

  @override
  Future<List<HadithDto>> getHadithsByTopic(String topic,
      {int page = 1, int limit = 20}) async {
    try {
      return await _sunnahApi.getHadithsByTopic(topic,
          page: page, limit: limit);
    } catch (e) {
      throw ServerException('Failed to fetch hadiths for topic "$topic": $e');
    }
  }
}

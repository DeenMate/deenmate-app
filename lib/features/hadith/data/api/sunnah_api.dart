import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../models/collection_dto.dart';
import '../models/book_dto.dart';
import '../models/chapter_dto.dart';
import '../models/hadith_dto.dart';

/// Sunnah.com API Service
/// Provides access to the Sunnah.com API for Hadith data
class SunnahApi {
  final Dio _dio;
  static const String _baseUrl = 'https://api.sunnah.com/v1';

  SunnahApi(this._dio);

  /// Get all available collections
  Future<List<CollectionDto>> getCollections() async {
    try {
      final response = await _dio.get('$_baseUrl/collections');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => CollectionDto.fromJson(json)).toList();
      } else {
        throw ServerException(
            'Failed to fetch collections: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  /// Get books for a specific collection
  Future<List<BookDto>> getBooks(String collectionId) async {
    try {
      final response =
          await _dio.get('$_baseUrl/collections/$collectionId/books');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => BookDto.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch books: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  /// Get chapters for a specific book
  Future<List<ChapterDto>> getChapters(
      String collectionId, String bookId) async {
    try {
      final response = await _dio
          .get('$_baseUrl/collections/$collectionId/books/$bookId/chapters');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ChapterDto.fromJson(json)).toList();
      } else {
        throw ServerException(
            'Failed to fetch chapters: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  /// Get hadiths for a specific chapter
  Future<List<HadithDto>> getHadiths(
    String collectionId,
    String bookId,
    String chapterId, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/collections/$collectionId/books/$bookId/chapters/$chapterId/hadiths',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => HadithDto.fromJson(json)).toList();
      } else {
        throw ServerException(
            'Failed to fetch hadiths: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  /// Get a specific hadith by ID
  Future<HadithDto> getHadith(String collectionId, String hadithId) async {
    try {
      final response = await _dio
          .get('$_baseUrl/collections/$collectionId/hadiths/$hadithId');

      if (response.statusCode == 200) {
        return HadithDto.fromJson(response.data['data']);
      } else {
        throw ServerException('Failed to fetch hadith: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  /// Search hadiths across collections
  Future<List<HadithDto>> searchHadiths(
    String query, {
    String? collectionId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'q': query,
        'page': page,
        'limit': limit,
      };

      if (collectionId != null) {
        queryParams['collection'] = collectionId;
      }

      final response = await _dio.get(
        '$_baseUrl/hadiths/search',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => HadithDto.fromJson(json)).toList();
      } else {
        throw ServerException(
            'Failed to search hadiths: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  /// Get topics/categories
  Future<List<String>> getTopics() async {
    try {
      final response = await _dio.get('$_baseUrl/topics');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => json['name'] as String).toList();
      } else {
        throw ServerException('Failed to fetch topics: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  /// Get hadiths by topic
  Future<List<HadithDto>> getHadithsByTopic(
    String topic, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/topics/$topic/hadiths',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => HadithDto.fromJson(json)).toList();
      } else {
        throw ServerException(
            'Failed to fetch hadiths by topic: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException('Unexpected error: $e');
    }
  }

  /// Handle DioException and convert to appropriate exceptions
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException('Request timeout: ${e.message}');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 404) {
          return NotFoundException('Resource not found: ${e.message}');
        } else if (statusCode == 429) {
          return RateLimitException('Rate limit exceeded: ${e.message}');
        } else if (statusCode! >= 500) {
          return ServerException('Server error: ${e.message}');
        } else {
          return ServerException('HTTP error $statusCode: ${e.message}');
        }
      case DioExceptionType.cancel:
        return CancelledException('Request cancelled: ${e.message}');
      case DioExceptionType.connectionError:
        return NetworkException('Network error: ${e.message}');
      default:
        return ServerException('Dio error: ${e.message}');
    }
  }
}

/// Custom exceptions for specific error cases
class NotFoundException extends ServerException {
  NotFoundException(String message) : super(message);
}

class RateLimitException extends ServerException {
  RateLimitException(String message) : super(message);
}

class CancelledException extends ServerException {
  CancelledException(String message) : super(message);
}

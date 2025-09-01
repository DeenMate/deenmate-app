import 'package:dio/dio.dart';
import '../../domain/entities/hadith_simple.dart';
import 'hadith_remote_data_source.dart';

/// Implementation of Hadith Remote Data Source
/// Integrates with Sunnah.com API following our documented strategy
class HadithRemoteDataSourceImpl implements HadithRemoteDataSource {
  final Dio _dio;
  static const String _baseUrl = 'https://api.sunnah.com/v1';
  
  HadithRemoteDataSourceImpl(this._dio);

  @override
  Future<List<HadithCollection>> getCollections() async {
    try {
      final response = await _dio.get('$_baseUrl/collections');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => _mapCollectionFromApi(json)).toList();
      } else {
        throw Exception('Failed to fetch collections: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching collections: $e');
    }
  }

  @override
  Future<List<Hadith>> getHadithsByCollection(String collectionId, {int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/collections/$collectionId/hadiths',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => _mapHadithFromApi(json)).toList();
      } else {
        throw Exception('Failed to fetch hadiths: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching hadiths: $e');
    }
  }

  @override
  Future<Hadith?> getHadithById(String hadithId) async {
    try {
      final response = await _dio.get('$_baseUrl/hadiths/$hadithId');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return _mapHadithFromApi(data);
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch hadith: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching hadith: $e');
    }
  }

  @override
  Future<HadithSearchResult> searchHadiths(String query, {
    String? collection,
    String? grade,
    List<String>? topics,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {
        'q': query,
        'page': page,
        'limit': limit,
      };

      if (collection != null) {
        queryParams['collection'] = collection;
      }
      if (grade != null) {
        queryParams['grade'] = grade;
      }
      if (topics != null && topics.isNotEmpty) {
        queryParams['topics'] = topics.join(',');
      }

      final response = await _dio.get(
        '$_baseUrl/hadiths/search',
        queryParameters: queryParams,
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> hadithsData = data['data'];
        final hadiths = hadithsData.map((json) => _mapHadithFromApi(json)).toList();
        
        return HadithSearchResult(
          hadiths: hadiths,
          totalResults: data['total'] ?? 0,
          currentPage: data['current_page'] ?? page,
          totalPages: data['last_page'] ?? 1,
          query: query,
          filters: _buildFilters(collection, grade, topics),
        );
      } else {
        throw Exception('Failed to search hadiths: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching hadiths: $e');
    }
  }

  @override
  Future<List<Hadith>> getHadithsByTopic(String topic, {int page = 1, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/hadiths',
        queryParameters: {
          'topic': topic,
          'page': page,
          'limit': limit,
        },
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => _mapHadithFromApi(json)).toList();
      } else {
        throw Exception('Failed to fetch hadiths by topic: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching hadiths by topic: $e');
    }
  }

  @override
  Future<List<String>> getTopics() async {
    try {
      final response = await _dio.get('$_baseUrl/topics');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((topic) => topic['name'] as String).toList();
      } else {
        throw Exception('Failed to fetch topics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching topics: $e');
    }
  }

  @override
  Future<List<String>> getGrades() async {
    try {
      final response = await _dio.get('$_baseUrl/grades');
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((grade) => grade['name'] as String).toList();
      } else {
        throw Exception('Failed to fetch grades: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching grades: $e');
    }
  }

  @override
  Future<String?> getHadithAudioUrl(String hadithId, String language) async {
    try {
      final response = await _dio.get('$_baseUrl/hadiths/$hadithId/audio');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final audioFiles = data['audio_files'] as List<dynamic>;
        
        for (final audioFile in audioFiles) {
          if (audioFile['language'] == language) {
            return audioFile['url'] as String;
          }
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  @override
  Future<String?> getHadithExplanation(String hadithId, String language) async {
    try {
      final response = await _dio.get('$_baseUrl/hadiths/$hadithId/explanation');
      
      if (response.statusCode == 200) {
        final data = response.data['data'];
        final explanations = data['explanations'] as List<dynamic>;
        
        for (final explanation in explanations) {
          if (explanation['language'] == language) {
            return explanation['text'] as String;
          }
        }
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // Helper methods for mapping API responses to our entities

  HadithCollection _mapCollectionFromApi(Map<String, dynamic> json) {
    return HadithCollection(
      id: json['collection_number']?.toString() ?? '',
      name: json['name'] ?? '',
      nameBengali: json['name_bn'] ?? json['name'] ?? '',
      nameArabic: json['name_ar'] ?? json['name'] ?? '',
      nameEnglish: json['name_en'] ?? json['name'] ?? '',
      nameUrdu: json['name_ur'] ?? json['name'] ?? '',
      description: json['description'] ?? '',
      descriptionBengali: json['description_bn'] ?? json['description'] ?? '',
      totalHadiths: json['total_hadiths'] ?? 0,
      author: json['author'] ?? '',
      authorBengali: json['author_bn'] ?? json['author'] ?? '',
      grade: json['grade'] ?? '',
      gradeBengali: json['grade_bn'] ?? json['grade'] ?? '',
      books: _extractBooks(json),
      booksBengali: _extractBooksBengali(json),
      coverImage: json['cover_image'] ?? '',
      isAvailable: json['is_available'] ?? true,
    );
  }

  Hadith _mapHadithFromApi(Map<String, dynamic> json) {
    return Hadith(
      id: json['hadith_number']?.toString() ?? '',
      hadithNumber: json['hadith_number']?.toString() ?? '',
      arabicText: json['arabic_text'] ?? '',
      bengaliText: json['bengali_text'] ?? json['english_text'] ?? '',
      englishText: json['english_text'] ?? '',
      urduText: json['urdu_text'] ?? json['english_text'] ?? '',
      collection: json['collection_number']?.toString() ?? '',
      bookName: json['book_name'] ?? '',
      bookNameBengali: json['book_name_bn'] ?? json['book_name'] ?? '',
      chapterName: json['chapter_name'] ?? '',
      chapterNameBengali: json['chapter_name_bn'] ?? json['chapter_name'] ?? '',
      narrator: json['narrator'] ?? '',
      narratorBengali: json['narrator_bn'] ?? json['narrator'] ?? '',
      grade: json['grade'] ?? '',
      gradeBengali: json['grade_bn'] ?? json['grade'] ?? '',
      topics: _extractTopics(json),
      topicsBengali: _extractTopicsBengali(json),
      explanation: json['explanation'] ?? '',
      explanationBengali: json['explanation_bn'] ?? json['explanation'] ?? '',
      isBookmarked: false, // Will be managed locally
      lastReadAt: DateTime.now(), // Will be managed locally
      readCount: 0, // Will be managed locally
      audioUrl: json['audio_url'] ?? '',
      arabicAudioUrl: json['arabic_audio_url'] ?? json['audio_url'] ?? '',
      bengaliAudioUrl: json['bengali_audio_url'] ?? json['audio_url'] ?? '',
      englishAudioUrl: json['english_audio_url'] ?? json['audio_url'] ?? '',
      urduAudioUrl: json['urdu_audio_url'] ?? json['audio_url'] ?? '',
      metadata: {
        'api_source': 'sunnah.com',
        'last_updated': json['updated_at'] ?? '',
        'original_data': json,
      },
    );
  }

  List<String> _extractBooks(Map<String, dynamic> json) {
    final books = json['books'] as List<dynamic>?;
    if (books != null) {
      return books.map((book) => book['name'] as String).toList();
    }
    return [];
  }

  List<String> _extractBooksBengali(Map<String, dynamic> json) {
    final books = json['books'] as List<dynamic>?;
    if (books != null) {
      return books.map((book) => book['name_bn'] as String? ?? book['name'] as String).toList();
    }
    return [];
  }

  List<String> _extractTopics(Map<String, dynamic> json) {
    final topics = json['topics'] as List<dynamic>?;
    if (topics != null) {
      return topics.map((topic) => topic['name'] as String).toList();
    }
    return [];
  }

  List<String> _extractTopicsBengali(Map<String, dynamic> json) {
    final topics = json['topics'] as List<dynamic>?;
    if (topics != null) {
      return topics.map((topic) => topic['name_bn'] as String? ?? topic['name'] as String).toList();
    }
    return [];
  }

  List<String> _buildFilters(String? collection, String? grade, List<String>? topics) {
    final filters = <String>[];
    if (collection != null) filters.add('collection: $collection');
    if (grade != null) filters.add('grade: $grade');
    if (topics != null && topics.isNotEmpty) filters.add('topics: ${topics.join(', ')}');
    return filters;
  }
}

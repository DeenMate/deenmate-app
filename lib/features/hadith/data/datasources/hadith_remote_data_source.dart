import '../../domain/entities/hadith_simple.dart';

/// Remote Data Source Interface for Hadith API
/// Integrates with Sunnah.com API following our documented strategy
abstract class HadithRemoteDataSource {
  /// Base URL for Sunnah.com API
  static const String baseUrl = 'https://api.sunnah.com/v1';
  
  /// Get Hadith collections from API
  Future<List<HadithCollection>> getCollections();

  /// Get Hadiths by collection from API
  Future<List<Hadith>> getHadithsByCollection(String collectionId, {int page = 1, int limit = 20});

  /// Get Hadith by ID from API
  Future<Hadith?> getHadithById(String hadithId);

  /// Search Hadiths from API
  Future<HadithSearchResult> searchHadiths(String query, {
    String? collection,
    String? grade,
    List<String>? topics,
    int page = 1,
    int limit = 20,
  });

  /// Get Hadiths by topic from API
  Future<List<Hadith>> getHadithsByTopic(String topic, {int page = 1, int limit = 20});

  /// Get Hadith topics from API
  Future<List<String>> getTopics();

  /// Get Hadith grades from API
  Future<List<String>> getGrades();

  /// Get Hadith audio URL
  Future<String?> getHadithAudioUrl(String hadithId, String language);

  /// Get Hadith explanation
  Future<String?> getHadithExplanation(String hadithId, String language);
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/hadith_simple.dart';
import '../../domain/repositories/hadith_repository.dart';

/// Provider for Hadith repository
final hadithRepositoryProvider = Provider<HadithRepository>((ref) {
  // TODO: Replace with actual implementation when ready
  return MockHadithRepository();
});

/// Provider for Hadith collections
final hadithCollectionsProvider =
    FutureProvider<List<HadithCollection>>((ref) async {
  final repository = ref.read(hadithRepositoryProvider);
  final result = await repository.getCollections();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (collections) => collections,
  );
});

/// Provider for Hadiths by collection
final hadithsByCollectionProvider =
    FutureProvider.family<List<Hadith>, String>((ref, collectionId) async {
  final repository = ref.read(hadithRepositoryProvider);
  final result = await repository.getHadithsByCollection(collectionId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (hadiths) => hadiths,
  );
});

/// Provider for specific Hadith by ID
final hadithByIdProvider =
    FutureProvider.family<Hadith?, String>((ref, hadithId) async {
  final repository = ref.read(hadithRepositoryProvider);
  // For now, we'll use a default collection ID since the interface requires it
  final result = await repository.getHadithById('bukhari', hadithId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (hadith) => hadith,
  );
});

/// Provider for Hadith search
final hadithSearchProvider =
    FutureProvider.family<List<Hadith>, String>((ref, query) async {
  final repository = ref.read(hadithRepositoryProvider);
  final result = await repository.searchHadiths(query);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (hadiths) => hadiths,
  );
});

/// Provider for Hadiths by topic
final hadithsByTopicProvider =
    FutureProvider.family<List<Hadith>, String>((ref, topic) async {
  final repository = ref.read(hadithRepositoryProvider);
  final result = await repository.getHadithsByTopic(topic);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (hadiths) => hadiths,
  );
});

/// Provider for popular Hadiths
final popularHadithsProvider = FutureProvider<List<Hadith>>((ref) async {
  final repository = ref.read(hadithRepositoryProvider);
  final result = await repository.getPopularHadiths();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (hadiths) => hadiths,
  );
});

/// Provider for recently read Hadiths
final recentlyReadHadithsProvider = FutureProvider<List<Hadith>>((ref) async {
  final repository = ref.read(hadithRepositoryProvider);
  final result = await repository.getRecentlyReadHadiths();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (hadiths) => hadiths,
  );
});

/// Provider for bookmarked Hadiths
final bookmarkedHadithsProvider = FutureProvider<List<Hadith>>((ref) async {
  final repository = ref.read(hadithRepositoryProvider);
  final result = await repository.getBookmarkedHadiths();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (hadiths) => hadiths,
  );
});

/// Provider for cache statistics
final hadithCacheStatsProvider =
    FutureProvider<Map<String, dynamic>>((ref) async {
  final repository = ref.read(hadithRepositoryProvider);
  final result = await repository.getCacheStats();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stats) => stats,
  );
});

/// StateNotifier for Hadith operations
class HadithNotifier extends StateNotifier<AsyncValue<List<Hadith>>> {
  final HadithRepository _repository;

  HadithNotifier(this._repository) : super(const AsyncValue.loading());

  /// Load Hadiths by collection
  Future<void> loadHadithsByCollection(String collectionId) async {
    state = const AsyncValue.loading();
    final result = await _repository.getHadithsByCollection(collectionId);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (hadiths) => AsyncValue.data(hadiths),
    );
  }

  /// Search Hadiths
  Future<void> searchHadiths(String query) async {
    state = const AsyncValue.loading();
    final result = await _repository.searchHadiths(query);
    state = result.fold(
      (failure) => AsyncValue.error(failure, StackTrace.current),
      (hadiths) => AsyncValue.data(hadiths),
    );
  }

  /// Toggle bookmark for a Hadith
  Future<void> toggleBookmark(String hadithId) async {
    final result = await _repository.toggleBookmark(hadithId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (success) {
        // Update the state to reflect the bookmark change
        state.whenData((hadiths) {
          final updatedHadiths = hadiths.map((hadith) {
            if (hadith.id == hadithId) {
              return hadith.copyWith(isBookmarked: !hadith.isBookmarked);
            }
            return hadith;
          }).toList();
          state = AsyncValue.data(updatedHadiths);
        });
      },
    );
  }

  /// Update read statistics for a Hadith
  Future<void> updateReadStats(String hadithId) async {
    final result = await _repository.updateReadStats(hadithId);
    result.fold(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (_) {
        // Update the state to reflect the read stats change
        state.whenData((hadiths) {
          final updatedHadiths = hadiths.map((hadith) {
            if (hadith.id == hadithId) {
              return hadith.copyWith(
                readCount: hadith.readCount + 1,
                lastReadAt: DateTime.now(),
              );
            }
            return hadith;
          }).toList();
          state = AsyncValue.data(updatedHadiths);
        });
      },
    );
  }
}

/// Provider for Hadith operations
final hadithNotifierProvider =
    StateNotifierProvider<HadithNotifier, AsyncValue<List<Hadith>>>((ref) {
  final repository = ref.read(hadithRepositoryProvider);
  return HadithNotifier(repository);
});

/// Mock implementation for testing
class MockHadithRepository implements HadithRepository {
  @override
  Future<Either<Failure, List<HadithCollection>>> getCollections() async {
    return Right([
      HadithCollection(
        id: 'bukhari',
        name: 'Sahih Bukhari',
        nameBengali: 'সহিহ বুখারী',
        nameArabic: 'صحيح البخاري',
        nameEnglish: 'Sahih Bukhari',
        nameUrdu: 'صحیح بخاری',
        description: 'The most authentic collection of Hadith',
        descriptionBengali: 'হাদিসের সবচেয়ে নির্ভরযোগ্য সংকলন',
        totalHadiths: 7563,
        author: 'Imam Bukhari',
        authorBengali: 'ইমাম বুখারী',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        books: ['Book 1', 'Book 2'],
        booksBengali: ['কিতাব ১', 'কিতাব ২'],
        coverImage: '',
        isAvailable: true,
      ),
      HadithCollection(
        id: 'muslim',
        name: 'Sahih Muslim',
        nameBengali: 'সহিহ মুসলিম',
        nameArabic: 'صحيح مسلم',
        nameEnglish: 'Sahih Muslim',
        nameUrdu: 'صحیح مسلم',
        description: 'Second most authentic collection of Hadith',
        descriptionBengali: 'দ্বিতীয় সর্বাধিক নির্ভরযোগ্য সংকলন',
        totalHadiths: 7563,
        author: 'Imam Muslim',
        authorBengali: 'ইমাম মুসলিম',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        books: ['Book 1', 'Book 2'],
        booksBengali: ['কিতাব ১', 'কিতাব ২'],
        coverImage: '',
        isAvailable: true,
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<Hadith>>> getHadithsByCollection(
      String collectionId,
      {int page = 1,
      int limit = 20}) async {
    return Right([
      Hadith(
        id: '1',
        hadithNumber: '1',
        arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
        bengaliText: 'কর্মগুলি উদ্দেশ্য অনুযায়ী বিচার করা হয়',
        englishText: 'Actions are judged by intentions',
        urduText: 'اعمال کا دارومدار نیتوں پر ہے',
        collection: collectionId,
        bookName: 'Book of Revelation',
        bookNameBengali: 'ওহীর কিতাব',
        chapterName: 'Chapter 1',
        chapterNameBengali: 'অধ্যায় ১',
        narrator: 'Umar ibn al-Khattab',
        narratorBengali: 'উমর ইবনে আল-খাত্তাব',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['Intention', 'Actions'],
        topicsBengali: ['নিয়ত', 'কর্ম'],
        explanation:
            'This hadith explains the importance of intention in actions',
        explanationBengali: 'এই হাদিস কর্মে নিয়তের গুরুত্ব ব্যাখ্যা করে',
        isBookmarked: false,
        lastReadAt: DateTime.now(),
        readCount: 0,
        audioUrl: '',
        arabicAudioUrl: '',
        bengaliAudioUrl: '',
        englishAudioUrl: '',
        urduAudioUrl: '',
        metadata: {},
      ),
    ]);
  }

  @override
  Future<Either<Failure, Hadith?>> getHadithById(
      String collectionId, String hadithId) async {
    return Right(Hadith(
      id: hadithId,
      hadithNumber: '1',
      arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
      bengaliText: 'কর্মগুলি উদ্দেশ্য অনুযায়ী বিচার করা হয়',
      englishText: 'Actions are judged by intentions',
      urduText: 'اعمال کا دارومدار نیتوں پر ہے',
      collection: collectionId,
      bookName: 'Book of Revelation',
      bookNameBengali: 'ওহীর কিতাব',
      chapterName: 'Chapter 1',
      chapterNameBengali: 'অধ্যায় ১',
      narrator: 'Umar ibn al-Khattab',
      narratorBengali: 'উমর ইবনে আল-খাত্তাব',
      grade: 'Sahih',
      gradeBengali: 'সহীহ',
      topics: ['Intention', 'Actions'],
      topicsBengali: ['নিয়ত', 'কর্ম'],
      explanation:
          'This hadith explains the importance of intention in actions',
      explanationBengali: 'এই হাদিস কর্মে নিয়তের গুরুত্ব ব্যাখ্যা করে',
      isBookmarked: false,
      lastReadAt: DateTime.now(),
      readCount: 0,
      audioUrl: '',
      arabicAudioUrl: '',
      bengaliAudioUrl: '',
      englishAudioUrl: '',
      urduAudioUrl: '',
      metadata: {},
    ));
  }

  @override
  Future<Either<Failure, List<Hadith>>> searchHadiths(String query,
      {String? collectionId, int page = 1, int limit = 20}) async {
    return Right([
      Hadith(
        id: '1',
        hadithNumber: '1',
        arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
        bengaliText: 'কর্মগুলি উদ্দেশ্য অনুযায়ী বিচার করা হয়',
        englishText: 'Actions are judged by intentions',
        urduText: 'اعمال کا دارومدار نیتوں پر ہے',
        collection: collectionId ?? 'bukhari',
        bookName: 'Book of Revelation',
        bookNameBengali: 'ওহীর কিতাব',
        chapterName: 'Chapter 1',
        chapterNameBengali: 'অধ্যায় ১',
        narrator: 'Umar ibn al-Khattab',
        narratorBengali: 'উমর ইবনে আল-খাত্তাব',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['Intention', 'Actions'],
        topicsBengali: ['নিয়ত', 'কর্ম'],
        explanation:
            'This hadith explains the importance of intention in actions',
        explanationBengali: 'এই হাদিস কর্মে নিয়তের গুরুত্ব ব্যাখ্যা করে',
        isBookmarked: false,
        lastReadAt: DateTime.now(),
        readCount: 0,
        audioUrl: '',
        arabicAudioUrl: '',
        bengaliAudioUrl: '',
        englishAudioUrl: '',
        urduAudioUrl: '',
        metadata: {},
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<Hadith>>> getHadithsByTopic(String topic,
      {int page = 1, int limit = 20}) async {
    return Right([
      Hadith(
        id: '1',
        hadithNumber: '1',
        arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
        bengaliText: 'কর্মগুলি উদ্দেশ্য অনুযায়ী বিচার করা হয়',
        englishText: 'Actions are judged by intentions',
        urduText: 'اعمال کا دارومدار نیتوں پر ہے',
        collection: 'bukhari',
        bookName: 'Book of Revelation',
        bookNameBengali: 'ওহীর কিতাব',
        chapterName: 'Chapter 1',
        chapterNameBengali: 'অধ্যায় ১',
        narrator: 'Umar ibn al-Khattab',
        narratorBengali: 'উমর ইবনে আল-খাত্তাব',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['Intention', 'Actions'],
        topicsBengali: ['নিয়ত', 'কর্ম'],
        explanation:
            'This hadith explains the importance of intention in actions',
        explanationBengali: 'এই হাদিস কর্মে নিয়তের গুরুত্ব ব্যাখ্যা করে',
        isBookmarked: false,
        lastReadAt: DateTime.now(),
        readCount: 0,
        audioUrl: '',
        arabicAudioUrl: '',
        bengaliAudioUrl: '',
        englishAudioUrl: '',
        urduAudioUrl: '',
        metadata: {},
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<Hadith>>> getPopularHadiths(
      {int limit = 10}) async {
    return Right([
      Hadith(
        id: '1',
        hadithNumber: '1',
        arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
        bengaliText: 'কর্মগুলি উদ্দেশ্য অনুযায়ী বিচার করা হয়',
        englishText: 'Actions are judged by intentions',
        urduText: 'اعمال کا دارومدار نیتوں پر ہے',
        collection: 'bukhari',
        bookName: 'Book of Revelation',
        bookNameBengali: 'ওহীর কিতাব',
        chapterName: 'Chapter 1',
        chapterNameBengali: 'অধ্যায় ১',
        narrator: 'Umar ibn al-Khattab',
        narratorBengali: 'উমর ইবনে আল-খাত্তাব',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['Intention', 'Actions'],
        topicsBengali: ['নিয়ত', 'কর্ম'],
        explanation:
            'This hadith explains the importance of intention in actions',
        explanationBengali: 'এই হাদিস কর্মে নিয়তের গুরুত্ব ব্যাখ্যা করে',
        isBookmarked: false,
        lastReadAt: DateTime.now(),
        readCount: 0,
        audioUrl: '',
        arabicAudioUrl: '',
        bengaliAudioUrl: '',
        englishAudioUrl: '',
        urduAudioUrl: '',
        metadata: {},
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<Hadith>>> getRecentlyReadHadiths(
      {int limit = 10}) async {
    return Right([
      Hadith(
        id: '1',
        hadithNumber: '1',
        arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
        bengaliText: 'কর্মগুলি উদ্দেশ্য অনুযায়ী বিচার করা হয়',
        englishText: 'Actions are judged by intentions',
        urduText: 'اعمال کا دارومدار نیتوں پر ہے',
        collection: 'bukhari',
        bookName: 'Book of Revelation',
        bookNameBengali: 'ওহীর কিতাব',
        chapterName: 'Chapter 1',
        chapterNameBengali: 'অধ্যায় ১',
        narrator: 'Umar ibn al-Khattab',
        narratorBengali: 'উমর ইবনে আল-খাত্তাব',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['Intention', 'Actions'],
        topicsBengali: ['নিয়ত', 'কর্ম'],
        explanation:
            'This hadith explains the importance of intention in actions',
        explanationBengali: 'এই হাদিস কর্মে নিয়তের গুরুত্ব ব্যাখ্যা করে',
        isBookmarked: false,
        lastReadAt: DateTime.now(),
        readCount: 0,
        audioUrl: '',
        arabicAudioUrl: '',
        bengaliAudioUrl: '',
        englishAudioUrl: '',
        urduAudioUrl: '',
        metadata: {},
      ),
    ]);
  }

  @override
  Future<Either<Failure, List<Hadith>>> getBookmarkedHadiths(
      {int limit = 10}) async {
    return Right([
      Hadith(
        id: '1',
        hadithNumber: '1',
        arabicText: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
        bengaliText: 'কর্মগুলি উদ্দেশ্য অনুযায়ী বিচার করা হয়',
        englishText: 'Actions are judged by intentions',
        urduText: 'اعمال کا دارومدار نیتوں پر ہے',
        collection: 'bukhari',
        bookName: 'Book of Revelation',
        bookNameBengali: 'ওহীর কিতাব',
        chapterName: 'Chapter 1',
        chapterNameBengali: 'অধ্যায় ১',
        narrator: 'Umar ibn al-Khattab',
        narratorBengali: 'উমর ইবনে আল-খাত্তাব',
        grade: 'Sahih',
        gradeBengali: 'সহীহ',
        topics: ['Intention', 'Actions'],
        topicsBengali: ['নিয়ত', 'কর্ম'],
        explanation:
            'This hadith explains the importance of intention in actions',
        explanationBengali: 'এই হাদিস কর্মে নিয়তের গুরুত্ব ব্যাখ্যা করে',
        isBookmarked: true,
        lastReadAt: DateTime.now(),
        readCount: 0,
        audioUrl: '',
        arabicAudioUrl: '',
        bengaliAudioUrl: '',
        englishAudioUrl: '',
        urduAudioUrl: '',
        metadata: {},
      ),
    ]);
  }

  @override
  Future<Either<Failure, bool>> toggleBookmark(String hadithId) async {
    return const Right(true);
  }

  @override
  Future<Either<Failure, void>> updateReadStats(String hadithId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, bool>> isHadithCached(String hadithId) async {
    return const Right(false);
  }

  @override
  Future<Either<Failure, void>> cacheHadith(Hadith hadith) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, Hadith?>> getCachedHadith(String hadithId) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getCacheStats() async {
    return Right({
      'totalCached': 0,
      'cacheSize': '0 MB',
      'lastUpdated': DateTime.now().toIso8601String(),
    });
  }
}

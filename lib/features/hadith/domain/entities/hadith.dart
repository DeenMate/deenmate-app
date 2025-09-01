import 'package:freezed_annotation/freezed_annotation.dart';

part 'hadith.freezed.dart';
part 'hadith.g.dart';

@freezed
class Hadith with _$Hadith {
  const factory Hadith({
    required String id,
    required String hadithNumber,
    required String arabicText,
    required String bengaliText,
    required String englishText,
    required String urduText,
    required String collection,
    required String bookName,
    required String bookNameBengali,
    required String chapterName,
    required String chapterNameBengali,
    required String narrator,
    required String narratorBengali,
    required String grade,
    required String gradeBengali,
    required List<String> topics,
    required List<String> topicsBengali,
    required String explanation,
    required String explanationBengali,
    required bool isBookmarked,
    required DateTime lastReadAt,
    required int readCount,
    required String audioUrl,
    required String arabicAudioUrl,
    required String bengaliAudioUrl,
    required String englishAudioUrl,
    required String urduAudioUrl,
    required Map<String, dynamic> metadata,
  }) = _Hadith;

  factory Hadith.fromJson(Map<String, dynamic> json) => _$HadithFromJson(json);
}

@freezed
class HadithCollection with _$HadithCollection {
  const factory HadithCollection({
    required String id,
    required String name,
    required String nameBengali,
    required String nameArabic,
    required String nameEnglish,
    required String nameUrdu,
    required String description,
    required String descriptionBengali,
    required int totalHadiths,
    required String author,
    required String authorBengali,
    required String grade,
    required String gradeBengali,
    required List<String> books,
    required List<String> booksBengali,
    required String coverImage,
    required bool isAvailable,
  }) = _HadithCollection;

  factory HadithCollection.fromJson(Map<String, dynamic> json) =>
      _$HadithCollectionFromJson(json);
}

@freezed
class HadithBook with _$HadithBook {
  const factory HadithBook({
    required String id,
    required String collectionId,
    required String name,
    required String nameBengali,
    required String nameArabic,
    required String nameEnglish,
    required String nameUrdu,
    required String description,
    required String descriptionBengali,
    required int totalHadiths,
    required List<String> chapters,
    required List<String> chaptersBengali,
    required int order,
  }) = _HadithBook;

  factory HadithBook.fromJson(Map<String, dynamic> json) =>
      _$HadithBookFromJson(json);
}

@freezed
class HadithChapter with _$HadithChapter {
  const factory HadithChapter({
    required String id,
    required String bookId,
    required String name,
    required String nameBengali,
    required String nameArabic,
    required String nameEnglish,
    required String nameUrdu,
    required String description,
    required String descriptionBengali,
    required int totalHadiths,
    required int order,
  }) = _HadithChapter;

  factory HadithChapter.fromJson(Map<String, dynamic> json) =>
      _$HadithChapterFromJson(json);
}

@freezed
class HadithTopic with _$HadithTopic {
  const factory HadithTopic({
    required String id,
    required String name,
    required String nameBengali,
    required String nameArabic,
    required String nameEnglish,
    required String nameUrdu,
    required String description,
    required String descriptionBengali,
    required int totalHadiths,
    required String category,
    required String categoryBengali,
    required int order,
  }) = _HadithTopic;

  factory HadithTopic.fromJson(Map<String, dynamic> json) =>
      _$HadithTopicFromJson(json);
}

@freezed
class HadithSearchResult with _$HadithSearchResult {
  const factory HadithSearchResult({
    required List<Hadith> hadiths,
    required int totalResults,
    required int currentPage,
    required int totalPages,
    required String query,
    required List<String> filters,
  }) = _HadithSearchResult;

  factory HadithSearchResult.fromJson(Map<String, dynamic> json) =>
      _$HadithSearchResultFromJson(json);
}

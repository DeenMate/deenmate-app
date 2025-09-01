/// Simple Hadith entity for Phase 1 implementation
/// Bengali-first approach with Islamic terminology
class Hadith {
  final String id;
  final String hadithNumber;
  final String arabicText;
  final String bengaliText;
  final String englishText;
  final String urduText;
  final String collection;
  final String bookName;
  final String bookNameBengali;
  final String chapterName;
  final String chapterNameBengali;
  final String narrator;
  final String narratorBengali;
  final String grade;
  final String gradeBengali;
  final List<String> topics;
  final List<String> topicsBengali;
  final String explanation;
  final String explanationBengali;
  final bool isBookmarked;
  final DateTime lastReadAt;
  final int readCount;
  final String audioUrl;
  final String arabicAudioUrl;
  final String bengaliAudioUrl;
  final String englishAudioUrl;
  final String urduAudioUrl;
  final Map<String, dynamic> metadata;

  const Hadith({
    required this.id,
    required this.hadithNumber,
    required this.arabicText,
    required this.bengaliText,
    required this.englishText,
    required this.urduText,
    required this.collection,
    required this.bookName,
    required this.bookNameBengali,
    required this.chapterName,
    required this.chapterNameBengali,
    required this.narrator,
    required this.narratorBengali,
    required this.grade,
    required this.gradeBengali,
    required this.topics,
    required this.topicsBengali,
    required this.explanation,
    required this.explanationBengali,
    required this.isBookmarked,
    required this.lastReadAt,
    required this.readCount,
    required this.audioUrl,
    required this.arabicAudioUrl,
    required this.bengaliAudioUrl,
    required this.englishAudioUrl,
    required this.urduAudioUrl,
    required this.metadata,
  });

  Hadith copyWith({
    String? id,
    String? hadithNumber,
    String? arabicText,
    String? bengaliText,
    String? englishText,
    String? urduText,
    String? collection,
    String? bookName,
    String? bookNameBengali,
    String? chapterName,
    String? chapterNameBengali,
    String? narrator,
    String? narratorBengali,
    String? grade,
    String? gradeBengali,
    List<String>? topics,
    List<String>? topicsBengali,
    String? explanation,
    String? explanationBengali,
    bool? isBookmarked,
    DateTime? lastReadAt,
    int? readCount,
    String? audioUrl,
    String? arabicAudioUrl,
    String? bengaliAudioUrl,
    String? englishAudioUrl,
    String? urduAudioUrl,
    Map<String, dynamic>? metadata,
  }) {
    return Hadith(
      id: id ?? this.id,
      hadithNumber: hadithNumber ?? this.hadithNumber,
      arabicText: arabicText ?? this.arabicText,
      bengaliText: bengaliText ?? this.bengaliText,
      englishText: englishText ?? this.englishText,
      urduText: urduText ?? this.urduText,
      collection: collection ?? this.collection,
      bookName: bookName ?? this.bookName,
      bookNameBengali: bookNameBengali ?? this.bookNameBengali,
      chapterName: chapterName ?? this.chapterName,
      chapterNameBengali: chapterNameBengali ?? this.chapterNameBengali,
      narrator: narrator ?? this.narrator,
      narratorBengali: narratorBengali ?? this.narratorBengali,
      grade: grade ?? this.grade,
      gradeBengali: gradeBengali ?? this.gradeBengali,
      topics: topics ?? this.topics,
      topicsBengali: topicsBengali ?? this.topicsBengali,
      explanation: explanation ?? this.explanation,
      explanationBengali: explanationBengali ?? this.explanationBengali,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      readCount: readCount ?? this.readCount,
      audioUrl: audioUrl ?? this.audioUrl,
      arabicAudioUrl: arabicAudioUrl ?? this.arabicAudioUrl,
      bengaliAudioUrl: bengaliAudioUrl ?? this.bengaliAudioUrl,
      englishAudioUrl: englishAudioUrl ?? this.englishAudioUrl,
      urduAudioUrl: urduAudioUrl ?? this.urduAudioUrl,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hadithNumber': hadithNumber,
      'arabicText': arabicText,
      'bengaliText': bengaliText,
      'englishText': englishText,
      'urduText': urduText,
      'collection': collection,
      'bookName': bookName,
      'bookNameBengali': bookNameBengali,
      'chapterName': chapterName,
      'chapterNameBengali': chapterNameBengali,
      'narrator': narrator,
      'narratorBengali': narratorBengali,
      'grade': grade,
      'gradeBengali': gradeBengali,
      'topics': topics,
      'topicsBengali': topicsBengali,
      'explanation': explanation,
      'explanationBengali': explanationBengali,
      'isBookmarked': isBookmarked,
      'lastReadAt': lastReadAt.toIso8601String(),
      'readCount': readCount,
      'audioUrl': audioUrl,
      'arabicAudioUrl': arabicAudioUrl,
      'bengaliAudioUrl': bengaliAudioUrl,
      'englishAudioUrl': englishAudioUrl,
      'urduAudioUrl': urduAudioUrl,
      'metadata': metadata,
    };
  }

  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'] as String,
      hadithNumber: json['hadithNumber'] as String,
      arabicText: json['arabicText'] as String,
      bengaliText: json['bengaliText'] as String,
      englishText: json['englishText'] as String,
      urduText: json['urduText'] as String,
      collection: json['collection'] as String,
      bookName: json['bookName'] as String,
      bookNameBengali: json['bookNameBengali'] as String,
      chapterName: json['chapterName'] as String,
      chapterNameBengali: json['chapterNameBengali'] as String,
      narrator: json['narrator'] as String,
      narratorBengali: json['narratorBengali'] as String,
      grade: json['grade'] as String,
      gradeBengali: json['gradeBengali'] as String,
      topics: List<String>.from(json['topics']),
      topicsBengali: List<String>.from(json['topicsBengali']),
      explanation: json['explanation'] as String,
      explanationBengali: json['explanationBengali'] as String,
      isBookmarked: json['isBookmarked'] as bool,
      lastReadAt: DateTime.parse(json['lastReadAt'] as String),
      readCount: json['readCount'] as int,
      audioUrl: json['audioUrl'] as String,
      arabicAudioUrl: json['arabicAudioUrl'] as String,
      bengaliAudioUrl: json['bengaliAudioUrl'] as String,
      englishAudioUrl: json['englishAudioUrl'] as String,
      urduAudioUrl: json['urduAudioUrl'] as String,
      metadata: Map<String, dynamic>.from(json['metadata']),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Hadith && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Hadith(id: $id, hadithNumber: $hadithNumber, collection: $collection)';
  }
}

/// Hadith Collection entity
class HadithCollection {
  final String id;
  final String name;
  final String nameBengali;
  final String nameArabic;
  final String nameEnglish;
  final String nameUrdu;
  final String description;
  final String descriptionBengali;
  final int totalHadiths;
  final String author;
  final String authorBengali;
  final String grade;
  final String gradeBengali;
  final List<String> books;
  final List<String> booksBengali;
  final String coverImage;
  final bool isAvailable;

  const HadithCollection({
    required this.id,
    required this.name,
    required this.nameBengali,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameUrdu,
    required this.description,
    required this.descriptionBengali,
    required this.totalHadiths,
    required this.author,
    required this.authorBengali,
    required this.grade,
    required this.gradeBengali,
    required this.books,
    required this.booksBengali,
    required this.coverImage,
    required this.isAvailable,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameBengali': nameBengali,
      'nameArabic': nameArabic,
      'nameEnglish': nameEnglish,
      'nameUrdu': nameUrdu,
      'description': description,
      'descriptionBengali': descriptionBengali,
      'totalHadiths': totalHadiths,
      'author': author,
      'authorBengali': authorBengali,
      'grade': grade,
      'gradeBengali': gradeBengali,
      'books': books,
      'booksBengali': booksBengali,
      'coverImage': coverImage,
      'isAvailable': isAvailable,
    };
  }

  factory HadithCollection.fromJson(Map<String, dynamic> json) {
    return HadithCollection(
      id: json['id'] as String,
      name: json['name'] as String,
      nameBengali: json['nameBengali'] as String,
      nameArabic: json['nameArabic'] as String,
      nameEnglish: json['nameEnglish'] as String,
      nameUrdu: json['nameUrdu'] as String,
      description: json['description'] as String,
      descriptionBengali: json['descriptionBengali'] as String,
      totalHadiths: json['totalHadiths'] as int,
      author: json['author'] as String,
      authorBengali: json['authorBengali'] as String,
      grade: json['grade'] as String,
      gradeBengali: json['gradeBengali'] as String,
      books: List<String>.from(json['books']),
      booksBengali: List<String>.from(json['booksBengali']),
      coverImage: json['coverImage'] as String,
      isAvailable: json['isAvailable'] as bool,
    );
  }
}

/// Hadith Search Result
class HadithSearchResult {
  final List<Hadith> hadiths;
  final int totalResults;
  final int currentPage;
  final int totalPages;
  final String query;
  final List<String> filters;

  const HadithSearchResult({
    required this.hadiths,
    required this.totalResults,
    required this.currentPage,
    required this.totalPages,
    required this.query,
    required this.filters,
  });

  Map<String, dynamic> toJson() {
    return {
      'hadiths': hadiths.map((h) => h.toJson()).toList(),
      'totalResults': totalResults,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'query': query,
      'filters': filters,
    };
  }

  factory HadithSearchResult.fromJson(Map<String, dynamic> json) {
    return HadithSearchResult(
      hadiths: (json['hadiths'] as List)
          .map((h) => Hadith.fromJson(h as Map<String, dynamic>))
          .toList(),
      totalResults: json['totalResults'] as int,
      currentPage: json['currentPage'] as int,
      totalPages: json['totalPages'] as int,
      query: json['query'] as String,
      filters: List<String>.from(json['filters']),
    );
  }
}

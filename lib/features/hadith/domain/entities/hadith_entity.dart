/// Enhanced Hadith entity for comprehensive hadith display and functionality
class HadithEntity {
  final String id;
  final String hadithNumber;
  final String arabicText;
  final String bengaliText;
  final String englishText;
  final String urduText;
  final String bookId;
  final String bookName;
  final String bookNameBengali;
  final String bookShortName; // B, M, N, A, T, I, Ma
  final String chapterName;
  final String chapterNameBengali;
  final String chapterNumber;
  final String narrator;
  final String narratorBengali;
  final String grade;
  final String gradeBengali;
  final String gradeColor; // For UI color coding
  final List<String> topics;
  final List<String> topicsBengali;
  final String explanation;
  final String explanationBengali;
  final String reference;
  final String referenceBengali;
  final bool isBookmarked;
  final DateTime? lastReadAt;
  final int readCount;
  final String audioUrl;
  final String arabicAudioUrl;
  final String bengaliAudioUrl;
  final String englishAudioUrl;
  final String urduAudioUrl;
  final List<String> keywords;
  final List<String> keywordsBengali;
  final Map<String, dynamic> metadata;

  const HadithEntity({
    required this.id,
    required this.hadithNumber,
    required this.arabicText,
    required this.bengaliText,
    required this.englishText,
    required this.urduText,
    required this.bookId,
    required this.bookName,
    required this.bookNameBengali,
    required this.bookShortName,
    required this.chapterName,
    required this.chapterNameBengali,
    required this.chapterNumber,
    required this.narrator,
    required this.narratorBengali,
    required this.grade,
    required this.gradeBengali,
    required this.gradeColor,
    required this.topics,
    required this.topicsBengali,
    required this.explanation,
    required this.explanationBengali,
    required this.reference,
    required this.referenceBengali,
    this.isBookmarked = false,
    this.lastReadAt,
    this.readCount = 0,
    this.audioUrl = '',
    this.arabicAudioUrl = '',
    this.bengaliAudioUrl = '',
    this.englishAudioUrl = '',
    this.urduAudioUrl = '',
    this.keywords = const [],
    this.keywordsBengali = const [],
    this.metadata = const {},
  });

  HadithEntity copyWith({
    String? id,
    String? hadithNumber,
    String? arabicText,
    String? bengaliText,
    String? englishText,
    String? urduText,
    String? bookId,
    String? bookName,
    String? bookNameBengali,
    String? bookShortName,
    String? chapterName,
    String? chapterNameBengali,
    String? chapterNumber,
    String? narrator,
    String? narratorBengali,
    String? grade,
    String? gradeBengali,
    String? gradeColor,
    List<String>? topics,
    List<String>? topicsBengali,
    String? explanation,
    String? explanationBengali,
    String? reference,
    String? referenceBengali,
    bool? isBookmarked,
    DateTime? lastReadAt,
    int? readCount,
    String? audioUrl,
    String? arabicAudioUrl,
    String? bengaliAudioUrl,
    String? englishAudioUrl,
    String? urduAudioUrl,
    List<String>? keywords,
    List<String>? keywordsBengali,
    Map<String, dynamic>? metadata,
  }) {
    return HadithEntity(
      id: id ?? this.id,
      hadithNumber: hadithNumber ?? this.hadithNumber,
      arabicText: arabicText ?? this.arabicText,
      bengaliText: bengaliText ?? this.bengaliText,
      englishText: englishText ?? this.englishText,
      urduText: urduText ?? this.urduText,
      bookId: bookId ?? this.bookId,
      bookName: bookName ?? this.bookName,
      bookNameBengali: bookNameBengali ?? this.bookNameBengali,
      bookShortName: bookShortName ?? this.bookShortName,
      chapterName: chapterName ?? this.chapterName,
      chapterNameBengali: chapterNameBengali ?? this.chapterNameBengali,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      narrator: narrator ?? this.narrator,
      narratorBengali: narratorBengali ?? this.narratorBengali,
      grade: grade ?? this.grade,
      gradeBengali: gradeBengali ?? this.gradeBengali,
      gradeColor: gradeColor ?? this.gradeColor,
      topics: topics ?? this.topics,
      topicsBengali: topicsBengali ?? this.topicsBengali,
      explanation: explanation ?? this.explanation,
      explanationBengali: explanationBengali ?? this.explanationBengali,
      reference: reference ?? this.reference,
      referenceBengali: referenceBengali ?? this.referenceBengali,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      readCount: readCount ?? this.readCount,
      audioUrl: audioUrl ?? this.audioUrl,
      arabicAudioUrl: arabicAudioUrl ?? this.arabicAudioUrl,
      bengaliAudioUrl: bengaliAudioUrl ?? this.bengaliAudioUrl,
      englishAudioUrl: englishAudioUrl ?? this.englishAudioUrl,
      urduAudioUrl: urduAudioUrl ?? this.urduAudioUrl,
      keywords: keywords ?? this.keywords,
      keywordsBengali: keywordsBengali ?? this.keywordsBengali,
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
      'bookId': bookId,
      'bookName': bookName,
      'bookNameBengali': bookNameBengali,
      'bookShortName': bookShortName,
      'chapterName': chapterName,
      'chapterNameBengali': chapterNameBengali,
      'chapterNumber': chapterNumber,
      'narrator': narrator,
      'narratorBengali': narratorBengali,
      'grade': grade,
      'gradeBengali': gradeBengali,
      'gradeColor': gradeColor,
      'topics': topics,
      'topicsBengali': topicsBengali,
      'explanation': explanation,
      'explanationBengali': explanationBengali,
      'reference': reference,
      'referenceBengali': referenceBengali,
      'isBookmarked': isBookmarked,
      'lastReadAt': lastReadAt?.toIso8601String(),
      'readCount': readCount,
      'audioUrl': audioUrl,
      'arabicAudioUrl': arabicAudioUrl,
      'bengaliAudioUrl': bengaliAudioUrl,
      'englishAudioUrl': englishAudioUrl,
      'urduAudioUrl': urduAudioUrl,
      'keywords': keywords,
      'keywordsBengali': keywordsBengali,
      'metadata': metadata,
    };
  }

  factory HadithEntity.fromJson(Map<String, dynamic> json) {
    return HadithEntity(
      id: json['id'] ?? '',
      hadithNumber: json['hadithNumber'] ?? '',
      arabicText: json['arabicText'] ?? '',
      bengaliText: json['bengaliText'] ?? '',
      englishText: json['englishText'] ?? '',
      urduText: json['urduText'] ?? '',
      bookId: json['bookId'] ?? '',
      bookName: json['bookName'] ?? '',
      bookNameBengali: json['bookNameBengali'] ?? '',
      bookShortName: json['bookShortName'] ?? '',
      chapterName: json['chapterName'] ?? '',
      chapterNameBengali: json['chapterNameBengali'] ?? '',
      chapterNumber: json['chapterNumber'] ?? '',
      narrator: json['narrator'] ?? '',
      narratorBengali: json['narratorBengali'] ?? '',
      grade: json['grade'] ?? '',
      gradeBengali: json['gradeBengali'] ?? '',
      gradeColor: json['gradeColor'] ?? '#4CAF50',
      topics: List<String>.from(json['topics'] ?? []),
      topicsBengali: List<String>.from(json['topicsBengali'] ?? []),
      explanation: json['explanation'] ?? '',
      explanationBengali: json['explanationBengali'] ?? '',
      reference: json['reference'] ?? '',
      referenceBengali: json['referenceBengali'] ?? '',
      isBookmarked: json['isBookmarked'] ?? false,
      lastReadAt: json['lastReadAt'] != null ? DateTime.parse(json['lastReadAt']) : null,
      readCount: json['readCount'] ?? 0,
      audioUrl: json['audioUrl'] ?? '',
      arabicAudioUrl: json['arabicAudioUrl'] ?? '',
      bengaliAudioUrl: json['bengaliAudioUrl'] ?? '',
      englishAudioUrl: json['englishAudioUrl'] ?? '',
      urduAudioUrl: json['urduAudioUrl'] ?? '',
      keywords: List<String>.from(json['keywords'] ?? []),
      keywordsBengali: List<String>.from(json['keywordsBengali'] ?? []),
      metadata: json['metadata'] ?? {},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HadithEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'HadithEntity(id: $id, hadithNumber: $hadithNumber, book: $bookName)';
  }
}

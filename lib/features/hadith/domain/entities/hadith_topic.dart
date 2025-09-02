/// Hadith Topic for subject-wise categorization
class HadithTopic {
  final String id;
  final String name;
  final String nameBengali;
  final String nameArabic;
  final String nameUrdu;
  final String description;
  final String descriptionBengali;
  final int totalHadiths;
  final String iconName;
  final String colorCode;
  final bool isPopular;
  final int order;
  final List<String> keywords;
  final List<String> keywordsBengali;
  final Map<String, dynamic> metadata;

  const HadithTopic({
    required this.id,
    required this.name,
    required this.nameBengali,
    required this.nameArabic,
    required this.nameUrdu,
    required this.description,
    required this.descriptionBengali,
    required this.totalHadiths,
    this.iconName = 'book',
    this.colorCode = '#4CAF50',
    this.isPopular = false,
    this.order = 0,
    this.keywords = const [],
    this.keywordsBengali = const [],
    this.metadata = const {},
  });

  HadithTopic copyWith({
    String? id,
    String? name,
    String? nameBengali,
    String? nameArabic,
    String? nameUrdu,
    String? description,
    String? descriptionBengali,
    int? totalHadiths,
    String? iconName,
    String? colorCode,
    bool? isPopular,
    int? order,
    List<String>? keywords,
    List<String>? keywordsBengali,
    Map<String, dynamic>? metadata,
  }) {
    return HadithTopic(
      id: id ?? this.id,
      name: name ?? this.name,
      nameBengali: nameBengali ?? this.nameBengali,
      nameArabic: nameArabic ?? this.nameArabic,
      nameUrdu: nameUrdu ?? this.nameUrdu,
      description: description ?? this.description,
      descriptionBengali: descriptionBengali ?? this.descriptionBengali,
      totalHadiths: totalHadiths ?? this.totalHadiths,
      iconName: iconName ?? this.iconName,
      colorCode: colorCode ?? this.colorCode,
      isPopular: isPopular ?? this.isPopular,
      order: order ?? this.order,
      keywords: keywords ?? this.keywords,
      keywordsBengali: keywordsBengali ?? this.keywordsBengali,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameBengali': nameBengali,
      'nameArabic': nameArabic,
      'nameUrdu': nameUrdu,
      'description': description,
      'descriptionBengali': descriptionBengali,
      'totalHadiths': totalHadiths,
      'iconName': iconName,
      'colorCode': colorCode,
      'isPopular': isPopular,
      'order': order,
      'keywords': keywords,
      'keywordsBengali': keywordsBengali,
      'metadata': metadata,
    };
  }

  factory HadithTopic.fromJson(Map<String, dynamic> json) {
    return HadithTopic(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameBengali: json['nameBengali'] ?? '',
      nameArabic: json['nameArabic'] ?? '',
      nameUrdu: json['nameUrdu'] ?? '',
      description: json['description'] ?? '',
      descriptionBengali: json['descriptionBengali'] ?? '',
      totalHadiths: json['totalHadiths'] ?? 0,
      iconName: json['iconName'] ?? 'book',
      colorCode: json['colorCode'] ?? '#4CAF50',
      isPopular: json['isPopular'] ?? false,
      order: json['order'] ?? 0,
      keywords: List<String>.from(json['keywords'] ?? []),
      keywordsBengali: List<String>.from(json['keywordsBengali'] ?? []),
      metadata: json['metadata'] ?? {},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HadithTopic && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'HadithTopic(id: $id, name: $name, totalHadiths: $totalHadiths)';
  }
}

/// Search filter for hadith searches
class HadithSearchFilter {
  final List<String> bookIds;
  final List<String> grades;
  final List<String> topicIds;
  final List<String> narrators;
  final String? language;
  final DateTime? fromDate;
  final DateTime? toDate;
  final bool exactMatch;
  final bool searchInArabic;
  final bool searchInTranslation;
  final Map<String, dynamic> metadata;

  const HadithSearchFilter({
    this.bookIds = const [],
    this.grades = const [],
    this.topicIds = const [],
    this.narrators = const [],
    this.language,
    this.fromDate,
    this.toDate,
    this.exactMatch = false,
    this.searchInArabic = true,
    this.searchInTranslation = true,
    this.metadata = const {},
  });

  HadithSearchFilter copyWith({
    List<String>? bookIds,
    List<String>? grades,
    List<String>? topicIds,
    List<String>? narrators,
    String? language,
    DateTime? fromDate,
    DateTime? toDate,
    bool? exactMatch,
    bool? searchInArabic,
    bool? searchInTranslation,
    Map<String, dynamic>? metadata,
  }) {
    return HadithSearchFilter(
      bookIds: bookIds ?? this.bookIds,
      grades: grades ?? this.grades,
      topicIds: topicIds ?? this.topicIds,
      narrators: narrators ?? this.narrators,
      language: language ?? this.language,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      exactMatch: exactMatch ?? this.exactMatch,
      searchInArabic: searchInArabic ?? this.searchInArabic,
      searchInTranslation: searchInTranslation ?? this.searchInTranslation,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookIds': bookIds,
      'grades': grades,
      'topicIds': topicIds,
      'narrators': narrators,
      'language': language,
      'fromDate': fromDate?.toIso8601String(),
      'toDate': toDate?.toIso8601String(),
      'exactMatch': exactMatch,
      'searchInArabic': searchInArabic,
      'searchInTranslation': searchInTranslation,
      'metadata': metadata,
    };
  }

  factory HadithSearchFilter.fromJson(Map<String, dynamic> json) {
    return HadithSearchFilter(
      bookIds: List<String>.from(json['bookIds'] ?? []),
      grades: List<String>.from(json['grades'] ?? []),
      topicIds: List<String>.from(json['topicIds'] ?? []),
      narrators: List<String>.from(json['narrators'] ?? []),
      language: json['language'],
      fromDate: json['fromDate'] != null ? DateTime.parse(json['fromDate']) : null,
      toDate: json['toDate'] != null ? DateTime.parse(json['toDate']) : null,
      exactMatch: json['exactMatch'] ?? false,
      searchInArabic: json['searchInArabic'] ?? true,
      searchInTranslation: json['searchInTranslation'] ?? true,
      metadata: json['metadata'] ?? {},
    );
  }
}

/// Hadith Book entity representing collections like Sahih Bukhari, Sahih Muslim etc.
class HadithBook {
  final String id;
  final String name;
  final String nameBengali;
  final String nameArabic;
  final String nameUrdu;
  final String shortName; // B, M, N, A, T, I, Ma
  final String description;
  final String descriptionBengali;
  final int totalHadiths;
  final String compiler;
  final String compilerBengali;
  final String coverImageUrl;
  final bool isPopular;
  final int order;
  final Map<String, dynamic> metadata;

  const HadithBook({
    required this.id,
    required this.name,
    required this.nameBengali,
    required this.nameArabic,
    required this.nameUrdu,
    required this.shortName,
    required this.description,
    required this.descriptionBengali,
    required this.totalHadiths,
    required this.compiler,
    required this.compilerBengali,
    this.coverImageUrl = '',
    this.isPopular = false,
    this.order = 0,
    this.metadata = const {},
  });

  HadithBook copyWith({
    String? id,
    String? name,
    String? nameBengali,
    String? nameArabic,
    String? nameUrdu,
    String? shortName,
    String? description,
    String? descriptionBengali,
    int? totalHadiths,
    String? compiler,
    String? compilerBengali,
    String? coverImageUrl,
    bool? isPopular,
    int? order,
    Map<String, dynamic>? metadata,
  }) {
    return HadithBook(
      id: id ?? this.id,
      name: name ?? this.name,
      nameBengali: nameBengali ?? this.nameBengali,
      nameArabic: nameArabic ?? this.nameArabic,
      nameUrdu: nameUrdu ?? this.nameUrdu,
      shortName: shortName ?? this.shortName,
      description: description ?? this.description,
      descriptionBengali: descriptionBengali ?? this.descriptionBengali,
      totalHadiths: totalHadiths ?? this.totalHadiths,
      compiler: compiler ?? this.compiler,
      compilerBengali: compilerBengali ?? this.compilerBengali,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      isPopular: isPopular ?? this.isPopular,
      order: order ?? this.order,
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
      'shortName': shortName,
      'description': description,
      'descriptionBengali': descriptionBengali,
      'totalHadiths': totalHadiths,
      'compiler': compiler,
      'compilerBengali': compilerBengali,
      'coverImageUrl': coverImageUrl,
      'isPopular': isPopular,
      'order': order,
      'metadata': metadata,
    };
  }

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nameBengali: json['nameBengali'] ?? '',
      nameArabic: json['nameArabic'] ?? '',
      nameUrdu: json['nameUrdu'] ?? '',
      shortName: json['shortName'] ?? '',
      description: json['description'] ?? '',
      descriptionBengali: json['descriptionBengali'] ?? '',
      totalHadiths: json['totalHadiths'] ?? 0,
      compiler: json['compiler'] ?? '',
      compilerBengali: json['compilerBengali'] ?? '',
      coverImageUrl: json['coverImageUrl'] ?? '',
      isPopular: json['isPopular'] ?? false,
      order: json['order'] ?? 0,
      metadata: json['metadata'] ?? {},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HadithBook && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'HadithBook(id: $id, name: $name, totalHadiths: $totalHadiths)';
  }
}

import 'package:json_annotation/json_annotation.dart';

part 'chapter_dto.g.dart';

/// Data Transfer Object for Hadith Chapter from Sunnah.com API
@JsonSerializable()
class ChapterDto {
  final String id;
  final String name;
  final String? arabicName;
  final String? englishName;
  final String? urduName;
  final String? bengaliName;
  final String? description;
  final String? arabicDescription;
  final String? englishDescription;
  final String? urduDescription;
  final String? bengaliDescription;
  final int? hadithCount;
  final String? bookId;
  final String? collectionId;
  final int? chapterNumber;
  final Map<String, dynamic>? metadata;

  const ChapterDto({
    required this.id,
    required this.name,
    this.arabicName,
    this.englishName,
    this.urduName,
    this.bengaliName,
    this.description,
    this.arabicDescription,
    this.englishDescription,
    this.urduDescription,
    this.bengaliDescription,
    this.hadithCount,
    this.bookId,
    this.collectionId,
    this.chapterNumber,
    this.metadata,
  });

  factory ChapterDto.fromJson(Map<String, dynamic> json) =>
      _$ChapterDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChapterDtoToJson(this);

  @override
  String toString() {
    return 'ChapterDto(id: $id, name: $name, hadithCount: $hadithCount, chapterNumber: $chapterNumber)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChapterDto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

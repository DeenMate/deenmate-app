import 'package:json_annotation/json_annotation.dart';

part 'book_dto.g.dart';

/// Data Transfer Object for Hadith Book from Sunnah.com API
@JsonSerializable()
class BookDto {
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
  final int? chapterCount;
  final String? collectionId;
  final int? bookNumber;
  final Map<String, dynamic>? metadata;

  const BookDto({
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
    this.chapterCount,
    this.collectionId,
    this.bookNumber,
    this.metadata,
  });

  factory BookDto.fromJson(Map<String, dynamic> json) =>
      _$BookDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BookDtoToJson(this);

  @override
  String toString() {
    return 'BookDto(id: $id, name: $name, hadithCount: $hadithCount, chapterCount: $chapterCount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BookDto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

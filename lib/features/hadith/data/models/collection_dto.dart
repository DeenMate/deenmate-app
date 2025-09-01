import 'package:json_annotation/json_annotation.dart';

part 'collection_dto.g.dart';

/// Data Transfer Object for Hadith Collection from Sunnah.com API
@JsonSerializable()
class CollectionDto {
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
  final String? type; // 'Sahih', 'Sunan', 'Jami', etc.
  final String? author;
  final String? arabicAuthor;
  final String? englishAuthor;
  final String? urduAuthor;
  final String? bengaliAuthor;
  final bool? isAvailable;
  final String? coverImage;
  final Map<String, dynamic>? metadata;

  const CollectionDto({
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
    this.type,
    this.author,
    this.arabicAuthor,
    this.englishAuthor,
    this.urduAuthor,
    this.bengaliAuthor,
    this.isAvailable,
    this.coverImage,
    this.metadata,
  });

  factory CollectionDto.fromJson(Map<String, dynamic> json) => _$CollectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionDtoToJson(this);

  @override
  String toString() {
    return 'CollectionDto(id: $id, name: $name, hadithCount: $hadithCount, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CollectionDto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

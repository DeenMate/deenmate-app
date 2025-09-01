// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chapter_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChapterDto _$ChapterDtoFromJson(Map<String, dynamic> json) => ChapterDto(
      id: json['id'] as String,
      name: json['name'] as String,
      arabicName: json['arabicName'] as String?,
      englishName: json['englishName'] as String?,
      urduName: json['urduName'] as String?,
      bengaliName: json['bengaliName'] as String?,
      description: json['description'] as String?,
      arabicDescription: json['arabicDescription'] as String?,
      englishDescription: json['englishDescription'] as String?,
      urduDescription: json['urduDescription'] as String?,
      bengaliDescription: json['bengaliDescription'] as String?,
      hadithCount: (json['hadithCount'] as num?)?.toInt(),
      bookId: json['bookId'] as String?,
      collectionId: json['collectionId'] as String?,
      chapterNumber: (json['chapterNumber'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ChapterDtoToJson(ChapterDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'arabicName': instance.arabicName,
      'englishName': instance.englishName,
      'urduName': instance.urduName,
      'bengaliName': instance.bengaliName,
      'description': instance.description,
      'arabicDescription': instance.arabicDescription,
      'englishDescription': instance.englishDescription,
      'urduDescription': instance.urduDescription,
      'bengaliDescription': instance.bengaliDescription,
      'hadithCount': instance.hadithCount,
      'bookId': instance.bookId,
      'collectionId': instance.collectionId,
      'chapterNumber': instance.chapterNumber,
      'metadata': instance.metadata,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookDto _$BookDtoFromJson(Map<String, dynamic> json) => BookDto(
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
      chapterCount: (json['chapterCount'] as num?)?.toInt(),
      collectionId: json['collectionId'] as String?,
      bookNumber: (json['bookNumber'] as num?)?.toInt(),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$BookDtoToJson(BookDto instance) => <String, dynamic>{
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
      'chapterCount': instance.chapterCount,
      'collectionId': instance.collectionId,
      'bookNumber': instance.bookNumber,
      'metadata': instance.metadata,
    };

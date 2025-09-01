// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'collection_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CollectionDto _$CollectionDtoFromJson(Map<String, dynamic> json) =>
    CollectionDto(
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
      type: json['type'] as String?,
      author: json['author'] as String?,
      arabicAuthor: json['arabicAuthor'] as String?,
      englishAuthor: json['englishAuthor'] as String?,
      urduAuthor: json['urduAuthor'] as String?,
      bengaliAuthor: json['bengaliAuthor'] as String?,
      isAvailable: json['isAvailable'] as bool?,
      coverImage: json['coverImage'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CollectionDtoToJson(CollectionDto instance) =>
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
      'type': instance.type,
      'author': instance.author,
      'arabicAuthor': instance.arabicAuthor,
      'englishAuthor': instance.englishAuthor,
      'urduAuthor': instance.urduAuthor,
      'bengaliAuthor': instance.bengaliAuthor,
      'isAvailable': instance.isAvailable,
      'coverImage': instance.coverImage,
      'metadata': instance.metadata,
    };

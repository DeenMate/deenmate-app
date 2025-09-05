// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verse_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerseDto _$VerseDtoFromJson(Map<String, dynamic> json) => VerseDto(
      verseKey: json['verse_key'] as String,
      verseNumber: (json['verse_number'] as num).toInt(),
      textUthmani: json['text_uthmani'] as String,
      translations: (json['translations'] as List<dynamic>?)
              ?.map((e) => TranslationDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      audio: json['audio'] == null
          ? null
          : AudioDto.fromJson(json['audio'] as Map<String, dynamic>),
      sajdah: json['sajdah'] == null
          ? null
          : SajdahDto.fromJson(json['sajdah'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerseDtoToJson(VerseDto instance) => <String, dynamic>{
      'verse_key': instance.verseKey,
      'verse_number': instance.verseNumber,
      'text_uthmani': instance.textUthmani,
      'translations': instance.translations.map((e) => e.toJson()).toList(),
      'audio': instance.audio?.toJson(),
      'sajdah': instance.sajdah?.toJson(),
    };

TranslationDto _$TranslationDtoFromJson(Map<String, dynamic> json) =>
    TranslationDto(
      resourceId: (json['resource_id'] as num).toInt(),
      text: json['text'] as String,
    );

Map<String, dynamic> _$TranslationDtoToJson(TranslationDto instance) =>
    <String, dynamic>{
      'resource_id': instance.resourceId,
      'text': instance.text,
    };

AudioDto _$AudioDtoFromJson(Map<String, dynamic> json) => AudioDto(
      url: json['url'] as String,
      duration: (json['duration'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$AudioDtoToJson(AudioDto instance) => <String, dynamic>{
      'url': instance.url,
      'duration': instance.duration,
    };

SajdahDto _$SajdahDtoFromJson(Map<String, dynamic> json) => SajdahDto(
      id: (json['id'] as num).toInt(),
      verseKey: json['verse_key'] as String,
      sajdahNumber: (json['sajdah_number'] as num).toInt(),
      type: json['type'] as String,
      recommended: json['recommended'] as bool?,
      obligatory: json['obligatory'] as bool?,
    );

Map<String, dynamic> _$SajdahDtoToJson(SajdahDto instance) => <String, dynamic>{
      'id': instance.id,
      'verse_key': instance.verseKey,
      'sajdah_number': instance.sajdahNumber,
      'type': instance.type,
      'recommended': instance.recommended,
      'obligatory': instance.obligatory,
    };

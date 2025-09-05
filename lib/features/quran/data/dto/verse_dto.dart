import 'package:json_annotation/json_annotation.dart';

part 'verse_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class VerseDto {
  const VerseDto({
    required this.verseKey,
    required this.verseNumber,
    required this.textUthmani,
    this.translations = const [],
    this.audio,
    this.sajdah,
  });

  @JsonKey(name: 'verse_key')
  final String verseKey; // e.g., 1:1
  @JsonKey(name: 'verse_number')
  final int verseNumber; // within surah
  @JsonKey(name: 'text_uthmani')
  final String textUthmani;
  final List<TranslationDto> translations;
  final AudioDto? audio;
  final SajdahDto? sajdah; // Sajdah information if this verse requires prostration

  factory VerseDto.fromJson(Map<String, dynamic> json) =>
      _$VerseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$VerseDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class TranslationDto {
  const TranslationDto({
    required this.resourceId,
    required this.text,
  });

  @JsonKey(name: 'resource_id')
  final int resourceId;
  final String text;
  // language_name is not always provided by the API; omit for compatibility

  factory TranslationDto.fromJson(Map<String, dynamic> json) =>
      _$TranslationDtoFromJson(json);
  Map<String, dynamic> toJson() => _$TranslationDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AudioDto {
  const AudioDto({required this.url, this.duration});
  final String url;
  final double? duration;

  factory AudioDto.fromJson(Map<String, dynamic> json) =>
      _$AudioDtoFromJson(json);
  Map<String, dynamic> toJson() => _$AudioDtoToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SajdahDto {
  const SajdahDto({
    required this.id,
    required this.verseKey,
    required this.sajdahNumber,
    required this.type,
    this.recommended,
    this.obligatory,
  });

  final int id;
  @JsonKey(name: 'verse_key')
  final String verseKey;
  @JsonKey(name: 'sajdah_number')
  final int sajdahNumber; // 1-15 (there are 15 sajdah verses in Quran)
  final String type; // 'recommended' or 'obligatory'
  final bool? recommended; // Whether this is a recommended sajdah
  final bool? obligatory; // Whether this is an obligatory sajdah

  factory SajdahDto.fromJson(Map<String, dynamic> json) =>
      _$SajdahDtoFromJson(json);
  Map<String, dynamic> toJson() => _$SajdahDtoToJson(this);
}

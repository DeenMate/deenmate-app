import 'package:json_annotation/json_annotation.dart';

part 'hadith_dto.g.dart';

/// Data Transfer Object for Hadith from Sunnah.com API
@JsonSerializable()
class HadithDto {
  final String id;
  final String hadithNumber;
  final String arabicText;
  final String? englishText;
  final String? urduText;
  final String? bengaliText;
  final String collectionId;
  final String? bookId;
  final String? chapterId;
  final String? bookName;
  final String? bookNameBengali;
  final String? chapterName;
  final String? chapterNameBengali;
  final String? narrator;
  final String? narratorBengali;
  final String? grade;
  final String? gradeBengali;
  final List<String>? topics;
  final List<String>? topicsBengali;
  final String? explanation;
  final String? explanationBengali;
  final String? audioUrl;
  final String? arabicAudioUrl;
  final String? bengaliAudioUrl;
  final String? englishAudioUrl;
  final String? urduAudioUrl;
  final Map<String, dynamic>? metadata;

  const HadithDto({
    required this.id,
    required this.hadithNumber,
    required this.arabicText,
    this.englishText,
    this.urduText,
    this.bengaliText,
    required this.collectionId,
    this.bookId,
    this.chapterId,
    this.bookName,
    this.bookNameBengali,
    this.chapterName,
    this.chapterNameBengali,
    this.narrator,
    this.narratorBengali,
    this.grade,
    this.gradeBengali,
    this.topics,
    this.topicsBengali,
    this.explanation,
    this.explanationBengali,
    this.audioUrl,
    this.arabicAudioUrl,
    this.bengaliAudioUrl,
    this.englishAudioUrl,
    this.urduAudioUrl,
    this.metadata,
  });

  factory HadithDto.fromJson(Map<String, dynamic> json) => _$HadithDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HadithDtoToJson(this);

  @override
  String toString() {
    return 'HadithDto(id: $id, hadithNumber: $hadithNumber, collectionId: $collectionId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HadithDto && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

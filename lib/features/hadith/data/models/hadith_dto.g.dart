// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hadith_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HadithDto _$HadithDtoFromJson(Map<String, dynamic> json) => HadithDto(
      id: json['id'] as String,
      hadithNumber: json['hadithNumber'] as String,
      arabicText: json['arabicText'] as String,
      englishText: json['englishText'] as String?,
      urduText: json['urduText'] as String?,
      bengaliText: json['bengaliText'] as String?,
      collectionId: json['collectionId'] as String,
      bookId: json['bookId'] as String?,
      chapterId: json['chapterId'] as String?,
      bookName: json['bookName'] as String?,
      bookNameBengali: json['bookNameBengali'] as String?,
      chapterName: json['chapterName'] as String?,
      chapterNameBengali: json['chapterNameBengali'] as String?,
      narrator: json['narrator'] as String?,
      narratorBengali: json['narratorBengali'] as String?,
      grade: json['grade'] as String?,
      gradeBengali: json['gradeBengali'] as String?,
      topics:
          (json['topics'] as List<dynamic>?)?.map((e) => e as String).toList(),
      topicsBengali: (json['topicsBengali'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      explanation: json['explanation'] as String?,
      explanationBengali: json['explanationBengali'] as String?,
      audioUrl: json['audioUrl'] as String?,
      arabicAudioUrl: json['arabicAudioUrl'] as String?,
      bengaliAudioUrl: json['bengaliAudioUrl'] as String?,
      englishAudioUrl: json['englishAudioUrl'] as String?,
      urduAudioUrl: json['urduAudioUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$HadithDtoToJson(HadithDto instance) => <String, dynamic>{
      'id': instance.id,
      'hadithNumber': instance.hadithNumber,
      'arabicText': instance.arabicText,
      'englishText': instance.englishText,
      'urduText': instance.urduText,
      'bengaliText': instance.bengaliText,
      'collectionId': instance.collectionId,
      'bookId': instance.bookId,
      'chapterId': instance.chapterId,
      'bookName': instance.bookName,
      'bookNameBengali': instance.bookNameBengali,
      'chapterName': instance.chapterName,
      'chapterNameBengali': instance.chapterNameBengali,
      'narrator': instance.narrator,
      'narratorBengali': instance.narratorBengali,
      'grade': instance.grade,
      'gradeBengali': instance.gradeBengali,
      'topics': instance.topics,
      'topicsBengali': instance.topicsBengali,
      'explanation': instance.explanation,
      'explanationBengali': instance.explanationBengali,
      'audioUrl': instance.audioUrl,
      'arabicAudioUrl': instance.arabicAudioUrl,
      'bengaliAudioUrl': instance.bengaliAudioUrl,
      'englishAudioUrl': instance.englishAudioUrl,
      'urduAudioUrl': instance.urduAudioUrl,
      'metadata': instance.metadata,
    };

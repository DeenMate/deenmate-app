import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deen_mate/features/quran/data/dto/chapter_dto.dart';
import 'package:deen_mate/features/quran/data/dto/verse_dto.dart';

void main() {
  group('Quran Repository Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Chapter DTO Tests', () {
      test('should create ChapterDto from JSON', () {
        // Arrange
        final json = {
          'id': 1,
          'name_arabic': 'الفاتحة',
          'name_simple': 'Al-Fatiha',
          'verses_count': 7,
          'revelation_place': 'Meccan',
        };

        // Act
        final chapter = ChapterDto.fromJson(json);

        // Assert
        expect(chapter.id, equals(1));
        expect(chapter.nameArabic, equals('الفاتحة'));
        expect(chapter.nameSimple, equals('Al-Fatiha'));
        expect(chapter.versesCount, equals(7));
        expect(chapter.revelationPlace, equals('Meccan'));
      });

      test('should convert ChapterDto to JSON', () {
        // Arrange
        final chapter = ChapterDto(
          id: 1,
          nameArabic: 'الفاتحة',
          nameSimple: 'Al-Fatiha',
          versesCount: 7,
          revelationPlace: 'Meccan',
        );

        // Act
        final json = chapter.toJson();

        // Assert
        expect(json['id'], equals(1));
        expect(json['name_arabic'], equals('الفاتحة'));
        expect(json['name_simple'], equals('Al-Fatiha'));
        expect(json['verses_count'], equals(7));
        expect(json['revelation_place'], equals('Meccan'));
      });
    });

    group('Verse DTO Tests', () {
      test('should create VerseDto from JSON', () {
        // Arrange
        final json = {
          'verse_key': '1:1',
          'verse_number': 1,
          'text_uthmani': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          'translations': [
            {
              'resource_id': 131,
              'text':
                  'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
            }
          ],
        };

        // Act
        final verse = VerseDto.fromJson(json);

        // Assert
        expect(verse.verseKey, equals('1:1'));
        expect(verse.verseNumber, equals(1));
        expect(verse.textUthmani,
            equals('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'));
        expect(verse.translations.length, equals(1));
        expect(verse.translations[0].text, contains('Allah'));
      });

      test('should convert VerseDto to JSON', () {
        // Arrange
        final translations = [
          TranslationDto(
            resourceId: 131,
            text:
                'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
          ),
        ];

        final verse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translations: translations,
        );

        // Act
        final json = verse.toJson();

        // Assert
        expect(json['verse_key'], equals('1:1'));
        expect(json['verse_number'], equals(1));
        expect(json['text_uthmani'],
            equals('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'));
        expect(json['translations'], isA<List>());
        expect(json['translations'].length, equals(1));
      });
    });

    group('Translation DTO Tests', () {
      test('should create TranslationDto from JSON', () {
        // Arrange
        final json = {
          'resource_id': 131,
          'text':
              'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
        };

        // Act
        final translation = TranslationDto.fromJson(json);

        // Assert
        expect(translation.resourceId, equals(131));
        expect(translation.text, contains('Allah'));
      });

      test('should convert TranslationDto to JSON', () {
        // Arrange
        final translation = TranslationDto(
          resourceId: 131,
          text:
              'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
        );

        // Act
        final json = translation.toJson();

        // Assert
        expect(json['resource_id'], equals(131));
        expect(json['text'], contains('Allah'));
      });
    });

    group('Multi-language Support Tests', () {
      test('should handle Bangla translation', () {
        // Arrange
        final banglaTranslation = TranslationDto(
          resourceId: 95,
          text: 'পরম করুণাময় অতি দয়ালু আল্লাহর নামে।',
        );

        // Act & Assert
        expect(banglaTranslation.text, contains('পরম করুণাময়'));
        expect(banglaTranslation.resourceId, equals(95));
      });

      test('should handle Urdu translation', () {
        // Arrange
        final urduTranslation = TranslationDto(
          resourceId: 101,
          text: 'اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے۔',
        );

        // Act & Assert
        expect(urduTranslation.text, contains('اللہ'));
        expect(urduTranslation.resourceId, equals(101));
      });
    });

    group('Data Validation Tests', () {
      test('should validate chapter ID is positive', () {
        // Arrange & Act
        final chapter = ChapterDto(
          id: 1,
          nameArabic: 'الفاتحة',
          nameSimple: 'Al-Fatiha',
          versesCount: 7,
          revelationPlace: 'Meccan',
        );

        // Assert
        expect(chapter.id, greaterThan(0));
      });

      test('should validate verse number is positive', () {
        // Arrange
        final translations = [
          TranslationDto(
            resourceId: 131,
            text: 'Test translation',
          ),
        ];

        // Act
        final verse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'Test text',
          translations: translations,
        );

        // Assert
        expect(verse.verseNumber, greaterThan(0));
      });

      test('should validate Arabic text is not empty', () {
        // Arrange
        final translations = [
          TranslationDto(
            resourceId: 131,
            text: 'Test translation',
          ),
        ];

        // Act
        final verse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translations: translations,
        );

        // Assert
        expect(verse.textUthmani, isNotEmpty);
        expect(verse.textUthmani, contains('اللَّهِ'));
      });
    });
  });
}

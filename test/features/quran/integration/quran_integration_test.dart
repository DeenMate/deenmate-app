import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deen_mate/features/quran/data/dto/chapter_dto.dart';
import 'package:deen_mate/features/quran/data/dto/verse_dto.dart';

void main() {
  group('Quran Integration Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Multi-language Quran Reading Flow', () {
      testWidgets('should display Quran in English and switch to Bangla',
          (WidgetTester tester) async {
        // Arrange
        final testChapter = ChapterDto(
          id: 1,
          nameArabic: 'الفاتحة',
          nameSimple: 'Al-Fatiha',
          versesCount: 7,
          revelationPlace: 'Meccan',
        );

        final englishVerses = [
          VerseDto(
            verseKey: '1:1',
            verseNumber: 1,
            textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            translations: [
              TranslationDto(
                resourceId: 131,
                text:
                    'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
              ),
            ],
          ),
        ];

        final banglaVerses = [
          VerseDto(
            verseKey: '1:1',
            verseNumber: 1,
            textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            translations: [
              TranslationDto(
                resourceId: 95,
                text: 'পরম করুণাময় অতি দয়ালু আল্লাহর নামে।',
              ),
            ],
          ),
        ];

        // Act - Initial English display
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildQuranReader(testChapter, englishVerses),
              ),
            ),
          ),
        );

        // Assert - English content
        expect(find.text('Al-Fatiha'),
            findsNWidgets(2)); // AppBar + Chapter header
        expect(find.text('In the name of Allah'), findsOneWidget);

        // Act - Switch to Bangla
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildQuranReader(testChapter, banglaVerses),
              ),
            ),
          ),
        );

        // Assert - Bangla content
        expect(find.text('Al-Fatiha'),
            findsNWidgets(2)); // AppBar + Chapter header
        expect(find.text('পরম করুণাময়'), findsOneWidget);
      });

      testWidgets('should handle language switching with same Arabic text',
          (WidgetTester tester) async {
        // Arrange
        final testChapter = ChapterDto(
          id: 1,
          nameArabic: 'الفاتحة',
          nameSimple: 'Al-Fatiha',
          versesCount: 7,
          revelationPlace: 'Meccan',
        );

        final testVerse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translations: [
            TranslationDto(
              resourceId: 131,
              text:
                  'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
            ),
            TranslationDto(
              resourceId: 95,
              text: 'পরম করুণাময় অতি দয়ালু আল্লাহর নামে।',
            ),
            TranslationDto(
              resourceId: 101,
              text: 'اللہ کے نام سے جو بڑا مہربان نہایت رحم والا ہے۔',
            ),
          ],
        );

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildMultiLanguageQuranReader(testChapter, [testVerse]),
              ),
            ),
          ),
        );

        // Assert - Arabic text should always be present
        expect(find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
            findsOneWidget);
        expect(find.text('In the name of Allah'), findsOneWidget);
        expect(find.text('পরম করুণাময়'), findsOneWidget);
        expect(find.text('اللہ کے نام سے'), findsOneWidget);
      });
    });

    group('Quran Reading Experience', () {
      testWidgets('should display complete chapter with multiple verses',
          (WidgetTester tester) async {
        // Arrange
        final testChapter = ChapterDto(
          id: 1,
          nameArabic: 'الفاتحة',
          nameSimple: 'Al-Fatiha',
          versesCount: 7,
          revelationPlace: 'Meccan',
        );

        final testVerses = [
          VerseDto(
            verseKey: '1:1',
            verseNumber: 1,
            textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            translations: [
              TranslationDto(
                resourceId: 131,
                text:
                    'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
              ),
            ],
          ),
          VerseDto(
            verseKey: '1:2',
            verseNumber: 2,
            textUthmani: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            translations: [
              TranslationDto(
                resourceId: 131,
                text: '[All] praise is [due] to Allah, Lord of the worlds.',
              ),
            ],
          ),
          VerseDto(
            verseKey: '1:3',
            verseNumber: 3,
            textUthmani: 'الرَّحْمَٰنِ الرَّحِيمِ',
            translations: [
              TranslationDto(
                resourceId: 131,
                text: 'The Entirely Merciful, the Especially Merciful.',
              ),
            ],
          ),
        ];

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildQuranReader(testChapter, testVerses),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Al-Fatiha'),
            findsNWidgets(2)); // AppBar + Chapter header
        expect(find.text('الفاتحة'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);
        expect(find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
            findsOneWidget);
        expect(
            find.text('الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ'), findsOneWidget);
        expect(find.text('الرَّحْمَٰنِ الرَّحِيمِ'), findsOneWidget);
        expect(find.text('In the name of Allah'), findsOneWidget);
        expect(find.text('[All] praise is [due] to Allah'), findsOneWidget);
        expect(find.text('The Entirely Merciful'), findsOneWidget);
      });

      testWidgets('should handle chapter metadata display',
          (WidgetTester tester) async {
        // Arrange
        final testChapter = ChapterDto(
          id: 2,
          nameArabic: 'البقرة',
          nameSimple: 'Al-Baqarah',
          versesCount: 286,
          revelationPlace: 'Medinan',
        );

        final testVerses = [
          VerseDto(
            verseKey: '2:1',
            verseNumber: 1,
            textUthmani: 'الٓمٓ',
            translations: [
              TranslationDto(
                resourceId: 131,
                text: 'Alif, Lam, Meem.',
              ),
            ],
          ),
        ];

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildQuranReader(testChapter, testVerses),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Al-Baqarah'),
            findsNWidgets(2)); // AppBar + Chapter header
        expect(find.text('البقرة'), findsOneWidget);
        expect(find.text('286 verses'), findsOneWidget);
        expect(find.text('Medinan'), findsOneWidget);
      });
    });

    group('Quran Navigation and Interaction', () {
      testWidgets('should handle verse navigation',
          (WidgetTester tester) async {
        // Arrange
        final testChapter = ChapterDto(
          id: 1,
          nameArabic: 'الفاتحة',
          nameSimple: 'Al-Fatiha',
          versesCount: 7,
          revelationPlace: 'Meccan',
        );

        final testVerses = [
          VerseDto(
            verseKey: '1:1',
            verseNumber: 1,
            textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            translations: [
              TranslationDto(
                resourceId: 131,
                text: 'Verse 1 translation',
              ),
            ],
          ),
          VerseDto(
            verseKey: '1:2',
            verseNumber: 2,
            textUthmani: 'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',
            translations: [
              TranslationDto(
                resourceId: 131,
                text: 'Verse 2 translation',
              ),
            ],
          ),
        ];

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildQuranReader(testChapter, testVerses),
              ),
            ),
          ),
        );

        // Assert - All verses should be visible
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('Verse 1 translation'), findsOneWidget);
        expect(find.text('Verse 2 translation'), findsOneWidget);
      });

      testWidgets('should handle empty verses gracefully',
          (WidgetTester tester) async {
        // Arrange
        final testChapter = ChapterDto(
          id: 1,
          nameArabic: 'الفاتحة',
          nameSimple: 'Al-Fatiha',
          versesCount: 7,
          revelationPlace: 'Meccan',
        );

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildQuranReader(testChapter, []),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Al-Fatiha'),
            findsNWidgets(2)); // AppBar + Chapter header
        expect(find.text('No verses available'), findsOneWidget);
      });
    });

    group('Quran Accessibility and Usability', () {
      testWidgets('should have proper semantic structure',
          (WidgetTester tester) async {
        // Arrange
        final testChapter = ChapterDto(
          id: 1,
          nameArabic: 'الفاتحة',
          nameSimple: 'Al-Fatiha',
          versesCount: 7,
          revelationPlace: 'Meccan',
        );

        final testVerses = [
          VerseDto(
            verseKey: '1:1',
            verseNumber: 1,
            textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            translations: [
              TranslationDto(
                resourceId: 131,
                text: 'Test translation',
              ),
            ],
          ),
        ];

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildAccessibleQuranReader(testChapter, testVerses),
              ),
            ),
          ),
        );

        // Assert
        expect(
            find.bySemanticsLabel('Quran Chapter Al-Fatiha'), findsOneWidget);
        expect(find.bySemanticsLabel('Verse 1'), findsOneWidget);
      });

      testWidgets('should handle different screen sizes',
          (WidgetTester tester) async {
        // Arrange
        final testChapter = ChapterDto(
          id: 1,
          nameArabic: 'الفاتحة',
          nameSimple: 'Al-Fatiha',
          versesCount: 7,
          revelationPlace: 'Meccan',
        );

        final testVerses = [
          VerseDto(
            verseKey: '1:1',
            verseNumber: 1,
            textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            translations: [
              TranslationDto(
                resourceId: 131,
                text: 'Test translation',
              ),
            ],
          ),
        ];

        // Act - Test on small screen
        tester.binding.window.physicalSizeTestValue = const Size(320, 568);
        tester.binding.window.devicePixelRatioTestValue = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildQuranReader(testChapter, testVerses),
              ),
            ),
          ),
        );

        // Assert - Content should still be visible
        expect(find.text('Al-Fatiha'),
            findsNWidgets(2)); // AppBar + Chapter header
        expect(find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
            findsOneWidget);

        // Reset screen size
        addTearDown(tester.binding.window.clearPhysicalSizeTestValue);
      });
    });
  });
}

// Helper widget for testing Quran reader
Widget _buildQuranReader(ChapterDto chapter, List<VerseDto> verses) {
  return Scaffold(
    appBar: AppBar(
      title: Text(chapter.nameSimple),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Chapter header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    chapter.nameArabic,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chapter.nameSimple,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${chapter.versesCount} verses',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        chapter.revelationPlace,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Verses
          if (verses.isNotEmpty)
            ...verses.map((verse) => _buildVerseCard(verse))
          else
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No verses available',
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

// Helper widget for testing multi-language Quran reader
Widget _buildMultiLanguageQuranReader(
    ChapterDto chapter, List<VerseDto> verses) {
  return Scaffold(
    appBar: AppBar(
      title: Text(chapter.nameSimple),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Chapter header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    chapter.nameArabic,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    chapter.nameSimple,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Verses with all translations
          ...verses.map((verse) => _buildMultiLanguageVerseCard(verse)),
        ],
      ),
    ),
  );
}

// Helper widget for testing accessible Quran reader
Widget _buildAccessibleQuranReader(ChapterDto chapter, List<VerseDto> verses) {
  return Scaffold(
    appBar: AppBar(
      title: Semantics(
        label: 'Quran Chapter ${chapter.nameSimple}',
        child: Text(chapter.nameSimple),
      ),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          // Chapter header
          Semantics(
            label: 'Quran Chapter ${chapter.nameSimple}',
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      chapter.nameArabic,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      chapter.nameSimple,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Verses
          ...verses.map((verse) => _buildAccessibleVerseCard(verse)),
        ],
      ),
    ),
  );
}

// Helper widget for building verse cards
Widget _buildVerseCard(VerseDto verse) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${verse.verseNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            verse.textUthmani,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Uthmanic',
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),
          if (verse.translations.isNotEmpty)
            ...verse.translations.map((translation) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    translation.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
        ],
      ),
    ),
  );
}

// Helper widget for building multi-language verse cards
Widget _buildMultiLanguageVerseCard(VerseDto verse) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${verse.verseNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            verse.textUthmani,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Uthmanic',
            ),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 16),
          if (verse.translations.isNotEmpty)
            ...verse.translations.map((translation) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    translation.text,
                    style: const TextStyle(fontSize: 16),
                  ),
                )),
        ],
      ),
    ),
  );
}

// Helper widget for building accessible verse cards
Widget _buildAccessibleVerseCard(VerseDto verse) {
  return Semantics(
    label: 'Verse ${verse.verseNumber}',
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Semantics(
                  label: 'Verse number ${verse.verseNumber}',
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${verse.verseNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Semantics(
              label: 'Arabic text for verse ${verse.verseNumber}',
              child: Text(
                verse.textUthmani,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Uthmanic',
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 16),
            if (verse.translations.isNotEmpty)
              ...verse.translations.map((translation) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Semantics(
                      label: 'Translation for verse ${verse.verseNumber}',
                      child: Text(
                        translation.text,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  )),
          ],
        ),
      ),
    ),
  );
}

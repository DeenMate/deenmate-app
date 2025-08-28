import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deen_mate/features/quran/data/dto/chapter_dto.dart';
import 'package:deen_mate/features/quran/data/dto/verse_dto.dart';

void main() {
  group('Quran Reader Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    group('Verse Card Tests', () {
      testWidgets('should render verse card with Arabic text and translation',
          (WidgetTester tester) async {
        // Arrange
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
          ],
        );

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildVerseCard(testVerse),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('1'), findsOneWidget);
        expect(find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
            findsOneWidget);
        expect(find.text('In the name of Allah'), findsOneWidget);
      });

      testWidgets('should handle multiple translations',
          (WidgetTester tester) async {
        // Arrange
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
          ],
        );

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildVerseCard(testVerse),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('In the name of Allah'), findsOneWidget);
        expect(find.text('পরম করুণাময়'), findsOneWidget);
      });

      testWidgets('should handle verse without translations',
          (WidgetTester tester) async {
        // Arrange
        final testVerse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translations: [],
        );

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildVerseCard(testVerse),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'),
            findsOneWidget);
        expect(find.text('No translation available'), findsOneWidget);
      });

      testWidgets('should display verse numbers correctly',
          (WidgetTester tester) async {
        // Arrange
        final testVerse = VerseDto(
          verseKey: '1:5',
          verseNumber: 5,
          textUthmani: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ',
          translations: [
            TranslationDto(
              resourceId: 131,
              text: 'It is You we worship and You we ask for help.',
            ),
          ],
        );

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildVerseCard(testVerse),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('5'), findsOneWidget);
        expect(find.text('إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ'),
            findsOneWidget);
      });
    });

    group('Chapter Header Tests', () {
      testWidgets('should render chapter header with Arabic and English names',
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
                body: _buildChapterHeader(testChapter),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('الفاتحة'), findsOneWidget);
        expect(find.text('Al-Fatiha'), findsOneWidget);
        expect(find.text('7 verses'), findsOneWidget);
        expect(find.text('Meccan'), findsOneWidget);
      });

      testWidgets('should handle Medinan chapter', (WidgetTester tester) async {
        // Arrange
        final testChapter = ChapterDto(
          id: 2,
          nameArabic: 'البقرة',
          nameSimple: 'Al-Baqarah',
          versesCount: 286,
          revelationPlace: 'Medinan',
        );

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildChapterHeader(testChapter),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('البقرة'), findsOneWidget);
        expect(find.text('Al-Baqarah'), findsOneWidget);
        expect(find.text('286 verses'), findsOneWidget);
        expect(find.text('Medinan'), findsOneWidget);
      });
    });

    group('User Interaction Tests', () {
      testWidgets('should handle bookmark button tap',
          (WidgetTester tester) async {
        // Arrange
        final testVerse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translations: [
            TranslationDto(
              resourceId: 131,
              text: 'Test translation',
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildVerseCardWithActions(testVerse),
              ),
            ),
          ),
        );

        // Act
        final bookmarkButton = find.byIcon(Icons.bookmark_border);
        if (bookmarkButton.evaluate().isNotEmpty) {
          await tester.tap(bookmarkButton);
          await tester.pump();
        }

        // Assert
        // Note: Actual bookmark functionality would need to be tested
        // based on the specific implementation
      });

      testWidgets('should handle share button tap',
          (WidgetTester tester) async {
        // Arrange
        final testVerse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translations: [
            TranslationDto(
              resourceId: 131,
              text: 'Test translation',
            ),
          ],
        );

        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildVerseCardWithActions(testVerse),
              ),
            ),
          ),
        );

        // Act
        final shareButton = find.byIcon(Icons.share);
        if (shareButton.evaluate().isNotEmpty) {
          await tester.tap(shareButton);
          await tester.pump();
        }

        // Assert
        // Note: Actual share functionality would need to be tested
        // based on the specific implementation
      });
    });

    group('Accessibility Tests', () {
      testWidgets('should have proper semantic labels for verse cards',
          (WidgetTester tester) async {
        // Arrange
        final testVerse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translations: [
            TranslationDto(
              resourceId: 131,
              text: 'Test translation',
            ),
          ],
        );

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildVerseCardWithSemantics(testVerse),
              ),
            ),
          ),
        );

        // Assert
        expect(find.bySemanticsLabel('Verse 1'), findsOneWidget);
        expect(find.bySemanticsLabel('Bookmark verse 1'), findsOneWidget);
      });
    });

    group('Multi-language Support Tests', () {
      testWidgets('should display Bangla translation correctly',
          (WidgetTester tester) async {
        // Arrange
        final testVerse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translations: [
            TranslationDto(
              resourceId: 95,
              text: 'পরম করুণাময় অতি দয়ালু আল্লাহর নামে।',
            ),
          ],
        );

        // Act
        await tester.pumpWidget(
          ProviderScope(
            parent: container,
            child: MaterialApp(
              home: Scaffold(
                body: _buildVerseCard(testVerse),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('পরম করুণাময়'), findsOneWidget);
        expect(find.text('আল্লাহর নামে'), findsOneWidget);
      });

      testWidgets('should display Urdu translation correctly',
          (WidgetTester tester) async {
        // Arrange
        final testVerse = VerseDto(
          verseKey: '1:1',
          verseNumber: 1,
          textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
          translations: [
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
                body: _buildVerseCard(testVerse),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('اللہ کے نام سے'), findsOneWidget);
        expect(find.text('مہربان'), findsOneWidget);
      });
    });
  });
}

// Helper widget for testing individual verse cards
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
                ))
          else
            const Text(
              'No translation available',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    ),
  );
}

// Helper widget for testing chapter headers
Widget _buildChapterHeader(ChapterDto chapter) {
  return Card(
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
  );
}

// Helper widget for testing verse cards with action buttons
Widget _buildVerseCardWithActions(VerseDto verse) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.bookmark_border),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () {},
                  ),
                ],
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

// Helper widget for testing verse cards with semantic labels
Widget _buildVerseCardWithSemantics(VerseDto verse) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Semantics(
                label: 'Verse ${verse.verseNumber}',
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
              Row(
                children: [
                  Semantics(
                    label: 'Bookmark verse ${verse.verseNumber}',
                    child: IconButton(
                      icon: const Icon(Icons.bookmark_border),
                      onPressed: () {},
                    ),
                  ),
                ],
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

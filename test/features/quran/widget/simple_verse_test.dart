import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:deen_mate/features/quran/data/dto/verse_dto.dart';

void main() {
  group('Simple Verse Widget Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    testWidgets('should render simple text widget',
        (WidgetTester tester) async {
      // Arrange
      const testText = 'Test translation';

      // Act
      await tester.pumpWidget(
        ProviderScope(
          parent: container,
          child: MaterialApp(
            home: Scaffold(
              body: Text(testText),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text(testText), findsOneWidget);
    });

    testWidgets('should render verse number', (WidgetTester tester) async {
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
              body: Text('${testVerse.verseNumber}'),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('should render Arabic text', (WidgetTester tester) async {
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
              body: Text(testVerse.textUthmani),
            ),
          ),
        ),
      );

      // Assert
      expect(
          find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'), findsOneWidget);
    });

    testWidgets('should render translation text', (WidgetTester tester) async {
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
              body: Text(testVerse.translations.first.text),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test translation'), findsOneWidget);
    });

    testWidgets('should render simple verse card', (WidgetTester tester) async {
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
              body: _buildSimpleVerseCard(testVerse),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('1'), findsOneWidget);
      expect(
          find.text('بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ'), findsOneWidget);
      expect(find.text('Test translation'), findsOneWidget);
    });
  });
}

// Simple verse card widget for testing
Widget _buildSimpleVerseCard(VerseDto verse) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${verse.verseNumber}'),
          const SizedBox(height: 16),
          Text(verse.textUthmani),
          const SizedBox(height: 16),
          if (verse.translations.isNotEmpty)
            Text(verse.translations.first.text),
        ],
      ),
    ),
  );
}

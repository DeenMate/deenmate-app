import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:deen_mate/features/quran/domain/services/audio_service.dart';
import 'package:deen_mate/features/quran/data/api/verses_api.dart';
import 'package:deen_mate/features/quran/data/dto/verse_dto.dart';
import 'package:deen_mate/features/quran/data/dto/verses_page_dto.dart';

import 'audio_service_test.mocks.dart';

// Generate mocks with: flutter packages pub run build_runner build
@GenerateMocks([
  Dio,
  VersesApi,
])
void main() {
  group('QuranAudioService', () {
    late QuranAudioService audioService;
    late MockDio mockDio;
    late MockVersesApi mockVersesApi;
    late SharedPreferences mockPrefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockPrefs = await SharedPreferences.getInstance();
      
      mockDio = MockDio();
      mockVersesApi = MockVersesApi();
      
      audioService = QuranAudioService(mockDio, mockVersesApi, prefs: mockPrefs);
    });

    tearDown(() async {
      try {
        await audioService.dispose();
      } catch (e) {
        // Ignore disposal errors in tests
      }
    });

    tearDown(() async {
      await audioService.dispose();
    });

    group('verse API integration', () {
      test('should fetch verses when downloading chapter', () async {
        // Arrange
        const chapterId = 1;
        const reciterId = 7;
        
        final mockVerses = [
          const VerseDto(
            verseKey: '1:1',
            verseNumber: 1,
            textUthmani: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            audio: AudioDto(url: 'https://verses.quran.com/7/1:1.mp3'),
          ),
        ];

        final mockResponse = VersesPageDto(
          verses: mockVerses,
          pagination: const PaginationDto(
            totalPages: 1,
            currentPage: 1,
          ),
        );

        when(mockVersesApi.byChapter(
          chapterId: chapterId,
          translationIds: [],
          recitationId: reciterId,
          page: 1,
          perPage: 300,
        )).thenAnswer((_) async => mockResponse);

        // Mock dio download to avoid file operations
        when(mockDio.download(
          any,
          any,
          onReceiveProgress: anyNamed('onReceiveProgress'),
          cancelToken: anyNamed('cancelToken'),
        )).thenThrow(Exception('File operation skipped in test'));

        // Act & Assert - Test that the API is called even if download fails
        try {
          await audioService.downloadChapterAudio(chapterId, reciterId, null);
        } catch (e) {
          // Expected to fail due to mocked download
        }

        // Verify the API was called with correct parameters
        verify(mockVersesApi.byChapter(
          chapterId: chapterId,
          translationIds: [],
          recitationId: reciterId,
          page: 1,
          perPage: 300,
        )).called(1);
      });

      test('should handle API errors gracefully', () async {
        // Arrange
        const chapterId = 1;
        const reciterId = 7;
        
        when(mockVersesApi.byChapter(
          chapterId: chapterId,
          translationIds: [],
          recitationId: reciterId,
          page: 1,
          perPage: 300,
        )).thenThrow(Exception('API Error'));

        // Act & Assert
        expect(
          () => audioService.downloadChapterAudio(chapterId, reciterId, null),
          throwsException,
        );
      });
    });

    group('progress persistence', () {
      test('should retrieve chapter progress from SharedPreferences', () async {
        // Arrange
        const chapterId = 1;
        const reciterId = 7;
        const progress = 0.75;

        // Manually set progress in SharedPreferences
        await mockPrefs.setDouble('audio_progress_${chapterId}_$reciterId', progress);

        // Act
        final retrievedProgress = await audioService.getChapterProgress(chapterId, reciterId);

        // Assert
        expect(retrievedProgress, equals(progress));
      });

      test('should check chapter completion from SharedPreferences', () async {
        // Arrange
        const chapterId = 1;
        const reciterId = 7;

        // Manually set completion in SharedPreferences
        await mockPrefs.setBool('audio_complete_${chapterId}_$reciterId', true);

        // Act
        final isComplete = await audioService.isChapterComplete(chapterId, reciterId);

        // Assert
        expect(isComplete, isTrue);
      });

      test('should return empty list for downloaded chapters when none exist', () async {
        // Arrange
        const reciterId = 7;

        // Act
        final downloadedChapters = await audioService.getDownloadedChapters(reciterId);

        // Assert
        expect(downloadedChapters, isEmpty);
      });

      test('should clear reciter data from SharedPreferences', () async {
        // Arrange
        const reciterId = 7;
        
        // Set some data
        await mockPrefs.setBool('audio_complete_1_$reciterId', true);
        await mockPrefs.setDouble('audio_progress_2_$reciterId', 0.5);

        // Act
        await audioService.clearReciterData(reciterId);

        // Assert
        final progress = await audioService.getChapterProgress(2, reciterId);
        final isComplete = await audioService.isChapterComplete(1, reciterId);
        expect(progress, equals(0.0));
        expect(isComplete, isFalse);
      });
    });

    group('download size estimation', () {
      test('should estimate chapter download size', () async {
        // Arrange
        const chapterId = 1;
        const reciterId = 7;
        
        final mockVerses = List.generate(7, (index) => VerseDto(
          verseKey: '1:${index + 1}',
          verseNumber: index + 1,
          textUthmani: 'Test verse',
        ));

        final mockResponse = VersesPageDto(
          verses: mockVerses,
          pagination: const PaginationDto(
            totalPages: 1,
            currentPage: 1,
          ),
        );

        when(mockVersesApi.byChapter(
          chapterId: chapterId,
          translationIds: [],
          recitationId: reciterId,
          page: 1,
          perPage: 300,
        )).thenAnswer((_) async => mockResponse);

        // Act
        final estimatedSize = await audioService.getEstimatedChapterSize(chapterId, reciterId);

        // Assert
        // 7 verses * 150KB / 1024 = ~1.025MB
        expect(estimatedSize, closeTo(1.025, 0.1));
      });

      test('should handle estimation errors gracefully', () async {
        // Arrange
        const chapterId = 1;
        const reciterId = 7;
        
        when(mockVersesApi.byChapter(
          chapterId: chapterId,
          translationIds: [],
          recitationId: reciterId,
          page: 1,
          perPage: 300,
        )).thenThrow(Exception('API Error'));

        // Act
        final estimatedSize = await audioService.getEstimatedChapterSize(chapterId, reciterId);

        // Assert
        expect(estimatedSize, equals(0.0));
      });
    });

    group('service lifecycle', () {
      test('should initialize service without errors', () async {
        // Act & Assert
        await expectLater(audioService.initialize(), completes);
      });

      test('should dispose service without errors', () async {
        // Arrange
        await audioService.initialize();

        // Act & Assert
        await expectLater(audioService.dispose(), completes);
      });
    });
  });
}

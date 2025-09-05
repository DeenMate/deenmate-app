import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/api/verses_api.dart';

/// Comprehensive audio service for Quran recitation
/// Handles playback, downloads, and offline audio management
class QuranAudioService {
  QuranAudioService(
    this._dio,
    this._versesApi, {
    SharedPreferences? prefs,
  }) : _prefs = prefs;

  final Dio _dio;
  final VersesApi _versesApi;
  SharedPreferences? _prefs;

  // In-memory cache for reciter availability
  final Map<int, bool> _reciterAvailabilityCache = {};

  /// Callback to prompt user for download when audio is not available offline
  /// Returns true if user wants to download, false to play online
  Future<bool> Function(dynamic verse)? onPromptDownload;
  final AudioPlayer _audioPlayer = AudioPlayer();
  final StreamController<AudioState> _stateController =
      StreamController<AudioState>.broadcast();
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<Duration> _durationController =
      StreamController<Duration>.broadcast();
  final StreamController<AudioDownloadProgress> _downloadController =
      StreamController<AudioDownloadProgress>.broadcast();

  // Current playback state
  AudioState _currentState = AudioState.stopped;
  List<VerseAudio> _playlist = [];
  int _currentIndex = 0;
  RepeatMode _repeatMode = RepeatMode.off;
  bool _autoAdvance = true;
  double _playbackSpeed = 1.0;
  Timer? _positionTimer;

  // Getters for streams
  Stream<AudioState> get stateStream => _stateController.stream;
  Stream<Duration> get positionStream => _positionController.stream;
  Stream<Duration> get durationStream => _durationController.stream;
  Stream<AudioDownloadProgress> get downloadStream =>
      _downloadController.stream;

  // Getters for current state
  AudioState get currentState => _currentState;
  List<VerseAudio> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  RepeatMode get repeatMode => _repeatMode;
  bool get autoAdvance => _autoAdvance;
  double get playbackSpeed => _playbackSpeed;
  VerseAudio? get currentVerse =>
      _playlist.isNotEmpty && _currentIndex < _playlist.length
          ? _playlist[_currentIndex]
          : null;

  /// Initialize the audio service
  Future<void> initialize() async {
    // Initialize SharedPreferences if not already set
    _prefs ??= await SharedPreferences.getInstance();

    await _audioPlayer.setReleaseMode(ReleaseMode.stop);

    // Listen to player state changes
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _updateState(_mapPlayerState(state));
    });

    // Listen to position changes
    _audioPlayer.onPositionChanged.listen((position) {
      _positionController.add(position);
    });

    // Listen to duration changes
    _audioPlayer.onDurationChanged.listen((duration) {
      _durationController.add(duration);
    });

    // Listen to completion
    _audioPlayer.onPlayerComplete.listen((_) {
      _onTrackComplete();
    });
  }

  /// Probe whether a reciter appears available by checking first verse of Al-Fatiha
  Future<bool> isReciterAvailable(int reciterId) async {
    // Return from cache if available
    if (_reciterAvailabilityCache.containsKey(reciterId)) {
      return _reciterAvailabilityCache[reciterId]!;
    }

    try {
      // Build a lightweight URL for 1:1
      final url = 'https://audio.qurancdn.com/$reciterId/1_1.mp3';
      final response = await _dio.head(url); // Use HEAD for efficiency
      final isAvailable = response.statusCode == 200;
      _reciterAvailabilityCache[reciterId] = isAvailable;
      return isAvailable;
    } catch (e) {
      if (kDebugMode) {
        print('Reciter availability check failed for ID $reciterId: $e');
      }
      _reciterAvailabilityCache[reciterId] = false; // Cache the failure
      return false;
    }
  }

  /// Set the playlist for playback
  Future<void> setPlaylist(List<VerseAudio> verses) async {
    _playlist = verses;
    _currentIndex = 0;
    if (kDebugMode) {
      print('Audio: Playlist set with ${verses.length} verses');
    }
  }

  /// Play a specific verse with smart online/offline handling
  Future<void> playVerse(int index) async {
    if (index < 0 || index >= _playlist.length) return;

    _currentIndex = index;
    final verse = _playlist[index];

    if (kDebugMode) {
      print('Audio: Playing verse ${verse.verseKey}');
    }

    try {
      // Check if audio is available offline
      final localPath = await _getLocalAudioPath(verse);

      if (localPath != null && File(localPath).existsSync()) {
        // Play from local file
        await _audioPlayer.play(DeviceFileSource(localPath));
        if (kDebugMode) {
          print('Audio: Playing from local file: $localPath');
        }
        _updateState(AudioState.playing);
      } else if (verse.onlineUrl != null) {
        // Check if we should prompt user for download
        if (onPromptDownload != null) {
          final shouldDownload = await onPromptDownload!(verse);

          if (shouldDownload) {
            // Download the verse audio first
            _updateState(AudioState.buffering);
            await downloadVerseAudio(verse);

            // Now play from local file
            final newLocalPath = await _getLocalAudioPath(verse);
            if (newLocalPath != null && File(newLocalPath).existsSync()) {
              await _audioPlayer.play(DeviceFileSource(newLocalPath));
              _updateState(AudioState.playing);
            } else {
              throw Exception('Failed to download verse ${verse.verseKey}');
            }
          } else {
            // User chose to play online
            await _audioPlayer.play(UrlSource(verse.onlineUrl!));
            _updateState(AudioState.playing);
          }
        } else {
          // No prompt callback, play online directly
          await _audioPlayer.play(UrlSource(verse.onlineUrl!));
          _updateState(AudioState.playing);
        }

        if (kDebugMode) {
          print('Audio: Playing from online: ${verse.onlineUrl}');
        }
      } else {
        throw Exception(
            'No audio source available for verse ${verse.verseKey}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Audio: Error playing verse ${verse.verseKey}: $e');
      }
      _updateState(AudioState.error);
    }
  }

  /// Play the current verse
  Future<void> play() async {
    if (_playlist.isEmpty) return;

    if (_currentState == AudioState.paused) {
      await _audioPlayer.resume();
    } else {
      await playVerse(_currentIndex);
    }
  }

  /// Pause playback
  Future<void> pause() async {
    await _audioPlayer.pause();
  }

  /// Stop playback
  Future<void> stop() async {
    await _audioPlayer.stop();
    _updateState(AudioState.stopped);
  }

  /// Play next verse
  Future<void> next() async {
    if (_currentIndex < _playlist.length - 1) {
      await playVerse(_currentIndex + 1);
    } else if (_repeatMode == RepeatMode.all) {
      await playVerse(0);
    }
  }

  /// Play previous verse
  Future<void> previous() async {
    if (_currentIndex > 0) {
      await playVerse(_currentIndex - 1);
    } else if (_repeatMode == RepeatMode.all) {
      await playVerse(_playlist.length - 1);
    }
  }

  /// Seek to position
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  /// Set repeat mode
  void setRepeatMode(RepeatMode mode) {
    _repeatMode = mode;
    if (kDebugMode) {
      print('Audio: Repeat mode set to $mode');
    }
  }

  /// Set auto advance
  void setAutoAdvance(bool enabled) {
    _autoAdvance = enabled;
    if (kDebugMode) {
      print('Audio: Auto advance set to $enabled');
    }
  }

  /// Set playback speed
  Future<void> setPlaybackSpeed(double speed) async {
    _playbackSpeed = speed;
    await _audioPlayer.setPlaybackRate(speed);
    if (kDebugMode) {
      print('Audio: Playback speed set to ${speed}x');
    }
  }

  /// Download verse audio for offline use
  Future<void> downloadVerseAudio(
    VerseAudio verse, {
    Function(double progress)? onProgress,
    CancelToken? cancelToken,
    int maxRetries = 3,
  }) async {
    if (verse.onlineUrl == null) {
      throw Exception('No online URL available for verse ${verse.verseKey}');
    }

    final localPath = await _getLocalAudioPath(verse);
    if (localPath == null) {
      throw Exception(
          'Could not determine local path for verse ${verse.verseKey}');
    }

    final file = File(localPath);
    if (file.existsSync()) {
      if (kDebugMode) {
        print('Audio: Verse ${verse.verseKey} already downloaded');
      }
      onProgress?.call(1.0);
      return;
    }

    int retryCount = 0;
    while (retryCount <= maxRetries) {
      try {
        // Check for cancellation
        if (cancelToken?.isCancelled == true) {
          throw DioException(
            requestOptions: RequestOptions(path: verse.onlineUrl!),
            type: DioExceptionType.cancel,
            message: 'Download cancelled',
          );
        }

        // Create directory if it doesn't exist
        await file.parent.create(recursive: true);

        if (kDebugMode) {
          print(
              'Audio: Downloading verse ${verse.verseKey} (attempt ${retryCount + 1}/${maxRetries + 1})');
        }

        // Download with progress tracking and cancellation support
        await _dio.download(
          verse.onlineUrl!,
          localPath,
          cancelToken: cancelToken,
          onReceiveProgress: (received, total) {
            if (total > 0) {
              final progress = received / total;
              onProgress?.call(progress);
              _downloadController.add(AudioDownloadProgress(
                verseKey: verse.verseKey,
                progress: progress,
                isComplete: progress >= 1.0,
                status: progress >= 1.0 ? 'Downloaded' : 'Downloading...',
              ));
            }
          },
        );

        if (kDebugMode) {
          print('Audio: Successfully downloaded verse ${verse.verseKey}');
        }
        return; // Success, exit retry loop
      } catch (e) {
        retryCount++;

        // Don't retry if cancelled
        if (e is DioException && e.type == DioExceptionType.cancel) {
          if (kDebugMode) {
            print('Audio: Download cancelled for verse ${verse.verseKey}');
          }
          rethrow;
        }

        // Clean up partial file on failure
        if (file.existsSync()) {
          try {
            await file.delete();
          } catch (_) {}
        }

        if (retryCount > maxRetries) {
          if (kDebugMode) {
            print(
                'Audio: Failed to download verse ${verse.verseKey} after $maxRetries retries: $e');
          }
          rethrow;
        }

        if (kDebugMode) {
          print(
              'Audio: Retry $retryCount for verse ${verse.verseKey} after error: $e');
        }

        // Exponential backoff: wait 1s, 2s, 4s
        await Future.delayed(Duration(seconds: 1 << (retryCount - 1)));
      }
    }
  }

  /// Download entire chapter audio
  Future<void> downloadChapterAudio(
    int chapterId,
    int reciterId,
    List<VerseAudio>? verses, {
    Function(double progress, String currentVerse)? onProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      if (kDebugMode) {
        print('Audio: Starting download for chapter $chapterId');
      }

      // Check if already complete
      if (await isChapterComplete(chapterId, reciterId)) {
        onProgress?.call(1.0, 'Already downloaded');
        return;
      }

      // Create verse list if not provided
      final verseList =
          verses ?? await _createVerseAudioList(chapterId, reciterId);

      if (verseList.isEmpty) {
        throw Exception('No verses found for chapter $chapterId');
      }

      if (kDebugMode) {
        print(
            'Audio: Downloading ${verseList.length} verses for chapter $chapterId');
      }

      // Reset progress at start
      await _saveChapterProgress(chapterId, reciterId, 0.0);

      for (int i = 0; i < verseList.length; i++) {
        // Check for cancellation
        if (cancelToken?.isCancelled == true) {
          if (kDebugMode) {
            print('Audio: Download cancelled for chapter $chapterId');
          }
          return;
        }

        final verse = verseList[i];
        final verseProgress = i / verseList.length;

        onProgress?.call(verseProgress, verse.verseKey);

        // Update downloadStream with verse-level progress
        _downloadController.add(AudioDownloadProgress(
          verseKey: verse.verseKey,
          progress: verseProgress,
          isComplete: false,
          status: 'Downloading verse ${i + 1}/${verseList.length}',
        ));

        try {
          await downloadVerseAudio(
            verse,
            cancelToken: cancelToken,
            onProgress: (progress) {
              final totalProgress = (i + progress) / verseList.length;
              onProgress?.call(totalProgress, verse.verseKey);

              // Save incremental progress
              _saveChapterProgress(chapterId, reciterId, totalProgress);
            },
          );
        } catch (e) {
          if (kDebugMode) {
            print('Audio: Error downloading verse ${verse.verseKey}: $e');
          }

          // Emit error progress
          _downloadController.add(AudioDownloadProgress(
            verseKey: verse.verseKey,
            progress: verseProgress,
            isComplete: false,
            status: 'Error: $e',
          ));

          rethrow;
        }
      }

      // Mark as complete
      await _markChapterComplete(chapterId, reciterId);
      onProgress?.call(1.0, 'Complete');

      // Emit completion
      _downloadController.add(AudioDownloadProgress(
        verseKey: 'chapter_$chapterId',
        progress: 1.0,
        isComplete: true,
        status: 'Chapter $chapterId download complete',
      ));

      if (kDebugMode) {
        print('Audio: Successfully downloaded chapter $chapterId');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Audio: Failed to download chapter $chapterId: $e');
      }

      // Emit error
      _downloadController.add(AudioDownloadProgress(
        verseKey: 'chapter_$chapterId',
        progress: 0.0,
        isComplete: false,
        status: 'Failed to download chapter: $e',
      ));

      rethrow;
    }
  }

  /// Download all Quran audio for a specific reciter
  Future<void> downloadFullQuranAudio(
    int reciterId, {
    Function(double progress, String currentChapter)? onProgress,
  }) async {
    onProgress?.call(0.0, 'Starting full Quran download...');

    // For full Quran download, we'll need to iterate through all 114 chapters
    final totalChapters = 114;

    for (int chapterId = 1; chapterId <= totalChapters; chapterId++) {
      final chapterProgress = (chapterId - 1) / totalChapters;

      onProgress?.call(chapterProgress, 'Downloading Surah $chapterId...');

      // Download chapter audio (verses will be fetched automatically)
      await downloadChapterAudio(
        chapterId,
        reciterId,
        null, // Let the method fetch verses automatically
        onProgress: (progress, verse) {
          final totalProgress = ((chapterId - 1) + progress) / totalChapters;
          onProgress?.call(totalProgress, 'Surah $chapterId - $verse');
        },
      );
    }

    onProgress?.call(1.0, 'Full Quran download complete!');
  }

  /// Helper method to create verse audio list for a chapter
  Future<List<VerseAudio>> _createVerseAudioList(
      int chapterId, int reciterId) async {
    try {
      if (kDebugMode) {
        print(
            'Audio: Creating verse list for chapter $chapterId, reciter $reciterId');
      }

      // Fetch all verses for the chapter with audio data
      final versesPage = await _versesApi.byChapter(
        chapterId: chapterId,
        translationIds: [], // We only need audio data
        recitationId: reciterId,
        page: 1,
        perPage:
            300, // Get all verses in one request (largest surah has 286 verses)
      );

      if (kDebugMode) {
        print(
            'Audio: Fetched ${versesPage.verses.length} verses for chapter $chapterId');
      }

      // Convert VerseDto to VerseAudio
      final verseAudioList = versesPage.verses.map((verseDto) {
        // Build the audio URL using the standard Quran.com pattern
        String? audioUrl;
        if (verseDto.audio?.url != null) {
          final apiUrl = verseDto.audio!.url;
          // Check if the URL is already complete or needs domain prefix
          if (apiUrl.startsWith('http')) {
            audioUrl = apiUrl;
          } else {
            // Use the pattern from providers.dart which works for audio streaming
            audioUrl = 'https://audio.qurancdn.com/$apiUrl';
          }
        } else {
          // Fallback: construct URL using standard pattern
          // Format: https://audio.qurancdn.com/{{recitation_id}}/{{verse_key}}.mp3
          audioUrl =
              'https://audio.qurancdn.com/$reciterId/${verseDto.verseKey}.mp3';
        }

        return VerseAudio(
          verseKey: verseDto.verseKey,
          chapterId: chapterId,
          verseNumber: verseDto.verseNumber,
          reciterId: reciterId,
          onlineUrl: audioUrl,
        );
      }).toList();

      if (kDebugMode) {
        print('Audio: Created ${verseAudioList.length} VerseAudio objects');
      }

      return verseAudioList;
    } catch (e) {
      if (kDebugMode) {
        print('Audio: Error creating verse list for chapter $chapterId: $e');
      }
      rethrow;
    }
  }

  /// Check if verse audio is downloaded
  Future<bool> isVerseDownloaded(VerseAudio verse) async {
    final localPath = await _getLocalAudioPath(verse);
    return localPath != null && File(localPath).existsSync();
  }

  /// Get downloaded audio size for a chapter
  Future<double> getChapterAudioSize(int chapterId, int reciterId) async {
    double totalSize = 0;
    final audioDir = await _getAudioDirectory();
    final chapterDir =
        Directory('$audioDir/reciter_$reciterId/chapter_$chapterId');

    if (chapterDir.existsSync()) {
      await for (final file in chapterDir.list()) {
        if (file is File && file.path.endsWith('.mp3')) {
          final stat = await file.stat();
          totalSize += stat.size;
        }
      }
    }

    return totalSize / (1024 * 1024); // Return size in MB
  }

  /// Delete downloaded chapter audio
  Future<void> deleteChapterAudio(int chapterId, int reciterId) async {
    final audioDir = await _getAudioDirectory();
    final chapterDir =
        Directory('$audioDir/reciter_$reciterId/chapter_$chapterId');

    if (chapterDir.existsSync()) {
      await chapterDir.delete(recursive: true);
      if (kDebugMode) {
        print('Audio: Deleted chapter $chapterId audio for reciter $reciterId');
      }
    }
  }

  /// Get storage statistics
  Future<AudioStorageStats> getStorageStats() async {
    final audioDir = await _getAudioDirectory();
    final dir = Directory(audioDir);

    if (!dir.existsSync()) {
      return AudioStorageStats(totalSizeMB: 0, fileCount: 0, chaptersCount: 0);
    }

    double totalSize = 0;
    int fileCount = 0;
    Set<int> chapters = {};

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.mp3')) {
        final stat = await entity.stat();
        totalSize += stat.size;
        fileCount++;

        // Extract chapter ID from path
        final pathParts = entity.path.split('/');
        for (final part in pathParts) {
          if (part.startsWith('chapter_')) {
            final chapterId = int.tryParse(part.substring(8));
            if (chapterId != null) {
              chapters.add(chapterId);
            }
          }
        }
      }
    }

    return AudioStorageStats(
      totalSizeMB: totalSize / (1024 * 1024),
      fileCount: fileCount,
      chaptersCount: chapters.length,
    );
  }

  // Progress persistence methods

  /// Save chapter download progress
  Future<void> _saveChapterProgress(
      int chapterId, int reciterId, double progress) async {
    if (_prefs == null) return;

    final key = 'audio_progress_${chapterId}_$reciterId';
    await _prefs!.setDouble(key, progress);

    if (kDebugMode) {
      print(
          'Audio: Saved progress for chapter $chapterId: ${(progress * 100).toStringAsFixed(1)}%');
    }
  }

  /// Get chapter download progress
  Future<double> getChapterProgress(int chapterId, int reciterId) async {
    if (_prefs == null) return 0.0;

    final key = 'audio_progress_${chapterId}_$reciterId';
    return _prefs!.getDouble(key) ?? 0.0;
  }

  /// Mark chapter as complete
  Future<void> _markChapterComplete(int chapterId, int reciterId) async {
    if (_prefs == null) return;

    final key = 'audio_complete_${chapterId}_$reciterId';
    await _prefs!.setBool(key, true);
    await _saveChapterProgress(chapterId, reciterId, 1.0);

    if (kDebugMode) {
      print('Audio: Marked chapter $chapterId as complete');
    }
  }

  /// Check if chapter is fully downloaded
  Future<bool> isChapterComplete(int chapterId, int reciterId) async {
    if (_prefs == null) return false;

    final key = 'audio_complete_${chapterId}_$reciterId';
    return _prefs!.getBool(key) ?? false;
  }

  /// Get list of all downloaded chapters for a reciter
  Future<List<int>> getDownloadedChapters(int reciterId) async {
    if (_prefs == null) return [];

    final keys = _prefs!.getKeys();
    final chapters = <int>[];

    for (final key in keys) {
      if (key.startsWith('audio_complete_') && key.endsWith('_$reciterId')) {
        final parts = key.split('_');
        if (parts.length >= 3) {
          final chapterId = int.tryParse(parts[2]);
          if (chapterId != null && _prefs!.getBool(key) == true) {
            chapters.add(chapterId);
          }
        }
      }
    }

    chapters.sort();
    return chapters;
  }

  /// Clear all progress data for a reciter
  Future<void> clearReciterData(int reciterId) async {
    if (_prefs == null) return;

    final keys = _prefs!.getKeys().toList();
    final keysToRemove = keys
        .where((key) =>
            key.contains('_$reciterId') &&
            (key.startsWith('audio_progress_') ||
                key.startsWith('audio_complete_')))
        .toList();

    for (final key in keysToRemove) {
      await _prefs!.remove(key);
    }

    if (kDebugMode) {
      print(
          'Audio: Cleared ${keysToRemove.length} data entries for reciter $reciterId');
    }
  }

  /// Get estimated download size for a chapter (in MB)
  Future<double> getEstimatedChapterSize(int chapterId, int reciterId) async {
    try {
      // Create verse audio list to get verse count
      final verses = await _createVerseAudioList(chapterId, reciterId);

      // Estimate: average verse audio file is ~150KB
      const averageVerseSizeKB = 150;
      final estimatedSizeMB = (verses.length * averageVerseSizeKB) / 1024;

      if (kDebugMode) {
        print(
            'Audio: Estimated size for chapter $chapterId: ${estimatedSizeMB.toStringAsFixed(1)} MB (${verses.length} verses)');
      }

      return estimatedSizeMB;
    } catch (e) {
      if (kDebugMode) {
        print('Audio: Error estimating chapter size: $e');
      }
      return 0.0;
    }
  }

  /// Dispose and clean up resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
    _positionTimer?.cancel();

    await _stateController.close();
    await _positionController.close();
    await _durationController.close();
    await _downloadController.close();

    if (kDebugMode) {
      print('Audio: Service disposed');
    }
  }

  // Private methods

  AudioState _mapPlayerState(PlayerState state) {
    switch (state) {
      case PlayerState.playing:
        return AudioState.playing;
      case PlayerState.paused:
        return AudioState.paused;
      case PlayerState.stopped:
        return AudioState.stopped;
      case PlayerState.completed:
        return AudioState.stopped;
      case PlayerState.disposed:
        return AudioState.stopped;
    }
  }

  void _updateState(AudioState state) {
    _currentState = state;
    _stateController.add(state);

    if (kDebugMode) {
      print('Audio: State changed to $state');
    }
  }

  void _onTrackComplete() {
    if (_repeatMode == RepeatMode.one) {
      // Repeat current verse
      playVerse(_currentIndex);
    } else if (_autoAdvance && _currentIndex < _playlist.length - 1) {
      // Auto advance to next verse
      next();
    } else if (_autoAdvance && _repeatMode == RepeatMode.all) {
      // Start over if at end and repeat all is enabled
      playVerse(0);
    } else {
      // Stop playback
      _updateState(AudioState.stopped);
    }
  }

  Future<String?> _getLocalAudioPath(VerseAudio verse) async {
    final audioDir = await _getAudioDirectory();
    return '$audioDir/reciter_${verse.reciterId}/chapter_${verse.chapterId}/${verse.verseKey.replaceAll(':', '_')}.mp3';
  }

  Future<String> _getAudioDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return '${appDir.path}/quran_audio';
  }
}

// Data classes

class VerseAudio {
  const VerseAudio({
    required this.verseKey,
    required this.chapterId,
    required this.verseNumber,
    required this.reciterId,
    this.onlineUrl,
    this.localPath,
  });

  final String verseKey;
  final int chapterId;
  final int verseNumber;
  final int reciterId;
  final String? onlineUrl;
  final String? localPath;
}

enum AudioState {
  stopped,
  playing,
  paused,
  buffering,
  error,
}

enum RepeatMode {
  off,
  one,
  all,
}

class AudioDownloadProgress {
  const AudioDownloadProgress({
    required this.verseKey,
    required this.progress,
    required this.isComplete,
    this.status,
  });

  final String verseKey;
  final double progress;
  final bool isComplete;
  final String? status;
}

class AudioStorageStats {
  const AudioStorageStats({
    required this.totalSizeMB,
    required this.fileCount,
    required this.chaptersCount,
  });

  final double totalSizeMB;
  final int fileCount;
  final int chaptersCount;
}

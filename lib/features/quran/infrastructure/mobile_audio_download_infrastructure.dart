import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../../core/utils/app_logger.dart';
import '../../domain/services/audio_service.dart' as audio_service;

/// Mobile-optimized download infrastructure for Quran audio
/// Handles offline audio downloads with progress tracking and error recovery
class MobileAudioDownloadInfrastructure {
  static const String _audioStorageDir = 'quran_audio';
  static const int _maxConcurrentDownloads = 3;
  static const int _retryAttempts = 3;
  static const Duration _downloadTimeout = Duration(minutes: 5);

  final Map<String, DownloadProgress> _downloadProgress = {};
  final Map<String, StreamController<DownloadProgress>> _progressControllers =
      {};
  final Set<String> _activeDownloads = {};
  final Queue<DownloadRequest> _downloadQueue = Queue();

  static MobileAudioDownloadInfrastructure? _instance;
  static MobileAudioDownloadInfrastructure get instance =>
      _instance ??= MobileAudioDownloadInfrastructure._();

  MobileAudioDownloadInfrastructure._();

  /// Get download progress stream for a specific verse
  Stream<DownloadProgress> getDownloadProgress(String verseKey) {
    if (!_progressControllers.containsKey(verseKey)) {
      _progressControllers[verseKey] =
          StreamController<DownloadProgress>.broadcast();
    }
    return _progressControllers[verseKey]!.stream;
  }

  /// Download audio for a single verse with progress tracking
  Future<DownloadResult> downloadVerseAudio({
    required audio_service.VerseAudio verse,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
    bool overwriteExisting = false,
  }) async {
    final verseKey = verse.verseKey;

    try {
      // Check if already downloading
      if (_activeDownloads.contains(verseKey)) {
        return DownloadResult.alreadyInProgress(verseKey);
      }

      // Check if file already exists
      final localPath =
          await _getLocalAudioPath(verseKey, reciterSlug, quality);
      if (!overwriteExisting && await File(localPath).exists()) {
        return DownloadResult.alreadyExists(verseKey, localPath);
      }

      // Add to active downloads
      _activeDownloads.add(verseKey);

      // Initialize progress
      final progress = DownloadProgress(
        verseKey: verseKey,
        status: DownloadStatus.starting,
        progress: 0.0,
        downloadedBytes: 0,
        totalBytes: 0,
      );

      _updateProgress(verseKey, progress);

      // Start download
      final result = await _performDownload(
        verse: verse,
        reciterSlug: reciterSlug,
        quality: quality,
        localPath: localPath,
        verseKey: verseKey,
      );

      // Complete download
      _activeDownloads.remove(verseKey);

      final finalProgress = progress.copyWith(
        status:
            result.success ? DownloadStatus.completed : DownloadStatus.failed,
        progress: result.success ? 1.0 : 0.0,
        error: result.error,
      );

      _updateProgress(verseKey, finalProgress);

      // Process queue
      _processDownloadQueue();

      return result;
    } catch (e) {
      _activeDownloads.remove(verseKey);

      final errorProgress = DownloadProgress(
        verseKey: verseKey,
        status: DownloadStatus.failed,
        progress: 0.0,
        downloadedBytes: 0,
        totalBytes: 0,
        error: e.toString(),
      );

      _updateProgress(verseKey, errorProgress);

      return DownloadResult.failed(verseKey, e.toString());
    }
  }

  /// Download multiple verses with queue management
  Future<BatchDownloadResult> downloadMultipleVerses({
    required List<audio_service.VerseAudio> verses,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
    bool overwriteExisting = false,
    Function(String verseKey, DownloadProgress progress)? onProgress,
  }) async {
    final results = <String, DownloadResult>{};
    final total = verses.length;
    var completed = 0;

    // Add verses to queue
    for (final verse in verses) {
      final request = DownloadRequest(
        verse: verse,
        reciterSlug: reciterSlug,
        quality: quality,
        overwriteExisting: overwriteExisting,
      );

      _downloadQueue.add(request);
    }

    // Process queue and collect results
    final completer = Completer<BatchDownloadResult>();

    // Subscribe to progress updates
    final subscriptions = <StreamSubscription>[];

    for (final verse in verses) {
      final subscription =
          getDownloadProgress(verse.verseKey).listen((progress) {
        onProgress?.call(verse.verseKey, progress);

        if (progress.status == DownloadStatus.completed ||
            progress.status == DownloadStatus.failed) {
          completed++;

          results[verse.verseKey] = progress.status == DownloadStatus.completed
              ? DownloadResult.success(verse.verseKey, progress.localPath ?? '')
              : DownloadResult.failed(
                  verse.verseKey, progress.error ?? 'Unknown error');

          if (completed == total) {
            // Clean up subscriptions
            for (final sub in subscriptions) {
              sub.cancel();
            }

            final batchResult = BatchDownloadResult(
              totalRequested: total,
              successful: results.values.where((r) => r.success).length,
              failed: results.values.where((r) => !r.success).length,
              results: results,
            );

            completer.complete(batchResult);
          }
        }
      });

      subscriptions.add(subscription);
    }

    // Start processing queue
    _processDownloadQueue();

    return completer.future;
  }

  /// Download entire Surah with progress tracking
  Future<BatchDownloadResult> downloadSurah({
    required int surahNumber,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
    bool overwriteExisting = false,
    Function(String verseKey, DownloadProgress progress)? onProgress,
  }) async {
    try {
      // Generate verse list for the surah
      final verses = await _generateSurahVerses(surahNumber);

      return downloadMultipleVerses(
        verses: verses,
        reciterSlug: reciterSlug,
        quality: quality,
        overwriteExisting: overwriteExisting,
        onProgress: onProgress,
      );
    } catch (e) {
      return BatchDownloadResult(
        totalRequested: 0,
        successful: 0,
        failed: 1,
        results: {
          'surah_$surahNumber':
              DownloadResult.failed('surah_$surahNumber', e.toString())
        },
      );
    }
  }

  /// Download popular chapters (commonly recited Surahs)
  Future<BatchDownloadResult> downloadPopularChapters({
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
    bool overwriteExisting = false,
    Function(String verseKey, DownloadProgress progress)? onProgress,
  }) async {
    // Popular Surahs: Al-Fatiha, Al-Baqarah (first 5 verses), Al-Ikhlas, Al-Falaq, An-Nas
    const popularSurahs = [1, 112, 113, 114];
    final allVerses = <audio_service.VerseAudio>[];

    for (final surahNumber in popularSurahs) {
      final verses = await _generateSurahVerses(surahNumber);
      allVerses.addAll(verses);
    }

    // Add first 5 verses of Al-Baqarah
    final baqarahVerses = await _generateSurahVerses(2, maxVerses: 5);
    allVerses.addAll(baqarahVerses);

    return downloadMultipleVerses(
      verses: allVerses,
      reciterSlug: reciterSlug,
      quality: quality,
      overwriteExisting: overwriteExisting,
      onProgress: onProgress,
    );
  }

  /// Get download statistics and storage info
  Future<DownloadStatistics> getDownloadStatistics() async {
    try {
      final storageDir = await _getStorageDirectory();
      final audioDir = Directory('${storageDir.path}/$_audioStorageDir');

      if (!await audioDir.exists()) {
        return DownloadStatistics.empty();
      }

      var totalFiles = 0;
      var totalSize = 0;
      final reciterStats = <String, ReciterStats>{};

      await for (final entity in audioDir.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.mp3')) {
          totalFiles++;
          final size = await entity.length();
          totalSize += size;

          // Extract reciter from path
          final pathParts = entity.path.split('/');
          if (pathParts.length >= 2) {
            final reciter = pathParts[pathParts.length - 2];

            if (!reciterStats.containsKey(reciter)) {
              reciterStats[reciter] = ReciterStats(
                  reciterSlug: reciter, fileCount: 0, totalSize: 0);
            }

            reciterStats[reciter] = reciterStats[reciter]!.copyWith(
              fileCount: reciterStats[reciter]!.fileCount + 1,
              totalSize: reciterStats[reciter]!.totalSize + size,
            );
          }
        }
      }

      return DownloadStatistics(
        totalFiles: totalFiles,
        totalSizeBytes: totalSize,
        reciterStats: reciterStats,
      );
    } catch (e) {
      return DownloadStatistics.empty();
    }
  }

  /// Delete downloaded audio for specific verse
  Future<bool> deleteVerseAudio({
    required String verseKey,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    try {
      final localPath =
          await _getLocalAudioPath(verseKey, reciterSlug, quality);
      final file = File(localPath);

      if (await file.exists()) {
        await file.delete();
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Error deleting verse audio: $e');
      return false;
    }
  }

  /// Delete all audio for a specific reciter
  Future<int> deleteReciterAudio(String reciterSlug) async {
    try {
      final storageDir = await _getStorageDirectory();
      final reciterDir =
          Directory('${storageDir.path}/$_audioStorageDir/$reciterSlug');

      if (!await reciterDir.exists()) {
        return 0;
      }

      var deletedCount = 0;
      await for (final entity in reciterDir.list(recursive: true)) {
        if (entity is File) {
          await entity.delete();
          deletedCount++;
        }
      }

      // Delete the directory if it's empty
      if (await reciterDir.list().isEmpty) {
        await reciterDir.delete();
      }

      return deletedCount;
    } catch (e) {
      debugPrint('Error deleting reciter audio: $e');
      return 0;
    }
  }

  /// Check if verse audio is downloaded
  Future<bool> isVerseDownloaded({
    required String verseKey,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    try {
      final localPath =
          await _getLocalAudioPath(verseKey, reciterSlug, quality);
      return await File(localPath).exists();
    } catch (e) {
      return false;
    }
  }

  /// Get local file path for verse audio
  Future<String> getLocalAudioPath({
    required String verseKey,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    return _getLocalAudioPath(verseKey, reciterSlug, quality);
  }

  // Private methods

  Future<DownloadResult> _performDownload({
    required audio_service.VerseAudio verse,
    required String reciterSlug,
    required DownloadQuality quality,
    required String localPath,
    required String verseKey,
  }) async {
    for (int attempt = 1; attempt <= _retryAttempts; attempt++) {
      try {
        // Update progress: downloading
        _updateProgress(
            verseKey,
            DownloadProgress(
              verseKey: verseKey,
              status: DownloadStatus.downloading,
              progress: 0.0,
              downloadedBytes: 0,
              totalBytes: 0,
              attempt: attempt,
            ));

        // Get download URL
        final downloadUrl = _buildDownloadUrl(verse, reciterSlug, quality);

        // Create request
        final request = http.Request('GET', Uri.parse(downloadUrl));
        final streamedResponse = await request.send().timeout(_downloadTimeout);

        if (streamedResponse.statusCode != 200) {
          throw HttpException(
              'HTTP ${streamedResponse.statusCode}: Failed to download audio');
        }

        // Prepare local file
        final file = File(localPath);
        await file.parent.create(recursive: true);
        final sink = file.openWrite();

        var downloadedBytes = 0;
        final totalBytes = streamedResponse.contentLength ?? 0;

        // Download with progress tracking
        await for (final chunk in streamedResponse.stream) {
          downloadedBytes += chunk.length;
          await sink.add(chunk);

          // Update progress
          final progress = totalBytes > 0 ? downloadedBytes / totalBytes : 0.0;

          _updateProgress(
              verseKey,
              DownloadProgress(
                verseKey: verseKey,
                status: DownloadStatus.downloading,
                progress: progress,
                downloadedBytes: downloadedBytes,
                totalBytes: totalBytes,
                attempt: attempt,
              ));
        }

        await sink.close();

        // Verify download
        if (totalBytes > 0 && downloadedBytes != totalBytes) {
          throw Exception(
              'Downloaded size mismatch: expected $totalBytes, got $downloadedBytes');
        }

        // Verify file integrity
        final fileSize = await file.length();
        if (fileSize == 0) {
          throw Exception('Downloaded file is empty');
        }

        return DownloadResult.success(verseKey, localPath);
      } catch (e) {
        debugPrint('Download attempt $attempt failed for $verseKey: $e');

        // Clean up failed download
        try {
          final file = File(localPath);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          AppLogger.warning('AudioDownload', 'Failed to clean up partial download: $localPath', error: e);
        }

        if (attempt == _retryAttempts) {
          return DownloadResult.failed(
              verseKey, 'Failed after $attempt attempts: $e');
        }

        // Wait before retry
        await Future.delayed(Duration(seconds: attempt * 2));
      }
    }

    return DownloadResult.failed(verseKey, 'Max retry attempts exceeded');
  }

  void _processDownloadQueue() {
    while (_downloadQueue.isNotEmpty &&
        _activeDownloads.length < _maxConcurrentDownloads) {
      final request = _downloadQueue.removeFirst();

      // Process download asynchronously
      downloadVerseAudio(
        verse: request.verse,
        reciterSlug: request.reciterSlug,
        quality: request.quality,
        overwriteExisting: request.overwriteExisting,
      );
    }
  }

  void _updateProgress(String verseKey, DownloadProgress progress) {
    _downloadProgress[verseKey] = progress;

    if (_progressControllers.containsKey(verseKey)) {
      _progressControllers[verseKey]!.add(progress);
    }

    // Trigger haptic feedback for key progress points
    if (progress.status == DownloadStatus.completed) {
      HapticFeedback.lightImpact();
    } else if (progress.status == DownloadStatus.failed) {
      HapticFeedback.heavyImpact();
    }
  }

  Future<Directory> _getStorageDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    return Directory('${appDir.path}/$_audioStorageDir');
  }

  Future<String> _getLocalAudioPath(
      String verseKey, String reciterSlug, DownloadQuality quality) async {
    final storageDir = await _getStorageDirectory();
    final qualitySuffix = quality == DownloadQuality.high ? '_hq' : '';
    return '${storageDir.path}/$reciterSlug/${verseKey}$qualitySuffix.mp3';
  }

  String _buildDownloadUrl(audio_service.VerseAudio verse, String reciterSlug,
      DownloadQuality quality) {
    // This should match your existing audio URL building logic
    final baseUrl = 'https://verses.quran.com';
    final qualityPath = quality == DownloadQuality.high ? 'high' : 'standard';
    return '$baseUrl/$reciterSlug/$qualityPath/${verse.verseKey}.mp3';
  }

  Future<List<audio_service.VerseAudio>> _generateSurahVerses(int surahNumber,
      {int? maxVerses}) async {
    // This should integrate with your existing verse generation logic
    // For now, returning a placeholder implementation
    final verses = <audio_service.VerseAudio>[];

    // You would replace this with actual verse count for the surah
    final verseCount = maxVerses ?? _getVerseCountForSurah(surahNumber);

    for (int i = 1; i <= verseCount; i++) {
      verses.add(audio_service.VerseAudio(
        verseKey: '$surahNumber:$i',
        audioUrl: '', // Will be built during download
      ));
    }

    return verses;
  }

  int _getVerseCountForSurah(int surahNumber) {
    // Simplified verse counts - replace with actual data
    const verseCounts = {
      1: 7, // Al-Fatiha
      2: 286, // Al-Baqarah
      112: 4, // Al-Ikhlas
      113: 5, // Al-Falaq
      114: 6, // An-Nas
    };

    return verseCounts[surahNumber] ?? 10; // Default fallback
  }

  /// Dispose resources
  void dispose() {
    for (final controller in _progressControllers.values) {
      controller.close();
    }
    _progressControllers.clear();
    _downloadProgress.clear();
    _activeDownloads.clear();
    _downloadQueue.clear();
  }
}

// Data classes

class DownloadProgress {
  final String verseKey;
  final DownloadStatus status;
  final double progress;
  final int downloadedBytes;
  final int totalBytes;
  final String? error;
  final String? localPath;
  final int? attempt;

  const DownloadProgress({
    required this.verseKey,
    required this.status,
    required this.progress,
    required this.downloadedBytes,
    required this.totalBytes,
    this.error,
    this.localPath,
    this.attempt,
  });

  DownloadProgress copyWith({
    String? verseKey,
    DownloadStatus? status,
    double? progress,
    int? downloadedBytes,
    int? totalBytes,
    String? error,
    String? localPath,
    int? attempt,
  }) {
    return DownloadProgress(
      verseKey: verseKey ?? this.verseKey,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      downloadedBytes: downloadedBytes ?? this.downloadedBytes,
      totalBytes: totalBytes ?? this.totalBytes,
      error: error ?? this.error,
      localPath: localPath ?? this.localPath,
      attempt: attempt ?? this.attempt,
    );
  }
}

class DownloadResult {
  final String verseKey;
  final bool success;
  final String? localPath;
  final String? error;

  const DownloadResult({
    required this.verseKey,
    required this.success,
    this.localPath,
    this.error,
  });

  factory DownloadResult.success(String verseKey, String localPath) {
    return DownloadResult(
        verseKey: verseKey, success: true, localPath: localPath);
  }

  factory DownloadResult.failed(String verseKey, String error) {
    return DownloadResult(verseKey: verseKey, success: false, error: error);
  }

  factory DownloadResult.alreadyExists(String verseKey, String localPath) {
    return DownloadResult(
        verseKey: verseKey, success: true, localPath: localPath);
  }

  factory DownloadResult.alreadyInProgress(String verseKey) {
    return DownloadResult(
        verseKey: verseKey,
        success: false,
        error: 'Download already in progress');
  }
}

class BatchDownloadResult {
  final int totalRequested;
  final int successful;
  final int failed;
  final Map<String, DownloadResult> results;

  const BatchDownloadResult({
    required this.totalRequested,
    required this.successful,
    required this.failed,
    required this.results,
  });

  double get successRate =>
      totalRequested > 0 ? successful / totalRequested : 0.0;
  bool get hasFailures => failed > 0;
  bool get allSuccessful => successful == totalRequested && failed == 0;
}

class DownloadRequest {
  final audio_service.VerseAudio verse;
  final String reciterSlug;
  final DownloadQuality quality;
  final bool overwriteExisting;

  const DownloadRequest({
    required this.verse,
    required this.reciterSlug,
    required this.quality,
    required this.overwriteExisting,
  });
}

class DownloadStatistics {
  final int totalFiles;
  final int totalSizeBytes;
  final Map<String, ReciterStats> reciterStats;

  const DownloadStatistics({
    required this.totalFiles,
    required this.totalSizeBytes,
    required this.reciterStats,
  });

  factory DownloadStatistics.empty() {
    return const DownloadStatistics(
      totalFiles: 0,
      totalSizeBytes: 0,
      reciterStats: {},
    );
  }

  double get totalSizeMB => totalSizeBytes / (1024 * 1024);
  double get totalSizeGB => totalSizeMB / 1024;
}

class ReciterStats {
  final String reciterSlug;
  final int fileCount;
  final int totalSize;

  const ReciterStats({
    required this.reciterSlug,
    required this.fileCount,
    required this.totalSize,
  });

  ReciterStats copyWith({
    String? reciterSlug,
    int? fileCount,
    int? totalSize,
  }) {
    return ReciterStats(
      reciterSlug: reciterSlug ?? this.reciterSlug,
      fileCount: fileCount ?? this.fileCount,
      totalSize: totalSize ?? this.totalSize,
    );
  }

  double get sizeMB => totalSize / (1024 * 1024);
}

enum DownloadStatus {
  starting,
  downloading,
  completed,
  failed,
  cancelled,
}

enum DownloadQuality {
  standard, // ~64kbps
  high, // ~128kbps
}

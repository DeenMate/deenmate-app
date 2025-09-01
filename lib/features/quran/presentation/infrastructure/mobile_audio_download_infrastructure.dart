import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import '../../domain/services/audio_service.dart';
import '../state/providers.dart';

/// Quality settings for audio downloads
enum DownloadQuality {
  standard, // 64kbps
  high,     // 128kbps
}

/// Status of a download operation
enum DownloadStatus {
  starting,
  downloading,
  completed,
  failed,
  cancelled,
}

/// Result of a single download operation
class DownloadResult {
  final bool success;
  final String localPath;
  final int fileSize;
  final String? error;
  
  const DownloadResult({
    required this.success,
    required this.localPath,
    required this.fileSize,
    this.error,
  });
  
  factory DownloadResult.success({
    required String localPath,
    required int fileSize,
  }) {
    return DownloadResult(
      success: true,
      localPath: localPath,
      fileSize: fileSize,
    );
  }
  
  factory DownloadResult.failure(String error) {
    return DownloadResult(
      success: false,
      localPath: '',
      fileSize: 0,
      error: error,
    );
  }
}

/// Result of batch download operations
class BatchDownloadResult {
  final int totalRequested;
  final int successful;
  final int failed;
  final List<String> errors;
  
  const BatchDownloadResult({
    required this.totalRequested,
    required this.successful,
    required this.failed,
    required this.errors,
  });
  
  bool get allSuccessful => failed == 0;
  bool get hasFailures => failed > 0;
  double get successRate => totalRequested > 0 ? successful / totalRequested : 0.0;
}

/// Statistics about downloaded audio files
class DownloadStatistics {
  final int totalFiles;
  final double totalSizeMB;
  final Map<String, int> reciterStats;
  
  const DownloadStatistics({
    required this.totalFiles,
    required this.totalSizeMB,
    required this.reciterStats,
  });
}

/// Progress information for ongoing downloads
class DownloadProgressInfo {
  final String verseKey;
  final double progress;
  final int bytesDownloaded;
  final int totalBytes;
  final String localPath;
  final DownloadStatus status;
  final int? attempt;
  
  const DownloadProgressInfo({
    required this.verseKey,
    required this.progress,
    required this.bytesDownloaded,
    required this.totalBytes,
    required this.localPath,
    required this.status,
    this.attempt,
  });
}

/// Batch download progress information
class BatchDownloadProgressInfo {
  final String batchId;
  final int completedCount;
  final int totalCount;
  final String currentItem;
  final double overallProgress;
  
  const BatchDownloadProgressInfo({
    required this.batchId,
    required this.completedCount,
    required this.totalCount,
    required this.currentItem,
    required this.overallProgress,
  });
}

/// Mobile-optimized audio download infrastructure
/// Provides offline-first download capabilities with progress tracking
class MobileAudioDownloadInfrastructure {
  static final MobileAudioDownloadInfrastructure _instance = 
      MobileAudioDownloadInfrastructure._internal();
  
  static MobileAudioDownloadInfrastructure get instance => _instance;
  
  MobileAudioDownloadInfrastructure._internal();
  
  // Configuration
  final int maxConcurrentDownloads = 3;
  final int maxRetryAttempts = 3;
  final int downloadTimeoutMinutes = 5;
  
  // Stream controllers for real-time updates
  final _downloadProgressController = StreamController<DownloadProgressInfo>.broadcast();
  final _batchProgressController = StreamController<BatchDownloadProgressInfo>.broadcast();
  
  // Public streams
  Stream<DownloadProgressInfo> get downloadProgressStream => 
      _downloadProgressController.stream;
  Stream<BatchDownloadProgressInfo> get batchProgressStream => 
      _batchProgressController.stream;
  
  // Internal state
  final Map<String, DownloadProgressInfo> _activeDownloads = {};
  final Set<String> _downloadQueue = {};
  bool _isInitialized = false;
  Directory? _audioDirectory;
  
  /// Initialize the download infrastructure
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      final documentsDir = await getApplicationDocumentsDirectory();
      _audioDirectory = Directory(path.join(documentsDir.path, 'quran_audio'));
      
      if (!await _audioDirectory!.exists()) {
        await _audioDirectory!.create(recursive: true);
      }
      
      _isInitialized = true;
    } catch (e) {
      throw Exception('Failed to initialize download infrastructure: $e');
    }
  }
  
  /// Download a single verse audio
  Future<DownloadResult> downloadVerse({
    required VerseAudio verse,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    await _ensureInitialized();
    
    final verseKey = verse.verseKey;
    final downloadKey = _getDownloadKey(verseKey, reciterSlug, quality);
    
    try {
      // Check if already downloaded
      if (await isVerseDownloaded(
        verseKey: verseKey,
        reciterSlug: reciterSlug,
        quality: quality,
      )) {
        final localPath = await getLocalAudioPath(
          verseKey: verseKey,
          reciterSlug: reciterSlug,
          quality: quality,
        );
        if (localPath != null) {
          final file = File(localPath);
          if (await file.exists()) {
            return DownloadResult.success(
              localPath: localPath,
              fileSize: await file.length(),
            );
          }
        }
      }
      
      // Start download
      final audioUrl = _constructAudioUrl(verseKey, reciterSlug, quality);
      final localPath = _getLocalFilePath(verseKey, reciterSlug, quality);
      
      _downloadProgressController.add(DownloadProgressInfo(
        verseKey: verseKey,
        progress: 0.0,
        bytesDownloaded: 0,
        totalBytes: 0,
        localPath: localPath,
        status: DownloadStatus.starting,
      ));
      
      final result = await _downloadFile(
        url: audioUrl,
        localPath: localPath,
        verseKey: verseKey,
      );
      
      if (result.success) {
        _downloadProgressController.add(DownloadProgressInfo(
          verseKey: verseKey,
          progress: 1.0,
          bytesDownloaded: result.fileSize,
          totalBytes: result.fileSize,
          localPath: localPath,
          status: DownloadStatus.completed,
        ));
      } else {
        _downloadProgressController.add(DownloadProgressInfo(
          verseKey: verseKey,
          progress: 0.0,
          bytesDownloaded: 0,
          totalBytes: 0,
          localPath: localPath,
          status: DownloadStatus.failed,
        ));
      }
      
      return result;
    } catch (e) {
      return DownloadResult.failure('Download failed: $e');
    }
  }
  
  /// Download multiple verses with batch progress tracking
  Future<BatchDownloadResult> downloadMultipleVerses({
    required List<VerseAudio> verses,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
    Function(String verseKey, double progress)? onProgress,
  }) async {
    final batchId = DateTime.now().millisecondsSinceEpoch.toString();
    int successful = 0;
    int failed = 0;
    final List<String> errors = [];
    
    for (int i = 0; i < verses.length; i++) {
      final verse = verses[i];
      
      _batchProgressController.add(BatchDownloadProgressInfo(
        batchId: batchId,
        completedCount: i,
        totalCount: verses.length,
        currentItem: verse.verseKey,
        overallProgress: i / verses.length,
      ));
      
      try {
        final result = await downloadVerse(
          verse: verse,
          reciterSlug: reciterSlug,
          quality: quality,
        );
        
        if (result.success) {
          successful++;
        } else {
          failed++;
          if (result.error != null) {
            errors.add('${verse.verseKey}: ${result.error}');
          }
        }
        
        onProgress?.call(verse.verseKey, (i + 1) / verses.length);
      } catch (e) {
        failed++;
        errors.add('${verse.verseKey}: $e');
      }
    }
    
    _batchProgressController.add(BatchDownloadProgressInfo(
      batchId: batchId,
      completedCount: verses.length,
      totalCount: verses.length,
      currentItem: '',
      overallProgress: 1.0,
    ));
    
    return BatchDownloadResult(
      totalRequested: verses.length,
      successful: successful,
      failed: failed,
      errors: errors,
    );
  }
  
  /// Download popular chapters (short surahs commonly recited)
  Future<BatchDownloadResult> downloadPopularChapters({
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
    Function(String verseKey, double progress)? onProgress,
  }) async {
    // Popular short chapters commonly recited
    final popularChapters = [
      '1:1', '1:2', '1:3', '1:4', '1:5', '1:6', '1:7', // Al-Fatiha
      '112:1', '112:2', '112:3', '112:4', // Al-Ikhlas
      '113:1', '113:2', '113:3', '113:4', '113:5', // Al-Falaq
      '114:1', '114:2', '114:3', '114:4', '114:5', '114:6', // An-Nas
    ];
    
    final verses = popularChapters.map((verseKey) => 
      VerseAudio(verseKey: verseKey)).toList();
    
    return downloadMultipleVerses(
      verses: verses,
      reciterSlug: reciterSlug,
      quality: quality,
      onProgress: onProgress,
    );
  }
  
  /// Download a complete Surah
  Future<BatchDownloadResult> downloadSurah({
    required int surahNumber,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    // This is a simplified implementation
    // In a real app, you'd fetch the verse count for the surah
    final verseCount = _getSurahVerseCount(surahNumber);
    final verses = List.generate(verseCount, (index) => 
      VerseAudio(verseKey: '$surahNumber:${index + 1}'));
    
    return downloadMultipleVerses(
      verses: verses,
      reciterSlug: reciterSlug,
      quality: quality,
    );
  }
  
  /// Check if a verse is already downloaded
  Future<bool> isVerseDownloaded({
    required String verseKey,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    await _ensureInitialized();
    
    final localPath = _getLocalFilePath(verseKey, reciterSlug, quality);
    final file = File(localPath);
    
    if (await file.exists()) {
      final size = await file.length();
      return size > 0; // File exists and has content
    }
    
    return false;
  }
  
  /// Get local audio path for a verse
  Future<String?> getLocalAudioPath({
    required String verseKey,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    if (await isVerseDownloaded(
      verseKey: verseKey,
      reciterSlug: reciterSlug,
      quality: quality,
    )) {
      return _getLocalFilePath(verseKey, reciterSlug, quality);
    }
    return null;
  }
  
  /// Get download statistics
  Future<DownloadStatistics> getDownloadStatistics() async {
    await _ensureInitialized();
    
    int totalFiles = 0;
    double totalSizeMB = 0.0;
    final Map<String, int> reciterStats = {};
    
    if (_audioDirectory != null && await _audioDirectory!.exists()) {
      await for (final entity in _audioDirectory!.list(recursive: true)) {
        if (entity is File && entity.path.endsWith('.mp3')) {
          totalFiles++;
          final size = await entity.length();
          totalSizeMB += size / (1024 * 1024);
          
          // Extract reciter from path
          final pathParts = entity.path.split('/');
          if (pathParts.length > 1) {
            final reciter = pathParts[pathParts.length - 2];
            reciterStats[reciter] = (reciterStats[reciter] ?? 0) + 1;
          }
        }
      }
    }
    
    return DownloadStatistics(
      totalFiles: totalFiles,
      totalSizeMB: totalSizeMB,
      reciterStats: reciterStats,
    );
  }
  
  /// Clear all downloads
  Future<void> clearAllDownloads() async {
    await _ensureInitialized();
    
    if (_audioDirectory != null && await _audioDirectory!.exists()) {
      await _audioDirectory!.delete(recursive: true);
      await _audioDirectory!.create(recursive: true);
    }
  }
  
  /// Get download progress for a specific verse
  Stream<DownloadProgressInfo> getDownloadProgress(String verseKey) {
    return downloadProgressStream.where((progress) => progress.verseKey == verseKey);
  }
  
  // Private helper methods
  
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
  
  String _getDownloadKey(String verseKey, String reciterSlug, DownloadQuality quality) {
    return '${verseKey}_${reciterSlug}_${quality.name}';
  }
  
  String _getLocalFilePath(String verseKey, String reciterSlug, DownloadQuality quality) {
    final qualityDir = quality == DownloadQuality.high ? 'high' : 'standard';
    final fileName = '${verseKey}.mp3';
    return path.join(_audioDirectory!.path, reciterSlug, qualityDir, fileName);
  }
  
  String _constructAudioUrl(String verseKey, String reciterSlug, DownloadQuality quality) {
    // This is a placeholder URL construction
    // In a real app, you'd use the actual audio service API
    final qualityParam = quality == DownloadQuality.high ? 'high' : 'low';
    return 'https://api.quran.com/api/v4/chapter_recitations/$reciterSlug/$verseKey?quality=$qualityParam';
  }
  
  Future<DownloadResult> _downloadFile({
    required String url,
    required String localPath,
    required String verseKey,
  }) async {
    try {
      // Create directory if it doesn't exist
      final file = File(localPath);
      await file.parent.create(recursive: true);
      
      // Download with progress tracking
      final request = http.Request('GET', Uri.parse(url));
      final response = await request.send();
      
      if (response.statusCode == 200) {
        final contentLength = response.contentLength ?? 0;
        int downloadedBytes = 0;
        
        final List<int> bytes = [];
        
        await for (final chunk in response.stream) {
          bytes.addAll(chunk);
          downloadedBytes += chunk.length;
          
          final progress = contentLength > 0 ? downloadedBytes / contentLength : 0.0;
          
          _downloadProgressController.add(DownloadProgressInfo(
            verseKey: verseKey,
            progress: progress,
            bytesDownloaded: downloadedBytes,
            totalBytes: contentLength,
            localPath: localPath,
            status: DownloadStatus.downloading,
          ));
        }
        
        await file.writeAsBytes(bytes);
        
        return DownloadResult.success(
          localPath: localPath,
          fileSize: bytes.length,
        );
      } else {
        return DownloadResult.failure('HTTP ${response.statusCode}');
      }
    } catch (e) {
      return DownloadResult.failure('Download error: $e');
    }
  }
  
  int _getSurahVerseCount(int surahNumber) {
    // Simplified verse counts for testing
    // In a real app, this would come from Quran data
    const verseCounts = {
      1: 7,   // Al-Fatiha
      2: 286, // Al-Baqarah  
      112: 4, // Al-Ikhlas
      113: 5, // Al-Falaq
      114: 6, // An-Nas
    };
    return verseCounts[surahNumber] ?? 10; // Default to 10 for unknown surahs
  }
  
  /// Dispose resources
  void dispose() {
    _downloadProgressController.close();
    _batchProgressController.close();
  }
}

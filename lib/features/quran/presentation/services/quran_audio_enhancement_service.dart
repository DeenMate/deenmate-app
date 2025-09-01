import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../infrastructure/mobile_audio_download_infrastructure.dart';
import 'mobile_audio_manager.dart';
import '../../domain/services/audio_service.dart' as audio_service;
import '../state/providers.dart';

/// Complete QURAN-103 Audio Enhancement Integration Service
/// Provides seamless integration between download infrastructure, 
/// progress indicators, and mobile audio playback
class QuranAudioEnhancementService {
  static final QuranAudioEnhancementService _instance = 
      QuranAudioEnhancementService._internal();
  
  static QuranAudioEnhancementService get instance => _instance;
  
  QuranAudioEnhancementService._internal();
  
  // Core components
  final _downloadInfrastructure = MobileAudioDownloadInfrastructure.instance;
  final _mobileAudioManager = MobileAudioManager.instance;
  
  // Stream controllers for real-time updates
  final _audioEnhancementStreamController = StreamController<AudioEnhancementEvent>.broadcast();
  final _downloadIntegrationController = StreamController<DownloadIntegrationEvent>.broadcast();
  
  // Public streams
  Stream<AudioEnhancementEvent> get audioEnhancementStream => 
      _audioEnhancementStreamController.stream;
  Stream<DownloadIntegrationEvent> get downloadIntegrationStream => 
      _downloadIntegrationController.stream;
  
  // Service state
  bool _isInitialized = false;
  bool _isIntegrationActive = false;
  
  /// Initialize the complete audio enhancement system
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize download infrastructure
      await _downloadInfrastructure.initialize();
      
      // Initialize mobile audio manager
      await _mobileAudioManager.initialize();
      
      // Set up integration listeners
      _setupIntegrationListeners();
      
      _isInitialized = true;
      _isIntegrationActive = true;
      
      _audioEnhancementStreamController.add(
        AudioEnhancementEvent.initialized(
          hasDownloadCapability: true,
          hasProgressTracking: true,
          hasMobileOptimization: true,
        ),
      );
    } catch (e) {
      _audioEnhancementStreamController.add(
        AudioEnhancementEvent.error('Failed to initialize audio enhancement: $e'),
      );
      rethrow;
    }
  }
  
  /// Set up listeners for seamless integration between components
  void _setupIntegrationListeners() {
    // Listen to download progress and update audio manager
    _downloadInfrastructure.downloadProgressStream.listen((progress) {
      _downloadIntegrationController.add(
        DownloadIntegrationEvent.downloadProgress(
          verseKey: progress.verseKey,
          progress: progress.progress,
          bytesDownloaded: progress.bytesDownloaded,
          totalBytes: progress.totalBytes,
        ),
      );
      
      // Notify mobile audio manager about download completion
      if (progress.progress >= 1.0) {
        _mobileAudioManager.notifyAudioAvailable(
          verseKey: progress.verseKey,
          localPath: progress.localPath,
        );
      }
    });
    
    // Listen to batch download events
    _downloadInfrastructure.batchProgressStream.listen((batchProgress) {
      _downloadIntegrationController.add(
        DownloadIntegrationEvent.batchProgress(
          batchId: batchProgress.batchId,
          completedCount: batchProgress.completedCount,
          totalCount: batchProgress.totalCount,
          currentItem: batchProgress.currentItem,
        ),
      );
    });
    
    // Listen to audio manager events and enhance with download info
    _mobileAudioManager.audioEventStream.listen((audioEvent) {
      _handleAudioManagerEvent(audioEvent);
    });
  }
  
  /// Handle audio manager events and enhance with download integration
  void _handleAudioManagerEvent(MobileAudioEvent audioEvent) {
    switch (audioEvent.type) {
      case MobileAudioEventType.playbackRequested:
        _handlePlaybackRequest(audioEvent);
        break;
      case MobileAudioEventType.downloadRequested:
        _handleDownloadRequest(audioEvent);
        break;
      case MobileAudioEventType.cacheEvicted:
        _handleCacheEviction(audioEvent);
        break;
      default:
        // Forward other events as enhancement events
        _audioEnhancementStreamController.add(
          AudioEnhancementEvent.audioManagerEvent(audioEvent),
        );
    }
  }
  
  /// Handle playback requests with automatic download fallback
  Future<void> _handlePlaybackRequest(MobileAudioEvent audioEvent) async {
    final verseKey = audioEvent.data['verseKey'] as String?;
    final reciterSlug = audioEvent.data['reciterSlug'] as String?;
    
    if (verseKey == null || reciterSlug == null) return;
    
    try {
      // Check if audio is already available locally
      final isAvailable = await _downloadInfrastructure.isVerseDownloaded(
        verseKey: verseKey,
        reciterSlug: reciterSlug,
        quality: DownloadQuality.standard,
      );
      
      if (isAvailable) {
        // Audio is downloaded, proceed with playback
        final localPath = await _downloadInfrastructure.getLocalAudioPath(
          verseKey: verseKey,
          reciterSlug: reciterSlug,
          quality: DownloadQuality.standard,
        );
        
        _audioEnhancementStreamController.add(
          AudioEnhancementEvent.playbackReady(
            verseKey: verseKey,
            localPath: localPath,
            isOffline: true,
          ),
        );
      } else {
        // Audio not downloaded, offer download or stream
        _audioEnhancementStreamController.add(
          AudioEnhancementEvent.downloadRequired(
            verseKey: verseKey,
            reciterSlug: reciterSlug,
            canStream: true,
          ),
        );
      }
    } catch (e) {
      _audioEnhancementStreamController.add(
        AudioEnhancementEvent.error('Playback preparation failed: $e'),
      );
    }
  }
  
  /// Handle download requests through the integration layer
  Future<void> _handleDownloadRequest(MobileAudioEvent audioEvent) async {
    final verseKey = audioEvent.data['verseKey'] as String?;
    final reciterSlug = audioEvent.data['reciterSlug'] as String?;
    final quality = audioEvent.data['quality'] as DownloadQuality? ?? DownloadQuality.standard;
    
    if (verseKey == null || reciterSlug == null) return;
    
    try {
      // Create verse audio object for download
      final verseAudio = audio_service.VerseAudio(
        verseKey: verseKey,
        audioUrl: '', // Will be resolved by download infrastructure
      );
      
      // Start download through infrastructure
      final result = await _downloadInfrastructure.downloadVerse(
        verse: verseAudio,
        reciterSlug: reciterSlug,
        quality: quality,
      );
      
      if (result.success) {
        _audioEnhancementStreamController.add(
          AudioEnhancementEvent.downloadCompleted(
            verseKey: verseKey,
            localPath: result.localPath,
            fileSize: result.fileSize,
          ),
        );
      } else {
        _audioEnhancementStreamController.add(
          AudioEnhancementEvent.downloadFailed(
            verseKey: verseKey,
            error: result.error ?? 'Unknown download error',
          ),
        );
      }
    } catch (e) {
      _audioEnhancementStreamController.add(
        AudioEnhancementEvent.error('Download request failed: $e'),
      );
    }
  }
  
  /// Handle cache eviction events
  void _handleCacheEviction(MobileAudioEvent audioEvent) {
    final verseKey = audioEvent.data['verseKey'] as String?;
    if (verseKey != null) {
      _audioEnhancementStreamController.add(
        AudioEnhancementEvent.cacheEvicted(verseKey: verseKey),
      );
    }
  }
  
  // Public API methods
  
  /// Download a single verse with enhanced progress tracking
  Future<DownloadResult> downloadVerse({
    required String verseKey,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    final verseAudio = audio_service.VerseAudio(
      verseKey: verseKey,
      audioUrl: '',
    );
    
    return await _downloadInfrastructure.downloadVerse(
      verse: verseAudio,
      reciterSlug: reciterSlug,
      quality: quality,
    );
  }
  
  /// Download multiple verses with batch progress tracking
  Future<BatchDownloadResult> downloadMultipleVerses({
    required List<String> verseKeys,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    final verses = verseKeys.map((key) => audio_service.VerseAudio(
      verseKey: key,
      audioUrl: '',
    )).toList();
    
    return await _downloadInfrastructure.downloadMultipleVerses(
      verses: verses,
      reciterSlug: reciterSlug,
      quality: quality,
    );
  }
  
  /// Download popular chapters with enhanced tracking
  Future<BatchDownloadResult> downloadPopularChapters({
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    return await _downloadInfrastructure.downloadPopularChapters(
      reciterSlug: reciterSlug,
      quality: quality,
    );
  }
  
  /// Download a complete Surah
  Future<BatchDownloadResult> downloadSurah({
    required int surahNumber,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    return await _downloadInfrastructure.downloadSurah(
      surahNumber: surahNumber,
      reciterSlug: reciterSlug,
      quality: quality,
    );
  }
  
  /// Check if a verse is downloaded
  Future<bool> isVerseDownloaded({
    required String verseKey,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    return await _downloadInfrastructure.isVerseDownloaded(
      verseKey: verseKey,
      reciterSlug: reciterSlug,
      quality: quality,
    );
  }
  
  /// Get local audio path for a verse
  Future<String?> getLocalAudioPath({
    required String verseKey,
    required String reciterSlug,
    DownloadQuality quality = DownloadQuality.standard,
  }) async {
    return await _downloadInfrastructure.getLocalAudioPath(
      verseKey: verseKey,
      reciterSlug: reciterSlug,
      quality: quality,
    );
  }
  
  /// Get download statistics
  Future<DownloadStatistics> getDownloadStatistics() async {
    return await _downloadInfrastructure.getDownloadStatistics();
  }
  
  /// Clear all downloads
  Future<void> clearAllDownloads() async {
    await _downloadInfrastructure.clearAllDownloads();
    _audioEnhancementStreamController.add(
      AudioEnhancementEvent.allDownloadsCleared(),
    );
  }
  
  /// Get enhanced audio manager instance
  MobileAudioManager get audioManager => _mobileAudioManager;
  
  /// Get download infrastructure instance
  MobileAudioDownloadInfrastructure get downloadInfrastructure => _downloadInfrastructure;
  
  /// Check if the service is ready
  bool get isReady => _isInitialized && _isIntegrationActive;
  
  /// Dispose resources
  void dispose() {
    _audioEnhancementStreamController.close();
    _downloadIntegrationController.close();
    _isIntegrationActive = false;
  }
}

/// Events emitted by the audio enhancement service
abstract class AudioEnhancementEvent {
  const AudioEnhancementEvent();
  
  factory AudioEnhancementEvent.initialized({
    required bool hasDownloadCapability,
    required bool hasProgressTracking,
    required bool hasMobileOptimization,
  }) = AudioEnhancementInitialized;
  
  factory AudioEnhancementEvent.playbackReady({
    required String verseKey,
    required String localPath,
    required bool isOffline,
  }) = AudioEnhancementPlaybackReady;
  
  factory AudioEnhancementEvent.downloadRequired({
    required String verseKey,
    required String reciterSlug,
    required bool canStream,
  }) = AudioEnhancementDownloadRequired;
  
  factory AudioEnhancementEvent.downloadCompleted({
    required String verseKey,
    required String localPath,
    required int fileSize,
  }) = AudioEnhancementDownloadCompleted;
  
  factory AudioEnhancementEvent.downloadFailed({
    required String verseKey,
    required String error,
  }) = AudioEnhancementDownloadFailed;
  
  factory AudioEnhancementEvent.cacheEvicted({
    required String verseKey,
  }) = AudioEnhancementCacheEvicted;
  
  factory AudioEnhancementEvent.allDownloadsCleared() = AudioEnhancementAllDownloadsCleared;
  
  factory AudioEnhancementEvent.audioManagerEvent(MobileAudioEvent event) = 
      AudioEnhancementAudioManagerEvent;
  
  factory AudioEnhancementEvent.error(String message) = AudioEnhancementError;
}

/// Specific event implementations
class AudioEnhancementInitialized extends AudioEnhancementEvent {
  final bool hasDownloadCapability;
  final bool hasProgressTracking;
  final bool hasMobileOptimization;
  
  const AudioEnhancementInitialized({
    required this.hasDownloadCapability,
    required this.hasProgressTracking,
    required this.hasMobileOptimization,
  });
}

class AudioEnhancementPlaybackReady extends AudioEnhancementEvent {
  final String verseKey;
  final String localPath;
  final bool isOffline;
  
  const AudioEnhancementPlaybackReady({
    required this.verseKey,
    required this.localPath,
    required this.isOffline,
  });
}

class AudioEnhancementDownloadRequired extends AudioEnhancementEvent {
  final String verseKey;
  final String reciterSlug;
  final bool canStream;
  
  const AudioEnhancementDownloadRequired({
    required this.verseKey,
    required this.reciterSlug,
    required this.canStream,
  });
}

class AudioEnhancementDownloadCompleted extends AudioEnhancementEvent {
  final String verseKey;
  final String localPath;
  final int fileSize;
  
  const AudioEnhancementDownloadCompleted({
    required this.verseKey,
    required this.localPath,
    required this.fileSize,
  });
}

class AudioEnhancementDownloadFailed extends AudioEnhancementEvent {
  final String verseKey;
  final String error;
  
  const AudioEnhancementDownloadFailed({
    required this.verseKey,
    required this.error,
  });
}

class AudioEnhancementCacheEvicted extends AudioEnhancementEvent {
  final String verseKey;
  
  const AudioEnhancementCacheEvicted({required this.verseKey});
}

class AudioEnhancementAllDownloadsCleared extends AudioEnhancementEvent {
  const AudioEnhancementAllDownloadsCleared();
}

class AudioEnhancementAudioManagerEvent extends AudioEnhancementEvent {
  final MobileAudioEvent event;
  
  const AudioEnhancementAudioManagerEvent(this.event);
}

class AudioEnhancementError extends AudioEnhancementEvent {
  final String message;
  
  const AudioEnhancementError(this.message);
}

/// Events for download integration
abstract class DownloadIntegrationEvent {
  const DownloadIntegrationEvent();
  
  factory DownloadIntegrationEvent.downloadProgress({
    required String verseKey,
    required double progress,
    required int bytesDownloaded,
    required int totalBytes,
  }) = DownloadIntegrationProgress;
  
  factory DownloadIntegrationEvent.batchProgress({
    required String batchId,
    required int completedCount,
    required int totalCount,
    required String currentItem,
  }) = DownloadIntegrationBatchProgress;
}

class DownloadIntegrationProgress extends DownloadIntegrationEvent {
  final String verseKey;
  final double progress;
  final int bytesDownloaded;
  final int totalBytes;
  
  const DownloadIntegrationProgress({
    required this.verseKey,
    required this.progress,
    required this.bytesDownloaded,
    required this.totalBytes,
  });
}

class DownloadIntegrationBatchProgress extends DownloadIntegrationEvent {
  final String batchId;
  final int completedCount;
  final int totalCount;
  final String currentItem;
  
  const DownloadIntegrationBatchProgress({
    required this.batchId,
    required this.completedCount,
    required this.totalCount,
    required this.currentItem,
  });
}

/// Riverpod provider for the audio enhancement service
final quranAudioEnhancementServiceProvider = Provider<QuranAudioEnhancementService>((ref) {
  return QuranAudioEnhancementService.instance;
});

/// Provider for audio enhancement events stream
final audioEnhancementEventsProvider = StreamProvider<AudioEnhancementEvent>((ref) {
  final service = ref.watch(quranAudioEnhancementServiceProvider);
  return service.audioEnhancementStream;
});

/// Provider for download integration events stream
final downloadIntegrationEventsProvider = StreamProvider<DownloadIntegrationEvent>((ref) {
  final service = ref.watch(quranAudioEnhancementServiceProvider);
  return service.downloadIntegrationStream;
});

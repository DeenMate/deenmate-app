import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../infrastructure/mobile_audio_download_infrastructure.dart';
import '../../domain/services/audio_service.dart' as audio_service;
import '../state/providers.dart';

/// Mobile-optimized progress indicators for audio downloads and playback
/// Provides visual feedback with haptic integration and accessibility support
class MobileAudioProgressIndicators extends StatelessWidget {
  const MobileAudioProgressIndicators({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        DownloadProgressWidget(),
        SizedBox(height: 16),
        PlaybackProgressWidget(),
      ],
    );
  }
}

/// Download progress indicator with real-time updates
class DownloadProgressWidget extends ConsumerWidget {
  const DownloadProgressWidget({
    super.key,
    this.verseKey,
    this.showDetails = true,
    this.compact = false,
  });

  final String? verseKey;
  final bool showDetails;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    if (verseKey == null) {
      return _buildGlobalDownloadProgress(context, l10n);
    }
    
    return _buildVerseDownloadProgress(context, l10n, verseKey!);
  }

  Widget _buildGlobalDownloadProgress(BuildContext context, AppLocalizations l10n) {
    return StreamBuilder<Map<String, DownloadProgress>>(
      stream: _getGlobalDownloadStream(),
      builder: (context, snapshot) {
        final activeDownloads = snapshot.data ?? {};
        
        if (activeDownloads.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.download, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      l10n.audioDownloadsTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${activeDownloads.length} active',
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...activeDownloads.values.map((progress) => 
                  _buildDownloadProgressItem(context, l10n, progress)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildVerseDownloadProgress(BuildContext context, AppLocalizations l10n, String verseKey) {
    return StreamBuilder<DownloadProgress>(
      stream: MobileAudioDownloadInfrastructure.instance.getDownloadProgress(verseKey),
      builder: (context, snapshot) {
        final progress = snapshot.data;
        
        if (progress == null || progress.status == DownloadStatus.completed) {
          return const SizedBox.shrink();
        }

        return _buildDownloadProgressItem(context, l10n, progress);
      },
    );
  }

  Widget _buildDownloadProgressItem(BuildContext context, AppLocalizations l10n, DownloadProgress progress) {
    final theme = Theme.of(context);
    final isError = progress.status == DownloadStatus.failed;
    final isCompleted = progress.status == DownloadStatus.completed;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isError 
          ? theme.colorScheme.errorContainer.withOpacity(0.1)
          : theme.colorScheme.primaryContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError 
            ? theme.colorScheme.error.withOpacity(0.3)
            : theme.colorScheme.primary.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with verse key and status
          Row(
            children: [
              Icon(
                _getStatusIcon(progress.status),
                size: 16,
                color: isError ? theme.colorScheme.error : theme.colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _formatVerseKey(progress.verseKey),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (progress.attempt != null && progress.attempt! > 1)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Retry ${progress.attempt}',
                    style: TextStyle(
                      fontSize: 10,
                      color: theme.colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
            ],
          ),
          
          if (showDetails) ...[
            const SizedBox(height: 8),
            
            // Progress bar
            if (!isError && !isCompleted)
              LinearProgressIndicator(
                value: progress.progress,
                backgroundColor: theme.colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              ),
            
            const SizedBox(height: 4),
            
            // Progress details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _getStatusText(context, l10n, progress),
                  style: TextStyle(
                    fontSize: 12,
                    color: isError 
                      ? theme.colorScheme.error 
                      : theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                if (progress.totalBytes > 0)
                  Text(
                    _formatBytes(progress.downloadedBytes, progress.totalBytes),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
          
          // Error message
          if (isError && progress.error != null) ...[
            const SizedBox(height: 4),
            Text(
              progress.error!,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.error,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Stream<Map<String, DownloadProgress>> _getGlobalDownloadStream() {
    // This would need to be implemented to track all active downloads
    // For now, returning an empty stream as placeholder
    return Stream.value({});
  }

  IconData _getStatusIcon(DownloadStatus status) {
    switch (status) {
      case DownloadStatus.starting:
        return Icons.download_outlined;
      case DownloadStatus.downloading:
        return Icons.downloading;
      case DownloadStatus.completed:
        return Icons.check_circle;
      case DownloadStatus.failed:
        return Icons.error_outline;
      case DownloadStatus.cancelled:
        return Icons.cancel_outlined;
    }
  }

  String _getStatusText(BuildContext context, AppLocalizations l10n, DownloadProgress progress) {
    switch (progress.status) {
      case DownloadStatus.starting:
        return 'Preparing download...';
      case DownloadStatus.downloading:
        return '${(progress.progress * 100).toInt()}% downloaded';
      case DownloadStatus.completed:
        return 'Download completed';
      case DownloadStatus.failed:
        return 'Download failed';
      case DownloadStatus.cancelled:
        return 'Download cancelled';
    }
  }

  String _formatVerseKey(String verseKey) {
    final parts = verseKey.split(':');
    if (parts.length == 2) {
      return 'Surah ${parts[0]}, Verse ${parts[1]}';
    }
    return verseKey;
  }

  String _formatBytes(int downloaded, int total) {
    final downloadedMB = downloaded / (1024 * 1024);
    final totalMB = total / (1024 * 1024);
    
    if (totalMB < 1) {
      final downloadedKB = downloaded / 1024;
      final totalKB = total / 1024;
      return '${downloadedKB.toStringAsFixed(0)}/${totalKB.toStringAsFixed(0)} KB';
    }
    
    return '${downloadedMB.toStringAsFixed(1)}/${totalMB.toStringAsFixed(1)} MB';
  }
}

/// Playback progress indicator for current audio
class PlaybackProgressWidget extends ConsumerWidget {
  const PlaybackProgressWidget({
    super.key,
    this.showSeekBar = true,
    this.showTimeLabels = true,
    this.compact = false,
  });

  final bool showSeekBar;
  final bool showTimeLabels;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioStateProvider);
    final currentVerse = ref.watch(currentVerseProvider);
    
    return audioState.when(
      data: (state) {
        if (state == audio_service.AudioState.stopped || currentVerse == null) {
          return const SizedBox.shrink();
        }
        
        return _buildPlaybackProgress(context, ref, state, currentVerse);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildPlaybackProgress(
    BuildContext context, 
    WidgetRef ref, 
    audio_service.AudioState state,
    audio_service.VerseAudio currentVerse,
  ) {
    final position = ref.watch(audioPositionProvider);
    final duration = ref.watch(audioDurationProvider);
    final theme = Theme.of(context);
    
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(compact ? 8.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current verse info
            if (!compact) ...[
              Row(
                children: [
                  Icon(
                    _getPlaybackIcon(state),
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _formatVerseKey(currentVerse.verseKey),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildPlaybackStatusChip(context, state),
                ],
              ),
              const SizedBox(height: 12),
            ],
            
            // Seek bar
            if (showSeekBar)
              _buildSeekBar(context, ref, position, duration),
            
            // Time labels
            if (showTimeLabels && (position.inSeconds > 0 || duration.inSeconds > 0)) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSeekBar(BuildContext context, WidgetRef ref, Duration position, Duration duration) {
    final theme = Theme.of(context);
    final progress = duration.inMilliseconds > 0 
        ? position.inMilliseconds / duration.inMilliseconds 
        : 0.0;
    
    return GestureDetector(
      onTapDown: (details) => _handleSeekTap(context, ref, details, duration),
      child: Container(
        height: 40,
        child: Stack(
          children: [
            // Background track
            Positioned(
              left: 0,
              right: 0,
              top: 18,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Progress track
            Positioned(
              left: 0,
              top: 18,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8 * progress.clamp(0.0, 1.0),
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            
            // Seek thumb
            if (progress > 0)
              Positioned(
                left: (MediaQuery.of(context).size.width * 0.8 * progress.clamp(0.0, 1.0)) - 8,
                top: 12,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackStatusChip(BuildContext context, audio_service.AudioState state) {
    final theme = Theme.of(context);
    final (text, color) = _getStatusChipInfo(state);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _handleSeekTap(BuildContext context, WidgetRef ref, TapDownDetails details, Duration duration) {
    if (duration.inMilliseconds <= 0) return;
    
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final width = renderBox.size.width;
    
    final seekPercent = (localPosition.dx / width).clamp(0.0, 1.0);
    final seekPosition = Duration(
      milliseconds: (duration.inMilliseconds * seekPercent).round(),
    );
    
    // Trigger haptic feedback
    HapticFeedback.selectionClick();
    
    // Seek to position (this would need to be implemented in your audio service)
    final audioService = ref.read(quranAudioServiceProvider);
    audioService.seek(seekPosition);
  }

  IconData _getPlaybackIcon(audio_service.AudioState state) {
    switch (state) {
      case audio_service.AudioState.playing:
        return Icons.play_circle_fill;
      case audio_service.AudioState.paused:
        return Icons.pause_circle_fill;
      case audio_service.AudioState.stopped:
        return Icons.stop_circle;
      default:
        return Icons.audio_file;
    }
  }

  (String, Color) _getStatusChipInfo(audio_service.AudioState state) {
    switch (state) {
      case audio_service.AudioState.playing:
        return ('Playing', Colors.green);
      case audio_service.AudioState.paused:
        return ('Paused', Colors.orange);
      case audio_service.AudioState.stopped:
        return ('Stopped', Colors.grey);
      default:
        return ('Loading', Colors.blue);
    }
  }

  String _formatVerseKey(String verseKey) {
    final parts = verseKey.split(':');
    if (parts.length == 2) {
      return 'Surah ${parts[0]}, Verse ${parts[1]}';
    }
    return verseKey;
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

/// Batch download progress indicator for multiple downloads
class BatchDownloadProgressWidget extends StatefulWidget {
  const BatchDownloadProgressWidget({
    super.key,
    required this.downloadFuture,
    this.onComplete,
    this.title = 'Downloading Audio',
  });

  final Future<BatchDownloadResult> downloadFuture;
  final Function(BatchDownloadResult)? onComplete;
  final String title;

  @override
  State<BatchDownloadProgressWidget> createState() => _BatchDownloadProgressWidgetState();
}

class _BatchDownloadProgressWidgetState extends State<BatchDownloadProgressWidget> {
  late Future<BatchDownloadResult> _downloadFuture;
  final Map<String, DownloadProgress> _progressMap = {};
  
  @override
  void initState() {
    super.initState();
    _downloadFuture = widget.downloadFuture;
    _downloadFuture.then((result) {
      widget.onComplete?.call(result);
      if (mounted) {
        // Trigger completion haptic feedback
        if (result.allSuccessful) {
          HapticFeedback.lightImpact();
        } else if (result.hasFailures) {
          HapticFeedback.heavyImpact();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                const Icon(Icons.download_multiple, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Overall progress
            FutureBuilder<BatchDownloadResult>(
              future: _downloadFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Column(
                    children: [
                      LinearProgressIndicator(
                        backgroundColor: theme.colorScheme.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Preparing downloads...',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  );
                }
                
                if (snapshot.hasError) {
                  return Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Download failed: ${snapshot.error}',
                        style: TextStyle(
                          fontSize: 14,
                          color: theme.colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                }
                
                final result = snapshot.data!;
                return Column(
                  children: [
                    // Completion status
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: result.allSuccessful 
                          ? Colors.green.withOpacity(0.1)
                          : result.hasFailures 
                            ? Colors.orange.withOpacity(0.1)
                            : theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            result.allSuccessful 
                              ? Icons.check_circle 
                              : result.hasFailures 
                                ? Icons.warning 
                                : Icons.info,
                            color: result.allSuccessful 
                              ? Colors.green 
                              : result.hasFailures 
                                ? Colors.orange 
                                : theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result.allSuccessful 
                                    ? 'All downloads completed successfully!'
                                    : 'Downloads completed with ${result.failed} failures',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '${result.successful}/${result.totalRequested} successful',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact progress indicator for floating UI elements
class CompactProgressIndicator extends StatelessWidget {
  const CompactProgressIndicator({
    super.key,
    required this.progress,
    this.size = 24.0,
    this.strokeWidth = 3.0,
    this.color,
    this.backgroundColor,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Color? color;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: progress.clamp(0.0, 1.0),
        strokeWidth: strokeWidth,
        color: color ?? theme.colorScheme.primary,
        backgroundColor: backgroundColor ?? theme.colorScheme.surfaceVariant,
      ),
    );
  }
}

/// Audio loading indicator with pulse animation
class AudioLoadingIndicator extends StatefulWidget {
  const AudioLoadingIndicator({
    super.key,
    this.size = 32.0,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  State<AudioLoadingIndicator> createState() => _AudioLoadingIndicatorState();
}

class _AudioLoadingIndicatorState extends State<AudioLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (widget.color ?? theme.colorScheme.primary)
                .withOpacity(_animation.value),
          ),
          child: Icon(
            Icons.audiotrack,
            size: widget.size * 0.6,
            color: Colors.white,
          ),
        );
      },
    );
  }
}

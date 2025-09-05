import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../state/providers.dart';
import '../../domain/services/audio_service.dart' as audio_service;
import 'mobile_audio_player.dart';
import 'mobile_audio_controls.dart';
import 'mobile_audio_gestures.dart';

/// Mobile Audio Manager - Central hub for mobile-optimized audio functionality
/// Integrates with existing QuranAudioService while providing mobile-first interface
class MobileAudioManager extends ConsumerStatefulWidget {
  const MobileAudioManager({
    super.key,
    this.child,
    this.showFloatingPlayer = true,
    this.enableGlobalGestures = false,
  });

  final Widget? child;
  final bool showFloatingPlayer;
  final bool enableGlobalGestures;

  @override
  ConsumerState<MobileAudioManager> createState() => _MobileAudioManagerState();
}

class _MobileAudioManagerState extends ConsumerState<MobileAudioManager> {
  bool _isPlayerVisible = false;
  bool _isPlayerMinimized = true;

  @override
  void initState() {
    super.initState();

    // Listen to audio state changes to show/hide player
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToAudioState();
    });
  }

  void _listenToAudioState() {
    ref.listen(audioStateProvider, (previous, next) {
      next.when(
        data: (state) {
          final shouldShow = state != audio_service.AudioState.stopped;

          if (shouldShow != _isPlayerVisible) {
            setState(() {
              _isPlayerVisible = shouldShow;
            });
          }
        },
        loading: () {},
        error: (_, __) {
          setState(() {
            _isPlayerVisible = false;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child ?? const SizedBox.shrink();

    // Wrap with global gestures if enabled
    if (widget.enableGlobalGestures) {
      content = _wrapWithGlobalGestures(content);
    }

    // Add floating player overlay
    if (widget.showFloatingPlayer) {
      content = _addFloatingPlayer(content);
    }

    return content;
  }

  Widget _wrapWithGlobalGestures(Widget child) {
    return AudioGestureHandler(
      onPlayPause: _handleGlobalPlayPause,
      onNext: _handleGlobalNext,
      onPrevious: _handleGlobalPrevious,
      onMinimize: _handleMinimizePlayer,
      onExpand: _handleExpandPlayer,
      child: child,
    );
  }

  Widget _addFloatingPlayer(Widget child) {
    return Stack(
      children: [
        child,

        // Floating audio player
        if (_isPlayerVisible)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: MobileAudioPlayer(
                isMinimized: _isPlayerMinimized,
                onMinimize: _handleMinimizePlayer,
                onExpand: _handleExpandPlayer,
                onClose: _handleClosePlayer,
              ),
            ),
          ),
      ],
    );
  }

  // Global gesture handlers
  void _handleGlobalPlayPause() {
    final audioState = ref.read(audioStateProvider);
    final service = ref.read(quranAudioServiceProvider);

    audioState.whenData((state) {
      switch (state) {
        case audio_service.AudioState.playing:
          service.pause();
          break;
        case audio_service.AudioState.paused:
          service.play();
          break;
        case audio_service.AudioState.stopped:
          if (service.playlist.isNotEmpty) {
            service.playVerse(service.currentIndex);
          }
          break;
        default:
          break;
      }
    });

    HapticFeedback.lightImpact();
  }

  void _handleGlobalNext() {
    final service = ref.read(quranAudioServiceProvider);
    service.next();
    HapticFeedback.lightImpact();
  }

  void _handleGlobalPrevious() {
    final service = ref.read(quranAudioServiceProvider);
    service.previous();
    HapticFeedback.lightImpact();
  }

  // Player state handlers
  void _handleMinimizePlayer() {
    setState(() {
      _isPlayerMinimized = true;
    });
    HapticFeedback.selectionClick();
  }

  void _handleExpandPlayer() {
    setState(() {
      _isPlayerMinimized = false;
    });
    HapticFeedback.selectionClick();
  }

  void _handleClosePlayer() {
    final service = ref.read(quranAudioServiceProvider);
    service.stop();

    setState(() {
      _isPlayerVisible = false;
      _isPlayerMinimized = true;
    });

    HapticFeedback.lightImpact();
  }
}

/// Mobile Audio Service Extensions
/// Helper methods for common mobile audio operations
extension MobileAudioServiceExtensions on audio_service.QuranAudioService {
  /// Play verse with mobile-optimized user feedback
  Future<void> playVerseMobile(int index,
      {Future<void> Function()? onPromptDownload}) async {
    // Set download prompt callback for mobile
    final callback = onPromptDownload ??
        () async {
          // Placeholder: integrate proper prompt if needed
        };
    // Attach prompt to service if not set
    onPromptDownload ??= callback;
    await playVerse(index);
  }

  /// Get mobile-friendly verse title
  String getVerseTitleMobile(audio_service.VerseAudio verse) {
    final parts = verse.verseKey.split(':');
    if (parts.length == 2) {
      final chapter = int.tryParse(parts[0]) ?? 0;
      final ayah = int.tryParse(parts[1]) ?? 0;
      return 'Surah $chapter, Verse $ayah';
    }
    return verse.verseKey;
  }

  /// Get mobile-friendly playlist info
  String getPlaylistInfoMobile() {
    if (playlist.isEmpty) return 'No playlist';
    final current = currentIndex + 1;
    final total = playlist.length;
    return '$current of $total verses';
  }
}

/// Mobile Audio Control Button for integration into existing UIs
class MobileAudioControlButton extends ConsumerWidget {
  const MobileAudioControlButton({
    super.key,
    this.verse,
    this.verses,
    this.size = 48.0,
    this.style = MobileAudioButtonStyle.primary,
  });

  final audio_service.VerseAudio? verse;
  final List<audio_service.VerseAudio>? verses;
  final double size;
  final MobileAudioButtonStyle style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioStateProvider);
    final service = ref.watch(quranAudioServiceProvider);

    return MobileAudioControls.playPauseButton(
      audioState: audioState,
      onPressed: () => _handlePress(ref, service),
      size: size,
    );
  }

  void _handlePress(WidgetRef ref, audio_service.QuranAudioService service) {
    if (verse != null) {
      // Single verse playback
      final playlist = verses ?? [verse!];
      service.setPlaylist(playlist);
      final index = playlist.indexOf(verse!);
      service.playVerse(index >= 0 ? index : 0);
    } else if (verses != null && verses!.isNotEmpty) {
      // Playlist playback
      service.setPlaylist(verses!);
      service.playVerse(0);
    }

    HapticFeedback.lightImpact();
  }
}

enum MobileAudioButtonStyle {
  primary,
  secondary,
  minimal,
}

/// Mobile Audio Download Manager
/// Handles mobile-optimized download operations
class MobileAudioDownloadManager {
  static Future<void> downloadVerseWithProgress({
    required audio_service.VerseAudio verse,
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    final service = ref.read(quranAudioServiceProvider);

    try {
      // Show mobile-optimized download progress
      _showDownloadProgress(context, verse);

      await service.downloadVerseAudio(verse);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Downloaded ${verse.verseKey}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Download failed: ${e.toString()}',
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  static void _showDownloadProgress(
      BuildContext context, audio_service.VerseAudio verse) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              'Downloading ${verse.verseKey}...',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );

    // Auto-dismiss after a reasonable time
    Future.delayed(const Duration(seconds: 10), () {
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  static Future<bool> showDownloadPrompt({
    required BuildContext context,
    required audio_service.VerseAudio verse,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.audioDownloadsTitle),
        content: Text(
          'Would you like to download ${verse.verseKey} for offline playback?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Download'),
          ),
        ],
      ),
    );

    return result ?? false;
  }
}

/// Quick Mobile Audio Actions
/// Utility class for common mobile audio actions
class QuickMobileAudioActions {
  static void playVerseQuick({
    required WidgetRef ref,
    required audio_service.VerseAudio verse,
    List<audio_service.VerseAudio>? playlist,
  }) {
    final service = ref.read(quranAudioServiceProvider);

    final audioPlaylist = playlist ?? [verse];
    service.setPlaylist(audioPlaylist);

    final index = audioPlaylist.indexOf(verse);
    service.playVerse(index >= 0 ? index : 0);

    HapticFeedback.lightImpact();
  }

  static void togglePlayPauseQuick({required WidgetRef ref}) {
    final audioState = ref.read(audioStateProvider);
    final service = ref.read(quranAudioServiceProvider);

    audioState.whenData((state) {
      switch (state) {
        case audio_service.AudioState.playing:
          service.pause();
          break;
        case audio_service.AudioState.paused:
          service.play();
          break;
        case audio_service.AudioState.stopped:
          if (service.playlist.isNotEmpty) {
            service.playVerse(service.currentIndex);
          }
          break;
        default:
          break;
      }
    });

    HapticFeedback.lightImpact();
  }

  static void nextTrackQuick({required WidgetRef ref}) {
    final service = ref.read(quranAudioServiceProvider);
    service.next();
    HapticFeedback.lightImpact();
  }

  static void previousTrackQuick({required WidgetRef ref}) {
    final service = ref.read(quranAudioServiceProvider);
    service.previous();
    HapticFeedback.lightImpact();
  }

  static void seekQuick({
    required WidgetRef ref,
    required Duration position,
  }) {
    final service = ref.read(quranAudioServiceProvider);
    service.seek(position);
    HapticFeedback.selectionClick();
  }

  static void showAudioDownloads({required BuildContext context}) {
    Navigator.pushNamed(context, '/audio-downloads');
  }
}

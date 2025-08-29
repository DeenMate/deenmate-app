import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../state/providers.dart';
import '../../domain/services/audio_service.dart' as audio_service;
import '../../../../core/theme/theme_helper.dart';

/// Mobile-optimized audio controls with touch-friendly buttons and gestures
/// Provides play/pause, next/previous, and seeking functionality
class MobileAudioControls extends ConsumerWidget {
  const MobileAudioControls({
    super.key,
    required this.audioState,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onSeek,
    this.showSeekButtons = true,
    this.buttonSize = 48.0,
  });

  final AsyncValue<audio_service.AudioState> audioState;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final ValueChanged<Duration> onSeek;
  final bool showSeekButtons;
  final double buttonSize;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous button
        _buildControlButton(
          context,
          icon: Icons.skip_previous,
          onPressed: onPrevious,
          tooltip: AppLocalizations.of(context)!.audioPrevious,
          size: buttonSize * 0.8,
        ),
        
        // Seek backward button (mobile-specific)
        if (showSeekButtons)
          _buildSeekButton(
            context,
            icon: Icons.replay_10,
            onPressed: () => _seekRelative(ref, -10),
            tooltip: AppLocalizations.of(context)!.audioSeekBackward,
            size: buttonSize * 0.7,
          ),
        
        // Play/Pause button (prominent)
        playPauseButton(
          audioState: audioState,
          onPressed: onPlayPause,
          size: buttonSize,
        ),
        
        // Seek forward button (mobile-specific)
        if (showSeekButtons)
          _buildSeekButton(
            context,
            icon: Icons.forward_10,
            onPressed: () => _seekRelative(ref, 10),
            tooltip: AppLocalizations.of(context)!.audioSeekForward,
            size: buttonSize * 0.7,
          ),
        
        // Next button
        _buildControlButton(
          context,
          icon: Icons.skip_next,
          onPressed: onNext,
          tooltip: AppLocalizations.of(context)!.audioNext,
          size: buttonSize * 0.8,
        ),
      ],
    );
  }

  /// Static method for creating a standalone play/pause button
  static Widget playPauseButton({
    required AsyncValue<audio_service.AudioState> audioState,
    required VoidCallback onPressed,
    double size = 48.0,
  }) {
    return Builder(
      builder: (context) {
        return audioState.when(
          data: (state) => _buildPlayPauseButton(
            context,
            state: state,
            onPressed: onPressed,
            size: size,
          ),
          loading: () => _buildLoadingButton(context, size: size),
          error: (_, __) => _buildErrorButton(context, size: size),
        );
      },
    );
  }

  static Widget _buildPlayPauseButton(
    BuildContext context, {
    required audio_service.AudioState state,
    required VoidCallback onPressed,
    required double size,
  }) {
    IconData icon;
    Color? backgroundColor;
    Color? iconColor;
    
    switch (state) {
      case audio_service.AudioState.playing:
        icon = Icons.pause;
        backgroundColor = ThemeHelper.getAccentColor(context);
        iconColor = Colors.white;
        break;
      case audio_service.AudioState.paused:
        icon = Icons.play_arrow;
        backgroundColor = ThemeHelper.getAccentColor(context);
        iconColor = Colors.white;
        break;
      case audio_service.AudioState.buffering:
        // Will show loading indicator instead
        icon = Icons.play_arrow;
        backgroundColor = ThemeHelper.getAccentColor(context).withOpacity(0.6);
        iconColor = Colors.white;
        break;
      case audio_service.AudioState.stopped:
      default:
        icon = Icons.play_arrow;
        backgroundColor = ThemeHelper.getAccentColor(context).withOpacity(0.8);
        iconColor = Colors.white;
        break;
    }

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(size / 2),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: ThemeHelper.getAccentColor(context).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: state == audio_service.AudioState.buffering
            ? _buildLoadingIndicator(context, size: size * 0.5)
            : Icon(
                icon,
                size: size * 0.5,
                color: iconColor,
              ),
      ),
    );
  }

  static Widget _buildLoadingButton(BuildContext context, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: ThemeHelper.getAccentColor(context).withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: _buildLoadingIndicator(context, size: size * 0.5),
    );
  }

  static Widget _buildErrorButton(BuildContext context, {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.6),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.error_outline,
        size: size * 0.5,
        color: Colors.white,
      ),
    );
  }

  static Widget _buildLoadingIndicator(BuildContext context, {required double size}) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required double size,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: ThemeHelper.getSurfaceColor(context),
            shape: BoxShape.circle,
            border: Border.all(
              color: ThemeHelper.getAccentColor(context).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: size * 0.45,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildSeekButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
    required double size,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: ThemeHelper.getAccentColor(context).withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: ThemeHelper.getAccentColor(context).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            size: size * 0.5,
            color: ThemeHelper.getAccentColor(context),
          ),
        ),
      ),
    );
  }

  void _seekRelative(WidgetRef ref, int seconds) {
    final position = ref.read(audioPositionProvider);
    
    position.whenData((currentPosition) {
      final newPosition = Duration(
        milliseconds: currentPosition.inMilliseconds + (seconds * 1000),
      );
      
      // Ensure we don't seek beyond the duration or before start
      final clampedPosition = Duration(
        milliseconds: newPosition.inMilliseconds.clamp(0, double.infinity).toInt(),
      );
      
      onSeek(clampedPosition);
    });
    
    HapticFeedback.selectionClick();
  }
}

/// Compact mobile audio controls for minimized player
class CompactMobileAudioControls extends ConsumerWidget {
  const CompactMobileAudioControls({
    super.key,
    required this.audioState,
    required this.onPlayPause,
    this.buttonSize = 32.0,
    this.showProgress = true,
  });

  final AsyncValue<audio_service.AudioState> audioState;
  final VoidCallback onPlayPause;
  final double buttonSize;
  final bool showProgress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Compact play/pause button
        MobileAudioControls.playPauseButton(
          audioState: audioState,
          onPressed: onPlayPause,
          size: buttonSize,
        ),
        
        if (showProgress) ...[
          const SizedBox(width: 8),
          // Compact progress indicator
          _buildCompactProgress(context, ref),
        ],
      ],
    );
  }

  Widget _buildCompactProgress(BuildContext context, WidgetRef ref) {
    final position = ref.watch(audioPositionProvider);
    final duration = ref.watch(audioDurationProvider);
    
    return SizedBox(
      width: 40,
      height: 4,
      child: position.when(
        data: (pos) => duration.when(
          data: (dur) {
            if (dur.inMilliseconds == 0) {
              return Container(
                decoration: BoxDecoration(
                  color: ThemeHelper.getAccentColor(context).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              );
            }
            
            final progress = pos.inMilliseconds / dur.inMilliseconds;
            
            return Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ThemeHelper.getAccentColor(context).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: progress.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: ThemeHelper.getAccentColor(context),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => Container(
            decoration: BoxDecoration(
              color: ThemeHelper.getAccentColor(context).withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
        loading: () => Container(
          decoration: BoxDecoration(
            color: ThemeHelper.getAccentColor(context).withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

/// Mobile audio control panel for quick access
class MobileAudioControlPanel extends ConsumerWidget {
  const MobileAudioControlPanel({
    super.key,
    this.backgroundColor,
    this.padding = const EdgeInsets.all(16),
  });

  final Color? backgroundColor;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioStateProvider);
    final service = ref.watch(quranAudioServiceProvider);
    
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick info
          _buildQuickInfo(context, service.currentVerse),
          
          const SizedBox(height: 16),
          
          // Main controls
          MobileAudioControls(
            audioState: audioState,
            onPlayPause: () => _handlePlayPause(ref, audioState),
            onNext: () => service.next(),
            onPrevious: () => service.previous(),
            onSeek: (position) => service.seek(position),
            showSeekButtons: false, // Simplified for panel
          ),
        ],
      ),
    );
  }

  Widget _buildQuickInfo(BuildContext context, audio_service.VerseAudio? verse) {
    if (verse == null) {
      return Text(
        AppLocalizations.of(context)!.audioNoTrackSelected,
        style: TextStyle(
          fontSize: 14,
          color: ThemeHelper.getTextSecondaryColor(context),
        ),
      );
    }
    
    return Text(
      verse.verseKey,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ThemeHelper.getTextPrimaryColor(context),
      ),
    );
  }

  void _handlePlayPause(WidgetRef ref, AsyncValue<audio_service.AudioState> audioState) {
    final service = ref.read(quranAudioServiceProvider);
    
    audioState.whenData((state) {
      switch (state) {
        case audio_service.AudioState.playing:
          service.pause();
          break;
        case audio_service.AudioState.paused:
          service.resume();
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
}

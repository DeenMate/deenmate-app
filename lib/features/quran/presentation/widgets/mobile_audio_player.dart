import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../state/providers.dart';
import '../../domain/services/audio_service.dart' as audio_service;
import '../../../../core/theme/theme_helper.dart';
import 'mobile_audio_controls.dart';
import 'mobile_audio_gestures.dart';

/// Mobile-optimized floating audio player with swipe controls and responsive design
/// Integrates with existing QuranAudioService while providing touch-first interface
class MobileAudioPlayer extends ConsumerStatefulWidget {
  const MobileAudioPlayer({
    super.key,
    this.isMinimized = false,
    this.onMinimize,
    this.onExpand,
    this.onClose,
  });

  final bool isMinimized;
  final VoidCallback? onMinimize;
  final VoidCallback? onExpand;
  final VoidCallback? onClose;

  @override
  ConsumerState<MobileAudioPlayer> createState() => _MobileAudioPlayerState();
}

class _MobileAudioPlayerState extends ConsumerState<MobileAudioPlayer>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _expandController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _expandAnimation;
  
  // Mobile-specific controllers
  late AnimationController _swipeIndicatorController;
  late Animation<double> _swipeIndicatorAnimation;
  
  bool _isDragging = false;
  double _dragOffset = 0.0;
  
  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    
    _swipeIndicatorController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    
    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeInOut,
    ));
    
    _swipeIndicatorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _swipeIndicatorController,
      curve: Curves.elasticOut,
    ));
    
    _slideController.forward();
    
    if (!widget.isMinimized) {
      _expandController.forward();
    }
  }

  @override
  void didUpdateWidget(MobileAudioPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isMinimized != oldWidget.isMinimized) {
      if (widget.isMinimized) {
        _expandController.reverse();
      } else {
        _expandController.forward();
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _expandController.dispose();
    _swipeIndicatorController.dispose();
    super.dispose();
  }

  void _handleSwipeGesture(double delta) {
    if (delta > 50) {
      // Swipe down - minimize
      widget.onMinimize?.call();
      HapticFeedback.lightImpact();
    } else if (delta < -50) {
      // Swipe up - expand
      widget.onExpand?.call();
      HapticFeedback.lightImpact();
    }
  }

  void _showSwipeIndicator() {
    _swipeIndicatorController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          _swipeIndicatorController.reverse();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioStateProvider);
    final currentVerse = ref.watch(quranAudioServiceProvider).currentVerse;
    
    // Don't show player if no audio is active
    if (audioState.when(
      data: (state) => state == audio_service.AudioState.stopped,
      loading: () => true,
      error: (_, __) => true,
    )) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _slideAnimation,
      child: _buildMobilePlayer(context, audioState, currentVerse),
    );
  }

  Widget _buildMobilePlayer(
    BuildContext context,
    AsyncValue<audio_service.AudioState> audioState,
    audio_service.VerseAudio? currentVerse,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 768;
    
    return MobileAudioGestures(
      onSwipeVertical: _handleSwipeGesture,
      onSwipeHorizontal: (delta) => _handleHorizontalSwipe(delta),
      onTap: widget.isMinimized ? widget.onExpand : null,
      child: AnimatedBuilder(
        animation: _expandAnimation,
        builder: (context, child) {
          final isExpanded = _expandAnimation.value > 0.5;
          
          return Container(
            width: screenWidth - (isTablet ? 32 : 16),
            margin: EdgeInsets.symmetric(
              horizontal: isTablet ? 16 : 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: ThemeHelper.getSurfaceColor(context),
              borderRadius: BorderRadius.circular(isExpanded ? 20 : 12),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.15),
                  blurRadius: isExpanded ? 25 : 15,
                  offset: Offset(0, isExpanded ? 12 : 6),
                ),
              ],
            ),
            child: isExpanded
                ? _buildExpandedPlayer(context, audioState, currentVerse)
                : _buildMinimizedPlayer(context, audioState, currentVerse),
          );
        },
      ),
    );
  }

  Widget _buildMinimizedPlayer(
    BuildContext context,
    AsyncValue<audio_service.AudioState> audioState,
    audio_service.VerseAudio? currentVerse,
  ) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Mobile play/pause button
          MobileAudioControls.playPauseButton(
            audioState: audioState,
            onPressed: () => _handlePlayPause(audioState),
            size: 40,
          ),
          
          const SizedBox(width: 16),
          
          // Verse info - mobile optimized
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getVerseTitle(context, currentVerse),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _getVerseSubtitle(context, currentVerse),
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          const SizedBox(width: 12),
          
          // Mobile progress indicator
          SizedBox(
            width: 32,
            height: 32,
            child: _buildMobileProgressIndicator(context),
          ),
          
          const SizedBox(width: 12),
          
          // Swipe indicator
          AnimatedBuilder(
            animation: _swipeIndicatorAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _swipeIndicatorAnimation.value * 0.6,
                child: Icon(
                  Icons.keyboard_arrow_up,
                  size: 20,
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedPlayer(
    BuildContext context,
    AsyncValue<audio_service.AudioState> audioState,
    audio_service.VerseAudio? currentVerse,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.6; // Max 60% of screen height
    
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with minimize control
          _buildExpandedHeader(context),
          
          const SizedBox(height: 24),
          
          // Verse information card
          _buildVerseInfoCard(context, currentVerse),
          
          const SizedBox(height: 24),
          
          // Mobile audio controls
          MobileAudioControls(
            audioState: audioState,
            onPlayPause: () => _handlePlayPause(audioState),
            onNext: _handleNext,
            onPrevious: _handlePrevious,
            onSeek: _handleSeek,
          ),
          
          const SizedBox(height: 16),
          
          // Mobile progress bar
          _buildMobileProgressBar(context),
          
          const SizedBox(height: 16),
          
          // Additional controls (repeat, speed, etc.)
          _buildAdditionalControls(context),
        ],
      ),
    );
  }

  Widget _buildExpandedHeader(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.music_note,
          size: 20,
          color: ThemeHelper.getAccentColor(context),
        ),
        const SizedBox(width: 8),
        Text(
          AppLocalizations.of(context)!.audioPlayerNowPlaying,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: widget.onMinimize,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            child: Icon(
              Icons.keyboard_arrow_down,
              size: 24,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerseInfoCard(BuildContext context, audio_service.VerseAudio? currentVerse) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelper.getAccentColor(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeHelper.getAccentColor(context).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            _getVerseTitle(context, currentVerse),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getVerseSubtitle(context, currentVerse),
            style: TextStyle(
              fontSize: 14,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMobileProgressIndicator(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final position = ref.watch(audioPositionProvider);
        final duration = ref.watch(audioDurationProvider);
        
        return position.when(
          data: (pos) => duration.when(
            data: (dur) {
              if (dur.inMilliseconds == 0) return const SizedBox.shrink();
              
              final progress = pos.inMilliseconds / dur.inMilliseconds;
              
              return CircularProgressIndicator(
                value: progress.clamp(0.0, 1.0),
                strokeWidth: 3,
                backgroundColor: ThemeHelper.getAccentColor(context).withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(
                  ThemeHelper.getAccentColor(context),
                ),
              );
            },
            loading: () => CircularProgressIndicator(
              strokeWidth: 3,
              backgroundColor: ThemeHelper.getAccentColor(context).withOpacity(0.2),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
          loading: () => CircularProgressIndicator(
            strokeWidth: 3,
            backgroundColor: ThemeHelper.getAccentColor(context).withOpacity(0.2),
          ),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildMobileProgressBar(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final position = ref.watch(audioPositionProvider);
        final duration = ref.watch(audioDurationProvider);
        
        return position.when(
          data: (pos) => duration.when(
            data: (dur) => _buildProgressSlider(context, pos, dur),
            loading: () => _buildProgressSliderSkeleton(context),
            error: (_, __) => const SizedBox.shrink(),
          ),
          loading: () => _buildProgressSliderSkeleton(context),
          error: (_, __) => const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildProgressSlider(BuildContext context, Duration position, Duration duration) {
    if (duration.inMilliseconds == 0) return const SizedBox.shrink();
    
    final progress = position.inMilliseconds / duration.inMilliseconds;
    
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
            activeTrackColor: ThemeHelper.getAccentColor(context),
            inactiveTrackColor: ThemeHelper.getAccentColor(context).withOpacity(0.2),
            thumbColor: ThemeHelper.getAccentColor(context),
            overlayColor: ThemeHelper.getAccentColor(context).withOpacity(0.2),
          ),
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: (value) {
              final newPosition = Duration(
                milliseconds: (value * duration.inMilliseconds).round(),
              );
              _handleSeek(newPosition);
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(position),
              style: TextStyle(
                fontSize: 12,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            Text(
              _formatDuration(duration),
              style: TextStyle(
                fontSize: 12,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressSliderSkeleton(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: ThemeHelper.getAccentColor(context).withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '--:--',
              style: TextStyle(
                fontSize: 12,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            Text(
              '--:--',
              style: TextStyle(
                fontSize: 12,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdditionalControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Repeat button
        _buildControlButton(
          context,
          icon: Icons.repeat,
          onPressed: _handleRepeat,
          tooltip: AppLocalizations.of(context)!.audioRepeat,
        ),
        
        // Speed control button
        _buildControlButton(
          context,
          icon: Icons.speed,
          onPressed: _handleSpeedControl,
          tooltip: AppLocalizations.of(context)!.audioSpeed,
        ),
        
        // Close button
        _buildControlButton(
          context,
          icon: Icons.close,
          onPressed: widget.onClose,
          tooltip: AppLocalizations.of(context)!.close,
        ),
      ],
    );
  }

  Widget _buildControlButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback? onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 40,
          height: 40,
          child: Icon(
            icon,
            size: 20,
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
      ),
    );
  }

  // Audio control handlers
  void _handlePlayPause(AsyncValue<audio_service.AudioState> audioState) {
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
          // Start playing current playlist if available
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

  void _handleNext() {
    final service = ref.read(quranAudioServiceProvider);
    service.next();
    HapticFeedback.lightImpact();
  }

  void _handlePrevious() {
    final service = ref.read(quranAudioServiceProvider);
    service.previous();
    HapticFeedback.lightImpact();
  }

  void _handleSeek(Duration position) {
    final service = ref.read(quranAudioServiceProvider);
    service.seek(position);
    HapticFeedback.selectionClick();
  }

  void _handleRepeat() {
    final service = ref.read(quranAudioServiceProvider);
    service.toggleRepeatMode();
    HapticFeedback.lightImpact();
  }

  void _handleSpeedControl() {
    final service = ref.read(quranAudioServiceProvider);
    // Cycle through common playback speeds: 1.0x -> 1.25x -> 1.5x -> 0.75x -> 1.0x
    final currentSpeed = service.playbackSpeed;
    double newSpeed;
    
    if (currentSpeed == 1.0) {
      newSpeed = 1.25;
    } else if (currentSpeed == 1.25) {
      newSpeed = 1.5;
    } else if (currentSpeed == 1.5) {
      newSpeed = 0.75;
    } else {
      newSpeed = 1.0;
    }
    
    service.setPlaybackSpeed(newSpeed);
    HapticFeedback.lightImpact();
    
    // Show speed change feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${AppLocalizations.of(context)!.audioSpeed}: ${newSpeed}x'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _handleHorizontalSwipe(double delta) {
    if (delta > 50) {
      // Swipe right - previous
      _handlePrevious();
    } else if (delta < -50) {
      // Swipe left - next
      _handleNext();
    }
  }

  // Utility methods
  String _getVerseTitle(BuildContext context, audio_service.VerseAudio? verse) {
    if (verse == null) return AppLocalizations.of(context)!.audioPlayerNowPlaying;
    
    // Parse verse key (e.g., "2:255" -> "Surah Al-Baqarah, Verse 255")
    final parts = verse.verseKey.split(':');
    if (parts.length == 2) {
      final chapterNum = int.tryParse(parts[0]) ?? 0;
      final verseNum = int.tryParse(parts[1]) ?? 0;
      
      // You might want to get chapter name from a service/provider here
      return 'Surah $chapterNum, Verse $verseNum';
    }
    
    return verse.verseKey;
  }

  String _getVerseSubtitle(BuildContext context, audio_service.VerseAudio? verse) {
    if (verse == null) return '';
    
    final service = ref.read(quranAudioServiceProvider);
    final total = service.playlist.length;
    final current = service.currentIndex + 1;
    
    return '$current of $total verses';
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

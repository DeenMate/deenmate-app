import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Mobile gesture detector for audio player interactions
/// Handles swipe gestures for audio navigation and player controls
class MobileAudioGestures extends StatefulWidget {
  const MobileAudioGestures({
    super.key,
    required this.child,
    this.onSwipeVertical,
    this.onSwipeHorizontal,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.swipeThreshold = 50.0,
    this.enableHapticFeedback = true,
  });

  final Widget child;
  final ValueChanged<double>? onSwipeVertical; // Positive = down, Negative = up
  final ValueChanged<double>? onSwipeHorizontal; // Positive = right, Negative = left
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final VoidCallback? onLongPress;
  final double swipeThreshold;
  final bool enableHapticFeedback;

  @override
  State<MobileAudioGestures> createState() => _MobileAudioGesturesState();
}

class _MobileAudioGesturesState extends State<MobileAudioGestures>
    with TickerProviderStateMixin {
  late AnimationController _feedbackController;
  late Animation<double> _feedbackAnimation;
  
  Offset? _panStart;
  bool _isSwipeDetected = false;
  DateTime? _lastTap;
  
  @override
  void initState() {
    super.initState();
    
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    
    _feedbackAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _feedbackController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _feedbackController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _feedbackController.reverse();
  }

  void _handleTapCancel() {
    _feedbackController.reverse();
  }

  void _handleTap() {
    if (widget.onTap != null) {
      widget.onTap!();
      
      if (widget.enableHapticFeedback) {
        HapticFeedback.lightImpact();
      }
    }
    
    // Handle double tap detection
    final now = DateTime.now();
    if (_lastTap != null && 
        now.difference(_lastTap!).inMilliseconds < 300 &&
        widget.onDoubleTap != null) {
      widget.onDoubleTap!();
      _lastTap = null; // Reset to prevent triple tap
      
      if (widget.enableHapticFeedback) {
        HapticFeedback.mediumImpact();
      }
    } else {
      _lastTap = now;
    }
  }

  void _handleLongPress() {
    if (widget.onLongPress != null) {
      widget.onLongPress!();
      
      if (widget.enableHapticFeedback) {
        HapticFeedback.heavyImpact();
      }
    }
  }

  void _handlePanStart(DragStartDetails details) {
    _panStart = details.localPosition;
    _isSwipeDetected = false;
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_panStart == null || _isSwipeDetected) return;
    
    final delta = details.localPosition - _panStart!;
    final absDeltaX = delta.dx.abs();
    final absDeltaY = delta.dy.abs();
    
    // Determine if this is a significant swipe
    if (absDeltaX > widget.swipeThreshold || absDeltaY > widget.swipeThreshold) {
      _isSwipeDetected = true;
      
      // Determine direction and trigger appropriate callback
      if (absDeltaX > absDeltaY) {
        // Horizontal swipe
        if (widget.onSwipeHorizontal != null) {
          widget.onSwipeHorizontal!(delta.dx);
          
          if (widget.enableHapticFeedback) {
            HapticFeedback.selectionClick();
          }
        }
      } else {
        // Vertical swipe
        if (widget.onSwipeVertical != null) {
          widget.onSwipeVertical!(delta.dy);
          
          if (widget.enableHapticFeedback) {
            HapticFeedback.selectionClick();
          }
        }
      }
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    _panStart = null;
    _isSwipeDetected = false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: _handleTap,
      onLongPress: _handleLongPress,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: AnimatedBuilder(
        animation: _feedbackAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _feedbackAnimation.value,
            child: widget.child,
          );
        },
      ),
    );
  }
}

/// Specialized gesture detector for audio seek operations
class AudioSeekGestures extends StatefulWidget {
  const AudioSeekGestures({
    super.key,
    required this.child,
    required this.onSeek,
    this.seekSensitivity = 1.0,
    this.showSeekPreview = true,
  });

  final Widget child;
  final ValueChanged<double> onSeek; // Relative seek in seconds
  final double seekSensitivity;
  final bool showSeekPreview;

  @override
  State<AudioSeekGestures> createState() => _AudioSeekGesturesState();
}

class _AudioSeekGesturesState extends State<AudioSeekGestures>
    with TickerProviderStateMixin {
  late AnimationController _previewController;
  late Animation<double> _previewAnimation;
  
  double _currentSeek = 0.0;
  bool _iseeking = false;
  Offset? _seekStart;
  
  @override
  void initState() {
    super.initState();
    
    _previewController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _previewAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _previewController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _previewController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    _seekStart = details.localPosition;
    _currentSeek = 0.0;
    _iseeking = false;
    
    if (widget.showSeekPreview) {
      _previewController.forward();
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_seekStart == null) return;
    
    final delta = details.localPosition - _seekStart!;
    final seekAmount = (delta.dx * widget.seekSensitivity) / 10.0; // Convert pixels to seconds
    
    setState(() {
      _currentSeek = seekAmount;
      _iseeking = seekAmount.abs() > 1.0; // Start seeking after 1 second threshold
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_iseeking && _currentSeek.abs() > 1.0) {
      widget.onSeek(_currentSeek);
      HapticFeedback.mediumImpact();
    }
    
    setState(() {
      _currentSeek = 0.0;
      _iseeking = false;
    });
    
    _seekStart = null;
    
    if (widget.showSeekPreview) {
      _previewController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Stack(
        children: [
          widget.child,
          
          // Seek preview overlay
          if (widget.showSeekPreview)
            AnimatedBuilder(
              animation: _previewAnimation,
              builder: (context, child) {
                if (_previewAnimation.value == 0.0 || !_iseeking) {
                  return const SizedBox.shrink();
                }
                
                return Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3 * _previewAnimation.value),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _currentSeek > 0 
                                  ? Icons.fast_forward 
                                  : Icons.fast_rewind,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_currentSeek > 0 ? '+' : ''}${_currentSeek.toStringAsFixed(1)}s',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Volume control gestures for audio player
class AudioVolumeGestures extends StatefulWidget {
  const AudioVolumeGestures({
    super.key,
    required this.child,
    required this.onVolumeChange,
    this.volumeSensitivity = 0.01,
    this.showVolumePreview = true,
  });

  final Widget child;
  final ValueChanged<double> onVolumeChange; // Volume delta (0.0 to 1.0)
  final double volumeSensitivity;
  final bool showVolumePreview;

  @override
  State<AudioVolumeGestures> createState() => _AudioVolumeGesturesState();
}

class _AudioVolumeGesturesState extends State<AudioVolumeGestures>
    with TickerProviderStateMixin {
  late AnimationController _previewController;
  late Animation<double> _previewAnimation;
  
  double _currentVolume = 0.0;
  bool _isAdjustingVolume = false;
  Offset? _volumeStart;
  
  @override
  void initState() {
    super.initState();
    
    _previewController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _previewAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _previewController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _previewController.dispose();
    super.dispose();
  }

  void _handlePanStart(DragStartDetails details) {
    _volumeStart = details.localPosition;
    _currentVolume = 0.0;
    _isAdjustingVolume = false;
    
    if (widget.showVolumePreview) {
      _previewController.forward();
    }
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_volumeStart == null) return;
    
    final delta = details.localPosition - _volumeStart!;
    final volumeDelta = -delta.dy * widget.volumeSensitivity; // Invert Y axis
    
    setState(() {
      _currentVolume = volumeDelta.clamp(-1.0, 1.0);
      _isAdjustingVolume = _currentVolume.abs() > 0.05; // Start adjusting after small threshold
    });
    
    if (_isAdjustingVolume) {
      widget.onVolumeChange(_currentVolume);
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    setState(() {
      _currentVolume = 0.0;
      _isAdjustingVolume = false;
    });
    
    _volumeStart = null;
    
    if (widget.showVolumePreview) {
      _previewController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Stack(
        children: [
          widget.child,
          
          // Volume preview overlay
          if (widget.showVolumePreview)
            AnimatedBuilder(
              animation: _previewAnimation,
              builder: (context, child) {
                if (_previewAnimation.value == 0.0 || !_isAdjustingVolume) {
                  return const SizedBox.shrink();
                }
                
                return Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3 * _previewAnimation.value),
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _currentVolume > 0 
                                  ? Icons.volume_up 
                                  : Icons.volume_down,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(_currentVolume * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

/// Combined gesture handler for comprehensive audio control
class AudioGestureHandler extends StatelessWidget {
  const AudioGestureHandler({
    super.key,
    required this.child,
    this.onPlayPause,
    this.onNext,
    this.onPrevious,
    this.onSeek,
    this.onVolumeChange,
    this.onMinimize,
    this.onExpand,
    this.enableAllGestures = true,
  });

  final Widget child;
  final VoidCallback? onPlayPause;
  final VoidCallback? onNext;
  final VoidCallback? onPrevious;
  final ValueChanged<double>? onSeek;
  final ValueChanged<double>? onVolumeChange;
  final VoidCallback? onMinimize;
  final VoidCallback? onExpand;
  final bool enableAllGestures;

  @override
  Widget build(BuildContext context) {
    Widget gestureChild = child;
    
    // Layer gestures in order of precedence
    if (enableAllGestures && onVolumeChange != null) {
      gestureChild = AudioVolumeGestures(
        onVolumeChange: onVolumeChange!,
        child: gestureChild,
      );
    }
    
    if (enableAllGestures && onSeek != null) {
      gestureChild = AudioSeekGestures(
        onSeek: onSeek!,
        child: gestureChild,
      );
    }
    
    gestureChild = MobileAudioGestures(
      onTap: onPlayPause,
      onSwipeHorizontal: (delta) {
        if (delta > 50 && onPrevious != null) {
          onPrevious!();
        } else if (delta < -50 && onNext != null) {
          onNext!();
        }
      },
      onSwipeVertical: (delta) {
        if (delta > 50 && onMinimize != null) {
          onMinimize!();
        } else if (delta < -50 && onExpand != null) {
          onExpand!();
        }
      },
      child: gestureChild,
    );
    
    return gestureChild;
  }
}

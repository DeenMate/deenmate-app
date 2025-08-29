import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/dto/verse_dto.dart';
import 'mobile_verse_actions.dart';

/// Enhanced verse widget with mobile gestures and improved interactions
class MobileEnhancedVerseWidget extends ConsumerStatefulWidget {
  const MobileEnhancedVerseWidget({
    super.key,
    required this.verse,
    required this.isBookmarked,
    required this.onPlay,
    required this.onBookmarkToggle,
    required this.onShare,
    required this.onShowOptions,
    this.showArabic = true,
    this.showTranslation = true,
    this.enableGestures = true,
  });

  final VerseDto verse;
  final bool isBookmarked;
  final VoidCallback onPlay;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onShare;
  final VoidCallback onShowOptions;
  final bool showArabic;
  final bool showTranslation;
  final bool enableGestures;

  @override
  ConsumerState<MobileEnhancedVerseWidget> createState() => _MobileEnhancedVerseWidgetState();
}

class _MobileEnhancedVerseWidgetState extends ConsumerState<MobileEnhancedVerseWidget>
    with TickerProviderStateMixin {
  late AnimationController _highlightController;
  late AnimationController _swipeController;
  late Animation<Color?> _highlightAnimation;
  late Animation<Offset> _swipeAnimation;
  
  bool _isHighlighted = false;
  bool _showActions = false;
  String _currentGesture = '';

  @override
  void initState() {
    super.initState();
    
    _highlightController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _highlightAnimation = ColorTween(
      begin: Colors.transparent,
      end: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
    ).animate(CurvedAnimation(
      parent: _highlightController,
      curve: Curves.easeInOut,
    ));
    
    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.05, 0),
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _highlightController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _showActions = !_showActions;
    });
    
    HapticFeedback.lightImpact();
    _triggerHighlight();
  }

  void _handleLongPress() {
    widget.onShowOptions();
    HapticFeedback.mediumImpact();
    _triggerHighlight();
  }

  void _handleSwipeLeft() {
    if (!widget.enableGestures) return;
    
    _currentGesture = 'bookmark';
    widget.onBookmarkToggle();
    _triggerSwipeAnimation();
    HapticFeedback.lightImpact();
  }

  void _handleSwipeRight() {
    if (!widget.enableGestures) return;
    
    _currentGesture = 'share';
    widget.onShare();
    _triggerSwipeAnimation();
    HapticFeedback.lightImpact();
  }

  void _handleDoubleTap() {
    if (!widget.enableGestures) return;
    
    _currentGesture = 'play';
    widget.onPlay();
    _triggerHighlight();
    HapticFeedback.selectionClick();
  }

  void _triggerHighlight() {
    _highlightController.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          _highlightController.reverse();
        }
      });
    });
  }

  void _triggerSwipeAnimation() {
    _swipeController.forward().then((_) {
      _swipeController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = MediaQuery.of(context).size.width >= 768;
    
    return AnimatedBuilder(
      animation: Listenable.merge([_highlightAnimation, _swipeAnimation]),
      builder: (context, child) {
        return Transform.translate(
          offset: _swipeAnimation.value,
          child: GestureDetector(
            onTap: _handleTap,
            onLongPress: _handleLongPress,
            onDoubleTap: _handleDoubleTap,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _highlightAnimation.value ?? ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
                ),
                boxShadow: _isHighlighted
                    ? [
                        BoxShadow(
                          color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verse header with number
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          widget.verse.verseNumber.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: ThemeHelper.getPrimaryColor(context),
                          ),
                        ),
                      ),
                      
                      const Spacer(),
                      
                      // Quick gesture hints
                      if (widget.enableGestures && !isTablet)
                        _buildGestureHints(context, l10n),
                    ],
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Arabic text
                  if (widget.showArabic)
                    _buildArabicText(context),
                  
                  // Translation
                  if (widget.showTranslation && widget.verse.translations.isNotEmpty)
                    _buildTranslationText(context),
                  
                  // Mobile actions
                  if (_showActions || isTablet)
                    Column(
                      children: [
                        const SizedBox(height: 16),
                        MobileVerseActions(
                          verse: widget.verse,
                          isBookmarked: widget.isBookmarked,
                          onPlay: widget.onPlay,
                          onBookmarkToggle: widget.onBookmarkToggle,
                          onShare: widget.onShare,
                          onShowOptions: widget.onShowOptions,
                          showCompactView: !isTablet,
                        ),
                      ],
                    ),
                  
                  // Gesture feedback
                  if (_currentGesture.isNotEmpty)
                    _buildGestureFeedback(context, l10n),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildArabicText(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.verse.textUthmani,
          style: TextStyle(
            fontSize: 20,
            height: 1.8,
            color: ThemeHelper.getTextPrimaryColor(context),
            fontFamily: 'AmiriQuran',
          ),
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTranslationText(BuildContext context) {
    final translation = widget.verse.translations.first;
    final cleanText = translation.text
        .replaceAll(RegExp(r'<sup[^>]*>[\s\S]*?<\/sup>', dotAll: true), ' ')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    return Column(
      children: [
        Text(
          cleanText,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildGestureHints(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildGestureHint(
          context: context,
          icon: Icons.touch_app,
          hint: l10n.tapForActions,
        ),
        const SizedBox(width: 8),
        _buildGestureHint(
          context: context,
          icon: Icons.swipe,
          hint: l10n.swipeForQuickActions,
        ),
      ],
    );
  }

  Widget _buildGestureHint({
    required BuildContext context,
    required IconData icon,
    required String hint,
  }) {
    return Tooltip(
      message: hint,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(
          icon,
          size: 12,
          color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.6),
        ),
      ),
    );
  }

  Widget _buildGestureFeedback(BuildContext context, AppLocalizations l10n) {
    String feedbackText = '';
    IconData feedbackIcon = Icons.check;
    
    switch (_currentGesture) {
      case 'bookmark':
        feedbackText = widget.isBookmarked ? l10n.bookmarkRemoved : l10n.bookmarkAdded;
        feedbackIcon = widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border;
        break;
      case 'share':
        feedbackText = l10n.verseShared;
        feedbackIcon = Icons.share;
        break;
      case 'play':
        feedbackText = l10n.audioPlaying;
        feedbackIcon = Icons.play_arrow;
        break;
    }
    
    // Clear feedback after delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        setState(() {
          _currentGesture = '';
        });
      }
    });
    
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            feedbackIcon,
            size: 14,
            color: ThemeHelper.getPrimaryColor(context),
          ),
          const SizedBox(width: 6),
          Text(
            feedbackText,
            style: TextStyle(
              fontSize: 12,
              color: ThemeHelper.getPrimaryColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/dto/verse_dto.dart';

/// Mobile-enhanced verse actions with gesture support and improved UX
class MobileVerseActions extends ConsumerStatefulWidget {
  const MobileVerseActions({
    super.key,
    required this.verse,
    required this.isBookmarked,
    required this.onPlay,
    required this.onBookmarkToggle,
    required this.onShare,
    required this.onShowOptions,
    this.showCompactView = false,
  });

  final VerseDto verse;
  final bool isBookmarked;
  final VoidCallback onPlay;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onShare;
  final VoidCallback onShowOptions;
  final bool showCompactView;

  @override
  ConsumerState<MobileVerseActions> createState() => _MobileVerseActionsState();
}

class _MobileVerseActionsState extends ConsumerState<MobileVerseActions>
    with TickerProviderStateMixin {
  late AnimationController _quickActionsController;
  late AnimationController _pulseController;
  late Animation<double> _quickActionsAnimation;
  late Animation<double> _pulseAnimation;
  
  bool _showQuickActions = false;
  String? _lastActionFeedback;

  @override
  void initState() {
    super.initState();
    
    _quickActionsController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _quickActionsAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _quickActionsController,
      curve: Curves.easeOutCubic,
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _quickActionsController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleQuickActions() {
    setState(() {
      _showQuickActions = !_showQuickActions;
    });
    
    if (_showQuickActions) {
      _quickActionsController.forward();
      HapticFeedback.lightImpact();
    } else {
      _quickActionsController.reverse();
    }
  }

  void _handleAction(String action, VoidCallback callback) {
    setState(() {
      _lastActionFeedback = action;
    });
    
    // Pulse animation for feedback
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
    
    // Haptic feedback
    HapticFeedback.selectionClick();
    
    // Execute callback
    callback();
    
    // Hide quick actions after action
    if (_showQuickActions) {
      Future.delayed(const Duration(milliseconds: 200), () {
        _toggleQuickActions();
      });
    }
    
    // Clear feedback after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _lastActionFeedback = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = MediaQuery.of(context).size.width >= 768;
    
    if (widget.showCompactView) {
      return _buildCompactActions(context, l10n);
    }
    
    return _buildFullActions(context, l10n, isTablet);
  }

  Widget _buildCompactActions(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildActionButton(
          context: context,
          icon: Icons.play_arrow,
          onTap: () => _handleAction('play', widget.onPlay),
          tooltip: l10n.playAudio,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context: context,
          icon: widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
          onTap: () => _handleAction('bookmark', widget.onBookmarkToggle),
          tooltip: widget.isBookmarked ? l10n.removeBookmark : l10n.addBookmark,
          isActive: widget.isBookmarked,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          context: context,
          icon: Icons.more_vert,
          onTap: _toggleQuickActions,
          tooltip: l10n.moreActions,
        ),
      ],
    );
  }

  Widget _buildFullActions(BuildContext context, AppLocalizations l10n, bool isTablet) {
    return Column(
      children: [
        // Primary actions row
        Row(
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildActionButton(
                    context: context,
                    icon: Icons.play_arrow,
                    onTap: () => _handleAction('play', widget.onPlay),
                    tooltip: l10n.playAudio,
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    context: context,
                    icon: widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                    onTap: () => _handleAction('bookmark', widget.onBookmarkToggle),
                    tooltip: widget.isBookmarked ? l10n.removeBookmark : l10n.addBookmark,
                    isActive: widget.isBookmarked,
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    context: context,
                    icon: Icons.share,
                    onTap: () => _handleAction('share', widget.onShare),
                    tooltip: l10n.share,
                  ),
                  const SizedBox(width: 12),
                  _buildActionButton(
                    context: context,
                    icon: Icons.more_vert,
                    onTap: () => _handleAction('options', widget.onShowOptions),
                    tooltip: l10n.moreActions,
                  ),
                ],
              ),
            ),
            
            // Quick actions toggle
            if (!isTablet)
              GestureDetector(
                onTap: _toggleQuickActions,
                child: AnimatedBuilder(
                  animation: _quickActionsAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _quickActionsAnimation.value * 3.14159,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: _showQuickActions 
                              ? ThemeHelper.getPrimaryColor(context).withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          _showQuickActions ? Icons.close : Icons.touch_app,
                          size: 20,
                          color: ThemeHelper.getPrimaryColor(context),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
        
        // Quick actions panel
        AnimatedBuilder(
          animation: _quickActionsAnimation,
          builder: (context, child) {
            return SizeTransition(
              sizeFactor: _quickActionsAnimation,
              child: Opacity(
                opacity: _quickActionsAnimation.value,
                child: _buildQuickActionsPanel(context, l10n),
              ),
            );
          },
        ),
        
        // Action feedback
        if (_lastActionFeedback != null)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    _getActionFeedbackText(context, l10n, _lastActionFeedback!),
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeHelper.getPrimaryColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildQuickActionsPanel(BuildContext context, AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.flash_on,
                size: 16,
                color: ThemeHelper.getPrimaryColor(context),
              ),
              const SizedBox(width: 8),
              Text(
                l10n.quickActions,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Quick action buttons
          Row(
            children: [
              Expanded(
                child: _buildQuickActionTile(
                  context: context,
                  icon: Icons.content_copy,
                  label: l10n.copy,
                  onTap: () => _handleCopyAction(context, l10n),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickActionTile(
                  context: context,
                  icon: Icons.text_fields,
                  label: l10n.textSize,
                  onTap: () => _handleTextSizeAction(context, l10n),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickActionTile(
                  context: context,
                  icon: Icons.translate,
                  label: l10n.translate,
                  onTap: () => _handleTranslateAction(context, l10n),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
    required String tooltip,
    bool isActive = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isActive 
                ? ThemeHelper.getPrimaryColor(context).withOpacity(0.2)
                : ThemeHelper.getCardColor(context),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive 
                  ? ThemeHelper.getPrimaryColor(context).withOpacity(0.3)
                  : ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isActive 
                ? ThemeHelper.getPrimaryColor(context)
                : ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: ThemeHelper.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 18,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getActionFeedbackText(BuildContext context, AppLocalizations l10n, String action) {
    switch (action) {
      case 'play':
        return l10n.audioPlaying;
      case 'bookmark':
        return widget.isBookmarked ? l10n.bookmarkRemoved : l10n.bookmarkAdded;
      case 'share':
        return l10n.verseShared;
      case 'options':
        return l10n.moreOptionsOpened;
      default:
        return l10n.actionCompleted;
    }
  }

  void _handleCopyAction(BuildContext context, AppLocalizations l10n) {
    // Show copy options (Arabic, Translation, Full)
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildCopyOptionsSheet(context, l10n),
    );
  }

  void _handleTextSizeAction(BuildContext context, AppLocalizations l10n) {
    // Show text size adjustment
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.textSizeAdjustment),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleTranslateAction(BuildContext context, AppLocalizations l10n) {
    // Show translation options
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.translationOptions),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildCopyOptionsSheet(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: 16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.copyOptions,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.close, color: ThemeHelper.getTextPrimaryColor(context)),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Copy options
          ListTile(
            leading: Icon(Icons.abc, color: ThemeHelper.getPrimaryColor(context)),
            title: Text(l10n.copyArabicText),
            subtitle: Text(l10n.copyArabicSubtitle),
            onTap: () {
              _copyArabicText(context, l10n);
              Navigator.pop(context);
            },
          ),
          
          if (widget.verse.translations.isNotEmpty)
            ListTile(
              leading: Icon(Icons.translate, color: ThemeHelper.getPrimaryColor(context)),
              title: Text(l10n.copyTranslation),
              subtitle: Text(l10n.copyTranslationSubtitle),
              onTap: () {
                _copyTranslation(context, l10n);
                Navigator.pop(context);
              },
            ),
          
          ListTile(
            leading: Icon(Icons.content_copy, color: ThemeHelper.getPrimaryColor(context)),
            title: Text(l10n.copyFullVerse),
            subtitle: Text(l10n.copyFullVerseSubtitle),
            onTap: () {
              _copyFullVerse(context, l10n);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _copyArabicText(BuildContext context, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: widget.verse.textUthmani));
    _showCopySuccess(context, l10n.arabicTextCopied);
  }

  void _copyTranslation(BuildContext context, AppLocalizations l10n) {
    if (widget.verse.translations.isEmpty) return;
    final cleanText = widget.verse.translations.first.text
        .replaceAll(RegExp(r'<sup[^>]*>[\s\S]*?<\/sup>', dotAll: true), ' ')
        .replaceAll(RegExp(r'<[^>]+>'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    
    Clipboard.setData(ClipboardData(text: cleanText));
    _showCopySuccess(context, l10n.translationCopied);
  }

  void _copyFullVerse(BuildContext context, AppLocalizations l10n) {
    final arabic = widget.verse.textUthmani;
    final translation = widget.verse.translations.isNotEmpty 
        ? widget.verse.translations.first.text
            .replaceAll(RegExp(r'<sup[^>]*>[\s\S]*?<\/sup>', dotAll: true), ' ')
            .replaceAll(RegExp(r'<[^>]+>'), ' ')
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim()
        : '';
    
    final fullText = translation.isNotEmpty 
        ? '$arabic\n\n$translation\n\n[${widget.verse.verseKey}]'
        : '$arabic\n\n[${widget.verse.verseKey}]';
    
    Clipboard.setData(ClipboardData(text: fullText));
    _showCopySuccess(context, l10n.fullVerseCopied);
  }

  void _showCopySuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: ThemeHelper.getPrimaryColor(context),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

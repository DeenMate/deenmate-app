import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Mobile-optimized Quick Tools Panel for Quran reading interface
/// Provides fast access to navigation, settings, and reading controls
class QuickToolsPanel extends ConsumerStatefulWidget {
  const QuickToolsPanel({
    super.key,
    required this.onNavigationModeChange,
    required this.onJumpToVerse,
    required this.onFontSizeAdjust,
    required this.onThemeToggle,
    required this.onTranslationPicker,
    required this.onBookmarkToggle,
    required this.onShareVerse,
    required this.currentChapterId,
    required this.currentVerseKey,
    this.isBookmarked = false,
  });

  final Function(String mode) onNavigationModeChange;
  final VoidCallback onJumpToVerse;
  final Function(double delta) onFontSizeAdjust;
  final VoidCallback onThemeToggle;
  final VoidCallback onTranslationPicker;
  final VoidCallback onBookmarkToggle;
  final VoidCallback onShareVerse;
  final int currentChapterId;
  final String? currentVerseKey;
  final bool isBookmarked;

  @override
  ConsumerState<QuickToolsPanel> createState() => _QuickToolsPanelState();
}

class _QuickToolsPanelState extends ConsumerState<QuickToolsPanel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fabController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _fabRotationAnimation;
  
  bool _isExpanded = false;
  String _selectedNavigationMode = 'surah';

  @override
  void initState() {
    super.initState();
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeInOut,
    ));
    
    _fabRotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.125, // 45 degrees (1/8 of a full rotation)
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  void _togglePanel() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _slideController.forward();
      _fabController.forward();
      HapticFeedback.lightImpact();
    } else {
      _slideController.reverse();
      _fabController.reverse();
    }
  }

  void _handleToolAction(String action) {
    HapticFeedback.selectionClick();
    
    switch (action) {
      case 'navigation':
        widget.onNavigationModeChange(_selectedNavigationMode);
        break;
      case 'jump':
        widget.onJumpToVerse();
        break;
      case 'font_increase':
        widget.onFontSizeAdjust(2.0);
        break;
      case 'font_decrease':
        widget.onFontSizeAdjust(-2.0);
        break;
      case 'theme':
        widget.onThemeToggle();
        break;
      case 'translation':
        widget.onTranslationPicker();
        break;
      case 'bookmark':
        widget.onBookmarkToggle();
        break;
      case 'share':
        widget.onShareVerse();
        break;
    }
    
    // Auto-close panel after action (except for navigation mode changes)
    if (action != 'navigation') {
      _togglePanel();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = ResponsiveLayout.isTablet(context);
    
    return Stack(
      children: [
        // Backdrop overlay
        if (_isExpanded)
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value * 0.5,
                child: GestureDetector(
                  onTap: _togglePanel,
                  child: Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              );
            },
          ),
        
        // Quick Tools Panel
        Positioned(
          bottom: isTablet ? 24 : 16,
          right: isTablet ? 24 : 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Tools Panel
              SlideTransition(
                position: _slideAnimation,
                child: AnimatedBuilder(
                  animation: _fadeAnimation,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _fadeAnimation.value,
                      child: _buildToolsPanel(context, l10n),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Main FAB
              _buildMainFAB(context, l10n),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainFAB(BuildContext context, AppLocalizations l10n) {
    return AnimatedBuilder(
      animation: _fabRotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _fabRotationAnimation.value * 2 * 3.14159,
          child: FloatingActionButton(
            onPressed: _togglePanel,
            backgroundColor: ThemeHelper.getPrimaryColor(context),
            foregroundColor: Colors.white,
            elevation: 8,
            child: Icon(
              _isExpanded ? Icons.close : Icons.menu,
              size: 24,
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolsPanel(BuildContext context, AppLocalizations l10n) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 280,
        maxHeight: 400,
      ),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.tune,
                  color: ThemeHelper.getPrimaryColor(context),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.quickTools,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
              ],
            ),
          ),
          
          // Navigation Section
          _buildNavigationSection(context, l10n),
          
          // Divider
          Divider(
            height: 1,
            color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
          ),
          
          // Reading Controls Section
          _buildReadingControlsSection(context, l10n),
          
          // Divider
          Divider(
            height: 1,
            color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
          ),
          
          // Actions Section
          _buildActionsSection(context, l10n),
        ],
      ),
    );
  }

  Widget _buildNavigationSection(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.navigation,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 12),
          
          // Navigation Mode Selector
          Container(
            decoration: BoxDecoration(
              color: ThemeHelper.getBackgroundColor(context),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildNavModeButton(context, 'surah', l10n.surah, Icons.book),
                _buildNavModeButton(context, 'page', l10n.page, Icons.article),
                _buildNavModeButton(context, 'juz', l10n.juz, Icons.bookmark_border),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Jump to Verse
          _buildToolButton(
            context: context,
            icon: Icons.search,
            label: l10n.jumpToVerse,
            onTap: () => _handleToolAction('jump'),
          ),
        ],
      ),
    );
  }

  Widget _buildNavModeButton(BuildContext context, String mode, String label, IconData icon) {
    final isSelected = _selectedNavigationMode == mode;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedNavigationMode = mode;
          });
          _handleToolAction('navigation');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? ThemeHelper.getPrimaryColor(context).withOpacity(0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected 
                    ? ThemeHelper.getPrimaryColor(context)
                    : ThemeHelper.getTextSecondaryColor(context),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected 
                      ? ThemeHelper.getPrimaryColor(context)
                      : ThemeHelper.getTextSecondaryColor(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadingControlsSection(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.readingControls,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 12),
          
          // Font Size Controls
          Row(
            children: [
              Expanded(
                child: _buildToolButton(
                  context: context,
                  icon: Icons.text_decrease,
                  label: l10n.fontSizeDecrease,
                  onTap: () => _handleToolAction('font_decrease'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildToolButton(
                  context: context,
                  icon: Icons.text_increase,
                  label: l10n.fontSizeIncrease,
                  onTap: () => _handleToolAction('font_increase'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Theme and Translation
          Row(
            children: [
              Expanded(
                child: _buildToolButton(
                  context: context,
                  icon: Icons.brightness_6,
                  label: l10n.theme,
                  onTap: () => _handleToolAction('theme'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildToolButton(
                  context: context,
                  icon: Icons.translate,
                  label: l10n.translation,
                  onTap: () => _handleToolAction('translation'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection(BuildContext context, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.actions,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              Expanded(
                child: _buildToolButton(
                  context: context,
                  icon: widget.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                  label: widget.isBookmarked ? l10n.removeBookmark : l10n.addBookmark,
                  onTap: () => _handleToolAction('bookmark'),
                  color: widget.isBookmarked ? Colors.orange : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildToolButton(
                  context: context,
                  icon: Icons.share,
                  label: l10n.share,
                  onTap: () => _handleToolAction('share'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: ThemeHelper.getBackgroundColor(context),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: color ?? ThemeHelper.getTextPrimaryColor(context),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

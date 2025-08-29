import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../state/providers.dart';
import 'mobile_font_controls_button.dart';

/// Mobile-optimized reading mode overlay with enhanced touch controls
/// Builds upon the existing ReadingModeOverlay with mobile-specific improvements
class MobileReadingModeOverlay extends ConsumerStatefulWidget {
  const MobileReadingModeOverlay({
    super.key,
    required this.child,
    required this.onExitReadingMode,
    this.chapterId,
  });

  final Widget child;
  final VoidCallback onExitReadingMode;
  final int? chapterId;

  @override
  ConsumerState<MobileReadingModeOverlay> createState() => _MobileReadingModeOverlayState();
}

class _MobileReadingModeOverlayState extends ConsumerState<MobileReadingModeOverlay>
    with TickerProviderStateMixin {
  late AnimationController _overlayController;
  late AnimationController _fabController;
  late Animation<double> _overlayAnimation;
  late Animation<double> _fabAnimation;
  late Animation<double> _fabScaleAnimation;
  
  bool _showControls = false;
  bool _showFab = true;
  
  // Mobile-specific state
  double _brightness = 0.5;
  bool _autoHideEnabled = true;
  Timer? _autoHideTimer;

  @override
  void initState() {
    super.initState();
    
    _overlayController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _overlayAnimation = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeInOut,
    );
    
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    );
    
    _fabScaleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_fabController);

    // Show FAB initially, hide controls
    _fabController.forward();
    
    // Auto-show controls briefly, then show FAB
    _showControlsBriefly();
  }

  @override
  void dispose() {
    _overlayController.dispose();
    _fabController.dispose();
    _autoHideTimer?.cancel();
    super.dispose();
  }

  void _showControlsBriefly() {
    _showControlsTemporarily();
    
    // After 3 seconds, hide controls and show FAB
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _hideControlsShowFab();
      }
    });
  }

  void _showControlsTemporarily() {
    if (!mounted) return;
    
    _autoHideTimer?.cancel();
    
    setState(() {
      _showControls = true;
      _showFab = false;
    });
    
    _overlayController.forward();
    _fabController.reverse();
    
    if (_autoHideEnabled) {
      _autoHideTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          _hideControlsShowFab();
        }
      });
    }
  }

  void _hideControlsShowFab() {
    if (!mounted) return;
    
    _autoHideTimer?.cancel();
    
    _overlayController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _showControls = false;
          _showFab = true;
        });
        _fabController.forward();
      }
    });
  }

  void _toggleControls() {
    HapticFeedback.lightImpact();
    
    if (_showControls) {
      _hideControlsShowFab();
    } else {
      _showControlsTemporarily();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final isLandscape = screenSize.width > screenSize.height;
    final safeAreaPadding = MediaQuery.of(context).padding;
    
    return Scaffold(
      backgroundColor: _getReadingModeBackground(context),
      body: Stack(
        children: [
          // Main content with gesture detector
          GestureDetector(
            onTap: _toggleControls,
            // Add swipe gestures for mobile navigation
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 300) {
                // Swipe right - previous page/chapter
                _navigatePrevious();
              } else if (details.primaryVelocity! < -300) {
                // Swipe left - next page/chapter  
                _navigateNext();
              }
            },
            child: ColoredBox(
              color: Colors.transparent,
              child: Padding(
                // Responsive padding based on device type and orientation
                padding: EdgeInsets.only(
                  left: isTablet 
                      ? (isLandscape ? 40.0 : 24.0) 
                      : (isLandscape ? 20.0 : 16.0),
                  right: isTablet 
                      ? (isLandscape ? 40.0 : 24.0) 
                      : (isLandscape ? 20.0 : 16.0),
                  top: safeAreaPadding.top,
                  bottom: safeAreaPadding.bottom,
                ),
                child: widget.child,
              ),
            ),
          ),
          
          // Mobile-optimized top overlay
          if (_showControls)
            _buildTopOverlay(),
          
          // Mobile-optimized bottom overlay  
          if (_showControls)
            _buildBottomOverlay(),
            
          // Floating Action Button for quick access
          if (_showFab)
            _buildFloatingControls(),
        ],
      ),
    );
  }

  Widget _buildTopOverlay() {
    return AnimatedBuilder(
      animation: _overlayAnimation,
      builder: (context, child) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, -100 * (1 - _overlayAnimation.value)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    children: [
                      // Top control bar
                      Row(
                        children: [
                          // Exit button with larger touch target
                          _buildTouchOptimizedButton(
                            Icons.close,
                            onPressed: widget.onExitReadingMode,
                            tooltip: AppLocalizations.of(context)!.exitReadingMode,
                          ),
                          
                          const Spacer(),
                          
                          // Chapter info
                          _buildChapterInfo(),
                          
                          const Spacer(),
                          
                          // Settings button
                          _buildTouchOptimizedButton(
                            Icons.tune,
                            onPressed: _showMobileSettings,
                            tooltip: AppLocalizations.of(context)!.quickSettings,
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Progress bar (mobile-optimized)
                      _buildMobileProgressBar(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomOverlay() {
    return AnimatedBuilder(
      animation: _overlayAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Transform.translate(
            offset: Offset(0, 120 * (1 - _overlayAnimation.value)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.9),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Quick action buttons (mobile-optimized grid)
                      _buildMobileActionGrid(),
                      
                      const SizedBox(height: 16),
                      
                      // Navigation controls
                      _buildMobileNavigationControls(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingControls() {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final isLandscape = screenSize.width > screenSize.height;
    final safeAreaPadding = MediaQuery.of(context).padding;
    
    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Positioned(
          bottom: isTablet 
              ? (isLandscape ? 32.0 : 24.0) 
              : (isLandscape ? 20.0 : 16.0) + safeAreaPadding.bottom,
          right: isTablet 
              ? (isLandscape ? 32.0 : 24.0) 
              : (isLandscape ? 20.0 : 16.0),
          child: Transform.scale(
            scale: _fabScaleAnimation.value,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Font controls button
                MobileFontControlsButton(
                  isVisible: _showFab,
                ),
                
                SizedBox(height: isTablet ? 12 : 8),
                
                // Quick settings mini-fab
                FloatingActionButton(
                  mini: !isTablet, // Use regular size on tablet
                  backgroundColor: Colors.black.withOpacity(0.7),
                  foregroundColor: Colors.white,
                  onPressed: _showMobileSettings,
                  heroTag: "settings",
                  child: Icon(
                    Icons.tune, 
                    size: isTablet ? 24 : 20,
                  ),
                ),
                
                SizedBox(height: isTablet ? 12 : 8),
                
                // Main control fab
                FloatingActionButton(
                  mini: false, // Always regular size for main control
                  backgroundColor: Colors.black.withOpacity(0.8),
                  foregroundColor: Colors.white,
                  onPressed: _toggleControls,
                  heroTag: "main_controls",
                  child: Icon(
                    Icons.touch_app,
                    size: isTablet ? 28 : 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTouchOptimizedButton(
    IconData icon, {
    required VoidCallback onPressed,
    String? tooltip,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          onPressed();
        },
        borderRadius: BorderRadius.circular(24),
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildChapterInfo() {
    final chaptersAsync = ref.watch(surahListProvider);
    
    return chaptersAsync.when(
      data: (chapters) {
        if (widget.chapterId == null) return const SizedBox.shrink();
        
        final chapter = chapters.firstWhere(
          (c) => c.id == widget.chapterId,
          orElse: () => chapters.first,
        );
        
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.chapterId}. ${chapter.nameSimple}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              chapter.nameArabic,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                fontFamily: 'Uthmani',
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  Widget _buildMobileProgressBar() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Reading Progress',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              '35%', // This would be connected to actual progress
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 4,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(2),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: 0.35, // Example progress
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileActionGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMobileActionButton(
          Icons.brightness_6,
          AppLocalizations.of(context)!.readingModeThemeTitle,
          _showThemeOptions,
        ),
        _buildMobileActionButton(
          Icons.text_fields,
          AppLocalizations.of(context)!.readingModeFontSettings,
          _showFontOptions,
        ),
        _buildMobileActionButton(
          Icons.translate,
          AppLocalizations.of(context)!.readingModeTranslationSettings,
          _showTranslationOptions,
        ),
        _buildMobileActionButton(
          Icons.bookmark_outline,
          'Bookmark',
          _addBookmark,
        ),
      ],
    );
  }

  Widget _buildMobileActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 72,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNavigationControls() {
    return Row(
      children: [
        // Previous button
        Expanded(
          child: _buildNavigationButton(
            Icons.arrow_back_ios,
            'Previous',
            _navigatePrevious,
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Auto-hide toggle
        InkWell(
          onTap: () {
            setState(() {
              _autoHideEnabled = !_autoHideEnabled;
            });
            HapticFeedback.lightImpact();
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _autoHideEnabled 
                ? Colors.white.withOpacity(0.2)
                : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              _autoHideEnabled ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
        
        const SizedBox(width: 16),
        
        // Next button
        Expanded(
          child: _buildNavigationButton(
            Icons.arrow_forward_ios,
            'Next',
            _navigateNext,
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getReadingModeBackground(BuildContext context) {
    final prefs = ref.watch(prefsProvider);
    
    // Enhanced mobile-specific background themes
    switch (prefs.arabicFontFamily) {
      case 'sepia':
        return const Color(0xFFF5F1E8); // Warm sepia
      case 'dark':
        return const Color(0xFF1A1A1A); // True black for OLED
      case 'green':
        return const Color(0xFFE8F5E8); // Soft green
      case 'night':
        return const Color(0xFF0D1117); // GitHub dark
      default:
        return ThemeHelper.getBackgroundColor(context);
    }
  }

  void _showMobileSettings() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _MobileReadingSettingsSheet(
        brightness: _brightness,
        onBrightnessChanged: (value) {
          setState(() {
            _brightness = value;
          });
        },
      ),
    );
  }

  void _showThemeOptions() {
    // Enhanced mobile theme selector
    _showMobileBottomSheet(
      title: AppLocalizations.of(context)!.readingModeThemeTitle,
      children: [
        _buildThemeOption(Icons.light_mode, AppLocalizations.of(context)!.readingModeThemeLight, 'light'),
        _buildThemeOption(Icons.dark_mode, AppLocalizations.of(context)!.readingModeThemeDark, 'dark'),
        _buildThemeOption(Icons.auto_stories, AppLocalizations.of(context)!.readingModeThemeSepia, 'sepia'),
        _buildThemeOption(Icons.eco, 'Green Theme', 'green'),
        _buildThemeOption(Icons.bedtime, 'Night Mode', 'night'),
      ],
    );
  }

  void _showFontOptions() {
    _showMobileBottomSheet(
      title: AppLocalizations.of(context)!.readingModeFontSettings,
      children: [
        // Font size controls with immediate preview
        _buildFontSizeControl(),
        const SizedBox(height: 16),
        _buildLineHeightControl(),
      ],
    );
  }

  void _showTranslationOptions() {
    _showMobileBottomSheet(
      title: AppLocalizations.of(context)!.readingModeTranslationSettings,
      children: [
        Text(
          'Translation selection is available in the main reading screen. Use the translation picker to choose your preferred translations.',
          style: TextStyle(
            color: ThemeHelper.getTextSecondaryColor(context),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _hideControlsShowFab();
            // This would open translation picker
          },
          child: const Text('Open Translation Picker'),
        ),
      ],
    );
  }

  void _showMobileBottomSheet({
    required String title,
    required List<Widget> children,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ThemeHelper.getSurfaceColor(context),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThemeHelper.getDividerColor(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: children,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(IconData icon, String title, String themeKey) {
    return ListTile(
      leading: Icon(icon, color: ThemeHelper.getPrimaryColor(context)),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        // Apply theme change
        HapticFeedback.lightImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title applied')),
        );
      },
    );
  }

  Widget _buildFontSizeControl() {
    final prefs = ref.watch(prefsProvider);
    final notifier = ref.read(prefsProvider.notifier);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.readingModeFontArabicSize,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Text('${prefs.arabicFontSize.toInt()}pt'),
            Expanded(
              child: Slider(
                value: prefs.arabicFontSize,
                min: 16,
                max: 40,
                divisions: 12,
                onChanged: (value) => notifier.updateArabicFontSize(value),
                activeColor: ThemeHelper.getPrimaryColor(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineHeightControl() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Line Height',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('1.2x'),
            Expanded(
              child: Slider(
                value: 1.5,
                min: 1.0,
                max: 2.0,
                divisions: 10,
                onChanged: (value) {
                  // Implement line height change
                },
                activeColor: ThemeHelper.getPrimaryColor(context),
              ),
            ),
            const Text('2.0x'),
          ],
        ),
      ],
    );
  }

  void _addBookmark() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.readingModeBookmarkAdded)),
    );
  }

  void _navigatePrevious() {
    HapticFeedback.lightImpact();
    // Implement previous navigation
    print('Navigate to previous');
  }

  void _navigateNext() {
    HapticFeedback.lightImpact();
    // Implement next navigation  
    print('Navigate to next');
  }
}

/// Mobile-optimized reading settings sheet
class _MobileReadingSettingsSheet extends ConsumerWidget {
  const _MobileReadingSettingsSheet({
    required this.brightness,
    required this.onBrightnessChanged,
  });

  final double brightness;
  final ValueChanged<double> onBrightnessChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: ThemeHelper.getDividerColor(context),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Title
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Reading Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
          ),
          
          // Brightness control
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Screen Brightness',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.brightness_low),
                    Expanded(
                      child: Slider(
                        value: brightness,
                        onChanged: onBrightnessChanged,
                        activeColor: ThemeHelper.getPrimaryColor(context),
                      ),
                    ),
                    const Icon(Icons.brightness_high),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

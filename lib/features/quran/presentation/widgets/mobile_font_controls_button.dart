import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/widgets/responsive_layout.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../state/providers.dart';
import 'mobile_font_controls.dart';

/// Floating font controls button for mobile interface
class MobileFontControlsButton extends ConsumerStatefulWidget {
  const MobileFontControlsButton({
    super.key,
    this.isVisible = true,
    this.onFontControlsOpen,
    this.onFontControlsClose,
  });

  final bool isVisible;
  final VoidCallback? onFontControlsOpen;
  final VoidCallback? onFontControlsClose;

  @override
  ConsumerState<MobileFontControlsButton> createState() => _MobileFontControlsButtonState();
}

class _MobileFontControlsButtonState extends ConsumerState<MobileFontControlsButton>
    with TickerProviderStateMixin {
  late AnimationController _visibilityController;
  late AnimationController _bounceController;
  late Animation<double> _visibilityAnimation;
  late Animation<double> _bounceAnimation;
  
  bool _isControlsOpen = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    
    _visibilityController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _visibilityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _visibilityController,
      curve: Curves.easeInOut,
    ));
    
    _bounceAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.elasticOut,
    ));
    
    if (widget.isVisible) {
      _visibilityController.forward();
    }
  }

  @override
  void didUpdateWidget(MobileFontControlsButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _visibilityController.forward();
      } else {
        _visibilityController.reverse();
        _closeFontControls();
      }
    }
  }

  @override
  void dispose() {
    _visibilityController.dispose();
    _bounceController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  void _toggleFontControls() {
    HapticFeedback.lightImpact();
    
    if (_isControlsOpen) {
      _closeFontControls();
    } else {
      _openFontControls();
    }
  }

  void _openFontControls() {
    if (_isControlsOpen) return;
    
    setState(() {
      _isControlsOpen = true;
    });
    
    _bounceController.forward().then((_) {
      _bounceController.reverse();
    });
    
    widget.onFontControlsOpen?.call();
    
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeFontControls() {
    if (!_isControlsOpen) return;
    
    setState(() {
      _isControlsOpen = false;
    });
    
    widget.onFontControlsClose?.call();
    
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Background overlay
          GestureDetector(
            onTap: _closeFontControls,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          
          // Font controls positioned at bottom
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _visibilityController,
                curve: Curves.easeOutCubic,
              )),
              child: Material(
                color: Colors.transparent,
                child: MobileFontControls(
                  isCompact: true,
                  showPreview: false,
                  onDismiss: _closeFontControls,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isTablet = ResponsiveLayout.isTablet(context);
    
    return AnimatedBuilder(
      animation: _visibilityAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _visibilityAnimation.value,
          child: Opacity(
            opacity: _visibilityAnimation.value,
            child: AnimatedBuilder(
              animation: _bounceAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _bounceAnimation.value,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: isTablet ? 24 : 16,
                      right: isTablet ? 24 : 16,
                    ),
                    child: FloatingActionButton(
                      onPressed: _toggleFontControls,
                      backgroundColor: _isControlsOpen 
                          ? ThemeHelper.getPrimaryColor(context).withOpacity(0.9)
                          : ThemeHelper.getPrimaryColor(context),
                      foregroundColor: Colors.white,
                      elevation: _isControlsOpen ? 8 : 4,
                      heroTag: "fontControlsButton",
                      tooltip: l10n.fontControls,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _isControlsOpen ? Icons.close : Icons.format_size,
                          key: ValueKey(_isControlsOpen),
                          size: isTablet ? 28 : 24,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// Font size adjustment panel for quick access
class QuickFontAdjustmentPanel extends ConsumerStatefulWidget {
  const QuickFontAdjustmentPanel({
    super.key,
    this.isVisible = false,
    this.onClose,
  });

  final bool isVisible;
  final VoidCallback? onClose;

  @override
  ConsumerState<QuickFontAdjustmentPanel> createState() => _QuickFontAdjustmentPanelState();
}

class _QuickFontAdjustmentPanelState extends ConsumerState<QuickFontAdjustmentPanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.isVisible) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(QuickFontAdjustmentPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _adjustFontSize(String type, double delta) {
    HapticFeedback.lightImpact();
    
    final prefs = ref.read(prefsProvider);
    final prefsNotifier = ref.read(prefsProvider.notifier);
    
    switch (type) {
      case 'arabic':
        final newSize = (prefs.arabicFontSize + delta).clamp(12.0, 48.0);
        prefsNotifier.updateArabicFontSize(newSize);
        break;
      case 'translation':
        final newSize = (prefs.translationFontSize + delta).clamp(10.0, 28.0);
        prefsNotifier.updateTranslationFontSize(newSize);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(prefsProvider);
    
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 60 * _slideAnimation.value),
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Arabic font controls
                  Expanded(
                    child: _buildQuickFontControl(
                      context: context,
                      label: l10n.arabicText,
                      currentSize: prefs.arabicFontSize,
                      onIncrease: () => _adjustFontSize('arabic', 2),
                      onDecrease: () => _adjustFontSize('arabic', -2),
                    ),
                  ),
                  
                  Container(
                    width: 1,
                    height: 40,
                    color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  
                  // Translation font controls
                  Expanded(
                    child: _buildQuickFontControl(
                      context: context,
                      label: l10n.translation,
                      currentSize: prefs.translationFontSize,
                      onIncrease: () => _adjustFontSize('translation', 1),
                      onDecrease: () => _adjustFontSize('translation', -1),
                    ),
                  ),
                  
                  // Close button
                  IconButton(
                    onPressed: widget.onClose,
                    icon: Icon(
                      Icons.close,
                      size: 20,
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuickFontControl({
    required BuildContext context,
    required String label,
    required double currentSize,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${currentSize.toInt()}px',
          style: TextStyle(
            fontSize: 10,
            color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildQuickAdjustButton(
              context: context,
              icon: Icons.remove,
              onTap: onDecrease,
            ),
            _buildQuickAdjustButton(
              context: context,
              icon: Icons.add,
              onTap: onIncrease,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickAdjustButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: ThemeHelper.getPrimaryColor(context).withOpacity(0.2),
          ),
        ),
        child: Icon(
          icon,
          size: 16,
          color: ThemeHelper.getPrimaryColor(context),
        ),
      ),
    );
  }
}

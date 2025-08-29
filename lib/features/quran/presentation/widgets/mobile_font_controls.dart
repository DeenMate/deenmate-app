import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../state/providers.dart';

/// Mobile-optimized font controls with intuitive gesture-based adjustments
class MobileFontControls extends ConsumerStatefulWidget {
  const MobileFontControls({
    super.key,
    this.isCompact = false,
    this.showPreview = true,
    this.onDismiss,
  });

  final bool isCompact;
  final bool showPreview;
  final VoidCallback? onDismiss;

  @override
  ConsumerState<MobileFontControls> createState() => _MobileFontControlsState();
}

class _MobileFontControlsState extends ConsumerState<MobileFontControls>
    with TickerProviderStateMixin {
  late AnimationController _previewController;
  late AnimationController _adjustmentController;
  late Animation<double> _previewAnimation;
  late Animation<double> _adjustmentAnimation;
  
  String _currentAdjustment = '';
  bool _isAdjusting = false;

  @override
  void initState() {
    super.initState();
    
    _previewController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _adjustmentController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _previewAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _previewController,
      curve: Curves.easeInOut,
    ));
    
    _adjustmentAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _adjustmentController,
      curve: Curves.easeInOut,
    ));
    
    if (widget.showPreview) {
      _previewController.forward();
    }
  }

  @override
  void dispose() {
    _previewController.dispose();
    _adjustmentController.dispose();
    super.dispose();
  }

  void _adjustFontSize(String type, double delta) {
    setState(() {
      _currentAdjustment = type;
      _isAdjusting = true;
    });
    
    _adjustmentController.forward().then((_) {
      _adjustmentController.reverse();
    });
    
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
    
    // Clear adjustment feedback after delay
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _currentAdjustment = '';
          _isAdjusting = false;
        });
      }
    });
  }

  void _resetFontSizes() {
    HapticFeedback.mediumImpact();
    ref.read(prefsProvider.notifier).resetFontSettings();
    
    setState(() {
      _currentAdjustment = 'reset';
      _isAdjusting = true;
    });
    
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _currentAdjustment = '';
          _isAdjusting = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(prefsProvider);
    final isTablet = MediaQuery.of(context).size.width >= 768;
    
    if (widget.isCompact) {
      return _buildCompactControls(context, l10n, prefs);
    }
    
    return _buildFullControls(context, l10n, prefs, isTablet);
  }

  Widget _buildCompactControls(
    BuildContext context,
    AppLocalizations l10n,
    QuranPrefs prefs,
  ) {
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
                  l10n.fontControls,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
              ),
              if (widget.onDismiss != null)
                IconButton(
                  icon: Icon(Icons.close, color: ThemeHelper.getTextPrimaryColor(context)),
                  onPressed: widget.onDismiss,
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Quick adjustment buttons
          Row(
            children: [
              Expanded(
                child: _buildQuickAdjustButton(
                  context: context,
                  label: l10n.arabicText,
                  currentSize: prefs.arabicFontSize,
                  onIncrease: () => _adjustFontSize('arabic', 2),
                  onDecrease: () => _adjustFontSize('arabic', -2),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickAdjustButton(
                  context: context,
                  label: l10n.translation,
                  currentSize: prefs.translationFontSize,
                  onIncrease: () => _adjustFontSize('translation', 1),
                  onDecrease: () => _adjustFontSize('translation', -1),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Reset button
          TextButton.icon(
            onPressed: _resetFontSizes,
            icon: Icon(Icons.refresh, size: 18),
            label: Text(l10n.resetFontSizes),
            style: TextButton.styleFrom(
              foregroundColor: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          
          // Adjustment feedback
          if (_isAdjusting)
            _buildAdjustmentFeedback(context, l10n),
        ],
      ),
    );
  }

  Widget _buildFullControls(
    BuildContext context,
    AppLocalizations l10n,
    QuranPrefs prefs,
    bool isTablet,
  ) {
    return Container(
      margin: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
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
                  Icons.format_size,
                  color: ThemeHelper.getPrimaryColor(context),
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n.fontControls,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ThemeHelper.getTextPrimaryColor(context),
                    ),
                  ),
                ),
                if (widget.onDismiss != null)
                  IconButton(
                    icon: Icon(Icons.close, color: ThemeHelper.getTextPrimaryColor(context)),
                    onPressed: widget.onDismiss,
                  ),
              ],
            ),
          ),
          
          // Font controls
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Arabic font control
                _buildFontSizeControl(
                  context: context,
                  label: l10n.arabicText,
                  currentSize: prefs.arabicFontSize,
                  minSize: 12.0,
                  maxSize: 48.0,
                  onChanged: (value) => _adjustFontSize('arabic', value - prefs.arabicFontSize),
                  onIncrease: () => _adjustFontSize('arabic', 2),
                  onDecrease: () => _adjustFontSize('arabic', -2),
                ),
                
                const SizedBox(height: 24),
                
                // Translation font control
                _buildFontSizeControl(
                  context: context,
                  label: l10n.translation,
                  currentSize: prefs.translationFontSize,
                  minSize: 10.0,
                  maxSize: 28.0,
                  onChanged: (value) => _adjustFontSize('translation', value - prefs.translationFontSize),
                  onIncrease: () => _adjustFontSize('translation', 1),
                  onDecrease: () => _adjustFontSize('translation', -1),
                ),
                
                const SizedBox(height: 24),
                
                // Reset button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _resetFontSizes,
                    icon: Icon(Icons.refresh),
                    label: Text(l10n.resetFontSizes),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(
                        color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
                
                // Preview section
                if (widget.showPreview)
                  AnimatedBuilder(
                    animation: _previewAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _previewAnimation.value,
                        child: _buildPreviewSection(context, l10n, prefs),
                      );
                    },
                  ),
                
                // Adjustment feedback
                if (_isAdjusting)
                  _buildAdjustmentFeedback(context, l10n),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAdjustButton({
    required BuildContext context,
    required String label,
    required double currentSize,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return AnimatedBuilder(
      animation: _adjustmentAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _currentAdjustment == label.toLowerCase() 
              ? _adjustmentAnimation.value 
              : 1.0,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeHelper.getBackgroundColor(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
              ),
            ),
            child: Column(
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${currentSize.toInt()}px',
                  style: TextStyle(
                    fontSize: 12,
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAdjustButton(
                      context: context,
                      icon: Icons.remove,
                      onTap: onDecrease,
                    ),
                    _buildAdjustButton(
                      context: context,
                      icon: Icons.add,
                      onTap: onIncrease,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFontSizeControl({
    required BuildContext context,
    required String label,
    required double currentSize,
    required double minSize,
    required double maxSize,
    required ValueChanged<double> onChanged,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
            ),
            Text(
              '${currentSize.toInt()}px',
              style: TextStyle(
                fontSize: 14,
                color: ThemeHelper.getTextSecondaryColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        Row(
          children: [
            _buildAdjustButton(
              context: context,
              icon: Icons.remove,
              onTap: onDecrease,
            ),
            
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: ThemeHelper.getPrimaryColor(context),
                    inactiveTrackColor: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
                    thumbColor: ThemeHelper.getPrimaryColor(context),
                    overlayColor: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                    trackHeight: 4.0,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                  ),
                  child: Slider(
                    value: currentSize,
                    min: minSize,
                    max: maxSize,
                    divisions: ((maxSize - minSize) / 2).round(),
                    onChanged: (value) {
                      HapticFeedback.selectionClick();
                      onChanged(value);
                    },
                  ),
                ),
              ),
            ),
            
            _buildAdjustButton(
              context: context,
              icon: Icons.add,
              onTap: onIncrease,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAdjustButton({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: ThemeHelper.getPrimaryColor(context).withOpacity(0.2),
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: ThemeHelper.getPrimaryColor(context),
        ),
      ),
    );
  }

  Widget _buildPreviewSection(
    BuildContext context,
    AppLocalizations l10n,
    QuranPrefs prefs,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelper.getBackgroundColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.preview,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Arabic preview
          Text(
            'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
            style: TextStyle(
              fontSize: prefs.arabicFontSize,
              height: prefs.arabicLineHeight,
              color: ThemeHelper.getTextPrimaryColor(context),
              fontFamily: 'UthmanicHafs',
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          
          const SizedBox(height: 8),
          
          // Translation preview
          Text(
            'In the name of Allah, the Beneficent, the Merciful.',
            style: TextStyle(
              fontSize: prefs.translationFontSize,
              height: prefs.translationLineHeight,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdjustmentFeedback(BuildContext context, AppLocalizations l10n) {
    String feedbackText = '';
    
    switch (_currentAdjustment) {
      case 'arabic':
        feedbackText = l10n.arabicFontAdjusted;
        break;
      case 'translation':
        feedbackText = l10n.translationFontAdjusted;
        break;
      case 'reset':
        feedbackText = l10n.fontSizesReset;
        break;
    }
    
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: 16,
            color: ThemeHelper.getPrimaryColor(context),
          ),
          const SizedBox(width: 8),
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

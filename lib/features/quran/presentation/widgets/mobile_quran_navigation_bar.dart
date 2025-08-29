import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Mobile-optimized horizontal navigation bar for Quran reading modes
/// Replaces static chips with functional TabBar for QURAN-102 enhancement
class MobileQuranNavigationBar extends ConsumerStatefulWidget {
  const MobileQuranNavigationBar({
    required this.currentChapterId,
    super.key,
    this.targetVerseKey,
    this.onNavigationChanged,
    this.suggestedMode,
  });

  final int currentChapterId;
  final String? targetVerseKey;
  final Function(QuranNavigationMode mode, int target)? onNavigationChanged;
  final QuranNavigationMode? suggestedMode;

  @override
  ConsumerState<MobileQuranNavigationBar> createState() =>
      _MobileQuranNavigationBarState();
}

class _MobileQuranNavigationBarState
    extends ConsumerState<MobileQuranNavigationBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  QuranNavigationMode _currentMode = QuranNavigationMode.surah;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this)
      ..addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentMode = QuranNavigationMode.values[_tabController.index];
      });
      
      // Notify parent widget of navigation change
      widget.onNavigationChanged?.call(_currentMode, widget.currentChapterId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: ThemeHelper.getSurfaceColor(context),
        border: Border(
          bottom: BorderSide(
            color: ThemeHelper.getDividerColor(context),
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: ThemeHelper.getPrimaryColor(context),
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: ThemeHelper.getPrimaryColor(context),
        unselectedLabelColor: ThemeHelper.getTextSecondaryColor(context),
        labelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        tabs: [
          _buildNavigationTab(
            localizations.quranSura,
            Icons.menu_book_outlined,
            QuranNavigationMode.surah,
          ),
          _buildNavigationTab(
            localizations.quranPage,
            Icons.auto_stories_outlined,
            QuranNavigationMode.page,
          ),
          _buildNavigationTab(
            localizations.quranJuz,
            Icons.bookmark_outline,
            QuranNavigationMode.juz,
          ),
          _buildNavigationTab(
            localizations.quranHizb,
            Icons.segment_outlined,
            QuranNavigationMode.hizb,
          ),
          _buildNavigationTab(
            localizations.quranRuku,
            Icons.format_list_numbered_outlined,
            QuranNavigationMode.ruku,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTab(String label, IconData icon, QuranNavigationMode mode) {
    final isSelected = _currentMode == mode;
    final isSuggested = widget.suggestedMode == mode && !isSelected;
    
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1)
              : isSuggested
                  ? ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.05)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(
                  color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.3),
                )
              : isSuggested
                  ? Border.all(
                      color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.2),
                      style: BorderStyle.solid,
                    )
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? ThemeHelper.getPrimaryColor(context)
                  : isSuggested
                      ? ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.7)
                      : ThemeHelper.getTextSecondaryColor(context),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected 
                    ? FontWeight.w600 
                    : isSuggested 
                        ? FontWeight.w500 
                        : FontWeight.w400,
                color: isSelected
                    ? ThemeHelper.getPrimaryColor(context)
                    : isSuggested
                        ? ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.7)
                        : ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            // Show suggestion indicator
            if (isSuggested) ...[
              const SizedBox(width: 4),
              Container(
                width: 4,
                height: 4,
                decoration: BoxDecoration(
                  color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.6),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Enhanced navigation state management for different Quran reading modes
enum QuranNavigationMode {
  surah,
  page,
  juz,
  hizb,
  ruku,
}

/// Extension to provide navigation mode properties
extension QuranNavigationModeExtension on QuranNavigationMode {
  String getDisplayName(AppLocalizations localizations) {
    switch (this) {
      case QuranNavigationMode.surah:
        return localizations.quranSura;
      case QuranNavigationMode.page:
        return localizations.quranPage;
      case QuranNavigationMode.juz:
        return localizations.quranJuz;
      case QuranNavigationMode.hizb:
        return localizations.quranHizb;
      case QuranNavigationMode.ruku:
        return localizations.quranRuku;
    }
  }

  IconData get icon {
    switch (this) {
      case QuranNavigationMode.surah:
        return Icons.menu_book_outlined;
      case QuranNavigationMode.page:
        return Icons.auto_stories_outlined;
      case QuranNavigationMode.juz:
        return Icons.bookmark_outline;
      case QuranNavigationMode.hizb:
        return Icons.segment_outlined;
      case QuranNavigationMode.ruku:
        return Icons.format_list_numbered_outlined;
    }
  }

  String get routePath {
    switch (this) {
      case QuranNavigationMode.surah:
        return '/quran/surah';
      case QuranNavigationMode.page:
        return '/quran/page';
      case QuranNavigationMode.juz:
        return '/quran/juz';
      case QuranNavigationMode.hizb:
        return '/quran/hizb';
      case QuranNavigationMode.ruku:
        return '/quran/ruku';
    }
  }
}

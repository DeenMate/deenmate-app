import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Breadcrumb navigation component showing current reading position
/// Provides quick location awareness and navigation to related sections
class BreadcrumbNavigation extends ConsumerWidget {
  final int currentSurah;
  final int currentAyah;
  final String readingMode;
  final VoidCallback? onSurahTap;
  final VoidCallback? onLocationTap;

  const BreadcrumbNavigation({
    super.key,
    required this.currentSurah,
    required this.currentAyah,
    required this.readingMode,
    this.onSurahTap,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        elevation: 2,
        color: ThemeHelper.getCardColor(context).withValues(alpha: 0.95),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              // Home icon
              Icon(
                Icons.home_outlined,
                size: 16,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
              const SizedBox(width: 8),
              
              // Navigation breadcrumbs
              Expanded(
                child: Wrap(
                  children: [
                    // Quran root
                    _buildBreadcrumbItem(
                      context: context,
                      text: 'Quran', // Placeholder until l10n is fixed
                      isClickable: false,
                    ),
                    
                    _buildSeparator(context),
                    
                    // Reading mode
                    _buildBreadcrumbItem(
                      context: context,
                      text: _getReadingModeDisplayName(readingMode, l10n),
                      isClickable: false,
                    ),
                    
                    _buildSeparator(context),
                    
                    // Surah name
                    _buildBreadcrumbItem(
                      context: context,
                      text: _getSurahName(currentSurah, l10n),
                      isClickable: onSurahTap != null,
                      onTap: onSurahTap,
                    ),
                    
                    if (readingMode != 'surah_view') ...[
                      _buildSeparator(context),
                      
                      // Current verse/location
                      _buildBreadcrumbItem(
                        context: context,
                        text: _getCurrentLocationText(readingMode, currentAyah, l10n),
                        isClickable: onLocationTap != null,
                        onTap: onLocationTap,
                      ),
                    ],
                  ],
                ),
              ),
              
              // Quick actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildQuickAction(
                    context: context,
                    icon: Icons.bookmark_outline,
                    onTap: () => _showBookmarkMenu(context),
                  ),
                  const SizedBox(width: 8),
                  _buildQuickAction(
                    context: context,
                    icon: Icons.share_outlined,
                    onTap: () => _shareCurrentLocation(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumbItem({
    required BuildContext context,
    required String text,
    required bool isClickable,
    VoidCallback? onTap,
  }) {
    final textWidget = Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: isClickable 
          ? ThemeHelper.getPrimaryColor(context)
          : ThemeHelper.getTextSecondaryColor(context),
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    if (isClickable && onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: textWidget,
        ),
      );
    }

    return textWidget;
  }

  Widget _buildSeparator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Icon(
        Icons.chevron_right,
        size: 14,
        color: ThemeHelper.getTextSecondaryColor(context),
      ),
    );
  }

  Widget _buildQuickAction({
    required BuildContext context,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          size: 16,
          color: ThemeHelper.getPrimaryColor(context),
        ),
      ),
    );
  }

  String _getReadingModeDisplayName(String mode, AppLocalizations l10n) {
    switch (mode) {
      case 'page_view':
        return 'Page'; // Placeholder until l10n is fixed
      case 'verse_by_verse':
        return 'Verses'; // Placeholder until l10n is fixed
      case 'surah_view':
        return 'Surah'; // Placeholder until l10n is fixed
      case 'juz_view':
        return 'Juz'; // Placeholder until l10n is fixed
      default:
        return 'Reading'; // Placeholder until l10n is fixed
    }
  }

  String _getSurahName(int surahNumber, AppLocalizations l10n) {
    // In a real implementation, this would get the surah name from a data source
    // For now, return a placeholder format
    final surahNames = [
      'Al-Fatiha', 'Al-Baqarah', 'Ali Imran', 'An-Nisa', 'Al-Maidah',
      'Al-Anam', 'Al-Araf', 'Al-Anfal', 'At-Tawbah', 'Yunus',
      // ... Add more surah names as needed
    ];
    
    if (surahNumber > 0 && surahNumber <= surahNames.length) {
      return surahNames[surahNumber - 1];
    }
    
    return 'Surah $surahNumber'; // Placeholder until l10n is fixed
  }

  String _getCurrentLocationText(String mode, int ayah, AppLocalizations l10n) {
    switch (mode) {
      case 'verse_by_verse':
        return 'Verse $ayah'; // Placeholder until l10n is fixed
      case 'page_view':
        return 'Page $ayah'; // ayah parameter used as page number in page view
      case 'juz_view':
        return 'Juz $ayah'; // ayah parameter used as juz number in juz view
      default:
        return '$ayah';
    }
  }

  void _showBookmarkMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.bookmark_add),
              title: const Text('Add Bookmark'), // Placeholder until l10n is fixed
              onTap: () {
                Navigator.pop(context);
                _addBookmark(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmarks),
              title: const Text('View Bookmarks'), // Placeholder until l10n is fixed
              onTap: () {
                Navigator.pop(context);
                _viewBookmarks(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addBookmark(BuildContext context) {
    // Implementation for adding bookmark
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Bookmark Added'), // Placeholder until l10n is fixed
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _viewBookmarks(BuildContext context) {
    // Implementation for viewing bookmarks
    // This would navigate to a bookmarks screen
  }

  void _shareCurrentLocation(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final surahName = _getSurahName(currentSurah, l10n);
    final locationText = _getCurrentLocationText(readingMode, currentAyah, l10n);
    
    final shareText = '$surahName - $locationText';
    
    // In a real implementation, this would use the share package
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share: $shareText'), // Placeholder until l10n is fixed
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Provider for breadcrumb navigation state
final breadcrumbNavigationProvider = StateProvider<Map<String, dynamic>>((ref) {
  return {
    'currentSurah': 1,
    'currentAyah': 1,
    'readingMode': 'verse_by_verse',
    'isVisible': true,
  };
});

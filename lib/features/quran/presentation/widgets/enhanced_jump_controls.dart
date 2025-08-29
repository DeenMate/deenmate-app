import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Enhanced mobile-optimized jump controls for Quran navigation
/// Provides touch-friendly interface for jumping to specific verses, pages, or positions
class EnhancedJumpControls extends ConsumerStatefulWidget {
  const EnhancedJumpControls({
    required this.currentChapterId,
    required this.currentVerseNumber,
    required this.onJumpToVerse,
    required this.onJumpToPage,
    required this.onJumpToBookmark,
    super.key,
  });

  final int currentChapterId;
  final int currentVerseNumber;
  final Function(int chapterId, int verseNumber) onJumpToVerse;
  final Function(int pageNumber) onJumpToPage;
  final Function(String bookmarkKey) onJumpToBookmark;

  @override
  ConsumerState<EnhancedJumpControls> createState() =>
      _EnhancedJumpControlsState();
}

class _EnhancedJumpControlsState extends ConsumerState<EnhancedJumpControls>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Jump to verse controllers
  int _selectedChapter = 1;
  int _selectedVerse = 1;
  
  // Jump to page controller
  int _selectedPage = 1;
  
  // Search controllers
  final TextEditingController _searchController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedChapter = widget.currentChapterId;
    _selectedVerse = widget.currentVerseNumber;
    
    // Calculate current page (simplified calculation)
    _selectedPage = ((widget.currentChapterId - 1) * 20 + widget.currentVerseNumber ~/ 10).clamp(1, 604);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: ThemeHelper.getBackgroundColor(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  'Jump to Location',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close,
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                ),
              ],
            ),
          ),
          
          // Tab bar
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bookmark_outline, size: 18),
                    const SizedBox(width: 6),
                    Text('Verse'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.auto_stories_outlined, size: 18),
                    const SizedBox(width: 6),
                    Text('Page'),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.favorite_outline, size: 18),
                    const SizedBox(width: 6),
                    Text('Saved'),
                  ],
                ),
              ),
            ],
            labelColor: ThemeHelper.getPrimaryColor(context),
            unselectedLabelColor: ThemeHelper.getTextSecondaryColor(context),
            indicatorColor: ThemeHelper.getPrimaryColor(context),
          ),
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildVerseJumpTab(context, localizations),
                _buildPageJumpTab(context, localizations),
                _buildBookmarksTab(context, localizations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerseJumpTab(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Chapter and Verse',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          ),
          const SizedBox(height: 20),
          
          // Chapter picker
          _buildPickerSection(
            context,
            'Chapter (Surah)',
            _selectedChapter,
            1,
            114,
            (value) => setState(() => _selectedChapter = value),
          ),
          
          const SizedBox(height: 20),
          
          // Verse picker  
          _buildPickerSection(
            context,
            'Verse (Ayah)',
            _selectedVerse,
            1,
            _getMaxVersesForChapter(_selectedChapter),
            (value) => setState(() => _selectedVerse = value),
          ),
          
          const SizedBox(height: 30),
          
          // Current position indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.my_location,
                  color: ThemeHelper.getPrimaryColor(context),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Current: Chapter ${widget.currentChapterId}, Verse ${widget.currentVerseNumber}',
                    style: TextStyle(
                      fontSize: 14,
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const Spacer(),
          
          // Jump button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _selectedChapter != widget.currentChapterId || 
                         _selectedVerse != widget.currentVerseNumber
                  ? () {
                      widget.onJumpToVerse(_selectedChapter, _selectedVerse);
                      Navigator.of(context).pop();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeHelper.getPrimaryColor(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Jump to Verse',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageJumpTab(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Jump to Page',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          ),
          const SizedBox(height: 20),
          
          // Page picker
          _buildPickerSection(
            context,
            'Page Number',
            _selectedPage,
            1,
            604,
            (value) => setState(() => _selectedPage = value),
          ),
          
          const SizedBox(height: 30),
          
          // Quick page shortcuts
          Text(
            'Quick Access',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 12),
          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickPageButton(context, 'Al-Fatihah', 1),
              _buildQuickPageButton(context, 'Al-Baqarah', 2),
              _buildQuickPageButton(context, 'Yasin', 440),
              _buildQuickPageButton(context, 'Ar-Rahman', 531),
              _buildQuickPageButton(context, 'Al-Mulk', 562),
              _buildQuickPageButton(context, 'Last Page', 604),
            ],
          ),
          
          const Spacer(),
          
          // Jump button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                widget.onJumpToPage(_selectedPage);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeHelper.getPrimaryColor(context),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Jump to Page $_selectedPage',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarksTab(BuildContext context, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saved Locations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          ),
          const SizedBox(height: 20),
          
          // Search bookmarks
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search bookmarks...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ThemeHelper.getDividerColor(context),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: ThemeHelper.getPrimaryColor(context),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Bookmarks list
          Expanded(
            child: Consumer(
              builder: (context, ref, child) {
                // In a real implementation, this would fetch bookmarks from storage
                return ListView(
                  children: [
                    _buildBookmarkItem(
                      context,
                      'Al-Fatihah',
                      'Chapter 1, Verse 1',
                      '1:1',
                      Icons.star,
                    ),
                    _buildBookmarkItem(
                      context,
                      'Ayat al-Kursi',
                      'Chapter 2, Verse 255',
                      '2:255',
                      Icons.bookmark,
                    ),
                    _buildBookmarkItem(
                      context,
                      'Last Read',
                      'Chapter ${widget.currentChapterId}, Verse ${widget.currentVerseNumber}',
                      '${widget.currentChapterId}:${widget.currentVerseNumber}',
                      Icons.history,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPickerSection(
    BuildContext context,
    String label,
    int value,
    int min,
    int max,
    Function(int) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: ThemeHelper.getDividerColor(context)),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              // Decrease button
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: value > min 
                      ? ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1)
                      : ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
                child: IconButton(
                  onPressed: value > min ? () => onChanged(value - 1) : null,
                  icon: Icon(
                    Icons.remove,
                    color: value > min 
                        ? ThemeHelper.getPrimaryColor(context)
                        : ThemeHelper.getTextSecondaryColor(context),
                  ),
                ),
              ),
              
              // Value display
              Expanded(
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: Text(
                    value.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: ThemeHelper.getTextPrimaryColor(context),
                    ),
                  ),
                ),
              ),
              
              // Increase button
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: value < max 
                      ? ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1)
                      : ThemeHelper.getTextSecondaryColor(context).withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: IconButton(
                  onPressed: value < max ? () => onChanged(value + 1) : null,
                  icon: Icon(
                    Icons.add,
                    color: value < max 
                        ? ThemeHelper.getPrimaryColor(context)
                        : ThemeHelper.getTextSecondaryColor(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPageButton(BuildContext context, String label, int page) {
    return InkWell(
      onTap: () => setState(() => _selectedPage = page),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _selectedPage == page
              ? ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1)
              : ThemeHelper.getSurfaceColor(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _selectedPage == page
                ? ThemeHelper.getPrimaryColor(context)
                : ThemeHelper.getDividerColor(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _selectedPage == page
                ? ThemeHelper.getPrimaryColor(context)
                : ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkItem(
    BuildContext context,
    String title,
    String subtitle,
    String verseKey,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: ThemeHelper.getPrimaryColor(context),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ThemeHelper.getTextPrimaryColor(context),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: ThemeHelper.getTextSecondaryColor(context),
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: ThemeHelper.getTextSecondaryColor(context),
      ),
      onTap: () {
        widget.onJumpToBookmark(verseKey);
        Navigator.of(context).pop();
      },
    );
  }

  int _getMaxVersesForChapter(int chapterId) {
    // Simplified verse count - in production, use actual Quran data
    const chapterVerseCounts = {
      1: 7, 2: 286, 3: 200, 4: 176, 5: 120, 6: 165, 7: 206, 8: 75, 9: 129, 10: 109,
      // Add more as needed...
    };
    return chapterVerseCounts[chapterId] ?? 50; // Default fallback
  }
}

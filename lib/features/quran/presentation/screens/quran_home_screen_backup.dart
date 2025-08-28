import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/dto/chapter_dto.dart';

import '../state/providers.dart';
import '../../../../core/theme/theme_helper.dart';
import 'quran_reader_screen.dart';

class QuranHomeScreen extends ConsumerStatefulWidget {
  const QuranHomeScreen({super.key});

  @override
  ConsumerState<QuranHomeScreen> createState() => _QuranHomeScreenState();
}

class _QuranHomeScreenState extends ConsumerState<QuranHomeScreen> {
  String _selectedTab = 'Sura';
  final List<String> _tabs = ['Sura', 'Page', 'Juz', 'Hizb', 'Ruku'];

  @override
  Widget build(BuildContext context) {
    final chapters = ref.watch(surahListProvider);
    final lastRead = ref.watch(lastReadProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu,
              color: ThemeHelper.getTextPrimaryColor(context)),
          onPressed: () {
            // TODO: Implement menu
          },
        ),
        title: Text(
          'Al Quran',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        centerTitle: true,
        actions: [
          // Offline status indicator
          Consumer(
            builder: (context, ref, child) {
              final offlineStatus = ref.watch(offlineContentStatusProvider);
              return offlineStatus.when(
                data: (status) => IconButton(
                  icon: Icon(
                    status.isFullyOffline
                        ? Icons.cloud_done
                        : status.hasEssentialContent
                            ? Icons.cloud_download
                            : Icons.cloud_off,
                    color: status.isFullyOffline
                        ? ThemeHelper.getPrimaryColor(context)
                        : status.hasEssentialContent
                            ? Theme.of(context).colorScheme.secondary
                            : ThemeHelper.getTextSecondaryColor(context),
                  ),
                  onPressed: () {
                    context.push('/quran/audio-downloads');
                  },
                  tooltip: status.isFullyOffline
                      ? 'Fully available offline'
                      : status.hasEssentialContent
                          ? 'Essential content available'
                          : 'Limited offline content',
                ),
                loading: () => IconButton(
                  icon: Icon(
                    Icons.cloud_off,
                    color: ThemeHelper.getTextSecondaryColor(context),
                  ),
                  onPressed: () {
                    context.push('/quran/audio-downloads');
                  },
                ),
                error: (_, __) => const SizedBox.shrink(),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.search,
                color: ThemeHelper.getTextPrimaryColor(context)),
            onPressed: () {
              context.go('/quran/search');
            },
          ),
        ],
      ),
      body: chapters.when(
        data: (list) {
          return _buildBody(context, list, lastRead);
        },
        loading: () => const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF7B1FA2),
          ),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading Quran',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<ChapterDto> list,
      AsyncValue<LastReadEntry?> lastReadAsync) {
    // Show content based on selected tab
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Last Read Section (only show for Sura tab)
        if (_selectedTab == 'Sura' && lastReadAsync.value != null) ...[
          const Text(
            'Last Read',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 12),
          _buildLastReadSection(lastReadAsync.value!, list),
          const SizedBox(height: 24),
        ],

        // Quick Access Features Section (only show for Sura tab)
        if (_selectedTab == 'Sura') ...[
          _buildQuickAccessSection(),
          const SizedBox(height: 24),
        ],

        // Navigation Tabs
        _buildNavigationTabs(),
        const SizedBox(height: 16),

        // Content based on selected tab
        _buildTabContent(),
      ],
    );
  }

  Widget _buildLastReadSection(LastReadEntry last, List<ChapterDto> chapters) {
    // Find the chapter for the last read entry
    final chapter = chapters.firstWhere(
      (c) => c.id == last.chapterId,
      orElse: () => ChapterDto(
        id: last.chapterId,
        nameArabic: 'Unknown',
        nameSimple: 'Unknown',
        versesCount: 0,
        revelationPlace: 'Meccan',
      ),
    );

    // Extract verse number from verse key (e.g., "2:255" -> "255")
    final verseNumber = last.verseKey.split(':').last;

    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 12),
            child: Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () {
                  // Navigate to the last read position
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuranReaderScreen(
                        chapterId: last.chapterId,
                        targetVerseKey: last.verseKey,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                        ThemeHelper.getPrimaryColor(context).withOpacity(0.2),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        chapter.nameSimple,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: ThemeHelper.getPrimaryColor(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Verse $verseNumber',
                        style: TextStyle(
                          fontSize: 14,
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeHelper.getPrimaryColor(context),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: ThemeHelper.getPrimaryColor(context),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5D4037),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickAccessTile(
                'Bookmarks',
                Icons.bookmark,
                const Color(0xFF7B1FA2),
                () => context.go('/quran/bookmarks'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickAccessTile(
                'Reading Plans',
                Icons.schedule,
                const Color(0xFF2E7D32),
                () => context.go('/quran/reading-plans'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Note: Offline functionality moved to cloud icon in top bar
        // Audio Downloads moved to More > Settings as per user feedback
      ],
    );
  }

  Widget _buildQuickAccessTile(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          final tab = _tabs[index];
          final isSelected = tab == _selectedTab;

          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = tab;
                });

                // Change content within the same page
                setState(() {
                  _selectedTab = tab;
                  // Clear search when switching tabs
                  _searchQuery = '';
                  _isSearching = false;
                  _filteredChapters.clear();
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ThemeHelper.getPrimaryColor(context)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? ThemeHelper.getPrimaryColor(context)
                        : ThemeHelper.getDividerColor(context),
                    width: 1,
                  ),
                ),
                child: Text(
                  tab,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimary
                        : ThemeHelper.getPrimaryColor(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 'Sura':
        return Column(
          children: _buildSurahList(
              _filteredChapters.isNotEmpty ? _filteredChapters : []),
        );
      case 'Page':
        return _buildPageList();
      case 'Juz':
        return _buildJuzList();
      case 'Hizb':
        return _buildHizbList();
      case 'Ruku':
        return _buildRukuList();
      default:
        return Column(
          children: _buildSurahList(
              _filteredChapters.isNotEmpty ? _filteredChapters : []),
        );
    }
  }

  Widget _buildPageList() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(pagesProvider).when(
              data: (pages) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  final page = pages[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ThemeHelper.getPrimaryColor(context),
                        child: Text(
                          '${page.pageNumber}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        'Page ${page.pageNumber}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${page.verseCount ?? 0} verses',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.go('/quran/page/${page.pageNumber}'),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Error loading pages: $error'),
              ),
            );
      },
    );
  }

  Widget _buildJuzList() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(juzListProvider).when(
              data: (juzList) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: juzList.length,
                itemBuilder: (context, index) {
                  final juz = juzList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ThemeHelper.getPrimaryColor(context),
                        child: Text(
                          '${juz.juzNumber}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        'Juz ${juz.juzNumber}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${juz.verseCount ?? 0} verses',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.go('/quran/juz/${juz.juzNumber}'),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Error loading Juz list: $error'),
              ),
            );
      },
    );
  }

  Widget _buildHizbList() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(hizbListProvider).when(
              data: (hizbList) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: hizbList.length,
                itemBuilder: (context, index) {
                  final hizb = hizbList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ThemeHelper.getPrimaryColor(context),
                        child: Text(
                          '${hizb.hizbNumber}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        'Hizb ${hizb.hizbNumber}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${hizb.verseCount ?? 0} verses',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.go('/quran/hizb/${hizb.hizbNumber}'),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Error loading Hizb list: $error'),
              ),
            );
      },
    );
  }

  Widget _buildRukuList() {
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(rukuListProvider).when(
              data: (rukuList) => ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: rukuList.length,
                itemBuilder: (context, index) {
                  final ruku = rukuList[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: ThemeHelper.getPrimaryColor(context),
                        child: Text(
                          '${ruku.rukuNumber}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        'Ruku ${ruku.rukuNumber}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${ruku.verseCount ?? 0} verses',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () => context.go('/quran/ruku/${ruku.rukuNumber}'),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text('Error loading Ruku list: $error'),
              ),
            );
      },
    );
  }

  List<Widget> _buildSurahList(List<ChapterDto> list) {
    return list.map((chapter) => _buildSurahTile(chapter)).toList();
  }

  Widget _buildSurahTile(ChapterDto chapter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${chapter.id}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ThemeHelper.getPrimaryColor(context),
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              Expanded(
                child: Text(
                  chapter.nameSimple,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
              ),
              Text(
                chapter.nameArabic,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ThemeHelper.getPrimaryColor(context),
                  fontFamily: 'Uthmani',
                ),
              ),
            ],
          ),
          subtitle: Text(
            '${chapter.versesCount} Verses • ${chapter.revelationPlace}',
            style: TextStyle(
              fontSize: 14,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          onTap: () => GoRouter.of(context).push('/quran/surah/${chapter.id}'),
        ),
      ),
    );
  }

  ),
      ),
    );
  }
}

  Widget _buildSearchExample(String title, String example) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 16,
            color: ThemeHelper.getPrimaryColor(context),
          ),
          const SizedBox(width: 8),
          Text(
            '$title: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          ),
          Text(
            example,
            style: TextStyle(
              fontSize: 14,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
          const SizedBox(height: 16),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords or check the spelling.',
            style: TextStyle(
              fontSize: 16,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<ChapterDto> results) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search results header
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            '${results.length} result${results.length == 1 ? '' : 's'} for "$_searchQuery"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
        ),

        // Search results list
        ...results.map((chapter) => _buildSurahTile(chapter)).toList(),
      ],
    );
  }
}

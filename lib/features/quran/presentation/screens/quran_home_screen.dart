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
          // Search icon - navigate to Advanced Search
          IconButton(
            icon: Icon(
              Icons.search,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
            onPressed: () {
              context.go('/quran/search');
            },
          ),
        ],
      ),
      body: chapters.when(
        data: (chapterList) => Column(
          children: [
            // Last Read Section
            if (lastRead.hasValue && lastRead.value != null)
              _buildLastReadSection(lastRead.value!),

            // Navigation Tabs
            _buildNavigationTabs(),

            // Content based on selected tab
            Expanded(
              child: _buildTabContent(chapterList),
            ),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load Quran',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(surahListProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLastReadSection(LastReadEntry lastRead) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuranReaderScreen(
              chapterId: lastRead.chapterId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              ThemeHelper.getPrimaryColor(context),
              ThemeHelper.getPrimaryColor(context).withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Last Read',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Chapter ${lastRead.chapterId}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  lastRead.verseKey,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to bookmarks page
              context.go('/quran/bookmarks');
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.bookmark,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildNavigationTabs() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _tabs.map((tab) {
              final isSelected = tab == _selectedTab;
              final index = _tabs.indexOf(tab);
              
              return Container(
                margin: EdgeInsets.only(
                  right: index < _tabs.length - 1 ? 8 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTab = tab;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                            ? Colors.white
                            : ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(List<ChapterDto> chapters) {
    switch (_selectedTab) {
      case 'Sura':
        return _buildChapterList(chapters);
      case 'Page':
        return _buildPageList();
      case 'Juz':
        return _buildJuzList();
      case 'Hizb':
        return _buildHizbList();
      case 'Ruku':
        return _buildRukuList();
      default:
        return _buildChapterList(chapters);
    }
  }

  Widget _buildChapterList(List<ChapterDto> list) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) => _buildSurahTile(list[index]),
    );
  }

  Widget _buildSurahTile(ChapterDto chapter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: ThemeHelper.getCardColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              chapter.id.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getPrimaryColor(context),
              ),
            ),
          ),
        ),
        title: Text(
          chapter.nameArabic,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        subtitle: Text(
          '${chapter.nameSimple} • ${chapter.versesCount} ayahs',
          style: TextStyle(
            fontSize: 14,
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            chapter.revelationPlace,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: ThemeHelper.getPrimaryColor(context),
            ),
          ),
        ),
        onTap: () async {
          final updater = ref.read(lastReadUpdaterProvider);
          await updater(LastReadEntry(
            chapterId: chapter.id,
            verseKey: '${chapter.id}:1',
          ));

          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => QuranReaderScreen(
                  chapterId: chapter.id,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildPageList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 604, // Total pages in Quran
      itemBuilder: (context, index) {
        final pageNumber = index + 1;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tileColor: ThemeHelper.getCardColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  pageNumber.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getPrimaryColor(context),
                  ),
                ),
              ),
            ),
            title: Text(
              'Page $pageNumber',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
            subtitle: Text(
              'Mushaf page',
              style: TextStyle(
                fontSize: 14,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            onTap: () {
              // Navigate to page reader
              context.go('/quran/page/$pageNumber');
            },
          ),
        );
      },
    );
  }

  Widget _buildJuzList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 30, // Total Juz in Quran
      itemBuilder: (context, index) {
        final juzNumber = index + 1;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tileColor: ThemeHelper.getCardColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  juzNumber.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getPrimaryColor(context),
                  ),
                ),
              ),
            ),
            title: Text(
              'Juz $juzNumber',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
            subtitle: Text(
              'Para $juzNumber',
              style: TextStyle(
                fontSize: 14,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            onTap: () {
              // Navigate to Juz reader
              context.go('/quran/juz/$juzNumber');
            },
          ),
        );
      },
    );
  }

  Widget _buildHizbList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 60, // Total Hizb in Quran
      itemBuilder: (context, index) {
        final hizbNumber = index + 1;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tileColor: ThemeHelper.getCardColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  hizbNumber.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getPrimaryColor(context),
                  ),
                ),
              ),
            ),
            title: Text(
              'Hizb $hizbNumber',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
            subtitle: Text(
              'Quarter section',
              style: TextStyle(
                fontSize: 14,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            onTap: () {
              // Navigate to Hizb reader
              context.go('/quran/hizb/$hizbNumber');
            },
          ),
        );
      },
    );
  }

  Widget _buildRukuList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 556, // Total Ruku in Quran
      itemBuilder: (context, index) {
        final rukuNumber = index + 1;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            tileColor: ThemeHelper.getCardColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  rukuNumber.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getPrimaryColor(context),
                  ),
                ),
              ),
            ),
            title: Text(
              'Ruku $rukuNumber',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
            subtitle: Text(
              'Ruku section',
              style: TextStyle(
                fontSize: 14,
                color: ThemeHelper.getTextSecondaryColor(context),
              ),
            ),
            onTap: () {
              // Navigate to Ruku reader
              context.go('/quran/ruku/$rukuNumber');
            },
          ),
        );
      },
    );
  }
}

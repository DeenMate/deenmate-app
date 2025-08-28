import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import '../../data/dto/verse_dto.dart';
import '../../data/dto/verses_page_dto.dart';
import '../../data/dto/chapter_dto.dart';
import '../../data/dto/translation_resource_dto.dart';
import '../state/providers.dart';
import '../widgets/verse_card_widget.dart';
import '../widgets/reading_mode_overlay.dart';
import '../widgets/enhanced_font_settings_widget.dart';
import '../widgets/translation_picker_widget.dart';
import '../widgets/tafsir_widget.dart';
import '../widgets/word_analysis_widget.dart';
import '../widgets/audio_download_prompt.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../core/storage/hive_boxes.dart' as boxes;
import '../../../../core/localization/strings.dart';

class EnhancedQuranReaderScreen extends ConsumerStatefulWidget {
  const EnhancedQuranReaderScreen({
    super.key,
    required this.chapterId,
    this.targetVerseKey,
  });

  final int chapterId;
  final String? targetVerseKey;

  @override
  ConsumerState<EnhancedQuranReaderScreen> createState() =>
      _EnhancedQuranReaderScreenState();
}

class _EnhancedQuranReaderScreenState
    extends ConsumerState<EnhancedQuranReaderScreen>
    with WidgetsBindingObserver {
  final ScrollController _controller = ScrollController();
  final Map<int, VersesPageDto> _pageCache = {};
  final List<VerseDto> _verses = <VerseDto>[];
  final List<String> _audioUrls = <String>[];
  final int _maxCachedPages = 10;
  final Set<String> _localBookmarkOn = {};
  final Set<String> _localBookmarkOff = {};

  int _page = 1;
  bool _isFetchingMore = false;
  bool _hasMorePages = true;
  bool _isReadingMode = false;
  StreamSubscription? _prefsSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller.addListener(_onScroll);

    // Load initial page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPage(1);
    });

    // Set up audio service callback for download prompts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final audioService = ref.read(quranAudioServiceProvider);
      audioService.onPromptDownload = _showAudioDownloadPrompt;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.removeListener(_onScroll);
    _controller.dispose();
    _prefsSubscription?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent - 1000) {
      if (!_isFetchingMore && _hasMorePages) {
        _loadNextPage();
      }
    }
  }

  Future<void> _loadPage(int page) async {
    if (_pageCache.containsKey(page)) {
      _updateVersesFromCache();
      return;
    }

    try {
      final prefs = ref.read(prefsProvider);
      final args = SurahPageArgs(
        widget.chapterId,
        page,
        translationIds: prefs.selectedTranslationIds,
        recitationId: prefs.recitationId,
      );

      final pageData = await ref.read(surahPageProvider(args).future);

      if (mounted) {
        setState(() {
          _pageCache[page] = pageData;
          _hasMorePages = pageData.verses.length >= 50; // Assuming 50 per page
        });

        _updateVersesFromCache();
        _cleanupOldPages();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading page: $e')),
        );
      }
    }
  }

  Future<void> _loadNextPage() async {
    if (_isFetchingMore) return;

    setState(() {
      _isFetchingMore = true;
    });

    await _loadPage(_page + 1);

    if (mounted) {
      setState(() {
        _page++;
        _isFetchingMore = false;
      });
    }
  }

  void _updateVersesFromCache() {
    final allVerses = <VerseDto>[];
    final allUrls = <String>[];
    final sortedPages = _pageCache.keys.toList()..sort();

    for (final page in sortedPages) {
      final pageData = _pageCache[page]!;
      allVerses.addAll(pageData.verses);

      for (final verse in pageData.verses) {
        if (verse.audio?.url != null) {
          allUrls.add(verse.audio!.url);
        }
      }
    }

    setState(() {
      _verses.clear();
      _verses.addAll(allVerses);
      _audioUrls.clear();
      _audioUrls.addAll(allUrls);
      ref.read(quranAudioProvider.notifier).setPlaylist(_audioUrls);
    });
  }

  void _onTranslationPreferencesChanged() async {
    // Clear cache and reload with new translations
    _pageCache.clear();

    // Clear Hive cache for this chapter
    final vBox = await Hive.openBox(boxes.Boxes.verses);
    final keysToDelete = <String>[];
    for (final key in vBox.keys) {
      if (key.toString().startsWith('ch:${widget.chapterId}|')) {
        keysToDelete.add(key.toString());
      }
    }

    for (final key in keysToDelete) {
      await vBox.delete(key);
    }

    // Reload current view
    await _loadPage(1);
    setState(() {
      _page = 1;
    });
  }

  void _cleanupOldPages() {
    if (_pageCache.length > _maxCachedPages) {
      final sortedPages = _pageCache.keys.toList()..sort();
      final pagesToRemove =
          sortedPages.take(_pageCache.length - _maxCachedPages);

      for (final page in pagesToRemove) {
        _pageCache.remove(page);
      }
    }
  }

  void _toggleReadingMode() {
    setState(() {
      _isReadingMode = !_isReadingMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final chaptersAsync = ref.watch(surahListProvider);
    final translationResourcesAsync = ref.watch(translationResourcesProvider);

    // Listen for translation preference changes in build method
    ref.listen(prefsProvider, (previous, next) {
      if (previous?.selectedTranslationIds != next.selectedTranslationIds) {
        _onTranslationPreferencesChanged();
      }
    });

    if (_isReadingMode) {
      return ReadingModeOverlay(
        onExitReadingMode: _toggleReadingMode,
        child: _buildReadingContent(
            context, chaptersAsync, translationResourcesAsync),
      );
    }

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      body: _buildReadingContent(
          context, chaptersAsync, translationResourcesAsync),
    );
  }

  Widget _buildReadingContent(
    BuildContext context,
    AsyncValue<List<ChapterDto>> chaptersAsync,
    AsyncValue<List<TranslationResourceDto>> translationResourcesAsync,
  ) {
    return translationResourcesAsync.when(
      data: (translationResources) {
        // Determine RTL direction based on current translations
        final isRTL = _shouldUseRTL(translationResources);

        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: CustomScrollView(
            controller: _controller,
            slivers: [
              // App bar
              if (!_isReadingMode) _buildSliverAppBar(context, chaptersAsync),

              // Verses content
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: _isReadingMode ? 24 : 16,
                  vertical: _isReadingMode ? 32 : 16,
                ),
                sliver: _buildVersesList(translationResources),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading translations: $error'),
      ),
    );
  }

  Widget _buildSliverAppBar(
      BuildContext context, AsyncValue<List<ChapterDto>> chaptersAsync) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SliverAppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        elevation: 0,
        floating: true,
        snap: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: ThemeHelper.getTextPrimaryColor(context)),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/quran');
            }
          },
        ),
        title: chaptersAsync.when(
          data: (chapters) {
            final chapter = chapters.isNotEmpty
                ? chapters.firstWhere(
                    (c) => c.id == widget.chapterId,
                    orElse: () => chapters.first,
                  )
                : null;
            if (chapter == null) {
              return const SizedBox.shrink();
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chapter.nameSimple,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
                Text(
                  chapter.nameArabic,
                  style: TextStyle(
                    fontSize: 14,
                    color: ThemeHelper.getTextSecondaryColor(context),
                    fontFamily: 'Uthmani',
                  ),
                ),
              ],
            );
          },
          loading: () => const SizedBox.shrink(),
          error: (_, __) => const SizedBox.shrink(),
        ),
        actions: [
          // Reading mode toggle
          IconButton(
            icon: Icon(
              _isReadingMode ? Icons.fullscreen_exit : Icons.fullscreen,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
            onPressed: _toggleReadingMode,
            tooltip:
                _isReadingMode ? 'Exit reading mode' : 'Enter reading mode',
          ),

          // Quick settings
          IconButton(
            icon: Icon(Icons.tune,
                color: ThemeHelper.getTextPrimaryColor(context)),
            onPressed: _showQuickSettings,
            tooltip: 'Quick settings',
          ),
        ],
      ),
    );
  }

  Widget _buildVersesList(List<TranslationResourceDto> translationResources) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == _verses.length) {
            return _isFetchingMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          final verse = _verses[index];
          return VerseCardWidget(
            verse: verse,
            translationResources: translationResources,
            onShare: () => _shareVerse(verse),
            onBookmark: () => _toggleBookmark(verse),
            onCopy: () => _copyVerse(verse),
            onTafsir: () => _showTafsir(verse),
            isBookmarked: _isVerseBookmarked(verse),
            showVerseActions: !_isReadingMode,
          );
        },
        childCount: _verses.length + (_isFetchingMore ? 1 : 0),
      ),
    );
  }

  void _showQuickSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: ThemeHelper.getSurfaceColor(context),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Consumer(
            builder: (context, ref, _) {
              final prefs = ref.watch(prefsProvider);
              final notifier = ref.read(prefsProvider.notifier);
              return ConstrainedBox(
                constraints: BoxConstraints(
                  // up to 85% of screen height
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 12),
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
                      // Header
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Quick Tools',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      ThemeHelper.getTextPrimaryColor(context),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.tune,
                                  color: ThemeHelper.getTextSecondaryColor(
                                      context)),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EnhancedFontSettingsWidget(),
                                  ),
                                );
                              },
                              tooltip: 'Font settings',
                            ),
                          ],
                        ),
                      ),
                      // Navigation tabs row (static shortcuts)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildChip(context, 'Sura', selected: true),
                            _buildChip(context, 'Page'),
                            _buildChip(context, 'Juz'),
                            _buildChip(context, 'Hizb'),
                            _buildChip(context, 'Ruku'),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Content toggles
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            SwitchListTile(
                              title: const Text('Arabic'),
                              value: prefs.showArabic,
                              onChanged: (v) => notifier.updateShowArabic(v),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            SwitchListTile(
                              title: const Text('Translation'),
                              value: prefs.showTranslation,
                              onChanged: (v) =>
                                  notifier.updateShowTranslation(v),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            SwitchListTile(
                              title: const Text('Tafsir'),
                              value: prefs.showTafsir,
                              onChanged: (v) => notifier.updateShowTafsir(v),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            SwitchListTile(
                              title: const Text('Word by Word'),
                              value: prefs.showWordAnalysis,
                              onChanged: (v) =>
                                  notifier.updateShowWordAnalysis(v),
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      // Font sliders (inline quick)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Font Settings',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color:
                                      ThemeHelper.getTextPrimaryColor(context),
                                )),
                            const SizedBox(height: 8),
                            _buildLabeledSlider(
                              context,
                              label: 'Arabic Font Size',
                              value: prefs.arabicFontSize,
                              min: 16,
                              max: 40,
                              onChanged: (v) =>
                                  notifier.updateArabicFontSize(v),
                            ),
                            _buildLabeledSlider(
                              context,
                              label: 'Translations/Tafsir Size',
                              value: prefs.translationFontSize,
                              min: 12,
                              max: 24,
                              onChanged: (v) =>
                                  notifier.updateTranslationFontSize(v),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String text,
      {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: selected
            ? ThemeHelper.getPrimaryColor(context).withOpacity(0.1)
            : ThemeHelper.getSurfaceColor(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected
              ? ThemeHelper.getPrimaryColor(context)
              : ThemeHelper.getDividerColor(context),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: selected
              ? ThemeHelper.getPrimaryColor(context)
              : ThemeHelper.getTextSecondaryColor(context),
        ),
      ),
    );
  }

  Widget _buildLabeledSlider(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style:
                    TextStyle(color: ThemeHelper.getTextPrimaryColor(context))),
            Text(value.toStringAsFixed(0),
                style: TextStyle(
                    color: ThemeHelper.getPrimaryColor(context),
                    fontWeight: FontWeight.w600)),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: ThemeHelper.getPrimaryColor(context),
            inactiveTrackColor:
                ThemeHelper.getPrimaryColor(context).withOpacity(0.3),
            thumbColor: ThemeHelper.getPrimaryColor(context),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            divisions: (max - min).round(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _shareVerse(VerseDto verse) {
    final translation =
        verse.translations.isNotEmpty ? verse.translations.first.text : '';

    final shareText = '''
${verse.textUthmani}

$translation

Quran ${verse.verseKey}
''';

    Share.share(shareText);
  }

  Future<void> _toggleBookmark(VerseDto verse) async {
    final bookmarksService = ref.read(bookmarksServiceProvider);

    try {
      final isBookmarked = await bookmarksService.isBookmarked(verse.verseKey);

      if (isBookmarked) {
        await bookmarksService.removeBookmark(verse.verseKey);
        setState(() {
          _localBookmarkOff.add(verse.verseKey);
          _localBookmarkOn.remove(verse.verseKey);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bookmark removed'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        final derivedChapterId =
            int.tryParse(verse.verseKey.split(':').first) ?? widget.chapterId;
        await bookmarksService.addBookmark(
          verseKey: verse.verseKey,
          chapterId: derivedChapterId,
          verseNumber: verse.verseNumber,
        );
        setState(() {
          _localBookmarkOn.add(verse.verseKey);
          _localBookmarkOff.remove(verse.verseKey);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verse bookmarked'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _copyVerse(VerseDto verse) {
    final translation =
        verse.translations.isNotEmpty ? verse.translations.first.text : '';

    final copyText = '''${verse.textUthmani}
$translation
Quran ${verse.verseKey}''';

    Clipboard.setData(ClipboardData(text: copyText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Verse copied to clipboard')),
    );
  }

  void _showTafsir(VerseDto verse) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: ThemeHelper.getBackgroundColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ThemeHelper.getTextSecondaryColor(context)
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.menu_book,
                      color: ThemeHelper.getPrimaryColor(context),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Tafsir - ${verse.verseKey}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getTextPrimaryColor(context),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.translate,
                          color: ThemeHelper.getTextSecondaryColor(context)),
                      onPressed: () => _showWordAnalysis(verse),
                      tooltip: 'Word analysis',
                    ),
                  ],
                ),
              ),
              // Tafsir content
              Expanded(
                child: TafsirWidget(
                  verse: verse,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showWordAnalysis(VerseDto verse) {
    if (context.canPop()) {
      context.pop(); // Close tafsir sheet
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.4,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: ThemeHelper.getBackgroundColor(context),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: ThemeHelper.getTextSecondaryColor(context)
                      .withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.translate,
                      color: ThemeHelper.getPrimaryColor(context),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Word Analysis - ${verse.verseKey}',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getTextPrimaryColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              // Word analysis content
              Expanded(
                child: WordAnalysisWidget(
                  verse: verse,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Show download prompt when audio is not available offline
  Future<bool> _showAudioDownloadPrompt(dynamic verse) async {
    if (!mounted) return false;

    // Get chapter name for display
    final chapters = await ref.read(surahListProvider.future);
    final derivedChapterId = int.tryParse(verse.verseKey.split(':').first) ?? 1;
    final chapter = chapters.firstWhere(
      (c) => c.id == derivedChapterId,
      orElse: () => ChapterDto(
        id: derivedChapterId,
        nameSimple: 'Chapter $derivedChapterId',
        nameArabic: '',
        versesCount: 0,
        revelationPlace: '',
      ),
    );

    return await AudioDownloadPromptDialog.show(
      context,
      verse,
      chapter.nameSimple,
    );
  }

  bool _isVerseBookmarked(VerseDto verse) {
    // Use local state for immediate UI feedback
    if (_localBookmarkOn.contains(verse.verseKey)) return true;
    if (_localBookmarkOff.contains(verse.verseKey)) return false;

    // Check from bookmark service stream (reactive state)
    final bookmarkKeysAsync = ref.watch(bookmarksProvider);
    return bookmarkKeysAsync.when(
      data: (bookmarkKeys) => bookmarkKeys.contains(verse.verseKey),
      loading: () => false,
      error: (_, __) => false,
    );
  }

  /// Determine if RTL direction should be used based on selected translations
  bool _shouldUseRTL(List<TranslationResourceDto> translationResources) {
    final prefs = ref.read(prefsProvider);

    // Always prioritize Arabic text (Quran is always RTL)
    // But check if we have any RTL translations selected
    for (final translationId in prefs.selectedTranslationIds) {
      final resource = translationResources.firstWhere(
        (r) => r.id == translationId,
        orElse: () => TranslationResourceDto(
          id: translationId,
          name: '',
          authorName: '',
          slug: '',
          languageName: 'unknown',
        ),
      );

      // Check if the language is RTL
      final langCode = resource.languageName?.toLowerCase() ?? '';
      if (S.isRTL(langCode)) {
        return true;
      }

      // Also check common language codes that might be in the name
      final langName = langCode;
      if (langName.contains('arabic') ||
          langName.contains('urdu') ||
          langName.contains('عربي') ||
          langName.contains('اردو')) {
        return true;
      }
    }

    // If no RTL translations selected, still use RTL for Arabic Quran text
    // This ensures Arabic verses are always displayed RTL
    return true; // Default to RTL since Quran is Arabic
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/utils/app_logger.dart';

import '../../domain/services/search_service.dart';
import '../state/providers.dart';
import '../widgets/search_result_card.dart';
import '../widgets/search_filters_widget.dart';
import '../widgets/search_history_widget.dart';
import '../../../../core/theme/theme_helper.dart';

/// Advanced Quran search screen with filters, history, and suggestions
/// Matches QuranMazid.com standards with comprehensive search capabilities
class QuranSearchScreen extends ConsumerStatefulWidget {
  const QuranSearchScreen({super.key});

  @override
  ConsumerState<QuranSearchScreen> createState() => _QuranSearchScreenState();
}

class _QuranSearchScreenState extends ConsumerState<QuranSearchScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  // Search state
  bool _isSearching = false;
  bool _showFilters = false;
  bool _showHistory = false;
  String _currentQuery = '';

  // Search results
  List<dynamic> _searchResults = [];
  List<SearchSuggestion> _suggestions = [];
  List<String> _searchHistory = [];

  // Search filters
  SearchScope _searchScope = SearchScope.all;
  List<int> _selectedChapterIds = [];
  List<int> _selectedTranslationIds = [];
  bool _enableDiacriticsSearch = false;
  bool _exactMatch = false;
  bool _enableTransliteration = false;
  bool _enableBengaliSearch = false;
  bool _enableFuzzyMatch = false;

  // Animation controllers
  late AnimationController _filtersAnimationController;
  late AnimationController _resultsAnimationController;

  @override
  void initState() {
    super.initState();
    _filtersAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _resultsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _loadSearchHistory();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _filtersAnimationController.dispose();
    _resultsAnimationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query != _currentQuery) {
      _currentQuery = query;

      if (query.isEmpty) {
        setState(() {
          _suggestions.clear();
          _searchResults.clear();
          _isSearching = false;
        });
      } else {
        _getSuggestions(query);
      }
    }
  }

  Future<void> _getSuggestions(String query) async {
    try {
      final searchService = ref.read(quranSearchServiceProvider);
      final suggestions = await searchService.getSearchSuggestions(query);

      if (mounted && query == _currentQuery) {
        setState(() {
          _suggestions = suggestions;
        });
      }
    } catch (e) {
      AppLogger.warning('QuranSearch', 'Failed to fetch suggestions', error: e);
    }
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
      _showHistory = false;
    });

    try {
      final searchService = ref.read(quranSearchServiceProvider);

      // Build search filters
      final filters = SearchFilters(
        chapterIds: _selectedChapterIds.isNotEmpty ? _selectedChapterIds : null,
        translationIds:
            _selectedTranslationIds.isNotEmpty ? _selectedTranslationIds : null,
        scope: _searchScope,
        enableTransliteration: _enableTransliteration,
        enableBengaliSearch: _enableBengaliSearch,
        enableFuzzyMatch: _enableFuzzyMatch,
      );

      // Build search options
      final options = SearchOptions(
        maxResults: 100,
        highlightMatches: true,
      );

      // Perform advanced search
      final results = await searchService.advancedSearch(
        query: query,
        filters: filters,
        options: options,
      );

      // Combine all results
      final allResults = <dynamic>[];
      allResults.addAll(results.verses);
      allResults.addAll(results.chapters);
      allResults.addAll(results.references);

      if (mounted) {
        setState(() {
          _searchResults = allResults;
          _isSearching = false;
        });

        _resultsAnimationController.forward(from: 0);
        await _saveToHistory(query);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSearching = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.hadithSearchError),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList('quran_search_history') ?? [];
      setState(() {
        _searchHistory = historyJson.take(10).toList(); // Keep last 10 searches
      });
    } catch (e) {
      AppLogger.warning('QuranSearch', 'Failed to load search history', error: e);
    }
  }

  Future<void> _saveToHistory(String query) async {
    try {
      if (_searchHistory.contains(query)) {
        _searchHistory.remove(query);
      }
      _searchHistory.insert(0, query);

      // Keep only last 10 searches
      if (_searchHistory.length > 10) {
        _searchHistory = _searchHistory.take(10).toList();
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('quran_search_history', _searchHistory);
    } catch (e) {
      AppLogger.warning('QuranSearch', 'Failed to save search history', error: e);
    }
  }

  Future<void> _clearHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('quran_search_history');
      setState(() {
        _searchHistory.clear();
      });
    } catch (e) {
      AppLogger.warning('QuranSearch', 'Failed to clear search history', error: e);
    }
  }

  void _toggleFilters() {
    setState(() {
      _showFilters = !_showFilters;
    });

    if (_showFilters) {
      _filtersAnimationController.forward();
    } else {
      _filtersAnimationController.reverse();
    }
  }

  void _onSuggestionTap(SearchSuggestion suggestion) {
    _searchController.text = suggestion.text;
    _currentQuery = suggestion.text;
    _performSearch();
  }

  void _onHistoryItemTap(String query) {
    _searchController.text = query;
    _currentQuery = query;
    setState(() {
      _showHistory = false;
    });
    _performSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getPrimaryColor(context),
        foregroundColor: Colors.white,
        title: const Text(
          'Advanced Search',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevation: 0,
        actions: [
          if (_searchHistory.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.history),
              onPressed: () {
                setState(() {
                  _showHistory = !_showHistory;
                  if (_showHistory) {
                    _showFilters = false;
                    _filtersAnimationController.reverse();
                  }
                });
              },
              tooltip: 'Search History',
            ),
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list : Icons.tune),
            onPressed: _toggleFilters,
            tooltip: 'Search Filters',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeHelper.getPrimaryColor(context),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: _buildSearchBar(),
          ),

          // Filters panel
          AnimatedBuilder(
            animation: _filtersAnimationController,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _filtersAnimationController,
                child: _showFilters
                    ? _buildFiltersPanel()
                    : const SizedBox.shrink(),
              );
            },
          ),

          // Main content
          Expanded(
            child: _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocus,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search Quran verses, chapters...',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.white),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _suggestions.clear();
                          _searchResults.clear();
                          _currentQuery = '';
                          _isSearching = false;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white.withOpacity(0.15),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onSubmitted: (_) => _performSearch(),
            textInputAction: TextInputAction.search,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: _isSearching
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.search, color: Colors.white),
            onPressed: _isSearching ? null : _performSearch,
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        border: Border(
          bottom: BorderSide(
            color: ThemeHelper.getDividerColor(context),
            width: 1,
          ),
        ),
      ),
      child: SearchFiltersWidget(
        onScopeChanged: (scope) {
          setState(() {
            _searchScope = scope;
          });
        },
        onChapterIdsChanged: (chapterIds) {
          setState(() {
            _selectedChapterIds = chapterIds;
          });
        },
        onTranslationIdsChanged: (translationIds) {
          setState(() {
            _selectedTranslationIds = translationIds;
          });
        },
        onDiacriticsChanged: (enabled) {
          setState(() {
            _enableDiacriticsSearch = enabled;
          });
        },
        onExactMatchChanged: (enabled) {
          setState(() {
            _exactMatch = enabled;
          });
        },
        onTransliterationChanged: (enabled) {
          setState(() {
            _enableTransliteration = enabled;
          });
        },
        onBengaliSearchChanged: (enabled) {
          setState(() {
            _enableBengaliSearch = enabled;
          });
        },
        onFuzzyMatchChanged: (enabled) {
          setState(() {
            _enableFuzzyMatch = enabled;
          });
        },
        searchScope: _searchScope,
        selectedChapterIds: _selectedChapterIds,
        selectedTranslationIds: _selectedTranslationIds,
        enableDiacriticsSearch: _enableDiacriticsSearch,
        exactMatch: _exactMatch,
        enableTransliteration: _enableTransliteration,
        enableBengaliSearch: _enableBengaliSearch,
        enableFuzzyMatch: _enableFuzzyMatch,
      ),
    );
  }

  Widget _buildMainContent() {
    if (_showHistory && _searchHistory.isNotEmpty) {
      return SearchHistoryWidget(
        onHistoryItemTap: _onHistoryItemTap,
        onClearHistory: _clearHistory,
        history: _searchHistory,
      );
    }

    if (_currentQuery.isNotEmpty &&
        _suggestions.isNotEmpty &&
        _searchResults.isEmpty) {
      return _buildSuggestions();
    }

    if (_searchResults.isNotEmpty) {
      return _buildSearchResults();
    }

    return _buildEmptyState();
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = _suggestions[index];
        return ListTile(
          leading: Icon(
            _getSuggestionIcon(suggestion.type),
            color: ThemeHelper.getPrimaryColor(context),
          ),
          title: Text(
            suggestion.text,
            style: TextStyle(
              color: ThemeHelper.getTextPrimaryColor(context),
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            _getSuggestionTypeLabel(suggestion.type),
            style: TextStyle(
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          onTap: () => _onSuggestionTap(suggestion),
        );
      },
    );
  }

  Widget _buildSearchResults() {
    return AnimatedBuilder(
      animation: _resultsAnimationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _resultsAnimationController,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: _resultsAnimationController,
              curve: Curves.easeOut,
            )),
            child: Column(
              children: [
                // Results count
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ThemeHelper.getCardColor(context),
                    border: Border(
                      bottom: BorderSide(
                        color: ThemeHelper.getDividerColor(context),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Text(
                    '${_searchResults.length} results found for "${_currentQuery}"',
                    style: TextStyle(
                      color: ThemeHelper.getTextSecondaryColor(context),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Results list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final result = _searchResults[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SearchResultCard(
                          query: _currentQuery,
                          result: result,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 64,
            color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Advanced Quran Search',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: ThemeHelper.getTextPrimaryColor(context),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search across verses, translations, and chapters\nwith powerful filters and suggestions',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 24),
          _buildQuickSearchTips(),
        ],
      ),
    );
  }

  Widget _buildQuickSearchTips() {
    final tips = [
      {'icon': Icons.book, 'text': 'Search verse content'},
      {'icon': Icons.translate, 'text': 'Search translations'},
      {'icon': Icons.numbers, 'text': 'Verse references (2:255)'},
      {'icon': Icons.category, 'text': 'Chapter names'},
    ];

    return Column(
      children: tips
          .map((tip) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tip['icon'] as IconData,
                      size: 16,
                      color: ThemeHelper.getPrimaryColor(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tip['text'] as String,
                      style: TextStyle(
                        color: ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  IconData _getSuggestionIcon(SuggestionType type) {
    switch (type) {
      case SuggestionType.chapter:
        return Icons.book;
      case SuggestionType.verse:
        return Icons.format_quote;
      case SuggestionType.topic:
        return Icons.topic;
      case SuggestionType.reference:
        return Icons.link;
    }
  }

  String _getSuggestionTypeLabel(SuggestionType type) {
    switch (type) {
      case SuggestionType.chapter:
        return 'Chapter';
      case SuggestionType.verse:
        return 'Verse';
      case SuggestionType.topic:
        return 'Topic';
      case SuggestionType.reference:
        return 'Reference';
    }
  }
}

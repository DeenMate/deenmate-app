import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../data/datasources/hadith_mock_data.dart';
import '../../domain/entities/hadith_entity.dart';
import '../../domain/entities/hadith_book.dart';
import 'hadith_detail_screen.dart';

/// Hadith Search Screen - Allows users to search through hadiths
class HadithSearchScreen extends StatefulWidget {
  final String? initialQuery;
  final String? topicId;
  
  const HadithSearchScreen({
    super.key,
    this.initialQuery,
    this.topicId,
  });

  @override
  State<HadithSearchScreen> createState() => _HadithSearchScreenState();
}

class _HadithSearchScreenState extends State<HadithSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  List<HadithEntity> _searchResults = [];
  List<HadithBook> _allBooks = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  
  String _selectedBookFilter = 'all';
  String _selectedGradeFilter = 'all';
  bool _searchInArabic = true;
  bool _searchInTranslation = true;

  @override
  void initState() {
    super.initState();
    _allBooks = HadithMockData.getHadithBooks();
    
    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch();
      });
    } else if (widget.topicId != null) {
      // Handle topic-based search - search for hadiths related to the topic
      _searchController.text = _getTopicSearchQuery(widget.topicId!);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _performSearch();
      });
    } else {
      // Focus on search field when screen opens
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }
  
  String _getTopicSearchQuery(String topicId) {
    // Map topic IDs to search queries
    switch (topicId) {
      case 'prayer':
        return 'নামাজ';
      case 'charity':
        return 'দান';
      case 'faith':
        return 'ঈমান';
      case 'fasting':
        return 'রোজা';
      case 'hajj':
        return 'হজ';
      case 'ethics':
        return 'নৈতিকতা';
      default:
        return '';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: colorScheme.onSurface,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.hadithSearchTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune_rounded, color: colorScheme.outline),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          _buildSearchSection(context),
          
          // Results Section
          Expanded(
            child: _buildResultsSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
          ),
        ),
      ),
      child: Column(
        children: [
          // Search Bar
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: l10n.hadithSearchDetailedHint,
                hintStyle: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.outline,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: colorScheme.primary,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear_rounded,
                        color: colorScheme.outline,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchResults.clear();
                          _hasSearched = false;
                        });
                      },
                    )
                  : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
              onSubmitted: (_) => _performSearch(),
              onChanged: (value) => setState(() {}),
            ),
          ),
          const SizedBox(height: 16),
          
          // Search Button and Quick Filters
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _performSearch,
                  icon: _isLoading 
                    ? SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.onPrimary,
                        ),
                      )
                    : const Icon(Icons.search_rounded),
                  label: Text(_isLoading ? l10n.hadithSearchingProgress : l10n.hadithSearchButton),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: _showFilterDialog,
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: colorScheme.primary),
                ),
                child: const Icon(Icons.tune_rounded),
              ),
            ],
          ),
          
          // Active Filters Display
          if (_hasActiveFilters()) ...[
            const SizedBox(height: 12),
            _buildActiveFilters(context),
          ],
        ],
      ),
    );
  }

  Widget _buildResultsSection(BuildContext context) {
    if (!_hasSearched) {
      return _buildSearchSuggestions(context);
    }
    
    if (_isLoading) {
      return _buildLoadingState(context);
    }
    
    if (_searchResults.isEmpty) {
      return _buildEmptyResults(context);
    }
    
    return _buildSearchResults(context);
  }

  Widget _buildSearchSuggestions(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;
    
    final suggestions = [
      'নিয়ত', 'আমল', 'সালাত', 'জান্নাত', 'জাহান্নাম',
      'দোয়া', 'তওবা', 'ধৈর্য', 'কৃতজ্ঞতা', 'মা-বাবা'
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.hadithPopularSearches,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  _searchController.text = suggestion;
                  _performSearch();
                },
                backgroundColor: colorScheme.surfaceVariant,
                labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
              );
            }).toList(),
          ),
          
          const SizedBox(height: 32),
          
          Text(
            l10n.hadithRecentSearches,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // Recent searches would go here
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.hadithNoRecentSearches,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            l10n.hadithSearchLoadingMessage,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyResults(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.search_off_rounded,
                color: colorScheme.outline,
                size: 40,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.hadithNoResultsFound,
              style: theme.textTheme.titleLarge?.copyWith(
                color: colorScheme.onBackground,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.hadithNoResultsFoundDetails(_searchController.text),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onBackground.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchResults.clear();
                      _hasSearched = false;
                    });
                  },
                  child: Text(l10n.hadithTryDifferentSearch),
                ),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: _showFilterDialog,
                  child: Text(l10n.hadithChangeFilter),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Results Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: colorScheme.surfaceVariant.withOpacity(0.3),
          child: Row(
            children: [
              Text(
                l10n.hadithResultsFound(_searchResults.length),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Text(
                l10n.hadithSearchContextFor(_searchController.text),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        
        // Results List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final hadith = _searchResults[index];
              return _buildHadithResultItem(context, hadith, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHadithResultItem(BuildContext context, HadithEntity hadith, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final gradeColor = Color(int.parse(hadith.gradeColor.replaceFirst('#', '0xFF')));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToHadithDetail(hadith),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        hadith.bookShortName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hadith.referenceBengali,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: gradeColor,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        hadith.gradeBengali,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Hadith Text Preview
                Text(
                  hadith.bengaliText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                    height: 1.5,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                if (hadith.topicsBengali.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: hadith.topicsBengali.take(3).map((topic) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: colorScheme.secondaryContainer.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          topic,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSecondaryContainer,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveFilters(BuildContext context) {
    return Container(
      height: 32,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          if (_selectedBookFilter != 'all')
            _buildFilterChip(
              context,
              'বই: ${_getBookName(_selectedBookFilter)}',
              () => setState(() => _selectedBookFilter = 'all'),
            ),
          if (_selectedGradeFilter != 'all')
            _buildFilterChip(
              context,
              'গ্রেড: $_selectedGradeFilter',
              () => setState(() => _selectedGradeFilter = 'all'),
            ),
          if (!_searchInArabic || !_searchInTranslation)
            _buildFilterChip(
              context,
              _searchInArabic ? 'শুধু আরবি' : 'শুধু অনুবাদ',
              () => setState(() {
                _searchInArabic = true;
                _searchInTranslation = true;
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, VoidCallback onRemove) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(label),
        deleteIcon: Icon(Icons.close, size: 16),
        onDeleted: onRemove,
        backgroundColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: colorScheme.onPrimaryContainer,
          fontSize: 12,
        ),
        deleteIconColor: colorScheme.onPrimaryContainer,
      ),
    );
  }

  bool _hasActiveFilters() {
    return _selectedBookFilter != 'all' ||
           _selectedGradeFilter != 'all' ||
           !_searchInArabic ||
           !_searchInTranslation;
  }

  String _getBookName(String bookId) {
    final book = _allBooks.firstWhere(
      (book) => book.id == bookId,
      orElse: () => _allBooks.first,
    );
    return book.nameBengali;
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final results = HadithMockData.searchHadiths(query);
      
      // Apply filters
      final filteredResults = results.where((hadith) {
        if (_selectedBookFilter != 'all' && hadith.bookId != _selectedBookFilter) {
          return false;
        }
        if (_selectedGradeFilter != 'all' && hadith.gradeBengali != _selectedGradeFilter) {
          return false;
        }
        return true;
      }).toList();

      setState(() {
        _searchResults = filteredResults;
        _isLoading = false;
      });
    });
  }

  void _navigateToHadithDetail(HadithEntity hadith) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HadithDetailScreen(hadith: hadith),
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterDialog(),
    );
  }

  Widget _buildFilterDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return StatefulBuilder(
      builder: (context, setDialogState) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: colorScheme.outline.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'খোঁজার ফিল্টার',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        setDialogState(() {
                          _selectedBookFilter = 'all';
                          _selectedGradeFilter = 'all';
                          _searchInArabic = true;
                          _searchInTranslation = true;
                        });
                      },
                      child: const Text('রিসেট'),
                    ),
                  ],
                ),
              ),
              
              // Filter Options
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Book Filter
                      Text(
                        'হাদিসের বই',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterOption(
                            context,
                            'সব বই',
                            _selectedBookFilter == 'all',
                            () => setDialogState(() => _selectedBookFilter = 'all'),
                          ),
                          ..._allBooks.map((book) => _buildFilterOption(
                            context,
                            book.nameBengali,
                            _selectedBookFilter == book.id,
                            () => setDialogState(() => _selectedBookFilter = book.id),
                          )),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Grade Filter
                      Text(
                        'হাদিসের গ্রেড',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildFilterOption(
                            context,
                            'সব গ্রেড',
                            _selectedGradeFilter == 'all',
                            () => setDialogState(() => _selectedGradeFilter = 'all'),
                          ),
                          _buildFilterOption(
                            context,
                            'সহিহ',
                            _selectedGradeFilter == 'সহিহ',
                            () => setDialogState(() => _selectedGradeFilter = 'সহিহ'),
                          ),
                          _buildFilterOption(
                            context,
                            'হাসান',
                            _selectedGradeFilter == 'হাসান',
                            () => setDialogState(() => _selectedGradeFilter = 'হাসান'),
                          ),
                          _buildFilterOption(
                            context,
                            'দাইফ',
                            _selectedGradeFilter == 'দাইফ',
                            () => setDialogState(() => _selectedGradeFilter = 'দাইফ'),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Search Scope
                      Text(
                        'খোঁজার পরিসর',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      CheckboxListTile(
                        title: const Text('আরবি টেক্সটে খুঁজুন'),
                        value: _searchInArabic,
                        onChanged: (value) {
                          setDialogState(() => _searchInArabic = value ?? true);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      CheckboxListTile(
                        title: const Text('অনুবাদে খুঁজুন'),
                        value: _searchInTranslation,
                        onChanged: (value) {
                          setDialogState(() => _searchInTranslation = value ?? true);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Apply Button
              Container(
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Update main state
                      Navigator.of(context).pop();
                      if (_hasSearched) {
                        _performSearch(); // Re-search with new filters
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'ফিল্টার প্রয়োগ করুন',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterOption(
    BuildContext context,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: colorScheme.primaryContainer,
      backgroundColor: colorScheme.surface,
      labelStyle: TextStyle(
        color: isSelected 
          ? colorScheme.onPrimaryContainer
          : colorScheme.onSurface,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
      side: BorderSide(
        color: isSelected 
          ? colorScheme.primary
          : colorScheme.outline.withOpacity(0.3),
      ),
    );
  }
}

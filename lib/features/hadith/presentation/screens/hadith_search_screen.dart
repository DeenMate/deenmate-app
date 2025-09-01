import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/hadith_provider.dart';
import '../../domain/entities/hadith_simple.dart';

/// Hadith Search Screen
/// Bengali-first approach with advanced filtering
class HadithSearchScreen extends ConsumerStatefulWidget {
  const HadithSearchScreen({super.key});

  @override
  ConsumerState<HadithSearchScreen> createState() => _HadithSearchScreenState();
}

class _HadithSearchScreenState extends ConsumerState<HadithSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  
  String _currentQuery = '';
  String? _selectedCollection;
  String? _selectedGrade;
  List<String> _selectedTopics = [];
  
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query != _currentQuery) {
      _currentQuery = query;
      if (query.isNotEmpty) {
        _performSearch();
      } else {
        ref.read(hadithSearchStateProvider.notifier).clearSearch();
      }
    }
  }

  void _performSearch() {
    if (_currentQuery.isNotEmpty) {
      ref.read(hadithSearchStateProvider.notifier).search(
        _currentQuery,
        collection: _selectedCollection,
        grade: _selectedGrade,
        topics: _selectedTopics.isNotEmpty ? _selectedTopics : null,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(hadithSearchStateProvider);
    final topicsAsync = ref.watch(hadithTopicsProvider);
    final gradesAsync = ref.watch(hadithGradesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'হাদীস অনুসন্ধান',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(_showFilters ? Icons.filter_list : Icons.filter_list_outlined),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                hintText: 'হাদীস অনুসন্ধান করুন...',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _currentQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(hadithSearchStateProvider.notifier).clearSearch();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _performSearch(),
            ),
          ),

          // Filters Section
          if (_showFilters) _buildFiltersSection(topicsAsync, gradesAsync),

          // Search Results
          Expanded(
            child: searchState.when(
              data: (searchResult) {
                if (searchResult.query.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildSearchResults(searchResult);
              },
              loading: () => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'অনুসন্ধান করা হচ্ছে...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              error: (error, stack) => _buildErrorState(error.toString()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltersSection(AsyncValue<List<String>> topicsAsync, AsyncValue<List<String>> gradesAsync) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ফিল্টার',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Collection Filter
          _buildDropdownFilter(
            label: 'সংকলন',
            value: _selectedCollection,
            items: const ['bukhari', 'muslim', 'abudawud', 'tirmidhi'],
            onChanged: (value) {
              setState(() {
                _selectedCollection = value;
              });
              _performSearch();
            },
          ),

          const SizedBox(height: 12),

          // Grade Filter
          gradesAsync.when(
            data: (grades) => _buildDropdownFilter(
              label: 'গ্রেড',
              value: _selectedGrade,
              items: grades,
              onChanged: (value) {
                setState(() {
                  _selectedGrade = value;
                });
                _performSearch();
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 12),

          // Topics Filter
          topicsAsync.when(
            data: (topics) => _buildTopicsFilter(topics),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('সব'),
            ),
            ...items.map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            )),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildTopicsFilter(List<String> topics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'বিষয়',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: topics.take(10).map((topic) {
            final isSelected = _selectedTopics.contains(topic);
            return FilterChip(
              label: Text(topic),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedTopics.add(topic);
                  } else {
                    _selectedTopics.remove(topic);
                  }
                });
                _performSearch();
              },
            );
          }).toList(),
        ),
      ],
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
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'হাদীস অনুসন্ধান করুন',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'কীওয়ার্ড, বিষয়, বা গ্রেড দিয়ে অনুসন্ধান করুন',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(HadithSearchResult searchResult) {
    if (searchResult.hadiths.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'কোন ফলাফল পাওয়া যায়নি',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '"${searchResult.query}" এর জন্য কোন হাদীস পাওয়া যায়নি',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Search Results Header
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Text(
                '${searchResult.totalResults} টি ফলাফল পাওয়া গেছে',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              if (searchResult.filters.isNotEmpty)
                Text(
                  'ফিল্টার: ${searchResult.filters.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ),

        // Results List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: searchResult.hadiths.length,
            itemBuilder: (context, index) {
              final hadith = searchResult.hadiths[index];
              return _buildHadithCard(hadith);
            },
          ),
        ),

        // Pagination
        if (searchResult.totalPages > 1)
          _buildPagination(searchResult),
      ],
    );
  }

  Widget _buildHadithCard(Hadith hadith) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to hadith details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hadith Text
              Text(
                hadith.bengaliText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Arabic Text
              if (hadith.arabicText.isNotEmpty) ...[
                Text(
                  hadith.arabicText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Amiri',
                    height: 1.5,
                  ),
                  textDirection: TextDirection.rtl,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
              ],

              // Metadata
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${hadith.collection} - ${hadith.hadithNumber}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (hadith.narrator.isNotEmpty)
                          Text(
                            'বর্ণনাকারী: ${hadith.narratorBengali}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (hadith.grade.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getGradeColor(hadith.grade),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            hadith.gradeBengali,
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      if (hadith.isBookmarked)
                        const Icon(
                          Icons.bookmark,
                          color: Colors.amber,
                          size: 20,
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPagination(HadithSearchResult searchResult) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (searchResult.currentPage > 1)
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                // TODO: Load previous page
              },
            ),
          Text(
            'পৃষ্ঠা ${searchResult.currentPage} / ${searchResult.totalPages}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (searchResult.currentPage < searchResult.totalPages)
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                // TODO: Load next page
              },
            ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: 16),
          Text(
            'অনুসন্ধানে সমস্যা হয়েছে',
            style: TextStyle(
              fontSize: 18,
              color: Colors.red[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _performSearch,
            child: const Text('আবার চেষ্টা করুন'),
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'sahih':
        return Colors.green;
      case 'hasan':
        return Colors.blue;
      case 'daif':
        return Colors.orange;
      case 'mawdu':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

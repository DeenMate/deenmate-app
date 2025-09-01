import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/hadith_provider.dart';
import '../../domain/entities/hadith_simple.dart';

/// Simple Hadith Search Screen
/// Bengali-first approach with basic search functionality
class HadithSearchScreen extends ConsumerStatefulWidget {
  const HadithSearchScreen({super.key});

  @override
  ConsumerState<HadithSearchScreen> createState() => _HadithSearchScreenState();
}

class _HadithSearchScreenState extends ConsumerState<HadithSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    if (query != _currentQuery) {
      _currentQuery = query;
      if (query.isNotEmpty) {
        _performSearch();
      } else {
        // Clear search by loading empty state
        ref.read(hadithNotifierProvider.notifier).searchHadiths('');
      }
    }
  }

  void _performSearch() {
    if (_currentQuery.isNotEmpty) {
      ref.read(hadithNotifierProvider.notifier).searchHadiths(_currentQuery);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final searchState = ref.watch(hadithNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.hadithSearchTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
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
                          ref
                              .read(hadithNotifierProvider.notifier)
                              .searchHadiths('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _performSearch(),
            ),
          ),

          // Search Results
          Expanded(
            child: searchState.when(
              data: (hadiths) {
                if (_currentQuery.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildSearchResults(hadiths);
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
            'কীওয়ার্ড দিয়ে অনুসন্ধান করুন',
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

  Widget _buildSearchResults(List<Hadith> hadiths) {
    if (hadiths.isEmpty) {
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
              '"$_currentQuery" এর জন্য কোন হাদীস পাওয়া যায়নি',
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
                '${hadiths.length} টি ফলাফল পাওয়া গেছে',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // Results List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: hadiths.length,
            itemBuilder: (context, index) {
              final hadith = hadiths[index];
              return _buildHadithCard(hadith);
            },
          ),
        ),
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

              // Metadata
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${hadith.collection} - ${hadith.hadithNumber}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
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
        ),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../providers/hadith_provider.dart';
import '../../domain/entities/hadith_simple.dart';

/// Hadith Home Screen
/// Bengali-first approach with Islamic terminology
class HadithHomeScreen extends ConsumerWidget {
  const HadithHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final collectionsAsync = ref.watch(hadithCollectionsProvider);
    final popularHadithsAsync = ref.watch(popularHadithsProvider);
    final recentlyReadAsync = ref.watch(recentlyReadHadithsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.hadithTitle,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Navigate to search screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () {
              // TODO: Navigate to bookmarks screen
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(hadithCollectionsProvider);
          ref.invalidate(popularHadithsProvider);
          ref.invalidate(recentlyReadHadithsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Collections Section
              _buildSectionHeader(l10n.hadithCollections, 'Hadith Collections'),
              const SizedBox(height: 12),
              _buildCollectionsSection(collectionsAsync),

              const SizedBox(height: 32),

              // Popular Hadiths Section
              _buildSectionHeader(l10n.hadithPopular, 'Popular Hadiths'),
              const SizedBox(height: 12),
              _buildPopularHadithsSection(popularHadithsAsync),

              const SizedBox(height: 32),

              // Recently Read Section
              _buildSectionHeader(l10n.hadithRecentlyRead, 'Recently Read'),
              const SizedBox(height: 12),
              _buildRecentlyReadSection(recentlyReadAsync),

              const SizedBox(height: 32),

              // Quick Actions
              _buildSectionHeader(l10n.hadithQuickActions, 'Quick Actions'),
              const SizedBox(height: 12),
              _buildQuickActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String bengaliTitle, String englishTitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bengaliTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          englishTitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildCollectionsSection(
      AsyncValue<List<HadithCollection>> collectionsAsync) {
    return collectionsAsync.when(
      data: (collections) {
        if (collections.isEmpty) {
          return _buildEmptyState(
              'কোন হাদীস সংকলন পাওয়া যায়নি', 'No Hadith collections found');
        }

        return SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: collections.length,
            itemBuilder: (context, index) {
              final collection = collections[index];
              return _buildCollectionCard(collection);
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(
          'সংকলন লোড করতে সমস্যা', 'Error loading collections'),
    );
  }

  Widget _buildCollectionCard(HadithCollection collection) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      child: Card(
        elevation: 2,
        child: InkWell(
          onTap: () {
            // TODO: Navigate to collection details
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection.nameBengali,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  collection.authorBengali,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${collection.totalHadiths} হাদীস',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularHadithsSection(
      AsyncValue<List<Hadith>> popularHadithsAsync) {
    return popularHadithsAsync.when(
      data: (hadiths) {
        if (hadiths.isEmpty) {
          return _buildEmptyState(
              'কোন জনপ্রিয় হাদীস নেই', 'No popular hadiths');
        }

        return Column(
          children: hadiths
              .take(5)
              .map((hadith) => _buildHadithCard(hadith))
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(
          'জনপ্রিয় হাদীস লোড করতে সমস্যা', 'Error loading popular hadiths'),
    );
  }

  Widget _buildRecentlyReadSection(AsyncValue<List<Hadith>> recentlyReadAsync) {
    return recentlyReadAsync.when(
      data: (hadiths) {
        if (hadiths.isEmpty) {
          return _buildEmptyState(
              'কোন সাম্প্রতিক পড়া নেই', 'No recently read hadiths');
        }

        return Column(
          children: hadiths
              .take(3)
              .map((hadith) => _buildHadithCard(hadith))
              .toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => _buildErrorState(
          'সাম্প্রতিক পড়া লোড করতে সমস্যা', 'Error loading recently read'),
    );
  }

  Widget _buildHadithCard(Hadith hadith) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to hadith details
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      hadith.bengaliText,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    '${hadith.collection} - ${hadith.hadithNumber}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'পঠিত: ${hadith.readCount}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.search,
            title: 'অনুসন্ধান',
            subtitle: 'Search',
            onTap: () {
              // TODO: Navigate to search
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.topic,
            title: 'বিষয়',
            subtitle: 'Topics',
            onTap: () {
              // TODO: Navigate to topics
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.bookmark,
            title: 'বুকমার্ক',
            subtitle: 'Bookmarks',
            onTap: () {
              // TODO: Navigate to bookmarks
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Colors.blue,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String bengaliMessage, String englishMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.inbox_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              bengaliMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              englishMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String bengaliMessage, String englishMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              bengaliMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.red[600],
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              englishMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.red[500],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

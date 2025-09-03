import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/services/search_service.dart';
import '../state/providers.dart';
import '../../../../core/theme/theme_helper.dart';

/// Widget for advanced search filters
/// Provides filtering options for search scope, chapters, translations, and search options
class SearchFiltersWidget extends ConsumerWidget {
  const SearchFiltersWidget({
    super.key,
    required this.onScopeChanged,
    required this.onChapterIdsChanged,
    required this.onTranslationIdsChanged,
    required this.onDiacriticsChanged,
    required this.onExactMatchChanged,
    required this.searchScope,
    required this.selectedChapterIds,
    required this.selectedTranslationIds,
    required this.enableDiacriticsSearch,
    required this.exactMatch,
  });

  final SearchScope searchScope;
  final List<int> selectedChapterIds;
  final List<int> selectedTranslationIds;
  final bool enableDiacriticsSearch;
  final bool exactMatch;
  final ValueChanged<SearchScope> onScopeChanged;
  final ValueChanged<List<int>> onChapterIdsChanged;
  final ValueChanged<List<int>> onTranslationIdsChanged;
  final ValueChanged<bool> onDiacriticsChanged;
  final ValueChanged<bool> onExactMatchChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search scope
        _buildSectionTitle('Search Scope'),
        const SizedBox(height: 8),
        _buildSearchScopeSelector(context),

        const SizedBox(height: 16),

        // Search options
        _buildSectionTitle('Search Options'),
        const SizedBox(height: 8),
        _buildSearchOptions(context),

        const SizedBox(height: 16),

        // Filters
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Chapters'),
                  const SizedBox(height: 8),
                  _buildChapterFilter(context, ref),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Translations'),
                  const SizedBox(height: 8),
                  _buildTranslationFilter(context, ref),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Reset button
        Center(
          child: OutlinedButton.icon(
            onPressed: () => _resetFilters(),
            icon: const Icon(Icons.clear_all),
            label: Text(AppLocalizations.of(context)!.quranResetFilters),
            style: OutlinedButton.styleFrom(
              foregroundColor: ThemeHelper.getPrimaryColor(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSearchScopeSelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.getDividerColor(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: SearchScope.values.map((scope) {
          final isSelected = searchScope == scope;
          return Expanded(
            child: GestureDetector(
              onTap: () => onScopeChanged(scope),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ThemeHelper.getPrimaryColor(context)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getScopeLabel(scope),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : ThemeHelper.getTextPrimaryColor(context),
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSearchOptions(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: enableDiacriticsSearch,
              onChanged: (value) => onDiacriticsChanged(value ?? false),
              activeColor: ThemeHelper.getPrimaryColor(context),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Include diacritics in search',
                style: TextStyle(
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: exactMatch,
              onChanged: (value) => onExactMatchChanged(value ?? false),
              activeColor: ThemeHelper.getPrimaryColor(context),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Exact word match',
                style: TextStyle(
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChapterFilter(BuildContext context, WidgetRef ref) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.getDividerColor(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final chaptersAsync = ref.watch(surahListProvider);

          return chaptersAsync.when(
            data: (chapters) {
              return Column(
                children: [
                  // Header with select all/none
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ThemeHelper.getCardColor(context),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(7)),
                      border: Border(
                        bottom: BorderSide(
                          color: ThemeHelper.getDividerColor(context),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${selectedChapterIds.length} selected',
                          style: TextStyle(
                            fontSize: 12,
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            if (selectedChapterIds.length == chapters.length) {
                              onChapterIdsChanged([]);
                            } else {
                              onChapterIdsChanged(
                                  chapters.map((c) => c.id).toList());
                            }
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ),
                          child: Text(
                            selectedChapterIds.length == chapters.length
                                ? 'None'
                                : 'All',
                            style: TextStyle(
                              fontSize: 12,
                              color: ThemeHelper.getPrimaryColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chapters list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: chapters.length,
                      itemBuilder: (context, index) {
                        final chapter = chapters[index];
                        final isSelected =
                            selectedChapterIds.contains(chapter.id);

                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) {
                            final newIds = List<int>.from(selectedChapterIds);
                            if (value == true) {
                              newIds.add(chapter.id);
                            } else {
                              newIds.remove(chapter.id);
                            }
                            onChapterIdsChanged(newIds);
                          },
                          title: Text(
                            '${chapter.id}. ${chapter.nameSimple}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          activeColor: ThemeHelper.getPrimaryColor(context),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) =>
                Center(child: Text(AppLocalizations.of(context)!.quranErrorLoadingChapters)),
          );
        },
      ),
    );
  }

  Widget _buildTranslationFilter(BuildContext context, WidgetRef ref) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: ThemeHelper.getDividerColor(context)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Consumer(
        builder: (context, ref, child) {
          final translationsAsync = ref.watch(translationResourcesProvider);

          return translationsAsync.when(
            data: (translations) {
              return Column(
                children: [
                  // Header with select all/none
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: ThemeHelper.getCardColor(context),
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(7)),
                      border: Border(
                        bottom: BorderSide(
                          color: ThemeHelper.getDividerColor(context),
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${selectedTranslationIds.length} selected',
                          style: TextStyle(
                            fontSize: 12,
                            color: ThemeHelper.getTextSecondaryColor(context),
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            if (selectedTranslationIds.length ==
                                translations.length) {
                              onTranslationIdsChanged([]);
                            } else {
                              onTranslationIdsChanged(
                                  translations.map((t) => t.id).toList());
                            }
                          },
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                          ),
                          child: Text(
                            selectedTranslationIds.length == translations.length
                                ? 'None'
                                : 'All',
                            style: TextStyle(
                              fontSize: 12,
                              color: ThemeHelper.getPrimaryColor(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Translations list
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: translations.length,
                      itemBuilder: (context, index) {
                        final translation = translations[index];
                        final isSelected =
                            selectedTranslationIds.contains(translation.id);

                        return CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) {
                            final newIds =
                                List<int>.from(selectedTranslationIds);
                            if (value == true) {
                              newIds.add(translation.id);
                            } else {
                              newIds.remove(translation.id);
                            }
                            onTranslationIdsChanged(newIds);
                          },
                          title: Text(
                            translation.name ?? 'Unknown Translation',
                            style: const TextStyle(fontSize: 13),
                          ),
                          subtitle: Text(
                            'by ${translation.authorName ?? 'Unknown'}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 4),
                          activeColor: ThemeHelper.getPrimaryColor(context),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) =>
                Center(child: Text(AppLocalizations.of(context)!.quranErrorLoadingTranslations)),
          );
        },
      ),
    );
  }

  String _getScopeLabel(SearchScope scope) {
    switch (scope) {
      case SearchScope.all:
        return 'All';
      case SearchScope.arabic:
        return 'Arabic';
      case SearchScope.translation:
        return 'Translation';
    }
  }

  void _resetFilters() {
    onScopeChanged(SearchScope.all);
    onChapterIdsChanged([]);
    onTranslationIdsChanged([]);
    onDiacriticsChanged(false);
    onExactMatchChanged(false);
  }
}

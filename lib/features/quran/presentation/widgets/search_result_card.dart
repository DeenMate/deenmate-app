import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/services/search_service.dart';
import '../../../../core/theme/theme_helper.dart';

/// Widget for displaying individual search results
/// Supports verse results, chapter results, and reference results
class SearchResultCard extends ConsumerWidget {
  const SearchResultCard({
    super.key,
    required this.query,
    required this.result,
  });

  final BaseSearchResult result;
  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      elevation: 2,
      color: ThemeHelper.getCardColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleTap(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (result is SearchResult) {
      return _buildVerseResult(context, result as SearchResult);
    } else if (result is ChapterSearchResult) {
      return _buildChapterResult(context, result as ChapterSearchResult);
    } else if (result is VerseReferenceResult) {
      return _buildReferenceResult(context, result as VerseReferenceResult);
    }
    
    return const SizedBox.shrink();
  }

  Widget _buildVerseResult(BuildContext context, SearchResult result) {
    final verse = result.verse;
    final chapterId = int.parse(verse.verseKey.split(':')[0]);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with chapter and verse info
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                verse.verseKey,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Chapter $chapterId',
                style: TextStyle(
                  color: ThemeHelper.getTextSecondaryColor(context),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Relevance score
            if (result.relevanceScore > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${(result.relevanceScore * 100).round()}%',
                  style: TextStyle(
                    color: ThemeHelper.getTextSecondaryColor(context),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Arabic text
        if (verse.textUthmani.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeHelper.getBackgroundColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ThemeHelper.getDividerColor(context),
                width: 1,
              ),
            ),
            child: Text(
              verse.textUthmani,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Uthmani',
                color: ThemeHelper.getTextPrimaryColor(context),
                height: 1.8,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        
        // Translation text (if available)
        if (verse.translations.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...verse.translations.take(2).map((translation) => Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ThemeHelper.getDividerColor(context).withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _highlightText(translation.text, query),
                    style: TextStyle(
                      fontSize: 15,
                      color: ThemeHelper.getTextPrimaryColor(context),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Translation ID: ${translation.resourceId}',
                    style: TextStyle(
                      fontSize: 12,
                      color: ThemeHelper.getTextSecondaryColor(context),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          )),
        ],
        
        // Matched text info
        if (result.matchedText.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Matched: ${result.matchedText}',
              style: TextStyle(
                fontSize: 11,
                color: ThemeHelper.getPrimaryColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChapterResult(BuildContext context, ChapterSearchResult result) {
    final chapter = result.chapter;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.book,
              color: ThemeHelper.getPrimaryColor(context),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Chapter',
              style: TextStyle(
                color: ThemeHelper.getTextSecondaryColor(context),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            // Relevance score
            if (result.relevanceScore > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ThemeHelper.getTextSecondaryColor(context).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${result.relevanceScore}%',
                  style: TextStyle(
                    color: ThemeHelper.getTextSecondaryColor(context),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Chapter info
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${chapter.id}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _highlightText(chapter.nameSimple, query),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: ThemeHelper.getTextPrimaryColor(context),
                    ),
                  ),
                  if (chapter.nameArabic.isNotEmpty)
                    Text(
                      chapter.nameArabic,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Uthmani',
                        color: ThemeHelper.getTextSecondaryColor(context),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                ],
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 8),
        
        // Chapter details
        Row(
          children: [
            _buildChapterDetail(
              context,
              Icons.format_list_numbered,
              '${chapter.versesCount} verses',
            ),
            const SizedBox(width: 16),
            _buildChapterDetail(
              context,
              Icons.location_on,
              chapter.revelationPlace,
            ),
          ],
        ),
        
        // Matched fields
        if (result.matchedFields.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: result.matchedFields.map((field) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                field,
                style: TextStyle(
                  fontSize: 11,
                  color: ThemeHelper.getPrimaryColor(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            )).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildReferenceResult(BuildContext context, VerseReferenceResult result) {
    final verse = result.verse;
    final reference = result.reference;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          children: [
            Icon(
              Icons.link,
              color: ThemeHelper.getPrimaryColor(context),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Verse Reference',
              style: TextStyle(
                color: ThemeHelper.getTextSecondaryColor(context),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: ThemeHelper.getPrimaryColor(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${reference.chapterId}:${reference.verseNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Verse content (shortened)
        if (verse.textUthmani.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeHelper.getBackgroundColor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ThemeHelper.getDividerColor(context),
                width: 1,
              ),
            ),
            child: Text(
              verse.textUthmani.length > 150 
                  ? '${verse.textUthmani.substring(0, 150)}...'
                  : verse.textUthmani,
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Uthmani',
                color: ThemeHelper.getTextPrimaryColor(context),
                height: 1.6,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
          ),
        
        // Match type
        if (result.matchType.isNotEmpty) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Matched: ${result.matchType}',
              style: TextStyle(
                fontSize: 11,
                color: ThemeHelper.getPrimaryColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildChapterDetail(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: ThemeHelper.getTextSecondaryColor(context),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
      ],
    );
  }

  String _highlightText(String text, String query) {
    // Simple highlighting - in a real app, you'd want to use a more sophisticated approach
    // For now, just return the original text as highlighting with RichText would be complex
    return text;
  }

  void _handleTap(BuildContext context) {
    if (result is SearchResult) {
      final verseResult = result as SearchResult;
      // Extract chapter ID from verse key (e.g., "2:255" -> 2)
      final chapterId = int.parse(verseResult.verse.verseKey.split(':')[0]);
      // Navigate to the verse in the reader
      context.push('/quran/chapter/$chapterId', extra: {
        'scrollToVerse': verseResult.verse.verseNumber,
      });
    } else if (result is ChapterSearchResult) {
      final chapterResult = result as ChapterSearchResult;
      // Navigate to the chapter
      context.push('/quran/chapter/${chapterResult.chapter.id}');
    } else if (result is VerseReferenceResult) {
      final referenceResult = result as VerseReferenceResult;
      // Extract chapter ID from verse key
      final chapterId = int.parse(referenceResult.verse.verseKey.split(':')[0]);
      // Navigate to the referenced verse
      context.push('/quran/chapter/$chapterId', extra: {
        'scrollToVerse': referenceResult.verse.verseNumber,
      });
    }
  }
}

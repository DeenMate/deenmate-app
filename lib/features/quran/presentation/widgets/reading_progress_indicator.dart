import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ReadingProgressIndicator extends ConsumerWidget {
  const ReadingProgressIndicator({
    super.key,
    required this.chapterId,
    required this.currentVerseIndex,
    required this.totalVerses,
    this.showStreak = true,
    this.showProgressBar = true,
  });

  final int chapterId;
  final int currentVerseIndex;
  final int totalVerses;
  final bool showStreak;
  final bool showProgressBar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = currentVerseIndex / totalVerses;
    final progressPercentage = (progress * 100).round();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ThemeHelper.getCardColor(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.quranReadingProgress,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
              Text(
                '$progressPercentage%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: ThemeHelper.getPrimaryColor(context),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Progress Bar
          if (showProgressBar) ...[
            LinearProgressIndicator(
              value: progress,
              backgroundColor: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                ThemeHelper.getPrimaryColor(context),
              ),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 8),
          ],
          
          // Progress Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context)!.quranVerse}: ${currentVerseIndex + 1} / $totalVerses',
                style: TextStyle(
                  fontSize: 12,
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
              ),
              if (showStreak) ...[
                Row(
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      size: 16,
                      color: ThemeHelper.getPrimaryColor(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${AppLocalizations.of(context)!.quranReadingStreak}: 7 ${AppLocalizations.of(context)!.quranDays}',
                      style: TextStyle(
                        fontSize: 12,
                        color: ThemeHelper.getTextSecondaryColor(context),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class CompactReadingProgressIndicator extends ConsumerWidget {
  const CompactReadingProgressIndicator({
    super.key,
    required this.chapterId,
    required this.currentVerseIndex,
    required this.totalVerses,
  });

  final int chapterId;
  final int currentVerseIndex;
  final int totalVerses;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = currentVerseIndex / totalVerses;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bookmark_outline,
            size: 16,
            color: ThemeHelper.getPrimaryColor(context),
          ),
          const SizedBox(width: 6),
          Text(
            '${currentVerseIndex + 1}/$totalVerses',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ThemeHelper.getPrimaryColor(context),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 40,
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: ThemeHelper.getPrimaryColor(context).withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(
                ThemeHelper.getPrimaryColor(context),
              ),
              minHeight: 4,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

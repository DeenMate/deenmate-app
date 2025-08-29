import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/theme/theme_helper.dart';
import '../controllers/smart_navigation_controller.dart';
import '../widgets/mobile_quran_navigation_bar.dart';

/// Widget that displays last reading position restoration banner
/// Shows when user returns to reading with option to continue from last position
class LastReadingPositionBanner extends ConsumerWidget {
  const LastReadingPositionBanner({
    super.key,
    required this.onRestorePosition,
    required this.onDismiss,
  });

  final Function(LastReadingPosition position) onRestorePosition;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smartNavController = ref.read(smartNavigationControllerProvider.notifier);
    final lastPosition = smartNavController.getLastReadingPosition();
    
    if (lastPosition == null) {
      return const SizedBox.shrink();
    }

    final localizations = AppLocalizations.of(context)!;
    final timeSinceLastRead = DateTime.now().difference(lastPosition.timestamp);
    
    // Only show if last reading was within 7 days
    if (timeSinceLastRead.inDays > 7) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.bookmark_outline,
                color: ThemeHelper.getPrimaryColor(context),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Continue Reading',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
              ),
              IconButton(
                onPressed: onDismiss,
                icon: Icon(
                  Icons.close,
                  size: 20,
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _formatLastReadingText(lastPosition, timeSinceLastRead),
            style: TextStyle(
              fontSize: 14,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Recommended mode chip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ThemeHelper.getPrimaryColor(context).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      lastPosition.suggestedMode.icon,
                      size: 14,
                      color: ThemeHelper.getPrimaryColor(context),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Suggested: ${lastPosition.suggestedMode.getDisplayName(localizations)}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: ThemeHelper.getPrimaryColor(context),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => onRestorePosition(lastPosition),
                style: TextButton.styleFrom(
                  foregroundColor: ThemeHelper.getPrimaryColor(context),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatLastReadingText(LastReadingPosition position, Duration timeSince) {
    final verse = position.position.verse;
    final timeText = _formatTimeAgo(timeSince);
    
    return 'Last read: Surah ${verse.chapterId}, Verse ${verse.verseNumber} • $timeText';
  }

  String _formatTimeAgo(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays == 1 ? '' : 's'} ago';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours == 1 ? '' : 's'} ago';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes} minute${duration.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

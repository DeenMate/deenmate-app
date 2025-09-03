import 'package:flutter/material.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/theme/theme_helper.dart';

/// Dialog to prompt user when audio is not available offline
/// Asks: "Play online or download surah?"
class AudioDownloadPromptDialog extends StatelessWidget {
  const AudioDownloadPromptDialog({
    super.key,
    required this.verse,
    required this.chapterName,
  });

  final dynamic verse; // Will be VerseAudio when implemented
  final String chapterName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(
            Icons.download_outlined,
            color: ThemeHelper.getPrimaryColor(context),
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            l10n.quranAudioNotDownloaded,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.quranAudioNotAvailableOffline(chapterName),
            style: TextStyle(
              fontSize: 14,
              color: ThemeHelper.getTextSecondaryColor(context),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.quranWouldYouLikeTo,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),

          // Download option
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ThemeHelper.getPrimaryColor(context).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ThemeHelper.getPrimaryColor(context).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.download,
                  color: ThemeHelper.getPrimaryColor(context),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.quranDownloadSurah,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        l10n.quranSaveForOffline,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Online option
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.wifi,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.quranPlayOnline,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        l10n.quranRequiresInternet,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeHelper.getTextSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Play online
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.wifi,
                size: 18,
                color: Colors.orange,
              ),
              const SizedBox(width: 4),
              Text(
                l10n.quranPlayOnline,
                style: const TextStyle(color: Colors.orange),
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true), // Download
          style: ElevatedButton.styleFrom(
            backgroundColor: ThemeHelper.getPrimaryColor(context),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.download, size: 18),
              const SizedBox(width: 4),
              Text(l10n.quranDownload),
            ],
          ),
        ),
      ],
    );
  }

  /// Show the download prompt dialog
  static Future<bool> show(
    BuildContext context,
    dynamic verse,
    String chapterName,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AudioDownloadPromptDialog(
        verse: verse,
        chapterName: chapterName,
      ),
    );
    return result ?? false; // Default to false (play online) if dismissed
  }

  /// Utility function to create audio download callback for audio service
  /// This integrates the prompt dialog with the audio service's onPromptDownload callback
  static Future<bool> Function(dynamic verse)? createAudioServiceCallback(
    BuildContext context,
  ) {
    return (dynamic verse) async {
      // Extract chapter name from verse context
      // For now, use a generic name - this should be enhanced to get actual chapter name
      final chapterName = 'Surah ${verse.chapterId ?? 'Unknown'}';

      return await AudioDownloadPromptDialog.show(
        context,
        verse,
        chapterName,
      );
    };
  }
}

/// Alternative simple version for quick prompts
class QuickAudioPrompt {
  static Future<bool> showSimple(
    BuildContext context,
    String verseKey,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(l10n.quranAudioNotAvailableOfflineSimple),
              content: Text(l10n.quranPlayVerseOnlineOrDownload(verseKey)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(l10n.quranPlayOnline),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text(l10n.quranDownload),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}

import 'package:flutter/material.dart';
import 'package:deen_mate/l10n/app_localizations.dart';

/// A dialog that prompts the user to either stream or download audio.
Future<bool?> showAudioDownloadPrompt(
  BuildContext context,
  String surahName,
) async {
  final l10n = AppLocalizations.of(context)!;
  final theme = Theme.of(context);
  final colors = theme.colorScheme;

  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: colors.surface,
        title: Text(
          l10n.quranDownloadAudioTitle,
          style: theme.textTheme.titleLarge?.copyWith(color: colors.onSurface),
        ),
        content: Text(
          l10n.quranDownloadAudioBody(surahName),
          style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              l10n.quranStreamOnline,
              style: TextStyle(color: colors.primary),
            ),
            onPressed: () {
              Navigator.of(context).pop(false); // Return false for streaming
            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colors.primary,
              foregroundColor: colors.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.quranDownloadAudioAction),
            onPressed: () {
              Navigator.of(context).pop(true); // Return true for downloading
            },
          ),
        ],
      );
    },
  );
}

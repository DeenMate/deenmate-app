import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/dto/verse_dto.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Widget that displays a visual indicator for sajdah (prostration) verses
class SajdahMarker extends StatelessWidget {
  const SajdahMarker({
    super.key,
    required this.sajdah,
    this.showTooltip = true,
    this.compact = false,
    this.onTap,
  });

  final SajdahDto sajdah;
  final bool showTooltip;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isObligatory = sajdah.obligatory ?? false;
    final isRecommended = sajdah.recommended ?? false;

    return GestureDetector(
      onTap: onTap ?? () => _showSajdahInfo(context, l10n),
      child: Tooltip(
        message: showTooltip
            ? _getTooltipText(l10n, isObligatory, isRecommended)
            : null,
        child: Container(
          padding: compact
              ? const EdgeInsets.symmetric(horizontal: 8, vertical: 4)
              : const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _getBackgroundColor(context, isObligatory, isRecommended),
            borderRadius: BorderRadius.circular(compact ? 12 : 16),
            border: Border.all(
              color: _getBorderColor(context, isObligatory, isRecommended),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: _getBackgroundColor(context, isObligatory, isRecommended)
                    .withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.volunteer_activism,
                size: compact ? 16 : 20,
                color: _getIconColor(context, isObligatory, isRecommended),
              ),
              if (!compact) ...[
                const SizedBox(width: 6),
                Text(
                  l10n.quranSajdah,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getIconColor(context, isObligatory, isRecommended),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor(
      BuildContext context, bool isObligatory, bool isRecommended) {
    if (isObligatory) {
      return ThemeHelper.getPrimaryColor(context).withOpacity(0.15);
    } else if (isRecommended) {
      return ThemeHelper.getSecondaryColor(context).withOpacity(0.15);
    } else {
      return ThemeHelper.getSurfaceColor(context).withOpacity(0.8);
    }
  }

  Color _getBorderColor(
      BuildContext context, bool isObligatory, bool isRecommended) {
    if (isObligatory) {
      return ThemeHelper.getPrimaryColor(context).withOpacity(0.6);
    } else if (isRecommended) {
      return ThemeHelper.getSecondaryColor(context).withOpacity(0.6);
    } else {
      return ThemeHelper.getDividerColor(context);
    }
  }

  Color _getIconColor(
      BuildContext context, bool isObligatory, bool isRecommended) {
    if (isObligatory) {
      return ThemeHelper.getPrimaryColor(context);
    } else if (isRecommended) {
      return ThemeHelper.getSecondaryColor(context);
    } else {
      return ThemeHelper.getTextSecondaryColor(context);
    }
  }

  String _getTooltipText(
      AppLocalizations l10n, bool isObligatory, bool isRecommended) {
    if (isObligatory) {
      return l10n.quranSajdahObligatory;
    } else if (isRecommended) {
      return l10n.quranSajdahRecommended;
    } else {
      return l10n.quranSajdahInfo;
    }
  }

  void _showSajdahInfo(BuildContext context, AppLocalizations l10n) {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.volunteer_activism,
              color: ThemeHelper.getPrimaryColor(context),
            ),
            const SizedBox(width: 12),
            Text(l10n.quranSajdahInfo),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${l10n.quranSajdahNumber}: ${sajdah.sajdahNumber}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.quranSajdahType}: ${_getSajdahTypeText(l10n)}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              '${l10n.quranSajdahVerse}: ${sajdah.verseKey}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ThemeHelper.getSurfaceColor(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ThemeHelper.getDividerColor(context),
                ),
              ),
              child: Text(
                _getSajdahDescription(l10n),
                style: TextStyle(
                  color: ThemeHelper.getTextSecondaryColor(context),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.quranClose),
          ),
        ],
      ),
    );
  }

  String _getSajdahTypeText(AppLocalizations l10n) {
    if (sajdah.obligatory ?? false) {
      return l10n.quranSajdahObligatory;
    } else if (sajdah.recommended ?? false) {
      return l10n.quranSajdahRecommended;
    } else {
      return l10n.quranSajdahType;
    }
  }

  String _getSajdahDescription(AppLocalizations l10n) {
    if (sajdah.obligatory ?? false) {
      return l10n.quranSajdahObligatoryDescription;
    } else if (sajdah.recommended ?? false) {
      return l10n.quranSajdahRecommendedDescription;
    } else {
      return l10n.quranSajdahGeneralDescription;
    }
  }
}

/// Compact sajdah marker for inline use in verse text
class CompactSajdahMarker extends StatelessWidget {
  const CompactSajdahMarker({
    super.key,
    required this.sajdah,
    this.size = 16,
  });

  final SajdahDto sajdah;
  final double size;

  @override
  Widget build(BuildContext context) {
    final isObligatory = sajdah.obligatory ?? false;
    final isRecommended = sajdah.recommended ?? false;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getBackgroundColor(context, isObligatory, isRecommended),
        shape: BoxShape.circle,
        border: Border.all(
          color: _getBorderColor(context, isObligatory, isRecommended),
          width: 1.5,
        ),
      ),
      child: Icon(
        Icons.volunteer_activism,
        size: size * 0.6,
        color: _getIconColor(context, isObligatory, isRecommended),
      ),
    );
  }

  Color _getBackgroundColor(
      BuildContext context, bool isObligatory, bool isRecommended) {
    if (isObligatory) {
      return ThemeHelper.getPrimaryColor(context).withOpacity(0.15);
    } else if (isRecommended) {
      return ThemeHelper.getSecondaryColor(context).withOpacity(0.15);
    } else {
      return ThemeHelper.getSurfaceColor(context).withOpacity(0.8);
    }
  }

  Color _getBorderColor(
      BuildContext context, bool isObligatory, bool isRecommended) {
    if (isObligatory) {
      return ThemeHelper.getPrimaryColor(context).withOpacity(0.6);
    } else if (isRecommended) {
      return ThemeHelper.getSecondaryColor(context).withOpacity(0.6);
    } else {
      return ThemeHelper.getDividerColor(context);
    }
  }

  Color _getIconColor(
      BuildContext context, bool isObligatory, bool isRecommended) {
    if (isObligatory) {
      return ThemeHelper.getPrimaryColor(context);
    } else if (isRecommended) {
      return ThemeHelper.getSecondaryColor(context);
    } else {
      return ThemeHelper.getTextSecondaryColor(context);
    }
  }
}

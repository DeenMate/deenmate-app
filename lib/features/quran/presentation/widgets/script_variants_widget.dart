import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../../../../core/theme/theme_helper.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Widget for selecting Quran script variants (Uthmanic vs IndoPak)
class ScriptVariantsWidget extends ConsumerWidget {
  const ScriptVariantsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(prefsProvider);
    final notifier = ref.read(prefsProvider.notifier);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.font_download,
                  color: ThemeHelper.getPrimaryColor(context),
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  l10n.quranScriptVariants,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: ThemeHelper.getTextPrimaryColor(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.quranScriptVariantsDescription,
              style: TextStyle(
                fontSize: 14,
                color: ThemeHelper.getTextSecondaryColor(context),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            // Script Variant Options
            ..._buildScriptVariantOptions(context, prefs, notifier, l10n),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildScriptVariantOptions(
    BuildContext context,
    QuranPrefs prefs,
    PrefsNotifier notifier,
    AppLocalizations l10n,
  ) {
    return [
      _buildScriptVariantOption(
        context: context,
        variant: 'Uthmanic',
        name: l10n.quranUthmanic,
        description: l10n.quranUthmanicDescription,
        preview: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        fontFamily: 'UthmanicHafs',
        isSelected: prefs.quranScriptVariant == 'Uthmanic',
        onTap: () => notifier.updateQuranScriptVariant('Uthmanic'),
      ),
      const SizedBox(height: 12),
      _buildScriptVariantOption(
        context: context,
        variant: 'IndoPak',
        name: l10n.quranIndoPak,
        description: l10n.quranIndoPakDescription,
        preview: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ',
        fontFamily: 'IndoPak',
        isSelected: prefs.quranScriptVariant == 'IndoPak',
        onTap: () => notifier.updateQuranScriptVariant('IndoPak'),
      ),
    ];
  }

  Widget _buildScriptVariantOption({
    required BuildContext context,
    required String variant,
    required String name,
    required String description,
    required String preview,
    required String fontFamily,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? ThemeHelper.getPrimaryColor(context)
              : ThemeHelper.getDividerColor(context),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? ThemeHelper.getPrimaryColor(context).withOpacity(0.1)
            : ThemeHelper.getSurfaceColor(context),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with name and selection indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: ThemeHelper.getTextPrimaryColor(context),
                      ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: ThemeHelper.getPrimaryColor(context),
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 4),
              
              // Description
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: ThemeHelper.getTextSecondaryColor(context),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              
              // Preview text
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: ThemeHelper.getBackgroundColor(context),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ThemeHelper.getDividerColor(context).withOpacity(0.5),
                  ),
                ),
                child: Text(
                  preview,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: fontFamily,
                    height: 1.8,
                    color: ThemeHelper.getTextPrimaryColor(context),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact script variant selector for inline use
class CompactScriptVariantSelector extends ConsumerWidget {
  const CompactScriptVariantSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(prefsProvider);
    final notifier = ref.read(prefsProvider.notifier);

    return Row(
      children: [
        Text(
          l10n.quranScript,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: ThemeHelper.getTextSecondaryColor(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: ThemeHelper.getDividerColor(context),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: prefs.quranScriptVariant,
                isExpanded: true,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                items: [
                  DropdownMenuItem(
                    value: 'Uthmanic',
                    child: Text(l10n.quranUthmanic),
                  ),
                  DropdownMenuItem(
                    value: 'IndoPak',
                    child: Text(l10n.quranIndoPak),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    notifier.updateQuranScriptVariant(value);
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

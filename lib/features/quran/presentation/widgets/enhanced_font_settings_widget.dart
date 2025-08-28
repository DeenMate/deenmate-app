import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../../../../core/theme/theme_helper.dart';

class EnhancedFontSettingsWidget extends ConsumerStatefulWidget {
  const EnhancedFontSettingsWidget({super.key});

  @override
  ConsumerState<EnhancedFontSettingsWidget> createState() =>
      _EnhancedFontSettingsWidgetState();
}

class _EnhancedFontSettingsWidgetState
    extends ConsumerState<EnhancedFontSettingsWidget> {
  static const List<ArabicFontOption> _arabicFonts = [
    ArabicFontOption(
      name: 'Uthmani',
      family: 'Uthmani',
      description: 'Traditional Uthmani script',
      preview: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    ),
    ArabicFontOption(
      name: 'KFGQ',
      family: 'KFGQ',
      description: 'King Fahd Glorious Quran',
      preview: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    ),
    ArabicFontOption(
      name: 'IndoPak',
      family: 'IndoPak',
      description: 'IndoPak style',
      preview: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    ),
    ArabicFontOption(
      name: 'Amiri',
      family: 'Amiri',
      description: 'Modern Arabic font',
      preview: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    ),
    ArabicFontOption(
      name: 'Scheherazade',
      family: 'Scheherazade',
      description: 'Classical Arabic style',
      preview: 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(prefsProvider);
    final notifier = ref.read(prefsProvider.notifier);

    return Scaffold(
      backgroundColor: ThemeHelper.getBackgroundColor(context),
      appBar: AppBar(
        backgroundColor: ThemeHelper.getBackgroundColor(context),
        elevation: 0,
        title: Text(
          'Font Settings',
          style: TextStyle(
            color: ThemeHelper.getTextPrimaryColor(context),
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: ThemeHelper.getTextPrimaryColor(context)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Font Preview Section
            _buildFontPreviewSection(prefs),
            const SizedBox(height: 24),

            // Arabic Font Family Selection
            _buildArabicFontFamilySection(prefs, notifier),
            const SizedBox(height: 24),

            // Font Size Controls
            _buildFontSizeSection(prefs, notifier),
            const SizedBox(height: 24),

            // Line Height Controls
            _buildLineHeightSection(prefs, notifier),
            const SizedBox(height: 24),

            // Advanced Settings
            _buildAdvancedSettingsSection(prefs, notifier),
          ],
        ),
      ),
    );
  }

  Widget _buildFontPreviewSection(QuranPrefs prefs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Font Preview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ThemeHelper.getCardColor(context),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: ThemeHelper.getDividerColor(context),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arabic text preview
                  Text(
                    'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
                    style: TextStyle(
                      fontSize: prefs.arabicFontSize,
                      fontFamily: prefs.arabicFontFamily ?? 'Uthmani',
                      height: prefs.arabicLineHeight,
                      color: ThemeHelper.getTextPrimaryColor(context),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  // Translation preview
                  Text(
                    'In the name of Allah, the Entirely Merciful, the Especially Merciful.',
                    style: TextStyle(
                      fontSize: prefs.translationFontSize,
                      height: prefs.translationLineHeight,
                      color: ThemeHelper.getTextSecondaryColor(context),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArabicFontFamilySection(
      QuranPrefs prefs, PrefsNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Arabic Font Family',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
            const SizedBox(height: 16),
            ...(_arabicFonts
                .map((font) => _buildFontOption(font, prefs, notifier))),
          ],
        ),
      ),
    );
  }

  Widget _buildFontOption(
      ArabicFontOption font, QuranPrefs prefs, PrefsNotifier notifier) {
    final isSelected = prefs.arabicFontFamily == font.family;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected
              ? ThemeHelper.getPrimaryColor(context)
              : ThemeHelper.getDividerColor(context),
          width: isSelected ? 2 : 1,
        ),
        color: isSelected
            ? ThemeHelper.getPrimaryColor(context).withOpacity(0.1)
            : ThemeHelper.getCardColor(context),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          font.name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: ThemeHelper.getTextPrimaryColor(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              font.description,
              style: TextStyle(
                color: ThemeHelper.getTextSecondaryColor(context),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              font.preview,
              style: TextStyle(
                fontSize: 20,
                fontFamily: font.family,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
          ],
        ),
        trailing: isSelected
            ? Icon(
                Icons.check_circle,
                color: ThemeHelper.getPrimaryColor(context),
              )
            : null,
        onTap: () => notifier.updateArabicFontFamily(font.family),
      ),
    );
  }

  Widget _buildFontSizeSection(QuranPrefs prefs, PrefsNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Font Sizes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
            const SizedBox(height: 16),

            // Arabic Font Size
            _buildSliderSetting(
              label: 'Arabic Font Size',
              value: prefs.arabicFontSize,
              min: 16.0,
              max: 40.0,
              divisions: 24,
              onChanged: (value) => notifier.updateArabicFontSize(value),
            ),
            const SizedBox(height: 16),

            // Translation Font Size
            _buildSliderSetting(
              label: 'Translation Font Size',
              value: prefs.translationFontSize,
              min: 12.0,
              max: 24.0,
              divisions: 12,
              onChanged: (value) => notifier.updateTranslationFontSize(value),
            ),
            const SizedBox(height: 16),

            // Tafsir Font Size
            _buildSliderSetting(
              label: 'Tafsir Font Size',
              value: prefs.tafsirFontSize,
              min: 10.0,
              max: 20.0,
              divisions: 10,
              onChanged: (value) => notifier.updateTafsirFontSize(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineHeightSection(QuranPrefs prefs, PrefsNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Line Heights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
            const SizedBox(height: 16),

            // Arabic Line Height
            _buildSliderSetting(
              label: 'Arabic Line Height',
              value: prefs.arabicLineHeight,
              min: 1.2,
              max: 2.5,
              divisions: 13,
              onChanged: (value) => notifier.updateArabicLineHeight(value),
            ),
            const SizedBox(height: 16),

            // Translation Line Height
            _buildSliderSetting(
              label: 'Translation Line Height',
              value: prefs.translationLineHeight,
              min: 1.2,
              max: 2.0,
              divisions: 8,
              onChanged: (value) => notifier.updateTranslationLineHeight(value),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvancedSettingsSection(
      QuranPrefs prefs, PrefsNotifier notifier) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Advanced Settings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: ThemeHelper.getTextPrimaryColor(context),
              ),
            ),
            const SizedBox(height: 16),

            // Reset to Defaults
            ListTile(
              leading: Icon(
                Icons.restore,
                color: ThemeHelper.getPrimaryColor(context),
              ),
              title: Text(
                'Reset to Defaults',
                style: TextStyle(
                  color: ThemeHelper.getTextPrimaryColor(context),
                ),
              ),
              subtitle: Text(
                'Restore all font settings to default values',
                style: TextStyle(
                  color: ThemeHelper.getTextSecondaryColor(context),
                ),
              ),
              onTap: () => _showResetConfirmation(notifier),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: ThemeHelper.getTextPrimaryColor(context),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(
                color: ThemeHelper.getPrimaryColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: ThemeHelper.getPrimaryColor(context),
            inactiveTrackColor:
                ThemeHelper.getPrimaryColor(context).withOpacity(0.3),
            thumbColor: ThemeHelper.getPrimaryColor(context),
            overlayColor: ThemeHelper.getPrimaryColor(context).withOpacity(0.2),
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  void _showResetConfirmation(PrefsNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Font Settings'),
        content: const Text(
          'Are you sure you want to reset all font settings to their default values? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              notifier.resetFontSettings();
              Navigator.of(context).pop();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class ArabicFontOption {
  final String name;
  final String family;
  final String description;
  final String preview;

  const ArabicFontOption({
    required this.name,
    required this.family,
    required this.description,
    required this.preview,
  });
}

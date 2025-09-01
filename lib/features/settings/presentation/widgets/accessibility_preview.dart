import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Accessibility preview widget to demonstrate current settings
class AccessibilityPreview extends ConsumerWidget {
  final double textScaleFactor;
  final bool highContrastMode;
  final String focusStyle;

  const AccessibilityPreview({
    super.key,
    required this.textScaleFactor,
    required this.highContrastMode,
    required this.focusStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = highContrastMode 
        ? _getHighContrastColorScheme(theme.colorScheme)
        : theme.colorScheme;

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preview',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: (theme.textTheme.titleMedium?.fontSize ?? 16) * textScaleFactor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'This is how text will appear with your current accessibility settings.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
                fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * textScaleFactor,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border.all(
                  color: colorScheme.outline,
                  width: focusStyle == 'enhanced' ? 2.0 : 1.0,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.visibility,
                    color: colorScheme.primary,
                    size: 24 * textScaleFactor,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Text(
                      'Sample interactive element',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * textScaleFactor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (highContrastMode) ...[
              const SizedBox(height: 8.0),
              Text(
                'High contrast mode is enabled',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  fontSize: (theme.textTheme.bodySmall?.fontSize ?? 12) * textScaleFactor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  ColorScheme _getHighContrastColorScheme(ColorScheme originalScheme) {
    return originalScheme.copyWith(
      surface: Colors.black,
      onSurface: Colors.white,
      primary: Colors.yellow,
      onPrimary: Colors.black,
      secondary: Colors.cyan,
      onSecondary: Colors.black,
      background: Colors.black,
      onBackground: Colors.white,
      outline: Colors.white,
    );
  }
}

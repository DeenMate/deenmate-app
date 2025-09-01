import 'package:flutter/material.dart';
import 'settings_tile.dart';

/// Slider input settings tile widget
class SliderSettingTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;
  final String Function(double)? labelBuilder;
  final bool enabled;
  final Color? iconColor;

  const SliderSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.labelBuilder,
    this.enabled = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        SettingsTile(
          title: title,
          subtitle: subtitle,
          icon: icon,
          enabled: enabled,
          iconColor: iconColor,
          trailing: Text(
            labelBuilder?.call(value) ?? value.toStringAsFixed(1),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: enabled 
                  ? theme.colorScheme.onSurface.withOpacity(0.6)
                  : theme.colorScheme.onSurface.withOpacity(0.38),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: enabled ? onChanged : null,
            label: labelBuilder?.call(value) ?? value.toStringAsFixed(1),
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );
  }
}

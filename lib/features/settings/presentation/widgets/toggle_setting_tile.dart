import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_tile.dart';

/// Toggle switch settings tile widget
class ToggleSettingTile extends ConsumerWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final Color? iconColor;

  const ToggleSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SettingsTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      enabled: enabled,
      iconColor: iconColor,
      trailing: Switch(
        value: value,
        onChanged: enabled ? onChanged : null,
      ),
      onTap: enabled ? () => onChanged(!value) : null,
    );
  }
}

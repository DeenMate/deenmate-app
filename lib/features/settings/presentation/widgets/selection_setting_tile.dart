import 'package:flutter/material.dart';
import 'settings_tile.dart';

/// Selection dropdown settings tile widget
class SelectionSettingTile<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool enabled;
  final Color? iconColor;
  final String Function(T)? itemBuilder;

  const SelectionSettingTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
    this.iconColor,
    this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      title: title,
      subtitle: subtitle,
      icon: icon,
      enabled: enabled,
      iconColor: iconColor,
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: enabled ? onChanged : null,
        underline: const SizedBox.shrink(),
        isDense: true,
      ),
    );
  }
}

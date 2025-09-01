import 'package:flutter/material.dart';

/// Reusable settings tile widget
class SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool enabled;
  final Color? iconColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.trailing,
    this.onTap,
    this.enabled = true,
    this.iconColor,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return ListTile(
      leading: Icon(
        icon,
        color: enabled 
            ? (iconColor ?? colorScheme.primary)
            : colorScheme.onSurface.withOpacity(0.38),
      ),
      title: Text(
        title,
        style: titleStyle ?? theme.textTheme.bodyLarge?.copyWith(
          color: enabled 
              ? colorScheme.onSurface
              : colorScheme.onSurface.withOpacity(0.38),
        ),
      ),
      subtitle: subtitle != null 
          ? Text(
              subtitle!,
              style: subtitleStyle ?? theme.textTheme.bodyMedium?.copyWith(
                color: enabled 
                    ? colorScheme.onSurface.withOpacity(0.6)
                    : colorScheme.onSurface.withOpacity(0.38),
              ),
            )
          : null,
      trailing: trailing,
      onTap: enabled ? onTap : null,
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
    );
  }
}

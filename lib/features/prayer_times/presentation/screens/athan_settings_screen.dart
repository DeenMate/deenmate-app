import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../../core/navigation/shell_wrapper.dart' show EnhancedAppRouter;
import '../../../../l10n/generated/app_localizations.dart';

import '../../../../core/utils/islamic_utils.dart' as islamic_utils;
import '../../domain/entities/athan_settings.dart';
import '../providers/notification_providers.dart' hide athanAudioProvider;
import '../providers/audio_providers.dart';
import '../providers/prayer_times_providers.dart';
import '../widgets/athan_preview_widget.dart';
import '../widgets/muadhin_selector_widget.dart';
import '../widgets/notification_permissions_widget.dart';
import '../widgets/prayer_notification_toggle.dart';
import '../widgets/volume_slider_widget.dart';

/// Athan Settings Screen - Comprehensive notification customization
class AthanSettingsScreen extends ConsumerStatefulWidget {
  const AthanSettingsScreen({super.key});

  @override
  ConsumerState<AthanSettingsScreen> createState() =>
      _AthanSettingsScreenState();
}

class _AthanSettingsScreenState extends ConsumerState<AthanSettingsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final athanSettingsAsync = ref.watch(athanSettingsProvider);
    final permissionsState = ref.watch(notificationPermissionsProvider);

    return WillPopScope(
      onWillPop: () async {
        // Navigate back to More screen instead of exiting the app
        context.go(EnhancedAppRouter.more);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.athanNotificationsTitle),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go(EnhancedAppRouter.more),
          ),
          bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
            tabs: [
              Tab(icon: const Icon(Icons.volume_up), text: AppLocalizations.of(context)!.athanTabTitle),
              Tab(icon: const Icon(Icons.notifications), text: AppLocalizations.of(context)!.prayersTabTitle),
              Tab(icon: const Icon(Icons.settings), text: AppLocalizations.of(context)!.advancedTabTitle),
              Tab(icon: const Icon(Icons.nightlight), text: AppLocalizations.of(context)!.ramadanTabTitle),
            ],
          ),
        ),
        body: athanSettingsAsync.when(
          data: (settings) => TabBarView(
            controller: _tabController,
            children: [
              _buildAthanTab(settings),
              _buildPrayersTab(settings),
              _buildAdvancedTab(settings, permissionsState),
              _buildRamadanTab(settings),
            ],
          ),
          loading: () => const SizedBox.shrink(),
          error: (error, stack) => _buildErrorView(error),
        ),
      ),
    );
  }

  Widget _buildAthanTab(AthanSettings settings) {
    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            AppLocalizations.of(context)!.athanSettingsTitle,
            AppLocalizations.of(context)!.athanSettingsSubtitle,
            Icons.volume_up,
          ),
          const SizedBox(height: 16),

          // Master Enable/Disable Switch
          _buildMasterToggle(settings),
          const SizedBox(height: 24),

          // Muadhin Voice Selector
          MuadhinSelectorWidget(
            selectedVoice: settings.muadhinVoice,
            onVoiceChanged: (voice) {
              ref
                  .read(athanSettingsProvider.notifier)
                  .updateMuadhinVoice(voice);
            },
          ),
          const SizedBox(height: 24),

          // Volume Control
          VolumeSliderWidget(
            volume: settings.volume,
            onVolumeChanged: (volume) {
              ref.read(athanSettingsProvider.notifier).updateVolume(volume);
            },
          ),
          const SizedBox(height: 24),

          // Athan Preview
          AthanPreviewWidget(
            muadhinVoice: settings.muadhinVoice,
            volume: settings.volume,
          ),
          const SizedBox(height: 24),

          // Duration and Other Audio Settings
          _buildAudioSettings(settings),
        ],
      ),
    );
  }

  Widget _buildPrayersTab(AthanSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            AppLocalizations.of(context)!.prayerNotificationsTitle,
            AppLocalizations.of(context)!.prayerNotificationsSubtitle,
            Icons.notifications,
          ),
          const SizedBox(height: 16),

          // Minimal inline exact-alarm prompt (shown only if needed)
          Consumer(builder: (context, ref, _) {
            final perms = ref.watch(notificationPermissionsProvider);
            if (perms.exactAlarmPermission) {
              return const SizedBox.shrink();
            }
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E50).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule,
                      size: 18, color: Color(0xFF2C3E50)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.preciseTimingRecommended,
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(notificationPermissionsProvider.notifier)
                          .requestExactAlarmPermission();
                    },
                    child: Text(AppLocalizations.of(context)!.permissionsGrant),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),

          // Reminder Time Selector
          _buildReminderTimeSelector(settings),
          const SizedBox(height: 24),

          // Individual Prayer Toggles
          _buildPrayerToggles(settings),
          const SizedBox(height: 24),

          // Notification Actions
          _buildNotificationActions(settings),
        ],
      ),
    );
  }

  Widget _buildAdvancedTab(
      AthanSettings settings, NotificationPermissionsState permissions) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            AppLocalizations.of(context)!.advancedSettingsTitle,
            AppLocalizations.of(context)!.advancedSettingsSubtitle,
            Icons.settings,
          ),
          const SizedBox(height: 16),

          // Permissions Status
          NotificationPermissionsWidget(permissions: permissions),
          const SizedBox(height: 24),

          // Mute Settings
          _buildMuteSettings(settings),
          const SizedBox(height: 24),

          // Smart Notifications
          _buildSmartNotifications(settings),
          const SizedBox(height: 24),

          // Do Not Disturb Override
          _buildDndSettings(settings),
          const SizedBox(height: 24),

          // Full Screen Notifications
          _buildFullScreenSettings(settings),
        ],
      ),
    );
  }

  Widget _buildRamadanTab(AthanSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            AppLocalizations.of(context)!.ramadanSettingsTitle,
            AppLocalizations.of(context)!.ramadanSettingsSubtitle,
            Icons.nightlight,
          ),
          const SizedBox(height: 16),

          // Ramadan Status
          _buildRamadanStatus(),
          const SizedBox(height: 24),

          // Ramadan Notifications Toggle
          _buildRamadanToggle(settings),
          const SizedBox(height: 24),

          // Suhur and Iftar Settings
          if (settings.ramadanSettings?.enabled == true) ...[
            _buildSuhurSettings(settings),
            const SizedBox(height: 16),
            _buildIftarSettings(settings),
            const SizedBox(height: 24),
            _buildRamadanSpecialFeatures(settings),
          ],
        ],
      ),
    );
  }

  Widget _buildMasterToggle(AthanSettings settings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: settings.isEnabled
                  ? Colors.green
                  : Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.notifications_active,
              color: settings.isEnabled ? Colors.white : Colors.grey[600],
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.prayerNotificationsTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: settings.isEnabled ? Colors.green : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  settings.isEnabled
                      ? AppLocalizations.of(context)!.notificationsEnabled
                      : AppLocalizations.of(context)!.notificationsDisabled,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: settings.isEnabled,
            onChanged: (value) {
              ref.read(athanSettingsProvider.notifier).toggleEnabled();
            },
            activeColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.green,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAudioSettings(AthanSettings settings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.audioSettingsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Duration Slider
        Row(
          children: [
            Icon(
              Icons.timer,
              color: Colors.green,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.durationLabel),
            Text(
              '${settings.durationSeconds}s',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Slider(
          value: settings.durationSeconds.toDouble(),
          min: 30,
          max: 300,
          divisions: 27,
          label: '${settings.durationSeconds}s',
          onChanged: (value) {
            // Optimistic update only (no rebuild jump)
            ref.read(athanSettingsProvider.notifier).updateSettings(
                  settings.copyWith(durationSeconds: value.toInt()),
                );
          },
        ),

        const SizedBox(height: 16),

        // Vibration Toggle
        SwitchListTile(
          title: Text(AppLocalizations.of(context)!.athanSettingsVibration),
          subtitle: Text(AppLocalizations.of(context)!.athanSettingsVibrationSubtitle),
          value: settings.vibrateEnabled,
          onChanged: (value) {
            ref.read(athanSettingsProvider.notifier).updateSettings(
                  settings.copyWith(vibrateEnabled: value),
                );
          },
          secondary: Icon(
            Icons.vibration,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildReminderTimeSelector(AthanSettings settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.schedule,
                color: Colors.green,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.reminderTimeTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.reminderTimeSubtitle,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: settings.reminderMinutes.toDouble(),
                  max: 60,
                  divisions: 12,
                  label: '${settings.reminderMinutes} min',
                  onChanged: (value) {
                    ref
                        .read(athanSettingsProvider.notifier)
                        .updateReminderMinutes(value.toInt());
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${settings.reminderMinutes} min',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerToggles(AthanSettings settings) {
    final l10n = AppLocalizations.of(context)!;
    final prayers = [
      (l10n.prayerFajr, 'فجر', Icons.wb_twilight),
      (l10n.prayerDhuhr, 'ظهر', Icons.wb_sunny_outlined),
      (l10n.prayerAsr, 'عصر', Icons.wb_cloudy),
      (l10n.prayerMaghrib, 'مغرب', Icons.wb_twilight),
      (l10n.prayerIsha, 'عشاء', Icons.nightlight),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.prayerNotificationsTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppLocalizations.of(context)!.choosePrayerNotifications,
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 16),
        ...prayers.map((prayer) {
          final prayerName = prayer.$1;
          final arabicName = prayer.$2;
          final icon = prayer.$3;

          return PrayerNotificationToggle(
            prayerName: prayerName,
            arabicName: arabicName,
            icon: icon,
            isEnabled: settings.isPrayerEnabled(prayerName),
            onToggle: (enabled) {
              ref
                  .read(athanSettingsProvider.notifier)
                  .togglePrayerNotification(prayerName, enabled);
            },
          );
        }),
      ],
    );
  }

  Widget _buildNotificationActions(AthanSettings settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.notificationActionsTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.athanSettingsQuickActions),
            subtitle: Text(AppLocalizations.of(context)!.athanSettingsQuickActionsSubtitle),
            value: true, // This would be a setting in AthanSettings
            onChanged: (value) {
              // Update quick actions setting
            },
            contentPadding: EdgeInsets.zero,
          ),
          SwitchListTile(
            title: Text(AppLocalizations.of(context)!.athanSettingsAutoComplete),
            subtitle: Text(AppLocalizations.of(context)!.athanSettingsAutoCompleteSubtitle),
            value: settings.autoMarkCompleted,
            onChanged: (value) {
              ref.read(athanSettingsProvider.notifier).updateSettings(
                    settings.copyWith(autoMarkCompleted: value),
                  );
            },
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildMuteSettings(AthanSettings settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.green.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.muteSettingsTitle,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppLocalizations.of(context)!.muteSettingsSubtitle,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Muted days
          Text('${AppLocalizations.of(context)!.mutedDaysLabel}',
              style: TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              AppLocalizations.of(context)!.monday,
              AppLocalizations.of(context)!.tuesday,
              AppLocalizations.of(context)!.wednesday,
              AppLocalizations.of(context)!.thursday,
              AppLocalizations.of(context)!.friday,
              AppLocalizations.of(context)!.saturday,
              AppLocalizations.of(context)!.sunday,
            ].map((day) {
              final isMuted =
                  settings.mutedDays?.contains(day.toLowerCase()) ?? false;
              return FilterChip(
                label: Text(day.substring(0, 3)),
                selected: isMuted,
                onSelected: (selected) {
                  // Update muted days
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Add time range button
          OutlinedButton.icon(
            onPressed: () => _showTimeRangeDialog(settings),
            icon: const Icon(Icons.access_time),
            label: Text(AppLocalizations.of(context)!.athanSettingsAddMuteTimeRange),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartNotifications(AthanSettings settings) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.athanSettingsSmartNotifications),
      subtitle: Text(AppLocalizations.of(context)!.athanSettingsSmartNotificationsSubtitle),
      value: settings.smartNotifications,
      onChanged: (value) {
        ref.read(athanSettingsProvider.notifier).updateSettings(
              settings.copyWith(smartNotifications: value),
            );
      },
      secondary: Icon(
        Icons.psychology,
        color: Colors.green,
      ),
    );
  }

  Widget _buildDndSettings(AthanSettings settings) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.athanSettingsOverrideDnd),
      subtitle: Text(AppLocalizations.of(context)!.athanSettingsOverrideDndSubtitle),
      value: settings.overrideDnd,
      onChanged: (value) {
        ref.read(athanSettingsProvider.notifier).updateSettings(
              settings.copyWith(overrideDnd: value),
            );
      },
      secondary: Icon(
        Icons.do_not_disturb_off,
        color: Colors.green,
      ),
    );
  }

  Widget _buildFullScreenSettings(AthanSettings settings) {
    return SwitchListTile(
      title: Text(AppLocalizations.of(context)!.athanSettingsFullScreenNotifications),
      subtitle: Text(AppLocalizations.of(context)!.athanSettingsFullScreenNotificationsSubtitle),
      value: settings.fullScreenNotification,
      onChanged: (value) {
        ref.read(athanSettingsProvider.notifier).updateSettings(
              settings.copyWith(fullScreenNotification: value),
            );
      },
      secondary: Icon(
        Icons.fullscreen,
        color: Colors.green,
      ),
    );
  }

  Widget _buildRamadanStatus() {
    final l10n = AppLocalizations.of(context)!;
    final isRamadan = islamic_utils.IslamicUtils.isRamadan();
    final daysRemaining = islamic_utils.IslamicUtils.getRamadanDaysRemaining();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isRamadan
              ? [
                  Colors.purple.withOpacity(0.1),
                  Colors.indigo.withOpacity(0.05)
                ]
              : [Colors.grey.withOpacity(0.1), Colors.grey.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRamadan
              ? Colors.purple.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isRamadan ? Colors.purple : Colors.grey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isRamadan ? Icons.nightlight : Icons.calendar_month,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isRamadan ? l10n.ramadanMubarak : l10n.ramadanStatus,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isRamadan ? Colors.purple[700] : Colors.grey[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isRamadan
                      ? daysRemaining != null
                          ? l10n.ramadanDaysRemaining(daysRemaining)
                          : l10n.ramadanBlessedMonth
                      : l10n.ramadanSettingsInfo,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRamadanToggle(AthanSettings settings) {
    final l10n = AppLocalizations.of(context)!;
    final isEnabled = settings.ramadanSettings?.enabled ?? false;

    return SwitchListTile(
      title: Text(l10n.prayerRamadanNotifications),
      subtitle: Text(l10n.prayerRamadanNotificationsSubtitle),
      value: isEnabled,
      onChanged: (value) {
        final newRamadanSettings =
            (settings.ramadanSettings ?? const RamadanNotificationSettings())
                .copyWith(enabled: value);
        ref
            .read(athanSettingsProvider.notifier)
            .updateRamadanSettings(newRamadanSettings);
      },
      secondary: Icon(
        Icons.nightlight,
        color: Colors.green,
      ),
    );
  }

  Widget _buildSuhurSettings(AthanSettings settings) {
    final l10n = AppLocalizations.of(context)!;
    final ramadanSettings = settings.ramadanSettings!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.free_breakfast, color: Colors.purple[600], size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.prayerSuhurReminder,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.prayerSuhurReminderText(ramadanSettings.suhurReminderMinutes),
            style: const TextStyle(fontSize: 14),
          ),
          Slider(
            value: ramadanSettings.suhurReminderMinutes.toDouble(),
            min: 15,
            max: 120,
            divisions: 21,
            label: '${ramadanSettings.suhurReminderMinutes} min',
            onChanged: (value) {
              final newSettings = ramadanSettings.copyWith(
                suhurReminderMinutes: value.toInt(),
              );
              ref
                  .read(athanSettingsProvider.notifier)
                  .updateRamadanSettings(newSettings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIftarSettings(AthanSettings settings) {
    final l10n = AppLocalizations.of(context)!;
    final ramadanSettings = settings.ramadanSettings!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.dinner_dining, color: Colors.orange[600], size: 20),
              const SizedBox(width: 8),
              Text(
                l10n.prayerIftarReminder,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.prayerIftarReminderText(ramadanSettings.iftarReminderMinutes),
            style: const TextStyle(fontSize: 14),
          ),
          Slider(
            value: ramadanSettings.iftarReminderMinutes.toDouble(),
            min: 5,
            max: 30,
            divisions: 5,
            label: '${ramadanSettings.iftarReminderMinutes} min',
            onChanged: (value) {
              final newSettings = ramadanSettings.copyWith(
                iftarReminderMinutes: value.toInt(),
              );
              ref
                  .read(athanSettingsProvider.notifier)
                  .updateRamadanSettings(newSettings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRamadanSpecialFeatures(AthanSettings settings) {
    final l10n = AppLocalizations.of(context)!;
    final ramadanSettings = settings.ramadanSettings!;

    return Column(
      children: [
        SwitchListTile(
          title: Text(l10n.prayerSpecialRamadanAthan),
          subtitle: Text(l10n.prayerSpecialRamadanAthanSubtitle),
          value: ramadanSettings.specialRamadanAthan,
          onChanged: (value) {
            final newSettings =
                ramadanSettings.copyWith(specialRamadanAthan: value);
            ref
                .read(athanSettingsProvider.notifier)
                .updateRamadanSettings(newSettings);
          },
          secondary: Icon(Icons.music_note, color: Colors.purple[600]),
        ),
        SwitchListTile(
          title: Text(l10n.prayerIncludeDuas),
          subtitle: Text(l10n.prayerIncludeDuasSubtitle),
          value: ramadanSettings.includeDuas,
          onChanged: (value) {
            final newSettings = ramadanSettings.copyWith(includeDuas: value);
            ref
                .read(athanSettingsProvider.notifier)
                .updateRamadanSettings(newSettings);
          },
          secondary: Icon(Icons.favorite, color: Colors.purple[600]),
        ),
        SwitchListTile(
          title: Text(l10n.prayerTrackFasting),
          subtitle: Text(l10n.prayerTrackFastingSubtitle),
          value: ramadanSettings.trackFasting,
          onChanged: (value) {
            final newSettings = ramadanSettings.copyWith(trackFasting: value);
            ref
                .read(athanSettingsProvider.notifier)
                .updateRamadanSettings(newSettings);
          },
          secondary: Icon(Icons.check_circle, color: Colors.purple[600]),
        ),
      ],
    );
  }

  Widget _buildErrorView(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.errorUnableToLoadSettings,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error.toString(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => ref.refresh(athanSettingsProvider),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeRangeDialog(AthanSettings settings) {
    // Show dialog to add mute time range
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.athanSettingsAddMuteTimeRange),
        content: const Text('Feature coming soon...'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.commonClose),
          ),
        ],
      ),
    );
  }

  // Test section removed for production
  Widget _buildTestSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🧪 Test Section (Debug)',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.orange,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final audioNotifier =
                          ref.read(athanAudioProvider.notifier);
                      await audioNotifier.previewAthan('abdulbasit');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Athan audio test started')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Athan test failed: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Test Athan Audio'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final scheduler =
                          ref.read(dailyNotificationSchedulerProvider);
                      await scheduler.scheduleToday(
                          force: true); // Force reschedule for testing
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Notifications scheduled for today')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Scheduling failed: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.schedule),
                  label: const Text('Schedule Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final permissions =
                          ref.read(notificationPermissionsProvider);
                      final settings = ref.read(athanSettingsProvider);
                      final prayerTimes = ref.read(currentPrayerTimesProvider);

                      String info =
                          'Permissions: ${permissions.notificationPermission}, ${permissions.exactAlarmPermission}\n';
                      info +=
                          'Settings enabled: ${settings.value?.isEnabled ?? 'loading'}\n';
                      info +=
                          'Prayer times: ${prayerTimes.value?.fajr.time ?? 'loading'}';

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(info),
                            duration: const Duration(seconds: 5)),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Debug failed: $e')),
                      );
                    }
                  },
                  icon: const Icon(Icons.info),
                  label: const Text('Debug Info'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                // Test immediate notification using the service's public methods
                final service = ref.read(notificationServiceProvider);
                await service.initialize();

                // Use the existing prayer notification scheduling with a test time
                final testPrayerTimes =
                    await ref.read(currentPrayerTimesProvider.future);
                final testSettingsAsync = ref.read(athanSettingsProvider);
                final testSettings = await testSettingsAsync.when(
                  data: (settings) => settings,
                  loading: () => throw Exception('Settings still loading'),
                  error: (error, stack) =>
                      throw Exception('Settings error: $error'),
                );

                // Schedule notifications for today (this will include any future prayers)
                await service.scheduleDailyPrayerNotifications(
                    testPrayerTimes, testSettings);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content:
                          Text('Prayer notifications scheduled for today')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Test notification failed: $e')),
                );
              }
            },
            icon: const Icon(Icons.notification_add),
            label: const Text('Schedule Prayer Notifications'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                // Show notification immediately instead of scheduling
                final flutterLocalNotificationsPlugin =
                    FlutterLocalNotificationsPlugin();

                const androidDetails = AndroidNotificationDetails(
                  'athan_notifications',
                  'Athan (Call to Prayer)',
                  channelDescription:
                      'Call to prayer notifications when prayer time arrives',
                  importance: Importance.max,
                  priority: Priority.max,
                  playSound: true,
                );

                const notificationDetails = NotificationDetails(
                  android: androidDetails,
                );

                await flutterLocalNotificationsPlugin.show(
                  9998, // Unique ID
                  '🕌 Test Prayer (1 sec)',
                  'This is a test prayer notification',
                  notificationDetails,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Test notification sent immediately!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Test notification failed: $e')),
                );
              }
            },
            icon: const Icon(Icons.flash_on),
            label: const Text('Test Notification (1 sec)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                // Show notification immediately instead of scheduling
                final flutterLocalNotificationsPlugin =
                    FlutterLocalNotificationsPlugin();

                const androidDetails = AndroidNotificationDetails(
                  'athan_notifications',
                  'Athan (Call to Prayer)',
                  channelDescription:
                      'Call to prayer notifications when prayer time arrives',
                  importance: Importance.max,
                  priority: Priority.max,
                  playSound: true,
                );

                const notificationDetails = NotificationDetails(
                  android: androidDetails,
                );

                await flutterLocalNotificationsPlugin.show(
                  9997, // Unique ID
                  '🕌 Demo Prayer (2 min)',
                  'This is a demo prayer notification with Azan',
                  notificationDetails,
                );

                // Also play Azan audio
                try {
                  final service = ref.read(notificationServiceProvider);
                  final currentSettings =
                      ref.read(athanSettingsProvider).value ??
                          const AthanSettings();
                  await service.playAthan('abdulbasit', 1.0,
                      durationSeconds: currentSettings.durationSeconds);
                } catch (e) {
                  print('Failed to play Azan: $e');
                }

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Demo notification sent! Azan should play now.'),
                    duration: const Duration(seconds: 3),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Demo notification failed: $e')),
                );
              }
            },
            icon: const Icon(Icons.timer),
            label: const Text('Demo Notification (2 min)'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () async {
              try {
                // Test immediate notification without scheduling
                final service = ref.read(notificationServiceProvider);
                await service.initialize();

                // Show notification immediately using a simple approach
                final flutterLocalNotificationsPlugin =
                    FlutterLocalNotificationsPlugin();

                const androidDetails = AndroidNotificationDetails(
                  'athan_notifications',
                  'Athan (Call to Prayer)',
                  channelDescription:
                      'Call to prayer notifications when prayer time arrives',
                  importance: Importance.max,
                  priority: Priority.max,
                  playSound: true,
                );

                const notificationDetails = NotificationDetails(
                  android: androidDetails,
                );

                await flutterLocalNotificationsPlugin.show(
                  9999, // Unique ID
                  '🕌 Immediate Test',
                  'This is an immediate test notification',
                  notificationDetails,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Immediate notification sent!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Immediate notification failed: $e')),
                );
              }
            },
            icon: const Icon(Icons.notification_important),
            label: const Text('Immediate Notification'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

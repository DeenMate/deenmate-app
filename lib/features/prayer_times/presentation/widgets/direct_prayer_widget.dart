import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';

import '../../../../core/state/prayer_settings_state.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/datasources/aladhan_api.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/prayer_calculation_settings.dart';
import '../providers/prayer_times_providers.dart';

class DirectPrayerWidget extends ConsumerStatefulWidget {
  const DirectPrayerWidget({super.key});

  @override
  ConsumerState<DirectPrayerWidget> createState() => _DirectPrayerWidgetState();
}

class _DirectPrayerWidgetState extends ConsumerState<DirectPrayerWidget> {
  String? currentPrayer;
  String? nextPrayer;
  String? remainingTime;
  String? calculationMethod;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadPrayerData();
    // React to calculation method/madhab changes from Settings
    ref.listen<AsyncValue<PrayerCalculationSettings>>(
      prayerSettingsProvider,
      (previous, next) {
        if (mounted && next.hasValue) {
          _loadPrayerData();
        }
      },
    );
  }

  String _getLocalizedPrayerName(String? prayerName) {
    if (prayerName == null) return 'None';
    switch (prayerName) {
      case 'Fajr':
        return AppLocalizations.of(context)!.prayerFajr;
      case 'Sunrise':
        return AppLocalizations.of(context)!.prayerSunrise;
      case 'Dhuhr':
        return AppLocalizations.of(context)!.prayerDhuhr;
      case 'Asr':
        return AppLocalizations.of(context)!.prayerAsr;
      case 'Maghrib':
        return AppLocalizations.of(context)!.prayerMaghrib;
      case 'Isha':
        return AppLocalizations.of(context)!.prayerIsha;
      default:
        return prayerName;
    }
  }

  Future<void> _loadPrayerData() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      // Load calculation method from global state
      await PrayerSettingsState.instance.loadSettings();
      final method = PrayerSettingsState.instance.calculationMethod;

      setState(() {
        calculationMethod = method;
      });

      // Create API instance
      final api = AladhanApi(Dio());

      // Production TODO: Integrate with proper location service (using respectful default)
      final location = Location(
        latitude: 21.4225,
        longitude: 39.8262,
        country: 'Saudi Arabia',
        city: 'Mecca',
        region: 'Makkah Province',
        timezone: 'Asia/Riyadh',
      );

      // Create settings
      final settings = PrayerCalculationSettings(
        calculationMethod: method,
        madhab: Madhab.shafi,
      );

      print('DirectPrayerWidget: Calling API with method: $method');

      // Call API directly
      final prayerTimes = await api.getPrayerTimes(
        date: DateTime.now(),
        location: location,
        settings: settings,
      );

      // Calculate current and next prayer
      final now = DateTime.now();
      final prayers = [
        {'name': 'Fajr', 'time': prayerTimes.fajr.time},
        {'name': 'Sunrise', 'time': prayerTimes.sunrise.time},
        {'name': 'Dhuhr', 'time': prayerTimes.dhuhr.time},
        {'name': 'Asr', 'time': prayerTimes.asr.time},
        {'name': 'Maghrib', 'time': prayerTimes.maghrib.time},
        {'name': 'Isha', 'time': prayerTimes.isha.time},
      ];

      String? current;
      String? next;
      Duration? remaining;

      for (int i = 0; i < prayers.length; i++) {
        final prayer = prayers[i];
        if (now.isBefore(prayer['time'] as DateTime)) {
          next = prayer['name'] as String;
          if (i > 0) {
            current = prayers[i - 1]['name'] as String;
          }
          remaining = (prayer['time'] as DateTime).difference(now);
          break;
        }
      }

      if (next == null) {
        current = 'Isha';
      }

      setState(() {
        currentPrayer = current;
        nextPrayer = next;
        remainingTime = remaining != null
            ? '${remaining.inHours}h ${remaining.inMinutes % 60}m'
            : null;
        isLoading = false;
      });

      print(
          'DirectPrayerWidget: Current: $current, Next: $next, Remaining: $remainingTime');
    } catch (e) {
      setState(() {
        error = AppLocalizations.of(context)!.errorPrayerTimesLoading;
        isLoading = false;
      });
      print('DirectPrayerWidget: Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1565C0),
              Color(0xFF42A5F5),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Direct Prayer Data',
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Method: ${calculationMethod ?? AppLocalizations.of(context)!.commonLoading}',
                  style: GoogleFonts.notoSans(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            if (isLoading)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            else if (error != null)
              Text(
                error!,
                style: GoogleFonts.notoSans(
                  color: Colors.red[100],
                  fontSize: 14,
                ),
              )
            else ...[
              // Current Prayer
              Text(
                '${AppLocalizations.of(context)!.currentPrayer}: ${_getLocalizedPrayerName(currentPrayer)}',
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // Next Prayer
              Text(
                '${AppLocalizations.of(context)!.nextPrayer}: ${_getLocalizedPrayerName(nextPrayer)}',
                style: GoogleFonts.notoSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              // Remaining Time
              if (remainingTime != null)
                Text(
                  '${AppLocalizations.of(context)!.prayerTimeRemaining}: $remainingTime',
                  style: GoogleFonts.notoSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],

            const SizedBox(height: 16),

            // Refresh Button
            ElevatedButton(
              onPressed: _loadPrayerData,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1565C0),
              ),
              child: Text(AppLocalizations.of(context)!.prayerTimeRefresh),
            ),
          ],
        ),
      ),
    );
  }
}

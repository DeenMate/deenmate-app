import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../../core/utils/islamic_utils.dart';
import '../providers/prayer_times_providers.dart';
import '../../domain/entities/prayer_times.dart';

/// Production Prayer Times Screen matching app-screens/02_prayer_times_screen.svg
/// Features: Live countdown, Islamic design, Bengali integration, prayer tracking
class PrayerTimesProductionScreen extends ConsumerStatefulWidget {
  const PrayerTimesProductionScreen({super.key});

  @override
  ConsumerState<PrayerTimesProductionScreen> createState() => _PrayerTimesProductionScreenState();
}

class _PrayerTimesProductionScreenState extends ConsumerState<PrayerTimesProductionScreen>
    with TickerProviderStateMixin {
  late Timer _countdownTimer;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  
  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    
    // Update countdown every second
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }
  
  @override
  void dispose() {
    _countdownTimer.cancel();
    _fadeController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeController,
              child: Column(
                children: [
                  _buildDateHeader(),
                  const SizedBox(height: 16),
                  _buildCurrentPrayerCard(),
                  const SizedBox(height: 16),
                  _buildUpcomingPrayersSection(),
                  const SizedBox(height: 16),
                  _buildTodaysProgressCard(),
                  const SizedBox(height: 16),
                  _buildLocationInfoCard(),
                  const SizedBox(height: 100), // Bottom padding for navigation
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        AppLocalizations.of(context)!.prayerTimesTitle,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            // Navigate to prayer settings
          },
        ),
      ],
    );
  }

  Widget _buildDateHeader() {
    final today = DateTime.now();
    final hijriDate = _getHijriDate(today);
    final banglaDate = _getBanglaDate(today);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.commonToday,
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _formatEnglishDate(today),
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  hijriDate,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  banglaDate,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Center(
              child: Text(
                '🌙',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPrayerCard() {
    final prayerTimesAsync = ref.watch(currentPrayerTimesProvider);
    
    return prayerTimesAsync.when(
      data: (prayerTimes) => _buildCurrentPrayerCardContent(prayerTimes),
      loading: () => _buildLoadingPrayerCard(),
      error: (error, stackTrace) => _buildEnhancedErrorCard(error),
    );
  }
  
  Widget _buildEnhancedErrorCard(Object error) {
    String title = AppLocalizations.of(context)!.prayerTimesUnavailable;
    String subtitle = AppLocalizations.of(context)!.prayerTimesUnableToLoad;
    String actionText = AppLocalizations.of(context)!.prayerTimesRetry;
    IconData icon = Icons.error_outline;
    Color iconColor = const Color(0xFFFF5722);
    VoidCallback? onActionPressed;

    // Determine error type and provide specific guidance
    if (error.toString().contains('location') || 
        error.toString().contains('permission')) {
      title = AppLocalizations.of(context)!.prayerTimesLocationRequired;
      subtitle = AppLocalizations.of(context)!.prayerTimesEnableLocation;
      actionText = AppLocalizations.of(context)!.prayerTimesEnableLocationAction;
      icon = Icons.location_off;
      iconColor = const Color(0xFFFF8F00);
      onActionPressed = () {
        // Navigate to location settings or show location picker
        _showLocationHelp();
      };
    } else if (error.toString().contains('network') || 
               error.toString().contains('timeout')) {
      title = AppLocalizations.of(context)!.prayerTimesNetworkIssue;
      subtitle = AppLocalizations.of(context)!.prayerTimesCheckConnection;
      actionText = AppLocalizations.of(context)!.prayerTimesRetry;
      icon = Icons.wifi_off;
      iconColor = const Color(0xFF2196F3);
      onActionPressed = () {
        // Refresh the provider
        ref.invalidate(currentPrayerTimesProvider);
      };
    } else {
      title = AppLocalizations.of(context)!.prayerTimesServiceUnavailable;
      subtitle = AppLocalizations.of(context)!.prayerTimesServiceTemporarilyUnavailable;
      actionText = AppLocalizations.of(context)!.prayerTimesTryAgain;
      icon = Icons.refresh;
      onActionPressed = () {
        ref.invalidate(currentPrayerTimesProvider);
      };
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: iconColor.withValues(alpha: 0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
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
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF666666),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (onActionPressed != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(actionText),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showLocationHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.prayerTimesLocationAccess),
        content: Text(AppLocalizations.of(context)!.prayerTimesLocationAccessMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.prayerTimesLater),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to settings or manual location picker
            },
            child: Text(AppLocalizations.of(context)!.prayerTimesSettings),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCurrentPrayerCardContent(PrayerTimes? prayerTimes) {
    if (prayerTimes == null) {
      return _buildEnhancedErrorCard(AppLocalizations.of(context)!.prayerTimesDataUnavailable);
    }
    
    final now = DateTime.now();
    final currentPrayer = _getCurrentPrayer(prayerTimes, now);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0x1A2E7D32),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2E7D32), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                currentPrayer['icon'],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currentPrayer['name'],
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentPrayer['time'],
                  style: const TextStyle(
                    color: Color(0xFF333333),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  currentPrayer['status'],
                  style: TextStyle(
                    color: currentPrayer['statusColor'],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.prayerTimesNextIn,
                style: const TextStyle(
                  color: Color(0xFF2E7D32),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 1.0 + 0.1 * _pulseController.value,
                    child: Text(
                      _getTimeUntilNextPrayer(),
                      style: const TextStyle(
                        color: Color(0xFF2E7D32),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildLoadingPrayerCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          CircularProgressIndicator(),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Loading Prayer Times...',
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)!.prayerTimesPleaseWait,
                  style: const TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Map<String, dynamic> _getCurrentPrayer(PrayerTimes prayerTimes, DateTime now) {
    final l10n = AppLocalizations.of(context)!;
    final prayers = [
      {
        'name': l10n.prayerFajr,
        'time': prayerTimes.fajr.time,
        'icon': '🌅',
        'bengaliName': l10n.prayerFajr,
      },
      {
        'name': l10n.prayerDhuhr,
        'time': prayerTimes.dhuhr.time,
        'icon': '☀️',
        'bengaliName': l10n.prayerDhuhr,
      },
      {
        'name': l10n.prayerAsr,
        'time': prayerTimes.asr.time,
        'icon': '🌤',
        'bengaliName': l10n.prayerAsr,
      },
      {
        'name': l10n.prayerMaghrib,
        'time': prayerTimes.maghrib.time,
        'icon': '🌆',
        'bengaliName': l10n.prayerMaghrib,
      },
      {
        'name': l10n.prayerIsha,
        'time': prayerTimes.isha.time,
        'icon': '🌙',
        'bengaliName': l10n.prayerIsha,
      },
    ];
    
    // Find the current prayer window or next upcoming prayer
    Map<String, dynamic> currentPrayer = prayers.first;
    
    // Look for active prayer window (between prayer time and next prayer time)
    for (int i = 0; i < prayers.length; i++) {
      final prayerTime = prayers[i]['time'] as DateTime;
      final nextPrayerTime = i < prayers.length - 1 
          ? prayers[i + 1]['time'] as DateTime
          : null;
      
      if (now.isAfter(prayerTime)) {
        if (nextPrayerTime == null || now.isBefore(nextPrayerTime)) {
          // We're in this prayer's active window
          currentPrayer = prayers[i];
          break;
        } else if (i == prayers.length - 1) {
          // After all prayers, show tomorrow's Fajr as upcoming
          currentPrayer = prayers[0];
          break;
        }
      } else {
        // This prayer is upcoming
        currentPrayer = prayers[i];
        break;
      }
    }

    final prayerTime = currentPrayer['time'] as DateTime;
    final timeString = _formatTime(prayerTime);
    
    // Determine prayer status with better logic
    String status;
    Color statusColor;
    
    // Check if this is tomorrow's Fajr (when current time is after Isha)
    final isTomorrowFajr = currentPrayer['name'] == AppLocalizations.of(context)!.prayerFajr && 
                           now.isAfter(prayerTimes.isha.time);
    
    if (isTomorrowFajr) {
      status = '🌅 Tomorrow | আগামীকাল';
      statusColor = const Color(0xFF1565C0);
    } else if (now.isBefore(prayerTime)) {
      // Prayer is upcoming
      final timeUntil = prayerTime.difference(now);
      if (timeUntil.inMinutes <= 30) {
        status = '⏰ Soon | শীঘ্রই (${timeUntil.inMinutes}min)';
        statusColor = const Color(0xFFFF8F00);
      } else {
        status = '⏳ Upcoming | আসন্ন';
        statusColor = const Color(0xFF1565C0);
      }
    } else {
      // Prayer time has passed - we're in the prayer window
      final nextPrayerTime = _getNextPrayerTime(prayerTimes, now);
      if (nextPrayerTime != null) {
        final timeSincePrayer = now.difference(prayerTime);
        if (timeSincePrayer.inMinutes <= 120) { // 2 hours active window
          status = '🕌 Active Time | সময় চলমান';
          statusColor = const Color(0xFF4CAF50);
        } else {
          status = '✓ Time Passed | সময় অতিক্রান্ত';
          statusColor = const Color(0xFF666666);
        }
      } else {
        status = '✓ Time Passed | সময় অতিক্রান্ত';
        statusColor = const Color(0xFF666666);
      }
    }
    
    return {
      'name': currentPrayer['name'],
      'time': timeString,
      'status': status,
      'statusColor': statusColor,
      'icon': currentPrayer['icon'],
    };
  }

  Widget _buildUpcomingPrayersSection() {
    final prayers = _getUpcomingPrayers();
    
    return Column(
      children: prayers.map((prayer) => Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: prayer['color'].withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                prayer['icon'],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          title: Text(
            prayer['name'],
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prayer['time'],
                style: const TextStyle(
                  color: Color(0xFF666666),
                  fontSize: 13,
                ),
              ),
              Text(
                prayer['remaining'],
                style: TextStyle(
                  color: prayer['color'],
                  fontSize: 11,
                ),
              ),
            ],
          ),
          trailing: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDDDDDD), width: 2),
            ),
          ),
        ),
      ),).toList(),
    );
  }

  Widget _buildTodaysProgressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Today's Progress | আজকের অগ্রগতি",
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildProgressItem(AppLocalizations.of(context)!.prayerStatsPrayers, '1/5', const Color(0xFF2E7D32)),
              const SizedBox(width: 16),
              _buildProgressItem(AppLocalizations.of(context)!.prayerStatsStreak, '7 days', const Color(0xFFFF8F00)),
              const SizedBox(width: 16),
              _buildProgressItem(AppLocalizations.of(context)!.prayerStatsMonth, '85%', const Color(0xFF1565C0)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationInfoCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📍 Dhaka, Bangladesh',
            style: TextStyle(
              color: Color(0xFF666666),
              fontSize: 12,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Calculation Method: Islamic Society of North America',
            style: TextStyle(
              color: Color(0xFF999999),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  String _getHijriDate(DateTime date) {
    // Use proper Hijri date calculation
    final hijriDate = IslamicUtils.getCurrentHijriDate();
    final weekdays = [AppLocalizations.of(context)!.weekdayMonday, AppLocalizations.of(context)!.weekdayTuesday, AppLocalizations.of(context)!.weekdayWednesday, AppLocalizations.of(context)!.weekdayThursday, AppLocalizations.of(context)!.weekdayFriday, AppLocalizations.of(context)!.weekdaySaturday, AppLocalizations.of(context)!.weekdaySunday];
    final weekday = weekdays[date.weekday - 1];
    final monthNames = [
      'Muharram', 'Safar', "Rabi' al-awwal", "Rabi' al-thani",
      'Jumada al-awwal', 'Jumada al-thani', 'Rajab', "Sha'ban",
      'Ramadan', 'Shawwal', "Dhu al-Qi'dah", 'Dhu al-Hijjah',
    ];
    final monthName = monthNames[hijriDate.hMonth - 1];
    return '$weekday, ${hijriDate.hDay} $monthName ${hijriDate.hYear}';
  }

  String _getBanglaDate(DateTime date) {
    // Use proper Hijri date for Bengali
    final hijriDate = IslamicUtils.getCurrentHijriDate();
    final bengaliHijriMonths = {
      1: 'মুহররম', 2: 'সফর', 3: 'রবিউল আউয়াল', 4: 'রবিউস সানি',
      5: 'জমাদিউল আউয়াল', 6: 'জমাদিউস সানি', 7: 'রজব', 8: 'শাবান',
      9: 'রমজান', 10: 'শাওয়াল', 11: 'জিলকদ', 12: 'জিলহজ',
    };
    final bengaliHijriMonth = bengaliHijriMonths[hijriDate.hMonth] ?? 'রমজান';
    return 'জুমা, ${hijriDate.hDay} $bengaliHijriMonth ${hijriDate.hYear}';
  }

  String _formatEnglishDate(DateTime date) {
    final weekdays = [AppLocalizations.of(context)!.weekdayMonday, AppLocalizations.of(context)!.weekdayTuesday, AppLocalizations.of(context)!.weekdayWednesday, AppLocalizations.of(context)!.weekdayThursday, AppLocalizations.of(context)!.weekdayFriday, AppLocalizations.of(context)!.weekdaySaturday, AppLocalizations.of(context)!.weekdaySunday];
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    
    return '${weekdays[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _getTimeUntilNextPrayer() {
    final prayerTimesAsync = ref.watch(currentPrayerTimesProvider);
    
    return prayerTimesAsync.when(
      data: (prayerTimes) {
        if (prayerTimes == null) return AppLocalizations.of(context)!.prayerTimesLocationRequired;
        
        final now = DateTime.now();
        final nextPrayer = _getNextPrayerTime(prayerTimes, now);
        
        if (nextPrayer == null) return AppLocalizations.of(context)!.prayerTimesLocationRequired;
        
        final difference = nextPrayer.difference(now);
        final hours = difference.inHours;
        final minutes = difference.inMinutes % 60;
        
        if (hours > 0) {
          return AppLocalizations.of(context)!.prayerRemainingIn(hours.toString(), minutes.toString());
        } else {
          return AppLocalizations.of(context)!.prayerRemainingInMinutes(minutes.toString());
        }
      },
      loading: () => AppLocalizations.of(context)!.commonLoading,
      error: (_, __) => AppLocalizations.of(context)!.prayerTimesLocationRequired,
    );
  }

  DateTime? _getNextPrayerTime(PrayerTimes prayerTimes, DateTime now) {
    final prayers = [
      prayerTimes.fajr.time,
      prayerTimes.dhuhr.time,
      prayerTimes.asr.time,
      prayerTimes.maghrib.time,
      prayerTimes.isha.time,
    ];
    
    // Find the next prayer time after now
    for (final prayer in prayers) {
      if (prayer.isAfter(now)) {
        return prayer;
      }
    }
    
    // If all prayers have passed, calculate tomorrow's Fajr
    // Use approximate calculation: add 24 hours to today's Fajr as baseline
    final tomorrowFajr = DateTime(
      prayerTimes.fajr.time.year,
      prayerTimes.fajr.time.month,
      prayerTimes.fajr.time.day + 1,
      prayerTimes.fajr.time.hour,
      prayerTimes.fajr.time.minute,
    );
    
    return tomorrowFajr;
  }

  List<Map<String, dynamic>> _getUpcomingPrayers() {
    final prayerTimesAsync = ref.watch(currentPrayerTimesProvider);
    
    return prayerTimesAsync.when(
      data: (prayerTimes) {
        if (prayerTimes == null) {
          return [
            {
              'name': AppLocalizations.of(context)!.prayerTimesUnavailable,
              'time': AppLocalizations.of(context)!.prayerTimesLocationAccess,
              'remaining': AppLocalizations.of(context)!.prayerTimesEnableLocationAction,
              'icon': '📍',
              'color': const Color(0xFF999999),
            }
          ];
        }
        
        final now = DateTime.now();
        final upcomingPrayers = <Map<String, dynamic>>[];
        
        final prayerData = [
          {
            'name': '${AppLocalizations.of(context)!.prayerFajr} | ফজর',
            'time': prayerTimes.fajr.time,
            'icon': '🌅',
            'color': const Color(0xFF2E7D32),
          },
          {
            'name': '${AppLocalizations.of(context)!.prayerDhuhr} | যুহর',
            'time': prayerTimes.dhuhr.time,
            'icon': '☀️',
            'color': const Color(0xFFFF8F00),
          },
          {
            'name': '${AppLocalizations.of(context)!.prayerAsr} | আসর',
            'time': prayerTimes.asr.time,
            'icon': '🌤',
            'color': const Color(0xFF7B1FA2),
          },
          {
            'name': '${AppLocalizations.of(context))!.prayerMaghrib} | মাগরিব',
            'time': prayerTimes.maghrib.time,
            'icon': '🌆',
            'color': const Color(0xFFD84315),
          },
          {
            'name': '${AppLocalizations.of(context)!.prayerIsha} | ইশা',
            'time': prayerTimes.isha.time,
            'icon': '🌙',
            'color': const Color(0xFF5D4037),
          },
        ];
        
        for (final prayer in prayerData) {
          final prayerTime = prayer['time'] as DateTime;
          if (prayerTime.isAfter(now)) {
            final difference = prayerTime.difference(now);
            final hours = difference.inHours;
            final minutes = difference.inMinutes % 60;
            
            String remaining;
            if (hours > 0) {
              remaining = AppLocalizations.of(context)!.prayerRemainingIn(hours.toString(), minutes.toString());
            } else {
              remaining = AppLocalizations.of(context)!.prayerRemainingInMinutes(minutes.toString());
            }
            
            upcomingPrayers.add({
              'name': prayer['name'],
              'time': _formatTime(prayerTime),
              'remaining': remaining,
              'icon': prayer['icon'],
              'color': prayer['color'],
            });
          }
        }
        
        return upcomingPrayers;
      },
      loading: () => [
        {
          'name': AppLocalizations.of(context)!.prayerTimesLoading,
          'time': AppLocalizations.of(context)!.commonPleaseWait,
          'remaining': AppLocalizations.of(context)!.commonLoading,
          'icon': '⏳',
          'color': const Color(0xFF999999),
        }
      ],
      error: (_, __) => [
        {
          'name': AppLocalizations.of(context)!.prayerTimesError,
          'time': AppLocalizations.of(context)!.prayerTimesLocationAccess,
          'remaining': AppLocalizations.of(context)!.prayerTimesRetry,
          'icon': '⚠️',
          'color': const Color(0xFFE53935),
        }
      ],
    );
  }
  
  String _formatTime(DateTime time) {
    final hour = time.hour;
    final minute = time.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : hour == 0 ? 12 : hour;
    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}

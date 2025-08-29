import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/providers.dart';
import '../../domain/services/audio_service.dart';

/// Mobile Audio Configuration
/// Central configuration for mobile-optimized audio behavior
class MobileAudioConfig {
  const MobileAudioConfig({
    this.enableHapticFeedback = true,
    this.autoMinimizeOnBackground = true,
    this.showDownloadPrompts = true,
    this.gestureSeekSensitivity = 10.0,
    this.volumeGestureSensitivity = 100.0,
    this.minimizedPlayerHeight = 80.0,
    this.expandedPlayerHeight = 300.0,
    this.animationDuration = const Duration(milliseconds: 300),
    this.enableOfflineMode = true,
    this.autoDownloadOnPlay = false,
    this.maxCacheSize = 500, // MB
  });

  final bool enableHapticFeedback;
  final bool autoMinimizeOnBackground;
  final bool showDownloadPrompts;
  final double gestureSeekSensitivity;
  final double volumeGestureSensitivity;
  final double minimizedPlayerHeight;
  final double expandedPlayerHeight;
  final Duration animationDuration;
  final bool enableOfflineMode;
  final bool autoDownloadOnPlay;
  final int maxCacheSize;
}

/// Mobile Audio Config Provider
final mobileAudioConfigProvider = Provider<MobileAudioConfig>((ref) {
  return const MobileAudioConfig();
});

/// Mobile Audio Manager Integration Extensions
/// Helper methods for integrating mobile audio throughout the app
extension MobileAudioIntegration on ConsumerWidget {
  /// Add mobile audio manager to any screen
  Widget withMobileAudio({
    required Widget child,
    bool showFloatingPlayer = true,
    bool enableGlobalGestures = false,
  }) {
    return Consumer(
      builder: (context, ref, _) {
        return MobileAudioManager(
          showFloatingPlayer: showFloatingPlayer,
          enableGlobalGestures: enableGlobalGestures,
          child: child,
        );
      },
    );
  }
}

/// Mobile Audio Theme Configuration
class MobileAudioTheme {
  const MobileAudioTheme({
    this.primaryColor = const Color(0xFF2E7D32),
    this.accentColor = const Color(0xFF4CAF50),
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.surfaceColor = Colors.white,
    this.textColor = const Color(0xFF212121),
    this.iconColor = const Color(0xFF757575),
    this.borderRadius = 12.0,
    this.elevation = 4.0,
  });

  final Color primaryColor;
  final Color accentColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textColor;
  final Color iconColor;
  final double borderRadius;
  final double elevation;

  ThemeData get materialTheme => ThemeData(
    primarySwatch: Colors.green,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    cardTheme: CardTheme(
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
  );
}

final mobileAudioThemeProvider = Provider<MobileAudioTheme>((ref) {
  return const MobileAudioTheme();
});

/// Mobile Audio Error Handling
class MobileAudioErrorHandler {
  static void handleAudioError({
    required BuildContext context,
    required Object error,
    String? customMessage,
  }) {
    String message = customMessage ?? _getErrorMessage(error);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            // Retry logic would go here
          },
        ),
      ),
    );
  }

  static String _getErrorMessage(Object error) {
    if (error is AudioException) {
      switch (error.type) {
        case AudioExceptionType.networkError:
          return 'Network error. Please check your connection.';
        case AudioExceptionType.fileNotFound:
          return 'Audio file not found. Please download first.';
        case AudioExceptionType.permissionDenied:
          return 'Permission denied. Please check app permissions.';
        case AudioExceptionType.unsupportedFormat:
          return 'Unsupported audio format.';
        case AudioExceptionType.unknown:
        default:
          return 'An unknown audio error occurred.';
      }
    }
    return 'Audio playback failed: ${error.toString()}';
  }
}

/// Mobile Audio Analytics
/// Track mobile audio usage for optimization
class MobileAudioAnalytics {
  static final Map<String, int> _usageStats = {};
  
  static void trackPlayback({
    required String verseKey,
    required String reciter,
    required bool isOnline,
  }) {
    final key = 'playback_${verseKey}_${reciter}_${isOnline ? 'online' : 'offline'}';
    _usageStats[key] = (_usageStats[key] ?? 0) + 1;
  }
  
  static void trackGesture({required String gestureType}) {
    final key = 'gesture_$gestureType';
    _usageStats[key] = (_usageStats[key] ?? 0) + 1;
  }
  
  static void trackDownload({
    required String verseKey,
    required bool success,
  }) {
    final key = 'download_${verseKey}_${success ? 'success' : 'failure'}';
    _usageStats[key] = (_usageStats[key] ?? 0) + 1;
  }
  
  static Map<String, int> getUsageStats() => Map.from(_usageStats);
  
  static void clearStats() => _usageStats.clear();
}

/// Mobile Audio Performance Monitor
class MobileAudioPerformanceMonitor {
  static final List<Duration> _loadTimes = [];
  static final List<Duration> _seekTimes = [];
  
  static void recordLoadTime(Duration duration) {
    _loadTimes.add(duration);
    if (_loadTimes.length > 100) {
      _loadTimes.removeAt(0); // Keep only last 100 measurements
    }
  }
  
  static void recordSeekTime(Duration duration) {
    _seekTimes.add(duration);
    if (_seekTimes.length > 100) {
      _seekTimes.removeAt(0);
    }
  }
  
  static double get averageLoadTime {
    if (_loadTimes.isEmpty) return 0.0;
    final total = _loadTimes.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
    return total / _loadTimes.length;
  }
  
  static double get averageSeekTime {
    if (_seekTimes.isEmpty) return 0.0;
    final total = _seekTimes.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
    return total / _seekTimes.length;
  }
  
  static Map<String, dynamic> getPerformanceReport() => {
    'avgLoadTimeMs': averageLoadTime,
    'avgSeekTimeMs': averageSeekTime,
    'totalLoadSamples': _loadTimes.length,
    'totalSeekSamples': _seekTimes.length,
  };
}

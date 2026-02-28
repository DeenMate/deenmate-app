import 'package:flutter/foundation.dart';

/// Lightweight structured logger wrapping [debugPrint] with level filtering.
///
/// Usage:
/// ```dart
/// AppLogger.info('PrayerService', 'Scheduled 5 notifications');
/// AppLogger.warning('AudioPlayer', 'Fallback path used for athan');
/// AppLogger.error('NotificationService', 'Failed to show notification', error: e);
/// ```
///
/// In release builds, all output is suppressed via [kDebugMode] guard.
class AppLogger {
  AppLogger._();

  /// Log an informational message.
  static void info(String tag, String message) {
    if (kDebugMode) {
      debugPrint('[$tag] INFO: $message');
    }
  }

  /// Log a warning (non-fatal issue, degraded behavior).
  static void warning(String tag, String message, {Object? error}) {
    if (kDebugMode) {
      final suffix = error != null ? ' | $error' : '';
      debugPrint('[$tag] WARN: $message$suffix');
    }
  }

  /// Log an error (operation failed, caught exception).
  static void error(String tag, String message,
      {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      debugPrint('[$tag] ERROR: $message | $error');
      if (stackTrace != null) {
        debugPrint('[$tag] STACK: $stackTrace');
      }
    }
  }
}

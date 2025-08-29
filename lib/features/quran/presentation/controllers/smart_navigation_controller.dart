import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/storage/hive_boxes.dart' as boxes;
import '../widgets/mobile_quran_navigation_bar.dart';

/// Smart navigation controller for context-aware Quran reading navigation
/// Handles position mapping between different navigation modes and provides recommendations
class SmartNavigationController extends StateNotifier<SmartNavigationState> {
  SmartNavigationController() : super(const SmartNavigationState());

  /// Maps a verse position to equivalent positions in different navigation modes
  QuranPositionMap mapVerseToAllModes(int chapterId, int verseNumber) {
    // For now, using simplified mapping - in production this would use actual Quran data
    final currentVerse = VersePosition(chapterId: chapterId, verseNumber: verseNumber);
    
    return QuranPositionMap(
      verse: currentVerse,
      page: _calculatePageFromVerse(chapterId, verseNumber),
      juz: _calculateJuzFromVerse(chapterId, verseNumber),
      hizb: _calculateHizbFromVerse(chapterId, verseNumber),
      ruku: _calculateRukuFromVerse(chapterId, verseNumber),
    );
  }

  /// Suggests the best navigation mode based on user reading patterns
  QuranNavigationMode suggestOptimalMode(int chapterId, int verseNumber) {
    final readingHistory = _getReadingHistory();
    
    // Analyze reading patterns to suggest optimal mode
    if (readingHistory.isNotEmpty) {
      final mostUsedMode = _getMostUsedNavigationMode(readingHistory);
      
      // Consider reading length preferences
      if (_isLongReadingSession(readingHistory)) {
        return QuranNavigationMode.page; // Page mode for long sessions
      }
      
      // Consider chapter-based reading patterns
      if (_isChapterBasedReader(readingHistory)) {
        return QuranNavigationMode.surah; // Surah mode for chapter readers
      }
      
      return mostUsedMode;
    }
    
    // Default recommendation for new users
    return QuranNavigationMode.surah;
  }

  /// Restores last reading position with smart mode suggestion
  LastReadingPosition? getLastReadingPosition() {
    final box = Hive.box(boxes.Boxes.prefs);
    final lastChapter = box.get('last_chapter_id');
    final lastVerse = box.get('last_verse_number');
    final lastMode = box.get('last_navigation_mode');
    
    if (lastChapter != null && lastVerse != null) {
      final position = mapVerseToAllModes(lastChapter, lastVerse);
      final suggestedMode = suggestOptimalMode(lastChapter, lastVerse);
      
      return LastReadingPosition(
        position: position,
        lastUsedMode: QuranNavigationMode.values.firstWhere(
          (mode) => mode.toString() == lastMode,
          orElse: () => QuranNavigationMode.surah,
        ),
        suggestedMode: suggestedMode,
        timestamp: DateTime.now(),
      );
    }
    
    return null;
  }

  /// Saves current reading position and navigation mode
  void saveReadingPosition(int chapterId, int verseNumber, QuranNavigationMode mode) {
    final box = Hive.box(boxes.Boxes.prefs);
    box
      ..put('last_chapter_id', chapterId)
      ..put('last_verse_number', verseNumber)
      ..put('last_navigation_mode', mode.toString())
      ..put('last_reading_timestamp', DateTime.now().millisecondsSinceEpoch);
    
    // Track navigation mode usage for pattern analysis
    _trackNavigationModeUsage(mode);
  }

  /// Updates reading session data for pattern analysis
  void trackReadingSession(QuranNavigationMode mode, Duration sessionLength) {
    final box = Hive.box(boxes.Boxes.prefs);
    final sessions = box.get('reading_sessions', defaultValue: <Map<String, dynamic>>[]) as List;
    
    sessions.add({
      'mode': mode.toString(),
      'duration_minutes': sessionLength.inMinutes,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
    
    // Keep only last 100 sessions for analysis
    if (sessions.length > 100) {
      sessions.removeRange(0, sessions.length - 100);
    }
    
    box.put('reading_sessions', sessions);
  }

  // Private helper methods for position calculations
  int _calculatePageFromVerse(int chapterId, int verseNumber) {
    // Simplified calculation - in production, use actual Quran page mapping
    return ((chapterId - 1) * 20 + verseNumber ~/ 10).clamp(1, 604);
  }

  int _calculateJuzFromVerse(int chapterId, int verseNumber) {
    // Simplified calculation - in production, use actual Juz boundaries
    return ((chapterId - 1) ~/ 9 + 1).clamp(1, 30);
  }

  int _calculateHizbFromVerse(int chapterId, int verseNumber) {
    // Simplified calculation - in production, use actual Hizb boundaries
    return ((chapterId - 1) ~/ 5 + 1).clamp(1, 60);
  }

  int _calculateRukuFromVerse(int chapterId, int verseNumber) {
    // Simplified calculation - in production, use actual Ruku boundaries
    return ((chapterId - 1) * 8 + verseNumber ~/ 5).clamp(1, 556);
  }

  List<Map<String, dynamic>> _getReadingHistory() {
    final box = Hive.box(boxes.Boxes.prefs);
    return (box.get('reading_sessions', defaultValue: <Map<String, dynamic>>[]) as List)
        .cast<Map<String, dynamic>>();
  }

  QuranNavigationMode _getMostUsedNavigationMode(List<Map<String, dynamic>> history) {
    final modeCount = <QuranNavigationMode, int>{};
    
    for (final session in history) {
      final modeString = session['mode'] as String?;
      if (modeString != null) {
        final mode = QuranNavigationMode.values.firstWhere(
          (m) => m.toString() == modeString,
          orElse: () => QuranNavigationMode.surah,
        );
        modeCount[mode] = (modeCount[mode] ?? 0) + 1;
      }
    }
    
    return modeCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  bool _isLongReadingSession(List<Map<String, dynamic>> history) {
    if (history.isEmpty) return false;
    
    final recentSessions = history.take(10);
    final avgDuration = recentSessions
        .map((s) => s['duration_minutes'] as int? ?? 0)
        .reduce((a, b) => a + b) / recentSessions.length;
    
    return avgDuration > 30; // Consider 30+ minutes as long sessions
  }

  bool _isChapterBasedReader(List<Map<String, dynamic>> history) {
    if (history.isEmpty) return false;
    
    final surahModeCount = history
        .where((s) => s['mode'] == QuranNavigationMode.surah.toString())
        .length;
    
    return surahModeCount > (history.length * 0.6); // 60% surah mode usage
  }

  void _trackNavigationModeUsage(QuranNavigationMode mode) {
    final box = Hive.box(boxes.Boxes.prefs);
    final usageKey = 'mode_usage_${mode.toString()}';
    final currentCount = box.get(usageKey, defaultValue: 0) as int;
    box.put(usageKey, currentCount + 1);
  }
}

/// State class for smart navigation
class SmartNavigationState {
  const SmartNavigationState({
    this.currentPosition,
    this.suggestedMode = QuranNavigationMode.surah,
    this.isLoading = false,
  });

  final QuranPositionMap? currentPosition;
  final QuranNavigationMode suggestedMode;
  final bool isLoading;

  SmartNavigationState copyWith({
    QuranPositionMap? currentPosition,
    QuranNavigationMode? suggestedMode,
    bool? isLoading,
  }) {
    return SmartNavigationState(
      currentPosition: currentPosition ?? this.currentPosition,
      suggestedMode: suggestedMode ?? this.suggestedMode,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Data models for position mapping
class QuranPositionMap {
  const QuranPositionMap({
    required this.verse,
    required this.page,
    required this.juz,
    required this.hizb,
    required this.ruku,
  });

  final VersePosition verse;
  final int page;
  final int juz;
  final int hizb;
  final int ruku;

  /// Gets the target identifier for a specific navigation mode
  int getTargetForMode(QuranNavigationMode mode) {
    switch (mode) {
      case QuranNavigationMode.surah:
        return verse.chapterId;
      case QuranNavigationMode.page:
        return page;
      case QuranNavigationMode.juz:
        return juz;
      case QuranNavigationMode.hizb:
        return hizb;
      case QuranNavigationMode.ruku:
        return ruku;
    }
  }
}

class VersePosition {
  const VersePosition({
    required this.chapterId,
    required this.verseNumber,
  });

  final int chapterId;
  final int verseNumber;

  String get verseKey => '$chapterId:$verseNumber';
}

class LastReadingPosition {
  const LastReadingPosition({
    required this.position,
    required this.lastUsedMode,
    required this.suggestedMode,
    required this.timestamp,
  });

  final QuranPositionMap position;
  final QuranNavigationMode lastUsedMode;
  final QuranNavigationMode suggestedMode;
  final DateTime timestamp;
}

/// Provider for smart navigation controller
final smartNavigationControllerProvider = 
    StateNotifierProvider<SmartNavigationController, SmartNavigationState>(
  (ref) => SmartNavigationController(),
);

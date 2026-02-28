import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/preference_keys.dart';

class PrayerSettingsState {
  static PrayerSettingsState? _instance;
  static PrayerSettingsState get instance =>
      _instance ??= PrayerSettingsState._();

  PrayerSettingsState._();

  String _calculationMethod = 'MWL';
  String _madhhab = 'shafi';

  String get calculationMethod => _calculationMethod;
  String get madhhab => _madhhab;

  Future<void> loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedMethod = prefs.getString(PreferenceKeys.calculationMethod);
      final savedMadhhab = prefs.getString(PreferenceKeys.madhhab);
      if (savedMethod != null) {
        _calculationMethod = savedMethod;
        debugPrint('PrayerSettingsState: Loaded method: $_calculationMethod');
      }
      if (savedMadhhab != null) {
        _madhhab = savedMadhhab;
        debugPrint('PrayerSettingsState: Loaded madhhab: $_madhhab');
      }
    } catch (e) {
      debugPrint('PrayerSettingsState: Error loading settings: $e');
    }
  }

  Future<void> setCalculationMethod(String method) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PreferenceKeys.calculationMethod, method);
      _calculationMethod = method;
      debugPrint('PrayerSettingsState: Saved method: $_calculationMethod');
    } catch (e) {
      debugPrint('PrayerSettingsState: Error saving settings: $e');
    }
  }

  Future<void> setMadhhab(String madhhab) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(PreferenceKeys.madhhab, madhhab);
      _madhhab = madhhab;
      debugPrint('PrayerSettingsState: Saved madhhab: $_madhhab');
    } catch (e) {
      debugPrint('PrayerSettingsState: Error saving madhhab: $e');
    }
  }

  Future<void> reset() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(PreferenceKeys.calculationMethod);
      await prefs.remove('onboarding_completed');
      await prefs.remove(PreferenceKeys.madhhab);
      _calculationMethod = 'MWL';
      _madhhab = 'shafi';
      debugPrint('PrayerSettingsState: Reset to default: $_calculationMethod');
    } catch (e) {
      debugPrint('PrayerSettingsState: Error resetting: $e');
    }
  }
}

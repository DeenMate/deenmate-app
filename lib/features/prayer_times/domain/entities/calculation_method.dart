import 'prayer_calculation_settings.dart';

/// Islamic prayer calculation methods
enum CalculationMethod {
  mwl('Muslim World League'),
  isna('Islamic Society of North America'),
  egypt('Egyptian General Authority of Survey'),
  makkah('Umm Al-Qura University, Makkah'),
  karachi('University of Islamic Sciences, Karachi'),
  tehran('Institute of Geophysics, University of Tehran'),
  jafari('Shia Ithna Ashari, Leva Research Institute, Qum');

  const CalculationMethod(this.displayName);
  final String displayName;

  /// Get the madhab (school of thought) for this method
  Madhab get madhab => Madhab.shafi; // Default to Shafi, can be overridden

  /// Get the organization behind this method
  String? get organization => null;

  /// Get the description of this method
  String get description => 'Standard Islamic prayer time calculation method';

  /// Get the Fajr angle for this method
  /// Each calculation method uses different astronomical angles for Fajr.
  /// Values sourced from official prayer time calculation standards:
  /// - MWL: Fajr 18°, Isha 17°
  /// - ISNA: Fajr 15°, Isha 15°
  /// - Egypt: Fajr 19.5°, Isha 17.5°
  /// - Makkah (Umm Al-Qura): Fajr 18.5°, Isha 90min interval
  /// - Karachi: Fajr 18°, Isha 18°
  /// - Tehran: Fajr 17.7°, Isha 14°
  /// - Jafari: Fajr 16°, Isha 14°
  double get fajrAngle {
    switch (this) {
      case CalculationMethod.mwl:
        return 18.0;
      case CalculationMethod.isna:
        return 15.0;
      case CalculationMethod.egypt:
        return 19.5;
      case CalculationMethod.makkah:
        return 18.5;
      case CalculationMethod.karachi:
        return 18.0;
      case CalculationMethod.tehran:
        return 17.7;
      case CalculationMethod.jafari:
        return 16.0;
    }
  }

  /// Get the Isha angle for this method
  /// Returns the angle used for Isha calculation.
  /// Note: Makkah (Umm Al-Qura) method uses a 90-minute interval after
  /// Maghrib instead of an angle; [ishaInterval] should be checked first.
  double get ishaAngle {
    switch (this) {
      case CalculationMethod.mwl:
        return 17.0;
      case CalculationMethod.isna:
        return 15.0;
      case CalculationMethod.egypt:
        return 17.5;
      case CalculationMethod.makkah:
        return 17.0; // Fallback; Makkah actually uses 90min interval
      case CalculationMethod.karachi:
        return 18.0;
      case CalculationMethod.tehran:
        return 14.0;
      case CalculationMethod.jafari:
        return 14.0;
    }
  }

  /// Get the Isha interval (in minutes) for methods that use a fixed
  /// time offset from Maghrib instead of an angle.
  /// Currently only Umm Al-Qura (Makkah) uses 90 minutes.
  /// Returns null for angle-based methods.
  int? get ishaInterval {
    switch (this) {
      case CalculationMethod.makkah:
        return 90;
      default:
        return null;
    }
  }

  /// Get the region this method is used in
  String? get region => null;

  /// Check if this is a custom method
  bool get isCustom => false;

  /// Get calculation method by name
  static CalculationMethod? fromName(String name) {
    try {
      return CalculationMethod.values.firstWhere((e) => e.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get recommended method for region
  static CalculationMethod getRecommendedForRegion(String country) {
    switch (country.toLowerCase()) {
      case 'saudi arabia':
      case 'united arab emirates':
      case 'qatar':
      case 'bahrain':
      case 'kuwait':
      case 'oman':
        return CalculationMethod.makkah;
      case 'united states':
      case 'canada':
        return CalculationMethod.isna;
      case 'egypt':
        return CalculationMethod.egypt;
      case 'pakistan':
        return CalculationMethod.karachi;
      case 'iran':
        return CalculationMethod.tehran;
      default:
        return CalculationMethod.mwl;
    }
  }
}

/// High latitude calculation methods for extreme locations
enum HighLatitudeMethod {
  /// Angle-based method (default)
  angleBased('AngleBased'),
  
  /// Seventh of the day/night
  seventhOfDay('SeventhOfDay'),
  
  /// Twilight angle method
  twilightAngle('TwilightAngle'),
  
  /// Middle of the night
  middleOfNight('MiddleOfNight');

  const HighLatitudeMethod(this.value);
  final String value;

  String get description {
    switch (this) {
      case HighLatitudeMethod.angleBased:
        return 'Standard angle-based calculation';
      case HighLatitudeMethod.seventhOfDay:
        return 'Divide night into seven parts';
      case HighLatitudeMethod.twilightAngle:
        return 'Use twilight angle for calculation';
      case HighLatitudeMethod.middleOfNight:
        return 'Calculate based on middle of night';
    }
  }
}

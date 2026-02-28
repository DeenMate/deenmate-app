import 'package:flutter_test/flutter_test.dart';
import 'package:deen_mate/features/prayer_times/domain/entities/calculation_method.dart';

/// Unit tests for CalculationMethod enum
/// Verifies that each calculation method returns the correct astronomical
/// angles used for Fajr and Isha prayer time calculations.
///
/// Reference values from official prayer time calculation standards:
/// - MWL (Muslim World League): Fajr 18°, Isha 17°
/// - ISNA (Islamic Society of North America): Fajr 15°, Isha 15°
/// - Egypt (Egyptian General Authority of Survey): Fajr 19.5°, Isha 17.5°
/// - Makkah (Umm Al-Qura University): Fajr 18.5°, Isha 90min interval
/// - Karachi (University of Islamic Sciences): Fajr 18°, Isha 18°
/// - Tehran (Institute of Geophysics): Fajr 17.7°, Isha 14°
/// - Jafari (Shia Ithna Ashari): Fajr 16°, Isha 14°
void main() {
  group('CalculationMethod Fajr angles', () {
    test('MWL returns Fajr angle 18.0°', () {
      expect(CalculationMethod.mwl.fajrAngle, 18.0);
    });

    test('ISNA returns Fajr angle 15.0°', () {
      expect(CalculationMethod.isna.fajrAngle, 15.0);
    });

    test('Egypt returns Fajr angle 19.5°', () {
      expect(CalculationMethod.egypt.fajrAngle, 19.5);
    });

    test('Makkah returns Fajr angle 18.5°', () {
      expect(CalculationMethod.makkah.fajrAngle, 18.5);
    });

    test('Karachi returns Fajr angle 18.0°', () {
      expect(CalculationMethod.karachi.fajrAngle, 18.0);
    });

    test('Tehran returns Fajr angle 17.7°', () {
      expect(CalculationMethod.tehran.fajrAngle, 17.7);
    });

    test('Jafari returns Fajr angle 16.0°', () {
      expect(CalculationMethod.jafari.fajrAngle, 16.0);
    });
  });

  group('CalculationMethod Isha angles', () {
    test('MWL returns Isha angle 17.0°', () {
      expect(CalculationMethod.mwl.ishaAngle, 17.0);
    });

    test('ISNA returns Isha angle 15.0°', () {
      expect(CalculationMethod.isna.ishaAngle, 15.0);
    });

    test('Egypt returns Isha angle 17.5°', () {
      expect(CalculationMethod.egypt.ishaAngle, 17.5);
    });

    test('Karachi returns Isha angle 18.0°', () {
      expect(CalculationMethod.karachi.ishaAngle, 18.0);
    });

    test('Tehran returns Isha angle 14.0°', () {
      expect(CalculationMethod.tehran.ishaAngle, 14.0);
    });

    test('Jafari returns Isha angle 14.0°', () {
      expect(CalculationMethod.jafari.ishaAngle, 14.0);
    });
  });

  group('CalculationMethod Isha interval (Umm Al-Qura)', () {
    test('Makkah uses 90-minute interval instead of angle', () {
      expect(CalculationMethod.makkah.ishaInterval, 90);
    });

    test('All other methods return null interval (angle-based)', () {
      for (final method in CalculationMethod.values) {
        if (method == CalculationMethod.makkah) continue;
        expect(
          method.ishaInterval,
          isNull,
          reason: '${method.name} should use angle, not interval',
        );
      }
    });
  });

  group('CalculationMethod angles are unique per method', () {
    test('Not all methods share the same Fajr angle', () {
      final fajrAngles =
          CalculationMethod.values.map((m) => m.fajrAngle).toSet();
      // There should be more than 1 unique Fajr angle
      expect(fajrAngles.length, greaterThan(1),
          reason: 'Different methods must have different Fajr angles');
    });

    test('Not all methods share the same Isha angle', () {
      final ishaAngles =
          CalculationMethod.values.map((m) => m.ishaAngle).toSet();
      expect(ishaAngles.length, greaterThan(1),
          reason: 'Different methods must have different Isha angles');
    });

    test('Every method has a positive Fajr angle', () {
      for (final method in CalculationMethod.values) {
        expect(method.fajrAngle, greaterThan(0),
            reason: '${method.name} Fajr angle must be positive');
        expect(method.fajrAngle, lessThanOrEqualTo(25),
            reason: '${method.name} Fajr angle must be <= 25°');
      }
    });

    test('Every method has a positive Isha angle', () {
      for (final method in CalculationMethod.values) {
        expect(method.ishaAngle, greaterThan(0),
            reason: '${method.name} Isha angle must be positive');
        expect(method.ishaAngle, lessThanOrEqualTo(25),
            reason: '${method.name} Isha angle must be <= 25°');
      }
    });
  });

  group('CalculationMethod.fromName', () {
    test('Returns correct method for valid name', () {
      expect(CalculationMethod.fromName('mwl'), CalculationMethod.mwl);
      expect(CalculationMethod.fromName('isna'), CalculationMethod.isna);
      expect(CalculationMethod.fromName('egypt'), CalculationMethod.egypt);
      expect(CalculationMethod.fromName('makkah'), CalculationMethod.makkah);
      expect(CalculationMethod.fromName('karachi'), CalculationMethod.karachi);
      expect(CalculationMethod.fromName('tehran'), CalculationMethod.tehran);
      expect(CalculationMethod.fromName('jafari'), CalculationMethod.jafari);
    });

    test('Returns null for invalid name', () {
      expect(CalculationMethod.fromName('invalid'), isNull);
      expect(CalculationMethod.fromName(''), isNull);
    });
  });

  group('CalculationMethod.getRecommendedForRegion', () {
    test('Returns Makkah for Gulf countries', () {
      expect(CalculationMethod.getRecommendedForRegion('Saudi Arabia'),
          CalculationMethod.makkah);
      expect(CalculationMethod.getRecommendedForRegion('United Arab Emirates'),
          CalculationMethod.makkah);
      expect(CalculationMethod.getRecommendedForRegion('Qatar'),
          CalculationMethod.makkah);
    });

    test('Returns ISNA for North America', () {
      expect(CalculationMethod.getRecommendedForRegion('United States'),
          CalculationMethod.isna);
      expect(CalculationMethod.getRecommendedForRegion('Canada'),
          CalculationMethod.isna);
    });

    test('Returns Karachi for Pakistan', () {
      expect(CalculationMethod.getRecommendedForRegion('Pakistan'),
          CalculationMethod.karachi);
    });

    test('Returns MWL as default for unknown regions', () {
      expect(CalculationMethod.getRecommendedForRegion('Unknown Country'),
          CalculationMethod.mwl);
    });
  });
}

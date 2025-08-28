# Prayer Times Feature Documentation

## 📋 Overview

The Prayer Times feature is the core functionality of DeenMate, providing accurate Islamic prayer time calculations based on user location and preferred calculation methods.

## 🏗️ Architecture

### File Structure
```
lib/features/prayer_times/
├── data/
│   ├── repositories/
│   │   └── prayer_repository_impl.dart
│   ├── datasources/
│   │   ├── prayer_api_datasource.dart
│   │   └── prayer_local_datasource.dart
│   └── models/
│       └── prayer_times_model.dart
├── domain/
│   ├── entities/
│   │   └── prayer_times.dart
│   ├── repositories/
│   │   └── prayer_repository.dart
│   └── usecases/
│       ├── get_prayer_times.dart
│       └── calculate_prayer_times.dart
└── presentation/
    ├── screens/
    │   └── prayer_times_screen.dart
    ├── widgets/
    │   ├── prayer_time_card.dart
    │   └── next_prayer_widget.dart
    └── providers/
        └── prayer_times_provider.dart
```

## 🕐 Prayer Time Calculation

### Calculation Methods
1. **Muslim World League** (Default)
2. **Egyptian General Authority of Survey**
3. **University of Islamic Sciences, Karachi**
4. **Umm Al-Qura University, Mecca**
5. **Islamic Society of North America (ISNA)**

### Implementation Details

#### Core Calculation Logic
```dart
class PrayerTimesCalculator {
  static PrayerTimes calculate({
    required double latitude,
    required double longitude,
    required DateTime date,
    required CalculationMethod method,
  }) {
    // Implementation uses astronomical algorithms
    // Based on Meeus's "Astronomical Algorithms"
  }
}
```

#### Key Algorithms
- **Solar calculations** for sun position
- **Twilight angles** for Fajr and Isha
- **Asr shadow ratio** (Hanafi vs Shafi methods)
- **High latitude adjustments** for extreme locations

## 🔔 Notification System

### Features
- Configurable Azan notifications for each prayer
- Custom notification tones
- Notification scheduling and rescheduling
- Hijri date display

### Implementation
```dart
class AthanNotificationProvider {
  void scheduleAthanNotifications(PrayerTimes times) {
    // Schedule notifications for each enabled prayer
  }
  
  void rescheduleNotifications() {
    // Called when settings change
  }
}
```

## 🌍 Location Integration

### Location Sources
1. **GPS** - Primary method using device location services
2. **Manual Entry** - User-entered coordinates
3. **City Selection** - Predefined city database

### Permissions
- Location permission handling
- Graceful fallbacks when permission denied
- Manual location entry option

## ⚙️ Settings & Preferences

### User Configurable Options
- **Calculation Method** - Different Islamic calculation methods
- **Madhab** - Hanafi vs Shafi Asr calculation
- **Manual Adjustments** - Fine-tune individual prayer times
- **Notification Settings** - Enable/disable per prayer
- **Display Format** - 12h vs 24h time format

### Storage
Uses Hive for local storage of:
- User location preferences
- Calculation method settings
- Manual time adjustments
- Notification preferences

## 🧪 Testing

### Unit Tests
- Prayer time calculation accuracy
- Edge cases (high latitudes, extreme dates)
- Time zone handling
- Method comparison tests

### Integration Tests
- Location service integration
- Notification scheduling
- Settings persistence
- UI state management

### Validation
Prayer times validated against:
- IslamicFinder.org
- PrayTimes.org
- Multiple Islamic authority sources

## 📱 UI Components

### Main Components
1. **Prayer Times Card** - Displays all 5 prayer times
2. **Next Prayer Widget** - Shows countdown to next prayer
3. **Prayer Settings Screen** - Configuration options
4. **Manual Adjustment Dialog** - Fine-tune times

### Localization
All prayer names and UI text properly localized:
- English: Fajr, Dhuhr, Asr, Maghrib, Isha
- Bengali: ফজর, যুহর, আসর, মাগরিব, ইশা
- Arabic: الفجر، الظهر، العصر، المغرب، العشاء
- Urdu: فجر، ظہر، عصر، مغرب، عشاء

## 🐛 Known Issues & Limitations

### Current Issues
- [ ] Occasional timezone calculation edge cases
- [ ] High latitude prayer time adjustments need refinement
- [ ] Notification scheduling on iOS background limitations

### Future Enhancements
- [ ] Qiyam al-Layl (night prayer) calculation
- [ ] Sunrise/sunset time display
- [ ] Prayer time history and statistics
- [ ] Community prayer time sharing

## 🔧 Maintenance

### Regular Updates
- Timezone database updates
- Location database maintenance
- Calculation algorithm improvements
- Bug fixes and optimizations

### Performance Considerations
- Efficient calculation caching
- Background location updates
- Battery-friendly notification scheduling
- Memory usage optimization

---

*This documentation should be updated when prayer time feature changes are made.*

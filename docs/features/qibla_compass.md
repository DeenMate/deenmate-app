# Qibla Compass Feature Documentation

## 📋 Overview

The Qibla Compass feature helps Muslims find the direction to the Kaaba in Mecca for prayer. It uses device sensors and GPS to provide accurate directional guidance.

## 🏗️ Architecture

### File Structure
```
lib/features/qibla/
├── data/
│   ├── repositories/
│   │   └── qibla_repository_impl.dart
│   ├── datasources/
│   │   └── qibla_calculation_datasource.dart
│   └── models/
│       └── qibla_direction_model.dart
├── domain/
│   ├── entities/
│   │   └── qibla_direction.dart
│   ├── repositories/
│   │   └── qibla_repository.dart
│   └── usecases/
│       └── calculate_qibla_direction.dart
└── presentation/
    ├── screens/
    │   ├── qibla_compass_screen.dart
    │   └── qibla_calibration_screen.dart
    ├── widgets/
    │   ├── compass_widget.dart
    │   └── calibration_widget.dart
    └── providers/
        └── qibla_provider.dart
```

## 🧭 Qibla Calculation

### Mathematical Foundation

#### Great Circle Distance Formula
```dart
double calculateQiblaDirection(
  double userLatitude,
  double userLongitude,
  double kaabaLatitude, // 21.4225°
  double kaabaLongitude, // 39.8262°
) {
  // Uses spherical trigonometry
  // Accounts for Earth's curvature
  // Returns bearing in degrees from North
}
```

#### Key Constants
- **Kaaba Coordinates**: 21.4225°N, 39.8262°E
- **Magnetic Declination**: Varies by location
- **Earth Radius**: 6371 km (for distance calculations)

### Sensor Integration

#### Required Sensors
1. **Magnetometer** - Magnetic compass readings
2. **Accelerometer** - Device orientation
3. **GPS** - User location (latitude/longitude)

#### Sensor Data Processing
```dart
class CompassSensorProvider {
  Stream<double> get magneticHeading; // Raw magnetic bearing
  Stream<double> get trueHeading;     // Corrected for declination
  Stream<bool> get isCalibrated;      // Sensor accuracy status
}
```

## 🔧 Calibration System

### Calibration Process
1. **Figure-8 Motion** - User rotates device in figure-8 pattern
2. **Magnetic Field Mapping** - Samples magnetic field variations
3. **Accuracy Assessment** - Validates sensor calibration quality
4. **Visual Feedback** - Guides user through calibration steps

### Accuracy Levels
- **HIGH** (3) - Excellent accuracy, ready for use
- **MEDIUM** (2) - Good accuracy, minor adjustments possible
- **LOW** (1) - Poor accuracy, recalibration recommended
- **UNRELIABLE** (0) - Sensor issues, manual direction needed

## 🌍 Location Services

### Location Requirements
- **GPS Permission** - Required for accurate positioning
- **Network Location** - Fallback when GPS unavailable
- **Manual Entry** - User can input coordinates manually

### Location Handling
```dart
class LocationService {
  Future<Position> getCurrentLocation();
  Future<bool> requestLocationPermission();
  Stream<Position> getLocationUpdates();
}
```

## 🎨 UI Components

### Compass Display
1. **Compass Rose** - Traditional compass design with Islamic patterns
2. **Qibla Indicator** - Clear arrow pointing to Kaaba direction
3. **Degree Display** - Numerical bearing to Kaaba
4. **Distance Display** - Great circle distance to Mecca
5. **Accuracy Indicator** - Visual sensor calibration status

### Visual Design Elements
- **Islamic Geometric Patterns** - Background design elements
- **Green Color Scheme** - Islamic color preferences
- **Arabic Calligraphy** - "Kaaba" text in Arabic
- **Smooth Animations** - Fluid compass needle movement

## 📍 Magnetic Declination

### What is Magnetic Declination?
Difference between magnetic north (compass reading) and true north (geographic north).

### Implementation
```dart
class MagneticDeclinationCalculator {
  static double getDeclination(
    double latitude,
    double longitude,
    DateTime date,
  ) {
    // Uses World Magnetic Model (WMM)
    // Returns declination in degrees
  }
}
```

### Global Variations
- **Varies by location** - Different for each geographic coordinate
- **Changes over time** - Magnetic poles shift annually
- **Updated annually** - WMM model updated by NOAA

## 🔔 Features & Settings

### Core Features
- Real-time compass direction
- Distance to Kaaba calculation
- Sensor calibration guidance
- Location-based accuracy
- Offline functionality

### User Settings
- **Calibration Sensitivity** - Adjust calibration requirements
- **Display Units** - Kilometers vs Miles for distance
- **Compass Style** - Different visual themes
- **Audio Feedback** - Sound when pointing to Qibla

## 🧪 Testing & Validation

### Testing Strategies
1. **Known Location Testing** - Test from mosques with known Qibla
2. **Multiple Device Testing** - Various phone orientations
3. **Calibration Testing** - Different calibration scenarios
4. **GPS Accuracy Testing** - Indoor vs outdoor performance

### Validation Methods
- **Cross-reference with mosque Qibla markers**
- **Compare with other Islamic apps**
- **Use surveyed mosque directions**
- **Test in different geographic regions**

## 🌍 Localization

### Text Localization
- **English**: "Qibla Direction", "Calibrate Compass"
- **Bengali**: "কিবলার দিক", "কম্পাস ক্যালিব্রেট করুন"
- **Arabic**: "اتجاه القبلة", "معايرة البوصلة"
- **Urdu**: "قبلہ کی سمت", "کمپاس کیلیبریٹ کریں"

### Cultural Considerations
- **RTL Layout Support** - Proper layout for Arabic/Urdu
- **Islamic Design Elements** - Culturally appropriate visuals
- **Religious Accuracy** - Ensuring correct Islamic guidance

## 🐛 Known Issues & Limitations

### Current Limitations
- **Indoor GPS Accuracy** - Reduced accuracy inside buildings
- **Magnetic Interference** - Metal objects affect compass
- **Device-Specific Variations** - Different sensor qualities
- **Calibration Persistence** - Calibration may reset

### Planned Improvements
- [ ] Gyroscope integration for stability
- [ ] Machine learning calibration optimization
- [ ] Augmented reality Qibla overlay
- [ ] Offline maps integration
- [ ] Prayer mat alignment guide

## 🔧 Maintenance & Updates

### Regular Maintenance
- **Magnetic Declination Updates** - Annual WMM model updates
- **Sensor Algorithms** - Improve accuracy algorithms
- **UI/UX Improvements** - Better user guidance
- **Performance Optimization** - Battery and CPU efficiency

### Technical Debt
- Sensor fusion improvements needed
- Better error handling for sensor failures
- More robust calibration persistence
- Enhanced accessibility features

---

*This documentation should be updated when Qibla compass feature changes are made.*

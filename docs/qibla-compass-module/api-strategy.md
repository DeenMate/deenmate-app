# Qibla Compass Module - API Strategy & Implementation

**Last Updated**: 29 August 2025  
**Module Status**: ✅ Implemented  
**Priority**: P0 (High)

---

## 📋 **API OVERVIEW**

### **Primary APIs**
The Qibla Compass module is primarily device-sensor focused with minimal external API dependencies, ensuring privacy and offline functionality for Qibla direction calculations.

**Device Sensors**: Compass, GPS, and accelerometer sensors  
**Location Services**: GPS coordinates for accurate Qibla calculation  
**Educational Content**: Islamic content about Qibla significance (Optional)  
**Documentation**: [Flutter Compass Plugin](https://pub.dev/packages/flutter_compass)  
**Rate Limits**: Device sensor dependent  
**Authentication**: Not required for device sensors

---

## 🔌 **API ENDPOINTS**

### **Device Sensor APIs**

#### **Compass Sensor**
```dart
class CompassSensorApi {
  final FlutterCompass _compass = FlutterCompass();

  /// Get compass heading stream
  Stream<CompassEvent> getCompassStream() {
    return _compass.compassUpdates;
  }

  /// Get current compass heading
  Future<double?> getCurrentHeading() async {
    try {
      final event = await _compass.compassUpdates.first;
      return event.heading;
    } catch (e) {
      print('Error getting compass heading: $e');
      return null;
    }
  }

  /// Check if compass is available
  Future<bool> isCompassAvailable() async {
    try {
      final event = await _compass.compassUpdates.first;
      return event.heading != null;
    } catch (e) {
      return false;
    }
  }
}
```

#### **GPS Location Sensor**
```dart
class LocationSensorApi {
  final Geolocator _geolocator = Geolocator();

  /// Get current location
  Future<Position> getCurrentLocation() async {
    // Check permissions
    LocationPermission permission = await _geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationException('Location permission denied');
      }
    }

    // Get current position
    return await _geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Get location stream
  Stream<Position> getLocationStream() {
    return _geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    );
  }

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await _geolocator.isLocationServiceEnabled();
  }
}
```

#### **Accelerometer Sensor**
```dart
class AccelerometerSensorApi {
  final AccelerometerEvent _accelerometer = AccelerometerEvent();

  /// Get accelerometer stream
  Stream<AccelerometerEvent> getAccelerometerStream() {
    return accelerometerEvents;
  }

  /// Get current accelerometer reading
  Future<AccelerometerEvent> getCurrentAccelerometer() async {
    return await accelerometerEvents.first;
  }
}
```

---

## 🏠 **OFFLINE-FIRST STRATEGY**

### **Local Data Storage**

#### **Location Cache**
```dart
class LocationCache {
  static const String locationCacheKey = 'last_known_location';
  static const Duration cacheExpiry = Duration(hours: 24);

  Future<void> cacheLocation(Position position) async {
    final prefs = await SharedPreferences.getInstance();
    final locationData = {
      'latitude': position.latitude,
      'longitude': position.longitude,
      'accuracy': position.accuracy,
      'timestamp': position.timestamp?.millisecondsSinceEpoch,
    };
    
    await prefs.setString(locationCacheKey, jsonEncode(locationData));
  }

  Future<Position?> getCachedLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final locationJson = prefs.getString(locationCacheKey);
    
    if (locationJson == null) return null;
    
    final locationData = jsonDecode(locationJson) as Map<String, dynamic>;
    final timestamp = locationData['timestamp'] as int?;
    
    if (timestamp == null) return null;
    
    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (cacheAge > LocationCache.cacheExpiry.inMilliseconds) {
      return null;
    }
    
    return Position(
      latitude: locationData['latitude'],
      longitude: locationData['longitude'],
      accuracy: locationData['accuracy'],
      altitude: 0,
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }
}
```

#### **Calibration Cache**
```dart
class CalibrationCache {
  static const String calibrationCacheKey = 'compass_calibration';
  static const Duration cacheExpiry = Duration(days: 7);

  Future<void> cacheCalibration(CalibrationData calibration) async {
    final prefs = await SharedPreferences.getInstance();
    final calibrationData = {
      'isAccurate': calibration.isAccurate,
      'accuracy': calibration.accuracy,
      'timestamp': calibration.timestamp.millisecondsSinceEpoch,
    };
    
    await prefs.setString(calibrationCacheKey, jsonEncode(calibrationData));
  }

  Future<CalibrationData?> getCachedCalibration() async {
    final prefs = await SharedPreferences.getInstance();
    final calibrationJson = prefs.getString(calibrationCacheKey);
    
    if (calibrationJson == null) return null;
    
    final calibrationData = jsonDecode(calibrationJson) as Map<String, dynamic>;
    final timestamp = calibrationData['timestamp'] as int;
    
    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (cacheAge > CalibrationCache.cacheExpiry.inMilliseconds) {
      return null;
    }
    
    return CalibrationData(
      isAccurate: calibrationData['isAccurate'],
      accuracy: calibrationData['accuracy'],
      readings: [],
      timestamp: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }
}
```

### **Built-in Islamic Content**

#### **Default Qibla Content**
```dart
class DefaultQiblaContent {
  static List<EducationalContent> getDefaultContent() {
    return [
      EducationalContent(
        id: 'qibla_001',
        title: 'Significance of Qibla',
        description: 'The importance of facing Qibla during prayer',
        content: '''
The Qibla is the direction Muslims face during prayer, which is towards the Kaaba in Makkah, Saudi Arabia. This direction was established by Allah in the Quran and is a fundamental aspect of Islamic worship.

Key points:
- Facing Qibla is obligatory for prayer
- Qibla direction varies based on geographic location
- Accurate Qibla direction ensures proper prayer
- Compass calibration improves accuracy
        ''',
        references: ['Surah Al-Baqarah 2:144', 'Sahih Bukhari 1:6:1'],
        category: 'qibla_significance',
      ),
      EducationalContent(
        id: 'qibla_002',
        title: 'How to Use Qibla Compass',
        description: 'Instructions for using the Qibla compass',
        content: '''
Using the Qibla compass:

1. Hold your device flat and level
2. Calibrate the compass if needed
3. The green arrow points to Qibla direction
4. Face the direction indicated by the arrow
5. Ensure accuracy within 5 degrees

Tips for better accuracy:
- Stay away from metal objects
- Calibrate regularly
- Use in open areas when possible
- Check for magnetic interference
        ''',
        references: ['Islamic Prayer Guidelines'],
        category: 'qibla_usage',
      ),
      EducationalContent(
        id: 'qibla_003',
        title: 'Compass Calibration',
        description: 'How to calibrate your compass for accuracy',
        content: '''
Compass Calibration Process:

1. Find an open area away from metal objects
2. Hold your device flat and level
3. Rotate your device in a figure-8 pattern
4. Continue until calibration is complete
5. Check accuracy indicator

Why calibration is important:
- Ensures accurate Qibla direction
- Compensates for magnetic interference
- Improves prayer direction accuracy
- Required for proper Islamic worship
        ''',
        references: ['Compass Calibration Guide'],
        category: 'calibration',
      ),
    ];
  }
}
```

---

## 🔄 **CACHING STRATEGY**

### **Cache Configuration**
```dart
class QiblaCompassCacheConfig {
  // Cache expiry times
  static const Duration locationCacheExpiry = Duration(hours: 24);
  static const Duration calibrationCacheExpiry = Duration(days: 7);
  static const Duration compassReadingsCacheExpiry = Duration(minutes: 5);
  
  // Cache keys
  static const String locationCacheKey = 'last_known_location';
  static const String calibrationCacheKey = 'compass_calibration';
  static const String compassReadingsCacheKey = 'compass_readings';
  
  // Cache size limits
  static const int maxCachedReadings = 100;
  static const int maxCalibrationHistory = 10;
}
```

### **Compass Readings Cache**
```dart
class CompassReadingsCache {
  static const String readingsCacheKey = 'compass_readings';

  Future<void> cacheReadings(List<CompassReading> readings) async {
    final prefs = await SharedPreferences.getInstance();
    final readingsData = readings.map((reading) => reading.toJson()).toList();
    await prefs.setString(readingsCacheKey, jsonEncode(readingsData));
  }

  Future<List<CompassReading>> getCachedReadings() async {
    final prefs = await SharedPreferences.getInstance();
    final readingsJson = prefs.getString(readingsCacheKey);
    
    if (readingsJson == null) return [];
    
    final readingsList = jsonDecode(readingsJson) as List;
    return readingsList
        .map((reading) => CompassReading.fromJson(reading))
        .toList();
  }
}
```

---

## 🚀 **OFFLINE STRATEGY**

### **Offline Data Management**
```dart
class QiblaCompassOfflineService {
  final LocationCache _locationCache;
  final CalibrationCache _calibrationCache;
  final CompassReadingsCache _readingsCache;

  QiblaCompassOfflineService(
    this._locationCache,
    this._calibrationCache,
    this._readingsCache,
  );

  Future<Position> getLocation() async {
    // Always try GPS first
    try {
      final locationService = LocationSensorApi();
      final position = await locationService.getCurrentLocation();
      
      // Cache the location
      await _locationCache.cacheLocation(position);
      return position;
    } catch (e) {
      // Fallback to cached location
      final cachedLocation = await _locationCache.getCachedLocation();
      if (cachedLocation != null) {
        return cachedLocation;
      }
      
      // Default to a known location if no cache
      throw OfflineException('No location available');
    }
  }

  Future<QiblaDirection> calculateQiblaDirectionOffline() async {
    final location = await getLocation();
    
    return QiblaCalculationService.calculateQiblaDirection(
      userLatitude: location.latitude,
      userLongitude: location.longitude,
    );
  }

  Future<CalibrationData?> getCalibrationData() async {
    return await _calibrationCache.getCachedCalibration();
  }
}
```

---

## 🔒 **SECURITY & PRIVACY**

### **Privacy-First Approach**
```dart
class QiblaCompassPrivacyService {
  // No personal data transmission
  static bool shouldTransmitData() {
    return false; // Never transmit personal location data
  }

  // Local data encryption
  static Future<void> encryptLocalData() async {
    // Implement local encryption for sensitive data
  }

  // Data anonymization for analytics
  static Map<String, dynamic> anonymizeData(Map<String, dynamic> data) {
    // Remove personal identifiers
    final anonymized = Map<String, dynamic>.from(data);
    anonymized.remove('exactLocation');
    anonymized.remove('userIdentifier');
    return anonymized;
  }
}
```

### **Sensor Permission Management**
```dart
class SensorPermissionManager {
  /// Request necessary permissions
  Future<bool> requestPermissions() async {
    // Request location permission
    LocationPermission locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        return false;
      }
    }

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    return true;
  }

  /// Check if all permissions are granted
  Future<bool> hasAllPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    
    return permission == LocationPermission.whileInUse || 
           permission == LocationPermission.always && serviceEnabled;
  }
}
```

---

## 📊 **MONITORING & ANALYTICS**

### **Usage Analytics**
```dart
class QiblaCompassAnalytics {
  static void trackCompassUsage(Duration usageTime) {
    FirebaseAnalytics.instance.logEvent(
      name: 'qibla_compass_usage',
      parameters: {
        'usage_time_seconds': usageTime.inSeconds,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackCalibration(bool success, double accuracy) {
    FirebaseAnalytics.instance.logEvent(
      name: 'compass_calibration',
      parameters: {
        'success': success,
        'accuracy': accuracy,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackQiblaCalculation(double distance) {
    FirebaseAnalytics.instance.logEvent(
      name: 'qibla_calculation',
      parameters: {
        'distance_km': distance,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
```

### **Performance Monitoring**
```dart
class QiblaCompassPerformanceTracker {
  static void trackCompassResponseTime(Duration responseTime) {
    FirebasePerformance.instance.newTrace('compass_response').then((trace) {
      trace.setMetric('response_time_ms', responseTime.inMilliseconds);
      trace.stop();
    });
  }

  static void trackQiblaCalculationTime(Duration calculationTime) {
    FirebasePerformance.instance.newTrace('qibla_calculation').then((trace) {
      trace.setMetric('calculation_time_ms', calculationTime.inMilliseconds);
      trace.stop();
    });
  }

  static void trackBatteryUsage(double batteryPercentage) {
    FirebasePerformance.instance.newTrace('battery_usage').then((trace) {
      trace.setMetric('battery_percentage', batteryPercentage);
      trace.stop();
    });
  }
}
```

---

## 🔄 **FALLBACK STRATEGIES**

### **API Fallback Chain**
1. **Primary**: Device sensors (compass, GPS)
2. **Secondary**: Cached location data (24-hour TTL)
3. **Tertiary**: Default location for offline access

### **Sensor Fallback**
```dart
class SensorFallbackService {
  static Position getDefaultLocation() {
    // Default to a central location if no GPS available
    return Position(
      latitude: 23.8103, // Dhaka coordinates
      longitude: 90.4125,
      accuracy: 1000, // Low accuracy indicator
      altitude: 0,
      timestamp: DateTime.now(),
      heading: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  static double getDefaultQiblaDirection() {
    // Default Qibla direction for Dhaka
    return 280.0; // Approximately 280 degrees
  }

  static CalibrationData getDefaultCalibration() {
    return CalibrationData(
      isAccurate: false,
      accuracy: 10.0, // Low accuracy
      readings: [],
      timestamp: DateTime.now(),
    );
  }
}
```

---

## 📚 **DOCUMENTATION FILES**

- **`README.md`** - Overview & purpose of the module
- **`qibla-compass-module-specification.md`** - Complete technical specification
- **`todo-qibla-compass.md`** - Detailed development tasks and tracking
- **`project-tracking.md`** - High-level project tracking

---

*Last Updated: 29 August 2025*  
*File Location: docs/qibla-compass-module/api-strategy.md*

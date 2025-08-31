# Prayer Times Module - API Strategy & Implementation

**Last Updated**: 29 August 2025  
**Module Status**: ✅ Implemented  
**Priority**: P0 (High)

---

## 📋 **API OVERVIEW**

### **Primary API: Aladhan API**
The Prayer Times module uses the Aladhan API as the primary data source for Islamic prayer times, supporting multiple calculation methods and locations worldwide.

**Base URL**: `https://api.aladhan.com/v1/`  
**Documentation**: [Aladhan API Docs](https://aladhan.com/prayer-times-api)  
**Rate Limits**: 1000 requests per hour per IP  
**Authentication**: Not required for public endpoints

---

## 🔌 **API ENDPOINTS**

### **Prayer Times Endpoint**
```http
GET /timings/{timestamp}
```

**Purpose**: Retrieve prayer times for a specific date and location  
**Parameters**:
- `timestamp`: Unix timestamp for the date
- `latitude`: Latitude coordinate
- `longitude`: Longitude coordinate
- `method`: Calculation method (default: 'mwl')

**Response Example**:
```json
{
  "code": 200,
  "status": "OK",
  "data": {
    "timings": {
      "Fajr": "05:30",
      "Sunrise": "07:15",
      "Dhuhr": "12:30",
      "Asr": "15:45",
      "Sunset": "17:45",
      "Maghrib": "18:00",
      "Isha": "19:30",
      "Imsak": "05:20",
      "Midnight": "00:30"
    },
    "date": {
      "readable": "29 Aug 2025",
      "timestamp": "1732838400",
      "gregorian": {
        "date": "29-08-2025",
        "format": "DD-MM-YYYY",
        "day": "29",
        "weekday": {
          "en": "Friday"
        },
        "month": {
          "number": 8,
          "en": "August"
        },
        "year": "2025"
      },
      "hijri": {
        "date": "15-02-1447",
        "format": "DD-MM-YYYY",
        "day": "15",
        "weekday": {
          "en": "Al Juma'a",
          "ar": "الجمعة"
        },
        "month": {
          "number": 2,
          "en": "Safar",
          "ar": "صفر"
        },
        "year": "1447"
      }
    },
    "meta": {
      "latitude": 23.8103,
      "longitude": 90.4125,
      "timezone": "Asia/Dhaka",
      "method": {
        "id": 3,
        "name": "Muslim World League",
        "params": {
          "Fajr": 18,
          "Isha": 17
        },
        "location": {
          "latitude": 21.4225,
          "longitude": 39.8262
        }
      }
    }
  }
}
```

**Implementation**:
```dart
class PrayerTimesApi {
  Future<PrayerTimesDto> getPrayerTimes(DateTime date, {
    required double latitude,
    required double longitude,
    String method = 'mwl',
  }) async {
    final timestamp = date.millisecondsSinceEpoch ~/ 1000;
    final response = await dio.get('/timings/$timestamp', queryParameters: {
      'latitude': latitude,
      'longitude': longitude,
      'method': method,
    });
    
    return PrayerTimesDto.fromJson(response.data['data']);
  }
}
```

### **Calendar Endpoint**
```http
GET /calendar
```

**Purpose**: Retrieve prayer times for an entire month  
**Parameters**:
- `month`: Month number (1-12)
- `year`: Year (e.g., 2025)
- `latitude`: Latitude coordinate
- `longitude`: Longitude coordinate
- `method`: Calculation method (default: 'mwl')

**Response Example**:
```json
{
  "code": 200,
  "status": "OK",
  "data": [
    {
      "timings": {
        "Fajr": "05:30",
        "Sunrise": "07:15",
        "Dhuhr": "12:30",
        "Asr": "15:45",
        "Sunset": "17:45",
        "Maghrib": "18:00",
        "Isha": "19:30"
      },
      "date": {
        "readable": "01 Aug 2025",
        "timestamp": "1735689600"
      }
    }
  ]
}
```

**Implementation**:
```dart
class PrayerTimesApi {
  Future<List<PrayerTimesDto>> getPrayerTimesCalendar({
    required int month,
    required int year,
    required double latitude,
    required double longitude,
    String method = 'mwl',
  }) async {
    final response = await dio.get('/calendar', queryParameters: {
      'month': month,
      'year': year,
      'latitude': latitude,
      'longitude': longitude,
      'method': method,
    });
    
    final timings = (response.data['data'] as List)
        .map((e) => PrayerTimesDto.fromJson(e))
        .toList();
        
    return timings;
  }
}
```

### **Timings by City Endpoint**
```http
GET /timingsByCity
```

**Purpose**: Get prayer times by city name  
**Parameters**:
- `city`: City name
- `country`: Country name
- `method`: Calculation method (default: 'mwl')

**Response Example**:
```json
{
  "code": 200,
  "status": "OK",
  "data": {
    "timings": {
      "Fajr": "05:30",
      "Sunrise": "07:15",
      "Dhuhr": "12:30",
      "Asr": "15:45",
      "Sunset": "17:45",
      "Maghrib": "18:00",
      "Isha": "19:30"
    },
    "date": {
      "readable": "29 Aug 2025"
    },
    "meta": {
      "latitude": 23.8103,
      "longitude": 90.4125,
      "timezone": "Asia/Dhaka"
    }
  }
}
```

**Implementation**:
```dart
class PrayerTimesApi {
  Future<PrayerTimesDto> getPrayerTimesByCity({
    required String city,
    required String country,
    String method = 'mwl',
  }) async {
    final response = await dio.get('/timingsByCity', queryParameters: {
      'city': city,
      'country': country,
      'method': method,
    });
    
    return PrayerTimesDto.fromJson(response.data['data']);
  }
}
```

---

## 🌐 **CALCULATION METHODS**

### **Available Calculation Methods**

| Method | Name | Description | Fajr Angle | Isha Angle | Status |
|--------|------|-------------|------------|------------|--------|
| **MWL** | Muslim World League | Standard method used by most countries | 18° | 17° | ✅ Active |
| **ISNA** | Islamic Society of North America | Used in North America | 15° | 15° | ✅ Active |
| **Egypt** | Egyptian General Authority | Used in Egypt and some African countries | 19.5° | 17.5° | ✅ Active |
| **Makkah** | Umm Al-Qura University | Used in Saudi Arabia | 18.5° | 90 min | ✅ Active |
| **Karachi** | University of Islamic Sciences | Used in Pakistan and India | 18° | 18° | ✅ Active |
| **Tehran** | Institute of Geophysics | Used in Iran | 17.7° | 14° | ✅ Active |

### **Calculation Method Configuration**
```dart
class CalculationMethodConfig {
  static const Map<String, String> methodNames = {
    'mwl': 'Muslim World League',
    'isna': 'Islamic Society of North America',
    'egypt': 'Egyptian General Authority',
    'makkah': 'Umm Al-Qura University',
    'karachi': 'University of Islamic Sciences',
    'tehran': 'Institute of Geophysics',
  };
  
  static const Map<String, String> methodDescriptions = {
    'mwl': 'Standard method used by most countries',
    'isna': 'Used in North America',
    'egypt': 'Used in Egypt and some African countries',
    'makkah': 'Used in Saudi Arabia',
    'karachi': 'Used in Pakistan and India',
    'tehran': 'Used in Iran',
  };
  
  static const Map<String, Map<String, double>> methodParameters = {
    'mwl': {'fajr': 18.0, 'isha': 17.0},
    'isna': {'fajr': 15.0, 'isha': 15.0},
    'egypt': {'fajr': 19.5, 'isha': 17.5},
    'makkah': {'fajr': 18.5, 'isha': 90.0}, // 90 minutes after Maghrib
    'karachi': {'fajr': 18.0, 'isha': 18.0},
    'tehran': {'fajr': 17.7, 'isha': 14.0},
  };
}
```

---

## 🔄 **CACHING STRATEGY**

### **Cache Configuration**
```dart
class PrayerTimesCacheConfig {
  // Cache expiry times
  static const Duration prayerTimesCacheExpiry = Duration(days: 7);
  static const Duration locationCacheExpiry = Duration(days: 30);
  static const Duration calendarCacheExpiry = Duration(days: 1);
  
  // Cache keys
  static const String prayerTimesCacheKey = 'prayer_times';
  static const String locationCacheKey = 'location';
  static const String calendarCacheKey = 'calendar';
  
  // Cache size limits
  static const int maxCachedPrayerTimes = 30; // 30 days
  static const int maxCachedLocations = 10;
  static const int maxCachedCalendars = 12; // 12 months
}
```

### **Hive Cache Implementation**
```dart
class PrayerTimesCacheService {
  static const String prayerTimesBox = 'prayer_times';
  static const String locationBox = 'location';
  static const String calendarBox = 'calendar';

  Future<void> cachePrayerTimes(DateTime date, PrayerTimes prayerTimes) async {
    final box = await Hive.openBox<PrayerTimes>(prayerTimesBox);
    final key = '${date.year}_${date.month}_${date.day}';
    
    await box.put(key, prayerTimes);
  }

  Future<PrayerTimes?> getCachedPrayerTimes(DateTime date) async {
    final box = await Hive.openBox<PrayerTimes>(prayerTimesBox);
    final key = '${date.year}_${date.month}_${date.day}';
    
    return box.get(key);
  }

  Future<void> cacheLocation(Location location) async {
    final box = await Hive.openBox<Location>(locationBox);
    await box.put('current', location);
  }

  Future<Location?> getCachedLocation() async {
    final box = await Hive.openBox<Location>(locationBox);
    return box.get('current');
  }

  Future<void> cacheCalendar(int month, int year, List<PrayerTimes> calendar) async {
    final box = await Hive.openBox<List<PrayerTimes>>(calendarBox);
    final key = '${year}_${month}';
    
    await box.put(key, calendar);
  }

  Future<List<PrayerTimes>?> getCachedCalendar(int month, int year) async {
    final box = await Hive.openBox<List<PrayerTimes>>(calendarBox);
    final key = '${year}_${month}';
    
    return box.get(key);
  }
}
```

---

## 🚀 **OFFLINE STRATEGY**

### **Offline Data Management**
```dart
class PrayerTimesOfflineService {
  final PrayerTimesCacheService _cacheService;
  final NetworkInfo _networkInfo;

  PrayerTimesOfflineService(this._cacheService, this._networkInfo);

  Future<PrayerTimes> getPrayerTimes(DateTime date) async {
    // Always try cache first
    final cachedPrayerTimes = await _cacheService.getCachedPrayerTimes(date);
    if (cachedPrayerTimes != null) {
      return cachedPrayerTimes;
    }

    // If no cache and no network, calculate offline
    if (!await _networkInfo.isConnected) {
      return _calculatePrayerTimesOffline(date);
    }

    // Fetch from API and cache
    final prayerTimes = await _fetchPrayerTimesFromApi(date);
    await _cacheService.cachePrayerTimes(date, prayerTimes);
    return prayerTimes;
  }

  Future<PrayerTimes> _calculatePrayerTimesOffline(DateTime date) async {
    // Use local calculation library for offline prayer times
    final location = await _cacheService.getCachedLocation();
    if (location == null) {
      throw OfflineException('No cached location available');
    }

    // Implement local prayer time calculation
    return _localPrayerTimeCalculation(date, location);
  }

  Future<void> preloadPrayerTimes() async {
    if (!await _networkInfo.isConnected) return;

    // Preload next 7 days of prayer times
    final now = DateTime.now();
    for (int i = 0; i < 7; i++) {
      final date = now.add(Duration(days: i));
      try {
        final prayerTimes = await _fetchPrayerTimesFromApi(date);
        await _cacheService.cachePrayerTimes(date, prayerTimes);
      } catch (e) {
        // Continue with next date if one fails
        continue;
      }
    }
  }
}
```

---

## 🔒 **SECURITY & RATE LIMITING**

### **Rate Limiting Strategy**
```dart
class PrayerTimesApiRateLimiter {
  static const int maxRequestsPerHour = 1000;
  static const int maxRequestsPerMinute = 60;
  
  final Map<String, List<DateTime>> _requestHistory = {};
  
  Future<void> checkRateLimit(String endpoint) async {
    final now = DateTime.now();
    final key = endpoint;
    
    if (!_requestHistory.containsKey(key)) {
      _requestHistory[key] = [];
    }
    
    final requests = _requestHistory[key]!;
    
    // Remove requests older than 1 hour
    requests.removeWhere((time) => now.difference(time).inHours > 0);
    
    // Check hourly limit
    if (requests.length >= maxRequestsPerHour) {
      throw RateLimitException('Hourly rate limit exceeded');
    }
    
    // Remove requests older than 1 minute
    requests.removeWhere((time) => now.difference(time).inMinutes > 0);
    
    // Check minute limit
    if (requests.length >= maxRequestsPerMinute) {
      throw RateLimitException('Minute rate limit exceeded');
    }
    
    // Add current request
    requests.add(now);
  }
}
```

### **Error Handling**
```dart
class PrayerTimesApiErrorHandler {
  static String handleApiError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 404:
              return 'Prayer times not found for this location.';
            case 429:
              return 'Too many requests. Please try again later.';
            case 500:
              return 'Server error. Please try again later.';
            default:
              return 'Network error occurred.';
          }
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        default:
          return 'Network error occurred.';
      }
    }
    
    return 'An unexpected error occurred.';
  }
}
```

---

## 📊 **MONITORING & ANALYTICS**

### **API Usage Tracking**
```dart
class PrayerTimesApiAnalytics {
  static void trackApiCall(String endpoint, Duration responseTime, bool success) {
    FirebaseAnalytics.instance.logEvent(
      name: 'prayer_times_api_call',
      parameters: {
        'endpoint': endpoint,
        'response_time_ms': responseTime.inMilliseconds,
        'success': success,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackCacheHit(String cacheType) {
    FirebaseAnalytics.instance.logEvent(
      name: 'prayer_times_cache_hit',
      parameters: {
        'cache_type': cacheType,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackOfflineUsage(String feature) {
    FirebaseAnalytics.instance.logEvent(
      name: 'prayer_times_offline_usage',
      parameters: {
        'feature': feature,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
```

### **Performance Monitoring**
```dart
class PrayerTimesPerformanceTracker {
  static void trackPrayerTimeLoadTime(DateTime date, Duration loadTime) {
    FirebasePerformance.instance.newTrace('prayer_times_load').then((trace) {
      trace.setMetric('date', date.millisecondsSinceEpoch);
      trace.setMetric('load_time_ms', loadTime.inMilliseconds);
      trace.stop();
    });
  }

  static void trackLocationDetectionTime(Duration detectionTime) {
    FirebasePerformance.instance.newTrace('location_detection').then((trace) {
      trace.setMetric('detection_time_ms', detectionTime.inMilliseconds);
      trace.stop();
    });
  }

  static void trackQiblaCalculationTime(Duration calculationTime) {
    FirebasePerformance.instance.newTrace('qibla_calculation').then((trace) {
      trace.setMetric('calculation_time_ms', calculationTime.inMilliseconds);
      trace.stop();
    });
  }
}
```

---

## 🔄 **FALLBACK STRATEGIES**

### **API Fallback Chain**
1. **Primary**: Aladhan API for real-time data
2. **Secondary**: Local calculation library for offline access
3. **Tertiary**: Cached data with 7-day TTL

### **Calculation Method Fallback**
```dart
class CalculationMethodFallbackService {
  static String getFallbackMethod(String preferredMethod) {
    switch (preferredMethod) {
      case 'mwl':
        return 'mwl'; // Muslim World League
      case 'isna':
        return 'isna'; // Islamic Society of North America
      case 'egypt':
        return 'egypt'; // Egyptian General Authority
      case 'makkah':
        return 'makkah'; // Umm Al-Qura University
      case 'karachi':
        return 'karachi'; // University of Islamic Sciences
      case 'tehran':
        return 'tehran'; // Institute of Geophysics
      default:
        return 'mwl'; // Default to Muslim World League
    }
  }

  static List<String> getFallbackMethods(String primaryMethod) {
    switch (primaryMethod) {
      case 'mwl':
        return ['mwl', 'isna', 'egypt']; // MWL, ISNA, Egypt
      case 'isna':
        return ['isna', 'mwl', 'egypt']; // ISNA, MWL, Egypt
      case 'egypt':
        return ['egypt', 'mwl', 'isna']; // Egypt, MWL, ISNA
      case 'makkah':
        return ['makkah', 'mwl', 'egypt']; // Makkah, MWL, Egypt
      case 'karachi':
        return ['karachi', 'mwl', 'isna']; // Karachi, MWL, ISNA
      case 'tehran':
        return ['tehran', 'mwl', 'egypt']; // Tehran, MWL, Egypt
      default:
        return ['mwl', 'isna', 'egypt']; // Default fallback chain
    }
  }
}
```

---

## 📚 **DOCUMENTATION FILES**

- **`README.md`** - Overview & purpose of the module
- **`prayer-times-module-specification.md`** - Complete technical specification
- **`todo-prayer-times.md`** - Detailed development tasks and tracking
- **`project-tracking.md`** - High-level project tracking

---

*Last Updated: 29 August 2025*  
*File Location: docs/prayer-times-module/api-strategy.md*

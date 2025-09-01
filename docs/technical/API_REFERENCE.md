# DeenMate API Reference Guide

**Version**: 1.0.0  
**Last Updated**: September 1, 2025  
**Status**: Production API Documentation  

---

## 📋 **Table of Contents**

1. [API Overview](#api-overview)
2. [Authentication & Security](#authentication--security)
3. [Prayer Times API](#prayer-times-api)
4. [Quran API](#quran-api)
5. [Hadith API](#hadith-api)
6. [Qibla Direction API](#qibla-direction-api)
7. [Zakat Calculator API](#zakat-calculator-api)
8. [Islamic Content API](#islamic-content-api)
9. [User Preferences API](#user-preferences-api)
10. [Error Handling](#error-handling)
11. [Rate Limiting](#rate-limiting)
12. [SDK Integration](#sdk-integration)

---

## 🌐 **API Overview**

DeenMate provides a comprehensive RESTful API for all Islamic features, designed with offline-first capabilities, Islamic accuracy verification, and mobile optimization in mind.

### **Base Configuration**

```dart
/// DeenMate API Client Configuration
class DeenMateApiConfig {
  static const String baseUrl = 'https://api.deenmate.com/v1';
  static const String cdnUrl = 'https://cdn.deenmate.com';
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration connectionTimeout = Duration(seconds: 10);
  
  // API Endpoints
  static const Map<String, String> endpoints = {
    'prayer_times': '/prayer-times',
    'quran': '/quran',
    'hadith': '/hadith',
    'qibla': '/qibla',
    'zakat': '/zakat',
    'islamic_content': '/content',
    'user_preferences': '/preferences',
    'authentication': '/auth',
  };
  
  // Islamic Content Verification
  static const Map<String, String> verificationEndpoints = {
    'verify_quran': '/verify/quran',
    'verify_hadith': '/verify/hadith',
    'verify_calculation': '/verify/calculation',
  };
}
```

### **API Client Initialization**

```dart
/// Initialize DeenMate API Client
class DeenMateApiClient {
  static final Dio _dio = Dio();
  static bool _initialized = false;
  
  static Future<void> initialize({
    String? apiKey,
    String? userAgent,
    bool enableOfflineMode = true,
  }) async {
    if (_initialized) return;
    
    _dio.options.baseUrl = DeenMateApiConfig.baseUrl;
    _dio.options.connectTimeout = DeenMateApiConfig.connectionTimeout;
    _dio.options.receiveTimeout = DeenMateApiConfig.defaultTimeout;
    
    // Add interceptors
    _dio.interceptors.addAll([
      _createAuthInterceptor(apiKey),
      _createErrorInterceptor(),
      _createCacheInterceptor(),
      if (enableOfflineMode) _createOfflineInterceptor(),
      _createIslamicVerificationInterceptor(),
    ]);
    
    _initialized = true;
  }
  
  // Authentication interceptor
  static Interceptor _createAuthInterceptor(String? apiKey) {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        if (apiKey != null) {
          options.headers['X-API-Key'] = apiKey;
        }
        options.headers['User-Agent'] = 'DeenMate Mobile App v1.0.0';
        options.headers['Accept'] = 'application/json';
        handler.next(options);
      },
    );
  }
}
```

---

## 🔐 **Authentication & Security**

### **API Key Authentication**

```dart
/// API Key management for DeenMate services
class DeenMateAuthentication {
  static String? _apiKey;
  static String? _refreshToken;
  
  // Set API key for authenticated requests
  static void setApiKey(String apiKey) {
    _apiKey = apiKey;
  }
  
  // Anonymous authentication for basic features
  static Future<AuthResponse> authenticateAnonymously() async {
    final response = await DeenMateApiClient.post('/auth/anonymous', data: {
      'device_id': await _getDeviceId(),
      'app_version': await _getAppVersion(),
      'platform': Platform.isIOS ? 'ios' : 'android',
    });
    
    return AuthResponse.fromJson(response.data);
  }
  
  // Optional user registration for enhanced features
  static Future<AuthResponse> registerUser({
    required String email,
    String? name,
    String? preferredLanguage,
    Map<String, dynamic>? preferences,
  }) async {
    final response = await DeenMateApiClient.post('/auth/register', data: {
      'email': email,
      'name': name,
      'preferred_language': preferredLanguage ?? 'en',
      'preferences': preferences ?? {},
    });
    
    final authResponse = AuthResponse.fromJson(response.data);
    _apiKey = authResponse.apiKey;
    _refreshToken = authResponse.refreshToken;
    
    return authResponse;
  }
  
  // Refresh authentication token
  static Future<void> refreshAuthentication() async {
    if (_refreshToken == null) return;
    
    final response = await DeenMateApiClient.post('/auth/refresh', data: {
      'refresh_token': _refreshToken,
    });
    
    final authResponse = AuthResponse.fromJson(response.data);
    _apiKey = authResponse.apiKey;
    _refreshToken = authResponse.refreshToken;
  }
}
```

### **Privacy & Data Protection**

```dart
/// Privacy-first data handling
class DeenMatePrivacy {
  // Data collection principles
  static const Map<String, String> dataUsage = {
    'location': 'Used only for prayer times and Qibla direction calculation',
    'preferences': 'Stored locally to enhance Islamic experience',
    'usage_analytics': 'Anonymous usage patterns to improve app features',
    'islamic_content': 'Cached locally for offline Islamic access',
  };
  
  // GDPR compliance methods
  static Future<void> requestDataExport() async {
    await DeenMateApiClient.post('/privacy/export-data');
  }
  
  static Future<void> deleteUserData() async {
    await DeenMateApiClient.delete('/privacy/delete-data');
  }
  
  static Future<PrivacyPolicy> getPrivacyPolicy() async {
    final response = await DeenMateApiClient.get('/privacy/policy');
    return PrivacyPolicy.fromJson(response.data);
  }
}
```

---

## 🕐 **Prayer Times API**

### **Get Prayer Times**

```dart
/// Prayer Times API methods
class PrayerTimesApi {
  // Get prayer times for specific location and date
  static Future<PrayerTimesResponse> getPrayerTimes({
    required double latitude,
    required double longitude,
    required DateTime date,
    String calculationMethod = 'mwl',
    String madhab = 'standard',
    Map<String, int>? adjustments,
  }) async {
    final response = await DeenMateApiClient.get(
      '/prayer-times',
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'date': date.toIso8601String().split('T')[0],
        'method': calculationMethod,
        'madhab': madhab,
        if (adjustments != null) 'adjustments': json.encode(adjustments),
      },
    );
    
    return PrayerTimesResponse.fromJson(response.data);
  }
  
  // Get prayer times for multiple dates (batch request)
  static Future<List<PrayerTimesResponse>> getPrayerTimesBatch({
    required double latitude,
    required double longitude,
    required DateTime startDate,
    required DateTime endDate,
    String calculationMethod = 'mwl',
    String madhab = 'standard',
  }) async {
    final response = await DeenMateApiClient.post('/prayer-times/batch', data: {
      'latitude': latitude,
      'longitude': longitude,
      'start_date': startDate.toIso8601String().split('T')[0],
      'end_date': endDate.toIso8601String().split('T')[0],
      'calculation_method': calculationMethod,
      'madhab': madhab,
    });
    
    return (response.data['prayer_times'] as List)
      .map((item) => PrayerTimesResponse.fromJson(item))
      .toList();
  }
  
  // Get available calculation methods
  static Future<List<CalculationMethod>> getCalculationMethods() async {
    final response = await DeenMateApiClient.get('/prayer-times/methods');
    
    return (response.data['methods'] as List)
      .map((item) => CalculationMethod.fromJson(item))
      .toList();
  }
  
  // Verify prayer time accuracy
  static Future<VerificationResult> verifyPrayerTimes({
    required PrayerTimesResponse prayerTimes,
    required double latitude,
    required double longitude,
  }) async {
    final response = await DeenMateApiClient.post('/verify/prayer-times', data: {
      'prayer_times': prayerTimes.toJson(),
      'location': {
        'latitude': latitude,
        'longitude': longitude,
      },
    });
    
    return VerificationResult.fromJson(response.data);
  }
}
```

### **Prayer Times Data Models**

```dart
/// Prayer Times API Data Models
class PrayerTimesResponse {
  final DateTime date;
  final LocationData location;
  final PrayerTimes prayerTimes;
  final CalculationMethod method;
  final Map<String, int> adjustments;
  final DateTime sunrise;
  final DateTime sunset;
  final IslamicDate islamicDate;
  
  const PrayerTimesResponse({
    required this.date,
    required this.location,
    required this.prayerTimes,
    required this.method,
    required this.adjustments,
    required this.sunrise,
    required this.sunset,
    required this.islamicDate,
  });
  
  factory PrayerTimesResponse.fromJson(Map<String, dynamic> json) {
    return PrayerTimesResponse(
      date: DateTime.parse(json['date']),
      location: LocationData.fromJson(json['location']),
      prayerTimes: PrayerTimes.fromJson(json['prayer_times']),
      method: CalculationMethod.fromJson(json['method']),
      adjustments: Map<String, int>.from(json['adjustments'] ?? {}),
      sunrise: DateTime.parse(json['sunrise']),
      sunset: DateTime.parse(json['sunset']),
      islamicDate: IslamicDate.fromJson(json['islamic_date']),
    );
  }
}

class PrayerTimes {
  final DateTime fajr;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  
  const PrayerTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
  });
  
  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    return PrayerTimes(
      fajr: DateTime.parse(json['fajr']),
      dhuhr: DateTime.parse(json['dhuhr']),
      asr: DateTime.parse(json['asr']),
      maghrib: DateTime.parse(json['maghrib']),
      isha: DateTime.parse(json['isha']),
    );
  }
}

class CalculationMethod {
  final String id;
  final String name;
  final String description;
  final double fajrAngle;
  final double ishaAngle;
  final String authority;
  final List<String> regions;
  
  const CalculationMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.fajrAngle,
    required this.ishaAngle,
    required this.authority,
    required this.regions,
  });
  
  factory CalculationMethod.fromJson(Map<String, dynamic> json) {
    return CalculationMethod(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      fajrAngle: json['fajr_angle'].toDouble(),
      ishaAngle: json['isha_angle'].toDouble(),
      authority: json['authority'],
      regions: List<String>.from(json['regions']),
    );
  }
}
```

---

## 📖 **Quran API**

### **Quran Content Access**

```dart
/// Quran API methods
class QuranApi {
  // Get Quran chapter (Surah)
  static Future<QuranChapterResponse> getChapter({
    required int chapterNumber,
    String language = 'ar',
    String? translation,
    bool includeAudio = false,
  }) async {
    final response = await DeenMateApiClient.get(
      '/quran/chapters/$chapterNumber',
      queryParameters: {
        'language': language,
        if (translation != null) 'translation': translation,
        'include_audio': includeAudio,
      },
    );
    
    return QuranChapterResponse.fromJson(response.data);
  }
  
  // Get specific verse (Ayah)
  static Future<QuranVerseResponse> getVerse({
    required int chapterNumber,
    required int verseNumber,
    String language = 'ar',
    List<String>? translations,
    bool includeAudio = false,
  }) async {
    final response = await DeenMateApiClient.get(
      '/quran/chapters/$chapterNumber/verses/$verseNumber',
      queryParameters: {
        'language': language,
        if (translations != null) 'translations': translations.join(','),
        'include_audio': includeAudio,
      },
    );
    
    return QuranVerseResponse.fromJson(response.data);
  }
  
  // Search Quran content
  static Future<QuranSearchResponse> searchQuran({
    required String query,
    String language = 'ar',
    List<String>? translations,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await DeenMateApiClient.get(
      '/quran/search',
      queryParameters: {
        'q': query,
        'language': language,
        if (translations != null) 'translations': translations.join(','),
        'page': page,
        'limit': limit,
      },
    );
    
    return QuranSearchResponse.fromJson(response.data);
  }
  
  // Get Quran recitations
  static Future<List<QuranReciter>> getReciters() async {
    final response = await DeenMateApiClient.get('/quran/reciters');
    
    return (response.data['reciters'] as List)
      .map((item) => QuranReciter.fromJson(item))
      .toList();
  }
  
  // Get audio URL for verse
  static Future<QuranAudioResponse> getVerseAudio({
    required int chapterNumber,
    required int verseNumber,
    required String reciterId,
    String quality = 'medium',
  }) async {
    final response = await DeenMateApiClient.get(
      '/quran/audio/$reciterId/$chapterNumber/$verseNumber',
      queryParameters: {
        'quality': quality,
      },
    );
    
    return QuranAudioResponse.fromJson(response.data);
  }
  
  // Get available translations
  static Future<List<QuranTranslation>> getTranslations() async {
    final response = await DeenMateApiClient.get('/quran/translations');
    
    return (response.data['translations'] as List)
      .map((item) => QuranTranslation.fromJson(item))
      .toList();
  }
}
```

### **Quran Data Models**

```dart
/// Quran API Data Models
class QuranChapterResponse {
  final QuranChapter chapter;
  final List<QuranVerse> verses;
  final List<QuranTranslation>? translations;
  final QuranAudioInfo? audio;
  
  const QuranChapterResponse({
    required this.chapter,
    required this.verses,
    this.translations,
    this.audio,
  });
  
  factory QuranChapterResponse.fromJson(Map<String, dynamic> json) {
    return QuranChapterResponse(
      chapter: QuranChapter.fromJson(json['chapter']),
      verses: (json['verses'] as List)
        .map((item) => QuranVerse.fromJson(item))
        .toList(),
      translations: json['translations'] != null
        ? (json['translations'] as List)
          .map((item) => QuranTranslation.fromJson(item))
          .toList()
        : null,
      audio: json['audio'] != null 
        ? QuranAudioInfo.fromJson(json['audio'])
        : null,
    );
  }
}

class QuranChapter {
  final int number;
  final String nameArabic;
  final String nameEnglish;
  final String nameTransliteration;
  final String meaning;
  final int versesCount;
  final String revelationPlace;
  final int revelationOrder;
  
  const QuranChapter({
    required this.number,
    required this.nameArabic,
    required this.nameEnglish,
    required this.nameTransliteration,
    required this.meaning,
    required this.versesCount,
    required this.revelationPlace,
    required this.revelationOrder,
  });
  
  factory QuranChapter.fromJson(Map<String, dynamic> json) {
    return QuranChapter(
      number: json['number'],
      nameArabic: json['name_arabic'],
      nameEnglish: json['name_english'],
      nameTransliteration: json['name_transliteration'],
      meaning: json['meaning'],
      versesCount: json['verses_count'],
      revelationPlace: json['revelation_place'],
      revelationOrder: json['revelation_order'],
    );
  }
}

class QuranVerse {
  final int number;
  final String textArabic;
  final String textUthmani;
  final Map<String, String> translations;
  final String? transliteration;
  final Map<String, String>? audio;
  
  const QuranVerse({
    required this.number,
    required this.textArabic,
    required this.textUthmani,
    required this.translations,
    this.transliteration,
    this.audio,
  });
  
  factory QuranVerse.fromJson(Map<String, dynamic> json) {
    return QuranVerse(
      number: json['number'],
      textArabic: json['text_arabic'],
      textUthmani: json['text_uthmani'],
      translations: Map<String, String>.from(json['translations'] ?? {}),
      transliteration: json['transliteration'],
      audio: json['audio'] != null 
        ? Map<String, String>.from(json['audio'])
        : null,
    );
  }
}
```

---

## 📚 **Hadith API**

### **Hadith Collection Access**

```dart
/// Hadith API methods
class HadithApi {
  // Get hadith collections
  static Future<List<HadithCollection>> getCollections() async {
    final response = await DeenMateApiClient.get('/hadith/collections');
    
    return (response.data['collections'] as List)
      .map((item) => HadithCollection.fromJson(item))
      .toList();
  }
  
  // Get hadiths from specific collection
  static Future<HadithResponse> getHadiths({
    required String collectionId,
    int page = 1,
    int limit = 20,
    String? book,
    String? chapter,
  }) async {
    final response = await DeenMateApiClient.get(
      '/hadith/collections/$collectionId',
      queryParameters: {
        'page': page,
        'limit': limit,
        if (book != null) 'book': book,
        if (chapter != null) 'chapter': chapter,
      },
    );
    
    return HadithResponse.fromJson(response.data);
  }
  
  // Get specific hadith
  static Future<HadithDetailResponse> getHadith({
    required String collectionId,
    required String hadithNumber,
    List<String>? translations,
  }) async {
    final response = await DeenMateApiClient.get(
      '/hadith/collections/$collectionId/hadiths/$hadithNumber',
      queryParameters: {
        if (translations != null) 'translations': translations.join(','),
      },
    );
    
    return HadithDetailResponse.fromJson(response.data);
  }
  
  // Search hadiths
  static Future<HadithSearchResponse> searchHadiths({
    required String query,
    List<String>? collections,
    String? grade,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await DeenMateApiClient.get(
      '/hadith/search',
      queryParameters: {
        'q': query,
        if (collections != null) 'collections': collections.join(','),
        if (grade != null) 'grade': grade,
        'page': page,
        'limit': limit,
      },
    );
    
    return HadithSearchResponse.fromJson(response.data);
  }
  
  // Verify hadith authenticity
  static Future<HadithVerificationResponse> verifyHadith({
    required String collectionId,
    required String hadithNumber,
    required String text,
  }) async {
    final response = await DeenMateApiClient.post('/verify/hadith', data: {
      'collection_id': collectionId,
      'hadith_number': hadithNumber,
      'text': text,
    });
    
    return HadithVerificationResponse.fromJson(response.data);
  }
}
```

### **Hadith Data Models**

```dart
/// Hadith API Data Models
class HadithCollection {
  final String id;
  final String name;
  final String nameArabic;
  final String compiler;
  final String description;
  final int totalHadiths;
  final String grade;
  final List<String> languages;
  
  const HadithCollection({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.compiler,
    required this.description,
    required this.totalHadiths,
    required this.grade,
    required this.languages,
  });
  
  factory HadithCollection.fromJson(Map<String, dynamic> json) {
    return HadithCollection(
      id: json['id'],
      name: json['name'],
      nameArabic: json['name_arabic'],
      compiler: json['compiler'],
      description: json['description'],
      totalHadiths: json['total_hadiths'],
      grade: json['grade'],
      languages: List<String>.from(json['languages']),
    );
  }
}

class Hadith {
  final String id;
  final String number;
  final String textArabic;
  final Map<String, String> translations;
  final String narrator;
  final String grade;
  final String book;
  final String chapter;
  final List<String> references;
  final IsnadChain? isnad;
  
  const Hadith({
    required this.id,
    required this.number,
    required this.textArabic,
    required this.translations,
    required this.narrator,
    required this.grade,
    required this.book,
    required this.chapter,
    required this.references,
    this.isnad,
  });
  
  factory Hadith.fromJson(Map<String, dynamic> json) {
    return Hadith(
      id: json['id'],
      number: json['number'],
      textArabic: json['text_arabic'],
      translations: Map<String, String>.from(json['translations'] ?? {}),
      narrator: json['narrator'],
      grade: json['grade'],
      book: json['book'],
      chapter: json['chapter'],
      references: List<String>.from(json['references']),
      isnad: json['isnad'] != null 
        ? IsnadChain.fromJson(json['isnad'])
        : null,
    );
  }
}

class IsnadChain {
  final List<String> narrators;
  final String authenticity;
  final String verification;
  
  const IsnadChain({
    required this.narrators,
    required this.authenticity,
    required this.verification,
  });
  
  factory IsnadChain.fromJson(Map<String, dynamic> json) {
    return IsnadChain(
      narrators: List<String>.from(json['narrators']),
      authenticity: json['authenticity'],
      verification: json['verification'],
    );
  }
}
```

---

## 🧭 **Qibla Direction API**

### **Qibla Calculation**

```dart
/// Qibla Direction API methods
class QiblaApi {
  // Calculate Qibla direction
  static Future<QiblaResponse> calculateQiblaDirection({
    required double latitude,
    required double longitude,
    bool includeMagneticDeclination = true,
  }) async {
    final response = await DeenMateApiClient.get(
      '/qibla/direction',
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'magnetic_declination': includeMagneticDeclination,
      },
    );
    
    return QiblaResponse.fromJson(response.data);
  }
  
  // Get magnetic declination for location
  static Future<MagneticDeclinationResponse> getMagneticDeclination({
    required double latitude,
    required double longitude,
    DateTime? date,
  }) async {
    final response = await DeenMateApiClient.get(
      '/qibla/magnetic-declination',
      queryParameters: {
        'lat': latitude,
        'lng': longitude,
        'date': (date ?? DateTime.now()).toIso8601String().split('T')[0],
      },
    );
    
    return MagneticDeclinationResponse.fromJson(response.data);
  }
  
  // Verify Qibla direction accuracy
  static Future<QiblaVerificationResponse> verifyQiblaDirection({
    required double calculatedDirection,
    required double latitude,
    required double longitude,
  }) async {
    final response = await DeenMateApiClient.post('/verify/qibla', data: {
      'calculated_direction': calculatedDirection,
      'latitude': latitude,
      'longitude': longitude,
    });
    
    return QiblaVerificationResponse.fromJson(response.data);
  }
}
```

### **Qibla Data Models**

```dart
/// Qibla API Data Models
class QiblaResponse {
  final double direction;
  final double distance;
  final LocationData userLocation;
  final LocationData kaabaLocation;
  final double? magneticDeclination;
  final QiblaCalculationMethod method;
  
  const QiblaResponse({
    required this.direction,
    required this.distance,
    required this.userLocation,
    required this.kaabaLocation,
    this.magneticDeclination,
    required this.method,
  });
  
  factory QiblaResponse.fromJson(Map<String, dynamic> json) {
    return QiblaResponse(
      direction: json['direction'].toDouble(),
      distance: json['distance'].toDouble(),
      userLocation: LocationData.fromJson(json['user_location']),
      kaabaLocation: LocationData.fromJson(json['kaaba_location']),
      magneticDeclination: json['magnetic_declination']?.toDouble(),
      method: QiblaCalculationMethod.fromJson(json['method']),
    );
  }
}

class QiblaCalculationMethod {
  final String name;
  final String description;
  final double accuracy;
  
  const QiblaCalculationMethod({
    required this.name,
    required this.description,
    required this.accuracy,
  });
  
  factory QiblaCalculationMethod.fromJson(Map<String, dynamic> json) {
    return QiblaCalculationMethod(
      name: json['name'],
      description: json['description'],
      accuracy: json['accuracy'].toDouble(),
    );
  }
}
```

---

## 💰 **Zakat Calculator API**

### **Zakat Calculation Services**

```dart
/// Zakat Calculator API methods
class ZakatApi {
  // Calculate Zakat for assets
  static Future<ZakatCalculationResponse> calculateZakat({
    required List<ZakatAssetInput> assets,
    String currency = 'USD',
    String calculationMethod = 'standard',
  }) async {
    final response = await DeenMateApiClient.post('/zakat/calculate', data: {
      'assets': assets.map((asset) => asset.toJson()).toList(),
      'currency': currency,
      'calculation_method': calculationMethod,
    });
    
    return ZakatCalculationResponse.fromJson(response.data);
  }
  
  // Get current Nisab thresholds
  static Future<NisabThresholdsResponse> getNisabThresholds({
    String currency = 'USD',
  }) async {
    final response = await DeenMateApiClient.get(
      '/zakat/nisab',
      queryParameters: {
        'currency': currency,
      },
    );
    
    return NisabThresholdsResponse.fromJson(response.data);
  }
  
  // Get current gold and silver prices
  static Future<PreciousMetalPricesResponse> getPreciousMetalPrices({
    String currency = 'USD',
  }) async {
    final response = await DeenMateApiClient.get(
      '/zakat/metal-prices',
      queryParameters: {
        'currency': currency,
      },
    );
    
    return PreciousMetalPricesResponse.fromJson(response.data);
  }
  
  // Get currency exchange rates
  static Future<ExchangeRatesResponse> getExchangeRates({
    String baseCurrency = 'USD',
  }) async {
    final response = await DeenMateApiClient.get(
      '/zakat/exchange-rates',
      queryParameters: {
        'base': baseCurrency,
      },
    );
    
    return ExchangeRatesResponse.fromJson(response.data);
  }
  
  // Verify Zakat calculation
  static Future<ZakatVerificationResponse> verifyZakatCalculation({
    required ZakatCalculationResponse calculation,
    required List<ZakatAssetInput> assets,
  }) async {
    final response = await DeenMateApiClient.post('/verify/zakat', data: {
      'calculation': calculation.toJson(),
      'assets': assets.map((asset) => asset.toJson()).toList(),
    });
    
    return ZakatVerificationResponse.fromJson(response.data);
  }
}
```

### **Zakat Data Models**

```dart
/// Zakat API Data Models
class ZakatAssetInput {
  final String type;
  final double value;
  final String currency;
  final Map<String, dynamic> metadata;
  
  const ZakatAssetInput({
    required this.type,
    required this.value,
    required this.currency,
    this.metadata = const {},
  });
  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'value': value,
      'currency': currency,
      'metadata': metadata,
    };
  }
}

class ZakatCalculationResponse {
  final double totalZakatableWealth;
  final double nisabThreshold;
  final bool isZakatDue;
  final double zakatAmount;
  final List<AssetZakatBreakdown> breakdown;
  final String currency;
  final DateTime calculationDate;
  final ZakatCalculationMethod method;
  
  const ZakatCalculationResponse({
    required this.totalZakatableWealth,
    required this.nisabThreshold,
    required this.isZakatDue,
    required this.zakatAmount,
    required this.breakdown,
    required this.currency,
    required this.calculationDate,
    required this.method,
  });
  
  factory ZakatCalculationResponse.fromJson(Map<String, dynamic> json) {
    return ZakatCalculationResponse(
      totalZakatableWealth: json['total_zakatable_wealth'].toDouble(),
      nisabThreshold: json['nisab_threshold'].toDouble(),
      isZakatDue: json['is_zakat_due'],
      zakatAmount: json['zakat_amount'].toDouble(),
      breakdown: (json['breakdown'] as List)
        .map((item) => AssetZakatBreakdown.fromJson(item))
        .toList(),
      currency: json['currency'],
      calculationDate: DateTime.parse(json['calculation_date']),
      method: ZakatCalculationMethod.fromJson(json['method']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'total_zakatable_wealth': totalZakatableWealth,
      'nisab_threshold': nisabThreshold,
      'is_zakat_due': isZakatDue,
      'zakat_amount': zakatAmount,
      'breakdown': breakdown.map((item) => item.toJson()).toList(),
      'currency': currency,
      'calculation_date': calculationDate.toIso8601String(),
      'method': method.toJson(),
    };
  }
}

class AssetZakatBreakdown {
  final String assetType;
  final double value;
  final double zakatRate;
  final double zakatAmount;
  final bool meetsNisab;
  
  const AssetZakatBreakdown({
    required this.assetType,
    required this.value,
    required this.zakatRate,
    required this.zakatAmount,
    required this.meetsNisab,
  });
  
  factory AssetZakatBreakdown.fromJson(Map<String, dynamic> json) {
    return AssetZakatBreakdown(
      assetType: json['asset_type'],
      value: json['value'].toDouble(),
      zakatRate: json['zakat_rate'].toDouble(),
      zakatAmount: json['zakat_amount'].toDouble(),
      meetsNisab: json['meets_nisab'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'asset_type': assetType,
      'value': value,
      'zakat_rate': zakatRate,
      'zakat_amount': zakatAmount,
      'meets_nisab': meetsNisab,
    };
  }
}
```

---

## 📝 **Islamic Content API**

### **Islamic Content Services**

```dart
/// Islamic Content API methods
class IslamicContentApi {
  // Get daily Islamic content
  static Future<DailyContentResponse> getDailyContent({
    String language = 'en',
    DateTime? date,
  }) async {
    final response = await DeenMateApiClient.get(
      '/content/daily',
      queryParameters: {
        'language': language,
        'date': (date ?? DateTime.now()).toIso8601String().split('T')[0],
      },
    );
    
    return DailyContentResponse.fromJson(response.data);
  }
  
  // Get Islamic articles
  static Future<ArticleListResponse> getArticles({
    String? category,
    String language = 'en',
    int page = 1,
    int limit = 20,
  }) async {
    final response = await DeenMateApiClient.get(
      '/content/articles',
      queryParameters: {
        if (category != null) 'category': category,
        'language': language,
        'page': page,
        'limit': limit,
      },
    );
    
    return ArticleListResponse.fromJson(response.data);
  }
  
  // Get Islamic duas
  static Future<DuaListResponse> getDuas({
    String? category,
    String language = 'en',
    bool includeAudio = false,
  }) async {
    final response = await DeenMateApiClient.get(
      '/content/duas',
      queryParameters: {
        if (category != null) 'category': category,
        'language': language,
        'include_audio': includeAudio,
      },
    );
    
    return DuaListResponse.fromJson(response.data);
  }
  
  // Get Islamic calendar events
  static Future<IslamicCalendarResponse> getIslamicCalendar({
    required int islamicYear,
    int? islamicMonth,
    String language = 'en',
  }) async {
    final response = await DeenMateApiClient.get(
      '/content/calendar',
      queryParameters: {
        'islamic_year': islamicYear,
        if (islamicMonth != null) 'islamic_month': islamicMonth,
        'language': language,
      },
    );
    
    return IslamicCalendarResponse.fromJson(response.data);
  }
}
```

---

## ⚙️ **User Preferences API**

### **Preferences Management**

```dart
/// User Preferences API methods
class UserPreferencesApi {
  // Get user preferences
  static Future<UserPreferencesResponse> getPreferences() async {
    final response = await DeenMateApiClient.get('/preferences');
    return UserPreferencesResponse.fromJson(response.data);
  }
  
  // Update user preferences
  static Future<void> updatePreferences({
    required Map<String, dynamic> preferences,
  }) async {
    await DeenMateApiClient.put('/preferences', data: {
      'preferences': preferences,
    });
  }
  
  // Sync preferences across devices
  static Future<void> syncPreferences() async {
    await DeenMateApiClient.post('/preferences/sync');
  }
}
```

---

## 🚨 **Error Handling**

### **API Error Response Format**

```dart
/// Standard API Error Response
class ApiError {
  final String code;
  final String message;
  final String? details;
  final Map<String, dynamic>? metadata;
  
  const ApiError({
    required this.code,
    required this.message,
    this.details,
    this.metadata,
  });
  
  factory ApiError.fromJson(Map<String, dynamic> json) {
    return ApiError(
      code: json['error']['code'],
      message: json['error']['message'],
      details: json['error']['details'],
      metadata: json['error']['metadata'],
    );
  }
}

/// Common Error Codes
class ApiErrorCodes {
  static const String invalidApiKey = 'INVALID_API_KEY';
  static const String rateLimitExceeded = 'RATE_LIMIT_EXCEEDED';
  static const String invalidLocation = 'INVALID_LOCATION';
  static const String calculationError = 'CALCULATION_ERROR';
  static const String verificationFailed = 'VERIFICATION_FAILED';
  static const String contentNotFound = 'CONTENT_NOT_FOUND';
  static const String networkError = 'NETWORK_ERROR';
  static const String serverError = 'SERVER_ERROR';
}

/// Error Handling Implementation
class ApiErrorHandler {
  static void handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.receiveTimeout:
        throw ApiException('Network timeout. Please check your connection.');
      
      case DioErrorType.response:
        final apiError = ApiError.fromJson(error.response?.data);
        throw ApiException(apiError.message, code: apiError.code);
      
      case DioErrorType.cancel:
        throw ApiException('Request was cancelled.');
      
      default:
        throw ApiException('An unexpected error occurred.');
    }
  }
}

class ApiException implements Exception {
  final String message;
  final String? code;
  
  const ApiException(this.message, {this.code});
  
  @override
  String toString() => 'ApiException: $message';
}
```

---

## 🔒 **Rate Limiting**

### **API Rate Limits**

```dart
/// API Rate Limiting Information
class ApiRateLimits {
  // Rate limits by endpoint category
  static const Map<String, RateLimit> rateLimits = {
    'prayer_times': RateLimit(requests: 100, period: Duration(hours: 1)),
    'quran': RateLimit(requests: 200, period: Duration(hours: 1)),
    'hadith': RateLimit(requests: 150, period: Duration(hours: 1)),
    'qibla': RateLimit(requests: 50, period: Duration(hours: 1)),
    'zakat': RateLimit(requests: 30, period: Duration(hours: 1)),
    'content': RateLimit(requests: 100, period: Duration(hours: 1)),
    'verification': RateLimit(requests: 20, period: Duration(hours: 1)),
  };
  
  // Rate limit headers
  static const Map<String, String> rateLimitHeaders = {
    'X-RateLimit-Limit': 'Maximum requests per period',
    'X-RateLimit-Remaining': 'Remaining requests in current period',
    'X-RateLimit-Reset': 'Time when rate limit resets (Unix timestamp)',
    'Retry-After': 'Seconds to wait before retrying (when rate limited)',
  };
}

class RateLimit {
  final int requests;
  final Duration period;
  
  const RateLimit({required this.requests, required this.period});
}

/// Rate Limit Handler
class RateLimitHandler {
  static void handleRateLimit(DioError error) {
    if (error.response?.statusCode == 429) {
      final retryAfter = error.response?.headers['retry-after']?.first;
      final resetTime = error.response?.headers['x-ratelimit-reset']?.first;
      
      throw RateLimitException(
        'Rate limit exceeded. Please try again later.',
        retryAfter: retryAfter != null ? int.parse(retryAfter) : null,
        resetTime: resetTime != null ? int.parse(resetTime) : null,
      );
    }
  }
}

class RateLimitException implements Exception {
  final String message;
  final int? retryAfter;
  final int? resetTime;
  
  const RateLimitException(
    this.message, {
    this.retryAfter,
    this.resetTime,
  });
}
```

---

## 📦 **SDK Integration**

### **Flutter SDK Usage**

```dart
/// DeenMate Flutter SDK Integration
class DeenMateSDK {
  static bool _initialized = false;
  
  // Initialize SDK
  static Future<void> initialize({
    String? apiKey,
    bool enableOfflineMode = true,
    String defaultLanguage = 'en',
    Map<String, dynamic>? defaultPreferences,
  }) async {
    if (_initialized) return;
    
    // Initialize API client
    await DeenMateApiClient.initialize(
      apiKey: apiKey,
      enableOfflineMode: enableOfflineMode,
    );
    
    // Set default language
    await LocalizationManager.setLanguage(defaultLanguage);
    
    // Apply default preferences
    if (defaultPreferences != null) {
      await PreferencesManager.setDefaults(defaultPreferences);
    }
    
    // Initialize offline content
    if (enableOfflineMode) {
      await OfflineContentManager.initialize();
    }
    
    _initialized = true;
  }
  
  // Quick access methods for common operations
  static Future<PrayerTimes> getCurrentPrayerTimes() async {
    final location = await LocationManager.getCurrentLocation();
    final response = await PrayerTimesApi.getPrayerTimes(
      latitude: location.latitude,
      longitude: location.longitude,
      date: DateTime.now(),
    );
    return response.prayerTimes;
  }
  
  static Future<double> getQiblaDirection() async {
    final location = await LocationManager.getCurrentLocation();
    final response = await QiblaApi.calculateQiblaDirection(
      latitude: location.latitude,
      longitude: location.longitude,
    );
    return response.direction;
  }
  
  static Future<QuranChapter> getQuranChapter(int chapterNumber) async {
    final response = await QuranApi.getChapter(
      chapterNumber: chapterNumber,
      language: await PreferencesManager.getLanguage(),
    );
    return QuranChapter(
      number: response.chapter.number,
      name: response.chapter.nameEnglish,
      verses: response.verses,
    );
  }
}

/// Usage Example
void main() async {
  // Initialize DeenMate SDK
  await DeenMateSDK.initialize(
    apiKey: 'your_api_key_here',
    enableOfflineMode: true,
    defaultLanguage: 'en',
  );
  
  // Use SDK methods
  try {
    final prayerTimes = await DeenMateSDK.getCurrentPrayerTimes();
    print('Next prayer: ${prayerTimes.getNextPrayer()}');
    
    final qiblaDirection = await DeenMateSDK.getQiblaDirection();
    print('Qibla direction: ${qiblaDirection}°');
    
    final alFatiha = await DeenMateSDK.getQuranChapter(1);
    print('Al-Fatiha has ${alFatiha.verses.length} verses');
    
  } catch (e) {
    print('Error: $e');
  }
}
```

---

*This API Reference Guide provides comprehensive documentation for integrating all DeenMate Islamic features, ensuring developers can build authentic and accurate Islamic applications with ease.*

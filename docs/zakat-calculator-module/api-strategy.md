# Zakat Calculator Module - API Strategy & Implementation

**Last Updated**: 29 August 2025  
**Module Status**: ✅ Implemented  
**Priority**: P0 (High)

---

## 📋 **API OVERVIEW**

### **Primary APIs**
The Zakat Calculator module uses multiple APIs for currency conversion and precious metals pricing to ensure accurate calculations based on current market values.

**Currency API**: Exchange Rate API  
**Precious Metals API**: Gold/Silver Price API  
**Documentation**: [Exchange Rate API](https://exchangerate-api.com/)  
**Rate Limits**: 1000 requests per month (free tier)  
**Authentication**: API key required

---

## 🔌 **API ENDPOINTS**

### **Currency Conversion API**

#### **Latest Exchange Rates**
```http
GET https://api.exchangerate-api.com/v4/latest/{base_currency}
```

**Purpose**: Get latest exchange rates for currency conversion  
**Parameters**:
- `base_currency`: Base currency code (e.g., 'USD', 'BDT')

**Response Example**:
```json
{
  "result": "success",
  "base_code": "USD",
  "target_code": "BDT",
  "conversion_rate": 109.5,
  "conversion_result": 1095.0
}
```

**Implementation**:
```dart
class CurrencyApi {
  Future<Map<String, double>> getExchangeRates(String baseCurrency) async {
    final response = await dio.get('/v4/latest/$baseCurrency');
    
    final rates = <String, double>{};
    final ratesData = response.data['rates'] as Map<String, dynamic>;
    
    for (final entry in ratesData.entries) {
      rates[entry.key] = (entry.value as num).toDouble();
    }
    
    return rates;
  }
}
```

#### **Currency Conversion**
```http
GET https://api.exchangerate-api.com/v4/convert/{from}/{to}/{amount}
```

**Purpose**: Convert specific amount between currencies  
**Parameters**:
- `from`: Source currency code
- `to`: Target currency code
- `amount`: Amount to convert

**Response Example**:
```json
{
  "result": "success",
  "base_code": "USD",
  "target_code": "BDT",
  "conversion_rate": 109.5,
  "conversion_result": 1095.0
}
```

**Implementation**:
```dart
class CurrencyApi {
  Future<double> convertCurrency({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    final response = await dio.get('/v4/convert/$fromCurrency/$toCurrency/$amount');
    
    return (response.data['conversion_result'] as num).toDouble();
  }
}
```

### **Precious Metals API**

#### **Gold and Silver Prices**
```http
GET https://api.metals.live/v1/spot
```

**Purpose**: Get current gold and silver spot prices  
**Parameters**: None

**Response Example**:
```json
[
  {
    "gold": 1950.50,
    "silver": 24.75,
    "platinum": 950.25,
    "palladium": 1200.00,
    "rhodium": 8000.00,
    "timestamp": 1732838400
  }
]
```

**Implementation**:
```dart
class PreciousMetalsApi {
  Future<Map<String, double>> getPreciousMetalsPrices() async {
    final response = await dio.get('/v1/spot');
    final data = response.data[0] as Map<String, dynamic>;
    
    return {
      'gold': (data['gold'] as num).toDouble(),
      'silver': (data['silver'] as num).toDouble(),
    };
  }
}
```

---

## 💱 **CURRENCY SUPPORT**

### **Supported Currencies**

| Currency | Code | Status | Priority |
|----------|------|--------|----------|
| **Bangladeshi Taka** | BDT | ✅ Primary | P0 |
| **US Dollar** | USD | ✅ Active | P1 |
| **Euro** | EUR | ✅ Active | P1 |
| **British Pound** | GBP | ✅ Active | P1 |
| **Saudi Riyal** | SAR | ✅ Active | P1 |
| **UAE Dirham** | AED | ✅ Active | P1 |
| **Indian Rupee** | INR | ✅ Active | P2 |
| **Pakistani Rupee** | PKR | ✅ Active | P2 |
| **Turkish Lira** | TRY | ✅ Active | P2 |
| **Malaysian Ringgit** | MYR | ✅ Active | P2 |

### **Currency Configuration**
```dart
class CurrencyConfig {
  static const String defaultCurrency = 'BDT';
  
  static const Map<String, String> currencyNames = {
    'BDT': 'Bangladeshi Taka',
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'SAR': 'Saudi Riyal',
    'AED': 'UAE Dirham',
    'INR': 'Indian Rupee',
    'PKR': 'Pakistani Rupee',
    'TRY': 'Turkish Lira',
    'MYR': 'Malaysian Ringgit',
  };
  
  static const Map<String, String> currencySymbols = {
    'BDT': '৳',
    'USD': '\$',
    'EUR': '€',
    'GBP': '£',
    'SAR': 'ر.س',
    'AED': 'د.إ',
    'INR': '₹',
    'PKR': '₨',
    'TRY': '₺',
    'MYR': 'RM',
  };
}
```

---

## 🔄 **CACHING STRATEGY**

### **Cache Configuration**
```dart
class ZakatCalculatorCacheConfig {
  // Cache expiry times
  static const Duration currencyRatesCacheExpiry = Duration(hours: 24);
  static const Duration preciousMetalsCacheExpiry = Duration(hours: 6);
  static const Duration calculationsCacheExpiry = Duration(days: 30);
  
  // Cache keys
  static const String currencyRatesCacheKey = 'currency_rates';
  static const String preciousMetalsCacheKey = 'precious_metals';
  static const String calculationsCacheKey = 'zakat_calculations';
  
  // Cache size limits
  static const int maxCachedRates = 50;
  static const int maxCachedCalculations = 100;
}
```

### **Currency Rate Caching**
```dart
class CurrencyRateCacheService {
  static const String currencyRatesBox = 'currency_rates';

  Future<void> cacheCurrencyRates(Map<String, double> rates) async {
    final prefs = await SharedPreferences.getInstance();
    final ratesJson = jsonEncode(rates);
    await prefs.setString('currency_rates', ratesJson);
    await prefs.setInt('currency_rates_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<Map<String, double>?> getCachedCurrencyRates() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('currency_rates_timestamp');
    
    if (timestamp == null) return null;
    
    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (cacheAge > ZakatCalculatorCacheConfig.currencyRatesCacheExpiry.inMilliseconds) {
      return null;
    }
    
    final ratesJson = prefs.getString('currency_rates');
    if (ratesJson == null) return null;
    
    final ratesMap = jsonDecode(ratesJson) as Map<String, dynamic>;
    return ratesMap.map((key, value) => MapEntry(key, (value as num).toDouble()));
  }
}
```

### **Calculation Caching**
```dart
class ZakatCalculationCacheService {
  static const String calculationsBox = 'zakat_calculations';

  Future<void> cacheCalculation(ZakatCalculationResult result) async {
    final box = await Hive.openBox<ZakatCalculationResult>(calculationsBox);
    final key = '${result.calculationDate.millisecondsSinceEpoch}';
    
    await box.put(key, result);
  }

  Future<List<ZakatCalculationResult>> getCachedCalculations() async {
    final box = await Hive.openBox<ZakatCalculationResult>(calculationsBox);
    return box.values.toList();
  }

  Future<void> clearOldCalculations() async {
    final box = await Hive.openBox<ZakatCalculationResult>(calculationsBox);
    final cutoffDate = DateTime.now().subtract(ZakatCalculatorCacheConfig.calculationsCacheExpiry);
    
    final keysToDelete = <String>[];
    for (final entry in box.toMap().entries) {
      if (entry.value.calculationDate.isBefore(cutoffDate)) {
        keysToDelete.add(entry.key);
      }
    }
    
    await box.deleteAll(keysToDelete);
  }
}
```

---

## 🚀 **OFFLINE STRATEGY**

### **Offline Data Management**
```dart
class ZakatCalculatorOfflineService {
  final CurrencyRateCacheService _currencyCache;
  final ZakatCalculationCacheService _calculationCache;
  final NetworkInfo _networkInfo;

  ZakatCalculatorOfflineService(
    this._currencyCache,
    this._calculationCache,
    this._networkInfo,
  );

  Future<Map<String, double>> getCurrencyRates() async {
    // Always try cache first
    final cachedRates = await _currencyCache.getCachedCurrencyRates();
    if (cachedRates != null) {
      return cachedRates;
    }

    // If no cache and no network, use default rates
    if (!await _networkInfo.isConnected) {
      return _getDefaultCurrencyRates();
    }

    // Fetch from API and cache
    final rates = await _fetchCurrencyRatesFromApi();
    await _currencyCache.cacheCurrencyRates(rates);
    return rates;
  }

  Future<Map<String, double>> _getDefaultCurrencyRates() async {
    // Default rates as fallback
    return {
      'USD': 1.0,
      'BDT': 109.5,
      'EUR': 0.85,
      'GBP': 0.73,
      'SAR': 3.75,
      'AED': 3.67,
      'INR': 82.5,
      'PKR': 280.0,
      'TRY': 26.8,
      'MYR': 4.65,
    };
  }

  Future<ZakatCalculationResult> calculateZakatOffline({
    required List<ZakatAsset> assets,
    required String currency,
  }) async {
    // Use cached rates or default rates
    final rates = await getCurrencyRates();
    final goldPricePerGram = _getGoldPricePerGram(currency, rates);
    final silverPricePerGram = _getSilverPricePerGram(currency, rates);

    return ZakatCalculationService().calculateTotalZakat(
      assets: assets,
      goldPricePerGram: goldPricePerGram,
      silverPricePerGram: silverPricePerGram,
    );
  }
}
```

---

## 🔒 **SECURITY & RATE LIMITING**

### **Rate Limiting Strategy**
```dart
class ZakatCalculatorApiRateLimiter {
  static const int maxRequestsPerHour = 100;
  static const int maxRequestsPerDay = 1000;
  
  final Map<String, List<DateTime>> _requestHistory = {};
  
  Future<void> checkRateLimit(String endpoint) async {
    final now = DateTime.now();
    final key = endpoint;
    
    if (!_requestHistory.containsKey(key)) {
      _requestHistory[key] = [];
    }
    
    final requests = _requestHistory[key]!;
    
    // Remove requests older than 1 day
    requests.removeWhere((time) => now.difference(time).inDays > 0);
    
    // Check daily limit
    if (requests.length >= maxRequestsPerDay) {
      throw RateLimitException('Daily rate limit exceeded');
    }
    
    // Remove requests older than 1 hour
    requests.removeWhere((time) => now.difference(time).inHours > 0);
    
    // Check hourly limit
    if (requests.length >= maxRequestsPerHour) {
      throw RateLimitException('Hourly rate limit exceeded');
    }
    
    // Add current request
    requests.add(now);
  }
}
```

### **Error Handling**
```dart
class ZakatCalculatorApiErrorHandler {
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
              return 'Currency rates not found.';
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
class ZakatCalculatorApiAnalytics {
  static void trackApiCall(String endpoint, Duration responseTime, bool success) {
    FirebaseAnalytics.instance.logEvent(
      name: 'zakat_calculator_api_call',
      parameters: {
        'endpoint': endpoint,
        'response_time_ms': responseTime.inMilliseconds,
        'success': success,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackCalculation(String assetType, double amount, String currency) {
    FirebaseAnalytics.instance.logEvent(
      name: 'zakat_calculation',
      parameters: {
        'asset_type': assetType,
        'amount': amount,
        'currency': currency,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackCurrencyConversion(String fromCurrency, String toCurrency) {
    FirebaseAnalytics.instance.logEvent(
      name: 'currency_conversion',
      parameters: {
        'from_currency': fromCurrency,
        'to_currency': toCurrency,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
```

### **Performance Monitoring**
```dart
class ZakatCalculatorPerformanceTracker {
  static void trackCalculationTime(Duration calculationTime) {
    FirebasePerformance.instance.newTrace('zakat_calculation').then((trace) {
      trace.setMetric('calculation_time_ms', calculationTime.inMilliseconds);
      trace.stop();
    });
  }

  static void trackCurrencyConversionTime(Duration conversionTime) {
    FirebasePerformance.instance.newTrace('currency_conversion').then((trace) {
      trace.setMetric('conversion_time_ms', conversionTime.inMilliseconds);
      trace.stop();
    });
  }

  static void trackCacheHit(String cacheType) {
    FirebasePerformance.instance.newTrace('cache_hit').then((trace) {
      trace.setMetric('cache_type', cacheType.hashCode);
      trace.stop();
    });
  }
}
```

---

## 🔄 **FALLBACK STRATEGIES**

### **API Fallback Chain**
1. **Primary**: Exchange Rate API for currency conversion
2. **Secondary**: Cached rates with 24-hour TTL
3. **Tertiary**: Default rates for offline access

### **Currency Fallback**
```dart
class CurrencyFallbackService {
  static Map<String, double> getDefaultRates() {
    return {
      'USD': 1.0,
      'BDT': 109.5,
      'EUR': 0.85,
      'GBP': 0.73,
      'SAR': 3.75,
      'AED': 3.67,
      'INR': 82.5,
      'PKR': 280.0,
      'TRY': 26.8,
      'MYR': 4.65,
    };
  }

  static double getGoldPricePerGram(String currency) {
    final goldPrices = {
      'USD': 62.5,  // $62.5 per gram
      'BDT': 6843.75, // ৳6843.75 per gram
      'EUR': 53.125, // €53.125 per gram
      'GBP': 45.625, // £45.625 per gram
      'SAR': 234.375, // ر.س234.375 per gram
      'AED': 229.375, // د.إ229.375 per gram
    };
    
    return goldPrices[currency] ?? 62.5; // Default to USD price
  }

  static double getSilverPricePerGram(String currency) {
    final silverPrices = {
      'USD': 0.8,   // $0.8 per gram
      'BDT': 87.6,  // ৳87.6 per gram
      'EUR': 0.68,  // €0.68 per gram
      'GBP': 0.584, // £0.584 per gram
      'SAR': 3.0,   // ر.س3.0 per gram
      'AED': 2.936, // د.إ2.936 per gram
    };
    
    return silverPrices[currency] ?? 0.8; // Default to USD price
  }
}
```

---

## 📚 **DOCUMENTATION FILES**

- **`README.md`** - Overview & purpose of the module
- **`zakat-calculator-module-specification.md`** - Complete technical specification
- **`todo-zakat-calculator.md`** - Detailed development tasks and tracking
- **`project-tracking.md`** - High-level project tracking

---

*Last Updated: 29 August 2025*  
*File Location: docs/zakat-calculator-module/api-strategy.md*

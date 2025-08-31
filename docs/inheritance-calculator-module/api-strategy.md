# Inheritance Calculator Module - API Strategy & Implementation

**Last Updated**: 29 August 2025  
**Module Status**: ✅ Implemented  
**Priority**: P0 (High)

---

## 📋 **API OVERVIEW**

### **Primary APIs**
The Inheritance Calculator module is primarily offline-focused with minimal external API dependencies, ensuring privacy and data security for sensitive family inheritance calculations.

**Educational Content API**: Islamic Content API (Optional)  
**Currency API**: Exchange Rate API (For estate value conversion)  
**Documentation**: [Islamic Content API](https://api.islamic-content.com/)  
**Rate Limits**: 100 requests per day (free tier)  
**Authentication**: API key required (optional)

---

## 🔌 **API ENDPOINTS**

### **Educational Content API**

#### **Islamic Inheritance Rules**
```http
GET https://api.islamic-content.com/v1/inheritance/rules
```

**Purpose**: Get Islamic inheritance rules and explanations  
**Parameters**:
- `language`: Language code (e.g., 'en', 'bn', 'ar')
- `category`: Content category (e.g., 'fixed_shares', 'residuaries')

**Response Example**:
```json
{
  "success": true,
  "data": {
    "rules": [
      {
        "id": "rule_001",
        "title": "Fixed Share Heirs",
        "description": "Ashab al-Furud are heirs with fixed shares",
        "content": "Fixed share heirs include husband, wife, father, mother...",
        "references": [
          "Surah An-Nisa 4:11",
          "Sahih Bukhari 6732"
        ],
        "examples": [
          {
            "scenario": "Husband with children",
            "share": "1/4",
            "explanation": "Husband gets 1/4 when there are children"
          }
        ]
      }
    ]
  }
}
```

**Implementation**:
```dart
class IslamicContentApi {
  Future<List<EducationalContent>> getInheritanceRules({
    String language = 'en',
    String? category,
  }) async {
    final queryParams = <String, dynamic>{
      'language': language,
    };
    
    if (category != null) {
      queryParams['category'] = category;
    }
    
    final response = await dio.get('/v1/inheritance/rules', queryParameters: queryParams);
    
    final rulesData = response.data['data']['rules'] as List;
    return rulesData
        .map((rule) => EducationalContent.fromJson(rule))
        .toList();
  }
}
```

#### **Calculation Examples**
```http
GET https://api.islamic-content.com/v1/inheritance/examples
```

**Purpose**: Get inheritance calculation examples  
**Parameters**:
- `language`: Language code
- `complexity`: Example complexity (simple, moderate, complex)

**Response Example**:
```json
{
  "success": true,
  "data": {
    "examples": [
      {
        "id": "example_001",
        "title": "Simple Inheritance Case",
        "description": "Husband, wife, son, daughter",
        "heirs": [
          {"name": "Husband", "category": "husband", "count": 1},
          {"name": "Wife", "category": "wife", "count": 1},
          {"name": "Son", "category": "son", "count": 1},
          {"name": "Daughter", "category": "daughter", "count": 1}
        ],
        "total_estate": 100000,
        "calculation": {
          "Husband": 25000,
          "Wife": 12500,
          "Son": 41666.67,
          "Daughter": 20833.33
        },
        "explanation": "Husband gets 1/4, wife gets 1/8, remaining divided 2:1 between son and daughter"
      }
    ]
  }
}
```

**Implementation**:
```dart
class IslamicContentApi {
  Future<List<CalculationExample>> getCalculationExamples({
    String language = 'en',
    String complexity = 'simple',
  }) async {
    final response = await dio.get('/v1/inheritance/examples', queryParameters: {
      'language': language,
      'complexity': complexity,
    });
    
    final examplesData = response.data['data']['examples'] as List;
    return examplesData
        .map((example) => CalculationExample.fromJson(example))
        .toList();
  }
}
```

### **Currency Conversion API**

#### **Estate Value Conversion**
```http
GET https://api.exchangerate-api.com/v4/convert/{from}/{to}/{amount}
```

**Purpose**: Convert estate value between currencies  
**Parameters**:
- `from`: Source currency code
- `to`: Target currency code
- `amount`: Estate amount to convert

**Response Example**:
```json
{
  "result": "success",
  "base_code": "USD",
  "target_code": "BDT",
  "conversion_rate": 109.5,
  "conversion_result": 1095000.0
}
```

**Implementation**:
```dart
class CurrencyApi {
  Future<double> convertEstateValue({
    required String fromCurrency,
    required String toCurrency,
    required double amount,
  }) async {
    final response = await dio.get('/v4/convert/$fromCurrency/$toCurrency/$amount');
    
    return (response.data['conversion_result'] as num).toDouble();
  }
}
```

---

## 🏠 **OFFLINE-FIRST STRATEGY**

### **Local Data Storage**

#### **Inheritance Rules Cache**
```dart
class InheritanceRulesCache {
  static const String rulesCacheKey = 'inheritance_rules';
  static const Duration cacheExpiry = Duration(days: 90);

  Future<void> cacheInheritanceRules(List<EducationalContent> rules) async {
    final prefs = await SharedPreferences.getInstance();
    final rulesJson = jsonEncode(rules.map((rule) => rule.toJson()).toList());
    await prefs.setString(rulesCacheKey, rulesJson);
    await prefs.setInt('${rulesCacheKey}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<EducationalContent>?> getCachedInheritanceRules() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('${rulesCacheKey}_timestamp');
    
    if (timestamp == null) return null;
    
    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (cacheAge > InheritanceRulesCache.cacheExpiry.inMilliseconds) {
      return null;
    }
    
    final rulesJson = prefs.getString(rulesCacheKey);
    if (rulesJson == null) return null;
    
    final rulesList = jsonDecode(rulesJson) as List;
    return rulesList
        .map((rule) => EducationalContent.fromJson(rule))
        .toList();
  }
}
```

#### **Calculation Examples Cache**
```dart
class CalculationExamplesCache {
  static const String examplesCacheKey = 'calculation_examples';
  static const Duration cacheExpiry = Duration(days: 90);

  Future<void> cacheCalculationExamples(List<CalculationExample> examples) async {
    final prefs = await SharedPreferences.getInstance();
    final examplesJson = jsonEncode(examples.map((example) => example.toJson()).toList());
    await prefs.setString(examplesCacheKey, examplesJson);
    await prefs.setInt('${examplesCacheKey}_timestamp', DateTime.now().millisecondsSinceEpoch);
  }

  Future<List<CalculationExample>?> getCachedCalculationExamples() async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getInt('${examplesCacheKey}_timestamp');
    
    if (timestamp == null) return null;
    
    final cacheAge = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (cacheAge > CalculationExamplesCache.cacheExpiry.inMilliseconds) {
      return null;
    }
    
    final examplesJson = prefs.getString(examplesCacheKey);
    if (examplesJson == null) return null;
    
    final examplesList = jsonDecode(examplesJson) as List;
    return examplesList
        .map((example) => CalculationExample.fromJson(example))
        .toList();
  }
}
```

### **Built-in Islamic Content**

#### **Default Inheritance Rules**
```dart
class DefaultInheritanceRules {
  static List<EducationalContent> getDefaultRules() {
    return [
      EducationalContent(
        id: 'rule_001',
        title: 'Fixed Share Heirs (Ashab al-Furud)',
        description: 'Heirs with predetermined shares in the estate',
        content: '''
Fixed share heirs include:
- Husband: 1/4 (with children) or 1/2 (without children)
- Wife: 1/8 (with children) or 1/4 (without children)
- Father: 1/6 (with children) or 1/3 (without children)
- Mother: 1/6 (with children) or 1/3 (without children)
- Daughter: 1/2 (single) or 2/3 (multiple)
- Full Sister: 1/2 (single) or 2/3 (multiple)
- Half Sister: 1/2 (single) or 2/3 (multiple)
- Uterine Sister: 1/6 (single) or 1/3 (multiple)
        ''',
        references: ['Surah An-Nisa 4:11', 'Surah An-Nisa 4:12'],
        category: 'fixed_shares',
      ),
      EducationalContent(
        id: 'rule_002',
        title: 'Residuary Heirs (Asabah)',
        description: 'Heirs who receive the remaining estate after fixed shares',
        content: '''
Residuary heirs include:
- Son: Receives remaining estate
- Grandson: Receives remaining estate (if no son)
- Father: Receives remaining estate (if no children)
- Full Brother: Receives remaining estate (if no father/children)
- Half Brother: Receives remaining estate (if no full brother)
        ''',
        references: ['Sahih Bukhari 6732'],
        category: 'residuaries',
      ),
      EducationalContent(
        id: 'rule_003',
        title: 'Exclusion Rules (Mahjub)',
        description: 'Rules for excluding certain heirs',
        content: '''
Exclusion rules:
- Father excludes grandfather
- Son excludes grandson
- Full brother excludes half brother
- Grandfather excludes grandmother
        ''',
        references: ['Islamic Inheritance Law'],
        category: 'exclusion_rules',
      ),
    ];
  }
}
```

#### **Default Calculation Examples**
```dart
class DefaultCalculationExamples {
  static List<CalculationExample> getDefaultExamples() {
    return [
      CalculationExample(
        id: 'example_001',
        title: 'Simple Case: Husband, Wife, Son, Daughter',
        description: 'Basic inheritance with common heirs',
        heirs: [
          Heir(id: '1', name: 'Husband', category: HeirCategory.husband, gender: HeirGender.male, count: 1, shareType: HeirShareType.fixed),
          Heir(id: '2', name: 'Wife', category: HeirCategory.wife, gender: HeirGender.female, count: 1, shareType: HeirShareType.fixed),
          Heir(id: '3', name: 'Son', category: HeirCategory.son, gender: HeirGender.male, count: 1, shareType: HeirShareType.residuary),
          Heir(id: '4', name: 'Daughter', category: HeirCategory.daughter, gender: HeirGender.female, count: 1, shareType: HeirShareType.fixed),
        ],
        totalEstate: 100000,
        calculation: {
          'Husband': 25000.0,
          'Wife': 12500.0,
          'Son': 41666.67,
          'Daughter': 20833.33,
        },
        explanation: 'Husband gets 1/4 (25,000), wife gets 1/8 (12,500), remaining 62,500 divided 2:1 between son and daughter',
      ),
      CalculationExample(
        id: 'example_002',
        title: 'Complex Case: Father, Mother, Husband, Daughter',
        description: 'Inheritance with multiple fixed share heirs',
        heirs: [
          Heir(id: '1', name: 'Father', category: HeirCategory.father, gender: HeirGender.male, count: 1, shareType: HeirShareType.fixed),
          Heir(id: '2', name: 'Mother', category: HeirCategory.mother, gender: HeirGender.female, count: 1, shareType: HeirShareType.fixed),
          Heir(id: '3', name: 'Husband', category: HeirCategory.husband, gender: HeirGender.male, count: 1, shareType: HeirShareType.fixed),
          Heir(id: '4', name: 'Daughter', category: HeirCategory.daughter, gender: HeirGender.female, count: 1, shareType: HeirShareType.fixed),
        ],
        totalEstate: 100000,
        calculation: {
          'Father': 16666.67,
          'Mother': 16666.67,
          'Husband': 25000.0,
          'Daughter': 41666.67,
        },
        explanation: 'Father gets 1/6 (16,667), mother gets 1/6 (16,667), husband gets 1/4 (25,000), daughter gets 1/2 (41,667)',
      ),
    ];
  }
}
```

---

## 🔄 **CACHING STRATEGY**

### **Cache Configuration**
```dart
class InheritanceCalculatorCacheConfig {
  // Cache expiry times
  static const Duration inheritanceRulesCacheExpiry = Duration(days: 90);
  static const Duration calculationExamplesCacheExpiry = Duration(days: 90);
  static const Duration calculationsCacheExpiry = Duration(days: 365);
  static const Duration currencyRatesCacheExpiry = Duration(hours: 24);
  
  // Cache keys
  static const String inheritanceRulesCacheKey = 'inheritance_rules';
  static const String calculationExamplesCacheKey = 'calculation_examples';
  static const String calculationsCacheKey = 'inheritance_calculations';
  static const String currencyRatesCacheKey = 'currency_rates';
  
  // Cache size limits
  static const int maxCachedRules = 100;
  static const int maxCachedExamples = 50;
  static const int maxCachedCalculations = 200;
}
```

### **Calculation Caching**
```dart
class InheritanceCalculationCacheService {
  static const String calculationsBox = 'inheritance_calculations';

  Future<void> cacheCalculation(InheritanceCalculation result) async {
    final box = await Hive.openBox<InheritanceCalculation>(calculationsBox);
    final key = '${result.calculationDate.millisecondsSinceEpoch}';
    
    await box.put(key, result);
  }

  Future<List<InheritanceCalculation>> getCachedCalculations() async {
    final box = await Hive.openBox<InheritanceCalculation>(calculationsBox);
    return box.values.toList();
  }

  Future<void> clearOldCalculations() async {
    final box = await Hive.openBox<InheritanceCalculation>(calculationsBox);
    final cutoffDate = DateTime.now().subtract(InheritanceCalculatorCacheConfig.calculationsCacheExpiry);
    
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
class InheritanceCalculatorOfflineService {
  final InheritanceRulesCache _rulesCache;
  final CalculationExamplesCache _examplesCache;
  final NetworkInfo _networkInfo;

  InheritanceCalculatorOfflineService(
    this._rulesCache,
    this._examplesCache,
    this._networkInfo,
  );

  Future<List<EducationalContent>> getInheritanceRules() async {
    // Always try cache first
    final cachedRules = await _rulesCache.getCachedInheritanceRules();
    if (cachedRules != null) {
      return cachedRules;
    }

    // If no cache and no network, use default rules
    if (!await _networkInfo.isConnected) {
      return DefaultInheritanceRules.getDefaultRules();
    }

    // Fetch from API and cache
    final rules = await _fetchInheritanceRulesFromApi();
    await _rulesCache.cacheInheritanceRules(rules);
    return rules;
  }

  Future<List<CalculationExample>> getCalculationExamples() async {
    // Always try cache first
    final cachedExamples = await _examplesCache.getCachedCalculationExamples();
    if (cachedExamples != null) {
      return cachedExamples;
    }

    // If no cache and no network, use default examples
    if (!await _networkInfo.isConnected) {
      return DefaultCalculationExamples.getDefaultExamples();
    }

    // Fetch from API and cache
    final examples = await _fetchCalculationExamplesFromApi();
    await _examplesCache.cacheCalculationExamples(examples);
    return examples;
  }

  Future<InheritanceCalculation> calculateInheritanceOffline({
    required List<Heir> heirs,
    required double totalEstate,
  }) async {
    // Use local calculation service
    return InheritanceCalculationService().calculateInheritance(
      heirs: heirs,
      totalEstate: totalEstate,
    );
  }
}
```

---

## 🔒 **SECURITY & PRIVACY**

### **Privacy-First Approach**
```dart
class InheritanceCalculatorPrivacyService {
  // No personal data transmission
  static bool shouldTransmitData() {
    return false; // Never transmit personal inheritance data
  }

  // Local data encryption
  static Future<void> encryptLocalData() async {
    // Implement local encryption for sensitive data
  }

  // Data anonymization for analytics
  static Map<String, dynamic> anonymizeData(Map<String, dynamic> data) {
    // Remove personal identifiers
    final anonymized = Map<String, dynamic>.from(data);
    anonymized.remove('heirNames');
    anonymized.remove('familyDetails');
    return anonymized;
  }
}
```

### **Rate Limiting Strategy**
```dart
class InheritanceCalculatorApiRateLimiter {
  static const int maxRequestsPerDay = 100;
  static const int maxRequestsPerHour = 10;
  
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

---

## 📊 **MONITORING & ANALYTICS**

### **Usage Analytics**
```dart
class InheritanceCalculatorAnalytics {
  static void trackCalculation(String scenario, int heirCount) {
    FirebaseAnalytics.instance.logEvent(
      name: 'inheritance_calculation',
      parameters: {
        'scenario': scenario,
        'heir_count': heirCount,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackEducationalContentAccess(String contentId) {
    FirebaseAnalytics.instance.logEvent(
      name: 'educational_content_access',
      parameters: {
        'content_id': contentId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  static void trackOfflineUsage(String feature) {
    FirebaseAnalytics.instance.logEvent(
      name: 'inheritance_offline_usage',
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
class InheritanceCalculatorPerformanceTracker {
  static void trackCalculationTime(Duration calculationTime) {
    FirebasePerformance.instance.newTrace('inheritance_calculation').then((trace) {
      trace.setMetric('calculation_time_ms', calculationTime.inMilliseconds);
      trace.stop();
    });
  }

  static void trackHeirProcessingTime(Duration processingTime) {
    FirebasePerformance.instance.newTrace('heir_processing').then((trace) {
      trace.setMetric('processing_time_ms', processingTime.inMilliseconds);
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
1. **Primary**: Local calculation engine (always available)
2. **Secondary**: Cached educational content (90-day TTL)
3. **Tertiary**: Built-in default content (always available)

### **Content Fallback**
```dart
class ContentFallbackService {
  static List<EducationalContent> getFallbackRules() {
    return DefaultInheritanceRules.getDefaultRules();
  }

  static List<CalculationExample> getFallbackExamples() {
    return DefaultCalculationExamples.getDefaultExamples();
  }

  static Map<String, String> getFallbackReferences() {
    return {
      'quran': 'Surah An-Nisa 4:11-12, 4:176',
      'hadith': 'Sahih Bukhari 6732, Sahih Muslim 1615',
      'scholarly': 'Islamic Inheritance Law - Standard Rules',
    };
  }
}
```

---

## 📚 **DOCUMENTATION FILES**

- **`README.md`** - Overview & purpose of the module
- **`inheritance-calculator-module-specification.md`** - Complete technical specification
- **`todo-inheritance-calculator.md`** - Detailed development tasks and tracking
- **`project-tracking.md`** - High-level project tracking

---

*Last Updated: 29 August 2025*  
*File Location: docs/inheritance-calculator-module/api-strategy.md*

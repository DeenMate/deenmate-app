// Data Transfer Objects for metal prices API responses
// Handles serialization/deserialization of precious metal price data

import 'package:equatable/equatable.dart';
import '../../domain/entities/nisab_threshold.dart';

/// DTO for metal prices from external APIs
class MetalPricesDto extends Equatable {
  const MetalPricesDto({
    required this.goldPricePerGram,
    required this.silverPricePerGram,
    required this.currency,
    required this.lastUpdated,
    required this.source,
    this.isRealTime = true,
  });

  final double goldPricePerGram;
  final double silverPricePerGram;
  final String currency;
  final DateTime lastUpdated;
  final String source;
  final bool isRealTime;

  /// Create from API response data
  factory MetalPricesDto.fromApiResponse(
    List<dynamic> apiData,
    String currency,
  ) {
    double goldPrice = 0;
    double silverPrice = 0;

    for (final item in apiData) {
      final metal = item as Map<String, dynamic>;
      final symbol = metal['symbol'] as String;
      final price = (metal['price'] as num).toDouble();
      
      // Convert from troy ounce to gram (1 troy ounce = 31.1035 grams)
      final pricePerGram = price / 31.1035;

      if (symbol == 'XAU') { // Gold
        goldPrice = pricePerGram;
      } else if (symbol == 'XAG') { // Silver
        silverPrice = pricePerGram;
      }
    }

    return MetalPricesDto(
      goldPricePerGram: goldPrice,
      silverPricePerGram: silverPrice,
      currency: currency,
      lastUpdated: DateTime.now(),
      source: 'metals.live',
      isRealTime: true,
    );
  }

  /// Create from JSON
  factory MetalPricesDto.fromJson(Map<String, dynamic> json) {
    return MetalPricesDto(
      goldPricePerGram: (json['goldPricePerGram'] as num).toDouble(),
      silverPricePerGram: (json['silverPricePerGram'] as num).toDouble(),
      currency: json['currency'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      source: json['source'] as String,
      isRealTime: json['isRealTime'] as bool? ?? true,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'goldPricePerGram': goldPricePerGram,
      'silverPricePerGram': silverPricePerGram,
      'currency': currency,
      'lastUpdated': lastUpdated.toIso8601String(),
      'source': source,
      'isRealTime': isRealTime,
    };
  }

  /// Convert to domain entity
  NisabThreshold toNisabThreshold({
    NisabType preferredNisab = NisabType.lower,
  }) {
    return NisabThreshold.fromMetalPrices(
      goldPricePerGram: goldPricePerGram,
      silverPricePerGram: silverPricePerGram,
      currency: currency,
      preferredNisab: preferredNisab,
    );
  }

  /// Check if prices are stale (older than 1 hour for real-time)
  bool get isStale {
    final threshold = isRealTime 
        ? const Duration(hours: 1)
        : const Duration(days: 1);
    return DateTime.now().difference(lastUpdated) > threshold;
  }

  /// Get gold price formatted for display
  String get formattedGoldPrice {
    return '${goldPricePerGram.toStringAsFixed(2)} $currency/g';
  }

  /// Get silver price formatted for display
  String get formattedSilverPrice {
    return '${silverPricePerGram.toStringAsFixed(2)} $currency/g';
  }

  @override
  List<Object?> get props => [
        goldPricePerGram,
        silverPricePerGram,
        currency,
        lastUpdated,
        source,
        isRealTime,
      ];

  MetalPricesDto copyWith({
    double? goldPricePerGram,
    double? silverPricePerGram,
    String? currency,
    DateTime? lastUpdated,
    String? source,
    bool? isRealTime,
  }) {
    return MetalPricesDto(
      goldPricePerGram: goldPricePerGram ?? this.goldPricePerGram,
      silverPricePerGram: silverPricePerGram ?? this.silverPricePerGram,
      currency: currency ?? this.currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      source: source ?? this.source,
      isRealTime: isRealTime ?? this.isRealTime,
    );
  }
}

/// DTO for Zakat wealth data storage
class ZakatWealthDto extends Equatable {
  const ZakatWealthDto({
    required this.cash,
    required this.savings,
    required this.goldGrams,
    required this.goldValue,
    required this.silverGrams,
    required this.silverValue,
    required this.businessInventory,
    required this.accountsReceivable,
    required this.investments,
    required this.rentalIncome,
    required this.otherAssets,
    required this.debts,
    required this.businessExpenses,
    required this.currency,
    required this.lastUpdated,
  });

  final double cash;
  final double savings;
  final double goldGrams;
  final double goldValue;
  final double silverGrams;
  final double silverValue;
  final double businessInventory;
  final double accountsReceivable;
  final double investments;
  final double rentalIncome;
  final double otherAssets;
  final double debts;
  final double businessExpenses;
  final String currency;
  final DateTime lastUpdated;

  /// Create from JSON
  factory ZakatWealthDto.fromJson(Map<String, dynamic> json) {
    return ZakatWealthDto(
      cash: (json['cash'] as num?)?.toDouble() ?? 0,
      savings: (json['savings'] as num?)?.toDouble() ?? 0,
      goldGrams: (json['goldGrams'] as num?)?.toDouble() ?? 0,
      goldValue: (json['goldValue'] as num?)?.toDouble() ?? 0,
      silverGrams: (json['silverGrams'] as num?)?.toDouble() ?? 0,
      silverValue: (json['silverValue'] as num?)?.toDouble() ?? 0,
      businessInventory: (json['businessInventory'] as num?)?.toDouble() ?? 0,
      accountsReceivable: (json['accountsReceivable'] as num?)?.toDouble() ?? 0,
      investments: (json['investments'] as num?)?.toDouble() ?? 0,
      rentalIncome: (json['rentalIncome'] as num?)?.toDouble() ?? 0,
      otherAssets: (json['otherAssets'] as num?)?.toDouble() ?? 0,
      debts: (json['debts'] as num?)?.toDouble() ?? 0,
      businessExpenses: (json['businessExpenses'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'USD',
      lastUpdated: json['lastUpdated'] != null 
          ? DateTime.parse(json['lastUpdated'] as String)
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'cash': cash,
      'savings': savings,
      'goldGrams': goldGrams,
      'goldValue': goldValue,
      'silverGrams': silverGrams,
      'silverValue': silverValue,
      'businessInventory': businessInventory,
      'accountsReceivable': accountsReceivable,
      'investments': investments,
      'rentalIncome': rentalIncome,
      'otherAssets': otherAssets,
      'debts': debts,
      'businessExpenses': businessExpenses,
      'currency': currency,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        cash,
        savings,
        goldGrams,
        goldValue,
        silverGrams,
        silverValue,
        businessInventory,
        accountsReceivable,
        investments,
        rentalIncome,
        otherAssets,
        debts,
        businessExpenses,
        currency,
        lastUpdated,
      ];
}

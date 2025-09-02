// Nisab threshold entity for Zakat calculations
// Represents the minimum wealth threshold for Zakat obligation

import 'package:equatable/equatable.dart';

/// Represents the Nisab threshold for Zakat calculation
/// Nisab is the minimum amount of wealth a Muslim must possess 
/// before being liable to pay Zakat
class NisabThreshold extends Equatable {
  const NisabThreshold({
    required this.goldNisab,
    required this.silverNisab,
    required this.currency,
    required this.goldPricePerGram,
    required this.silverPricePerGram,
    required this.lastUpdated,
    this.preferredNisab = NisabType.lower,
  });

  /// Nisab value based on gold price
  final double goldNisab;
  
  /// Nisab value based on silver price
  final double silverNisab;
  
  /// Currency for the Nisab values
  final String currency;
  
  /// Current gold price per gram
  final double goldPricePerGram;
  
  /// Current silver price per gram
  final double silverPricePerGram;
  
  /// When the prices were last updated
  final DateTime lastUpdated;
  
  /// Preferred Nisab calculation method
  final NisabType preferredNisab;

  /// Gold Nisab weight in grams (87.48g = 7.5 tola)
  static const double goldNisabWeight = 87.48;
  
  /// Silver Nisab weight in grams (612.36g = 52.5 tola)
  static const double silverNisabWeight = 612.36;

  /// Get the effective Nisab value based on preference
  double get effectiveNisab {
    switch (preferredNisab) {
      case NisabType.gold:
        return goldNisab;
      case NisabType.silver:
        return silverNisab;
      case NisabType.lower:
        return goldNisab < silverNisab ? goldNisab : silverNisab;
      case NisabType.higher:
        return goldNisab > silverNisab ? goldNisab : silverNisab;
    }
  }

  /// Check if a given wealth amount meets the Nisab threshold
  bool meetsNisab(double wealth) => wealth >= effectiveNisab;

  /// Calculate how much more wealth is needed to reach Nisab
  double shortfallFromNisab(double wealth) {
    final shortfall = effectiveNisab - wealth;
    return shortfall > 0 ? shortfall : 0;
  }

  /// Calculate how much wealth exceeds the Nisab threshold
  double excessAboveNisab(double wealth) {
    final excess = wealth - effectiveNisab;
    return excess > 0 ? excess : 0;
  }

  @override
  List<Object?> get props => [
        goldNisab,
        silverNisab,
        currency,
        goldPricePerGram,
        silverPricePerGram,
        lastUpdated,
        preferredNisab,
      ];

  NisabThreshold copyWith({
    double? goldNisab,
    double? silverNisab,
    String? currency,
    double? goldPricePerGram,
    double? silverPricePerGram,
    DateTime? lastUpdated,
    NisabType? preferredNisab,
  }) {
    return NisabThreshold(
      goldNisab: goldNisab ?? this.goldNisab,
      silverNisab: silverNisab ?? this.silverNisab,
      currency: currency ?? this.currency,
      goldPricePerGram: goldPricePerGram ?? this.goldPricePerGram,
      silverPricePerGram: silverPricePerGram ?? this.silverPricePerGram,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      preferredNisab: preferredNisab ?? this.preferredNisab,
    );
  }

  /// Factory constructor for creating Nisab from current metal prices
  factory NisabThreshold.fromMetalPrices({
    required double goldPricePerGram,
    required double silverPricePerGram,
    required String currency,
    NisabType preferredNisab = NisabType.lower,
  }) {
    final goldNisab = goldPricePerGram * goldNisabWeight;
    final silverNisab = silverPricePerGram * silverNisabWeight;
    
    return NisabThreshold(
      goldNisab: goldNisab,
      silverNisab: silverNisab,
      currency: currency,
      goldPricePerGram: goldPricePerGram,
      silverPricePerGram: silverPricePerGram,
      lastUpdated: DateTime.now(),
      preferredNisab: preferredNisab,
    );
  }
}

/// Types of Nisab calculation methods
enum NisabType {
  /// Use gold-based Nisab value
  gold,
  
  /// Use silver-based Nisab value
  silver,
  
  /// Use the lower of gold or silver Nisab (more charitable)
  lower,
  
  /// Use the higher of gold or silver Nisab
  higher,
}

/// Extension methods for NisabType
extension NisabTypeExtension on NisabType {
  /// Get display name for the Nisab type
  String get displayName {
    switch (this) {
      case NisabType.gold:
        return 'Gold-based Nisab';
      case NisabType.silver:
        return 'Silver-based Nisab';
      case NisabType.lower:
        return 'Lower Value (More Charitable)';
      case NisabType.higher:
        return 'Higher Value';
    }
  }

  /// Get description for the Nisab type
  String get description {
    switch (this) {
      case NisabType.gold:
        return 'Uses current gold prices to calculate Nisab threshold';
      case NisabType.silver:
        return 'Uses current silver prices to calculate Nisab threshold';
      case NisabType.lower:
        return 'Uses the lower of gold or silver Nisab for maximum charity';
      case NisabType.higher:
        return 'Uses the higher of gold or silver Nisab';
    }
  }
}

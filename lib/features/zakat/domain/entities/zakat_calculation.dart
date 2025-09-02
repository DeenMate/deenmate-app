// Core Zakat calculation entity based on Islamic Sharia principles
// Represents the fundamental calculation for obligatory charity in Islam

import 'package:equatable/equatable.dart';

/// Represents a complete Zakat calculation with all Islamic requirements
class ZakatCalculation extends Equatable {
  const ZakatCalculation({
    required this.wealth,
    required this.nisab,
    required this.zakatDue,
    required this.isEligible,
    required this.calculationType,
    required this.currency,
    this.goldPricePerGram,
    this.silverPricePerGram,
    this.calculations = const {},
  });

  /// Total wealth subject to Zakat calculation
  final double wealth;
  
  /// Nisab threshold for this calculation type
  final double nisab;
  
  /// Amount of Zakat due (2.5% of eligible wealth)
  final double zakatDue;
  
  /// Whether Zakat is obligatory based on Nisab threshold
  final bool isEligible;
  
  /// Type of Zakat calculation performed
  final ZakatCalculationType calculationType;
  
  /// Currency used for calculation
  final String currency;
  
  /// Current gold price per gram (for Nisab calculation)
  final double? goldPricePerGram;
  
  /// Current silver price per gram (for Nisab calculation)
  final double? silverPricePerGram;
  
  /// Detailed breakdown of individual asset calculations
  final Map<String, ZakatAssetCalculation> calculations;

  /// Standard Zakat rate (2.5% or 1/40th)
  static const double zakatRate = 0.025;
  
  /// Gold Nisab in grams (87.48g)
  static const double goldNisabGrams = 87.48;
  
  /// Silver Nisab in grams (612.36g)
  static const double silverNisabGrams = 612.36;

  @override
  List<Object?> get props => [
        wealth,
        nisab,
        zakatDue,
        isEligible,
        calculationType,
        currency,
        goldPricePerGram,
        silverPricePerGram,
        calculations,
      ];

  ZakatCalculation copyWith({
    double? wealth,
    double? nisab,
    double? zakatDue,
    bool? isEligible,
    ZakatCalculationType? calculationType,
    String? currency,
    double? goldPricePerGram,
    double? silverPricePerGram,
    Map<String, ZakatAssetCalculation>? calculations,
  }) {
    return ZakatCalculation(
      wealth: wealth ?? this.wealth,
      nisab: nisab ?? this.nisab,
      zakatDue: zakatDue ?? this.zakatDue,
      isEligible: isEligible ?? this.isEligible,
      calculationType: calculationType ?? this.calculationType,
      currency: currency ?? this.currency,
      goldPricePerGram: goldPricePerGram ?? this.goldPricePerGram,
      silverPricePerGram: silverPricePerGram ?? this.silverPricePerGram,
      calculations: calculations ?? this.calculations,
    );
  }
}

/// Types of Zakat calculations based on Islamic jurisprudence
enum ZakatCalculationType {
  /// Complete wealth calculation including all assets
  comprehensive,
  
  /// Cash and bank accounts only
  cashOnly,
  
  /// Gold and silver jewelry/investments
  goldSilver,
  
  /// Business inventory and trade goods
  business,
  
  /// Livestock (cattle, sheep, goats, camels)
  livestock,
  
  /// Agricultural produce (crops and fruits)
  agriculture,
}

/// Individual asset calculation within overall Zakat assessment
class ZakatAssetCalculation extends Equatable {
  const ZakatAssetCalculation({
    required this.assetType,
    required this.value,
    required this.isEligible,
    required this.zakatDue,
    this.quantity,
    this.unitValue,
    this.description,
  });

  /// Type of asset being calculated
  final ZakatAssetType assetType;
  
  /// Total value of this asset
  final double value;
  
  /// Whether this asset qualifies for Zakat
  final bool isEligible;
  
  /// Zakat due on this specific asset
  final double zakatDue;
  
  /// Quantity of the asset (for gold/silver weight, livestock count, etc.)
  final double? quantity;
  
  /// Value per unit of the asset
  final double? unitValue;
  
  /// Optional description of the asset
  final String? description;

  @override
  List<Object?> get props => [
        assetType,
        value,
        isEligible,
        zakatDue,
        quantity,
        unitValue,
        description,
      ];
}

/// Types of assets subject to Zakat calculation
enum ZakatAssetType {
  /// Cash in hand and checking accounts
  cash,
  
  /// Savings accounts and fixed deposits
  savings,
  
  /// Gold jewelry and investments
  gold,
  
  /// Silver jewelry and investments
  silver,
  
  /// Business inventory and stock
  businessInventory,
  
  /// Accounts receivable and business debts
  accountsReceivable,
  
  /// Investment portfolios and stocks
  investments,
  
  /// Rental property income (net)
  rentalIncome,
  
  /// Cattle for Zakat calculation
  cattle,
  
  /// Sheep and goats
  sheep,
  
  /// Camels
  camels,
  
  /// Agricultural crops
  crops,
  
  /// Other zakatable assets
  other,
}

// Zakat wealth tracking entity for comprehensive Islamic finance management
// Tracks various types of wealth subject to Zakat calculation

import 'package:equatable/equatable.dart';
import 'zakat_calculation.dart';

/// Represents a user's wealth portfolio for Zakat calculation
class ZakatWealth extends Equatable {
  const ZakatWealth({
    this.cash = 0,
    this.savings = 0,
    this.goldGrams = 0,
    this.goldValue = 0,
    this.silverGrams = 0,
    this.silverValue = 0,
    this.businessInventory = 0,
    this.accountsReceivable = 0,
    this.investments = 0,
    this.rentalIncome = 0,
    this.otherAssets = 0,
    this.debts = 0,
    this.businessExpenses = 0,
    this.currency = 'USD',
    this.lastUpdated,
  });

  // === ASSETS ===
  
  /// Cash in hand and checking accounts
  final double cash;
  
  /// Savings accounts and fixed deposits
  final double savings;
  
  /// Gold owned in grams
  final double goldGrams;
  
  /// Current market value of gold owned
  final double goldValue;
  
  /// Silver owned in grams
  final double silverGrams;
  
  /// Current market value of silver owned
  final double silverValue;
  
  /// Business inventory and stock value
  final double businessInventory;
  
  /// Money owed to you by others
  final double accountsReceivable;
  
  /// Investment portfolios, stocks, bonds
  final double investments;
  
  /// Net income from rental properties
  final double rentalIncome;
  
  /// Other zakatable assets
  final double otherAssets;

  // === DEDUCTIONS ===
  
  /// Outstanding debts and loans
  final double debts;
  
  /// Business operational expenses
  final double businessExpenses;

  // === METADATA ===
  
  /// Currency for all monetary values
  final String currency;
  
  /// Last time this wealth data was updated
  final DateTime? lastUpdated;

  /// Calculate total gross wealth (before deductions)
  double get totalGrossWealth =>
      cash +
      savings +
      goldValue +
      silverValue +
      businessInventory +
      accountsReceivable +
      investments +
      rentalIncome +
      otherAssets;

  /// Calculate total deductions
  double get totalDeductions => debts + businessExpenses;

  /// Calculate net zakatable wealth (after deductions)
  double get netZakatableWealth {
    final net = totalGrossWealth - totalDeductions;
    return net > 0 ? net : 0;
  }

  /// Check if this wealth data is stale (older than 30 days)
  bool get isStale {
    if (lastUpdated == null) return true;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));
    return lastUpdated!.isBefore(thirtyDaysAgo);
  }

  /// Get breakdown of wealth by category
  Map<ZakatAssetType, double> get wealthBreakdown => {
        ZakatAssetType.cash: cash,
        ZakatAssetType.savings: savings,
        ZakatAssetType.gold: goldValue,
        ZakatAssetType.silver: silverValue,
        ZakatAssetType.businessInventory: businessInventory,
        ZakatAssetType.accountsReceivable: accountsReceivable,
        ZakatAssetType.investments: investments,
        ZakatAssetType.rentalIncome: rentalIncome,
        ZakatAssetType.other: otherAssets,
      };

  /// Get individual asset calculations for detailed breakdown
  Map<String, ZakatAssetCalculation> getAssetCalculations() {
    const zakatRate = ZakatCalculation.zakatRate;
    
    return {
      'cash': ZakatAssetCalculation(
        assetType: ZakatAssetType.cash,
        value: cash,
        isEligible: cash > 0,
        zakatDue: cash * zakatRate,
        description: 'Cash in hand and checking accounts',
      ),
      'savings': ZakatAssetCalculation(
        assetType: ZakatAssetType.savings,
        value: savings,
        isEligible: savings > 0,
        zakatDue: savings * zakatRate,
        description: 'Savings accounts and fixed deposits',
      ),
      'gold': ZakatAssetCalculation(
        assetType: ZakatAssetType.gold,
        value: goldValue,
        isEligible: goldValue > 0,
        zakatDue: goldValue * zakatRate,
        quantity: goldGrams,
        unitValue: goldGrams > 0 ? goldValue / goldGrams : 0,
        description: 'Gold jewelry and investments',
      ),
      'silver': ZakatAssetCalculation(
        assetType: ZakatAssetType.silver,
        value: silverValue,
        isEligible: silverValue > 0,
        zakatDue: silverValue * zakatRate,
        quantity: silverGrams,
        unitValue: silverGrams > 0 ? silverValue / silverGrams : 0,
        description: 'Silver jewelry and investments',
      ),
      'business': ZakatAssetCalculation(
        assetType: ZakatAssetType.businessInventory,
        value: businessInventory,
        isEligible: businessInventory > 0,
        zakatDue: businessInventory * zakatRate,
        description: 'Business inventory and stock',
      ),
      'receivables': ZakatAssetCalculation(
        assetType: ZakatAssetType.accountsReceivable,
        value: accountsReceivable,
        isEligible: accountsReceivable > 0,
        zakatDue: accountsReceivable * zakatRate,
        description: 'Money owed by others',
      ),
      'investments': ZakatAssetCalculation(
        assetType: ZakatAssetType.investments,
        value: investments,
        isEligible: investments > 0,
        zakatDue: investments * zakatRate,
        description: 'Investment portfolios and stocks',
      ),
      'rental': ZakatAssetCalculation(
        assetType: ZakatAssetType.rentalIncome,
        value: rentalIncome,
        isEligible: rentalIncome > 0,
        zakatDue: rentalIncome * zakatRate,
        description: 'Net rental property income',
      ),
      'other': ZakatAssetCalculation(
        assetType: ZakatAssetType.other,
        value: otherAssets,
        isEligible: otherAssets > 0,
        zakatDue: otherAssets * zakatRate,
        description: 'Other zakatable assets',
      ),
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

  ZakatWealth copyWith({
    double? cash,
    double? savings,
    double? goldGrams,
    double? goldValue,
    double? silverGrams,
    double? silverValue,
    double? businessInventory,
    double? accountsReceivable,
    double? investments,
    double? rentalIncome,
    double? otherAssets,
    double? debts,
    double? businessExpenses,
    String? currency,
    DateTime? lastUpdated,
  }) {
    return ZakatWealth(
      cash: cash ?? this.cash,
      savings: savings ?? this.savings,
      goldGrams: goldGrams ?? this.goldGrams,
      goldValue: goldValue ?? this.goldValue,
      silverGrams: silverGrams ?? this.silverGrams,
      silverValue: silverValue ?? this.silverValue,
      businessInventory: businessInventory ?? this.businessInventory,
      accountsReceivable: accountsReceivable ?? this.accountsReceivable,
      investments: investments ?? this.investments,
      rentalIncome: rentalIncome ?? this.rentalIncome,
      otherAssets: otherAssets ?? this.otherAssets,
      debts: debts ?? this.debts,
      businessExpenses: businessExpenses ?? this.businessExpenses,
      currency: currency ?? this.currency,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  /// Factory constructor for empty wealth profile
  factory ZakatWealth.empty({String currency = 'USD'}) {
    return ZakatWealth(currency: currency, lastUpdated: DateTime.now());
  }

  /// Update the last updated timestamp
  ZakatWealth withUpdatedTimestamp() {
    return copyWith(lastUpdated: DateTime.now());
  }
}

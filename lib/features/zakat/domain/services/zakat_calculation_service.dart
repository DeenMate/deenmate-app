// Zakat calculation service implementing Islamic Sharia principles
// Core business logic for calculating obligatory charity (Zakat)

import '../entities/zakat_calculation.dart';
import '../entities/zakat_wealth.dart';
import '../entities/nisab_threshold.dart';

/// Service for performing Zakat calculations according to Islamic law
class ZakatCalculationService {
  const ZakatCalculationService();

  /// Calculate comprehensive Zakat based on all wealth types
  ZakatCalculation calculateComprehensiveZakat({
    required ZakatWealth wealth,
    required NisabThreshold nisab,
  }) {
    final netWealth = wealth.netZakatableWealth;
    final isEligible = nisab.meetsNisab(netWealth);
    final zakatDue = isEligible ? netWealth * ZakatCalculation.zakatRate : 0.0;

    return ZakatCalculation(
      wealth: netWealth.toDouble(),
      nisab: nisab.effectiveNisab.toDouble(),
      zakatDue: zakatDue.toDouble(),
      isEligible: isEligible,
      calculationType: ZakatCalculationType.comprehensive,
      currency: wealth.currency,
      goldPricePerGram: nisab.goldPricePerGram?.toDouble(),
      silverPricePerGram: nisab.silverPricePerGram?.toDouble(),
      calculations: wealth.getAssetCalculations(),
    );
  }

  /// Calculate Zakat on cash assets only
  ZakatCalculation calculateCashZakat({
    required double cashAmount,
    required NisabThreshold nisab,
    required String currency,
  }) {
    final isEligible = nisab.meetsNisab(cashAmount);
    final zakatDue = isEligible ? cashAmount * ZakatCalculation.zakatRate : 0;

    return ZakatCalculation(
      wealth: cashAmount.toDouble(),
      nisab: nisab.effectiveNisab.toDouble(),
      zakatDue: zakatDue.toDouble(),
      isEligible: isEligible,
      calculationType: ZakatCalculationType.cashOnly,
      currency: currency,
      goldPricePerGram: nisab.goldPricePerGram?.toDouble(),
      silverPricePerGram: nisab.silverPricePerGram?.toDouble(),
      calculations: {
        'cash': ZakatAssetCalculation(
          assetType: ZakatAssetType.cash,
          value: cashAmount.toDouble(),
          isEligible: isEligible,
          zakatDue: zakatDue.toDouble(),
        ),
      },
    );
  }

  /// Calculate Zakat on gold and silver specifically
  ZakatCalculation calculateGoldSilverZakat({
    required double goldGrams,
    required double silverGrams,
    required double goldPricePerGram,
    required double silverPricePerGram,
    required String currency,
  }) {
    final goldValue = goldGrams * goldPricePerGram;
    final silverValue = silverGrams * silverPricePerGram;
    final totalValue = goldValue + silverValue;

    // Create nisab threshold for metals calculation
    final nisab = NisabThreshold.fromMetalPrices(
      goldPricePerGram: goldPricePerGram,
      silverPricePerGram: silverPricePerGram,
      currency: currency,
    );

    final isEligible = nisab.meetsNisab(totalValue);
    final zakatDue = isEligible ? totalValue * ZakatCalculation.zakatRate : 0;

    return ZakatCalculation(
      wealth: totalValue.toDouble(),
      nisab: nisab.effectiveNisab.toDouble(),
      zakatDue: zakatDue.toDouble(),
      isEligible: isEligible,
      calculationType: ZakatCalculationType.goldSilver,
      currency: currency,
      goldPricePerGram: goldPricePerGram?.toDouble(),
      silverPricePerGram: silverPricePerGram?.toDouble(),
      calculations: {
        'gold': ZakatAssetCalculation(
          assetType: ZakatAssetType.gold,
          value: goldValue.toDouble(),
          isEligible: goldValue > 0,
          zakatDue: (goldValue * ZakatCalculation.zakatRate).toDouble(),
          quantity: goldGrams?.toDouble(),
          unitValue: goldPricePerGram?.toDouble(),
        ),
        'silver': ZakatAssetCalculation(
          assetType: ZakatAssetType.silver,
          value: silverValue.toDouble(),
          isEligible: silverValue > 0,
          zakatDue: (silverValue * ZakatCalculation.zakatRate).toDouble(),
          quantity: silverGrams?.toDouble(),
          unitValue: silverPricePerGram?.toDouble(),
        ),
      },
    );
  }

  /// Calculate Zakat on business inventory and assets
  ZakatCalculation calculateBusinessZakat({
    required double inventoryValue,
    required double accountsReceivable,
    required double businessCash,
    required double businessDebts,
    required NisabThreshold nisab,
    required String currency,
  }) {
    final totalBusinessAssets = inventoryValue + accountsReceivable + businessCash;
    final netBusinessWealth = totalBusinessAssets - businessDebts;
    final finalWealth = netBusinessWealth > 0 ? netBusinessWealth : 0.0;

    final isEligible = nisab.meetsNisab(finalWealth);
    final zakatDue = isEligible ? finalWealth * ZakatCalculation.zakatRate : 0.0;

    return ZakatCalculation(
      wealth: finalWealth.toDouble(),
      nisab: nisab.effectiveNisab.toDouble(),
      zakatDue: zakatDue.toDouble(),
      isEligible: isEligible,
      calculationType: ZakatCalculationType.business,
      currency: currency,
      goldPricePerGram: nisab.goldPricePerGram?.toDouble(),
      silverPricePerGram: nisab.silverPricePerGram?.toDouble(),
      calculations: {
        'inventory': ZakatAssetCalculation(
          assetType: ZakatAssetType.businessInventory,
          value: inventoryValue.toDouble(),
          isEligible: inventoryValue > 0,
          zakatDue: (inventoryValue * ZakatCalculation.zakatRate).toDouble(),
        ),
        'receivables': ZakatAssetCalculation(
          assetType: ZakatAssetType.accountsReceivable,
          value: accountsReceivable.toDouble(),
          isEligible: accountsReceivable > 0,
          zakatDue: (accountsReceivable * ZakatCalculation.zakatRate).toDouble(),
        ),
        'business_cash': ZakatAssetCalculation(
          assetType: ZakatAssetType.cash,
          value: businessCash.toDouble(),
          isEligible: businessCash > 0,
          zakatDue: (businessCash * ZakatCalculation.zakatRate).toDouble(),
        ),
      },
    );
  }

  /// Calculate how much additional wealth is needed to reach Nisab
  double calculateNisabShortfall({
    required double currentWealth,
    required NisabThreshold nisab,
  }) {
    return nisab.shortfallFromNisab(currentWealth);
  }

  /// Calculate how much wealth exceeds Nisab threshold
  double calculateWealthExcess({
    required double currentWealth,
    required NisabThreshold nisab,
  }) {
    return nisab.excessAboveNisab(currentWealth);
  }

  /// Validate if wealth data is sufficient for accurate calculation
  ZakatCalculationValidation validateWealthData(ZakatWealth wealth) {
    final issues = <String>[];
    final warnings = <String>[];

    // Check for stale data
    if (wealth.isStale) {
      warnings.add('Wealth data is older than 30 days and may be outdated');
    }

    // Check for missing essential data
    if (wealth.totalGrossWealth <= 0) {
      issues.add('No wealth data provided - please enter your assets');
    }

    // Check for gold/silver inconsistencies
    if (wealth.goldGrams > 0 && wealth.goldValue <= 0) {
      warnings.add('Gold quantity specified but no value provided');
    }
    if (wealth.silverGrams > 0 && wealth.silverValue <= 0) {
      warnings.add('Silver quantity specified but no value provided');
    }

    // Check for unrealistic values
    if (wealth.debts > wealth.totalGrossWealth) {
      warnings.add('Debts exceed total assets - verify your entries');
    }

    return ZakatCalculationValidation(
      isValid: issues.isEmpty,
      issues: issues,
      warnings: warnings,
    );
  }

  /// Get recommended calculation frequency based on wealth volatility
  ZakatCalculationFrequency getRecommendedCalculationFrequency(
    ZakatWealth wealth,
  ) {
    final investmentRatio = wealth.investments / wealth.totalGrossWealth;
    final businessRatio = wealth.businessInventory / wealth.totalGrossWealth;

    // High volatility portfolios need more frequent calculation
    if (investmentRatio > 0.5 || businessRatio > 0.3) {
      return ZakatCalculationFrequency.monthly;
    }

    // Medium volatility
    if (investmentRatio > 0.2 || businessRatio > 0.1) {
      return ZakatCalculationFrequency.quarterly;
    }

    // Low volatility - mostly cash and fixed assets
    return ZakatCalculationFrequency.annually;
  }
}

/// Validation result for Zakat calculation data
class ZakatCalculationValidation {
  const ZakatCalculationValidation({
    required this.isValid,
    required this.issues,
    required this.warnings,
  });

  final bool isValid;
  final List<String> issues;
  final List<String> warnings;

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasIssues => issues.isNotEmpty;
}

/// Recommended frequency for Zakat calculations
enum ZakatCalculationFrequency {
  monthly,
  quarterly,
  biannually,
  annually,
}

extension ZakatCalculationFrequencyExtension on ZakatCalculationFrequency {
  String get displayName {
    switch (this) {
      case ZakatCalculationFrequency.monthly:
        return 'Monthly';
      case ZakatCalculationFrequency.quarterly:
        return 'Quarterly';
      case ZakatCalculationFrequency.biannually:
        return 'Bi-annually';
      case ZakatCalculationFrequency.annually:
        return 'Annually';
    }
  }

  String get description {
    switch (this) {
      case ZakatCalculationFrequency.monthly:
        return 'Recommended for high-volatility portfolios with significant investments';
      case ZakatCalculationFrequency.quarterly:
        return 'Recommended for moderate business or investment activity';
      case ZakatCalculationFrequency.biannually:
        return 'Recommended for stable wealth with minimal changes';
      case ZakatCalculationFrequency.annually:
        return 'Minimum Islamic requirement - suitable for simple wealth portfolios';
    }
  }

  Duration get duration {
    switch (this) {
      case ZakatCalculationFrequency.monthly:
        return const Duration(days: 30);
      case ZakatCalculationFrequency.quarterly:
        return const Duration(days: 90);
      case ZakatCalculationFrequency.biannually:
        return const Duration(days: 180);
      case ZakatCalculationFrequency.annually:
        return const Duration(days: 365);
    }
  }
}

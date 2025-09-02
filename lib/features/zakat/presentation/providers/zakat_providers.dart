// Riverpod providers for Zakat module state management
// Handles metal prices, wealth data, and calculation state

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../domain/entities/zakat_calculation.dart';
import '../../domain/entities/zakat_wealth.dart';
import '../../domain/entities/nisab_threshold.dart';
import '../../domain/services/zakat_calculation_service.dart';
import '../../data/api/metal_prices_api_client.dart';
import '../../data/dto/metal_prices_dto.dart';

// === API CLIENT PROVIDERS ===

/// HTTP client provider
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Metal prices API client provider
final metalPricesApiClientProvider = Provider<MetalPricesApiClient>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  return MetalPricesApiClient(httpClient: httpClient);
});

// === SERVICE PROVIDERS ===

/// Zakat calculation service provider
final zakatCalculationServiceProvider = Provider<ZakatCalculationService>((ref) {
  return const ZakatCalculationService();
});

// === DATA PROVIDERS ===

/// Metal prices state notifier
class MetalPricesNotifier extends StateNotifier<AsyncValue<MetalPricesDto>> {
  MetalPricesNotifier(this._apiClient) : super(const AsyncValue.loading());

  final MetalPricesApiClient _apiClient;

  /// Fetch current metal prices
  Future<void> fetchCurrentPrices(String currency) async {
    state = const AsyncValue.loading();
    
    try {
      final prices = await _apiClient.getCurrentMetalPrices(currency: currency);
      state = AsyncValue.data(prices);
    } catch (e, stack) {
      // Try fallback prices if API fails
      try {
        final fallbackPrices = _apiClient.getFallbackMetalPrices(currency);
        state = AsyncValue.data(fallbackPrices);
      } catch (fallbackError) {
        state = AsyncValue.error(e, stack);
      }
    }
  }

  /// Fetch historical prices for a specific date
  Future<void> fetchHistoricalPrices(DateTime date, String currency) async {
    state = const AsyncValue.loading();
    
    try {
      final prices = await _apiClient.getHistoricalMetalPrices(
        date: date,
        currency: currency,
      );
      state = AsyncValue.data(prices);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Refresh current prices
  Future<void> refresh(String currency) async {
    await fetchCurrentPrices(currency);
  }
}

/// Metal prices provider
final metalPricesProvider = StateNotifierProvider<MetalPricesNotifier, AsyncValue<MetalPricesDto>>((ref) {
  final apiClient = ref.watch(metalPricesApiClientProvider);
  return MetalPricesNotifier(apiClient);
});

/// Nisab threshold provider (derived from metal prices)
final nisabThresholdProvider = Provider<AsyncValue<NisabThreshold>>((ref) {
  final metalPricesAsync = ref.watch(metalPricesProvider);
  
  return metalPricesAsync.when(
    data: (prices) => AsyncValue.data(prices.toNisabThreshold()),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

// === WEALTH MANAGEMENT PROVIDERS ===

/// Zakat wealth state notifier
class ZakatWealthNotifier extends StateNotifier<AsyncValue<ZakatWealth?>> {
  ZakatWealthNotifier() : super(const AsyncValue.data(null));

  /// Update wealth data
  Future<void> updateWealth(ZakatWealth wealth) async {
    state = const AsyncValue.loading();
    
    try {
      // Here you would typically save to local storage or remote API
      // For now, we'll just update the state
      final updatedWealth = wealth.withUpdatedTimestamp();
      state = AsyncValue.data(updatedWealth);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Clear wealth data
  void clearWealth() {
    state = const AsyncValue.data(null);
  }

  /// Load saved wealth data
  Future<void> loadSavedWealth() async {
    // This would typically load from persistent storage
    // For now, we'll keep the current state
  }
}

/// Zakat wealth provider
final zakatWealthNotifierProvider = StateNotifierProvider<ZakatWealthNotifier, AsyncValue<ZakatWealth?>>((ref) {
  return ZakatWealthNotifier();
});

/// Saved wealth provider (for form persistence)
final savedZakatWealthProvider = Provider<ZakatWealth?>((ref) {
  final wealthAsync = ref.watch(zakatWealthNotifierProvider);
  return wealthAsync.value;
});

// === CALCULATION PROVIDERS ===

/// Zakat calculation state notifier
class ZakatCalculationNotifier extends StateNotifier<AsyncValue<ZakatCalculation?>> {
  ZakatCalculationNotifier(this._calculationService, this._ref) 
      : super(const AsyncValue.data(null));

  final ZakatCalculationService _calculationService;
  final Ref _ref;

  /// Calculate comprehensive Zakat
  Future<void> calculateZakat(ZakatWealth wealth) async {
    state = const AsyncValue.loading();
    
    try {
      final nisabAsync = _ref.read(nisabThresholdProvider);
      
      final nisab = await nisabAsync.when(
        data: (threshold) => Future.value(threshold),
        loading: () => Future.error('Nisab data not loaded'),
        error: (error, stack) => Future.error(error),
      );

      final calculation = _calculationService.calculateComprehensiveZakat(
        wealth: wealth,
        nisab: nisab,
      );

      state = AsyncValue.data(calculation);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Calculate cash-only Zakat
  Future<void> calculateCashZakat({
    required double cashAmount,
    required String currency,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final nisabAsync = _ref.read(nisabThresholdProvider);
      
      final nisab = await nisabAsync.when(
        data: (threshold) => Future.value(threshold),
        loading: () => Future.error('Nisab data not loaded'),
        error: (error, stack) => Future.error(error),
      );

      final calculation = _calculationService.calculateCashZakat(
        cashAmount: cashAmount,
        nisab: nisab,
        currency: currency,
      );

      state = AsyncValue.data(calculation);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Calculate gold/silver Zakat
  Future<void> calculateGoldSilverZakat({
    required double goldGrams,
    required double silverGrams,
    required String currency,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      final metalPricesAsync = _ref.read(metalPricesProvider);
      
      final metalPrices = await metalPricesAsync.when(
        data: (prices) => Future.value(prices),
        loading: () => Future.error('Metal prices not loaded'),
        error: (error, stack) => Future.error(error),
      );

      final calculation = _calculationService.calculateGoldSilverZakat(
        goldGrams: goldGrams,
        silverGrams: silverGrams,
        goldPricePerGram: metalPrices.goldPricePerGram,
        silverPricePerGram: metalPrices.silverPricePerGram,
        currency: currency,
      );

      state = AsyncValue.data(calculation);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  /// Clear calculation
  void clearCalculation() {
    state = const AsyncValue.data(null);
  }
}

/// Zakat calculation provider
final zakatCalculationNotifierProvider = StateNotifierProvider<ZakatCalculationNotifier, AsyncValue<ZakatCalculation?>>((ref) {
  final calculationService = ref.watch(zakatCalculationServiceProvider);
  return ZakatCalculationNotifier(calculationService, ref);
});

// === VALIDATION PROVIDERS ===

/// Wealth validation provider
final wealthValidationProvider = Provider<ZakatCalculationValidation?>((ref) {
  final wealthAsync = ref.watch(zakatWealthNotifierProvider);
  final calculationService = ref.watch(zakatCalculationServiceProvider);
  
  return wealthAsync.value != null 
      ? calculationService.validateWealthData(wealthAsync.value!)
      : null;
});

/// Calculation frequency recommendation provider
final recommendedCalculationFrequencyProvider = Provider<ZakatCalculationFrequency?>((ref) {
  final wealthAsync = ref.watch(zakatWealthNotifierProvider);
  final calculationService = ref.watch(zakatCalculationServiceProvider);
  
  return wealthAsync.value != null 
      ? calculationService.getRecommendedCalculationFrequency(wealthAsync.value!)
      : null;
});

// === UTILITY PROVIDERS ===

/// Check if Zakat is due provider
final isZakatDueProvider = Provider<bool>((ref) {
  final calculationAsync = ref.watch(zakatCalculationNotifierProvider);
  return calculationAsync.value?.isEligible ?? false;
});

/// Zakat amount due provider
final zakatAmountDueProvider = Provider<double>((ref) {
  final calculationAsync = ref.watch(zakatCalculationNotifierProvider);
  return calculationAsync.value?.zakatDue ?? 0;
});

/// Nisab shortfall provider
final nisabShortfallProvider = Provider<double?>((ref) {
  final calculationAsync = ref.watch(zakatCalculationNotifierProvider);
  final nisabAsync = ref.watch(nisabThresholdProvider);
  
  if (calculationAsync.value != null && nisabAsync.value != null) {
    final wealth = calculationAsync.value!.wealth;
    final nisab = nisabAsync.value!;
    
    if (wealth < nisab.effectiveNisab) {
      return nisab.effectiveNisab - wealth;
    }
  }
  
  return null;
});

/// Format currency amount provider
final formatCurrencyProvider = Provider.family<String, Map<String, dynamic>>((ref, params) {
  final amount = params['amount'] as double;
  final currency = params['currency'] as String;
  
  // Simple formatting - in a real app you might use intl package
  final symbol = currency == 'USD' ? '\$' 
      : currency == 'EUR' ? '€'
      : currency == 'GBP' ? '£'
      : currency == 'BDT' ? '৳'
      : currency == 'INR' ? '₹'
      : currency == 'PKR' ? '₨'
      : currency == 'SAR' ? 'ر.س'
      : currency == 'AED' ? 'د.إ'
      : currency;
  
  return '$symbol${amount.toStringAsFixed(2)}';
});

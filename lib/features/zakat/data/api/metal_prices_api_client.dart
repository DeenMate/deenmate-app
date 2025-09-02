// API client for fetching current gold and silver prices
// Used for real-time Nisab threshold calculations

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dto/metal_prices_dto.dart';

/// API client for fetching precious metal prices
class MetalPricesApiClient {
  const MetalPricesApiClient({
    required this.httpClient,
    this.baseUrl = 'https://api.metals.live/v1/spot',
  });

  final http.Client httpClient;
  final String baseUrl;

  /// Fetch current gold and silver prices
  Future<MetalPricesDto> getCurrentMetalPrices({
    String currency = 'USD',
  }) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/gold,silver'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return MetalPricesDto.fromApiResponse(data, currency);
      } else {
        throw MetalPricesApiException(
          'Failed to fetch metal prices: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is MetalPricesApiException) rethrow;
      throw MetalPricesApiException(
        'Network error while fetching metal prices: $e',
        0,
      );
    }
  }

  /// Fetch historical gold and silver prices for a specific date
  Future<MetalPricesDto> getHistoricalMetalPrices({
    required DateTime date,
    String currency = 'USD',
  }) async {
    try {
      final dateString = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      
      final response = await httpClient.get(
        Uri.parse('$baseUrl/gold,silver/$dateString'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return MetalPricesDto.fromApiResponse(data, currency);
      } else {
        throw MetalPricesApiException(
          'Failed to fetch historical metal prices: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (e is MetalPricesApiException) rethrow;
      throw MetalPricesApiException(
        'Network error while fetching historical metal prices: $e',
        0,
      );
    }
  }

  /// Get fallback metal prices when API is unavailable
  /// These are approximate values and should be updated regularly
  MetalPricesDto getFallbackMetalPrices(String currency) {
    // Fallback prices (approximate USD values per gram as of 2024)
    // These should be updated periodically
    final fallbackPrices = {
      'USD': {'gold': 65.0, 'silver': 0.85},
      'EUR': {'gold': 60.0, 'silver': 0.78},
      'GBP': {'gold': 52.0, 'silver': 0.68},
      'CAD': {'gold': 88.0, 'silver': 1.15},
      'AUD': {'gold': 98.0, 'silver': 1.28},
      'BDT': {'gold': 7800.0, 'silver': 102.0}, // Bangladeshi Taka
      'INR': {'gold': 5400.0, 'silver': 70.0},  // Indian Rupee
      'PKR': {'gold': 18500.0, 'silver': 240.0}, // Pakistani Rupee
      'SAR': {'gold': 245.0, 'silver': 3.2},    // Saudi Riyal
      'AED': {'gold': 240.0, 'silver': 3.1},    // UAE Dirham
    };

    final prices = fallbackPrices[currency] ?? fallbackPrices['USD']!;
    
    return MetalPricesDto(
      goldPricePerGram: prices['gold']!,
      silverPricePerGram: prices['silver']!,
      currency: currency,
      lastUpdated: DateTime.now(),
      source: 'fallback',
      isRealTime: false,
    );
  }
}

/// Exception thrown when metal prices API fails
class MetalPricesApiException implements Exception {
  const MetalPricesApiException(this.message, this.statusCode);

  final String message;
  final int statusCode;

  @override
  String toString() => 'MetalPricesApiException: $message (Status: $statusCode)';
}

/// Extensions for currency formatting
extension CurrencyExtension on String {
  /// Get currency symbol for display
  String get currencySymbol {
    switch (this) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'CAD':
        return 'C\$';
      case 'AUD':
        return 'A\$';
      case 'BDT':
        return '৳';
      case 'INR':
        return '₹';
      case 'PKR':
        return '₨';
      case 'SAR':
        return 'ر.س';
      case 'AED':
        return 'د.إ';
      default:
        return this;
    }
  }

  /// Check if currency is supported for metal prices
  bool get isSupportedCurrency {
    const supportedCurrencies = [
      'USD', 'EUR', 'GBP', 'CAD', 'AUD',
      'BDT', 'INR', 'PKR', 'SAR', 'AED'
    ];
    return supportedCurrencies.contains(this);
  }
}

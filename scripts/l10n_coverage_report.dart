#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script to generate localization coverage report
/// Usage: dart run scripts/l10n_coverage_report.dart

void main() async {
  print('📊 Generating localization coverage report...');
  
  final report = await generateCoverageReport();
  
  print('\n📋 LOCALIZATION COVERAGE REPORT');
  print('=' * 50);
  
  print('\n📊 Overall Statistics:');
  print('   Total keys: ${report.totalKeys}');
  print('   Translated locales: ${report.locales.length}');
  print('   Average coverage: ${report.averageCoverage.toStringAsFixed(1)}%');
  
  print('\n🌍 Per-Locale Coverage:');
  for (final locale in report.locales) {
    final coverage = report.localeCoverage[locale]!;
    final status = coverage >= 95 ? '✅' : coverage >= 80 ? '⚠️' : '❌';
    print('   $status $locale: ${coverage.toStringAsFixed(1)}% (${report.localeKeys[locale]!.length}/${report.totalKeys} keys)');
  }
  
  print('\n📂 Feature-Based Coverage:');
  for (final feature in report.featureCoverage.keys) {
    final coverage = report.featureCoverage[feature]!;
    final status = coverage >= 95 ? '✅' : coverage >= 80 ? '⚠️' : '❌';
    print('   $status $feature: ${coverage.toStringAsFixed(1)}%');
  }
  
  if (report.missingKeys.isNotEmpty) {
    print('\n❌ Missing Translations:');
    for (final locale in report.missingKeys.keys) {
      if (report.missingKeys[locale]!.isNotEmpty) {
        print('   $locale: ${report.missingKeys[locale]!.take(5).join(', ')}${report.missingKeys[locale]!.length > 5 ? '...' : ''}');
      }
    }
  }
  
  if (report.untranslatedKeys.isNotEmpty) {
    print('\n⚠️ Possibly Untranslated (English values in non-English locales):');
    for (final locale in report.untranslatedKeys.keys) {
      if (report.untranslatedKeys[locale]!.isNotEmpty) {
        print('   $locale: ${report.untranslatedKeys[locale]!.take(3).join(', ')}${report.untranslatedKeys[locale]!.length > 3 ? '...' : ''}');
      }
    }
  }
  
  print('\n🎯 Recommendations:');
  if (report.averageCoverage < 80) {
    print('   📢 CRITICAL: Average coverage below 80%. Prioritize missing translations.');
  }
  
  for (final locale in report.locales) {
    final coverage = report.localeCoverage[locale]!;
    if (coverage < 95) {
      final missing = report.totalKeys - report.localeKeys[locale]!.length;
      print('   🔧 $locale needs $missing more translations to reach 95% coverage');
    }
  }
  
  // Generate detailed report file
  final reportFile = File('coverage/l10n_coverage_report.json');
  await reportFile.parent.create(recursive: true);
  await reportFile.writeAsString(jsonEncode(report.toJson()));
  print('\n💾 Detailed report saved to: ${reportFile.path}');
  
  // Exit with appropriate code
  exit(report.averageCoverage >= 80 ? 0 : 1);
}

Future<CoverageReport> generateCoverageReport() async {
  final arbFiles = await findArbFiles();
  final arbData = <String, Map<String, dynamic>>{};
  
  // Load all ARB files
  for (final file in arbFiles) {
    try {
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final locale = file.path.split('/').last.replaceAll('.arb', '').replaceAll('app_', '');
      arbData[locale] = data;
    } catch (e) {
      print('⚠️ Failed to parse ${file.path}: $e');
    }
  }
  
  if (arbData.isEmpty) {
    throw Exception('No valid ARB files found');
  }
  
  // Find reference locale and keys
  final referenceLocale = arbData.containsKey('en') ? 'en' : arbData.keys.first;
  final allKeys = arbData[referenceLocale]!.keys
      .where((key) => !key.startsWith('@'))
      .toSet();
  
  // Calculate per-locale coverage
  final localeCoverage = <String, double>{};
  final localeKeys = <String, Set<String>>{};
  final missingKeys = <String, Set<String>>{};
  final untranslatedKeys = <String, Set<String>>{};
  
  for (final locale in arbData.keys) {
    final keys = arbData[locale]!.keys
        .where((key) => !key.startsWith('@'))
        .where((key) => arbData[locale]![key]?.toString().trim().isNotEmpty ?? false)
        .toSet();
    
    localeKeys[locale] = keys;
    localeCoverage[locale] = (keys.length / allKeys.length) * 100;
    missingKeys[locale] = allKeys.difference(keys);
    
    // Check for untranslated keys (same value as English)
    if (locale != referenceLocale && arbData.containsKey(referenceLocale)) {
      final untranslated = <String>{};
      for (final key in keys.intersection(allKeys)) {
        final refValue = arbData[referenceLocale]![key]?.toString();
        final localeValue = arbData[locale]![key]?.toString();
        if (refValue != null && localeValue == refValue && refValue.length > 5) {
          untranslated.add(key);
        }
      }
      untranslatedKeys[locale] = untranslated;
    }
  }
  
  // Calculate feature-based coverage
  final featureCoverage = calculateFeatureCoverage(allKeys, arbData);
  
  // Calculate average coverage
  final avgCoverage = localeCoverage.values.isEmpty ? 0.0 : 
      localeCoverage.values.reduce((a, b) => a + b) / localeCoverage.length;
  
  return CoverageReport(
    totalKeys: allKeys.length,
    locales: arbData.keys.toList()..sort(),
    localeCoverage: localeCoverage,
    localeKeys: localeKeys,
    missingKeys: missingKeys,
    untranslatedKeys: untranslatedKeys,
    featureCoverage: featureCoverage,
    averageCoverage: avgCoverage,
  );
}

Map<String, double> calculateFeatureCoverage(Set<String> allKeys, Map<String, Map<String, dynamic>> arbData) {
  final features = <String, Set<String>>{
    'Prayer Times': allKeys.where((k) => k.contains('prayer') || k.contains('salah')).toSet(),
    'Quran': allKeys.where((k) => k.contains('quran') || k.contains('surah') || k.contains('ayah')).toSet(),
    'Audio': allKeys.where((k) => k.contains('audio') || k.contains('download') || k.contains('reciter')).toSet(),
    'Zakat': allKeys.where((k) => k.contains('zakat')).toSet(),
    'Qibla': allKeys.where((k) => k.contains('qibla')).toSet(),
    'Settings': allKeys.where((k) => k.contains('setting') || k.contains('preference')).toSet(),
    'UI Controls': allKeys.where((k) => k.contains('button') || k.contains('label') || k.contains('title')).toSet(),
    'Error Messages': allKeys.where((k) => k.contains('error') || k.contains('fail')).toSet(),
  };
  
  final coverage = <String, double>{};
  
  for (final feature in features.keys) {
    final featureKeys = features[feature]!;
    if (featureKeys.isEmpty) {
      coverage[feature] = 100.0;
      continue;
    }
    
    var totalCoverage = 0.0;
    var localeCount = 0;
    
    for (final locale in arbData.keys) {
      final localeKeys = arbData[locale]!.keys
          .where((key) => !key.startsWith('@'))
          .where((key) => arbData[locale]![key]?.toString().trim().isNotEmpty ?? false)
          .toSet();
      
      final coveredKeys = featureKeys.intersection(localeKeys);
      totalCoverage += (coveredKeys.length / featureKeys.length) * 100;
      localeCount++;
    }
    
    coverage[feature] = localeCount > 0 ? totalCoverage / localeCount : 0.0;
  }
  
  return coverage;
}

Future<List<File>> findArbFiles() async {
  final l10nDir = Directory('lib/l10n');
  if (!await l10nDir.exists()) {
    return [];
  }
  
  return l10nDir
      .listSync()
      .whereType<File>()
      .where((file) => file.path.endsWith('.arb'))
      .toList();
}

class CoverageReport {
  final int totalKeys;
  final List<String> locales;
  final Map<String, double> localeCoverage;
  final Map<String, Set<String>> localeKeys;
  final Map<String, Set<String>> missingKeys;
  final Map<String, Set<String>> untranslatedKeys;
  final Map<String, double> featureCoverage;
  final double averageCoverage;
  
  CoverageReport({
    required this.totalKeys,
    required this.locales,
    required this.localeCoverage,
    required this.localeKeys,
    required this.missingKeys,
    required this.untranslatedKeys,
    required this.featureCoverage,
    required this.averageCoverage,
  });
  
  Map<String, dynamic> toJson() {
    return {
      'totalKeys': totalKeys,
      'locales': locales,
      'localeCoverage': localeCoverage,
      'localeKeys': localeKeys.map((k, v) => MapEntry(k, v.toList())),
      'missingKeys': missingKeys.map((k, v) => MapEntry(k, v.toList())),
      'untranslatedKeys': untranslatedKeys.map((k, v) => MapEntry(k, v.toList())),
      'featureCoverage': featureCoverage,
      'averageCoverage': averageCoverage,
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }
}

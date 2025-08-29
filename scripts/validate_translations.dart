#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script to validate ARB translations and check for missing keys
/// Usage: dart run scripts/validate_translations.dart

void main() async {
  print('🔍 Validating translations...');
  
  final arbFiles = await findArbFiles();
  if (arbFiles.isEmpty) {
    print('❌ No ARB files found!');
    exit(1);
  }
  
  print('📄 Found ARB files: ${arbFiles.map((f) => f.path.split('/').last).join(', ')}');
  
  final validationResults = await validateTranslations(arbFiles);
  
  if (validationResults.isValid) {
    print('✅ All translations are valid!');
    exit(0);
  } else {
    print('❌ Translation validation failed:');
    for (final error in validationResults.errors) {
      print('   $error');
    }
    exit(1);
  }
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

Future<ValidationResult> validateTranslations(List<File> arbFiles) async {
  final errors = <String>[];
  final arbData = <String, Map<String, dynamic>>{};
  
  // Load all ARB files
  for (final file in arbFiles) {
    try {
      final content = await file.readAsString();
      final data = jsonDecode(content) as Map<String, dynamic>;
      final locale = file.path.split('/').last.replaceAll('.arb', '').replaceAll('app_', '');
      arbData[locale] = data;
    } catch (e) {
      errors.add('Failed to parse ${file.path}: $e');
    }
  }
  
  if (arbData.isEmpty) {
    errors.add('No valid ARB files found');
    return ValidationResult(false, errors);
  }
  
  // Find the reference locale (usually 'en')
  final referenceLocale = arbData.containsKey('en') ? 'en' : arbData.keys.first;
  final referenceKeys = arbData[referenceLocale]!.keys
      .where((key) => !key.startsWith('@'))
      .toSet();
  
  print('📋 Reference locale: $referenceLocale (${referenceKeys.length} keys)');
  
  // Check each locale against reference
  for (final locale in arbData.keys) {
    if (locale == referenceLocale) continue;
    
    final localeKeys = arbData[locale]!.keys
        .where((key) => !key.startsWith('@'))
        .toSet();
    
    print('📋 Checking locale: $locale (${localeKeys.length} keys)');
    
    // Find missing keys
    final missingKeys = referenceKeys.difference(localeKeys);
    if (missingKeys.isNotEmpty) {
      errors.add('Locale $locale missing keys: ${missingKeys.join(', ')}');
    }
    
    // Find extra keys
    final extraKeys = localeKeys.difference(referenceKeys);
    if (extraKeys.isNotEmpty) {
      errors.add('Locale $locale has extra keys: ${extraKeys.join(', ')}');
    }
    
    // Check for empty translations
    final emptyTranslations = localeKeys
        .where((key) => arbData[locale]![key]?.toString().trim().isEmpty ?? true)
        .toList();
    if (emptyTranslations.isNotEmpty) {
      errors.add('Locale $locale has empty translations: ${emptyTranslations.join(', ')}');
    }
    
    // Validate placeholder consistency
    for (final key in localeKeys.intersection(referenceKeys)) {
      final refValue = arbData[referenceLocale]![key]?.toString() ?? '';
      final localeValue = arbData[locale]![key]?.toString() ?? '';
      
      final refPlaceholders = extractPlaceholders(refValue);
      final localePlaceholders = extractPlaceholders(localeValue);
      
      if (!setsEqual(refPlaceholders, localePlaceholders)) {
        errors.add('Placeholder mismatch in $locale.$key: expected $refPlaceholders, got $localePlaceholders');
      }
    }
  }
  
  // Check for audio-specific keys that should exist
  final requiredAudioKeys = [
    'audioDownloadStarting',
    'audioDownloadProgress',
    'audioDownloadComplete',
    'audioDownloadFailed',
    'audioStorageUsed',
    'audioSelectReciter',
  ];
  
  final missingAudioKeys = requiredAudioKeys
      .where((key) => !referenceKeys.contains(key))
      .toList();
  
  if (missingAudioKeys.isNotEmpty) {
    errors.add('Missing required audio keys: ${missingAudioKeys.join(', ')}');
  }
  
  return ValidationResult(errors.isEmpty, errors);
}

Set<String> extractPlaceholders(String text) {
  final regex = RegExp(r'\{(\w+)\}');
  return regex.allMatches(text)
      .map((match) => match.group(1)!)
      .toSet();
}

bool setsEqual(Set<String> a, Set<String> b) {
  return a.length == b.length && a.difference(b).isEmpty;
}

class ValidationResult {
  final bool isValid;
  final List<String> errors;
  
  ValidationResult(this.isValid, this.errors);
}

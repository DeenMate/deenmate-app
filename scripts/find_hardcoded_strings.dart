#!/usr/bin/env dart

import 'dart:io';
import 'dart:convert';

/// Script to find hardcoded strings in Dart files
/// Usage: dart run scripts/find_hardcoded_strings.dart [directory]

void main(List<String> args) {
  final directory = args.isNotEmpty ? args[0] : 'lib/';
  print('🔍 Scanning for hardcoded strings in: $directory');
  
  final issues = <String>[];
  final excludePatterns = [
    r"import\s+['\"]", // Import statements
    r"part\s+['\"]", // Part statements
    r"//.*['\"]", // Comments
    r"/\*.*\*/", // Block comments
    r"@[A-Z]\w*\(['\"]", // Annotations
    r"assert\s*\(['\"]", // Assert statements
  ];
  
  scanDirectory(Directory(directory), issues, excludePatterns);
  
  if (issues.isEmpty) {
    print('✅ No hardcoded strings found!');
    exit(0);
  } else {
    print('❌ Found ${issues.length} potential hardcoded strings:');
    for (final issue in issues) {
      print('   $issue');
    }
    exit(1);
  }
}

void scanDirectory(Directory dir, List<String> issues, List<String> excludePatterns) {
  for (final entity in dir.listSync()) {
    if (entity is File && entity.path.endsWith('.dart')) {
      scanFile(entity, issues, excludePatterns);
    } else if (entity is Directory && !entity.path.contains('.dart_tool')) {
      scanDirectory(entity, issues, excludePatterns);
    }
  }
}

void scanFile(File file, List<String> issues, List<String> excludePatterns) {
  final content = file.readAsStringSync();
  final lines = content.split('\n');
  
  for (int i = 0; i < lines.length; i++) {
    final line = lines[i];
    final lineNumber = i + 1;
    
    // Skip if line matches exclude patterns
    if (excludePatterns.any((pattern) => RegExp(pattern).hasMatch(line))) {
      continue;
    }
    
    // Look for string literals that might be user-facing
    final stringMatches = RegExp(r"['\"]([^'\"]{3,})['\"]").allMatches(line);
    
    for (final match in stringMatches) {
      final stringValue = match.group(1)!;
      
      // Skip common non-user-facing strings
      if (shouldSkipString(stringValue)) continue;
      
      // Check if this looks like user-facing text
      if (isLikelyUserFacingString(stringValue)) {
        issues.add('${file.path}:$lineNumber - "$stringValue"');
      }
    }
  }
}

bool shouldSkipString(String value) {
  final skipPatterns = [
    r'^[a-z_]+$', // Variable names
    r'^[A-Z_]+$', // Constants
    r'^\d+$', // Numbers
    r'^[a-z]+://.*', // URLs
    r'^/.*', // Paths
    r'^[a-z]+\.[a-z]+', // Dot notation
    r'^[a-zA-Z]+\([^)]*\)$', // Function calls
  ];
  
  return skipPatterns.any((pattern) => RegExp(pattern).hasMatch(value));
}

bool isLikelyUserFacingString(String value) {
  // Look for characteristics of user-facing strings
  final userFacingPatterns = [
    r'\b(the|a|an|is|are|was|were|have|has|had)\b', // Common English words
    r'\b(prayer|quran|islamic|allah|surah|ayah)\b', // Islamic terms
    r'\b(error|success|loading|failed|complete)\b', // Status messages
    r'\b(download|upload|save|delete|cancel)\b', // Action words
    r'[.!?]$', // Ends with punctuation
  ];
  
  return userFacingPatterns.any((pattern) => 
    RegExp(pattern, caseSensitive: false).hasMatch(value)
  ) && value.length > 5; // Minimum length for meaningful text
}

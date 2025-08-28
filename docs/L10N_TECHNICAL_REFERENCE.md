# DeenMate l10n Technical Documentation

**Last Updated**: August 28, 2025  
**Status**: Comprehensive analysis completed - Implementation ready

---

## 📊 EXECUTIVE SUMMARY

### Critical Findings
- **262 hardcoded strings** identified across 80+ files
- **Current coverage**: 26% (68 of 262 strings localized)
- **Critical modules affected**: Prayer Times (27%), Quran Reader (21%)
- **Configuration issues**: Import paths + l10n.yaml settings

### Implementation Plan
- **7-week systematic approach** to achieve 95%+ coverage
- **189 new ARB keys** required with Bengali translations
- **CI/CD enforcement** to prevent future hardcoded strings
- **Zero tolerance policy** for new development

---

### Bengali Translation Priorities

**Islamic Terms (High Priority):**
- Salah/Prayer → নামাজ
- Qibla → কিবলা
- Athan/Adhan → আযান
- Quran → কুরআন
- Zakat → যাকাত
- Sawm/Fasting → রোযা
- Hajj → হজ্জ
- Dua → দোয়া
- Tafsir → তাফসির
- Sunnah → সুন্নাহ

**Prayer Time Terms:**
- Fajr → ফজর
- Dhuhr → যোহর  
- Asr → আসর
- Maghrib → মাগরিব
- Isha → ইশা
- Sunrise → সূর্যোদয়
- Midnight → মধ্যরাত

**Common UI Actions:**
- Settings → সেটিংস
- Notification → বিজ্ঞপ্তি
- Calendar → ক্যালেন্ডার
- Location → অবস্থান
- Language → ভাষা
- Theme → থিম

## ⚙️ Configuration Requirements

### 1. l10n.yaml Fix (CRITICAL)
```yaml
# CURRENT (WRONG):
synthetic-package: false

# REQUIRED FIX:
synthetic-package: true
```

### 2. Import Path Standardization (14 files)
**Wrong patterns found:**
```dart
// ❌ Package import (12 files)
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ❌ Assets import (2 files)  
import '../../../assets/translations/app_localizations.dart';
```

**Correct pattern:**
```dart
// ✅ Relative import
import '../../../../l10n/generated/app_localizations.dart';
```

### 3. Files Requiring Import Fixes
- `lib/features/quran/presentation/screens/quran_reader_screen.dart`
- `lib/features/prayer_times/presentation/screens/calculation_method_screen.dart`
- `lib/features/prayer_times/presentation/screens/athan_settings_screen.dart`
- `lib/features/settings/presentation/screens/accessibility_settings_screen.dart`
- [10 additional files documented in main TODO.md]

---

## 📄 ARB KEY REQUIREMENTS

### Critical Islamic Features (Priority 1)

#### Prayer Times (17 keys)
```json
{
  "prayerCalculationMethodsTitle": "Prayer Calculation Methods",
  "prayerCalculationMethodsApplyMethod": "Apply Method",
  "prayerCalculationMethodsCreateCustom": "Create Custom Method",
  "athanSettingsVibration": "Vibration",
  "athanSettingsQuickActions": "Quick Actions",
  "athanSettingsAutoComplete": "Auto-complete",
  "permissionsGrant": "Grant"
}
```

#### Quran Reader (17 keys)
```json
{
  "quranReaderLoadError": "Failed to load: {errorMessage}",
  "quranReaderAudioManager": "Audio Manager",
  "quranReaderAutoScroll": "Auto Scroll",
  "quranSurah": "Surah",
  "quranJuz": "Juz",
  "quranReaderCopyArabicText": "Copy Arabic Text",
  "quranVerseCopiedToClipboard": "Verse copied to clipboard"
}
```

### Common Actions (Priority 1)
```json
{
  "commonRetry": "Retry",
  "commonExit": "Exit", 
  "commonClose": "Close",
  "commonConfirm": "Confirm",
  "commonSkip": "Skip",
  "commonClear": "Clear",
  "commonView": "View",
  "commonGo": "Go",
  "commonDownload": "Download",
  "commonSendEmail": "Send Email",
  "commonHelp": "Help"
}
```

### Bengali Translations (Critical Islamic Terms)
```json
{
  "prayerCalculationMethodsTitle": "নামাজের সময় নির্ধারণ পদ্ধতি",
  "athanSettingsVibration": "কম্পন",
  "quranSurah": "সূরা",
  "quranJuz": "পারা",
  "readingPlansRamadan": "রমজান",
  "inheritanceHelpStep1": "১. মৃত ব্যক্তির লিঙ্গ নির্বাচন করুন",
  "commonRetry": "পুনরায় চেষ্টা",
  "commonExit": "বাহির",
  "commonClose": "বন্ধ"
}
```

---

## 🔄 CODE TRANSFORMATION EXAMPLES

### Navigation Dialog Fix
```dart
// ❌ BEFORE (hardcoded)
AlertDialog(
  title: Text('Exit DeenMate'),
  content: Text('Are you sure you want to exit the app?'),
  actions: [
    TextButton(child: Text('Cancel'), onPressed: () => Navigator.pop(context)),
    TextButton(child: Text('Exit'), onPressed: () => Navigator.pop(context, true)),
  ],
)

// ✅ AFTER (localized)
AlertDialog(
  title: Text(AppLocalizations.of(context)!.navigationExitDialogTitle),
  content: Text(AppLocalizations.of(context)!.navigationExitDialogMessage),
  actions: [
    TextButton(child: Text(AppLocalizations.of(context)!.commonCancel), onPressed: () => Navigator.pop(context)),
    TextButton(child: Text(AppLocalizations.of(context)!.commonExit), onPressed: () => Navigator.pop(context, true)),
  ],
)
```

### Prayer Method Screen Fix
```dart
// ❌ BEFORE (hardcoded)
AppBar(title: Text('Prayer Calculation Methods'))

ElevatedButton(
  onPressed: () => _applyMethod(method),
  child: Text('Apply Method'),
)

// ✅ AFTER (localized)
AppBar(title: Text(AppLocalizations.of(context)!.prayerCalculationMethodsTitle))

ElevatedButton(
  onPressed: () => _applyMethod(method),
  child: Text(AppLocalizations.of(context)!.prayerCalculationMethodsApplyMethod),
)
```

### Quran Reader Error Handling
```dart
// ❌ BEFORE (hardcoded)
Text('Failed to load: $_errorMessage')

ElevatedButton(
  onPressed: _retryLoad,
  child: Text('Retry'),
)

// ✅ AFTER (localized with parameter)
Text(AppLocalizations.of(context)!.quranReaderLoadError(_errorMessage))

ElevatedButton(
  onPressed: _retryLoad,
  child: Text(AppLocalizations.of(context)!.commonRetry),
)
```

---

## 📊 Analysis Summary

**Total Hardcoded Strings:** 262 instances  
**Files Affected:** 80+ files  
**Current l10n Coverage:** 26%  
**Target Coverage:** 100%

**Priority Distribution:**
- High Priority: 189 strings (critical UI elements)
- Medium Priority: 47 strings (secondary features)  
- Low Priority: 26 strings (debug/development)

### Critical File/Line Mappings (Sample)

**Prayer Times Module:**
- `lib/features/prayer_times/presentation/screens/prayer_calculation_methods_screen.dart:127` → "Prayer Calculation Methods" → `prayer.calculationMethodsTitle`
- `lib/features/prayer_times/presentation/screens/prayer_calculation_methods_screen.dart:163` → "Apply Method" → `prayer.applyMethod`
- `lib/features/prayer_times/presentation/screens/athan_settings_screen.dart:234` → "Vibration" → `athan.vibration`

**Quran Reader Module:**
- `lib/features/quran/presentation/screens/quran_reader_screen.dart:1576` → "Surah" → `quran.surah`
- `lib/features/quran/presentation/screens/quran_reader_screen.dart:1690` → "Copy Arabic Text" → `quran.reader.copyArabicText`
- `lib/features/quran/presentation/screens/bookmarks_screen.dart:405` → "Delete" → `common.delete`

**Inheritance Calculator:**
- `lib/features/zakat/presentation/screens/inheritance_calculator_screen.dart:286` → "Add Heir" → `inheritance.addHeir`
- `lib/features/zakat/presentation/screens/inheritance_calculator_screen.dart:307` → "Calculate" → `common.calculate`

**Common Actions (Used across multiple files):**
- `common.retry` (7 occurrences)
- `common.close` (12 occurrences)  
- `common.confirm` (8 occurrences)
- `common.view` (5 occurrences)

---

## 🔒 CI/CD ENFORCEMENT STRATEGY

### GitHub Actions Workflow (l10n-validation.yml)
```yaml
name: L10n Validation
on:
  pull_request:
    paths: ['lib/**/*.dart', 'lib/l10n/**']
  push:
    branches: [main, develop]

jobs:
  hardcoded-string-check:
    name: Check for Hardcoded Strings
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      - name: Run hardcoded string scan
        run: |
          echo "🔍 Scanning for hardcoded UI strings..."
          PATTERNS=("Text\s*\(\s*['\"]" "SnackBar\s*\(\s*content:\s*Text\s*\(\s*['\"]" "title:\s*Text\s*\(\s*['\"]")
          VIOLATIONS=0
          for pattern in "${PATTERNS[@]}"; do
            MATCHES=$(find lib/ -name "*.dart" -not -path "lib/l10n/generated/*" \
              -exec grep -l -E "$pattern" {} \; 2>/dev/null | wc -l)
            if [ "$MATCHES" -gt 0 ]; then
              echo "❌ Found $MATCHES files with hardcoded strings matching: $pattern"
              VIOLATIONS=$((VIOLATIONS + MATCHES))
            fi
          done
          if [ "$VIOLATIONS" -gt 0 ]; then
            echo "💥 FAILURE: Found $VIOLATIONS hardcoded string violations"
            exit 1
          fi

  l10n-config-validation:
    name: Validate l10n Configuration
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Validate l10n.yaml configuration
        run: |
          if [ ! -f "l10n.yaml" ]; then
            echo "❌ l10n.yaml not found"; exit 1
          fi
          if ! grep -q "synthetic-package: true" l10n.yaml; then
            echo "❌ l10n.yaml missing 'synthetic-package: true'"; exit 1
          fi
          if ! grep -q "arb-dir: lib/l10n" l10n.yaml; then
            echo "❌ l10n.yaml missing correct arb-dir"; exit 1
          fi

  arb-file-validation:
    name: Validate ARB Files
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      - name: Validate ARB files
        run: |
          if [ ! -f "lib/l10n/app_en.arb" ]; then
            echo "❌ app_en.arb template file missing"; exit 1
          fi
          if [ ! -f "lib/l10n/app_bn.arb" ]; then
            echo "❌ app_bn.arb Bengali file missing"; exit 1
          fi
          python3 -m json.tool lib/l10n/app_en.arb > /dev/null
          python3 -m json.tool lib/l10n/app_bn.arb > /dev/null
          flutter gen-l10n
```

### Pre-commit Hook
```bash
#!/bin/bash
# Check for hardcoded strings in staged files
STAGED_DART_FILES=$(git diff --cached --name-only | grep '\.dart$' | grep -v 'lib/l10n/generated/')

if [ -n "$STAGED_DART_FILES" ]; then
    for file in $STAGED_DART_FILES; do
        if grep -E "Text\s*\(\s*['\"]" "$file" > /dev/null 2>&1; then
            echo "❌ Hardcoded string detected in: $file"
            exit 1
        fi
    done
fi
```

### VS Code Integration
```json
{
  "emeraldwalk.runonsave": {
    "commands": [
      {
        "match": "\\.dart$",
        "cmd": "if grep -E \"Text\\s*\\(\\s*['\\\"]\" \"${file}\" > /dev/null; then echo 'WARNING: Potential hardcoded string in ${fileBasename}'; fi"
      }
    ]
  }
}
```

---

## 📈 WEEKLY IMPLEMENTATION MILESTONES

### Week 1: Critical Infrastructure
- [ ] Fix l10n.yaml configuration
- [ ] Standardize 14 import paths  
- [ ] Add 50 critical ARB keys (Common + Navigation)
- [ ] Implement Prayer Times core strings

**Target**: 262 → 150 hardcoded strings

### Week 2: Islamic Core Features  
- [ ] Complete Prayer Times module (45 strings)
- [ ] Complete Quran Reader core (38 strings)
- [ ] Add Bengali translations for all new keys

**Target**: 150 → 75 hardcoded strings

### Week 3: Supporting Features
- [ ] Inheritance Calculator (12 strings)
- [ ] Accessibility features (15 strings)
- [ ] Bookmarks and Reading Plans (19 strings)

**Target**: 75 → 25 hardcoded strings

### Week 4: Final Implementation
- [ ] Remaining modules completion
- [ ] 100% Bengali translation verification
- [ ] CI/CD workflow deployment

**Target**: 25 → 0 hardcoded strings

---

## 🎯 SUCCESS METRICS

### Quality Gates
- **Zero hardcoded strings** in new PRs (CI enforced)
- **95%+ localization coverage** for critical paths
- **100% Bengali translation** for user-facing strings  
- **100% import path compliance**
- **All CI/CD checks passing**

### Cultural Compliance
- **Islamic terminology accuracy** verified by Bengali speakers
- **Cultural appropriateness** for religious content
- **Proper Arabic transliteration** in Bengali context

### Technical Excellence
- **Official Flutter l10n** compliance (ARB-based)
- **Type-safe localization** with generated accessors
- **ICU message format** support for complex strings
- **Automated compliance** monitoring

---

## 🚨 RISK MITIGATION

### High-Risk Areas
1. **Islamic terminology** - Requires expert Bengali review
2. **UI layout breaking** - Bengali text length variations
3. **Performance impact** - Localization loading overhead
4. **CI/CD false positives** - Pattern detection accuracy

### Mitigation Strategies
1. **Expert consultation** - Bengali-speaking Islamic scholar review
2. **Responsive design testing** - Text overflow scenarios
3. **Performance benchmarking** - Before/after measurements
4. **Pattern refinement** - Iterative CI/CD improvement

---

*Technical documentation compiled from comprehensive 7-deliverable analysis*  
*Implementation ready - Phase 1 can begin immediately*

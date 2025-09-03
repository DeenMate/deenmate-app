# Quran Module - TODO & Backlog

*Last Updated: 2025-09-03*  
*Module Location: `lib/features/quran/`*

This document tracks prioritized bug fixes, enhancements, and feature gaps for the Quran module based on comprehensive audit findings.

---

## 🚨 Critical Issues (Priority 1)

### 1. Fix Hardcoded Strings in Reader Screens
**Files Affected:**
- `lib/features/quran/presentation/screens/juz_reader_screen.dart`
- `lib/features/quran/presentation/screens/ruku_reader_screen.dart`
- `lib/features/quran/presentation/screens/hizb_reader_screen.dart`

**Current vs Expected:**
```dart
// CURRENT (BAD):
Text('Juz $juzNumber')
Text('No verses found for Juz $juzNumber')
Text('This feature is under development')
Text('Error loading Juz $juzNumber: $error')
const Text('Retry')

// EXPECTED (GOOD):
Text(AppLocalizations.of(context)!.quranJuzTitle(juzNumber))
Text(AppLocalizations.of(context)!.quranNoVersesFound)
Text(AppLocalizations.of(context)!.quranFeatureUnderDevelopment)
Text(AppLocalizations.of(context)!.quranErrorLoadingContent(error))
Text(AppLocalizations.of(context)!.quranRetryButton)
```

**ARB Keys to Add:**
```json
{
  "quranJuzTitle": "Juz {number}",
  "quranRukuTitle": "Ruku {number}",
  "quranHizbTitle": "Hizb {number}",
  "quranPageTitle": "Page {number}",
  "quranNoVersesFound": "No verses found",
  "quranFeatureUnderDevelopment": "This feature is under development",
  "quranErrorLoadingContent": "Error loading content: {error}",
  "quranRetryButton": "Retry"
}
```

**Proposed Fix:**
1. Add missing ARB keys to `lib/l10n/app_en.arb` and `lib/l10n/app_bn.arb`
2. Update all reader screen files to use AppLocalizations
3. Test language switching behavior

**Dependencies:** None  
**Risk Level:** Low (straightforward i18n migration)  
**Test Cases:**
- [ ] Switch language and verify all screens show correct translations
- [ ] Test error states in both EN and BN
- [ ] Verify parameter interpolation works correctly

---

### 2. Fix Reciter Availability Issue
**File:** `lib/features/quran/data/api/resources_api.dart`

**Current Issue:**
Some reciters show as "unavailable" in the picker, preventing audio playback.

**Root Cause Investigation Needed:**
- Check API response structure for recitation resources
- Verify reciter ID mapping between API and local storage
- Check if API endpoint has changed response format

**Proposed Fix:**
1. Debug API response in `getRecitationResources()`
2. Add better error handling and logging
3. Implement fallback reciter selection
4. Add availability status indicator in UI

**Dependencies:** API investigation  
**Risk Level:** Medium (requires API debugging)  
**Test Cases:**
- [ ] All reciters in dropdown should be playable
- [ ] Error handling when reciter is truly unavailable
- [ ] Fallback to default reciter when selected reciter fails

---

### 3. Implement Audio Download Prompts
**Files:**
- `lib/features/quran/presentation/widgets/audio_player_widget.dart`
- `lib/features/quran/presentation/widgets/mobile_audio_player.dart`

**Current Issue:**
When user plays a verse for an unavailable audio file, no prompt appears.

**Expected Behavior:**
Show dialog: "Audio not downloaded. Stream online or Download this Surah?"

**Proposed Fix:**
```dart
// Add to audio player widget
Future<void> _handleAudioPlay(String verseKey) async {
  final hasLocalAudio = await _checkLocalAudio(verseKey);
  
  if (!hasLocalAudio) {
    final action = await _showAudioPrompt(context);
    if (action == AudioAction.download) {
      await _downloadSurahAudio(verseKey);
    } else if (action == AudioAction.stream) {
      await _streamAudio(verseKey);
    }
  } else {
    await _playLocalAudio(verseKey);
  }
}
```

**Dependencies:** Audio service refactoring  
**Risk Level:** Medium (UX flow changes)  
**Test Cases:**
- [ ] Prompt appears when audio not available
- [ ] Stream option works immediately
- [ ] Download option saves audio for future use
- [ ] No prompt when audio already downloaded

---

## 🔥 High Priority Issues (Priority 2)

### 4. Implement Background Text Download
**File:** `lib/features/quran/domain/services/offline_content_service.dart`

**Current Issue:**
No automatic download of complete Quran text after app install.

**Expected Behavior:**
- Download all Quran text + translations in background after install
- Show progress notification
- Resume on app restart if interrupted
- Only download on Wi-Fi by default

**Proposed Fix:**
```dart
class BackgroundDownloadService {
  Future<void> schedulePostInstallDownload() async {
    // Use WorkManager or background task
    // Download all 114 chapters with default translations
    // Store progress in Hive
    // Send progress notifications
  }
}
```

**Dependencies:** WorkManager or similar background task library  
**Risk Level:** High (background processing complexity)  
**Test Cases:**
- [ ] Download starts automatically after fresh install
- [ ] Progress is visible to user
- [ ] Download resumes after app restart
- [ ] App works offline after download complete

---

### 5. Complete "Download All Audio" Feature
**File:** `lib/features/quran/presentation/screens/audio_downloads_screen.dart`

**Current Issue:**
UI exists but bulk download functionality incomplete.

**Missing Implementation:**
- Batch download queue management
- Progress tracking for multiple chapters
- Cancel/pause all downloads
- Storage space verification

**Proposed Fix:**
```dart
// Add to audio downloads screen
Future<void> _downloadAllAudio() async {
  final totalSize = await _calculateTotalSize();
  final hasSpace = await _verifyStorageSpace(totalSize);
  
  if (!hasSpace) {
    _showInsufficientStorageDialog();
    return;
  }
  
  await _startBatchDownload(allChapters);
}
```

**Dependencies:** Storage management utilities  
**Risk Level:** Medium (storage and queue management)  
**Test Cases:**
- [ ] Storage space checked before download
- [ ] All chapters download in sequence
- [ ] Progress shown for each chapter
- [ ] Cancel/pause functionality works

---

### 6. Add Consistent Sajdah Markers
**Files:** All verse display widgets

**Current Issue:**
Sajdah indicators are inconsistent across different reading modes.

**Expected Implementation:**
- Mark all 14 places of sajdah in Quran
- Consistent icon/styling across all reader screens
- Optional: Haptic feedback on sajdah verses

**Proposed Fix:**
Add sajdah data to verse DTOs and implement consistent UI component.

**Dependencies:** Sajdah verse data  
**Risk Level:** Low (UI enhancement)  
**Test Cases:**
- [ ] All 14 sajdah verses marked correctly
- [ ] Consistent styling across screens
- [ ] Marker visible in different reading modes

---

## 📋 Medium Priority Features (Priority 3)

### 7. Implement Tafsir Panel
**Files:**
- `lib/features/quran/presentation/screens/quran_reader_screen.dart`
- Create new widget: `tafsir_panel_widget.dart`

**Current Status:**
API exists, data models ready, but no UI implementation.

**Required Features:**
- Toggle tafsir panel below verses
- Multiple tafsir sources (Ibn Kathir, Tabari, etc.)
- Tafsir source picker
- Expandable/collapsible panel

**Dependencies:** UI design for tafsir panel  
**Risk Level:** Low (data already available)

---

### 8. Add Word-by-Word Display
**File:** Create `lib/features/quran/presentation/widgets/word_by_word_widget.dart`

**Features Required:**
- Arabic word + transliteration + meaning
- Toggle on/off
- Expandable below each verse
- Multiple language support for meanings

**Dependencies:** Word analysis API integration  
**Risk Level:** Medium (complex UI layout)

---

### 9. Implement Script Variations
**Files:** Font assets and text rendering

**Required Scripts:**
- Uthmanic (current default)
- IndoPak (for South Asian users)
- Font switching functionality
- Proper line height and spacing for each script

**Dependencies:** Font assets, typography system  
**Risk Level:** Medium (font rendering complexity)

---

### 10. Advanced Search Implementation
**File:** `lib/features/quran/presentation/screens/quran_search_screen.dart`

**Missing Features:**
- Keyword search across translations
- Transliteration search
- Bengali text search
- Search filters (chapter, verse range)
- Search result highlighting

**Dependencies:** Search indexing system  
**Risk Level:** High (search algorithm complexity)

---

## 🧪 Testing Checklist

### Unit Tests Required
- [ ] Audio download state management
- [ ] Verse caching logic
- [ ] Search functionality
- [ ] Background download service
- [ ] API client error handling

### Widget Tests Required
- [ ] Reader screens with hardcoded string fixes
- [ ] Audio player prompt dialogs
- [ ] Translation picker functionality
- [ ] Search results display
- [ ] Tafsir panel toggle

### Integration Tests Required
- [ ] Complete offline functionality
- [ ] Audio download and playback flow
- [ ] Language switching persistence
- [ ] Background download completion
- [ ] Search across different content types

---

## 📈 Success Metrics

### Sprint A Goals
- [ ] Zero hardcoded strings in Quran module
- [ ] 100% reciter availability
- [ ] Audio download prompts implemented
- [ ] Background text download working
- [ ] ARB coverage complete for EN/BN

### Quality Targets
- [ ] Test coverage > 70%
- [ ] No critical bugs in production
- [ ] i18n coverage 100% for Quran module
- [ ] Performance: Reader screen loads < 2 seconds

---

*Next Action: Start with hardcoded strings migration - create branch `fix/quran-i18n-strings`*

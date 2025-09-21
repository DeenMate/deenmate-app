# Quran Module - TODO & Bug Backlog

This document lists prioritized tasks, bugs, and feature gaps for the Quran module.

*Last Updated: 2025-09-04*

---

## Critical (Core functionality broken or missing)

1.  **Reciter Availability Bug**: Reciters show as "unavailable" in the picker.
    -   **Description**: The list of available reciters is incorrectly filtered, showing many as unavailable when they should be playable.
    -   **Files**: `lib/features/quran/presentation/state/providers.dart` (recitationsProvider), `lib/features/quran/domain/services/audio_service.dart`.
    -   **Current Behavior**: Reciter picker is almost empty or shows "unavailable" tags.
    -   **Expected Behavior**: All reciters that have a valid API source should be listed as available.
    -   **Proposed Fix**: Debug the `isReciterAvailable` check in `QuranAudioService`. It might be an API issue, a parsing error, or a race condition. Add caching for availability checks to improve performance.
    -   **Risk**: Medium (involves API and state management).
    -   **Test Cases**:
        -   Unit test for `isReciterAvailable`.
        -   Widget test to ensure the reciter picker populates correctly.

2.  **Missing Audio Download Prompts**: Users are not prompted to stream or download when playing audio for a Surah not available offline.
    -   **Description**: Tapping the play button on a verse in a non-downloaded surah either does nothing or silently starts streaming, which is against the specified policy.
    -   **Files**: `lib/features/quran/presentation/widgets/audio_player_widget.dart`, `lib/features/quran/domain/services/audio_service.dart`, `lib/features/quran/presentation/screens/enhanced_quran_reader_screen.dart`.
    -   **Current Behavior**: No prompt is shown.
    -   **Expected Behavior**: A dialog should appear asking the user to "Stream Online" or "Download this Surah audio".
    -   **Proposed Fix**: Before initiating playback, check for local audio availability. If not found, trigger a dialog. Wire the dialog's actions to the appropriate streaming or download functions in `QuranAudioService`.
    -   **Risk**: Low.
    -   **Test Cases**:
        -   Widget test to verify the dialog appears when playing an undownloaded surah.
        -   Integration test to confirm that "Stream" plays audio and "Download" starts the download process.

3.  **Hardcoded Strings**: Multiple screens and widgets contain hardcoded English strings, breaking i18n for Bengali and other languages.
    -   **Description**: UI elements display English text regardless of the selected app language.
    -   **Files**: `rg -n --glob "lib/features/quran/**.dart" 'Text\\(|\.tr\\(|"[A-Za-z]'` will find them. Known culprits are in reader screens (`juz_reader_screen.dart`, etc.) and some widgets.
    -   **Current Behavior**: "Juz 1", "No verses found", etc., are always in English.
    -   **Expected Behavior**: All UI strings should be sourced from ARB files and respect the current locale.
    -   **Proposed Fix**: Systematically replace all hardcoded strings with `AppLocalizations.of(context)!.keyName`. Add the new keys to `app_en.arb` and `app_bn.arb`.
    -   **Risk**: Low.
    -   **Test Cases**:
        -   Widget tests for affected screens, checking for correct localization in both EN and BN.

---

## High (Major UX degradation or missing core feature)

1.  **Background Text Download Unverified**: The initial download of Quran text is implemented but its success, resilience (retry on failure), and constraints (Wi-Fi/charging) are unconfirmed.
    -   **Description**: The app should download the entire Quran text in the background after the first launch. The current implementation exists but lacks robustness.
    -   **Files**: `lib/features/quran/presentation/state/providers.dart` (`quranBackgroundDownloadProvider`), `lib/features/quran/domain/services/offline_content_service.dart`.
    -   **Current Behavior**: A `FutureProvider` triggers a download once. It's unclear if it retries or handles network loss.
    -   **Expected Behavior**: A robust background job that downloads the essential Quran text, retries on failure, and ideally runs only on Wi-Fi.
    -   **Proposed Fix**: Enhance `OfflineContentService` to use a more robust background task manager (like `workmanager`). Add logic for retries and network constraints. Add logging to monitor its status.
    -   **Risk**: Medium.
    -   **Test Cases**:
        -   Integration test: Fresh install, disconnect internet, verify app fails gracefully. Connect to Wi-Fi, verify download completes in the background.

2.  **No Tafsir/Word-by-Word UI**: The backend and data layers can fetch tafsir and word-by-word data, but no UI exists in the reader to display it.
    -   **Description**: A key feature for in-depth study is completely missing from the user interface.
    -   **Files**: `lib/features/quran/presentation/screens/enhanced_quran_reader_screen.dart`, `lib/features/quran/presentation/widgets/`.
    -   **Current Behavior**: The reader only shows Arabic text and translations.
    -   **Expected Behavior**: The reader should have controls (e.g., a bottom tray or toggleable panel) to display word-by-word analysis and selected tafsirs for a given verse.
    -   **Proposed Fix**: Design and implement a `TafsirPanel` and a `WordByWordTray` widget. Add controls to the reader screen to toggle their visibility.
    -   **Risk**: Medium.
    -   **Test Cases**:
        -   Widget test for the new panels.
        -   Golden tests for the reader screen with panels open.

3.  **Redundant Audio Controllers**: Two separate audio management systems (`QuranAudioService` and `QuranAudioController`) exist.
    -   **Description**: This creates code duplication, confusion for developers, and potential state synchronization bugs.
    -   **Files**: `lib/features/quran/presentation/state/providers.dart`, `lib/features/quran/domain/services/audio_service.dart`.
    -   **Current Behavior**: Both controllers are available and potentially used in different parts of the app.
    -   **Expected Behavior**: A single, unified audio service that manages state, playback, and downloads.
    -   **Proposed Fix**: Choose `QuranAudioService` as the single source of truth. Refactor any widgets currently using `QuranAudioController` to use the service instead. Remove `QuranAudioController`.
    -   **Risk**: High (major refactoring).
    -   **Test Cases**:
        -   Regression testing on all audio features after the refactor.

---

## Medium (Nice-to-have / Parity gaps)

1.  **Missing Script Variants**: No UI to switch between Uthmanic and IndoPak scripts.
2.  **Basic Search Only**: Search does not support transliteration, fuzzy matching, or different languages effectively.
3.  **Incomplete Reading Plans**: The feature screen exists but is not fully implemented.
4.  **Monolithic Provider File**: `providers.dart` is over 1300 lines and needs to be broken down into smaller, feature-specific files for maintainability.
5.  **Missing "Download All Audio"**: The UI for this may exist, but the underlying implementation is incomplete.

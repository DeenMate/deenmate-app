# DeenMate Quran Module: Project Tracking

This document tracks the audit, planning, and execution of improvements for the DeenMate Quran module.

*Last Updated: 2025-09-04*

---

## 1) Current State — Audit 2025-09-04

### 1.1 Structure & Providers

#### File System Structure (`lib/features/quran/`)

The module follows a standard feature-driven architecture, but with some inconsistencies in layer separation.

```
lib/features/quran/
├── data/              # Data layer: API clients, DTOs, and repository implementations.
│   ├── api/           # API clients (Dio) for Quran.com.
│   ├── cache/         # Hive cache keys.
│   ├── dto/           # Data Transfer Objects for API responses.
│   └── repo/          # Implementation of the domain repository.
├── domain/            # Business logic: Entities, use cases (services), and repository contracts.
│   └── services/      # Contains use cases like AudioService, BookmarksService, etc.
├── infrastructure/    # Platform-specific implementations (e.g., audio downloaders).
├── presentation/      # UI Layer: Screens, widgets, and Riverpod providers for state.
│   ├── controllers/   # StateNotifiers/Controllers for complex UI logic.
│   ├── providers/     # Riverpod providers (mostly for audio).
│   ├── screens/       # Feature screens (Reader, Home, Search, etc.).
│   ├── state/         # Main monolithic providers file.
│   └── widgets/       # Reusable UI components.
└── utils/             # Utility functions.
```

**Observations:**
- The separation between `data`, `domain`, and `presentation` is generally followed.
- The `domain/services` directory acts as the use case layer.
- The `presentation/state/providers.dart` file is a "god file" over 1300 lines long and should be refactored.
- There's a duplicate `mobile_audio_download_infrastructure.dart` file, which needs cleanup.

#### Riverpod Providers Analysis

The providers are centralized in `presentation/state/providers.dart`.

**Key Provider Groups:**

1.  **API/Data Layer Providers:**
    - `dioQfProvider`: Provides the Dio instance for network requests.
    - `chaptersApiProvider`, `versesApiProvider`, `resourcesApiProvider`: Provide API client instances.
    - `quranRepoProvider`: The central repository, combining API and cache logic.

2.  **Domain Service Providers:**
    - `quranAudioServiceProvider`: Manages audio playback, downloads, and state. This seems to be the primary, more complex audio handler.
    - `offlineContentServiceProvider`: Manages downloading and accessing offline text.
    - `bookmarksServiceProvider`: Handles bookmark logic.
    - `quranSearchServiceProvider`: Encapsulates search logic.

3.  **Application/State Providers:**
    - `surahListProvider`: Fetches the list of all Surahs.
    - `recitationsProvider`: Fetches available reciters and **filters them by availability**, which is a key area for the "unavailable reciter" bug.
    - `translationResourcesProvider`, `tafsirResourcesProvider`: Fetch other resources.
    - `lastReadProvider`, `bookmarksProvider`: Stream providers for user-specific data from Hive.
    - `prefsProvider`: A `NotifierProvider` managing a `QuranPrefs` object with all user settings (fonts, translations, etc.). This is the source of truth for UI configuration.
    - `quranAudioProvider`: A simpler `StateNotifier` for audio control. **This is a potential conflict/redundancy** with `quranAudioServiceProvider`.
    - `quranBackgroundDownloadProvider`: A `FutureProvider` that triggers the initial background download of Quran text after installation. This confirms the feature exists but needs verification.

**Provider-related Issues:**
- **Monolithic Provider File**: `providers.dart` is too large and hard to maintain.
- **Redundant Audio Controllers**: Two systems for audio (`quranAudioServiceProvider` and `quranAudioProvider`) likely cause conflicts and confusion. The project should standardize on one.
- **Provider Dependencies**: The dependency graph is complex due to the single file. Splitting the file would clarify dependencies.

### 1.2 API & Data

- **API Usage**: The app uses the `quran.com` v4 API. Key endpoints identified in the code are `/chapters`, `/verses/by_chapter`, and `/resources/*` (translations, recitations, tafsirs).
- **Data Flow**: `QuranRepository` in `data/repo/` orchestrates calls to the API clients (`data/api/`) and caches responses in Hive.
- **Models**: DTOs in `data/dto/` are used for JSON parsing with `freezed` and `json_serializable`.
- **Error Handling**: The repository layer includes `try-catch` blocks and seems to fall back to cache on failure, which is good practice.
- **Caching**: Hive is used extensively. The `quranRepoProvider` injects `Hive` directly. Cache keys are defined in `data/cache/cache_keys.dart`. The TTL policy is not explicitly defined in the code and seems to be indefinite.

### 1.3 Offline & Storage

- **Offline Text**: The `quranBackgroundDownloadProvider` confirms an attempt to download essential Quran text post-install. It uses a `SharedPreferences` flag (`quran_basic_downloaded`) to run only once. The `OfflineContentService` handles the logic. This needs to be tested to confirm it works as expected.
- **Local Schema**: Hive boxes are used for:
    - `quran_last_read`: Stores the last read verse.
    - `quran_bookmarks_chapters`: Bookmarked chapters.
    - `notes`: User notes per verse.
    - `downloads`: Tracks download status of chapters.
    - `quran_prefs`: User preferences (fonts, translations, etc.).
    - `verses`: Caches verse data fetched from the API.

### 1.4 Audio

- **Reciter List**: The `recitationsProvider` fetches the list of reciters and then filters them by calling `service.isReciterAvailable(r.id)`. This is the likely source of the "unavailable" bug; the availability check might be failing or too slow.
- **Playback**: Two audio controllers exist. `QuranAudioController` is a simple `StateNotifier` that handles basic playback. `QuranAudioService` is a more complex service that also manages downloads and state streams. This redundancy must be resolved. The app appears to use `audioplayers` package.
- **Download Policy**:
    - The `AudioDownloadManager` and `quranAudioServiceProvider` contain logic for downloading chapter audio.
    - There is no clear evidence of a prompt to "Stream online" or "Download". This is a major gap.
    - There is no "Download all Surah audio" feature visible in the providers.

### 1.5 UI/UX & Theme

- A quick scan of widget files shows usage of `Theme.of(context)` and custom theme extensions, which is good. A full visual audit is required to spot inconsistencies.
- Layouts for single/multi-translation views are present.
- A `SajdahMarkerWidget` exists.
- Word-by-word and tafsir panels are missing from the main reader UI, although providers for their data exist.

### 1.6 i18n Localization

- **Hardcoded Strings**: A search is needed to identify all hardcoded strings. The user prompt already pointed out several in reader screens.
- **ARB Coverage**: `l10n.yaml` and `.arb` files in `lib/l10n` need to be checked for completeness for EN and BN.

### 1.7 Feature Parity vs Goals

- **Gaps Identified**:
    - **Critical**: No Tafsir view, no word-by-word view, no script variations (Uthmanic/IndoPak).
    - **High**: Advanced search is missing (only basic implementation exists).
    - **Medium**: Reading plans are not fully implemented.
    - **Core**: Audio download prompts and "download all" are missing. Background text download needs verification.

---

## 2) Bug & Gap List (Prioritized)

*This section will be moved to `docs/quran-module/todo-quran.md`.*

**Critical (Core functionality broken or missing)**
1.  **Reciter Availability Bug**: Reciters show as "unavailable".
    - **Root Cause Hypothesis**: The `isReciterAvailable` check in `QuranAudioService` is faulty or the underlying API endpoint is failing.
    - **Fix**: Debug the availability check, fix the API call, and add robust error handling.
2.  **Missing Audio Download Prompts**: Users are not prompted to stream or download when playing audio for a Surah not available offline.
    - **Fix**: Implement a dialog prompt within the audio playback logic when a download is required.
3.  **Hardcoded Strings**: Multiple screens contain hardcoded English strings, breaking i18n.
    - **Fix**: Move all user-facing strings to `.arb` files and use `AppLocalizations`.

**High (Major UX degradation)**
1.  **Background Text Download Unverified**: The initial download of Quran text is implemented but its success and resilience are unconfirmed.
    - **Fix**: Add logging and a hidden debug interface to monitor the download status. Ensure it retries on failure.
2.  **No Tafsir/Word-by-Word UI**: Data providers exist, but the UI to display tafsir and word-by-word analysis is missing from the reader.
    - **Fix**: Create toggleable panels or views in the reader screen to display this content.
3.  **Redundant Audio Controllers**: Two separate audio management systems (`QuranAudioService` and `QuranAudioController`) exist, causing confusion and potential bugs.
    - **Fix**: Refactor to use a single, unified audio service (`QuranAudioService` seems more feature-complete).

**Medium (Nice-to-have / Parity gaps)**
1.  **Missing Script Variants**: No UI to switch between Uthmanic and IndoPak scripts.
2.  **Basic Search Only**: Search does not support transliteration, fuzzy matching, or different languages effectively.
3.  **Incomplete Reading Plans**: The feature exists but is not fully implemented.
4.  **Monolithic Provider File**: `providers.dart` needs to be broken down into smaller, feature-specific files.

---

## 4) Implementation Plan

### Sprint A — Stabilize & Parity
- **Task 1: Fix Reciter Availability**:
    - **Files**: `lib/features/quran/presentation/state/providers.dart` (recitationsProvider), `lib/features/quran/domain/services/audio_service.dart`.
    - **Steps**:
        1.  Investigate `isReciterAvailable` in `QuranAudioService`.
        2.  Add logging to determine why it's failing.
        3.  Implement a robust fix with a fallback.
        4.  Add a unit test for the reciter availability logic.
- **Task 2: Implement Audio Download Policy**:
    - **Files**: `lib/features/quran/presentation/widgets/audio_player_widget.dart`, `lib/features/quran/domain/services/audio_service.dart`.
    - **Steps**:
        1.  Before playing audio, check if the Surah is downloaded.
        2.  If not, show a dialog with "Stream" and "Download" options.
        3.  Wire the dialog buttons to the appropriate functions in `QuranAudioService`.
        4.  Add a widget test for the prompt.
- **Task 3: Migrate All Quran Strings to ARB**:
    - **Files**: All files in `lib/features/quran/`, `lib/l10n/`.
    - **Steps**:
        1.  Run a regex search for hardcoded strings.
        2.  Add new keys to `app_en.arb` and `app_bn.arb`.
        3.  Replace hardcoded strings with `AppLocalizations.of(context)!.keyName`.
        4.  Regenerate localization files.
- **Task 4: Add Sajdah Markers**:
    - **Files**: `lib/features/quran/presentation/widgets/verse_card_widget.dart`, `lib/features/quran/data/dto/verse_dto.dart`.
    - **Steps**:
        1.  Ensure `verse_dto` has a `sajdah` field.
        2.  Use the existing `SajdahMarkerWidget` and display it conditionally in `VerseCardWidget`.
        3.  Verify styling against the app theme.

This completes the initial audit and planning phase. I will now proceed with creating the documentation files and then begin implementation of Sprint A.

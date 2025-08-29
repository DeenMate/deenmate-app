## Hadith Module – DeenMate Implementation Spec (Flutter/Riverpod/Hive/Dio)

Version: 0.1 (Draft)
Date: 2025-08-29

### 1) Context & Alignment with Current Project
- Framework: Flutter (Material 3)
- State: Riverpod (providers, notifiers)
- Routing: GoRouter (configured in `lib/core/navigation/shell_wrapper.dart`)
- Networking: Dio (`lib/core/net/dio_client.dart`)
- Persistence: Hive + SharedPreferences (`lib/core/storage/hive_boxes.dart`, feature states)
- Localization: Flutter l10n (ARB files in `lib/l10n/`, generated Dart in `lib/l10n/generated/`)
- Theming: Centralized theme + `ThemeHelper`
- Clean Architecture: `features/<name>/{data,domain,presentation}`

Constraints for Hadith:
- Use l10n (ARB) keys; no i18next.
- Reuse Dio client & retry interceptor.
- Cache offline using Hive. Prefer assets bootstrap under `assets/data/hadith/` for minimal offline.
- Keep providers Riverpod-first and react to language changes.

### 2) Goals & Scope (DeenMate)
- Collections (Phase 1): Bukhari, Muslim (EN + AR baseline; BN staged).
- Features: Browse by collection → book → chapter; search; bookmarking; share; offline read.
- Non-Goals (Phase 1): Commentary, user notes, audio.

#### Success Metrics (KPIs)
- P50 detail load time < 800ms (cached), < 1500ms (network)
- List first frame < 200ms with skeletons
- Crash rate < 0.5% on Hadith screens
- ≥ 25% of monthly active users use bookmarks within 30 days of launch

### 3) Data Sources & Licensing Strategy
- Primary Source Options:
  - Public JSON datasets with clear attribution for Bukhari/Muslim.
  - Staged local bootstrap: `assets/data/hadith/{bukhari,muslim}/index.json` for Book/Chapter lists; verse/hadith shards by folder.
- Remote API Abstraction:
  - Define `HadithRemoteDataSource` with pluggable endpoints (base URL configurable via `AppConfig`).
  - Attribute sources in UI and docs.
- Licensing: Store `source`, `license`, `translator` metadata per entry; render in details screen footer.

### 4) Directory & File Layout
```
lib/features/hadith/
  data/
    datasources/
      hadith_remote_datasource.dart
      hadith_local_datasource.dart
    repositories/
      hadith_repository_impl.dart
    models/
      hadith_dto.dart
      book_dto.dart
      chapter_dto.dart
  domain/
    entities/
      hadith.dart
      book.dart
      chapter.dart
    repositories/
      hadith_repository.dart
    usecases/
      get_collections.dart
      get_books.dart
      get_chapters.dart
      get_hadith_list.dart
      get_hadith_detail.dart
      search_hadith.dart
      toggle_bookmark.dart
  presentation/
    providers/
      hadith_providers.dart
    screens/
      hadith_home_screen.dart
      hadith_collection_screen.dart
      hadith_book_screen.dart
      hadith_chapter_screen.dart
      hadith_detail_screen.dart
    widgets/
      hadith_card.dart
      hadith_filters_sheet.dart
      hadith_bookmark_button.dart
```

Assets (optional bootstrap):
```
assets/data/hadith/
  bukhari/
    index.json           // books metadata
    chapters/{book}.json // chapter metadata
    items/{book}_{chapter}.json // hadith list
```

### 5) Data Model (DTOs → Entities)
- hadith_dto.dart
  - id (string), collection, bookNumber, chapterNumber
  - arabicText, translations[{lang, translator, text}]
  - grades[], reference, narrator, source, license, tags[]
- book_dto.dart: number, titles{en,ar,bn}, count
- chapter_dto.dart: number, titles{en,ar,bn}, count
- Mapping: DTO ↔ Entity via explicit mappers; null-safe with defaults.

### 6) Repository Contracts
`HadithRepository`:
- Future<List<String>> getCollections()
- Future<List<Book>> getBooks(String collection, {String lang})
- Future<List<Chapter>> getChapters(String collection, int book, {String lang})
- Future<List<Hadith>> getHadithList(String collection, int book, int chapter, {String lang, int page})
- Future<Hadith> getHadithDetail(String collection, String hadithId, {String lang})
- Future<List<Hadith>> search(String query, {String? collection, String lang, int page})
- Future<void> toggleBookmark(Hadith hadith)
- Stream<Set<String>> bookmarks()

Implementation notes:
- Remote-first with local fallback; cache hydrated pages in Hive (box per collection).
- Keep search simple (client-side over fetched page) in Phase 1; add remote search if backend available.

### 7) Riverpod Providers
- `hadithRepositoryProvider` → repository impl
- `hadithCollectionsProvider` → List<String>
- `hadithBooksProvider(collection, lang)` → AsyncValue<List<Book>>
- `hadithChaptersProvider(collection, book, lang)` → AsyncValue<List<Chapter>>
- `hadithListProvider(collection, book, chapter, lang, page)` → AsyncValue<List<Hadith>>
- `hadithDetailProvider(collection, id, lang)` → AsyncValue<Hadith>
- `hadithSearchProvider(query, collection, lang, page)` → AsyncValue<List<Hadith>>
- `hadithBookmarksProvider` → StreamProvider<Set<String>> (Hive-backed)
- Language reactivity: derive `lang` from current l10n (`AppLocalizations`) or from a `languagePreferencesProvider` selector.

### 8) Caching & Offline
- Hive boxes:
  - `hadith_cache_<collection>`: keyed by path (e.g., `list:bukhari:78:5:en:1`), TTL 7 days.
  - `hadith_bookmarks`: set of hadith ids.
- Preload strategy: small bootstrap assets for TOC to enable offline browsing of structure; lazy-load hadith pages when online.

### 9) Networking
- Use `DioClient` from `lib/core/net/dio_client.dart` (inherits interceptors/retry).
- API endpoints configurable via `AppConfig`.
- Graceful error mapping to `Failure` types (reuse `lib/core/error`).

### 10) Routing (GoRouter)
- Add routes in `shell_wrapper.dart`:
  - `/hadith` → `HadithHomeScreen`
  - `/hadith/:collection` → `HadithCollectionScreen`
  - `/hadith/:collection/book/:book` → `HadithBookScreen`
  - `/hadith/:collection/book/:book/chapter/:chapter` → `HadithChapterScreen`
  - `/hadith/:collection/item/:id` → `HadithDetailScreen`

### 11) UI/UX
- List → Book → Chapter → Hadith Detail flow.
- Detail layout:
  - Arabic (RTL, large Arabic font from app fonts) → divider → translation → meta (grade, ref, narrator, source/translator)
  - Actions: bookmark, share, copy; floating sheet for filters.
- Respect theme and text scaling; no hardcoded colors; use `Theme.of(context)`.

### 12) Localization (l10n)
- ARB location: `lib/l10n/intl_en.arb`, `lib/l10n/intl_bn.arb`, `lib/l10n/intl_ar.arb`, etc.
- Add ARB keys (samples):
  - hadithTitle, hadithCollections, hadithSearchPlaceholder
  - hadithBook, hadithChapter, hadithReference, hadithNarrator, hadithGrade
  - hadithSourceAttribution, hadithTranslator
  - hadithBookmarksTitle, hadithNoResults
- Generate via `flutter gen-l10n`; generated files in `lib/l10n/generated/`; reference with `AppLocalizations`.
- RTL support: set `textDirection` for Arabic blocks and ensure proper alignment.

### 13) Testing Plan
- Unit:
  - DTO ↔ Entity mapping
  - Repository behaviors (remote success/failure, cache fallback)
- Widget:
  - Hadith list renders items; detail renders Arabic + translation; bookmark toggle
  - RTL rendering checks for Arabic
- Integration:
  - Navigation across routes; search flow; offline fallback using mocked datasources

### 14) Phased Delivery
- Phase 1 (2–3 weeks):
  - Collections: Bukhari, Muslim
  - EN + AR
  - Browse + detail + bookmarks + basic search
  - Hive cache + bootstrap assets
- Phase 2:
  - Add 4 more collections; BN translations where available
  - Enhanced search; filters (grade, narrator)
- Phase 3:
  - Advanced search, notes (local-only), export/share packs

### 15) Open Questions / Risks
- Dataset licensing per translator and redistribution terms
- Translation coverage for BN/UR in Phase 1
- Backend availability for server-side search (optional)

### 15.1) Functional Requirements (FR)
- Browse collections with counts and localized titles
- Navigate book → chapter → hadith; preserve scroll position per route
- Hadith detail: Arabic (RTL, Arabic font), translation, metadata (reference, grade, narrator), attribution (source + translator)
- Language switching reflects immediately across list/detail
- Search by text (+ optional collection filter); client-side on fetched sets (Phase 1)
- Bookmark/unbookmark; bookmarks view; persisted in Hive
- Offline-first: cached reads when offline; hydrate when online
- Share content (text + reference + attribution)
- Localized empty/error states; retry actions

### 15.2) Non-Functional Requirements (NFR)
- Reliability: cached reads must work without network
- Performance: list skeleton < 200ms; detail P50 < 800ms cached
- Accessibility: semantic labels, scalable typography, contrast, SR-friendly
- Security: HTTPS, read-only API; sanitize inputs; no PII stored
- Localization: all strings in ARB; RTL correct for AR/UR; Arabic fonts from app bundle
- Offline: cache TTL 7 days; eviction policy; versioned keys
- Telemetry: screen views, search, bookmark, share (non-PII)

### 16) Implementation Checklist
- Data layer: DTOs, datasources, repository impl
- Domain: entities + usecases
- Presentation: providers + screens + widgets
- Hive boxes + migrations (keys/versioning)
- Routes in `shell_wrapper.dart`
- l10n keys added to ARB and generated
- Tests: unit/widget/integration

### 17) Security, Compliance, Attribution
- HTTPS only; sanitize query inputs; validate payloads
- Display source and translator attribution in detail and share
- Preserve licenses in metadata; maintain sources registry in docs

### 18) Telemetry & Analytics (non‑PII)
- Events: `HadithViewed`, `HadithSearched`, `HadithBookmarked`, `HadithShared`
- Context: collection, book/chapter, lang (no user identifiers)

### 19) Acceptance Criteria
- Can browse Bukhari/Muslim hierarchy and open hadith detail
- Arabic + English displayed correctly; RTL applied for Arabic content
- Search returns relevant results for current language
- Bookmarks persist and are listed; actions reflected instantly
- Offline: previously opened lists and details render without network
- Source/translator attribution visible on detail and in shared text



# Documentation Merge Mapping

**Created**: September 1, 2025  
**Last Updated**: September 1, 2025  
**Purpose**: Track mapping of original documentation files to their merged locations in PROJECT_CONTEXT.md and PROJECT_STATUS.md

---

## 📋 File Mapping Summary

| Original File | Destination | Section/Task IDs | Status |
|---------------|-------------|------------------|--------|
| `README.md` | PROJECT_CONTEXT.md | Architecture & Tech, Module Specifications | ✅ Merged |
| `PROJECT_TRACKING.md` | PROJECT_STATUS.md | Sprint Board, Active Sprint, Resolved vs In-Progress | ✅ Merged |
| `TODO.md` | PROJECT_STATUS.md | Sprint Board, Blocked Items, Roadmap | ✅ Merged |
| `SRS.md` | PROJECT_CONTEXT.md | Architecture & Tech, Module Specifications | ✅ Merged |
| `CHANGELOG.md` | PROJECT_STATUS.md | Change Log, Version History | ✅ Merged |
| `technical/ARCHITECTURE.md` | PROJECT_CONTEXT.md | Architecture & Tech, High-Level Architecture | ✅ Merged |
| `technical/TECHNICAL_SPECIFICATIONS.md` | PROJECT_CONTEXT.md | Module Specifications, Tech Stack | ✅ Merged |
| `technical/API_STRATEGIES.md` | PROJECT_CONTEXT.md | APIs & Integration, API Matrix | ✅ Merged |
| `technical/API_REFERENCE.md` | PROJECT_CONTEXT.md | APIs & Integration, API Matrix | ✅ Merged |
| `technical/INTEGRATION_GUIDE.md` | PROJECT_CONTEXT.md | Architecture & Tech, Integration Patterns | ✅ Merged |
| `quran-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Quran) | ✅ Merged |
| `quran-module/project-tracking.md` | PROJECT_STATUS.md | Sprint Board (QURAN-001 to QURAN-006) | ✅ Merged |
| `quran-module/todo-quran.md` | PROJECT_STATUS.md | Sprint Board, Blocked Items | ✅ Merged |
| `hadith-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Hadith) | ✅ Merged |
| `hadith-module/project-tracking.md` | PROJECT_STATUS.md | Sprint Board (HADITH-001 to HADITH-004) | ✅ Merged |
| `zakat-calculator-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Zakat) | ✅ Merged |
| `zakat-calculator-module/project-tracking.md` | PROJECT_STATUS.md | Sprint Board (ZAKAT-001 to ZAKAT-004) | ✅ Merged |
| `inheritance-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Inheritance) | ✅ Merged |
| `inheritance-module/project-tracking.md` | PROJECT_STATUS.md | Sprint Board (INHERIT-001 to INHERIT-004) | ✅ Merged |
| `home-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Home) | ✅ Merged |
| `settings-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Settings) | ✅ Merged |
| `onboarding-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Onboarding) | ✅ Merged |
| `islamic-content-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Islamic Content) | ✅ Merged |
| `prayer-times-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Prayer Times) | ✅ Merged |
| `qibla-module/README.md` | PROJECT_CONTEXT.md | Module Specifications (Qibla) | ✅ Merged |
| `technical/ISLAMIC_COMPLIANCE.md` | PROJECT_CONTEXT.md | Legal & Licensing, Islamic Standards | ✅ Merged |
| `technical/features/README.md` | PROJECT_CONTEXT.md | Module Specifications, Feature Details | ✅ Merged |
| `technical/features/inheritance_calculator.md` | PROJECT_CONTEXT.md | Module Specifications (Inheritance) | ✅ Merged |
| `technical/features/qibla_compass.md` | PROJECT_CONTEXT.md | Module Specifications (Qibla) | ✅ Merged |
| `technical/features/multi_language.md` | PROJECT_CONTEXT.md | Design & UI Guidelines, Localization | ✅ Merged |
| `technical/features/prayer_times.md` | PROJECT_CONTEXT.md | Module Specifications (Prayer Times) | ✅ Merged |
| `quran-module/api-strategy.md` | PROJECT_CONTEXT.md | APIs & Integration, Quran API Details | ✅ Merged |
| `quran-module/sprint-a-completion.md` | PROJECT_STATUS.md | Sprint Board, Completed Tasks | ✅ Merged |
| `developers_guide.md` | PROJECT_CONTEXT.md | Architecture & Tech, Tech Stack | ✅ Merged |
| `DOCUMENTATION_AUDIT_REPORT.md` | PROJECT_STATUS.md | Critical Gaps, Implementation Status | ✅ Merged |
| `HADITH_API_SETUP.md` | PROJECT_CONTEXT.md | APIs & Integration, API Setup | ✅ Merged |

---

## 📊 Content Distribution

### PROJECT_CONTEXT.md Sections
- **Architecture & Tech**: From ARCHITECTURE.md, TECHNICAL_SPECIFICATIONS.md, INTEGRATION_GUIDE.md, developers_guide.md
- **Database / Schema**: From ARCHITECTURE.md, TECHNICAL_SPECIFICATIONS.md
- **APIs & Integration**: From API_STRATEGIES.md, API_REFERENCE.md
- **Sync Strategy & Schedules**: From ARCHITECTURE.md, API_STRATEGIES.md
- **Module Specifications**: From all module README.md files
- **Design & UI Guidelines**: From TECHNICAL_SPECIFICATIONS.md, developers_guide.md
- **Legal & Licensing**: From README.md, SRS.md
- **Observability & Security**: From ARCHITECTURE.md, TECHNICAL_SPECIFICATIONS.md
- **Important Invariants**: From ARCHITECTURE.md, SRS.md

### PROJECT_STATUS.md Sections
- **Sprint Board**: From PROJECT_TRACKING.md, TODO.md, all module project-tracking.md files
- **Active Sprint / Current Focus**: From PROJECT_TRACKING.md
- **Resolved vs In-Progress vs Blocked**: From PROJECT_TRACKING.md, TODO.md
- **Blocked Items & Blockers Log**: From all module project-tracking.md files
- **Risks & Mitigations**: From PROJECT_TRACKING.md, module project-tracking.md files
- **Upcoming Roadmap**: From PROJECT_TRACKING.md, TODO.md
- **Metrics & Acceptance Criteria**: From PROJECT_TRACKING.md, module project-tracking.md files
- **Pending Docs / Missing Data**: From PROJECT_TRACKING.md, TODO.md
- **Change Log**: From CHANGELOG.md

---

## 🎯 Task ID Mapping

### Quran Module Tasks
- **QURAN-001**: Fix Reciter Availability Bug (from quran-module/project-tracking.md)
- **QURAN-002**: Implement Audio Download Policy (from quran-module/project-tracking.md)
- **QURAN-003**: Migrate All Quran Strings to ARB (from quran-module/project-tracking.md)
- **QURAN-004**: Add Sajdah Markers (from quran-module/todo-quran.md)
- **QURAN-005**: Script Variants (from quran-module/todo-quran.md)
- **QURAN-006**: Enhanced Search (from quran-module/todo-quran.md)
- **QURAN-007**: Background Text Download (from quran-module/sprint-a-completion.md)
- **QURAN-008**: Audio Service Integration (from quran-module/sprint-a-completion.md)

### Hadith Module Tasks
- **HADITH-001**: API Integration (from hadith-module/project-tracking.md)
- **HADITH-002**: Advanced UI Screens (from hadith-module/project-tracking.md)
- **HADITH-003**: Bengali-First Interface (from hadith-module/project-tracking.md)
- **HADITH-004**: Testing & Quality Assurance (from hadith-module/project-tracking.md)
- **HADITH-005**: Mock Data System (from hadith-module/README.md)
- **HADITH-006**: Search Framework (from hadith-module/README.md)
- **HADITH-007**: Bookmarking System (from hadith-module/README.md)

### Prayer Times Module Tasks
- **PRAYER-001**: Core Calculation Engine (from prayer-times-module/README.md)
- **PRAYER-002**: Location Services (from prayer-times-module/README.md)
- **PRAYER-003**: Notification System (from prayer-times-module/README.md)
- **PRAYER-004**: Multiple Calculation Methods (from prayer-times-module/README.md)
- **PRAYER-005**: Offline Support (from prayer-times-module/README.md)

### Qibla Module Tasks
- **QIBLA-001**: Compass Integration (from qibla-module/README.md)
- **QIBLA-002**: GPS Integration (from qibla-module/README.md)
- **QIBLA-003**: Calibration Tools (from qibla-module/README.md)
- **QIBLA-004**: Educational Content (from qibla-module/README.md)

### Zakat Module Tasks
- **ZAKAT-001**: Create Module Architecture (from zakat-calculator-module/project-tracking.md)
- **ZAKAT-002**: Islamic Calculation Engine (from zakat-calculator-module/project-tracking.md)
- **ZAKAT-003**: Asset Input Interface (from zakat-calculator-module/project-tracking.md)
- **ZAKAT-004**: Live Price Integration (from zakat-calculator-module/project-tracking.md)
- **ZAKAT-005**: Multiple Madhab Support (from zakat-calculator-module/README.md)
- **ZAKAT-006**: Educational Content (from zakat-calculator-module/README.md)
- **ZAKAT-007**: History Tracking (from zakat-calculator-module/README.md)

### Inheritance Module Tasks
- **INHERIT-001**: Islamic Law Engine (from inheritance-module/project-tracking.md)
- **INHERIT-002**: Family Relationship Models (from inheritance-module/project-tracking.md)
- **INHERIT-003**: Multiple Schools Support (from inheritance-module/project-tracking.md)
- **INHERIT-004**: Complex Scenarios (from inheritance-module/project-tracking.md)
- **INHERIT-005**: Visual Family Tree (from inheritance-module/README.md)
- **INHERIT-006**: Educational Content (from inheritance-module/README.md)
- **INHERIT-007**: History Tracking (from inheritance-module/README.md)

### Home Module Tasks
- **HOME-001**: Dashboard Implementation (from home-module/README.md)
- **HOME-002**: Quick Actions (from home-module/README.md)
- **HOME-003**: Islamic Calendar Integration (from home-module/README.md)
- **HOME-004**: Daily Content Display (from home-module/README.md)

### Onboarding Module Tasks
- **ONBOARD-001**: 8-Step Flow (from onboarding-module/README.md)
- **ONBOARD-002**: Language Selection (from onboarding-module/README.md)
- **ONBOARD-003**: Location Setup (from onboarding-module/README.md)
- **ONBOARD-004**: Islamic Preferences (from onboarding-module/README.md)
- **ONBOARD-005**: Data Transfer (from onboarding-module/README.md)

### Settings Module Tasks
- **SETTINGS-001**: App Settings (from settings-module/README.md)
- **SETTINGS-002**: Accessibility Settings (from settings-module/README.md)
- **SETTINGS-003**: Theme Management (from settings-module/README.md)
- **SETTINGS-004**: Preference Persistence (from settings-module/README.md)

### Islamic Content Module Tasks
- **ISLAMIC-001**: Daily Content System (from islamic-content-module/README.md)
- **ISLAMIC-002**: Content Management (from islamic-content-module/README.md)
- **ISLAMIC-003**: Educational Materials (from islamic-content-module/README.md)

### Localization Tasks
- **LOCAL-001**: Migrate Legacy Translations (from PROJECT_TRACKING.md, TODO.md)
- **LOCAL-002**: Fix Hardcoded Strings (from PROJECT_TRACKING.md, TODO.md)
- **LOCAL-003**: RTL Support Enhancement (from PROJECT_TRACKING.md)
- **LOCAL-004**: Arabic Translation (from technical/features/multi_language.md)
- **LOCAL-005**: Urdu Translation (from technical/features/multi_language.md)

---

## 🔍 Verification Notes

### Completeness Check
- ✅ All 35+ documentation files accounted for
- ✅ All task entries converted to PROJECT_STATUS.md Sprint Board
- ✅ All module specifications consolidated in PROJECT_CONTEXT.md
- ✅ All API information consolidated in PROJECT_CONTEXT.md
- ✅ All project tracking information consolidated in PROJECT_STATUS.md
- ✅ Additional technical details and implementation guidelines added
- ✅ Enhanced Islamic compliance and development standards included

### Content Preservation
- ✅ All critical technical information preserved
- ✅ All task priorities and statuses maintained
- ✅ All module implementation statuses accurately reflected
- ✅ All Islamic compliance requirements documented
- ✅ All API dependencies and integration patterns preserved

### Quality Assurance
- ✅ No duplicate information in final documents
- ✅ Consistent module naming conventions applied
- ✅ All task IDs properly assigned and tracked
- ✅ All critical gaps and blockers identified
- ✅ All performance metrics and acceptance criteria included

---

## 📚 Archived Files Reference

All original documentation files are preserved in `docs_archive/` with the following structure:
```
docs_archive/
├── README.md
├── PROJECT_TRACKING.md
├── TODO.md
├── SRS.md
├── CHANGELOG.md
├── technical/
│   ├── ARCHITECTURE.md
│   ├── TECHNICAL_SPECIFICATIONS.md
│   ├── API_STRATEGIES.md
│   ├── API_REFERENCE.md
│   └── INTEGRATION_GUIDE.md
├── quran-module/
│   ├── README.md
│   ├── project-tracking.md
│   └── todo-quran.md
├── hadith-module/
│   ├── README.md
│   └── project-tracking.md
├── zakat-calculator-module/
│   ├── README.md
│   └── project-tracking.md
├── inheritance-module/
│   ├── README.md
│   └── project-tracking.md
├── developers_guide.md
└── MAPPING.md (this file)
```

---

*This mapping file ensures complete traceability of all documentation consolidation work and provides a reference for locating specific information in the original files.*
# docs -> merge mapping

## File-to-Section Mapping

This document maps each original docs/ file to its corresponding sections in the canonical PROJECT_CONTEXT.md and PROJECT_STATUS.md files.

### Core Documentation Files

**docs/README.md** -> PROJECT_CONTEXT.md: Overview section; PROJECT_STATUS.md: Module status summary
**docs/PROJECT_TRACKING.md** -> PROJECT_STATUS.md: Sprint board, task backlog, module status summary, progress analytics
**docs/SRS.md** -> PROJECT_CONTEXT.md: Tech stack & versions, architecture overview, modules specifications
**docs/TODO.md** -> PROJECT_STATUS.md: Sprint board tasks, backlog items, current priorities
**docs/CHANGELOG.md** -> PROJECT_STATUS.md: Revision log section
**docs/developers_guide.md** -> PROJECT_CONTEXT.md: Tech stack details, development workflow

### Technical Documentation

**docs/technical/ARCHITECTURE.md** -> PROJECT_CONTEXT.md: High-level architecture diagram, system design principles
**docs/technical/TECHNICAL_SPECIFICATIONS.md** -> PROJECT_CONTEXT.md: Modules overview section (individual module specs)
**docs/technical/API_STRATEGIES.md** -> PROJECT_CONTEXT.md: API matrix section
**docs/technical/API_REFERENCE.md** -> PROJECT_CONTEXT.md: API matrix details, authentication
**docs/technical/ISLAMIC_COMPLIANCE.md** -> PROJECT_CONTEXT.md: Security & compliance section
**docs/technical/INTEGRATION_GUIDE.md** -> PROJECT_CONTEXT.md: API integration details

### Module Documentation

**docs/quran-module/README.md** -> PROJECT_CONTEXT.md: Quran module overview
**docs/quran-module/project-tracking.md** -> PROJECT_STATUS.md: QURAN tasks and status
**docs/quran-module/todo-quran.md** -> PROJECT_STATUS.md: Sprint board QURAN items
**docs/quran-module/api-strategy.md** -> PROJECT_CONTEXT.md: API matrix Quran entries
**docs/quran-module/sprint-a-completion.md** -> PROJECT_STATUS.md: Completed sprint tracking
**docs/quran-module/backlog.json** -> PROJECT_STATUS.md: Backlog items

**docs/hadith-module/README.md** -> PROJECT_CONTEXT.md: Hadith module overview
**docs/hadith-module/project-tracking.md** -> PROJECT_STATUS.md: HADITH tasks and status

**docs/prayer-times-module/README.md** -> PROJECT_CONTEXT.md: Prayer Times module overview

**docs/zakat-calculator-module/README.md** -> PROJECT_CONTEXT.md: Zakat module overview
**docs/zakat-calculator-module/project-tracking.md** -> PROJECT_STATUS.md: ZAKAT critical gap analysis

**docs/inheritance-module/README.md** -> PROJECT_CONTEXT.md: Inheritance module overview
**docs/inheritance-module/project-tracking.md** -> PROJECT_STATUS.md: INHERIT critical gap analysis

**docs/home-module/README.md** -> PROJECT_CONTEXT.md: Home module overview
**docs/qibla-module/README.md** -> PROJECT_CONTEXT.md: Qibla module overview
**docs/settings-module/README.md** -> PROJECT_CONTEXT.md: Settings module overview
**docs/onboarding-module/README.md** -> PROJECT_CONTEXT.md: Onboarding module overview
**docs/islamic-content-module/README.md** -> PROJECT_CONTEXT.md: Islamic Content module overview

### Specialized Documentation

**docs/HADITH_API_SETUP.md** -> PROJECT_CONTEXT.md: API matrix Hadith section; PROJECT_STATUS.md: API key blockers
**docs/DOCUMENTATION_AUDIT_REPORT.md** -> PROJECT_STATUS.md: Revision log, verification results

### Resource Files

**docs/resources/** -> Referenced as supporting documentation in PROJECT_CONTEXT.md Appendix

## Summary

- **Total files processed**: 41 files from docs/ directory
- **PROJECT_CONTEXT.md sections**: 15 major sections populated
- **PROJECT_STATUS.md sections**: 11 major sections populated
- **Critical findings**: 2 modules requiring complete rebuilds identified and documented
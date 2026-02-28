# PROJECT_CONTEXT.md
Last updated: 2025-09-24
Version: merged-docs-1
Summary: Single-source project context compiled from docs/ directory (archived in docs_archive/)

---

## Overview

DeenMate is a comprehensive Islamic companion app built with Flutter 3.x, following Clean Architecture principles. The application provides essential Islamic services including prayer times, Quran reading with audio, Qibla direction, Zakat calculation, and Hadith collections. The app emphasizes offline-first functionality, multi-language support (English, Bengali, Arabic, Urdu), and strict Islamic compliance.

**Project Status**: 78% Complete (171/220 story points)
**Critical Issues**: 2 modules require complete rebuild (Zakat P0, Inheritance P1)
**Success Stories**: Quran (exemplary) and Prayer Times (production ready)

---

## Tech Stack & Versions

### Core Framework
- **Framework**: Flutter 3.x
- **Language**: Dart 3.x
- **UI**: Material 3 with Islamic customization
- **Minimum SDK**: Flutter 3.10.0, Dart 3.0.0

### State Management & Architecture
- **Architecture**: Clean Architecture (Domain/Data/Presentation)
- **State Management**: Riverpod 2.x + Provider pattern
- **Navigation**: GoRouter (type-safe routing)
- **Dependency Injection**: Riverpod providers

### Storage & Networking
- **Local Storage**: Hive (NoSQL) + SharedPreferences
- **HTTP Client**: Dio with interceptors and retry logic
- **Caching Strategy**: LRU cache + offline-first approach
- **Database**: Hive for verses, prayer times, settings

### Platform-Specific
- **Notifications**: flutter_local_notifications
- **Location**: Geolocator + Geocoding
- **Audio**: AudioPlayers with download management
- **Sensors**: Flutter Compass for Qibla
- **PDF Generation**: PDF package for reports
- **Fonts**: Uthmanic Hafs, Amiri, Noto Sans Arabic/Bengali

---

## High-Level Architecture Diagram (textual)

```
┌─────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│  │   Quran     │ │ Prayer Times│ │    Zakat    │ │  More   │ │
│  │   Module    │ │   Module    │ │   Module    │ │ Modules │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────────────────────┘
                           │
┌─────────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│  │  Use Cases  │ │  Entities   │ │ Repositories│ │Services │ │
│  │             │ │             │ │ (Abstract)  │ │         │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────────────────────┘
                           │
┌─────────────────────────────────────────────────────────────┐
│                      DATA LAYER                             │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────┐ │
│  │ Repositories│ │ Data Sources│ │ Local Cache │ │ External│ │
│  │(Concrete)   │ │             │ │   (Hive)    │ │   APIs  │ │
│  └─────────────┘ └─────────────┘ └─────────────┘ └─────────┘ │
└─────────────────────────────────────────────────────────────┘
```

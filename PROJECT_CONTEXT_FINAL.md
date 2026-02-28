# PROJECT_CONTEXT.md
Last updated: 2025-09-24  
Complete documentation merge from docs/ directory

## Overview

DeenMate is a comprehensive Islamic companion app built with Flutter 3.x, following Clean Architecture principles. The app provides essential Islamic services including prayer times, Quran reading with audio, Qibla direction, Zakat calculation, and Hadith collections.

**Project Status**: 78% Complete (171/220 story points)  
**Critical Issues**: 2 modules require complete rebuild (Zakat P0, Inheritance P1)  
**Success Stories**: Quran (exemplary, 95%, 81 files), Prayer Times (90%), Hadith (95%, 32 files)

## Module Status Summary

### 🟢 Exemplary Implementation: Quran Module
- **Status**: 95% Complete (81 files, 33.8k+ lines)
- **Architecture**: Clean Architecture properly implemented
- **Features**: Complete Quran text, 20+ translations, audio, search, bookmarks
- **Recent**: Sprint A completed (reciter bug fixed, EN/BN localization, background download)
- **API**: Quran.com API v4 with robust caching

### 🟢 Production Ready: Prayer Times Module  
- **Status**: 90% Complete (56 files)
- **Features**: Accurate prayer calculations, Athan notifications, Qibla direction
- **API**: AlAdhan API with local calculation fallback

### 🟢 Feature Complete: Hadith Module
- **Status**: 95% Complete (32 files)
- **Features**: Bengali-first interface, 7 major collections, search, bookmarks
- **API**: Sunnah.com API ready, comprehensive mock data

### 🔴 Critical Gap: Zakat Module
- **Status**: 5% Complete - COMPLETE REBUILD REQUIRED
- **Reality**: Only single screen file (745 lines) in home module
- **Missing**: Dedicated module structure, Islamic calculation engine, Clean Architecture
- **Priority**: P0 - Critical business feature

### 🔴 Critical Gap: Inheritance Module  
- **Status**: 5% Complete - COMPLETE DEVELOPMENT REQUIRED
- **Reality**: Only 4 placeholder presentation files
- **Missing**: Islamic law engine, calculation algorithms, domain logic
- **Priority**: P1 - Important Islamic legal tool

## API Integration Matrix

| Service | Module | URL | Status | Cache TTL |
|---------|--------|-----|--------|-----------|
| Quran.com API v4 | Quran | api.quran.com/api/v4 | ✅ Active | 24h-7d |
| AlAdhan API | Prayer | api.aladhan.com/v1 | ✅ Active | 24h |
| Sunnah.com API | Hadith | api.sunnah.com/v1 | ✅ Ready | 7d |
| Metals API | Zakat | ❌ Missing | ❌ Required | 1h |

## Islamic Compliance Standards

- **Verified Quran Text**: From King Fahd Complex
- **Authenticated Hadith**: Sahih Bukhari, Muslim collections  
- **Prayer Accuracy**: ±2 minute tolerance
- **Scholar Review**: Required for Zakat/Inheritance calculations

## Documentation Migration

All original docs preserved in `docs_archive/`:
- **Module Documentation**: 41 files across 9 modules
- **Technical Specs**: Architecture, API strategies, Islamic compliance
- **Project Tracking**: Sprint boards, TODO items, progress metrics

**Critical Finding**: Documentation claimed 95% completion but implementation audit reveals major gaps requiring complete rebuilds for 2 critical modules.

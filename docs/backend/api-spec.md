# DeenMate Backend API Layer - API Specification

**Date**: September 3, 2025  
**Version**: v1.0  
**Base URL**: `https://api.deenmate.app/v1`  
**Purpose**: REST API specification for DeenMate mobile app  

---

## Executive Summary

This document defines the REST API endpoints for the DeenMate backend service. The API is designed to replace direct third-party API calls from the mobile app with a unified, cached, and optimized backend service. All endpoints return JSON and follow REST conventions.

---

## 1. API Overview

### 1.1 Base Configuration

```yaml
openapi: 3.0.3
info:
  title: DeenMate API
  version: 1.0.0
  description: Islamic content API for DeenMate mobile application
servers:
  - url: https://api.deenmate.app/v1
    description: Production server
  - url: https://staging-api.deenmate.app/v1
    description: Staging server
```

### 1.2 Authentication

**API Key Authentication**:
```http
Authorization: Bearer <api_key>
X-API-Key: <api_key>
```

**Anonymous Access**:
- Most read endpoints are publicly accessible
- Rate limiting applies to anonymous users
- Enhanced features require authentication

### 1.3 Common Response Format

```json
{
  "success": true,
  "data": { /* response data */ },
  "meta": {
    "timestamp": "2025-09-03T10:30:00Z",
    "version": "1.0.0",
    "request_id": "req_123456"
  },
  "pagination": { /* if applicable */ }
}
```

**Error Response Format**:
```json
{
  "success": false,
  "error": {
    "code": "INVALID_REQUEST",
    "message": "Invalid chapter number. Must be between 1 and 114.",
    "details": {
      "field": "chapter_id",
      "value": "115"
    }
  },
  "meta": {
    "timestamp": "2025-09-03T10:30:00Z",
    "request_id": "req_123456"
  }
}
```

---

## 2. Quran API Endpoints

### 2.1 Get Quran Chapters

**Endpoint**: `GET /quran/chapters`

**Description**: Retrieve list of all Quran chapters with metadata

**Parameters**: None

**Response**:
```json
{
  "success": true,
  "data": {
    "chapters": [
      {
        "id": 1,
        "chapter_number": 1,
        "name_arabic": "الفاتحة",
        "name_english": "Al-Fatihah",
        "name_bangla": "আল-ফাতিহা",
        "revelation_place": "mecca",
        "verse_count": 7,
        "bismillah_pre": true
      }
    ]
  },
  "meta": {
    "total_chapters": 114,
    "cache_ttl": 86400
  }
}
```

**Caching**: 24 hours  
**Rate Limit**: 100/hour for anonymous, 1000/hour for authenticated

---

### 2.2 Get Chapter Verses

**Endpoint**: `GET /quran/chapters/{chapter_id}/verses`

**Description**: Retrieve verses for a specific chapter with translations

**Parameters**:
- `chapter_id` (path, required): Chapter number (1-114)
- `translations` (query, optional): Comma-separated translation IDs (e.g., "131,84")
- `reciter` (query, optional): Reciter ID for audio URLs
- `page` (query, optional): Page number for pagination (default: 1)
- `per_page` (query, optional): Items per page (default: 50, max: 100)

**Example Request**:
```http
GET /quran/chapters/1/verses?translations=131,84&reciter=7&page=1&per_page=10
```

**Response**:
```json
{
  "success": true,
  "data": {
    "chapter": {
      "id": 1,
      "name_english": "Al-Fatihah",
      "verse_count": 7
    },
    "verses": [
      {
        "id": 1,
        "verse_number": 1,
        "verse_key": "1:1",
        "text_uthmani": "بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ",
        "translations": [
          {
            "id": 131,
            "text": "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
            "language": "english",
            "author": "Saheeh International"
          },
          {
            "id": 84,
            "text": "নামে আল্লাহর যিনি পরম করুণাময়, অতি দয়ালু।",
            "language": "bangla",
            "author": "Taisirul Quran"
          }
        ],
        "audio": {
          "url": "https://cdn.deenmate.app/audio/7/1_1.mp3",
          "duration": 3500
        },
        "meta": {
          "juz_number": 1,
          "hizb_number": 1,
          "page_number": 1
        }
      }
    ]
  },
  "pagination": {
    "current_page": 1,
    "per_page": 10,
    "total_pages": 1,
    "total_verses": 7
  }
}
```

**Caching**: 1 hour  
**Rate Limit**: 50/hour for anonymous, 500/hour for authenticated

---

### 2.3 Get Translation Resources

**Endpoint**: `GET /quran/translations`

**Description**: Get available translation resources

**Parameters**:
- `language` (query, optional): Filter by language code (e.g., "en", "bn", "ar")

**Response**:
```json
{
  "success": true,
  "data": {
    "translations": [
      {
        "id": 131,
        "name": "Saheeh International",
        "author": "Saheeh International",
        "language_code": "en",
        "language_name": "English",
        "direction": "ltr"
      },
      {
        "id": 84,
        "name": "Taisirul Quran",
        "author": "Taisirul Quran Board",
        "language_code": "bn",
        "language_name": "Bengali",
        "direction": "ltr"
      }
    ]
  }
}
```

---

### 2.4 Get Reciters

**Endpoint**: `GET /quran/reciters`

**Description**: Get available Quran reciters for audio

**Response**:
```json
{
  "success": true,
  "data": {
    "reciters": [
      {
        "id": 7,
        "name": "Mishari Rashid al-Afasy",
        "english_name": "Mishari Rashid al-Afasy",
        "style": "Murattal",
        "qirat": "Hafs"
      }
    ]
  }
}
```

---

### 2.5 Search Quran

**Endpoint**: `GET /quran/search`

**Description**: Full-text search across Quran translations

**Parameters**:
- `q` (query, required): Search query
- `language` (query, optional): Language to search in (default: "english")
- `translation` (query, optional): Specific translation ID to search
- `page` (query, optional): Page number (default: 1)
- `per_page` (query, optional): Results per page (default: 20, max: 50)

**Example Request**:
```http
GET /quran/search?q=mercy&language=english&page=1&per_page=10
```

**Response**:
```json
{
  "success": true,
  "data": {
    "results": [
      {
        "verse_key": "1:1",
        "chapter_name": "Al-Fatihah",
        "verse_number": 1,
        "text": "In the name of Allah, the Entirely Merciful, the Especially Merciful.",
        "highlight": "In the name of Allah, the Entirely <mark>Merciful</mark>, the Especially <mark>Merciful</mark>.",
        "relevance_score": 0.95
      }
    ]
  },
  "pagination": {
    "current_page": 1,
    "total_results": 114,
    "total_pages": 12
  }
}
```

---

## 3. Prayer Times API Endpoints

### 3.1 Get Prayer Times

**Endpoint**: `GET /prayer/times`

**Description**: Get prayer times for specific location and date

**Parameters**:
- `latitude` (query, required): Latitude (-90 to 90)
- `longitude` (query, required): Longitude (-180 to 180)
- `date` (query, optional): Date in YYYY-MM-DD format (default: today)
- `method` (query, optional): Calculation method ID (default: 2 - ISNA)
- `timezone` (query, optional): IANA timezone (auto-detected if not provided)
- `madhab` (query, optional): Madhab for Asr calculation (1=Hanafi, 0=Standard)

**Example Request**:
```http
GET /prayer/times?latitude=40.7128&longitude=-74.0060&date=2025-09-03&method=2
```

**Response**:
```json
{
  "success": true,
  "data": {
    "location": {
      "latitude": 40.7128,
      "longitude": -74.0060,
      "city": "New York",
      "country": "United States",
      "timezone": "America/New_York"
    },
    "date": {
      "gregorian": "2025-09-03",
      "hijri": {
        "date": "12-03-1447",
        "month": "Rabi' al-thani",
        "year": 1447
      }
    },
    "times": {
      "fajr": "05:18",
      "sunrise": "06:32",
      "dhuhr": "12:54",
      "asr": "16:24",
      "maghrib": "19:16",
      "isha": "20:37"
    },
    "qibla_direction": 58.48,
    "method": {
      "id": 2,
      "name": "Islamic Society of North America (ISNA)"
    }
  },
  "meta": {
    "cache_expires": "2025-09-04T00:00:00Z"
  }
}
```

**Caching**: Until next day at midnight  
**Rate Limit**: 200/hour for anonymous, 1000/hour for authenticated

---

### 3.2 Get Monthly Prayer Calendar

**Endpoint**: `GET /prayer/calendar`

**Description**: Get prayer times for entire month

**Parameters**:
- `latitude` (query, required): Latitude
- `longitude` (query, required): Longitude  
- `year` (query, required): Year (e.g., 2025)
- `month` (query, required): Month (1-12)
- `method` (query, optional): Calculation method ID

**Response**:
```json
{
  "success": true,
  "data": {
    "calendar": [
      {
        "date": "2025-09-01",
        "times": {
          "fajr": "05:16",
          "dhuhr": "12:55",
          "asr": "16:26",
          "maghrib": "19:18",
          "isha": "20:39"
        }
      }
    ]
  }
}
```

---

### 3.3 Get Qibla Direction

**Endpoint**: `GET /prayer/qibla`

**Description**: Get Qibla direction for location

**Parameters**:
- `latitude` (query, required): Latitude
- `longitude` (query, required): Longitude

**Response**:
```json
{
  "success": true,
  "data": {
    "qibla_direction": 58.48,
    "distance_km": 11043.2,
    "location": {
      "latitude": 40.7128,
      "longitude": -74.0060
    },
    "kaaba": {
      "latitude": 21.4225,
      "longitude": 39.8262
    }
  }
}
```

---

## 4. Hadith API Endpoints

### 4.1 Get Hadith Collections

**Endpoint**: `GET /hadith/collections`

**Description**: Get available hadith collections

**Response**:
```json
{
  "success": true,
  "data": {
    "collections": [
      {
        "id": "bukhari",
        "name_english": "Sahih al-Bukhari",
        "name_arabic": "صحيح البخاري",
        "name_bangla": "সহীহ বুখারী",
        "short_name": "Bukhari",
        "total_hadiths": 7563,
        "is_sahih": true,
        "scholar_name": "Imam al-Bukhari"
      }
    ]
  }
}
```

---

### 4.2 Get Collection Books

**Endpoint**: `GET /hadith/collections/{collection_id}/books`

**Description**: Get books within a hadith collection

**Response**:
```json
{
  "success": true,
  "data": {
    "collection": {
      "id": "bukhari",
      "name_english": "Sahih al-Bukhari"
    },
    "books": [
      {
        "id": 1,
        "book_number": 1,
        "name_english": "Revelation",
        "name_arabic": "بدء الوحي",
        "hadith_count": 7
      }
    ]
  }
}
```

---

### 4.3 Get Hadiths from Book

**Endpoint**: `GET /hadith/collections/{collection_id}/books/{book_id}/hadiths`

**Description**: Get hadiths from specific book

**Parameters**:
- `page` (query, optional): Page number
- `per_page` (query, optional): Items per page (max: 50)

**Response**:
```json
{
  "success": true,
  "data": {
    "hadiths": [
      {
        "id": 1,
        "hadith_number": "1",
        "reference": "Sahih al-Bukhari 1:1",
        "text_arabic": "إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ...",
        "text_english": "Actions are but by intention...",
        "text_bangla": "কাজ (এর প্রাপ্যতা) নিয়তের উপর নির্ভরশীল...",
        "grade": "Sahih",
        "narrator": "Umar ibn al-Khattab",
        "topic": "Intention"
      }
    ]
  },
  "pagination": {
    "current_page": 1,
    "total_hadiths": 7
  }
}
```

---

### 4.4 Search Hadiths

**Endpoint**: `GET /hadith/search`

**Description**: Search across hadith collections

**Parameters**:
- `q` (query, required): Search query
- `collection` (query, optional): Specific collection to search
- `language` (query, optional): Language to search in
- `page` (query, optional): Page number

**Response**:
```json
{
  "success": true,
  "data": {
    "results": [
      {
        "hadith_id": 1,
        "collection": "bukhari",
        "reference": "Sahih al-Bukhari 1:1",
        "text": "Actions are but by intention...",
        "highlight": "<mark>Actions</mark> are but by intention...",
        "grade": "Sahih",
        "relevance_score": 0.89
      }
    ]
  }
}
```

---

## 5. Zakat API Endpoints

### 5.1 Get Nisab Rates

**Endpoint**: `GET /zakat/nisab`

**Description**: Get current Nisab thresholds for Zakat calculation

**Parameters**:
- `currency` (query, optional): Currency code (default: "USD")
- `date` (query, optional): Specific date (default: today)

**Response**:
```json
{
  "success": true,
  "data": {
    "currency": "USD",
    "date": "2025-09-03",
    "nisab": {
      "gold": {
        "amount": 1856.90,
        "grams": 87.48,
        "price_per_gram": 65.50
      },
      "silver": {
        "amount": 520.45,
        "grams": 612.36,
        "price_per_gram": 0.85
      }
    },
    "recommended": "silver",
    "last_updated": "2025-09-03T10:00:00Z"
  }
}
```

---

### 5.2 Calculate Zakat

**Endpoint**: `POST /zakat/calculate`

**Description**: Calculate Zakat amount based on assets

**Request Body**:
```json
{
  "currency": "USD",
  "assets": {
    "cash": 5000,
    "gold_grams": 100,
    "silver_grams": 0,
    "investments": 2000,
    "business_assets": 0
  },
  "liabilities": {
    "debts": 500
  }
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "total_assets": 7000,
    "total_liabilities": 500,
    "zakatable_wealth": 6500,
    "nisab_threshold": 520.45,
    "is_liable": true,
    "zakat_due": 162.50,
    "zakat_rate": 0.025,
    "calculation_date": "2025-09-03"
  }
}
```

---

## 6. Error Codes & Status Codes

### 6.1 HTTP Status Codes

| Code | Meaning | When Used |
|------|---------|-----------|
| 200 | OK | Successful request |
| 400 | Bad Request | Invalid parameters |
| 401 | Unauthorized | Missing/invalid API key |
| 403 | Forbidden | Rate limit exceeded |
| 404 | Not Found | Resource not found |
| 429 | Too Many Requests | Rate limit exceeded |
| 500 | Internal Server Error | Server error |
| 503 | Service Unavailable | Maintenance mode |

### 6.2 Custom Error Codes

| Code | Description |
|------|-------------|
| `INVALID_CHAPTER` | Chapter number out of range (1-114) |
| `INVALID_VERSE` | Verse number invalid for chapter |
| `INVALID_COORDINATES` | Latitude/longitude out of range |
| `INVALID_DATE` | Date format invalid or out of range |
| `TRANSLATION_NOT_FOUND` | Requested translation not available |
| `RECITER_NOT_FOUND` | Requested reciter not available |
| `COLLECTION_NOT_FOUND` | Hadith collection not found |
| `RATE_LIMIT_EXCEEDED` | API rate limit exceeded |
| `SEARCH_QUERY_TOO_SHORT` | Search query must be at least 3 characters |

---

## 7. Rate Limiting

### 7.1 Rate Limit Headers

All responses include rate limiting headers:

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1693737600
```

### 7.2 Rate Limit Tiers

| User Type | Requests/Hour | Burst Limit |
|-----------|---------------|-------------|
| Anonymous | 100 | 20/minute |
| Authenticated | 1000 | 50/minute |
| Premium | 5000 | 100/minute |
| Enterprise | Custom | Custom |

---

## 8. Caching Strategy

### 8.1 Cache Headers

```http
Cache-Control: public, max-age=3600
ETag: "e1ca502697e5c9317743dc1f8c6b4ec2"
Last-Modified: Tue, 03 Sep 2025 10:30:00 GMT
```

### 8.2 Cache TTL by Endpoint

| Endpoint | TTL | CDN Cache |
|----------|-----|-----------|
| `/quran/chapters` | 24 hours | Yes |
| `/quran/chapters/{id}/verses` | 1 hour | Yes |
| `/prayer/times` | Until midnight | No |
| `/hadith/collections` | 24 hours | Yes |
| `/zakat/nisab` | 1 hour | No |

---

## 9. Pagination

### 9.1 Standard Pagination

```http
GET /quran/chapters/2/verses?page=2&per_page=50
```

**Response**:
```json
{
  "pagination": {
    "current_page": 2,
    "per_page": 50,
    "total_pages": 6,
    "total_items": 286,
    "has_next": true,
    "has_previous": true,
    "next_page": 3,
    "previous_page": 1
  }
}
```

---

## 10. Webhooks (Future)

### 10.1 Data Update Notifications

**Endpoint**: `POST /webhooks/data-updates`

**Payload**:
```json
{
  "event": "translation_updated",
  "resource": "quran_translations",
  "resource_id": 131,
  "timestamp": "2025-09-03T10:30:00Z"
}
```

---

**API Specification Completed**: September 3, 2025  
**Version**: 1.0.0  
**Total Endpoints**: 15+ core endpoints across 4 modules  
**Ready for Implementation**: Yes, with complete request/response examples

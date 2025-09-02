# Hadith API Setup Guide

## Overview

The DeenMate app integrates with the Sunnah.com API to provide authentic Hadith data. This guide explains how to set up API access for development and production.

## Sunnah.com API

### About
- **Provider**: Sunnah.com
- **Documentation**: https://sunnah.stoplight.io/docs/api/
- **Base URL**: https://api.sunnah.com/v1
- **Authentication**: API Key required

### Getting API Access

1. **Request API Key**:
   - Visit: https://github.com/sunnah-com/api/issues/new?template=request-for-api-access.md
   - Fill out the access request form
   - Explain your use case (Islamic educational app)
   - Wait for approval from the Sunnah.com team

2. **Configure API Key**:
   ```bash
   # For development, create a .env file or set environment variable
   export SUNNAH_API_KEY="your_api_key_here"
   
   # For Flutter run
   flutter run --dart-define=SUNNAH_API_KEY=your_api_key_here
   ```

3. **Verify Setup**:
   - Run the integration tests: `flutter test test/features/hadith/integration/api_integration_test.dart`
   - Check app logs for successful API connections

### API Features

The implementation supports:

- ✅ **Collections**: Fetch available Hadith collections (Bukhari, Muslim, etc.)
- ✅ **Books**: Get books within collections
- ✅ **Chapters**: Get chapters within books
- ✅ **Hadiths**: Fetch individual Hadiths
- ✅ **Search**: Search across Hadith text
- ✅ **Topics**: Browse by topic/category
- ✅ **Multi-language**: Arabic, English, Urdu, Bengali support

### Error Handling

The app gracefully handles:
- ❌ **403 Forbidden**: Shows user-friendly message about API key requirement
- ❌ **429 Rate Limit**: Implements retry logic with backoff
- ❌ **Network Issues**: Offline mode with cached data
- ❌ **Server Errors**: Fallback to local data when available

### Development Without API Key

For development without an API key:

1. **Mock Data**: The app includes comprehensive mock data for development
2. **Local Testing**: Use the existing mock providers for UI development
3. **Offline Mode**: All features work with cached/local data

### Production Deployment

For production:

1. **Secure Storage**: Store API key in secure environment variables
2. **Rate Limiting**: Implement appropriate caching to minimize API calls
3. **Monitoring**: Monitor API usage and error rates
4. **Fallback**: Always have local data as fallback

## Technical Implementation

### Architecture

```
lib/features/hadith/
├── data/
│   ├── api/sunnah_api.dart              # API client
│   ├── models/                          # DTOs for API responses
│   ├── datasources/                     # Remote & local data sources
│   └── repositories/                    # Repository implementation
├── domain/
│   ├── entities/                        # Domain entities
│   └── repositories/                    # Repository interfaces
└── presentation/
    ├── providers/hadith_data_providers.dart  # Dependency injection
    └── providers/hadith_provider.dart        # State management
```

### Key Files

- **`sunnah_api.dart`**: HTTP client for Sunnah.com API
- **`hadith_repository_impl.dart`**: Repository with caching logic
- **`hadith_data_providers.dart`**: Riverpod providers for DI
- **`app_config.dart`**: Configuration including API key management

### Testing

```bash
# Run API integration tests
flutter test test/features/hadith/integration/

# Run all hadith module tests
flutter test test/features/hadith/

# Run with API key
flutter test --dart-define=SUNNAH_API_KEY=your_key test/features/hadith/integration/
```

## Troubleshooting

### Common Issues

1. **403 Forbidden Error**:
   - Verify API key is correctly set
   - Check if API key has required permissions
   - Ensure proper headers are sent

2. **Rate Limiting**:
   - Implement exponential backoff
   - Cache API responses locally
   - Reduce API call frequency

3. **Network Issues**:
   - Verify internet connectivity
   - Check API endpoint availability
   - Review timeout settings

### Support

- **Sunnah.com API**: Create issues on [GitHub](https://github.com/sunnah-com/api)
- **DeenMate App**: Check project documentation or create an issue

## Status

- ✅ **API Client**: Implemented with authentication
- ✅ **Error Handling**: Comprehensive error management
- ✅ **Caching**: Local storage for offline access
- ✅ **UI Integration**: Provider-based state management
- ⏳ **API Key**: Pending approval from Sunnah.com
- ⏳ **Production**: Ready for deployment once API key obtained

## Next Steps

1. Request API key from Sunnah.com
2. Test with live API once key is approved
3. Optimize caching strategy based on usage patterns
4. Implement advanced search features
5. Add bookmark synchronization

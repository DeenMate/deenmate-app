class AppConfig {
  const AppConfig();

  // Public dev base (bypass auth): Quran.com API v4
  final String qfBase = 'https://api.quran.com/api/v4';

  // Sunnah.com API key (request from: https://github.com/sunnah-com/api/issues/new?template=request-for-api-access.md)
  final String? sunnahApiKey = const String.fromEnvironment(
    'SUNNAH_API_KEY',
  );

  // Token proxy endpoint (edge worker)
  final String tokenProxy = const String.fromEnvironment(
    'TOKEN_PROXY',
    defaultValue: 'https://auth.deenmate.app/token',
  );

  // Pagination size
  final int perPage = 50;
}

/// Centralized preference keys to ensure consistency across onboarding and settings
class PreferenceKeys {
  // Onboarding completion
  static const String onboardingCompleted = 'onboarding_completed';
  
  // User identification
  static const String userName = 'user_name';
  
  // Location preferences
  static const String userCity = 'user_city';
  static const String userCountry = 'user_country';
  static const String userLatitude = 'user_latitude';
  static const String userLongitude = 'user_longitude';
  
  // Prayer calculation preferences
  static const String calculationMethod = 'calculation_method';
  static const String madhhab = 'madhhab';
  
  // Notification preferences - UNIFIED KEYS
  static const String notificationsEnabled = 'notifications_enabled';
  static const String athanEnabled = 'athan_enabled';
  static const String prayerRemindersEnabled = 'prayer_reminders_enabled';
  static const String enabledPrayers = 'enabled_prayers';
  
  // Theme preferences
  static const String selectedTheme = 'selected_theme';
  
  // Language preferences
  static const String selectedLanguage = 'selected_language';
  
  // Translation preferences
  static const String selectedTranslationIds = 'selected_translation_ids';
  
  // Reading preferences
  static const String lastReadChapter = 'last_read_chapter';
  static const String lastReadVerse = 'last_read_verse';
  
  // Zakat calculator data
  static const String zakatCash = 'zakat_cash';
  static const String zakatSavings = 'zakat_savings';
  static const String zakatInvestment = 'zakat_investment';
  static const String zakatGold = 'zakat_gold';
  static const String zakatSilver = 'zakat_silver';
  static const String zakatCurrency = 'zakat_currency';
  
  // Helper methods to fix calculation method sync issues
  // Convert calculation method from name to index for settings UI compatibility
  static int getCalculationMethodIndex(String methodName) {
    const methods = ['KARACHI', 'ISNA', 'MWL', 'MAKKAH', 'EGYPT', 'TEHRAN', 'JAFARI'];
    final index = methods.indexOf(methodName.toUpperCase());
    return index >= 0 ? index : 2; // Default to MWL (index 2)
  }
  
  // Convert calculation method from index to name for storage consistency
  static String getCalculationMethodName(int index) {
    const methods = ['KARACHI', 'ISNA', 'MWL', 'MAKKAH', 'EGYPT', 'TEHRAN', 'JAFARI'];
    return index >= 0 && index < methods.length ? methods[index] : 'MWL';
  }
}

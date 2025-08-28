// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get appTitle => 'DeenMate';

  @override
  String get onboardingWelcomeTitle => 'DeenMate میں خوش آمدید';

  @override
  String get onboardingWelcomeSubtitle => 'آپ کا مکمل اسلامی ساتھی';

  @override
  String get onboardingLanguageTitle => 'اپنی زبان منتخب کریں';

  @override
  String get onboardingLanguageSubtitle =>
      'ایپ کے لیے اپنی ترجیحی زبان منتخب کریں';

  @override
  String get onboardingUsernameTitle => 'What should we call you?';

  @override
  String get onboardingUsernameSubtitle =>
      'Enter your name or preferred nickname';

  @override
  String get onboardingLocationTitle => 'Set Your Location';

  @override
  String get onboardingLocationSubtitle =>
      'This helps us provide accurate prayer times';

  @override
  String get onboardingCalculationTitle => 'Prayer Time Calculation';

  @override
  String get onboardingCalculationSubtitle =>
      'Choose your preferred calculation method';

  @override
  String get onboardingMadhhabTitle => 'Select Your Madhhab';

  @override
  String get onboardingMadhhabSubtitle =>
      'Choose your Islamic school of thought';

  @override
  String get onboardingNotificationsTitle => 'Notifications';

  @override
  String get onboardingNotificationsSubtitle =>
      'Stay connected with prayer reminders';

  @override
  String get onboardingThemeTitle => 'Choose Your Theme';

  @override
  String get onboardingThemeSubtitle => 'Select your preferred visual style';

  @override
  String get onboardingCompleteTitle => 'You\'re All Set!';

  @override
  String get onboardingCompleteSubtitle =>
      'Welcome to DeenMate. Let\'s begin your journey.';

  @override
  String get navigationHome => 'ہوم';

  @override
  String get navigationQuran => 'قرآن';

  @override
  String get navigationHadith => 'حدیث';

  @override
  String get navigationMore => 'مزید';

  @override
  String get prayerTimesTitle => 'نماز کے اوقات';

  @override
  String get prayerFajr => 'فجر';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'ظہر';

  @override
  String get prayerAsr => 'عصر';

  @override
  String get prayerMaghrib => 'مغرب';

  @override
  String get prayerIsha => 'عشاء';

  @override
  String get nextPrayer => 'اگلی نماز';

  @override
  String get currentPrayer => 'موجودہ نماز';

  @override
  String get timeRemaining => 'باقی وقت';

  @override
  String get quranTitle => 'قرآن';

  @override
  String get quranLastRead => 'آخری پڑھا گیا';

  @override
  String get quranContinue => 'جاری رکھیں';

  @override
  String get quranSearch => 'تلاش';

  @override
  String get quranNavigation => 'Navigation';

  @override
  String get quranSurah => 'Surah';

  @override
  String get quranPage => 'Page';

  @override
  String get quranJuz => 'Juz';

  @override
  String get quranHizb => 'Hizb';

  @override
  String get quranRuku => 'Ruku';

  @override
  String get ramadanSuhoor => 'Suhoor';

  @override
  String get ramadanIftaar => 'Iftaar';

  @override
  String get prayerTimesSource => 'timings from AlAdhan';

  @override
  String prayerTimesUpdated(String time) {
    return 'Updated: $time';
  }

  @override
  String get prayerTimesCurrentPrayer => 'Current Prayer';

  @override
  String get prayerTimesNextPrayer => 'Next Prayer';

  @override
  String get prayerTimesNoActivePrayer => 'No Active Prayer';

  @override
  String get prayerTimesAzan => 'Azan';

  @override
  String get prayerTimesJamaat => 'Jama\'at';

  @override
  String prayerTimesEndTime(String time) {
    return 'End time - $time';
  }

  @override
  String get settingsTitle => 'ترتیبات';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrayerReminders => 'Prayer Reminders';

  @override
  String get settingsTheme => 'تھیم';

  @override
  String get settingsLanguage => 'زبان';

  @override
  String get settingsCalculationMethod => 'Calculation Method';

  @override
  String get commonLoading => 'لوڈ ہو رہا ہے...';

  @override
  String get commonError => 'غلطی';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'منسوخ کریں';

  @override
  String get commonSave => 'محفوظ کریں';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'پیچھے';

  @override
  String get commonNext => 'اگلا';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonContinue => 'جاری رکھیں';

  @override
  String get commonDone => 'Done';

  @override
  String get exitDialogTitle => 'Exit DeenMate';

  @override
  String get exitDialogMessage => 'Are you sure you want to exit the app?';

  @override
  String get exitDialogExit => 'Exit';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languageUrdu => 'اردو';

  @override
  String get languageArabic => 'العربية';

  @override
  String get languageFullySupported => 'Fully Supported';

  @override
  String get languageComingSoon => 'Coming Soon';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLightSerenity => 'Light Serenity';

  @override
  String get themeNightCalm => 'Night Calm';

  @override
  String get themeHeritageSepia => 'Heritage Sepia';

  @override
  String get errorGeneric => 'Something went wrong';

  @override
  String get errorNetwork => 'Network error. Please check your connection.';

  @override
  String get errorLocation =>
      'Location access is required for accurate prayer times.';

  @override
  String get errorPermission => 'Permission denied';

  @override
  String get infoLocationRequired =>
      'Location access helps provide accurate prayer times for your area.';

  @override
  String get infoNotificationsHelp => 'Get notified before each prayer time.';

  @override
  String get infoThemeDescription =>
      'Choose your preferred visual style for the app.';

  @override
  String get locationSetSuccess => 'Location set successfully!';

  @override
  String locationGetFailed(String error) {
    return 'Failed to get location: $error';
  }

  @override
  String locationSaveSuccess(String city, String country) {
    return 'Location \"$city, $country\" saved successfully!';
  }

  @override
  String locationSaveFailed(String error) {
    return 'Failed to save location: $error';
  }

  @override
  String get locationPermissionRequired => 'Location Permission Required';

  @override
  String get buttonCancel => 'Cancel';

  @override
  String get buttonTryAgain => 'Try Again';

  @override
  String get buttonConfirm => 'Confirm';

  @override
  String get settingsAbout => 'About DeenMate';

  @override
  String get settingsAboutSubtitle => 'Version, credits, and more';

  @override
  String get settingsPrivacyPolicy => 'Privacy Policy';

  @override
  String get settingsPrivacyPolicySubtitle => 'How we protect your data';

  @override
  String get settingsClearCache => 'Clear Cache';

  @override
  String get settingsClearCacheSubtitle => 'Free up storage space';

  @override
  String get settingsExportData => 'Export Data';

  @override
  String get settingsExportDataSubtitle => 'Backup your settings and data';

  @override
  String get settingsPrayerCalculationMethod => 'Prayer Calculation Method';

  @override
  String get settingsSelectLanguage => 'Select Language';

  @override
  String get settingsPermissionRequired => 'Permission Required';

  @override
  String get settingsCacheClearedSuccess => 'Cache cleared successfully';

  @override
  String get settingsExportComingSoon => 'Export feature coming soon!';

  @override
  String get prayerCalculationMethods => 'Prayer Calculation Methods';

  @override
  String get prayerAthanNotifications => 'Athan & Notifications';

  @override
  String get prayerVibration => 'Vibration';

  @override
  String get prayerVibrationSubtitle => 'Vibrate device during Athan';

  @override
  String get prayerQuickActions => 'Quick Actions';

  @override
  String get prayerQuickActionsSubtitle =>
      'Show \"Mark as Prayed\" and \"Snooze\" buttons';

  @override
  String get prayerAutoComplete => 'Auto-complete';

  @override
  String get prayerAutoCompleteSubtitle =>
      'Automatically mark prayer as completed';

  @override
  String get prayerSmartNotifications => 'Smart Notifications';

  @override
  String get prayerSmartNotificationsSubtitle =>
      'Adjust notifications based on your activity';

  @override
  String get prayerOverrideDND => 'Override Do Not Disturb';

  @override
  String get prayerOverrideDNDSubtitle =>
      'Show prayer notifications even in DND mode';

  @override
  String get prayerFullScreenNotifications => 'Full Screen Notifications';

  @override
  String get prayerFullScreenNotificationsSubtitle =>
      'Show prayer time as full screen alert';

  @override
  String get prayerRamadanNotifications => 'Ramadan Notifications';

  @override
  String get prayerRamadanNotificationsSubtitle =>
      'Enable special notifications for Suhur and Iftar';

  @override
  String get prayerSpecialRamadanAthan => 'Special Ramadan Athan';

  @override
  String get prayerSpecialRamadanAthanSubtitle =>
      'Use special Athan recitations during Ramadan';

  @override
  String get prayerIncludeDuas => 'Include Duas';

  @override
  String get prayerIncludeDuasSubtitle =>
      'Show Ramadan-specific duas in notifications';

  @override
  String get prayerTrackFasting => 'Track Fasting';

  @override
  String get prayerTrackFastingSubtitle => 'Keep track of your fasting status';

  @override
  String get buttonRetry => 'Retry';

  @override
  String get buttonGrant => 'Grant';

  @override
  String get buttonApply => 'Apply';

  @override
  String get buttonGotIt => 'Got it';

  @override
  String get prayerTestAthanAudio => 'Test Athan Audio';

  @override
  String get prayerScheduleNow => 'Schedule Now';

  @override
  String get prayerDebugInfo => 'Debug Info';

  @override
  String get prayerScheduleNotifications => 'Schedule Prayer Notifications';

  @override
  String get prayerTestNotification => 'Test Notification (1 sec)';

  @override
  String get prayerDemoNotification => 'Demo Notification (2 min)';

  @override
  String get prayerImmediateNotification => 'Immediate Notification';

  @override
  String get prayerAthanTestStarted => 'Athan audio test started';

  @override
  String prayerAthanTestFailed(String error) {
    return 'Athan test failed: $error';
  }

  @override
  String get prayerNotificationsScheduled =>
      'Notifications scheduled for today';

  @override
  String prayerSchedulingFailed(String error) {
    return 'Scheduling failed: $error';
  }

  @override
  String prayerDebugFailed(String error) {
    return 'Debug failed: $error';
  }

  @override
  String get prayerTestNotificationSent =>
      'Test notification sent immediately!';

  @override
  String prayerTestNotificationFailed(String error) {
    return 'Test notification failed: $error';
  }

  @override
  String get prayerDemoNotificationSent =>
      'Demo notification sent! Azan should play now.';

  @override
  String prayerDemoNotificationFailed(String error) {
    return 'Demo notification failed: $error';
  }

  @override
  String get prayerImmediateNotificationSent => 'Immediate notification sent!';

  @override
  String prayerImmediateNotificationFailed(String error) {
    return 'Immediate notification failed: $error';
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'DeenMate';

  @override
  String get onboardingWelcomeTitle => 'مرحباً بك في DeenMate';

  @override
  String get onboardingWelcomeSubtitle => 'رفيقك الإسلامي الشامل';

  @override
  String get onboardingLanguageTitle => 'اختر لغتك';

  @override
  String get onboardingLanguageSubtitle => 'اختر لغتك المفضلة للتطبيق';

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
  String get onboardingLocationGpsTitle => 'Use GPS Location';

  @override
  String get onboardingLocationGpsSubtitle =>
      'Automatically detect your current location';

  @override
  String get onboardingLocationManualTitle => 'Manual Selection';

  @override
  String get onboardingLocationManualSubtitle => 'Choose your city manually';

  @override
  String get onboardingUsernameHint => 'Enter your name';

  @override
  String get onboardingNotificationEnable => 'Enable';

  @override
  String get onboardingNotificationEnableSubtitle =>
      'Receive prayer time notifications';

  @override
  String get onboardingNotificationDisable => 'Disable';

  @override
  String get onboardingNotificationDisableSubtitle => 'Use silent mode only';

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
  String get navigationHome => 'الرئيسية';

  @override
  String get navigationQuran => 'القرآن';

  @override
  String get navigationHadith => 'الحديث';

  @override
  String get navigationMore => 'المزيد';

  @override
  String get prayerTimesTitle => 'أوقات الصلاة';

  @override
  String get prayerFajr => 'الفجر';

  @override
  String get prayerSunrise => 'Sunrise';

  @override
  String get prayerDhuhr => 'الظهر';

  @override
  String get prayerAsr => 'العصر';

  @override
  String get prayerMaghrib => 'المغرب';

  @override
  String get prayerIsha => 'العشاء';

  @override
  String get nextPrayer => 'الصلاة القادمة';

  @override
  String get currentPrayer => 'الصلاة الحالية';

  @override
  String get timeRemaining => 'الوقت المتبقي';

  @override
  String get quranTitle => 'القرآن';

  @override
  String get quranLastRead => 'آخر قراءة';

  @override
  String get quranContinue => 'استمر';

  @override
  String get quranSearch => 'بحث';

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
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsNotifications => 'Notifications';

  @override
  String get settingsPrayerReminders => 'Prayer Reminders';

  @override
  String get settingsTheme => 'المظهر';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsCalculationMethod => 'Calculation Method';

  @override
  String get commonLoading => 'جاري التحميل...';

  @override
  String get commonError => 'خطأ';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonSave => 'حفظ';

  @override
  String get commonClose => 'Close';

  @override
  String get commonBack => 'رجوع';

  @override
  String get commonNext => 'التالي';

  @override
  String get commonSkip => 'Skip';

  @override
  String get commonContinue => 'استمر';

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

  @override
  String get audioDownloadsTitle => 'Audio Downloads';

  @override
  String get audioStorageTitle => 'Audio Storage';

  @override
  String get audioStorageErrorStats => 'Error loading stats';

  @override
  String get audioSelectReciterTitle => 'Select Reciter';

  @override
  String get audioRecitersLoadError => 'Error loading reciters';

  @override
  String get audioQuickActionsTitle => 'Quick Actions';

  @override
  String get audioDownloadPopularTitle => 'Download Popular';

  @override
  String get audioDownloadPopularSubtitle => 'Download most popular chapters';

  @override
  String get audioDownloadAllTitle => 'Download All';

  @override
  String get audioDownloadAllSubtitle => 'Download complete Quran';

  @override
  String get audioIndividualChaptersTitle => 'Individual Chapters';

  @override
  String get audioDownloadCancel => 'Cancel';

  @override
  String get audioChapterDelete => 'Delete';
}

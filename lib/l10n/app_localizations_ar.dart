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
  String get settingsPrayerSettings => 'Prayer Settings';

  @override
  String get settingsAthanSettings => 'Athan Settings';

  @override
  String get settingsAthanSubtitle => 'Call to prayer customization';

  @override
  String get settingsPrayerNotifications => 'Prayer Notifications';

  @override
  String get settingsPrayerNotificationsSubtitle =>
      'Enable prayer time reminders';

  @override
  String get settingsPrayerRemindersSubtitle => 'Get notified for prayer times';

  @override
  String get settingsIslamicMidnight => 'Islamic Midnight';

  @override
  String get settingsIslamicMidnightSubtitle =>
      'Calculate midnight according to Islamic tradition';

  @override
  String get settingsIslamicContent => 'Islamic Content';

  @override
  String get settingsDailyVerses => 'Daily Verses';

  @override
  String get settingsDailyVersesSubtitle => 'Receive daily Quranic verses';

  @override
  String get settingsQuranSettings => 'Quran Settings';

  @override
  String get settingsReadingPreferences => 'Reading Preferences';

  @override
  String get settingsContentTranslations => 'Content & Translations';

  @override
  String get settingsOfflineManagement => 'Offline Management';

  @override
  String get settingsOfflineSubtitle =>
      'Quran text and translations for offline reading';

  @override
  String get settingsAudioDownloads => 'Audio Downloads';

  @override
  String get settingsAudioSubtitle =>
      'Download recitations for offline listening';

  @override
  String get settingsAccessibility => 'Accessibility';

  @override
  String get settingsAppSettings => 'App Settings';

  @override
  String get settingsDataStorage => 'Data & Storage';

  @override
  String get settingsUserName => 'Your name';

  @override
  String get settingsUserNameSubtitle => 'Set your display name';

  @override
  String get settingsEditName => 'Edit name';

  @override
  String get settingsEnterName => 'Enter your name';

  @override
  String get settingsAppDescription => 'Islamic Utility Super App';

  @override
  String get settingsComingSoon => 'Coming Soon';

  @override
  String get settingsPrayerCalculationMethodTitle =>
      'Prayer Calculation Method';

  @override
  String get commonLoading => 'جاري التحميل...';

  @override
  String get commonPleaseWait => 'Please wait...';

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
  String get errorLanguageChangeFailed =>
      'Failed to change language. Please try again.';

  @override
  String get errorLanguageChangeGeneric =>
      'An error occurred while changing the language.';

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
  String get buttonClear => 'Clear';

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
  String get settingsClearCacheConfirmMessage =>
      'Are you sure you want to clear the cache? This will remove temporary files and may slow down the app initially.';

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

  @override
  String audioErrorLoadingChapters(String error) {
    return 'Error loading chapters: $error';
  }

  @override
  String get audioDownloadingPopularChapters =>
      'Downloading popular chapters...';

  @override
  String audioDownloadingChapter(String chapterId, String status) {
    return 'Downloading chapter $chapterId: $status';
  }

  @override
  String get audioPopularChaptersDownloadSuccess =>
      'Popular chapters downloaded successfully!';

  @override
  String audioDownloadFailed(String error) {
    return 'Download failed: $error';
  }

  @override
  String get audioDownloadingCompleteQuran => 'Downloading complete Quran...';

  @override
  String audioDownloadingSurah(String chapterName, String status) {
    return 'Surah $chapterName: $status';
  }

  @override
  String get audioCompleteQuranDownloadSuccess =>
      'Complete Quran downloaded successfully!';

  @override
  String audioDownloadingVerse(String currentVerse) {
    return 'Downloading $currentVerse...';
  }

  @override
  String get audioChapterDeleted => 'Chapter audio deleted';

  @override
  String audioDeleteFailed(String error) {
    return 'Delete failed: $error';
  }

  @override
  String get audioUserCancelled => 'User cancelled';

  @override
  String get prayerTimesLoading => 'Loading Prayer Times';

  @override
  String get prayerTimesUnavailable => 'Prayer Times Unavailable';

  @override
  String get prayerTimesUnableToLoad => 'Unable to load prayer times';

  @override
  String get prayerTimesLocationRequired => 'Location Required';

  @override
  String get prayerTimesEnableLocation =>
      'Enable location services for accurate prayer times';

  @override
  String get prayerTimesEnableLocationAction => 'Enable Location';

  @override
  String get prayerTimesNetworkIssue => 'Network Issue';

  @override
  String get prayerTimesCheckConnection =>
      'Check internet connection and try again';

  @override
  String get prayerTimesServiceUnavailable => 'Service Unavailable';

  @override
  String get prayerTimesServiceTemporarilyUnavailable =>
      'Prayer time service is temporarily unavailable';

  @override
  String get prayerTimesRetry => 'Retry';

  @override
  String get prayerTimesTryAgain => 'Try Again';

  @override
  String get prayerTimesDataUnavailable => 'Prayer times data is unavailable';

  @override
  String get prayerTimesLocationAccess => 'Location Access';

  @override
  String get prayerTimesLocationAccessMessage =>
      'DeenMate needs location access to provide accurate prayer times for your area.\n\nYou can:\n• Enable location services in device settings\n• Manually select your city in app settings\n• Use approximate times based on your region';

  @override
  String get prayerTimesLater => 'Later';

  @override
  String get prayerTimesSettings => 'Settings';

  @override
  String get commonToday => 'Today';

  @override
  String get islamicMonthMuharram => 'Muharram';

  @override
  String get islamicMonthSafar => 'Safar';

  @override
  String get islamicMonthRabiAlAwwal => 'Rabi al-Awwal';

  @override
  String get islamicMonthRabiAlThani => 'Rabi al-Thani';

  @override
  String get islamicMonthJumadaAlAwwal => 'Jumada al-Awwal';

  @override
  String get islamicMonthJumadaAlThani => 'Jumada al-Thani';

  @override
  String get islamicMonthRajab => 'Rajab';

  @override
  String get islamicMonthShaban => 'Sha\'ban';

  @override
  String get islamicMonthRamadan => 'Ramadan';

  @override
  String get islamicMonthShawwal => 'Shawwal';

  @override
  String get islamicMonthDhuAlQadah => 'Dhu al-Qadah';

  @override
  String get islamicMonthDhuAlHijjah => 'Dhu al-Hijjah';

  @override
  String get homeTimeStatusNow => 'now';

  @override
  String get homeGreeting => 'As-salāmu \'alaykum,';

  @override
  String get homeForbiddenSunrise => 'Salah is forbidden during sunrise';

  @override
  String get homeForbiddenZenith =>
      'Salah is forbidden during solar noon (zenith)';

  @override
  String get homeForbiddenSunset => 'Salah is forbidden during sunset';

  @override
  String homePrayerIn(String prayerName) {
    return '$prayerName in ';
  }

  @override
  String homePrayerRemaining(String prayerName) {
    return '$prayerName remaining ';
  }

  @override
  String get homeNoActivePrayer => 'No Active Prayer';

  @override
  String get homeCurrentPrayer => 'Current Prayer';

  @override
  String get homeNextPrayer => 'Next Prayer';

  @override
  String get athanPreviewTitle => 'Preview Athan';

  @override
  String get athanPreviewDescription =>
      'Listen to a sample of the selected Muadhin voice:';

  @override
  String get athanPreviewPlay => 'Preview';

  @override
  String get athanPreviewStop => 'Stop';

  @override
  String get athanPreviewPlaying => 'Playing...';

  @override
  String get reciterAbdulBasit => 'Abdul Basit Abdul Samad';

  @override
  String get reciterAbdulBasitDesc =>
      'Renowned Quranic reciter from Egypt with a melodious voice';

  @override
  String get reciterMishary => 'Mishary Rashid Alafasy';

  @override
  String get reciterMisharyDesc => 'Famous Imam and reciter from Kuwait';

  @override
  String get reciterSudais => 'Sheikh Abdul Rahman Al-Sudais';

  @override
  String get reciterSudaisDesc => 'Imam of Masjid al-Haram in Mecca';

  @override
  String get reciterShuraim => 'Sheikh Saud Al-Shuraim';

  @override
  String get reciterShuraimDesc => 'Imam of Masjid al-Haram in Mecca';

  @override
  String get reciterMaher => 'Maher Al-Muaiqly';

  @override
  String get reciterMaherDesc =>
      'Imam of Masjid al-Haram with beautiful recitation';

  @override
  String get reciterYasser => 'Yasser Ad-Dussary';

  @override
  String get reciterYasserDesc => 'Beautiful voice from Saudi Arabia';

  @override
  String get reciterAjmi => 'Ahmad Al-Ajmi';

  @override
  String get reciterAjmiDesc => 'Kuwaiti reciter with distinctive style';

  @override
  String get reciterGhamdi => 'Saad Al-Ghamdi';

  @override
  String get reciterGhamdiDesc =>
      'Saudi reciter known for emotional recitation';

  @override
  String get reciterDefault => 'Default Athan';

  @override
  String get reciterDefaultDesc => 'Standard Islamic call to prayer';

  @override
  String get prayerTimesNextIn => 'Next in';

  @override
  String get prayerTimesPleaseWait => 'Please wait';

  @override
  String get settingsReadingPreferencesSubtitle =>
      'Font size, translations, layout';

  @override
  String get settingsContentTranslationsSubtitle =>
      'Choose Quran & Hadith translations per language';

  @override
  String get settingsAccessibilitySubtitle =>
      'Screen reader, high contrast, text scaling';

  @override
  String settingsLanguageComingSoon(String languageName) {
    return '$languageName support is coming soon. The app will use English for now.';
  }

  @override
  String settingsLanguageChanged(String languageName) {
    return 'Language changed to $languageName';
  }

  @override
  String get translationPickerTitle => 'Select Translations';

  @override
  String translationPickerErrorLoading(String error) {
    return 'Error loading translations: $error';
  }

  @override
  String get translationPickerCancel => 'Cancel';

  @override
  String get translationPickerApply => 'Apply';

  @override
  String get translationPickerLanguageLabel => 'Language: ';

  @override
  String get translationPickerAllLanguages => 'All Languages';

  @override
  String get translationPickerEnglish => 'English';

  @override
  String get translationPickerArabic => 'Arabic';

  @override
  String get translationPickerUrdu => 'Urdu';

  @override
  String get translationPickerBengali => 'Bengali';

  @override
  String get translationPickerIndonesian => 'Indonesian';

  @override
  String get translationPickerTurkish => 'Turkish';

  @override
  String get translationPickerFrench => 'French';

  @override
  String get readingModeThemeTitle => 'Reading Theme';

  @override
  String get readingModeThemeLight => 'Light Theme';

  @override
  String get readingModeThemeDark => 'Dark Theme';

  @override
  String get readingModeThemeSepia => 'Sepia Theme';

  @override
  String get readingModeThemeLightApplied => 'Light theme applied';

  @override
  String get readingModeThemeDarkApplied => 'Dark theme applied';

  @override
  String get readingModeThemeSepiaApplied => 'Sepia theme applied';

  @override
  String get readingModeFontSettings => 'Font Settings';

  @override
  String get readingModeFontArabicSize => 'Arabic Font Size';

  @override
  String get readingModeFontTranslationSize => 'Translation Font Size';

  @override
  String get readingModeDone => 'Done';

  @override
  String get readingModeTranslationSettings => 'Translation Settings';

  @override
  String get readingModeOK => 'OK';

  @override
  String get readingModeBookmarkAdded => 'Bookmark added';

  @override
  String get verseCardWordAnalysis => 'Word Analysis';

  @override
  String get verseCardPlayAudio => 'Play Audio';

  @override
  String get verseCardDownloadAudio => 'Download Audio';

  @override
  String get verseCardAddNote => 'Add Note';

  @override
  String get verseCardAudioNotAvailable =>
      'Audio playback not available for this verse';

  @override
  String verseCardDownloadingAudio(String verseKey) {
    return 'Downloading audio for verse $verseKey...';
  }

  @override
  String verseCardNotesTitle(String verseKey) {
    return 'Notes for $verseKey';
  }

  @override
  String get verseCardOK => 'OK';

  @override
  String get audioPlayerNowPlaying => 'Now Playing';

  @override
  String get audioPlayerNoVerseSelected => 'No verse selected';

  @override
  String get audioPlayerDefaultReciter => 'Mishary Rashid Alafasy';

  @override
  String get audioPlayerCurrentPlaylist => 'Current Playlist';

  @override
  String get audioPlayerPlaylistComingSoon =>
      'Playlist functionality coming soon';

  @override
  String audioPlayerPlaylistCount(int count) {
    return '$count verses in playlist';
  }

  @override
  String audioPlayerDownloadingVerse(String verseKey) {
    return 'Downloading verse $verseKey...';
  }

  @override
  String audioPlayerDownloadFailed(String error) {
    return 'Download failed: $error';
  }

  @override
  String get wordAnalysisTitle => 'Word-by-Word Analysis';

  @override
  String get wordAnalysisHideAnalysis => 'Tap to hide analysis';

  @override
  String get wordAnalysisShowAnalysis =>
      'Arabic • Transliteration • Translation';

  @override
  String get wordAnalysisDisplayOptions => 'Display Options';

  @override
  String get wordAnalysisTransliteration => 'Transliteration';

  @override
  String get wordAnalysisGrammar => 'Grammar';

  @override
  String get wordAnalysisTapInstruction =>
      'Tap on any word for detailed analysis';

  @override
  String get wordAnalysisOverview => 'Word Analysis Overview';

  @override
  String get wordAnalysisWordDetails => 'Word Details';

  @override
  String get wordAnalysisPosition => 'Position';

  @override
  String get wordAnalysisRoot => 'Root';

  @override
  String get wordAnalysisLemma => 'Lemma';

  @override
  String get wordAnalysisStem => 'Stem';

  @override
  String get wordAnalysisPartOfSpeech => 'Part of Speech';

  @override
  String get wordAnalysisNoDetails =>
      'No additional details available for this word.';

  @override
  String get wordAnalysisGrammarGender => 'Gender';

  @override
  String get wordAnalysisGrammarNumber => 'Number';

  @override
  String get wordAnalysisGrammarPerson => 'Person';

  @override
  String get wordAnalysisGrammarTense => 'Tense';

  @override
  String get wordAnalysisGrammarMood => 'Mood';

  @override
  String get wordAnalysisGrammarVoice => 'Voice';

  @override
  String get wordAnalysisGrammarDetails => 'Grammar';

  @override
  String get wordAnalysisNotAvailable =>
      'No word analysis available for this verse';

  @override
  String get navigationPrayer => 'Prayer';

  @override
  String get navigationQibla => 'Qibla';

  @override
  String get inheritanceCalculatorTitle => 'Inheritance Calculator';

  @override
  String get inheritanceQuickStart => 'Quick Start Guide';

  @override
  String get inheritanceEnterEstate => '1. Enter Estate Value';

  @override
  String get inheritanceSelectHeirs => '2. Select Heirs';

  @override
  String get inheritanceCalculate => '3. Calculate Distribution';

  @override
  String get inheritanceStartCalculation => 'Start Calculation';

  @override
  String get inheritanceFeatures => 'Key Features';

  @override
  String get inheritanceShariahCompliant => '📖 Shariah Compliant';

  @override
  String get inheritanceBasedOnQuran => 'Based on Quran and Sunnah';

  @override
  String get inheritanceStepByStep => '📊 Step-by-Step Guidance';

  @override
  String get inheritanceDetailedBreakdown => 'Detailed calculation breakdown';

  @override
  String get inheritanceAulRaddSupport => '⚖️ Aul & Radd Support';

  @override
  String get inheritanceComplexScenarios =>
      'Handles complex inheritance scenarios';

  @override
  String get inheritanceQuranicReferences => '📚 Quranic References';

  @override
  String get inheritanceRelevantVerses =>
      'Relevant verses and hadiths included';

  @override
  String get inheritanceBengaliLanguage => '🌍 Bengali Language';

  @override
  String get inheritanceBengaliSupport => 'Full Bengali language support';

  @override
  String get inheritanceOfflineCalculation => '📱 Offline Calculation';

  @override
  String get inheritanceWorksOffline => 'Works completely offline';

  @override
  String get qiblaCompassTitle => 'Qibla Compass';

  @override
  String get qiblaCompassNotAvailable => 'Compass not available';

  @override
  String get qiblaCompassCalibrating => 'Calibrating Compass...';

  @override
  String get qiblaCompassUnavailable => 'Compass Unavailable';

  @override
  String get qiblaCompassActive => 'Compass Active';

  @override
  String get qiblaDirectionNorth => 'N';

  @override
  String get qiblaDirectionEast => 'E';

  @override
  String get qiblaDirectionSouth => 'S';

  @override
  String get qiblaDirectionWest => 'W';

  @override
  String get qiblaDirection => 'Qibla Direction';

  @override
  String get qiblaCurrentLocation => 'Current Location';

  @override
  String get qiblaRecalibrate => 'Recalibrate';

  @override
  String get qiblaUpdateLocation => 'Update Location';

  @override
  String get onboardingNotificationDescription1 =>
      'Stay connected with your daily prayers';

  @override
  String get onboardingNotificationDescription2 =>
      'Receive timely reminders for Islamic practices';

  @override
  String get onboardingNotificationSelectPrayers =>
      'Select which prayers you\'d like to be reminded about';
}

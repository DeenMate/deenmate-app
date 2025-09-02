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
  String get onboardingLocationTitle => 'Location';

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
  String get onboardingMadhhabTitle => 'Select Your Mazhab';

  @override
  String get onboardingMadhhabSubtitle =>
      'Choose your school of Islamic jurisprudence for prayer calculations';

  @override
  String get onboardingMadhhabMostWidelyFollowed =>
      'Most widely followed mazhab';

  @override
  String get onboardingMadhhabOtherSchools => 'Other major schools of thought';

  @override
  String get madhhabHanafi => 'Hanafi';

  @override
  String get madhhabShafiMalikiHanbali => 'Shafi\'i, Maliki, Hanbali';

  @override
  String get onboardingNotificationsTitle => 'Notifications';

  @override
  String get onboardingNotificationsSubtitle =>
      'Stay connected with prayer reminders';

  @override
  String get onboardingThemeTitle => 'Choose Your Theme';

  @override
  String get hadithTitle => 'Hadith';

  @override
  String get hadithCollections => 'Hadith Collections';

  @override
  String get hadithPopular => 'Popular Hadiths';

  @override
  String get hadithRecentlyRead => 'Recently Read';

  @override
  String get hadithQuickActions => 'Quick Actions';

  @override
  String get hadithSearch => 'Search';

  @override
  String get hadithTopics => 'Topics';

  @override
  String get hadithBookmarks => 'Bookmarks';

  @override
  String hadithReadCount(int count) {
    return 'Read: $count';
  }

  @override
  String hadithCount(int count) {
    return '$count Hadiths';
  }

  @override
  String get hadithNoCollections => 'No Hadith collections found';

  @override
  String get hadithNoPopular => 'No popular hadiths';

  @override
  String get hadithNoRecentlyRead => 'No recently read hadiths';

  @override
  String get hadithErrorLoadingCollections => 'Error loading collections';

  @override
  String get hadithErrorLoadingPopular => 'Error loading popular hadiths';

  @override
  String get hadithErrorLoadingRecentlyRead => 'Error loading recently read';

  @override
  String get hadithSearchTitle => 'Hadith Search';

  @override
  String get hadithSearchHint => 'Search for hadiths...';

  @override
  String get hadithSearching => 'Searching...';

  @override
  String get hadithSearchEmpty => 'Search for Hadiths';

  @override
  String get hadithSearchEmptySubtitle => 'Search using keywords';

  @override
  String get hadithNoResults => 'No results found';

  @override
  String hadithNoResultsForQuery(String query) {
    return 'No hadiths found for \"$query\"';
  }

  @override
  String get hadithSearchError => 'Error occurred while searching';

  @override
  String get hadithTryAgain => 'Try Again';

  @override
  String hadithResultsFound(int count) {
    return '$count hadiths found';
  }

  @override
  String hadithNarrator(String name) {
    return 'Narrator: $name';
  }

  @override
  String get hadithFilters => 'Filters';

  @override
  String get hadithCollection => 'Collection';

  @override
  String get hadithGrade => 'Grade';

  @override
  String get hadithAll => 'All';

  @override
  String get hadithTodaysHadith => 'Today\'s Hadith';

  @override
  String get hadithSearchHintWithShortcut => 'Search hadiths (Ctrl+K)';

  @override
  String get hadithPopularBooks => 'Popular Books';

  @override
  String get hadithPopularTopics => 'Popular Topics';

  @override
  String get hadithExploreMore => 'Explore More';

  @override
  String get hadithViewAll => 'View All';

  @override
  String get hadithBooksTitle => 'Hadith Books';

  @override
  String get hadithMainTitle => 'Hadith';

  @override
  String get onboardingThemeSubtitle => 'Select your preferred visual style';

  @override
  String get onboardingCompleteTitle => 'Setup Complete!';

  @override
  String get onboardingCompleteSubtitle => 'Your DeenMate app is ready to use';

  @override
  String get onboardingFeaturesTitle => 'Features';

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get errorSavingPreferences => 'Error saving preferences';

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
  String get timingsFromAlAdhan => 'Prayer Times from Al-Adhan';

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
  String get commonLoading => 'لوڈ ہو رہا ہے...';

  @override
  String get commonPleaseWait => 'Please wait...';

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
  String get errorLanguageChangeFailed =>
      'Failed to save language preference. Please try again.';

  @override
  String get errorLanguageChangeGeneric =>
      'An error occurred. Please try again.';

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
  String get buttonDelete => 'Delete';

  @override
  String get buttonEdit => 'Edit';

  @override
  String get buttonCopy => 'Copy';

  @override
  String get buttonShare => 'Share';

  @override
  String get buttonView => 'View';

  @override
  String get buttonStart => 'Start';

  @override
  String get buttonStop => 'Stop';

  @override
  String get verseBookmark => 'Bookmark verse';

  @override
  String get verseRemoveBookmark => 'Remove bookmark';

  @override
  String get verseCopy => 'Copy verse';

  @override
  String get verseShare => 'Share verse';

  @override
  String get verseViewTafsir => 'View tafsir';

  @override
  String get verseLoadingTranslation => 'Loading translation...';

  @override
  String get statusUnknown => 'Unknown';

  @override
  String get readingPlansTitle => 'Reading Plans';

  @override
  String get readingPlansMyPlans => 'My Plans';

  @override
  String get readingPlansToday => 'Today';

  @override
  String get readingPlansStats => 'Stats';

  @override
  String get readingPlansNewPlan => 'New Plan';

  @override
  String get readingPlansActive => 'ACTIVE';

  @override
  String get readingPlansProgress => 'Progress';

  @override
  String get readingPlansDays => 'Days';

  @override
  String get readingPlansVersesPerDay => 'Verses/Day';

  @override
  String get readingPlansTodaysReading => 'Today\'s Reading';

  @override
  String get readingPlansStartReading => 'Start Reading';

  @override
  String get readingPlansStartPlan => 'Start Plan';

  @override
  String get readingPlansStopPlan => 'Stop Plan';

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
  String get prayerSuhurReminder => 'Suhur Reminder';

  @override
  String get prayerIftarReminder => 'Iftar Reminder';

  @override
  String prayerSuhurReminderText(int minutes) {
    return 'Remind me $minutes minutes before Fajr for Suhur';
  }

  @override
  String prayerIftarReminderText(int minutes) {
    return 'Remind me $minutes minutes before Maghrib for Iftar';
  }

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
  String get ramadanMubarak => 'Ramadan Mubarak!';

  @override
  String get ramadanStatus => 'Ramadan Status';

  @override
  String ramadanDaysRemaining(int days) {
    return '$days days remaining in this blessed month';
  }

  @override
  String get ramadanBlessedMonth => 'The blessed month of fasting';

  @override
  String get ramadanSettingsInfo =>
      'Ramadan settings will be active during the holy month';

  @override
  String get errorUnableToLoadSettings => 'Unable to load settings';

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
  String get mobileReadingModeTitle => 'Reading Mode';

  @override
  String get mobileReadingModeProgress => 'Reading Progress';

  @override
  String get mobileReadingModeTheme => 'Theme';

  @override
  String get mobileReadingModeFont => 'Font';

  @override
  String get mobileReadingModeTranslation => 'Translation';

  @override
  String get mobileReadingModeBookmark => 'Bookmark';

  @override
  String get mobileReadingModePrevious => 'Previous';

  @override
  String get mobileReadingModeNext => 'Next';

  @override
  String get mobileReadingModeSettings => 'Reading Settings';

  @override
  String get mobileReadingModeBrightness => 'Screen Brightness';

  @override
  String get mobileReadingModeLineHeight => 'Line Height';

  @override
  String get mobileReadingModeNightMode => 'Night Mode';

  @override
  String get mobileReadingModeGreenTheme => 'Green Theme';

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
  String get bookmarkEdit => 'Edit';

  @override
  String get bookmarkShare => 'Share';

  @override
  String get bookmarkDelete => 'Delete';

  @override
  String get quranFontSettings => 'Font Settings';

  @override
  String get quranTranslationSettings => 'Translation Settings';

  @override
  String get quranContent => 'Content';

  @override
  String get quranArabic => 'Arabic';

  @override
  String get quranTranslation => 'Translation';

  @override
  String get quranTafsir => 'Tafsir';

  @override
  String get quranArabicFontSize => 'Arabic Font Size';

  @override
  String get quranTranslationFontSize => 'Translation Font Size';

  @override
  String get quranSura => 'Sura';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get errorLoadingPage => 'Error loading page';

  @override
  String get downloadFailed => 'Download failed';

  @override
  String get bookmarkRemoved => 'Bookmark removed';

  @override
  String get errorRemovingBookmark => 'Error removing bookmark';

  @override
  String get sortOptionsComingSoon => 'Sort options - Coming soon';

  @override
  String get manageCategoriesComingSoon => 'Manage categories - Coming soon';

  @override
  String get exportBookmarksComingSoon => 'Export bookmarks - Coming soon';

  @override
  String get editBookmarkComingSoon => 'Edit bookmark - Coming soon';

  @override
  String get addBookmarkDialogComingSoon => 'Add bookmark dialog - Coming soon';

  @override
  String get createCategoryDialogComingSoon =>
      'Create category dialog - Coming soon';

  @override
  String get editCategoryComingSoon => 'Edit category - Coming soon';

  @override
  String get deleteCategoryComingSoon => 'Delete category - Coming soon';

  @override
  String get clearCacheFailed => 'Failed to clear cache';

  @override
  String get quarterSection => 'Quarter section';

  @override
  String get verses => 'Verses';

  @override
  String get selected => 'selected';

  @override
  String get autoScroll => 'Auto Scroll';

  @override
  String get quickSettings => 'Quick settings';

  @override
  String get enterReadingMode => 'Enter reading mode';

  @override
  String get exitReadingMode => 'Exit reading mode';

  @override
  String get onboardingNotificationDescription1 =>
      'Stay connected with your daily prayers';

  @override
  String get onboardingNotificationDescription2 =>
      'Receive timely reminders for Islamic practices';

  @override
  String get onboardingNotificationSelectPrayers =>
      'Select which prayers you\'d like to be reminded about';

  @override
  String get bookmarks => 'Bookmarks';

  @override
  String get bookmarkAll => 'All';

  @override
  String get bookmarkCategories => 'Categories';

  @override
  String get bookmarkRecent => 'Recent';

  @override
  String get bookmarkSort => 'Sort';

  @override
  String get bookmarkManageCategories => 'Manage Categories';

  @override
  String get bookmarkExport => 'Export';

  @override
  String get bookmarkNoBookmarksYet => 'No bookmarks yet';

  @override
  String get bookmarkNoBookmarksSubtitle =>
      'Bookmark verses while reading to save them here';

  @override
  String get bookmarkNoCategoriesYet => 'No categories yet';

  @override
  String get bookmarkNoCategoriesSubtitle =>
      'Create categories to organize your bookmarks';

  @override
  String get bookmarkCreateCategory => 'Create Category';

  @override
  String get bookmarkNoRecentBookmarks => 'No recent bookmarks';

  @override
  String get bookmarkNoRecentSubtitle =>
      'Your recently added bookmarks will appear here';

  @override
  String get edit => 'Edit';

  @override
  String get share => 'Share';

  @override
  String get commonCopy => 'Copy';

  @override
  String get duaCopiedToClipboard => 'Dua copied to clipboard';

  @override
  String get sharingSoon => 'Sharing feature coming soon!';

  @override
  String get duaSavedToFavorites => 'Dua saved to favorites!';

  @override
  String get accessibilitySettings => 'Accessibility Settings';

  @override
  String get verseCopiedToClipboard => 'Verse copied to clipboard';

  @override
  String get verseSavedToFavorites => 'Verse saved to favorites!';

  @override
  String get learnMore => 'Learn More';

  @override
  String get nameOfAllahCopied => 'Name of Allah copied to clipboard';

  @override
  String get detailedExplanationsSoon => 'Detailed explanations coming soon!';

  @override
  String get hadithCopiedToClipboard => 'Hadith copied to clipboard';

  @override
  String get hadithSavedToFavorites => 'Hadith saved to favorites!';

  @override
  String get retry => 'Retry';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonClear => 'Clear';

  @override
  String get commonView => 'View';

  @override
  String get commonGo => 'Go';

  @override
  String get commonDownload => 'Download';

  @override
  String get commonSendEmail => 'Send Email';

  @override
  String get commonHelp => 'Help';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get navigationExitDialogTitle => 'Exit DeenMate';

  @override
  String get navigationExitDialogMessage =>
      'Are you sure you want to exit the app?';

  @override
  String get prayerCalculationMethodsTitle => 'Prayer Calculation Methods';

  @override
  String get prayerCalculationMethodsApplyMethod => 'Apply Method';

  @override
  String get prayerCalculationMethodsCreateCustom => 'Create Custom Method';

  @override
  String get settingsMoreFeatures => 'More Features';

  @override
  String get athanSettingsVibration => 'Vibration';

  @override
  String get athanSettingsVibrationSubtitle => 'Vibrate device during Athan';

  @override
  String get athanSettingsQuickActions => 'Quick Actions';

  @override
  String get athanSettingsQuickActionsSubtitle =>
      'Show \"Mark as Prayed\" and \"Snooze\" buttons';

  @override
  String get athanSettingsAutoComplete => 'Auto-complete';

  @override
  String get athanSettingsAutoCompleteSubtitle =>
      'Automatically mark prayer as completed';

  @override
  String get athanSettingsAddMuteTimeRange => 'Add Mute Time Range';

  @override
  String get athanSettingsSmartNotifications => 'Smart Notifications';

  @override
  String get athanSettingsSmartNotificationsSubtitle =>
      'Adjust notifications based on your activity';

  @override
  String get athanSettingsOverrideDnd => 'Override Do Not Disturb';

  @override
  String get athanSettingsOverrideDndSubtitle =>
      'Show prayer notifications even in DND mode';

  @override
  String get athanSettingsFullScreenNotifications =>
      'Full Screen Notifications';

  @override
  String get athanSettingsFullScreenNotificationsSubtitle =>
      'Show prayer time as full screen alert';

  @override
  String get permissionsGrant => 'Grant';

  @override
  String get athanNotificationsTitle => 'Athan & Notifications';

  @override
  String get athanTabTitle => 'Athan';

  @override
  String get prayersTabTitle => 'Prayers';

  @override
  String get advancedTabTitle => 'Advanced';

  @override
  String get ramadanTabTitle => 'Ramadan';

  @override
  String get athanSettingsTitle => 'Athan Settings';

  @override
  String get athanSettingsSubtitle =>
      'Call to prayer notifications when prayer time arrives';

  @override
  String get prayerNotificationsTitle => 'Prayer Notifications';

  @override
  String get prayerNotificationsSubtitle =>
      'Customize notifications for each prayer';

  @override
  String get preciseTimingRecommended => 'Precise timing recommended for Athan';

  @override
  String get advancedSettingsTitle => 'Advanced Settings';

  @override
  String get advancedSettingsSubtitle => 'Fine-tune notification behavior';

  @override
  String get ramadanSettingsTitle => 'Ramadan Settings';

  @override
  String get ramadanSettingsSubtitle =>
      'Special notifications for the holy month';

  @override
  String get notificationsEnabled => 'Notifications are enabled';

  @override
  String get notificationsDisabled => 'Notifications are disabled';

  @override
  String get audioSettingsTitle => 'Audio Settings';

  @override
  String get durationLabel => 'Duration: ';

  @override
  String get reminderTimeTitle => 'Reminder Time';

  @override
  String get reminderTimeSubtitle =>
      'Notify me this many minutes before prayer time:';

  @override
  String get choosePrayerNotifications =>
      'Choose which prayers to receive notifications for:';

  @override
  String get notificationActionsTitle => 'Notification Actions';

  @override
  String get muteSettingsTitle => 'Mute Settings';

  @override
  String get muteSettingsSubtitle =>
      'Configure when notifications should be silenced:';

  @override
  String get mutedDaysLabel => 'Muted Days:';

  @override
  String get monday => 'Monday';

  @override
  String get tuesday => 'Tuesday';

  @override
  String get wednesday => 'Wednesday';

  @override
  String get thursday => 'Thursday';

  @override
  String get friday => 'Friday';

  @override
  String get saturday => 'Saturday';

  @override
  String get sunday => 'Sunday';

  @override
  String get methodsRecommended => 'Recommended';

  @override
  String get methodsAllMethods => 'All Methods';

  @override
  String get methodsCompare => 'Compare';

  @override
  String get methodsLocationBasedRecommendations =>
      'Location-Based Recommendations';

  @override
  String get methodsLocationRecommendationText =>
      'These methods are recommended for your region. Location detection would normally determine this automatically.';

  @override
  String get methodsAllAvailableMethods => 'All Available Methods';

  @override
  String methodsFromOrganizations(int count) {
    return '$count calculation methods from Islamic organizations worldwide.';
  }

  @override
  String get methodComparison => 'Method Comparison';

  @override
  String get methodComparisonDescription =>
      'Select two methods to compare their angles and characteristics.';

  @override
  String get methodComparisonMethod1 => 'Method 1';

  @override
  String get methodComparisonMethod2 => 'Method 2';

  @override
  String get methodUnknownOrganization => 'Unknown Organization';

  @override
  String methodAngleFormat(String label, String angle) {
    return '$label: $angle°';
  }

  @override
  String get methodsAboutTooltip => 'About Calculation Methods';

  @override
  String get methodsHideComparisonTooltip => 'Hide Comparison';

  @override
  String get methodsApplyMethod => 'Apply Method';

  @override
  String get methodsCustom => 'Custom';

  @override
  String get methodsUnknownOrganization => 'Unknown Organization';

  @override
  String get methodsNotAvailable => 'N/A';

  @override
  String get methodsImpactAssessment => 'Impact Assessment:';

  @override
  String get methodsFajr => 'Fajr';

  @override
  String get methodsIsha => 'Isha';

  @override
  String get methodsSelectMethod => 'Select a calculation method';

  @override
  String get methodsComparisonResults => 'Comparison Results';

  @override
  String get methodsFajrAngle => 'Fajr Angle';

  @override
  String get methodsIshaAngle => 'Isha Angle';

  @override
  String get methodsOrganization => 'Organization';

  @override
  String get methodsRetry => 'Retry';

  @override
  String get methodsYourLocation => 'Your Location';

  @override
  String get methodsRecommendedMethods => 'Recommended Methods';

  @override
  String get methodsCustomMethod => 'Custom Method';

  @override
  String get methodsCustomMethodCreator => 'Custom Method Creator';

  @override
  String get methodsCreateCustomMethod => 'Create Custom Method';

  @override
  String get methodsView => 'View';

  @override
  String get methodsAboutCalculationMethods => 'About Calculation Methods';

  @override
  String get methodsGotIt => 'Got it';

  @override
  String get unableToLoadLocation => 'Unable to load location';

  @override
  String get locationIsNeeded =>
      'Location is needed to show recommended methods';

  @override
  String get athanSettingsRetry => 'Retry';

  @override
  String get athanSettingsFeatureComingSoon => 'Feature coming soon...';

  @override
  String get athanSettingsTestStarted => 'Athan audio test started';

  @override
  String get athanSettingsTestFailed => 'Athan test failed';

  @override
  String get athanSettingsTestAthanAudio => 'Test Athan Audio';

  @override
  String get athanSettingsNotificationsScheduled =>
      'Notifications scheduled for today';

  @override
  String get athanSettingsSchedulingFailed => 'Scheduling failed';

  @override
  String get athanSettingsScheduleNow => 'Schedule Now';

  @override
  String get athanSettingsDebugFailed => 'Debug failed';

  @override
  String get athanSettingsDebugInfo => 'Debug Info';

  @override
  String get athanSettingsPrayerNotificationsScheduled =>
      'Prayer notifications scheduled for today';

  @override
  String get athanSettingsTestNotificationFailed => 'Test notification failed';

  @override
  String get athanSettingsSchedulePrayerNotifications =>
      'Schedule Prayer Notifications';

  @override
  String get athanSettingsTestNotificationSent =>
      'Test notification sent immediately!';

  @override
  String get athanSettingsTestNotification1Sec => 'Test Notification (1 sec)';

  @override
  String get athanSettingsDemoNotificationSent =>
      'Demo notification sent! Azan should play now.';

  @override
  String get athanSettingsDemoNotificationFailed => 'Demo notification failed';

  @override
  String get athanSettingsDemoNotification2Min => 'Demo Notification (2 min)';

  @override
  String get athanSettingsImmediateNotificationSent =>
      'Immediate notification sent!';

  @override
  String quranReaderLoadError(String errorMessage) {
    return 'Failed to load: $errorMessage';
  }

  @override
  String get quranReaderAudioManager => 'Audio Manager';

  @override
  String get quranReaderAutoScroll => 'Auto Scroll';

  @override
  String get quranReaderEnableAutoScroll => 'Enable Auto Scroll';

  @override
  String get quranReaderQuickJump => 'Quick Jump';

  @override
  String get quranReaderCopyArabicText => 'Copy Arabic Text';

  @override
  String get quranReaderCopyArabicSubtitle => 'Copy only the Arabic verse';

  @override
  String get quranReaderCopyTranslation => 'Copy Translation';

  @override
  String get quranReaderCopyTranslationSubtitle => 'Copy only the translation';

  @override
  String get quranReaderCopyFullVerse => 'Copy Full Verse';

  @override
  String get quranReaderCopyFullVerseSubtitle =>
      'Copy Arabic text with translation';

  @override
  String get quranReaderReportError => 'Report Translation Error';

  @override
  String get quranReaderReportErrorSubtitle =>
      'Help improve translation accuracy';

  @override
  String get quranReaderReportErrorDialogTitle => 'Report Translation Error';

  @override
  String get quranVerseCopiedToClipboard => 'Verse copied to clipboard';

  @override
  String get bookmarksAddBookmark => 'Add Bookmark';

  @override
  String get bookmarksAddBookmarkComingSoon =>
      'Add bookmark dialog - Coming soon';

  @override
  String get bookmarksCreateCategoryComingSoon =>
      'Create category dialog - Coming soon';

  @override
  String get bookmarksSortOptionsComingSoon => 'Sort options - Coming soon';

  @override
  String get bookmarksManageCategoriesComingSoon =>
      'Manage categories - Coming soon';

  @override
  String get bookmarksExportBookmarksComingSoon =>
      'Export bookmarks - Coming soon';

  @override
  String get readingPlansMarkComplete => 'Mark Complete';

  @override
  String get readingPlansCreatePlan => 'Create Plan';

  @override
  String get readingPlansDeletePlan => 'Delete Plan';

  @override
  String readingPlansDeletePlanConfirm(String planName) {
    return 'Are you sure you want to delete \"$planName\"?';
  }

  @override
  String get readingPlansCreatePlanTitle => 'Create Reading Plan';

  @override
  String get readingPlansThirtyDay => '30-Day';

  @override
  String get readingPlansRamadan => 'Ramadan';

  @override
  String get readingPlansCustom => 'Custom';

  @override
  String get readingPlansPlanCreatedSuccess =>
      'Reading plan created successfully!';

  @override
  String get quickTools => 'Quick Tools';

  @override
  String get navigation => 'Navigation';

  @override
  String get readingControls => 'Reading Controls';

  @override
  String get actions => 'Actions';

  @override
  String get jumpToVerse => 'Jump to Verse';

  @override
  String get fontSizeIncrease => 'Font +';

  @override
  String get fontSizeDecrease => 'Font -';

  @override
  String get theme => 'Theme';

  @override
  String get translation => 'Translation';

  @override
  String get addBookmark => 'Bookmark';

  @override
  String get removeBookmark => 'Bookmarked';

  @override
  String get surah => 'Surah';

  @override
  String get page => 'Page';

  @override
  String get juz => 'Juz';

  @override
  String get playAudio => 'Play Audio';

  @override
  String get moreActions => 'More Actions';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get copy => 'Copy';

  @override
  String get textSize => 'Text Size';

  @override
  String get translate => 'Translate';

  @override
  String get audioPlaying => 'Audio playing...';

  @override
  String get bookmarkAdded => 'Bookmark added';

  @override
  String get verseShared => 'Verse shared';

  @override
  String get moreOptionsOpened => 'More options opened';

  @override
  String get actionCompleted => 'Action completed';

  @override
  String get textSizeAdjustment => 'Text size adjustment';

  @override
  String get translationOptions => 'Translation options';

  @override
  String get copyOptions => 'Copy Options';

  @override
  String get copyArabicText => 'Copy Arabic Text';

  @override
  String get copyArabicSubtitle => 'Copy only the Arabic verse';

  @override
  String get copyTranslation => 'Copy Translation';

  @override
  String get copyTranslationSubtitle => 'Copy only the translation';

  @override
  String get copyFullVerse => 'Copy Full Verse';

  @override
  String get copyFullVerseSubtitle => 'Copy Arabic text with translation';

  @override
  String get arabicTextCopied => 'Arabic text copied';

  @override
  String get translationCopied => 'Translation copied';

  @override
  String get fullVerseCopied => 'Full verse copied';

  @override
  String get tapForActions => 'Tap for actions';

  @override
  String get swipeForQuickActions => 'Swipe for quick actions';

  @override
  String get fontControls => 'Font Controls';

  @override
  String get arabicText => 'Arabic Text';

  @override
  String get resetFontSizes => 'Reset Font Sizes';

  @override
  String get preview => 'Preview';

  @override
  String get arabicFontAdjusted => 'Arabic font size adjusted';

  @override
  String get translationFontAdjusted => 'Translation font size adjusted';

  @override
  String get fontSizesReset => 'Font sizes reset to default';

  @override
  String get audioNext => 'Next';

  @override
  String get audioPrevious => 'Previous';

  @override
  String get audioRepeat => 'Repeat';

  @override
  String get audioSpeed => 'Speed';

  @override
  String get audioSeekForward => 'Seek forward 10 seconds';

  @override
  String get audioSeekBackward => 'Seek backward 10 seconds';

  @override
  String get audioNoTrackSelected => 'No track selected';

  @override
  String get close => 'Close';

  @override
  String get hadithSearchDetailedHint =>
      'Search hadiths... (e.g., intention, deed)';

  @override
  String get hadithSearchButton => 'Search';

  @override
  String get hadithSearchingProgress => 'Searching...';

  @override
  String get hadithPopularSearches => 'Popular Searches';

  @override
  String get hadithRecentSearches => 'Recent Searches';

  @override
  String get hadithNoRecentSearches => 'No recent searches yet';

  @override
  String get hadithSearchLoadingMessage => 'Searching hadiths...';

  @override
  String get hadithNoResultsFound => 'No hadiths found';

  @override
  String hadithNoResultsFoundDetails(String query) {
    return 'No hadiths found for \'$query\'. Try searching for something else.';
  }

  @override
  String get hadithTryDifferentSearch => 'Try Different Search';

  @override
  String get hadithClearSearch => 'Clear Search';

  @override
  String get hadithChangeFilter => 'Change Filter';

  @override
  String hadithSearchContextFor(String query) {
    return 'for \'$query\'';
  }

  @override
  String get hadithBooksScreenTitle => 'Hadith Books';

  @override
  String get hadithBooksSearchHint => 'Search hadith books...';

  @override
  String get hadithBooksFilterAll => 'All Books';

  @override
  String get hadithBooksFilterPopular => 'Popular';

  @override
  String get hadithBooksFilterKutubSittah => 'Kutub Sittah';

  @override
  String hadithBooksCountText(int count) {
    return '$count hadiths';
  }

  @override
  String get hadithBooksPopularLabel => 'Popular';

  @override
  String get hadithBooksNoBooksFound => 'No books found';

  @override
  String get hadithBooksEmptyStateSubtitle =>
      'Try searching for something else or change your filter';

  @override
  String get hadithBooksShowAllBooks => 'Show all books';

  @override
  String get hadithPopularBooksSubtitle =>
      'Valuable hadith collections to organize life in the light of Islam';

  @override
  String get hadithPopularTopicsSubtitle =>
      'Subject-wise hadith collections helpful in all areas of life';

  @override
  String hadithTotalCount(int count) {
    return 'Total hadiths $count';
  }

  @override
  String get hadithBookmarkTitle => 'Bookmark';

  @override
  String get hadithBookmarkSubtitle => 'Saved hadiths';

  @override
  String get hadithQuickAccess => 'Quick Access';

  @override
  String get hadithAdvancedSearch => 'Advanced Search';

  @override
  String get hadithAdvancedSearchSubtitle => 'Search in detail';

  @override
  String get hadithDetailCopy => 'Copy';

  @override
  String get hadithDetailShare => 'Share';

  @override
  String get hadithDetailSettings => 'Settings';

  @override
  String hadithDetailNumber(String number) {
    return 'Hadith number $number';
  }

  @override
  String get hadithDetailArabicText => 'Arabic';

  @override
  String get hadithDetailTranslation => 'Bengali Translation';

  @override
  String get hadithDetailFontSize => 'Font Size';

  @override
  String get hadithDetailArabicLabel => 'Arabic';

  @override
  String get hadithDetailTranslationLabel => 'Translation';

  @override
  String get hadithDetailReferenceInfo => 'Reference Information';

  @override
  String get hadithDetailNarrator => 'Narrator';

  @override
  String get hadithDetailChapter => 'Chapter';

  @override
  String get hadithDetailGrade => 'Grade';

  @override
  String get hadithDetailReference => 'Reference';

  @override
  String get hadithDetailRelatedTopics => 'Related Topics';

  @override
  String get hadithDetailCopyFull => 'Copy Full';

  @override
  String get hadithDetailShareButton => 'Share';

  @override
  String get hadithDetailBookmarkAdded => 'Hadith bookmarked';

  @override
  String get hadithDetailBookmarkRemoved => 'Bookmark removed';

  @override
  String get hadithDetailCopied => 'Copied';

  @override
  String get hadithDetailShared => 'Shared';

  @override
  String hadithShareTemplate(String arabicText, String bengaliText,
      String reference, String narrator) {
    return '$arabicText\n\n$bengaliText\n\nReference: $reference\nNarrator: $narrator';
  }

  @override
  String hadithTopicFormat(String order, String name) {
    return '$order $name';
  }

  @override
  String hadithReferenceLabel(String reference) {
    return 'Reference: $reference';
  }

  @override
  String hadithNarratorLabel(String narrator) {
    return 'Narrator: $narrator';
  }

  @override
  String hadithChapterLabel(String chapter) {
    return 'Chapter: $chapter';
  }

  @override
  String get quranAudioManager => 'Audio Manager';

  @override
  String get quranReciterLabel => 'Reciter:';

  @override
  String quranFailedToLoadReciters(String error) {
    return 'Failed to load reciters: $error';
  }

  @override
  String get audioDownloadStarting => 'Starting download...';

  @override
  String audioDownloadProgress(String name, num progress) {
    return 'Downloading $name: $progress%';
  }

  @override
  String get audioDownloadComplete => 'Download complete';

  @override
  String audioStorageUsed(String size) {
    return 'Storage used: $size';
  }

  @override
  String get audioSelectReciter => 'Select reciter';

  @override
  String get zakatTitle => 'Zakat Calculator';

  @override
  String get zakatResetDialogTitle => 'Reset Calculator';

  @override
  String get zakatResetDialogMessage => 'Clear all entered data?';

  @override
  String get zakatResetSuccess => 'Calculator reset successfully';

  @override
  String get zakatResetFormTooltip => 'Reset Form';

  @override
  String get zakatCalculate => 'Calculate Zakat';

  @override
  String get zakatCalculating => 'Calculating...';

  @override
  String get commonReset => 'Reset';

  @override
  String get quranGoToAyahHint => 'Go to Ayah (chapter:verse)';

  @override
  String get quranExampleAyahHint => 'e.g., 2:255';

  @override
  String get quranGoButton => 'Go';

  @override
  String get quranVerseOptions => 'Verse Options';

  @override
  String quranJuzItem(int number) {
    return 'Juz $number';
  }

  @override
  String zakatCalcError(String error) {
    return 'Error calculating Zakat: $error';
  }

  @override
  String get zakatCalculationSuccess =>
      'Zakat calculation completed successfully';

  @override
  String zakatUnableToLoadNisab(String error) {
    return 'Unable to load Nisab information: $error';
  }

  @override
  String get zakatCalculationError => 'Calculation Error';

  @override
  String get zakatAboutTitle => 'About Zakat';

  @override
  String get zakatAboutBody =>
      'Zakat is one of the Five Pillars of Islam and represents 2.5% of your wealth that must be given to those in need when your assets exceed the Nisab threshold for a full lunar year.';

  @override
  String get zakatCurrencyLabel => 'Currency';

  @override
  String zakatCurrencyName(String code) {
    return '$code';
  }

  @override
  String get zakatInvalidAmount => 'Please enter a valid amount';

  @override
  String methodsAllAvailableMethodsCount(int count) {
    return 'Choose from all $count available calculation methods used worldwide.';
  }

  @override
  String get methodsCreateCustomAngles =>
      'Create your own calculation method with custom angles.';

  @override
  String methodsApplied(String name) {
    return 'Applied \"$name\" calculation method';
  }

  @override
  String methodsApplyFailed(String error) {
    return 'Failed to apply method: $error';
  }

  @override
  String get methodsInfoFajrAngle =>
      '• Fajr Angle: Determines morning prayer time';

  @override
  String get methodsInfoIshaAngle =>
      '• Isha Angle: Determines night prayer time';

  @override
  String get methodsInfoRegionalPref =>
      '• Regional Preferences: Based on local scholarly consensus';

  @override
  String get methodsInfoMadhabDiff =>
      '• Madhab Differences: Mainly affect Asr calculation';

  @override
  String get methodsCustomComingSoon =>
      'Custom method creation will be available in a future update.';

  @override
  String get athanSettingsTestNotificationMessage =>
      'This is a test prayer notification';

  @override
  String get athanSettingsDemoNotificationMessage =>
      'This is a demo prayer notification with Azan';

  @override
  String get athanSettingsImmediateTestMessage =>
      'This is an immediate test notification';

  @override
  String get labelImmediateNotification => 'Immediate Notification';

  @override
  String get qiblaCalibrateFigure8 =>
      'Please calibrate your compass by moving your device in a figure-8 pattern';

  @override
  String get qiblaErrorInitializingCompass => 'Error initializing compass';

  @override
  String get qiblaErrorGettingLocation => 'Error getting location';

  @override
  String get qiblaCalibratingCompass => 'Calibrating Compass...';

  @override
  String get qiblaDirectionPerfect => 'Perfect Direction';

  @override
  String get qiblaTurnRight => 'Turn Right';

  @override
  String get qiblaTurnAround => 'Turn Around';

  @override
  String get qiblaTurnLeft => 'Turn Left';

  @override
  String get qiblaAccuracyExcellent => 'Excellent';

  @override
  String get qiblaAccuracyGood => 'Good';

  @override
  String get qiblaAccuracyFair => 'Fair';

  @override
  String get qiblaAccuracyPoor => 'Poor';

  @override
  String get qiblaError => 'Qibla Error';

  @override
  String get qiblaErrorHelp =>
      'Please check your device settings and try again.';

  @override
  String get qiblaCalibrateCompass => 'Calibrate Compass';

  @override
  String get qiblaHelpTitle => 'Qibla Help';

  @override
  String get qiblaHelpCommonIssues => 'Common Issues:';

  @override
  String get qiblaHelpLocationPermission => 'Location Permission';

  @override
  String get qiblaHelpLocationPermissionText =>
      'Make sure location services are enabled and permission is granted.';

  @override
  String get qiblaHelpCompassSensor => 'Compass Sensor';

  @override
  String get qiblaHelpCompassSensorText =>
      'Ensure your device has a compass sensor and it\'s working properly.';

  @override
  String get qiblaHelpCalibration => 'Calibration';

  @override
  String get qiblaHelpCalibrationText =>
      'Move your device in a figure-8 pattern to calibrate the compass.';

  @override
  String onboardingStepOfTotal(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get onboardingLocationPermissionTitle => 'Allow Location Access';

  @override
  String get onboardingLocationPermissionBody =>
      'To provide accurate prayer times, DeenMate needs access to your location. Please enable location permissions in your device settings.';

  @override
  String get locationCurrentLocation => 'Current Location';

  @override
  String get locationAutoDetected => 'Auto-detected';

  @override
  String get locationAutoTimezone => 'Auto';

  @override
  String get onboardingSelectLocation => 'Select Your Location';

  @override
  String get commonCountry => 'Country';

  @override
  String get commonCity => 'City';

  @override
  String get onboardingTapToContinue => 'Tap to continue';

  @override
  String get onboardingFeatureAccuratePrayerTimes => 'Accurate Prayer Times';

  @override
  String get onboardingFeatureCompleteQuran => 'Complete Quran Reading';

  @override
  String get onboardingFeatureQibla => 'Qibla Direction';

  @override
  String get onboardingFeatureAzanNotifications => 'Azan Notifications';

  @override
  String get onboardingEnableAthanAndSalah =>
      'Enable Azan & Salah Notifications?';

  @override
  String get onboardingNotificationsSetupLater =>
      'Notifications setup will be completed later. You can enable them in settings.';

  @override
  String get onboardingNotificationsSavedWithDefaults =>
      'Notification preferences saved with defaults. You can change them later in settings.';

  @override
  String get onboardingNameTooShort =>
      'Name must be at least 2 characters long';
}

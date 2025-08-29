// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'দীনমেট';

  @override
  String get onboardingWelcomeTitle => 'দীনমেটে স্বাগতম';

  @override
  String get onboardingWelcomeSubtitle => 'আপনার সম্পূর্ণ ইসলামিক সঙ্গী';

  @override
  String get onboardingLanguageTitle => 'আপনার ভাষা নির্বাচন করুন';

  @override
  String get onboardingLanguageSubtitle =>
      'অ্যাপের জন্য আপনার পছন্দের ভাষা নির্বাচন করুন';

  @override
  String get onboardingUsernameTitle => 'আমরা আপনাকে কী বলব?';

  @override
  String get onboardingUsernameSubtitle => 'আপনার নাম বা পছন্দের ডাকনাম লিখুন';

  @override
  String get onboardingLocationTitle => 'আপনার অবস্থান সেট করুন';

  @override
  String get onboardingLocationSubtitle =>
      'এটি আমাদের সঠিক নামাজের সময় প্রদান করতে সাহায্য করে';

  @override
  String get onboardingLocationGpsTitle => 'জিপিএস অবস্থান ব্যবহার করুন';

  @override
  String get onboardingLocationGpsSubtitle =>
      'স্বয়ংক্রিয়ভাবে আপনার বর্তমান অবস্থান সনাক্ত করুন';

  @override
  String get onboardingLocationManualTitle => 'ম্যানুয়াল নির্বাচন';

  @override
  String get onboardingLocationManualSubtitle =>
      'আপনার শহর ম্যানুয়ালি নির্বাচন করুন';

  @override
  String get onboardingUsernameHint => 'আপনার নাম লিখুন';

  @override
  String get onboardingNotificationEnable => 'সক্রিয় করুন';

  @override
  String get onboardingNotificationEnableSubtitle =>
      'নামাজের সময়ের নোটিফিকেশন পান';

  @override
  String get onboardingNotificationDisable => 'নিষ্ক্রিয় করুন';

  @override
  String get onboardingNotificationDisableSubtitle =>
      'শুধুমাত্র নীরব মোড ব্যবহার করুন';

  @override
  String get onboardingCalculationTitle => 'নামাজের সময় গণনা';

  @override
  String get onboardingCalculationSubtitle =>
      'আপনার পছন্দের গণনা পদ্ধতি নির্বাচন করুন';

  @override
  String get onboardingMadhhabTitle => 'আপনার মাযহাব নির্বাচন করুন';

  @override
  String get onboardingMadhhabSubtitle =>
      'আপনার ইসলামিক চিন্তাধারা নির্বাচন করুন';

  @override
  String get onboardingNotificationsTitle => 'বিজ্ঞপ্তি';

  @override
  String get onboardingNotificationsSubtitle =>
      'নামাজের স্মরণিকা দিয়ে সংযুক্ত থাকুন';

  @override
  String get onboardingThemeTitle => 'আপনার থিম নির্বাচন করুন';

  @override
  String get onboardingThemeSubtitle =>
      'আপনার পছন্দের দৃশ্য শৈলী নির্বাচন করুন';

  @override
  String get onboardingCompleteTitle => 'আপনি প্রস্তুত!';

  @override
  String get onboardingCompleteSubtitle =>
      'দীনমেটে স্বাগতম। চলুন আপনার যাত্রা শুরু করি।';

  @override
  String get navigationHome => 'হোম';

  @override
  String get navigationQuran => 'কুরআন';

  @override
  String get navigationHadith => 'হাদিস';

  @override
  String get navigationMore => 'আরও';

  @override
  String get prayerTimesTitle => 'নামাজের সময়';

  @override
  String get prayerFajr => 'ফজর';

  @override
  String get prayerSunrise => 'সূর্যোদয়';

  @override
  String get prayerDhuhr => 'যুহর';

  @override
  String get prayerAsr => 'আসর';

  @override
  String get prayerMaghrib => 'মাগরিব';

  @override
  String get prayerIsha => 'ইশা';

  @override
  String get nextPrayer => 'পরবর্তী নামাজ';

  @override
  String get currentPrayer => 'বর্তমান নামাজ';

  @override
  String get timeRemaining => 'বাকি সময়';

  @override
  String get quranTitle => 'কুরআন';

  @override
  String get quranLastRead => 'সর্বশেষ পড়া';

  @override
  String get quranContinue => 'চালিয়ে যান';

  @override
  String get quranSearch => 'অনুসন্ধান';

  @override
  String get quranNavigation => 'নেভিগেশন';

  @override
  String get quranSurah => 'সূরা';

  @override
  String get quranPage => 'পৃষ্ঠা';

  @override
  String get quranJuz => 'পারা';

  @override
  String get quranHizb => 'হিজব';

  @override
  String get quranRuku => 'রুকু';

  @override
  String get ramadanSuhoor => 'সাহরি';

  @override
  String get ramadanIftaar => 'ইফতার';

  @override
  String get prayerTimesSource => 'আল-আধান থেকে সময়';

  @override
  String prayerTimesUpdated(String time) {
    return 'আপডেট: $time';
  }

  @override
  String get prayerTimesCurrentPrayer => 'বর্তমান নামাজ';

  @override
  String get prayerTimesNextPrayer => 'পরবর্তী নামাজ';

  @override
  String get prayerTimesNoActivePrayer => 'কোন সক্রিয় নামাজ নেই';

  @override
  String get prayerTimesAzan => 'আজান';

  @override
  String get prayerTimesJamaat => 'জামাত';

  @override
  String prayerTimesEndTime(String time) {
    return 'শেষ সময় - $time';
  }

  @override
  String get settingsTitle => 'সেটিংস';

  @override
  String get settingsNotifications => 'বিজ্ঞপ্তি';

  @override
  String get settingsPrayerReminders => 'নামাজের স্মরণিকা';

  @override
  String get settingsTheme => 'থিম';

  @override
  String get settingsLanguage => 'ভাষা';

  @override
  String get settingsCalculationMethod => 'গণনা পদ্ধতি';

  @override
  String get settingsPrayerSettings => 'নামাজের সেটিংস';

  @override
  String get settingsAthanSettings => 'আজানের সেটিংস';

  @override
  String get settingsAthanSubtitle => 'আজানের কাস্টমাইজেশন';

  @override
  String get settingsPrayerNotifications => 'নামাজের বিজ্ঞপ্তি';

  @override
  String get settingsPrayerNotificationsSubtitle =>
      'নামাজের সময়ের অনুস্মারক সক্রিয় করুন';

  @override
  String get settingsPrayerRemindersSubtitle =>
      'নামাজের সময়ের জন্য অনুস্মারক পান';

  @override
  String get settingsIslamicMidnight => 'ইসলামিক মধ্যরাত';

  @override
  String get settingsIslamicMidnightSubtitle =>
      'ইসলামিক ঐতিহ্য অনুযায়ী মধ্যরাত গণনা করুন';

  @override
  String get settingsIslamicContent => 'ইসলামিক কন্টেন্ট';

  @override
  String get settingsDailyVerses => 'দৈনিক আয়াত';

  @override
  String get settingsDailyVersesSubtitle => 'দৈনিক কুরআনের আয়াত পান';

  @override
  String get settingsQuranSettings => 'কুরআনের সেটিংস';

  @override
  String get settingsReadingPreferences => 'পড়ার পছন্দ';

  @override
  String get settingsContentTranslations => 'কন্টেন্ট ও অনুবাদ';

  @override
  String get settingsOfflineManagement => 'অফলাইন ব্যবস্থাপনা';

  @override
  String get settingsOfflineSubtitle =>
      'অফলাইন পড়ার জন্য কুরআনের টেক্সট এবং অনুবাদ';

  @override
  String get settingsAudioDownloads => 'অডিও ডাউনলোড';

  @override
  String get settingsAudioSubtitle =>
      'অফলাইন শোনার জন্য তেলাওয়াত ডাউনলোড করুন';

  @override
  String get settingsAccessibility => 'অভিগম্যতা';

  @override
  String get settingsAppSettings => 'অ্যাপ সেটিংস';

  @override
  String get settingsDataStorage => 'ডেটা ও সংরক্ষণ';

  @override
  String get settingsUserName => 'আপনার নাম';

  @override
  String get settingsUserNameSubtitle => 'আপনার প্রদর্শনের নাম সেট করুন';

  @override
  String get settingsEditName => 'নাম সম্পাদনা করুন';

  @override
  String get settingsEnterName => 'আপনার নাম লিখুন';

  @override
  String get settingsAppDescription => 'ইসলামিক ইউটিলিটি সুপার অ্যাপ';

  @override
  String get settingsComingSoon => 'শীঘ্রই আসছে';

  @override
  String get settingsPrayerCalculationMethodTitle => 'নামাজের গণনা পদ্ধতি';

  @override
  String get commonLoading => 'লোড হচ্ছে...';

  @override
  String get commonPleaseWait => 'অনুগ্রহ করে অপেক্ষা করুন...';

  @override
  String get commonError => 'ত্রুটি';

  @override
  String get commonRetry => 'পুনরায় চেষ্টা করুন';

  @override
  String get commonCancel => 'বাতিল';

  @override
  String get commonSave => 'সংরক্ষণ';

  @override
  String get commonClose => 'বন্ধ';

  @override
  String get commonBack => 'পিছনে';

  @override
  String get commonNext => 'পরবর্তী';

  @override
  String get commonSkip => 'এড়িয়ে যান';

  @override
  String get commonContinue => 'চালিয়ে যান';

  @override
  String get commonDone => 'সম্পন্ন';

  @override
  String get exitDialogTitle => 'দীনমেট থেকে বের হন';

  @override
  String get exitDialogMessage =>
      'আপনি কি নিশ্চিত যে আপনি অ্যাপ থেকে বের হতে চান?';

  @override
  String get exitDialogExit => 'বের হন';

  @override
  String get languageEnglish => 'ইংরেজি';

  @override
  String get languageBengali => 'বাংলা';

  @override
  String get languageUrdu => 'উর্দু';

  @override
  String get languageArabic => 'আরবি';

  @override
  String get languageFullySupported => 'সম্পূর্ণ সমর্থিত';

  @override
  String get languageComingSoon => 'শীঘ্রই আসছে';

  @override
  String get themeLight => 'হালকা';

  @override
  String get themeDark => 'অন্ধকার';

  @override
  String get themeSystem => 'সিস্টেম';

  @override
  String get themeLightSerenity => 'হালকা প্রশান্তি';

  @override
  String get themeNightCalm => 'রাতের শান্তি';

  @override
  String get themeHeritageSepia => 'ঐতিহ্য সেপিয়া';

  @override
  String get errorGeneric => 'কিছু ভুল হয়েছে';

  @override
  String get errorNetwork =>
      'নেটওয়ার্ক ত্রুটি। অনুগ্রহ করে আপনার সংযোগ পরীক্ষা করুন।';

  @override
  String get errorLocation =>
      'সঠিক নামাজের সময়ের জন্য অবস্থান অ্যাক্সেস প্রয়োজন।';

  @override
  String get errorPermission => 'অনুমতি অস্বীকৃত';

  @override
  String get errorLanguageChangeFailed =>
      'ভাষা পরিবর্তন করতে ব্যর্থ হয়েছে। অনুগ্রহ করে আবার চেষ্টা করুন।';

  @override
  String get errorLanguageChangeGeneric =>
      'ভাষা পরিবর্তন করার সময় একটি ত্রুটি ঘটেছে।';

  @override
  String get infoLocationRequired =>
      'আপনার এলাকার সঠিক নামাজের সময় প্রদানের জন্য অবস্থান অ্যাক্সেস সাহায্য করে।';

  @override
  String get infoNotificationsHelp => 'প্রতিটি নামাজের আগে বিজ্ঞপ্তি পান।';

  @override
  String get infoThemeDescription =>
      'অ্যাপের জন্য আপনার পছন্দের দৃশ্য শৈলী নির্বাচন করুন।';

  @override
  String get locationSetSuccess => 'অবস্থান সফলভাবে সেট করা হয়েছে!';

  @override
  String locationGetFailed(String error) {
    return 'অবস্থান পাওয়া যায়নি: $error';
  }

  @override
  String locationSaveSuccess(String city, String country) {
    return 'অবস্থান \"$city, $country\" সফলভাবে সংরক্ষিত হয়েছে!';
  }

  @override
  String locationSaveFailed(String error) {
    return 'অবস্থান সংরক্ষণ ব্যর্থ: $error';
  }

  @override
  String get locationPermissionRequired => 'অবস্থান অনুমতি প্রয়োজন';

  @override
  String get buttonCancel => 'বাতিল';

  @override
  String get buttonTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get buttonConfirm => 'নিশ্চিত করুন';

  @override
  String get buttonClear => 'পরিষ্কার করুন';

  @override
  String get settingsAbout => 'DeenMate সম্পর্কে';

  @override
  String get settingsAboutSubtitle => 'সংস্করণ, ক্রেডিট এবং আরও';

  @override
  String get settingsPrivacyPolicy => 'গোপনীয়তা নীতি';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'আমরা কীভাবে আপনার ডেটা রক্ষা করি';

  @override
  String get settingsClearCache => 'ক্যাশ মুছুন';

  @override
  String get settingsClearCacheSubtitle => 'স্টোরেজ স্থান মুক্ত করুন';

  @override
  String get settingsClearCacheConfirmMessage =>
      'আপনি কি নিশ্চিত যে আপনি ক্যাশ মুছে ফেলতে চান? এটি অস্থায়ী ফাইলগুলি সরিয়ে দেবে এবং প্রাথমিকভাবে অ্যাপটি ধীর করতে পারে।';

  @override
  String get settingsExportData => 'ডেটা রপ্তানি করুন';

  @override
  String get settingsExportDataSubtitle => 'আপনার সেটিংস এবং ডেটা ব্যাকআপ করুন';

  @override
  String get settingsPrayerCalculationMethod => 'নামাজ গণনা পদ্ধতি';

  @override
  String get settingsSelectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get settingsPermissionRequired => 'অনুমতি প্রয়োজন';

  @override
  String get settingsCacheClearedSuccess => 'ক্যাশ সফলভাবে মুছে ফেলা হয়েছে';

  @override
  String get settingsExportComingSoon => 'রপ্তানি বৈশিষ্ট্য শীঘ্রই আসছে!';

  @override
  String get prayerCalculationMethods => 'নামাজ গণনা পদ্ধতি';

  @override
  String get prayerAthanNotifications => 'আজান ও বিজ্ঞপ্তি';

  @override
  String get prayerVibration => 'কম্পন';

  @override
  String get prayerVibrationSubtitle => 'আজানের সময় ডিভাইস কম্পন করুন';

  @override
  String get prayerQuickActions => 'দ্রুত কর্ম';

  @override
  String get prayerQuickActionsSubtitle =>
      '\"নামাজ পড়া হয়েছে\" এবং \"স্নুজ\" বোতাম দেখান';

  @override
  String get prayerAutoComplete => 'স্বয়ংক্রিয় সম্পূর্ণ';

  @override
  String get prayerAutoCompleteSubtitle =>
      'স্বয়ংক্রিয়ভাবে নামাজ সম্পূর্ণ হিসেবে চিহ্নিত করুন';

  @override
  String get prayerSmartNotifications => 'স্মার্ট বিজ্ঞপ্তি';

  @override
  String get prayerSmartNotificationsSubtitle =>
      'আপনার কার্যকলাপের ভিত্তিতে বিজ্ঞপ্তি সামঞ্জস্য করুন';

  @override
  String get prayerOverrideDND => 'ডু নট ডিসটার্ব ওভাররাইড করুন';

  @override
  String get prayerOverrideDNDSubtitle =>
      'ডিএনডি মোডেও নামাজের বিজ্ঞপ্তি দেখান';

  @override
  String get prayerFullScreenNotifications => 'ফুল স্ক্রিন বিজ্ঞপ্তি';

  @override
  String get prayerFullScreenNotificationsSubtitle =>
      'নামাজের সময় ফুল স্ক্রিন সতর্কতা হিসেবে দেখান';

  @override
  String get prayerRamadanNotifications => 'রমজান বিজ্ঞপ্তি';

  @override
  String get prayerRamadanNotificationsSubtitle =>
      'সেহরি এবং ইফতারের জন্য বিশেষ বিজ্ঞপ্তি সক্রিয় করুন';

  @override
  String get prayerSpecialRamadanAthan => 'বিশেষ রমজান আজান';

  @override
  String get prayerSpecialRamadanAthanSubtitle =>
      'রমজানের সময় বিশেষ আজান পাঠ ব্যবহার করুন';

  @override
  String get prayerIncludeDuas => 'দোয়া অন্তর্ভুক্ত করুন';

  @override
  String get prayerIncludeDuasSubtitle =>
      'বিজ্ঞপ্তিতে রমজান-নির্দিষ্ট দোয়া দেখান';

  @override
  String get prayerTrackFasting => 'রোজা ট্র্যাক করুন';

  @override
  String get prayerTrackFastingSubtitle => 'আপনার রোজার অবস্থা ট্র্যাক রাখুন';

  @override
  String get buttonRetry => 'আবার চেষ্টা করুন';

  @override
  String get buttonGrant => 'অনুমতি দিন';

  @override
  String get buttonApply => 'প্রয়োগ করুন';

  @override
  String get buttonGotIt => 'বুঝেছি';

  @override
  String get prayerTestAthanAudio => 'আজান অডিও পরীক্ষা করুন';

  @override
  String get prayerScheduleNow => 'এখনই সময়সূচী করুন';

  @override
  String get prayerDebugInfo => 'ডিবাগ তথ্য';

  @override
  String get prayerScheduleNotifications => 'নামাজের বিজ্ঞপ্তি সময়সূচী করুন';

  @override
  String get prayerTestNotification => 'পরীক্ষামূলক বিজ্ঞপ্তি (১ সেকেন্ড)';

  @override
  String get prayerDemoNotification => 'ডেমো বিজ্ঞপ্তি (২ মিনিট)';

  @override
  String get prayerImmediateNotification => 'তাৎক্ষণিক বিজ্ঞপ্তি';

  @override
  String get prayerAthanTestStarted => 'আজান অডিও পরীক্ষা শুরু হয়েছে';

  @override
  String prayerAthanTestFailed(String error) {
    return 'আজান পরীক্ষা ব্যর্থ: $error';
  }

  @override
  String get prayerNotificationsScheduled =>
      'আজকের জন্য বিজ্ঞপ্তি সময়সূচী করা হয়েছে';

  @override
  String prayerSchedulingFailed(String error) {
    return 'সময়সূচী ব্যর্থ: $error';
  }

  @override
  String prayerDebugFailed(String error) {
    return 'ডিবাগ ব্যর্থ: $error';
  }

  @override
  String get prayerTestNotificationSent =>
      'পরীক্ষামূলক বিজ্ঞপ্তি তাৎক্ষণিকভাবে পাঠানো হয়েছে!';

  @override
  String prayerTestNotificationFailed(String error) {
    return 'পরীক্ষামূলক বিজ্ঞপ্তি ব্যর্থ: $error';
  }

  @override
  String get prayerDemoNotificationSent =>
      'ডেমো বিজ্ঞপ্তি পাঠানো হয়েছে! আজান এখন বাজবে।';

  @override
  String prayerDemoNotificationFailed(String error) {
    return 'ডেমো বিজ্ঞপ্তি ব্যর্থ: $error';
  }

  @override
  String get prayerImmediateNotificationSent =>
      'তাৎক্ষণিক বিজ্ঞপ্তি পাঠানো হয়েছে!';

  @override
  String prayerImmediateNotificationFailed(String error) {
    return 'তাৎক্ষণিক বিজ্ঞপ্তি ব্যর্থ: $error';
  }

  @override
  String get audioDownloadsTitle => 'অডিও ডাউনলোড';

  @override
  String get audioStorageTitle => 'অডিও স্টোরেজ';

  @override
  String get audioStorageErrorStats => 'স্ট্যাটিস্টিক্স লোড করতে ত্রুটি';

  @override
  String get audioSelectReciterTitle => 'তিলাওয়াতকারী নির্বাচন করুন';

  @override
  String get audioRecitersLoadError => 'তিলাওয়াতকারী লোড করতে ত্রুটি';

  @override
  String get audioQuickActionsTitle => 'দ্রুত কার্যক্রম';

  @override
  String get audioDownloadPopularTitle => 'জনপ্রিয় ডাউনলোড';

  @override
  String get audioDownloadPopularSubtitle =>
      'সবচেয়ে জনপ্রিয় সূরাগুলি ডাউনলোড করুন';

  @override
  String get audioDownloadAllTitle => 'সব ডাউনলোড';

  @override
  String get audioDownloadAllSubtitle => 'সম্পূর্ণ কুরআন ডাউনলোড করুন';

  @override
  String get audioIndividualChaptersTitle => 'পৃথক সূরাসমূহ';

  @override
  String get audioDownloadCancel => 'বাতিল';

  @override
  String get audioChapterDelete => 'মুছুন';

  @override
  String audioErrorLoadingChapters(String error) {
    return 'অধ্যায় লোড করতে ত্রুটি: $error';
  }

  @override
  String get audioDownloadingPopularChapters =>
      'জনপ্রিয় অধ্যায়গুলি ডাউনলোড হচ্ছে...';

  @override
  String audioDownloadingChapter(String chapterId, String status) {
    return 'অধ্যায় $chapterId ডাউনলোড হচ্ছে: $status';
  }

  @override
  String get audioPopularChaptersDownloadSuccess =>
      'জনপ্রিয় অধ্যায়গুলি সফলভাবে ডাউনলোড হয়েছে!';

  @override
  String audioDownloadFailed(String error) {
    return 'ডাউনলোড ব্যর্থ: $error';
  }

  @override
  String get audioDownloadingCompleteQuran => 'সম্পূর্ণ কুরআন ডাউনলোড হচ্ছে...';

  @override
  String audioDownloadingSurah(String chapterName, String status) {
    return 'সূরা $chapterName: $status';
  }

  @override
  String get audioCompleteQuranDownloadSuccess =>
      'সম্পূর্ণ কুরআন সফলভাবে ডাউনলোড হয়েছে!';

  @override
  String audioDownloadingVerse(String currentVerse) {
    return '$currentVerse ডাউনলোড হচ্ছে...';
  }

  @override
  String get audioChapterDeleted => 'অধ্যায়ের অডিও মুছে ফেলা হয়েছে';

  @override
  String audioDeleteFailed(String error) {
    return 'মুছে ফেলা ব্যর্থ: $error';
  }

  @override
  String get audioUserCancelled => 'ব্যবহারকারী বাতিল করেছেন';

  @override
  String get prayerTimesLoading => 'নামাজের সময় লোড হচ্ছে';

  @override
  String get prayerTimesUnavailable => 'নামাজের সময় অনুপলব্ধ';

  @override
  String get prayerTimesUnableToLoad => 'নামাজের সময় লোড করতে পারছি না';

  @override
  String get prayerTimesLocationRequired => 'অবস্থান প্রয়োজন';

  @override
  String get prayerTimesEnableLocation =>
      'সঠিক নামাজের সময়ের জন্য অবস্থান সেবা চালু করুন';

  @override
  String get prayerTimesEnableLocationAction => 'অবস্থান চালু করুন';

  @override
  String get prayerTimesNetworkIssue => 'নেটওয়ার্ক সমস্যা';

  @override
  String get prayerTimesCheckConnection =>
      'ইন্টারনেট সংযোগ পরীক্ষা করুন এবং আবার চেষ্টা করুন';

  @override
  String get prayerTimesServiceUnavailable => 'সেবা অনুপলব্ধ';

  @override
  String get prayerTimesServiceTemporarilyUnavailable =>
      'নামাজের সময় সেবা সাময়িকভাবে অনুপলব্ধ';

  @override
  String get prayerTimesRetry => 'আবার চেষ্টা করুন';

  @override
  String get prayerTimesTryAgain => 'আবার চেষ্টা করুন';

  @override
  String get prayerTimesDataUnavailable => 'নামাজের সময়ের তথ্য অনুপলব্ধ';

  @override
  String get prayerTimesLocationAccess => 'অবস্থানে প্রবেশাধিকার';

  @override
  String get prayerTimesLocationAccessMessage =>
      'ডীনমেটের আপনার এলাকার জন্য সঠিক নামাজের সময় প্রদান করতে অবস্থানে প্রবেশাধিকার প্রয়োজন।\n\nআপনি পারেন:\n• ডিভাইস সেটিংসে অবস্থান সেবা চালু করতে\n• অ্যাপ সেটিংসে ম্যানুয়ালি আপনার শহর নির্বাচন করতে\n• আপনার অঞ্চলের ভিত্তিতে আনুমানিক সময় ব্যবহার করতে';

  @override
  String get prayerTimesLater => 'পরে';

  @override
  String get prayerTimesSettings => 'সেটিংস';

  @override
  String get commonToday => 'আজ';

  @override
  String get islamicMonthMuharram => 'মুহাররম';

  @override
  String get islamicMonthSafar => 'সফর';

  @override
  String get islamicMonthRabiAlAwwal => 'রবিউল আউয়াল';

  @override
  String get islamicMonthRabiAlThani => 'রবিউস সানি';

  @override
  String get islamicMonthJumadaAlAwwal => 'জমাদিউল আউয়াল';

  @override
  String get islamicMonthJumadaAlThani => 'জমাদিউস সানি';

  @override
  String get islamicMonthRajab => 'রজব';

  @override
  String get islamicMonthShaban => 'শাবান';

  @override
  String get islamicMonthRamadan => 'রমজান';

  @override
  String get islamicMonthShawwal => 'শাওয়াল';

  @override
  String get islamicMonthDhuAlQadah => 'যিলকদ';

  @override
  String get islamicMonthDhuAlHijjah => 'যিলহজ';

  @override
  String get homeTimeStatusNow => 'এখন';

  @override
  String get homeGreeting => 'আসসালামু আলাইকুম,';

  @override
  String get homeForbiddenSunrise => 'সূর্যোদয়ের সময় নামাজ নিষিদ্ধ';

  @override
  String get homeForbiddenZenith => 'সূর্যের মধ্যাহ্নে (জেনিথ) নামাজ নিষিদ্ধ';

  @override
  String get homeForbiddenSunset => 'সূর্যাস্তের সময় নামাজ নিষিদ্ধ';

  @override
  String homePrayerIn(String prayerName) {
    return '$prayerName ';
  }

  @override
  String homePrayerRemaining(String prayerName) {
    return '$prayerName বাকি ';
  }

  @override
  String get homeNoActivePrayer => 'কোন সক্রিয় নামাজ নেই';

  @override
  String get homeCurrentPrayer => 'বর্তমান নামাজ';

  @override
  String get homeNextPrayer => 'পরবর্তী নামাজ';

  @override
  String get athanPreviewTitle => 'আযান প্রিভিউ';

  @override
  String get athanPreviewDescription =>
      'নির্বাচিত মুয়াজ্জিনের কণ্ঠস্বরের নমুনা শুনুন:';

  @override
  String get athanPreviewPlay => 'প্রিভিউ';

  @override
  String get athanPreviewStop => 'বন্ধ';

  @override
  String get athanPreviewPlaying => 'চলছে...';

  @override
  String get reciterAbdulBasit => 'আব্দুল বাসিত আব্দুস সামাদ';

  @override
  String get reciterAbdulBasitDesc =>
      'মিশর থেকে বিখ্যাত কুরআন তেলাওয়াতকারী, মধুর কণ্ঠস্বরের অধিকারী';

  @override
  String get reciterMishary => 'মিশারী রাশিদ আল-আফাসী';

  @override
  String get reciterMisharyDesc => 'কুয়েতের বিখ্যাত ইমাম ও তেলাওয়াতকারী';

  @override
  String get reciterSudais => 'শেখ আব্দুর রহমান আস-সুদাইস';

  @override
  String get reciterSudaisDesc => 'মক্কার মসজিদুল হারামের ইমাম';

  @override
  String get reciterShuraim => 'শেখ সউদ আশ-শুরাইম';

  @override
  String get reciterShuraimDesc => 'মক্কার মসজিদুল হারামের ইমাম';

  @override
  String get reciterMaher => 'মাহের আল-মুয়াইকলী';

  @override
  String get reciterMaherDesc =>
      'মসজিদুল হারামের ইমাম, সুন্দর তেলাওয়াতের অধিকারী';

  @override
  String get reciterYasser => 'ইয়াসের আদ-দুসারী';

  @override
  String get reciterYasserDesc => 'সৌদি আরব থেকে সুন্দর কণ্ঠস্বরের অধিকারী';

  @override
  String get reciterAjmi => 'আহমাদ আল-আজমী';

  @override
  String get reciterAjmiDesc =>
      'কুয়েতি তেলাওয়াতকারী, স্বতন্ত্র ধরনের অধিকারী';

  @override
  String get reciterGhamdi => 'সাদ আল-গামদী';

  @override
  String get reciterGhamdiDesc =>
      'সৌদি তেলাওয়াতকারী, আবেগময় তেলাওয়াতের জন্য বিখ্যাত';

  @override
  String get reciterDefault => 'ডিফল্ট আযান';

  @override
  String get reciterDefaultDesc => 'মানসম্পন্ন ইসলামিক আযান';

  @override
  String get prayerTimesNextIn => 'পরবর্তী';

  @override
  String get prayerTimesPleaseWait => 'অনুগ্রহ করে অপেক্ষা করুন';

  @override
  String get settingsReadingPreferencesSubtitle => 'ফন্ট সাইজ, অনুবাদ, লেআউট';

  @override
  String get settingsContentTranslationsSubtitle =>
      'প্রতিটি ভাষার জন্য কুরআন ও হাদিসের অনুবাদ নির্বাচন করুন';

  @override
  String get settingsAccessibilitySubtitle =>
      'স্ক্রিন রিডার, উচ্চ কনট্রাস্ট, টেক্সট স্কেলিং';

  @override
  String settingsLanguageComingSoon(String languageName) {
    return '$languageName সাপোর্ট শীঘ্রই আসছে। এখনকার জন্য অ্যাপটি ইংরেজি ব্যবহার করবে।';
  }

  @override
  String settingsLanguageChanged(String languageName) {
    return 'ভাষা $languageName এ পরিবর্তিত হয়েছে';
  }

  @override
  String get translationPickerTitle => 'অনুবাদ নির্বাচন করুন';

  @override
  String translationPickerErrorLoading(String error) {
    return 'অনুবাদ লোড করতে ত্রুটি: $error';
  }

  @override
  String get translationPickerCancel => 'বাতিল';

  @override
  String get translationPickerApply => 'প্রয়োগ';

  @override
  String get translationPickerLanguageLabel => 'ভাষা: ';

  @override
  String get translationPickerAllLanguages => 'সকল ভাষা';

  @override
  String get translationPickerEnglish => 'ইংরেজি';

  @override
  String get translationPickerArabic => 'আরবি';

  @override
  String get translationPickerUrdu => 'উর্দু';

  @override
  String get translationPickerBengali => 'বাংলা';

  @override
  String get translationPickerIndonesian => 'ইন্দোনেশিয়ান';

  @override
  String get translationPickerTurkish => 'তুর্কি';

  @override
  String get translationPickerFrench => 'ফরাসি';

  @override
  String get readingModeThemeTitle => 'পঠন থিম';

  @override
  String get readingModeThemeLight => 'উজ্জ্বল থিম';

  @override
  String get readingModeThemeDark => 'অন্ধকার থিম';

  @override
  String get readingModeThemeSepia => 'সেপিয়া থিম';

  @override
  String get readingModeThemeLightApplied => 'উজ্জ্বল থিম প্রয়োগ করা হয়েছে';

  @override
  String get readingModeThemeDarkApplied => 'অন্ধকার থিম প্রয়োগ করা হয়েছে';

  @override
  String get readingModeThemeSepiaApplied => 'সেপিয়া থিম প্রয়োগ করা হয়েছে';

  @override
  String get readingModeFontSettings => 'ফন্ট সেটিংস';

  @override
  String get readingModeFontArabicSize => 'আরবি ফন্টের আকার';

  @override
  String get readingModeFontTranslationSize => 'অনুবাদ ফন্টের আকার';

  @override
  String get readingModeDone => 'সম্পন্ন';

  @override
  String get readingModeTranslationSettings => 'অনুবাদ সেটিংস';

  @override
  String get readingModeOK => 'ঠিক আছে';

  @override
  String get readingModeBookmarkAdded => 'বুকমার্ক যোগ করা হয়েছে';

  @override
  String get verseCardWordAnalysis => 'শব্দ বিশ্লেষণ';

  @override
  String get verseCardPlayAudio => 'অডিও চালান';

  @override
  String get verseCardDownloadAudio => 'অডিও ডাউনলোড করুন';

  @override
  String get verseCardAddNote => 'নোট যোগ করুন';

  @override
  String get verseCardAudioNotAvailable =>
      'এই আয়াতের জন্য অডিও প্লেব্যাক উপলব্ধ নেই';

  @override
  String verseCardDownloadingAudio(String verseKey) {
    return 'আয়াত $verseKey এর অডিও ডাউনলোড করা হচ্ছে...';
  }

  @override
  String verseCardNotesTitle(String verseKey) {
    return '$verseKey এর নোট';
  }

  @override
  String get verseCardOK => 'ঠিক আছে';

  @override
  String get audioPlayerNowPlaying => 'এখন চলছে';

  @override
  String get audioPlayerNoVerseSelected => 'কোন আয়াত নির্বাচিত নেই';

  @override
  String get audioPlayerDefaultReciter => 'মিশারী রাশিদ আল-আফাসী';

  @override
  String get audioPlayerCurrentPlaylist => 'বর্তমান প্লেলিস্ট';

  @override
  String get audioPlayerPlaylistComingSoon => 'প্লেলিস্ট কার্যক্রম শীঘ্রই আসছে';

  @override
  String audioPlayerPlaylistCount(int count) {
    return 'প্লেলিস্টে $countটি আয়াত রয়েছে';
  }

  @override
  String audioPlayerDownloadingVerse(String verseKey) {
    return 'আয়াত $verseKey ডাউনলোড করা হচ্ছে...';
  }

  @override
  String audioPlayerDownloadFailed(String error) {
    return 'ডাউনলোড ব্যর্থ হয়েছে: $error';
  }

  @override
  String get wordAnalysisTitle => 'শব্দে শব্দে বিশ্লেষণ';

  @override
  String get wordAnalysisHideAnalysis => 'বিশ্লেষণ লুকাতে ট্যাপ করুন';

  @override
  String get wordAnalysisShowAnalysis => 'আরবি • রোমান • অনুবাদ';

  @override
  String get wordAnalysisDisplayOptions => 'প্রদর্শন বিকল্প';

  @override
  String get wordAnalysisTransliteration => 'রোমান';

  @override
  String get wordAnalysisGrammar => 'ব্যাকরণ';

  @override
  String get wordAnalysisTapInstruction =>
      'বিস্তারিত বিশ্লেষণের জন্য যেকোনো শব্দে ট্যাপ করুন';

  @override
  String get wordAnalysisOverview => 'শব্দ বিশ্লেষণ সংক্ষিপ্তসার';

  @override
  String get wordAnalysisWordDetails => 'শব্দের বিবরণ';

  @override
  String get wordAnalysisPosition => 'অবস্থান';

  @override
  String get wordAnalysisRoot => 'মূল';

  @override
  String get wordAnalysisLemma => 'লেমা';

  @override
  String get wordAnalysisStem => 'স্টেম';

  @override
  String get wordAnalysisPartOfSpeech => 'পদ';

  @override
  String get wordAnalysisNoDetails =>
      'এই শব্দের জন্য অতিরিক্ত বিবরণ উপলব্ধ নেই।';

  @override
  String get wordAnalysisGrammarGender => 'লিঙ্গ';

  @override
  String get wordAnalysisGrammarNumber => 'বচন';

  @override
  String get wordAnalysisGrammarPerson => 'পুরুষ';

  @override
  String get wordAnalysisGrammarTense => 'কাল';

  @override
  String get wordAnalysisGrammarMood => 'ভাব';

  @override
  String get wordAnalysisGrammarVoice => 'বাচ্য';

  @override
  String get wordAnalysisGrammarDetails => 'ব্যাকরণ';

  @override
  String get wordAnalysisNotAvailable =>
      'এই আয়াতের জন্য শব্দ বিশ্লেষণ উপলব্ধ নেই';

  @override
  String get navigationPrayer => 'নামাজ';

  @override
  String get navigationQibla => 'কিবলা';

  @override
  String get inheritanceCalculatorTitle => 'মীরাস ক্যালকুলেটর';

  @override
  String get inheritanceQuickStart => 'দ্রুত শুরুর গাইড';

  @override
  String get inheritanceEnterEstate => '১. সম্পত্তির মূল্য প্রবেশ করান';

  @override
  String get inheritanceSelectHeirs => '২. উত্তরাধিকারী নির্বাচন করুন';

  @override
  String get inheritanceCalculate => '৩. বন্টন গণনা করুন';

  @override
  String get inheritanceStartCalculation => 'গণনা শুরু করুন';

  @override
  String get inheritanceFeatures => 'মূল বৈশিষ্ট্য';

  @override
  String get inheritanceShariahCompliant => '📖 শরীয়াহ মোতাবেক';

  @override
  String get inheritanceBasedOnQuran => 'কুরআন ও সুন্নাহ ভিত্তিক';

  @override
  String get inheritanceStepByStep => '📊 ধাপে ধাপে নির্দেশনা';

  @override
  String get inheritanceDetailedBreakdown => 'বিস্তারিত গণনার বিবরণ';

  @override
  String get inheritanceAulRaddSupport => '⚖️ আউল ও রাদ্দ সাপোর্ট';

  @override
  String get inheritanceComplexScenarios => 'জটিল মীরাসের পরিস্থিতি সামলায়';

  @override
  String get inheritanceQuranicReferences => '📚 কুরআনিক রেফারেন্স';

  @override
  String get inheritanceRelevantVerses => 'সংশ্লিষ্ট আয়াত ও হাদিস অন্তর্ভুক্ত';

  @override
  String get inheritanceBengaliLanguage => '🌍 বাংলা ভাষা';

  @override
  String get inheritanceBengaliSupport => 'সম্পূর্ণ বাংলা ভাষা সাপোর্ট';

  @override
  String get inheritanceOfflineCalculation => '📱 অফলাইন গণনা';

  @override
  String get inheritanceWorksOffline => 'সম্পূর্ণ অফলাইনে কাজ করে';

  @override
  String get qiblaCompassTitle => 'কিবলা কম্পাস';

  @override
  String get qiblaCompassNotAvailable => 'কম্পাস উপলব্ধ নেই';

  @override
  String get qiblaCompassCalibrating => 'কম্পাস ক্যালিব্রেট করা হচ্ছে...';

  @override
  String get qiblaCompassUnavailable => 'কম্পাস অনুপলব্ধ';

  @override
  String get qiblaCompassActive => 'কম্পাস সক্রিয়';

  @override
  String get qiblaDirectionNorth => 'উ';

  @override
  String get qiblaDirectionEast => 'পূ';

  @override
  String get qiblaDirectionSouth => 'দ';

  @override
  String get qiblaDirectionWest => 'প';

  @override
  String get qiblaDirection => 'কিবলার দিক';

  @override
  String get qiblaCurrentLocation => 'বর্তমান অবস্থান';

  @override
  String get qiblaRecalibrate => 'পুনরায় ক্যালিব্রেট';

  @override
  String get qiblaUpdateLocation => 'অবস্থান আপডেট';

  @override
  String get bookmarkSort => 'সাজান';

  @override
  String get bookmarkManageCategories => 'ক্যাটাগরি পরিচালনা';

  @override
  String get bookmarkExport => 'এক্সপোর্ট';

  @override
  String get bookmarkEdit => 'সম্পাদনা';

  @override
  String get bookmarkShare => 'শেয়ার';

  @override
  String get bookmarkDelete => 'মুছুন';

  @override
  String get bookmarks => 'বুকমার্ক';

  @override
  String get bookmarkAll => 'সব';

  @override
  String get bookmarkCategories => 'ক্যাটাগরি';

  @override
  String get bookmarkRecent => 'সাম্প্রতিক';

  @override
  String get bookmarkNoBookmarksYet => 'এখনও কোনো বুকমার্ক নেই';

  @override
  String get bookmarkNoBookmarksSubtitle => 'পড়ার সময় আয়াত বুকমার্ক করুন এখানে সংরক্ষণের জন্য';

  @override
  String get bookmarkNoCategoriesYet => 'এখনও কোনো ক্যাটাগরি নেই';

  @override
  String get bookmarkNoCategoriesSubtitle => 'আপনার বুকমার্ক সংগঠিত করতে ক্যাটাগরি তৈরি করুন';

  @override
  String get bookmarkCreateCategory => 'ক্যাটাগরি তৈরি করুন';

  @override
  String get bookmarkNoRecentBookmarks => 'কোনো সাম্প্রতিক বুকমার্ক নেই';

  @override
  String get bookmarkNoRecentSubtitle => 'আপনার সাম্প্রতিক যোগ করা বুকমার্ক এখানে দেখা যাবে';

  @override
  String get edit => 'সম্পাদনা';

  @override
  String get share => 'শেয়ার';

  @override
  String get quranFontSettings => 'ফন্ট সেটিংস';

  @override
  String get quranTranslationSettings => 'অনুবাদ সেটিংস';

  @override
  String get quranContent => 'কন্টেন্ট';

  @override
  String get quranArabic => 'আরবি';

  @override
  String get quranTranslation => 'অনুবাদ';

  @override
  String get quranTafsir => 'তাফসির';

  @override
  String get quranArabicFontSize => 'আরবি ফন্ট সাইজ';

  @override
  String get quranTranslationFontSize => 'অনুবাদ ফন্ট সাইজ';

  @override
  String get quranSura => 'সূরা';

  @override
  String get comingSoon => 'শীঘ্রই আসছে';

  @override
  String get errorLoadingPage => 'পৃষ্ঠা লোড করতে ত্রুটি';

  @override
  String get downloadFailed => 'ডাউনলোড ব্যর্থ';

  @override
  String get bookmarkRemoved => 'বুকমার্ক সরানো হয়েছে';

  @override
  String get errorRemovingBookmark => 'বুকমার্ক সরাতে ত্রুটি';

  @override
  String get sortOptionsComingSoon => 'সাজানোর বিকল্প - শীঘ্রই আসছে';

  @override
  String get manageCategoriesComingSoon => 'ক্যাটাগরি পরিচালনা - শীঘ্রই আসছে';

  @override
  String get exportBookmarksComingSoon => 'বুকমার্ক এক্সপোর্ট - শীঘ্রই আসছে';

  @override
  String get editBookmarkComingSoon => 'বুকমার্ক সম্পাদনা - শীঘ্রই আসছে';

  @override
  String get addBookmarkDialogComingSoon =>
      'বুকমার্ক যোগ করার ডায়ালগ - শীঘ্রই আসছে';

  @override
  String get createCategoryDialogComingSoon =>
      'ক্যাটাগরি তৈরির ডায়ালগ - শীঘ্রই আসছে';

  @override
  String get editCategoryComingSoon => 'ক্যাটাগরি সম্পাদনা - শীঘ্রই আসছে';

  @override
  String get deleteCategoryComingSoon => 'ক্যাটাগরি মুছুন - শীঘ্রই আসছে';

  @override
  String get clearCacheFailed => 'ক্যাশ পরিষ্কার করতে ব্যর্থ';

  @override
  String get quarterSection => 'চতুর্থাংশ';

  @override
  String get verses => 'আয়াত';

  @override
  String get selected => 'নির্বাচিত';

  @override
  String get autoScroll => 'অটো স্ক্রল';

  @override
  String get quickSettings => 'দ্রুত সেটিংস';

  @override
  String get enterReadingMode => 'পড়ার মোড চালু করুন';

  @override
  String get exitReadingMode => 'পড়ার মোড বন্ধ করুন';

  @override
  String get onboardingNotificationDescription1 =>
      'আপনার দৈনিক নামাজের সাথে সংযুক্ত থাকুন';

  @override
  String get onboardingNotificationDescription2 =>
      'ইসলামিক অনুশীলনের জন্য সময়মতো অনুস্মারক পান';

  @override
  String get onboardingNotificationSelectPrayers =>
      'আপনি কোন নামাজের অনুস্মারক চান তা নির্বাচন করুন';
}

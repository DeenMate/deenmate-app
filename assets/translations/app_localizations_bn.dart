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
  String get quranJuz => 'জুজ';

  @override
  String get quranHizb => 'হিজব';

  @override
  String get quranRuku => 'রুকু';

  @override
  String get ramadanSuhoor => 'সেহরি';

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
  String get commonLoading => 'লোড হচ্ছে...';

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
}

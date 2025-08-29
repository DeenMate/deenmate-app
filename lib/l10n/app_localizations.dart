import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('bn'),
    Locale('ur'),
    Locale('ar')
  ];

  /// The main app title
  ///
  /// In en, this message translates to:
  /// **'DeenMate'**
  String get appTitle;

  /// Title for the welcome onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to DeenMate'**
  String get onboardingWelcomeTitle;

  /// Subtitle for the welcome onboarding screen
  ///
  /// In en, this message translates to:
  /// **'Your Complete Islamic Companion'**
  String get onboardingWelcomeSubtitle;

  /// Title for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get onboardingLanguageTitle;

  /// Subtitle for language selection screen
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language for the app'**
  String get onboardingLanguageSubtitle;

  /// Title for username input screen
  ///
  /// In en, this message translates to:
  /// **'What should we call you?'**
  String get onboardingUsernameTitle;

  /// Subtitle for username input screen
  ///
  /// In en, this message translates to:
  /// **'Enter your name or preferred nickname'**
  String get onboardingUsernameSubtitle;

  /// Title for location setup screen
  ///
  /// In en, this message translates to:
  /// **'Set Your Location'**
  String get onboardingLocationTitle;

  /// Subtitle for location setup screen
  ///
  /// In en, this message translates to:
  /// **'This helps us provide accurate prayer times'**
  String get onboardingLocationSubtitle;

  /// Title for GPS location option
  ///
  /// In en, this message translates to:
  /// **'Use GPS Location'**
  String get onboardingLocationGpsTitle;

  /// Subtitle for GPS location option
  ///
  /// In en, this message translates to:
  /// **'Automatically detect your current location'**
  String get onboardingLocationGpsSubtitle;

  /// Title for manual location option
  ///
  /// In en, this message translates to:
  /// **'Manual Selection'**
  String get onboardingLocationManualTitle;

  /// Subtitle for manual location option
  ///
  /// In en, this message translates to:
  /// **'Choose your city manually'**
  String get onboardingLocationManualSubtitle;

  /// Hint text for username input field
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get onboardingUsernameHint;

  /// Enable notifications option
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get onboardingNotificationEnable;

  /// Subtitle for enable notifications option
  ///
  /// In en, this message translates to:
  /// **'Receive prayer time notifications'**
  String get onboardingNotificationEnableSubtitle;

  /// Disable notifications option
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get onboardingNotificationDisable;

  /// Subtitle for disable notifications option
  ///
  /// In en, this message translates to:
  /// **'Use silent mode only'**
  String get onboardingNotificationDisableSubtitle;

  /// Title for calculation method screen
  ///
  /// In en, this message translates to:
  /// **'Prayer Time Calculation'**
  String get onboardingCalculationTitle;

  /// Subtitle for calculation method screen
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred calculation method'**
  String get onboardingCalculationSubtitle;

  /// Title for madhhab selection screen
  ///
  /// In en, this message translates to:
  /// **'Select Your Madhhab'**
  String get onboardingMadhhabTitle;

  /// Subtitle for madhhab selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose your Islamic school of thought'**
  String get onboardingMadhhabSubtitle;

  /// Title for notifications setup screen
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get onboardingNotificationsTitle;

  /// Subtitle for notifications setup screen
  ///
  /// In en, this message translates to:
  /// **'Stay connected with prayer reminders'**
  String get onboardingNotificationsSubtitle;

  /// Title for theme selection screen
  ///
  /// In en, this message translates to:
  /// **'Choose Your Theme'**
  String get onboardingThemeTitle;

  /// Subtitle for theme selection screen
  ///
  /// In en, this message translates to:
  /// **'Select your preferred visual style'**
  String get onboardingThemeSubtitle;

  /// Title for completion screen
  ///
  /// In en, this message translates to:
  /// **'You\'re All Set!'**
  String get onboardingCompleteTitle;

  /// Subtitle for completion screen
  ///
  /// In en, this message translates to:
  /// **'Welcome to DeenMate. Let\'s begin your journey.'**
  String get onboardingCompleteSubtitle;

  /// Navigation label for home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navigationHome;

  /// Navigation label for Quran screen
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get navigationQuran;

  /// Navigation label for Hadith screen
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get navigationHadith;

  /// Navigation label for more options screen
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navigationMore;

  /// Title for prayer times section
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimesTitle;

  /// Fajr prayer name
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get prayerFajr;

  /// Sunrise time
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get prayerSunrise;

  /// Dhuhr prayer name
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get prayerDhuhr;

  /// Asr prayer name
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get prayerAsr;

  /// Maghrib prayer name
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get prayerMaghrib;

  /// Isha prayer name
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get prayerIsha;

  /// Label for next prayer
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// Label for current prayer
  ///
  /// In en, this message translates to:
  /// **'Current Prayer'**
  String get currentPrayer;

  /// Label for time remaining
  ///
  /// In en, this message translates to:
  /// **'Time Remaining'**
  String get timeRemaining;

  /// Title for Quran section
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quranTitle;

  /// Label for last read section
  ///
  /// In en, this message translates to:
  /// **'Last Read'**
  String get quranLastRead;

  /// Button text to continue reading
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get quranContinue;

  /// Search placeholder text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get quranSearch;

  /// Navigation section title
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get quranNavigation;

  /// Surah navigation tab
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get quranSurah;

  /// Page navigation tab
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get quranPage;

  /// Juz/Para navigation tab
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get quranJuz;

  /// Hizb navigation tab
  ///
  /// In en, this message translates to:
  /// **'Hizb'**
  String get quranHizb;

  /// Ruku navigation tab
  ///
  /// In en, this message translates to:
  /// **'Ruku'**
  String get quranRuku;

  /// Pre-dawn meal during Ramadan
  ///
  /// In en, this message translates to:
  /// **'Suhoor'**
  String get ramadanSuhoor;

  /// Breaking fast meal during Ramadan
  ///
  /// In en, this message translates to:
  /// **'Iftaar'**
  String get ramadanIftaar;

  /// Source attribution for prayer times
  ///
  /// In en, this message translates to:
  /// **'timings from AlAdhan'**
  String get prayerTimesSource;

  /// Last updated time for prayer times
  ///
  /// In en, this message translates to:
  /// **'Updated: {time}'**
  String prayerTimesUpdated(String time);

  /// Label for current prayer
  ///
  /// In en, this message translates to:
  /// **'Current Prayer'**
  String get prayerTimesCurrentPrayer;

  /// Label for next prayer
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get prayerTimesNextPrayer;

  /// Message when no prayer is currently active
  ///
  /// In en, this message translates to:
  /// **'No Active Prayer'**
  String get prayerTimesNoActivePrayer;

  /// Azan (call to prayer) label
  ///
  /// In en, this message translates to:
  /// **'Azan'**
  String get prayerTimesAzan;

  /// Jama'at (congregational prayer) label
  ///
  /// In en, this message translates to:
  /// **'Jama\'at'**
  String get prayerTimesJamaat;

  /// Prayer end time label
  ///
  /// In en, this message translates to:
  /// **'End time - {time}'**
  String prayerTimesEndTime(String time);

  /// Settings screen title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Notifications settings section
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// Prayer reminders setting
  ///
  /// In en, this message translates to:
  /// **'Prayer Reminders'**
  String get settingsPrayerReminders;

  /// Theme settings section
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// Language settings option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// Prayer calculation method setting
  ///
  /// In en, this message translates to:
  /// **'Calculation Method'**
  String get settingsCalculationMethod;

  /// Prayer settings section title
  ///
  /// In en, this message translates to:
  /// **'Prayer Settings'**
  String get settingsPrayerSettings;

  /// Athan settings option
  ///
  /// In en, this message translates to:
  /// **'Athan Settings'**
  String get settingsAthanSettings;

  /// Athan settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Call to prayer customization'**
  String get settingsAthanSubtitle;

  /// Prayer notifications setting
  ///
  /// In en, this message translates to:
  /// **'Prayer Notifications'**
  String get settingsPrayerNotifications;

  /// Prayer notifications subtitle
  ///
  /// In en, this message translates to:
  /// **'Enable prayer time reminders'**
  String get settingsPrayerNotificationsSubtitle;

  /// Prayer reminders subtitle
  ///
  /// In en, this message translates to:
  /// **'Get notified for prayer times'**
  String get settingsPrayerRemindersSubtitle;

  /// Islamic midnight setting
  ///
  /// In en, this message translates to:
  /// **'Islamic Midnight'**
  String get settingsIslamicMidnight;

  /// Islamic midnight subtitle
  ///
  /// In en, this message translates to:
  /// **'Calculate midnight according to Islamic tradition'**
  String get settingsIslamicMidnightSubtitle;

  /// Islamic content section title
  ///
  /// In en, this message translates to:
  /// **'Islamic Content'**
  String get settingsIslamicContent;

  /// Daily verses setting
  ///
  /// In en, this message translates to:
  /// **'Daily Verses'**
  String get settingsDailyVerses;

  /// Daily verses subtitle
  ///
  /// In en, this message translates to:
  /// **'Receive daily Quranic verses'**
  String get settingsDailyVersesSubtitle;

  /// Quran settings section title
  ///
  /// In en, this message translates to:
  /// **'Quran Settings'**
  String get settingsQuranSettings;

  /// Reading preferences option
  ///
  /// In en, this message translates to:
  /// **'Reading Preferences'**
  String get settingsReadingPreferences;

  /// Content and translations option
  ///
  /// In en, this message translates to:
  /// **'Content & Translations'**
  String get settingsContentTranslations;

  /// Offline management option
  ///
  /// In en, this message translates to:
  /// **'Offline Management'**
  String get settingsOfflineManagement;

  /// Offline management subtitle
  ///
  /// In en, this message translates to:
  /// **'Quran text and translations for offline reading'**
  String get settingsOfflineSubtitle;

  /// Audio downloads option
  ///
  /// In en, this message translates to:
  /// **'Audio Downloads'**
  String get settingsAudioDownloads;

  /// Audio downloads subtitle
  ///
  /// In en, this message translates to:
  /// **'Download recitations for offline listening'**
  String get settingsAudioSubtitle;

  /// Accessibility settings option
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get settingsAccessibility;

  /// App settings section title
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get settingsAppSettings;

  /// Data and storage section title
  ///
  /// In en, this message translates to:
  /// **'Data & Storage'**
  String get settingsDataStorage;

  /// User name field label
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get settingsUserName;

  /// User name field subtitle
  ///
  /// In en, this message translates to:
  /// **'Set your display name'**
  String get settingsUserNameSubtitle;

  /// Edit name dialog title
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get settingsEditName;

  /// Name input field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get settingsEnterName;

  /// App description text
  ///
  /// In en, this message translates to:
  /// **'Islamic Utility Super App'**
  String get settingsAppDescription;

  /// Coming soon label
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get settingsComingSoon;

  /// Prayer calculation method dialog title
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation Method'**
  String get settingsPrayerCalculationMethodTitle;

  /// Generic loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

  /// Please wait message
  ///
  /// In en, this message translates to:
  /// **'Please wait...'**
  String get commonPleaseWait;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get commonError;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// Back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// Next button text
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// Skip button text
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get commonSkip;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// Done button text
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// Exit confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Exit DeenMate'**
  String get exitDialogTitle;

  /// Exit confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get exitDialogMessage;

  /// Exit confirmation dialog exit button
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exitDialogExit;

  /// English language name
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// Bengali language name
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get languageBengali;

  /// Urdu language name
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// Arabic language name
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// Language status - fully supported
  ///
  /// In en, this message translates to:
  /// **'Fully Supported'**
  String get languageFullySupported;

  /// Language status - coming soon
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get languageComingSoon;

  /// Light theme option
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Dark theme option
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// System theme option
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Light Serenity theme option
  ///
  /// In en, this message translates to:
  /// **'Light Serenity'**
  String get themeLightSerenity;

  /// Night Calm theme option
  ///
  /// In en, this message translates to:
  /// **'Night Calm'**
  String get themeNightCalm;

  /// Heritage Sepia theme option
  ///
  /// In en, this message translates to:
  /// **'Heritage Sepia'**
  String get themeHeritageSepia;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorGeneric;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errorNetwork;

  /// Location error message
  ///
  /// In en, this message translates to:
  /// **'Location access is required for accurate prayer times.'**
  String get errorLocation;

  /// Permission error message
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get errorPermission;

  /// Error message when language change fails
  ///
  /// In en, this message translates to:
  /// **'Failed to change language. Please try again.'**
  String get errorLanguageChangeFailed;

  /// Generic language change error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred while changing the language.'**
  String get errorLanguageChangeGeneric;

  /// Information about location requirement
  ///
  /// In en, this message translates to:
  /// **'Location access helps provide accurate prayer times for your area.'**
  String get infoLocationRequired;

  /// Information about notifications
  ///
  /// In en, this message translates to:
  /// **'Get notified before each prayer time.'**
  String get infoNotificationsHelp;

  /// Information about theme selection
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred visual style for the app.'**
  String get infoThemeDescription;

  /// Success message when location is set
  ///
  /// In en, this message translates to:
  /// **'Location set successfully!'**
  String get locationSetSuccess;

  /// Error message when location retrieval fails
  ///
  /// In en, this message translates to:
  /// **'Failed to get location: {error}'**
  String locationGetFailed(String error);

  /// Success message when location is saved
  ///
  /// In en, this message translates to:
  /// **'Location \"{city}, {country}\" saved successfully!'**
  String locationSaveSuccess(String city, String country);

  /// Error message when location saving fails
  ///
  /// In en, this message translates to:
  /// **'Failed to save location: {error}'**
  String locationSaveFailed(String error);

  /// Title for location permission dialog
  ///
  /// In en, this message translates to:
  /// **'Location Permission Required'**
  String get locationPermissionRequired;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get buttonCancel;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get buttonTryAgain;

  /// Confirm button text
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get buttonConfirm;

  /// Clear button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get buttonClear;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About DeenMate'**
  String get settingsAbout;

  /// About section subtitle
  ///
  /// In en, this message translates to:
  /// **'Version, credits, and more'**
  String get settingsAboutSubtitle;

  /// Privacy policy option
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsPrivacyPolicy;

  /// Privacy policy subtitle
  ///
  /// In en, this message translates to:
  /// **'How we protect your data'**
  String get settingsPrivacyPolicySubtitle;

  /// Clear cache option
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get settingsClearCache;

  /// Clear cache subtitle
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get settingsClearCacheSubtitle;

  /// Clear cache confirmation dialog message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to clear the cache? This will remove temporary files and may slow down the app initially.'**
  String get settingsClearCacheConfirmMessage;

  /// Export data option
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingsExportData;

  /// Export data subtitle
  ///
  /// In en, this message translates to:
  /// **'Backup your settings and data'**
  String get settingsExportDataSubtitle;

  /// Prayer calculation method setting
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation Method'**
  String get settingsPrayerCalculationMethod;

  /// Language selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get settingsSelectLanguage;

  /// Permission required dialog title
  ///
  /// In en, this message translates to:
  /// **'Permission Required'**
  String get settingsPermissionRequired;

  /// Cache cleared success message
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get settingsCacheClearedSuccess;

  /// Export feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'Export feature coming soon!'**
  String get settingsExportComingSoon;

  /// Prayer calculation methods screen title
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation Methods'**
  String get prayerCalculationMethods;

  /// Athan and notifications screen title
  ///
  /// In en, this message translates to:
  /// **'Athan & Notifications'**
  String get prayerAthanNotifications;

  /// Vibration setting title
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get prayerVibration;

  /// Vibration setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Vibrate device during Athan'**
  String get prayerVibrationSubtitle;

  /// Quick actions setting title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get prayerQuickActions;

  /// Quick actions setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Show \"Mark as Prayed\" and \"Snooze\" buttons'**
  String get prayerQuickActionsSubtitle;

  /// Auto-complete setting title
  ///
  /// In en, this message translates to:
  /// **'Auto-complete'**
  String get prayerAutoComplete;

  /// Auto-complete setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Automatically mark prayer as completed'**
  String get prayerAutoCompleteSubtitle;

  /// Smart notifications setting title
  ///
  /// In en, this message translates to:
  /// **'Smart Notifications'**
  String get prayerSmartNotifications;

  /// Smart notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Adjust notifications based on your activity'**
  String get prayerSmartNotificationsSubtitle;

  /// Override DND setting title
  ///
  /// In en, this message translates to:
  /// **'Override Do Not Disturb'**
  String get prayerOverrideDND;

  /// Override DND setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Show prayer notifications even in DND mode'**
  String get prayerOverrideDNDSubtitle;

  /// Full screen notifications setting title
  ///
  /// In en, this message translates to:
  /// **'Full Screen Notifications'**
  String get prayerFullScreenNotifications;

  /// Full screen notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Show prayer time as full screen alert'**
  String get prayerFullScreenNotificationsSubtitle;

  /// Ramadan notifications setting title
  ///
  /// In en, this message translates to:
  /// **'Ramadan Notifications'**
  String get prayerRamadanNotifications;

  /// Ramadan notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Enable special notifications for Suhur and Iftar'**
  String get prayerRamadanNotificationsSubtitle;

  /// Special Ramadan Athan setting title
  ///
  /// In en, this message translates to:
  /// **'Special Ramadan Athan'**
  String get prayerSpecialRamadanAthan;

  /// Special Ramadan Athan setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Use special Athan recitations during Ramadan'**
  String get prayerSpecialRamadanAthanSubtitle;

  /// Include duas setting title
  ///
  /// In en, this message translates to:
  /// **'Include Duas'**
  String get prayerIncludeDuas;

  /// Include duas setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Show Ramadan-specific duas in notifications'**
  String get prayerIncludeDuasSubtitle;

  /// Track fasting setting title
  ///
  /// In en, this message translates to:
  /// **'Track Fasting'**
  String get prayerTrackFasting;

  /// Track fasting setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Keep track of your fasting status'**
  String get prayerTrackFastingSubtitle;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get buttonRetry;

  /// Grant button text
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get buttonGrant;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get buttonApply;

  /// Got it button text
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get buttonGotIt;

  /// Test Athan audio button text
  ///
  /// In en, this message translates to:
  /// **'Test Athan Audio'**
  String get prayerTestAthanAudio;

  /// Schedule now button text
  ///
  /// In en, this message translates to:
  /// **'Schedule Now'**
  String get prayerScheduleNow;

  /// Debug info button text
  ///
  /// In en, this message translates to:
  /// **'Debug Info'**
  String get prayerDebugInfo;

  /// Schedule prayer notifications button text
  ///
  /// In en, this message translates to:
  /// **'Schedule Prayer Notifications'**
  String get prayerScheduleNotifications;

  /// Test notification button text
  ///
  /// In en, this message translates to:
  /// **'Test Notification (1 sec)'**
  String get prayerTestNotification;

  /// Demo notification button text
  ///
  /// In en, this message translates to:
  /// **'Demo Notification (2 min)'**
  String get prayerDemoNotification;

  /// Immediate notification button text
  ///
  /// In en, this message translates to:
  /// **'Immediate Notification'**
  String get prayerImmediateNotification;

  /// Athan test started message
  ///
  /// In en, this message translates to:
  /// **'Athan audio test started'**
  String get prayerAthanTestStarted;

  /// Athan test failed message
  ///
  /// In en, this message translates to:
  /// **'Athan test failed: {error}'**
  String prayerAthanTestFailed(String error);

  /// Notifications scheduled message
  ///
  /// In en, this message translates to:
  /// **'Notifications scheduled for today'**
  String get prayerNotificationsScheduled;

  /// Scheduling failed message
  ///
  /// In en, this message translates to:
  /// **'Scheduling failed: {error}'**
  String prayerSchedulingFailed(String error);

  /// Debug failed message
  ///
  /// In en, this message translates to:
  /// **'Debug failed: {error}'**
  String prayerDebugFailed(String error);

  /// Test notification sent message
  ///
  /// In en, this message translates to:
  /// **'Test notification sent immediately!'**
  String get prayerTestNotificationSent;

  /// Test notification failed message
  ///
  /// In en, this message translates to:
  /// **'Test notification failed: {error}'**
  String prayerTestNotificationFailed(String error);

  /// Demo notification sent message
  ///
  /// In en, this message translates to:
  /// **'Demo notification sent! Azan should play now.'**
  String get prayerDemoNotificationSent;

  /// Demo notification failed message
  ///
  /// In en, this message translates to:
  /// **'Demo notification failed: {error}'**
  String prayerDemoNotificationFailed(String error);

  /// Immediate notification sent message
  ///
  /// In en, this message translates to:
  /// **'Immediate notification sent!'**
  String get prayerImmediateNotificationSent;

  /// Immediate notification failed message
  ///
  /// In en, this message translates to:
  /// **'Immediate notification failed: {error}'**
  String prayerImmediateNotificationFailed(String error);

  /// Title for the audio downloads screen
  ///
  /// In en, this message translates to:
  /// **'Audio Downloads'**
  String get audioDownloadsTitle;

  /// Header for audio storage section
  ///
  /// In en, this message translates to:
  /// **'Audio Storage'**
  String get audioStorageTitle;

  /// Error message when storage stats fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading stats'**
  String get audioStorageErrorStats;

  /// Header for reciter selection section
  ///
  /// In en, this message translates to:
  /// **'Select Reciter'**
  String get audioSelectReciterTitle;

  /// Error message when reciters fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading reciters'**
  String get audioRecitersLoadError;

  /// Header for quick actions section
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get audioQuickActionsTitle;

  /// Title for download popular chapters button
  ///
  /// In en, this message translates to:
  /// **'Download Popular'**
  String get audioDownloadPopularTitle;

  /// Subtitle for download popular chapters button
  ///
  /// In en, this message translates to:
  /// **'Download most popular chapters'**
  String get audioDownloadPopularSubtitle;

  /// Title for download all chapters button
  ///
  /// In en, this message translates to:
  /// **'Download All'**
  String get audioDownloadAllTitle;

  /// Subtitle for download all chapters button
  ///
  /// In en, this message translates to:
  /// **'Download complete Quran'**
  String get audioDownloadAllSubtitle;

  /// Header for individual chapters section
  ///
  /// In en, this message translates to:
  /// **'Individual Chapters'**
  String get audioIndividualChaptersTitle;

  /// Tooltip text for cancel download button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get audioDownloadCancel;

  /// Menu item text for deleting audio chapter
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get audioChapterDelete;

  /// Error message when chapters fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading chapters: {error}'**
  String audioErrorLoadingChapters(String error);

  /// Status message when downloading popular chapters
  ///
  /// In en, this message translates to:
  /// **'Downloading popular chapters...'**
  String get audioDownloadingPopularChapters;

  /// Status message when downloading a specific chapter
  ///
  /// In en, this message translates to:
  /// **'Downloading chapter {chapterId}: {status}'**
  String audioDownloadingChapter(String chapterId, String status);

  /// Success message when popular chapters are downloaded
  ///
  /// In en, this message translates to:
  /// **'Popular chapters downloaded successfully!'**
  String get audioPopularChaptersDownloadSuccess;

  /// Error message when download fails
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String audioDownloadFailed(String error);

  /// Status message when downloading complete Quran
  ///
  /// In en, this message translates to:
  /// **'Downloading complete Quran...'**
  String get audioDownloadingCompleteQuran;

  /// Status message when downloading a surah
  ///
  /// In en, this message translates to:
  /// **'Surah {chapterName}: {status}'**
  String audioDownloadingSurah(String chapterName, String status);

  /// Success message when complete Quran is downloaded
  ///
  /// In en, this message translates to:
  /// **'Complete Quran downloaded successfully!'**
  String get audioCompleteQuranDownloadSuccess;

  /// Status message when downloading individual verse
  ///
  /// In en, this message translates to:
  /// **'Downloading {currentVerse}...'**
  String audioDownloadingVerse(String currentVerse);

  /// Success message when chapter audio is deleted
  ///
  /// In en, this message translates to:
  /// **'Chapter audio deleted'**
  String get audioChapterDeleted;

  /// Error message when delete operation fails
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String audioDeleteFailed(String error);

  /// Message when user cancels download
  ///
  /// In en, this message translates to:
  /// **'User cancelled'**
  String get audioUserCancelled;

  /// Loading message for prayer times
  ///
  /// In en, this message translates to:
  /// **'Loading Prayer Times'**
  String get prayerTimesLoading;

  /// Title when prayer times cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Prayer Times Unavailable'**
  String get prayerTimesUnavailable;

  /// Subtitle for general prayer times error
  ///
  /// In en, this message translates to:
  /// **'Unable to load prayer times'**
  String get prayerTimesUnableToLoad;

  /// Title when location is needed for prayer times
  ///
  /// In en, this message translates to:
  /// **'Location Required'**
  String get prayerTimesLocationRequired;

  /// Message asking user to enable location services
  ///
  /// In en, this message translates to:
  /// **'Enable location services for accurate prayer times'**
  String get prayerTimesEnableLocation;

  /// Button text to enable location
  ///
  /// In en, this message translates to:
  /// **'Enable Location'**
  String get prayerTimesEnableLocationAction;

  /// Title for network related prayer times errors
  ///
  /// In en, this message translates to:
  /// **'Network Issue'**
  String get prayerTimesNetworkIssue;

  /// Message for network connectivity issues
  ///
  /// In en, this message translates to:
  /// **'Check internet connection and try again'**
  String get prayerTimesCheckConnection;

  /// Title when prayer times service is down
  ///
  /// In en, this message translates to:
  /// **'Service Unavailable'**
  String get prayerTimesServiceUnavailable;

  /// Message when prayer times service is temporarily down
  ///
  /// In en, this message translates to:
  /// **'Prayer time service is temporarily unavailable'**
  String get prayerTimesServiceTemporarilyUnavailable;

  /// Button text to retry loading prayer times
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get prayerTimesRetry;

  /// Button text to try again
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get prayerTimesTryAgain;

  /// Message when prayer times data cannot be retrieved
  ///
  /// In en, this message translates to:
  /// **'Prayer times data is unavailable'**
  String get prayerTimesDataUnavailable;

  /// Title for location access dialog
  ///
  /// In en, this message translates to:
  /// **'Location Access'**
  String get prayerTimesLocationAccess;

  /// Full message explaining why location access is needed
  ///
  /// In en, this message translates to:
  /// **'DeenMate needs location access to provide accurate prayer times for your area.\n\nYou can:\n• Enable location services in device settings\n• Manually select your city in app settings\n• Use approximate times based on your region'**
  String get prayerTimesLocationAccessMessage;

  /// Button text to dismiss location dialog
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get prayerTimesLater;

  /// Button text to go to settings
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get prayerTimesSettings;

  /// The word 'Today'
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// First Islamic month
  ///
  /// In en, this message translates to:
  /// **'Muharram'**
  String get islamicMonthMuharram;

  /// Second Islamic month
  ///
  /// In en, this message translates to:
  /// **'Safar'**
  String get islamicMonthSafar;

  /// Third Islamic month
  ///
  /// In en, this message translates to:
  /// **'Rabi al-Awwal'**
  String get islamicMonthRabiAlAwwal;

  /// Fourth Islamic month
  ///
  /// In en, this message translates to:
  /// **'Rabi al-Thani'**
  String get islamicMonthRabiAlThani;

  /// Fifth Islamic month
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Awwal'**
  String get islamicMonthJumadaAlAwwal;

  /// Sixth Islamic month
  ///
  /// In en, this message translates to:
  /// **'Jumada al-Thani'**
  String get islamicMonthJumadaAlThani;

  /// Seventh Islamic month
  ///
  /// In en, this message translates to:
  /// **'Rajab'**
  String get islamicMonthRajab;

  /// Eighth Islamic month
  ///
  /// In en, this message translates to:
  /// **'Sha\'ban'**
  String get islamicMonthShaban;

  /// Ninth Islamic month - The holy month of fasting
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get islamicMonthRamadan;

  /// Tenth Islamic month
  ///
  /// In en, this message translates to:
  /// **'Shawwal'**
  String get islamicMonthShawwal;

  /// Eleventh Islamic month
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Qadah'**
  String get islamicMonthDhuAlQadah;

  /// Twelfth Islamic month - The month of Hajj
  ///
  /// In en, this message translates to:
  /// **'Dhu al-Hijjah'**
  String get islamicMonthDhuAlHijjah;

  /// Label indicating data was updated just now
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get homeTimeStatusNow;

  /// Islamic greeting displayed on home screen
  ///
  /// In en, this message translates to:
  /// **'As-salāmu \'alaykum,'**
  String get homeGreeting;

  /// Alert message for forbidden prayer time during sunrise
  ///
  /// In en, this message translates to:
  /// **'Salah is forbidden during sunrise'**
  String get homeForbiddenSunrise;

  /// Alert message for forbidden prayer time during solar noon
  ///
  /// In en, this message translates to:
  /// **'Salah is forbidden during solar noon (zenith)'**
  String get homeForbiddenZenith;

  /// Alert message for forbidden prayer time during sunset
  ///
  /// In en, this message translates to:
  /// **'Salah is forbidden during sunset'**
  String get homeForbiddenSunset;

  /// Prefix text for upcoming prayer countdown
  ///
  /// In en, this message translates to:
  /// **'{prayerName} in '**
  String homePrayerIn(String prayerName);

  /// Prefix text for remaining prayer time
  ///
  /// In en, this message translates to:
  /// **'{prayerName} remaining '**
  String homePrayerRemaining(String prayerName);

  /// Message when no prayer is currently active
  ///
  /// In en, this message translates to:
  /// **'No Active Prayer'**
  String get homeNoActivePrayer;

  /// Label for current prayer section
  ///
  /// In en, this message translates to:
  /// **'Current Prayer'**
  String get homeCurrentPrayer;

  /// Label for next prayer section
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get homeNextPrayer;

  /// Title for athan preview widget
  ///
  /// In en, this message translates to:
  /// **'Preview Athan'**
  String get athanPreviewTitle;

  /// Description text for athan preview
  ///
  /// In en, this message translates to:
  /// **'Listen to a sample of the selected Muadhin voice:'**
  String get athanPreviewDescription;

  /// Play button text for athan preview
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get athanPreviewPlay;

  /// Stop button text for athan preview
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get athanPreviewStop;

  /// Playing status text for athan preview
  ///
  /// In en, this message translates to:
  /// **'Playing...'**
  String get athanPreviewPlaying;

  /// Name of reciter Abdul Basit Abdul Samad
  ///
  /// In en, this message translates to:
  /// **'Abdul Basit Abdul Samad'**
  String get reciterAbdulBasit;

  /// Description of reciter Abdul Basit Abdul Samad
  ///
  /// In en, this message translates to:
  /// **'Renowned Quranic reciter from Egypt with a melodious voice'**
  String get reciterAbdulBasitDesc;

  /// Name of reciter Mishary Rashid Alafasy
  ///
  /// In en, this message translates to:
  /// **'Mishary Rashid Alafasy'**
  String get reciterMishary;

  /// Description of reciter Mishary Rashid Alafasy
  ///
  /// In en, this message translates to:
  /// **'Famous Imam and reciter from Kuwait'**
  String get reciterMisharyDesc;

  /// Name of reciter Sheikh Abdul Rahman Al-Sudais
  ///
  /// In en, this message translates to:
  /// **'Sheikh Abdul Rahman Al-Sudais'**
  String get reciterSudais;

  /// Description of reciter Sheikh Abdul Rahman Al-Sudais
  ///
  /// In en, this message translates to:
  /// **'Imam of Masjid al-Haram in Mecca'**
  String get reciterSudaisDesc;

  /// Name of reciter Sheikh Saud Al-Shuraim
  ///
  /// In en, this message translates to:
  /// **'Sheikh Saud Al-Shuraim'**
  String get reciterShuraim;

  /// Description of reciter Sheikh Saud Al-Shuraim
  ///
  /// In en, this message translates to:
  /// **'Imam of Masjid al-Haram in Mecca'**
  String get reciterShuraimDesc;

  /// Name of reciter Maher Al-Muaiqly
  ///
  /// In en, this message translates to:
  /// **'Maher Al-Muaiqly'**
  String get reciterMaher;

  /// Description of reciter Maher Al-Muaiqly
  ///
  /// In en, this message translates to:
  /// **'Imam of Masjid al-Haram with beautiful recitation'**
  String get reciterMaherDesc;

  /// Name of reciter Yasser Ad-Dussary
  ///
  /// In en, this message translates to:
  /// **'Yasser Ad-Dussary'**
  String get reciterYasser;

  /// Description of reciter Yasser Ad-Dussary
  ///
  /// In en, this message translates to:
  /// **'Beautiful voice from Saudi Arabia'**
  String get reciterYasserDesc;

  /// Name of reciter Ahmad Al-Ajmi
  ///
  /// In en, this message translates to:
  /// **'Ahmad Al-Ajmi'**
  String get reciterAjmi;

  /// Description of reciter Ahmad Al-Ajmi
  ///
  /// In en, this message translates to:
  /// **'Kuwaiti reciter with distinctive style'**
  String get reciterAjmiDesc;

  /// Name of reciter Saad Al-Ghamdi
  ///
  /// In en, this message translates to:
  /// **'Saad Al-Ghamdi'**
  String get reciterGhamdi;

  /// Description of reciter Saad Al-Ghamdi
  ///
  /// In en, this message translates to:
  /// **'Saudi reciter known for emotional recitation'**
  String get reciterGhamdiDesc;

  /// Default athan reciter name
  ///
  /// In en, this message translates to:
  /// **'Default Athan'**
  String get reciterDefault;

  /// Default athan reciter description
  ///
  /// In en, this message translates to:
  /// **'Standard Islamic call to prayer'**
  String get reciterDefaultDesc;

  /// Label for countdown to next prayer
  ///
  /// In en, this message translates to:
  /// **'Next in'**
  String get prayerTimesNextIn;

  /// Loading message for prayer times
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get prayerTimesPleaseWait;

  /// Subtitle for reading preferences settings
  ///
  /// In en, this message translates to:
  /// **'Font size, translations, layout'**
  String get settingsReadingPreferencesSubtitle;

  /// Subtitle for content translations settings
  ///
  /// In en, this message translates to:
  /// **'Choose Quran & Hadith translations per language'**
  String get settingsContentTranslationsSubtitle;

  /// Subtitle for accessibility settings
  ///
  /// In en, this message translates to:
  /// **'Screen reader, high contrast, text scaling'**
  String get settingsAccessibilitySubtitle;

  /// Message when selecting a language not fully supported yet
  ///
  /// In en, this message translates to:
  /// **'{languageName} support is coming soon. The app will use English for now.'**
  String settingsLanguageComingSoon(String languageName);

  /// Success message when language is changed
  ///
  /// In en, this message translates to:
  /// **'Language changed to {languageName}'**
  String settingsLanguageChanged(String languageName);

  /// Title for translation picker dialog
  ///
  /// In en, this message translates to:
  /// **'Select Translations'**
  String get translationPickerTitle;

  /// Error message when translations fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading translations: {error}'**
  String translationPickerErrorLoading(String error);

  /// Cancel button in translation picker
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get translationPickerCancel;

  /// Apply button in translation picker
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get translationPickerApply;

  /// Label for language filter dropdown
  ///
  /// In en, this message translates to:
  /// **'Language: '**
  String get translationPickerLanguageLabel;

  /// Option to show all languages in translation picker
  ///
  /// In en, this message translates to:
  /// **'All Languages'**
  String get translationPickerAllLanguages;

  /// English language option in translation picker
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get translationPickerEnglish;

  /// Arabic language option in translation picker
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get translationPickerArabic;

  /// Urdu language option in translation picker
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get translationPickerUrdu;

  /// Bengali language option in translation picker
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get translationPickerBengali;

  /// Indonesian language option in translation picker
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get translationPickerIndonesian;

  /// Turkish language option in translation picker
  ///
  /// In en, this message translates to:
  /// **'Turkish'**
  String get translationPickerTurkish;

  /// French language option in translation picker
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get translationPickerFrench;

  /// Title for reading theme selection dialog
  ///
  /// In en, this message translates to:
  /// **'Reading Theme'**
  String get readingModeThemeTitle;

  /// Light theme option in reading mode
  ///
  /// In en, this message translates to:
  /// **'Light Theme'**
  String get readingModeThemeLight;

  /// Dark theme option in reading mode
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get readingModeThemeDark;

  /// Sepia theme option in reading mode
  ///
  /// In en, this message translates to:
  /// **'Sepia Theme'**
  String get readingModeThemeSepia;

  /// Success message when light theme is applied
  ///
  /// In en, this message translates to:
  /// **'Light theme applied'**
  String get readingModeThemeLightApplied;

  /// Success message when dark theme is applied
  ///
  /// In en, this message translates to:
  /// **'Dark theme applied'**
  String get readingModeThemeDarkApplied;

  /// Success message when sepia theme is applied
  ///
  /// In en, this message translates to:
  /// **'Sepia theme applied'**
  String get readingModeThemeSepiaApplied;

  /// Title for font settings dialog
  ///
  /// In en, this message translates to:
  /// **'Font Settings'**
  String get readingModeFontSettings;

  /// Label for Arabic font size setting
  ///
  /// In en, this message translates to:
  /// **'Arabic Font Size'**
  String get readingModeFontArabicSize;

  /// Label for translation font size setting
  ///
  /// In en, this message translates to:
  /// **'Translation Font Size'**
  String get readingModeFontTranslationSize;

  /// Done button text in reading mode settings
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get readingModeDone;

  /// Title for translation settings dialog
  ///
  /// In en, this message translates to:
  /// **'Translation Settings'**
  String get readingModeTranslationSettings;

  /// OK button text in reading mode dialogs
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get readingModeOK;

  /// Success message when bookmark is added
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get readingModeBookmarkAdded;

  /// Button text for word analysis action in verse card
  ///
  /// In en, this message translates to:
  /// **'Word Analysis'**
  String get verseCardWordAnalysis;

  /// Button text for play audio action in verse card
  ///
  /// In en, this message translates to:
  /// **'Play Audio'**
  String get verseCardPlayAudio;

  /// Button text for download audio action in verse card
  ///
  /// In en, this message translates to:
  /// **'Download Audio'**
  String get verseCardDownloadAudio;

  /// Button text for add note action in verse card
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get verseCardAddNote;

  /// Error message when audio is not available for a verse
  ///
  /// In en, this message translates to:
  /// **'Audio playback not available for this verse'**
  String get verseCardAudioNotAvailable;

  /// Message shown when downloading audio for a verse
  ///
  /// In en, this message translates to:
  /// **'Downloading audio for verse {verseKey}...'**
  String verseCardDownloadingAudio(String verseKey);

  /// Title for notes dialog for a specific verse
  ///
  /// In en, this message translates to:
  /// **'Notes for {verseKey}'**
  String verseCardNotesTitle(String verseKey);

  /// OK button text in verse card dialogs
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get verseCardOK;

  /// Header text for the audio player showing current playback
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get audioPlayerNowPlaying;

  /// Message shown when no verse is selected in audio player
  ///
  /// In en, this message translates to:
  /// **'No verse selected'**
  String get audioPlayerNoVerseSelected;

  /// Default reciter name for audio playback
  ///
  /// In en, this message translates to:
  /// **'Mishary Rashid Alafasy'**
  String get audioPlayerDefaultReciter;

  /// Title for the playlist dialog
  ///
  /// In en, this message translates to:
  /// **'Current Playlist'**
  String get audioPlayerCurrentPlaylist;

  /// Message indicating playlist features are under development
  ///
  /// In en, this message translates to:
  /// **'Playlist functionality coming soon'**
  String get audioPlayerPlaylistComingSoon;

  /// Shows the number of verses in the current playlist
  ///
  /// In en, this message translates to:
  /// **'{count} verses in playlist'**
  String audioPlayerPlaylistCount(int count);

  /// Message shown when downloading audio for a verse
  ///
  /// In en, this message translates to:
  /// **'Downloading verse {verseKey}...'**
  String audioPlayerDownloadingVerse(String verseKey);

  /// Error message when audio download fails
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String audioPlayerDownloadFailed(String error);

  /// Title for the word analysis widget
  ///
  /// In en, this message translates to:
  /// **'Word-by-Word Analysis'**
  String get wordAnalysisTitle;

  /// Message when analysis is expanded
  ///
  /// In en, this message translates to:
  /// **'Tap to hide analysis'**
  String get wordAnalysisHideAnalysis;

  /// Message when analysis is collapsed
  ///
  /// In en, this message translates to:
  /// **'Arabic • Transliteration • Translation'**
  String get wordAnalysisShowAnalysis;

  /// Header for display options section
  ///
  /// In en, this message translates to:
  /// **'Display Options'**
  String get wordAnalysisDisplayOptions;

  /// Checkbox label for transliteration display
  ///
  /// In en, this message translates to:
  /// **'Transliteration'**
  String get wordAnalysisTransliteration;

  /// Checkbox label for grammar display
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get wordAnalysisGrammar;

  /// Instruction text for interactive word selection
  ///
  /// In en, this message translates to:
  /// **'Tap on any word for detailed analysis'**
  String get wordAnalysisTapInstruction;

  /// Title for word analysis overview section
  ///
  /// In en, this message translates to:
  /// **'Word Analysis Overview'**
  String get wordAnalysisOverview;

  /// Title for detailed word information
  ///
  /// In en, this message translates to:
  /// **'Word Details'**
  String get wordAnalysisWordDetails;

  /// Label for word position in verse
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get wordAnalysisPosition;

  /// Label for Arabic root of the word
  ///
  /// In en, this message translates to:
  /// **'Root'**
  String get wordAnalysisRoot;

  /// Label for word lemma
  ///
  /// In en, this message translates to:
  /// **'Lemma'**
  String get wordAnalysisLemma;

  /// Label for word stem
  ///
  /// In en, this message translates to:
  /// **'Stem'**
  String get wordAnalysisStem;

  /// Label for grammatical part of speech
  ///
  /// In en, this message translates to:
  /// **'Part of Speech'**
  String get wordAnalysisPartOfSpeech;

  /// Message when no additional word details are available
  ///
  /// In en, this message translates to:
  /// **'No additional details available for this word.'**
  String get wordAnalysisNoDetails;

  /// Grammar label for word gender
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get wordAnalysisGrammarGender;

  /// Grammar label for word number
  ///
  /// In en, this message translates to:
  /// **'Number'**
  String get wordAnalysisGrammarNumber;

  /// Grammar label for word person
  ///
  /// In en, this message translates to:
  /// **'Person'**
  String get wordAnalysisGrammarPerson;

  /// Grammar label for word tense
  ///
  /// In en, this message translates to:
  /// **'Tense'**
  String get wordAnalysisGrammarTense;

  /// Grammar label for word mood
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get wordAnalysisGrammarMood;

  /// Grammar label for word voice
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get wordAnalysisGrammarVoice;

  /// Grammar label for word grammar details
  ///
  /// In en, this message translates to:
  /// **'Grammar'**
  String get wordAnalysisGrammarDetails;

  /// Message when word analysis data is not available
  ///
  /// In en, this message translates to:
  /// **'No word analysis available for this verse'**
  String get wordAnalysisNotAvailable;

  /// Navigation label for prayer times section
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get navigationPrayer;

  /// Navigation label for qibla compass section
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get navigationQibla;

  /// Title for Islamic inheritance calculator
  ///
  /// In en, this message translates to:
  /// **'Inheritance Calculator'**
  String get inheritanceCalculatorTitle;

  /// Quick start section header
  ///
  /// In en, this message translates to:
  /// **'Quick Start Guide'**
  String get inheritanceQuickStart;

  /// Step 1 instruction
  ///
  /// In en, this message translates to:
  /// **'1. Enter Estate Value'**
  String get inheritanceEnterEstate;

  /// Step 2 instruction
  ///
  /// In en, this message translates to:
  /// **'2. Select Heirs'**
  String get inheritanceSelectHeirs;

  /// Step 3 instruction
  ///
  /// In en, this message translates to:
  /// **'3. Calculate Distribution'**
  String get inheritanceCalculate;

  /// Button to begin inheritance calculation
  ///
  /// In en, this message translates to:
  /// **'Start Calculation'**
  String get inheritanceStartCalculation;

  /// Features section header
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get inheritanceFeatures;

  /// Feature: Shariah compliance
  ///
  /// In en, this message translates to:
  /// **'📖 Shariah Compliant'**
  String get inheritanceShariahCompliant;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Based on Quran and Sunnah'**
  String get inheritanceBasedOnQuran;

  /// Feature: guided process
  ///
  /// In en, this message translates to:
  /// **'📊 Step-by-Step Guidance'**
  String get inheritanceStepByStep;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Detailed calculation breakdown'**
  String get inheritanceDetailedBreakdown;

  /// Feature: advanced Islamic law support
  ///
  /// In en, this message translates to:
  /// **'⚖️ Aul & Radd Support'**
  String get inheritanceAulRaddSupport;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Handles complex inheritance scenarios'**
  String get inheritanceComplexScenarios;

  /// Feature: religious references
  ///
  /// In en, this message translates to:
  /// **'📚 Quranic References'**
  String get inheritanceQuranicReferences;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Relevant verses and hadiths included'**
  String get inheritanceRelevantVerses;

  /// Feature: language support
  ///
  /// In en, this message translates to:
  /// **'🌍 Bengali Language'**
  String get inheritanceBengaliLanguage;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Full Bengali language support'**
  String get inheritanceBengaliSupport;

  /// Feature: offline capability
  ///
  /// In en, this message translates to:
  /// **'📱 Offline Calculation'**
  String get inheritanceOfflineCalculation;

  /// Feature description
  ///
  /// In en, this message translates to:
  /// **'Works completely offline'**
  String get inheritanceWorksOffline;

  /// Title for qibla compass screen
  ///
  /// In en, this message translates to:
  /// **'Qibla Compass'**
  String get qiblaCompassTitle;

  /// Message when compass is not available
  ///
  /// In en, this message translates to:
  /// **'Compass not available'**
  String get qiblaCompassNotAvailable;

  /// Status when compass is calibrating
  ///
  /// In en, this message translates to:
  /// **'Calibrating Compass...'**
  String get qiblaCompassCalibrating;

  /// Status when compass is unavailable
  ///
  /// In en, this message translates to:
  /// **'Compass Unavailable'**
  String get qiblaCompassUnavailable;

  /// Status when compass is active
  ///
  /// In en, this message translates to:
  /// **'Compass Active'**
  String get qiblaCompassActive;

  /// North direction label
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get qiblaDirectionNorth;

  /// East direction label
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get qiblaDirectionEast;

  /// South direction label
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get qiblaDirectionSouth;

  /// West direction label
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get qiblaDirectionWest;

  /// Label for qibla direction
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get qiblaDirection;

  /// Label for current location
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get qiblaCurrentLocation;

  /// Button to recalibrate compass
  ///
  /// In en, this message translates to:
  /// **'Recalibrate'**
  String get qiblaRecalibrate;

  /// Button to update location
  ///
  /// In en, this message translates to:
  /// **'Update Location'**
  String get qiblaUpdateLocation;

  /// Sort bookmarks option
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get bookmarkSort;

  /// Manage bookmark categories option
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get bookmarkManageCategories;

  /// Export bookmarks option
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get bookmarkExport;

  /// Edit bookmark action
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get bookmarkEdit;

  /// Share bookmark action
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get bookmarkShare;

  /// Delete bookmark action
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get bookmarkDelete;

  /// Bookmarks screen title
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get bookmarks;

  /// All bookmarks tab
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get bookmarkAll;

  /// Categories tab in bookmarks
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get bookmarkCategories;

  /// Recent bookmarks tab
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get bookmarkRecent;

  /// Empty state title for no bookmarks
  ///
  /// In en, this message translates to:
  /// **'No bookmarks yet'**
  String get bookmarkNoBookmarksYet;

  /// Empty state subtitle for no bookmarks
  ///
  /// In en, this message translates to:
  /// **'Bookmark verses while reading to save them here'**
  String get bookmarkNoBookmarksSubtitle;

  /// Empty state title for no categories
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get bookmarkNoCategoriesYet;

  /// Empty state subtitle for no categories
  ///
  /// In en, this message translates to:
  /// **'Create categories to organize your bookmarks'**
  String get bookmarkNoCategoriesSubtitle;

  /// Create category button text
  ///
  /// In en, this message translates to:
  /// **'Create Category'**
  String get bookmarkCreateCategory;

  /// Empty state title for no recent bookmarks
  ///
  /// In en, this message translates to:
  /// **'No recent bookmarks'**
  String get bookmarkNoRecentBookmarks;

  /// Empty state subtitle for no recent bookmarks
  ///
  /// In en, this message translates to:
  /// **'Your recently added bookmarks will appear here'**
  String get bookmarkNoRecentSubtitle;

  /// Edit menu option
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Share menu option
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Font settings section header
  ///
  /// In en, this message translates to:
  /// **'Font Settings'**
  String get quranFontSettings;

  /// Translation settings section header
  ///
  /// In en, this message translates to:
  /// **'Translation Settings'**
  String get quranTranslationSettings;

  /// Content settings section header
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get quranContent;

  /// Arabic text toggle label
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get quranArabic;

  /// Translation text toggle label
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get quranTranslation;

  /// Tafsir commentary toggle label
  ///
  /// In en, this message translates to:
  /// **'Tafsir'**
  String get quranTafsir;

  /// Arabic font size setting
  ///
  /// In en, this message translates to:
  /// **'Arabic Font Size'**
  String get quranArabicFontSize;

  /// Translation font size setting
  ///
  /// In en, this message translates to:
  /// **'Translation Font Size'**
  String get quranTranslationFontSize;

  /// Surah/Chapter navigation tab
  ///
  /// In en, this message translates to:
  /// **'Sura'**
  String get quranSura;

  /// Generic coming soon message
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// Error message for page loading failure
  ///
  /// In en, this message translates to:
  /// **'Error loading page'**
  String get errorLoadingPage;

  /// Download failure message
  ///
  /// In en, this message translates to:
  /// **'Download failed'**
  String get downloadFailed;

  /// Success message when bookmark is removed
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get bookmarkRemoved;

  /// Error message when bookmark removal fails
  ///
  /// In en, this message translates to:
  /// **'Error removing bookmark'**
  String get errorRemovingBookmark;

  /// Sort options placeholder message
  ///
  /// In en, this message translates to:
  /// **'Sort options - Coming soon'**
  String get sortOptionsComingSoon;

  /// Category management placeholder message
  ///
  /// In en, this message translates to:
  /// **'Manage categories - Coming soon'**
  String get manageCategoriesComingSoon;

  /// Export bookmarks placeholder message
  ///
  /// In en, this message translates to:
  /// **'Export bookmarks - Coming soon'**
  String get exportBookmarksComingSoon;

  /// Edit bookmark placeholder message
  ///
  /// In en, this message translates to:
  /// **'Edit bookmark - Coming soon'**
  String get editBookmarkComingSoon;

  /// Add bookmark dialog placeholder message
  ///
  /// In en, this message translates to:
  /// **'Add bookmark dialog - Coming soon'**
  String get addBookmarkDialogComingSoon;

  /// Create category dialog placeholder message
  ///
  /// In en, this message translates to:
  /// **'Create category dialog - Coming soon'**
  String get createCategoryDialogComingSoon;

  /// Edit category placeholder message
  ///
  /// In en, this message translates to:
  /// **'Edit category - Coming soon'**
  String get editCategoryComingSoon;

  /// Delete category placeholder message
  ///
  /// In en, this message translates to:
  /// **'Delete category - Coming soon'**
  String get deleteCategoryComingSoon;

  /// Cache clearing failure message
  ///
  /// In en, this message translates to:
  /// **'Failed to clear cache'**
  String get clearCacheFailed;

  /// Description for Hizb quarter sections
  ///
  /// In en, this message translates to:
  /// **'Quarter section'**
  String get quarterSection;

  /// Verses count label
  ///
  /// In en, this message translates to:
  /// **'Verses'**
  String get verses;

  /// Selected items count suffix
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get selected;

  /// Auto scroll feature button
  ///
  /// In en, this message translates to:
  /// **'Auto Scroll'**
  String get autoScroll;

  /// Quick settings tooltip
  ///
  /// In en, this message translates to:
  /// **'Quick settings'**
  String get quickSettings;

  /// Enter reading mode tooltip
  ///
  /// In en, this message translates to:
  /// **'Enter reading mode'**
  String get enterReadingMode;

  /// Exit reading mode tooltip
  ///
  /// In en, this message translates to:
  /// **'Exit reading mode'**
  String get exitReadingMode;

  /// First notification description in onboarding
  ///
  /// In en, this message translates to:
  /// **'Stay connected with your daily prayers'**
  String get onboardingNotificationDescription1;

  /// Second notification description in onboarding
  ///
  /// In en, this message translates to:
  /// **'Receive timely reminders for Islamic practices'**
  String get onboardingNotificationDescription2;

  /// Instruction for prayer selection in onboarding
  ///
  /// In en, this message translates to:
  /// **'Select which prayers you\'d like to be reminded about'**
  String get onboardingNotificationSelectPrayers;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'bn', 'en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

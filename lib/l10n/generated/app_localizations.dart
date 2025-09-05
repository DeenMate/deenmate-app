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
/// import 'generated/app_localizations.dart';
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

  /// Onboarding location screen title
  ///
  /// In en, this message translates to:
  /// **'Location'**
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

  /// Madhhab selection title
  ///
  /// In en, this message translates to:
  /// **'Select Your Mazhab'**
  String get onboardingMadhhabTitle;

  /// Madhhab subtitle
  ///
  /// In en, this message translates to:
  /// **'Choose your school of Islamic jurisprudence for prayer calculations'**
  String get onboardingMadhhabSubtitle;

  /// Badge for Hanafi
  ///
  /// In en, this message translates to:
  /// **'Most widely followed mazhab'**
  String get onboardingMadhhabMostWidelyFollowed;

  /// Badge for non-Hanafi
  ///
  /// In en, this message translates to:
  /// **'Other major schools of thought'**
  String get onboardingMadhhabOtherSchools;

  /// Hanafi label
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get madhhabHanafi;

  /// Group label
  ///
  /// In en, this message translates to:
  /// **'Shafi\'i, Maliki, Hanbali'**
  String get madhhabShafiMalikiHanbali;

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

  /// Title for Hadith module
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get hadithTitle;

  /// Hadith collections section title
  ///
  /// In en, this message translates to:
  /// **'Hadith Collections'**
  String get hadithCollections;

  /// Popular hadiths section title
  ///
  /// In en, this message translates to:
  /// **'Popular Hadiths'**
  String get hadithPopular;

  /// Recently read hadiths section title
  ///
  /// In en, this message translates to:
  /// **'Recently Read'**
  String get hadithRecentlyRead;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get hadithQuickActions;

  /// Search action
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get hadithSearch;

  /// Topics filter label
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get hadithTopics;

  /// Bookmarks action
  ///
  /// In en, this message translates to:
  /// **'Bookmarks'**
  String get hadithBookmarks;

  /// Read count display
  ///
  /// In en, this message translates to:
  /// **'Read: {count}'**
  String hadithReadCount(int count);

  /// Hadith count display
  ///
  /// In en, this message translates to:
  /// **'{count} Hadiths'**
  String hadithCount(int count);

  /// No collections found message
  ///
  /// In en, this message translates to:
  /// **'No Hadith collections found'**
  String get hadithNoCollections;

  /// No popular hadiths message
  ///
  /// In en, this message translates to:
  /// **'No popular hadiths'**
  String get hadithNoPopular;

  /// No recently read message
  ///
  /// In en, this message translates to:
  /// **'No recently read hadiths'**
  String get hadithNoRecentlyRead;

  /// Error loading collections
  ///
  /// In en, this message translates to:
  /// **'Error loading collections'**
  String get hadithErrorLoadingCollections;

  /// Error loading popular hadiths
  ///
  /// In en, this message translates to:
  /// **'Error loading popular hadiths'**
  String get hadithErrorLoadingPopular;

  /// Error loading recently read
  ///
  /// In en, this message translates to:
  /// **'Error loading recently read'**
  String get hadithErrorLoadingRecentlyRead;

  /// Title for Hadith search screen
  ///
  /// In en, this message translates to:
  /// **'Hadith Search'**
  String get hadithSearchTitle;

  /// Hint text for Hadith search
  ///
  /// In en, this message translates to:
  /// **'Search for hadiths...'**
  String get hadithSearchHint;

  /// Searching message
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get hadithSearching;

  /// Empty search state message
  ///
  /// In en, this message translates to:
  /// **'Search for Hadiths'**
  String get hadithSearchEmpty;

  /// Empty search state subtitle
  ///
  /// In en, this message translates to:
  /// **'Search using keywords'**
  String get hadithSearchEmptySubtitle;

  /// No search results message
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get hadithNoResults;

  /// No results for specific query
  ///
  /// In en, this message translates to:
  /// **'No hadiths found for \"{query}\"'**
  String hadithNoResultsForQuery(String query);

  /// Search error message
  ///
  /// In en, this message translates to:
  /// **'Error occurred while searching'**
  String get hadithSearchError;

  /// Try again button text
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get hadithTryAgain;

  /// Number of search results found
  ///
  /// In en, this message translates to:
  /// **'{count} hadiths found'**
  String hadithResultsFound(int count);

  /// Narrator label
  ///
  /// In en, this message translates to:
  /// **'Narrator: {name}'**
  String hadithNarrator(String name);

  /// Filters section title
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get hadithFilters;

  /// Collection filter label
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get hadithCollection;

  /// Grade filter label
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get hadithGrade;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get hadithAll;

  /// Today's hadith section title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Hadith'**
  String get hadithTodaysHadith;

  /// Search hint text with keyboard shortcut
  ///
  /// In en, this message translates to:
  /// **'Search hadiths (Ctrl+K)'**
  String get hadithSearchHintWithShortcut;

  /// Popular books section title
  ///
  /// In en, this message translates to:
  /// **'Popular Books'**
  String get hadithPopularBooks;

  /// Popular topics section title
  ///
  /// In en, this message translates to:
  /// **'Popular Topics'**
  String get hadithPopularTopics;

  /// Explore more button text
  ///
  /// In en, this message translates to:
  /// **'Explore More'**
  String get hadithExploreMore;

  /// View all button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get hadithViewAll;

  /// Hadith books screen title
  ///
  /// In en, this message translates to:
  /// **'Hadith Books'**
  String get hadithBooksTitle;

  /// Main hadith screen title
  ///
  /// In en, this message translates to:
  /// **'Hadith'**
  String get hadithMainTitle;

  /// Subtitle for theme selection screen
  ///
  /// In en, this message translates to:
  /// **'Select your preferred visual style'**
  String get onboardingThemeSubtitle;

  /// Onboarding completion title
  ///
  /// In en, this message translates to:
  /// **'Setup Complete!'**
  String get onboardingCompleteTitle;

  /// Onboarding completion subtitle
  ///
  /// In en, this message translates to:
  /// **'Your DeenMate app is ready to use'**
  String get onboardingCompleteSubtitle;

  /// Features section header
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get onboardingFeaturesTitle;

  /// Final CTA
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get onboardingGetStarted;

  /// Generic save error
  ///
  /// In en, this message translates to:
  /// **'Error saving preferences'**
  String get errorSavingPreferences;

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

  /// Label for prayer times source
  ///
  /// In en, this message translates to:
  /// **'Prayer Times from Al-Adhan'**
  String get timingsFromAlAdhan;

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

  /// Label for Islamic chapter (Surah)
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get quranSurah;

  /// Page navigation tab
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get quranPage;

  /// Label for Islamic section (Juz/Para)
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

  /// Title for Juz reader screen
  ///
  /// In en, this message translates to:
  /// **'Juz {number}'**
  String quranJuzTitle(int number);

  /// Title for Ruku reader screen
  ///
  /// In en, this message translates to:
  /// **'Ruku {number}'**
  String quranRukuTitle(int number);

  /// Title for Hizb reader screen
  ///
  /// In en, this message translates to:
  /// **'Hizb {number}'**
  String quranHizbTitle(int number);

  /// Title for Page reader screen
  ///
  /// In en, this message translates to:
  /// **'Page {number}'**
  String quranPageTitle(int number);

  /// Message when no verses are found for a section
  ///
  /// In en, this message translates to:
  /// **'No verses found'**
  String get quranNoVersesFound;

  /// Message for features that are not yet complete
  ///
  /// In en, this message translates to:
  /// **'This feature is under development'**
  String get quranFeatureUnderDevelopment;

  /// Error message when content fails to load
  ///
  /// In en, this message translates to:
  /// **'Error loading content: {error}'**
  String quranErrorLoadingContent(String error);

  /// Retry button text for error states
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get quranRetryButton;

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

  /// Language save failed error
  ///
  /// In en, this message translates to:
  /// **'Failed to save language preference. Please try again.'**
  String get errorLanguageChangeFailed;

  /// Generic error
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again.'**
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

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get buttonConfirm;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get buttonDelete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get buttonEdit;

  /// Copy button text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get buttonCopy;

  /// Share button text
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get buttonShare;

  /// View button text
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get buttonView;

  /// Start button text
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get buttonStart;

  /// Stop button text
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get buttonStop;

  /// Action to bookmark a verse
  ///
  /// In en, this message translates to:
  /// **'Bookmark verse'**
  String get verseBookmark;

  /// Action to remove bookmark from verse
  ///
  /// In en, this message translates to:
  /// **'Remove bookmark'**
  String get verseRemoveBookmark;

  /// Action to copy verse text
  ///
  /// In en, this message translates to:
  /// **'Copy verse'**
  String get verseCopy;

  /// Action to share verse
  ///
  /// In en, this message translates to:
  /// **'Share verse'**
  String get verseShare;

  /// Action to view verse commentary
  ///
  /// In en, this message translates to:
  /// **'View tafsir'**
  String get verseViewTafsir;

  /// Loading message for verse translation
  ///
  /// In en, this message translates to:
  /// **'Loading translation...'**
  String get verseLoadingTranslation;

  /// Unknown status or value
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get statusUnknown;

  /// Reading Plans screen title
  ///
  /// In en, this message translates to:
  /// **'Reading Plans'**
  String get readingPlansTitle;

  /// My Plans tab title
  ///
  /// In en, this message translates to:
  /// **'My Plans'**
  String get readingPlansMyPlans;

  /// Today tab title
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get readingPlansToday;

  /// Stats tab title
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get readingPlansStats;

  /// New Plan button text
  ///
  /// In en, this message translates to:
  /// **'New Plan'**
  String get readingPlansNewPlan;

  /// Active plan status
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get readingPlansActive;

  /// Progress label
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get readingPlansProgress;

  /// Days label
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get readingPlansDays;

  /// Verses per day label
  ///
  /// In en, this message translates to:
  /// **'Verses/Day'**
  String get readingPlansVersesPerDay;

  /// Today's reading title
  ///
  /// In en, this message translates to:
  /// **'Today\'s Reading'**
  String get readingPlansTodaysReading;

  /// Start reading button text
  ///
  /// In en, this message translates to:
  /// **'Start Reading'**
  String get readingPlansStartReading;

  /// Start plan menu action
  ///
  /// In en, this message translates to:
  /// **'Start Plan'**
  String get readingPlansStartPlan;

  /// Button to stop/pause a reading plan
  ///
  /// In en, this message translates to:
  /// **'Stop Plan'**
  String get readingPlansStopPlan;

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

  /// Suhur reminder setting title
  ///
  /// In en, this message translates to:
  /// **'Suhur Reminder'**
  String get prayerSuhurReminder;

  /// Iftar reminder setting title
  ///
  /// In en, this message translates to:
  /// **'Iftar Reminder'**
  String get prayerIftarReminder;

  /// Suhur reminder text with minutes placeholder
  ///
  /// In en, this message translates to:
  /// **'Remind me {minutes} minutes before Fajr for Suhur'**
  String prayerSuhurReminderText(int minutes);

  /// Iftar reminder text with minutes placeholder
  ///
  /// In en, this message translates to:
  /// **'Remind me {minutes} minutes before Maghrib for Iftar'**
  String prayerIftarReminderText(int minutes);

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

  /// Ramadan Mubarak greeting
  ///
  /// In en, this message translates to:
  /// **'Ramadan Mubarak!'**
  String get ramadanMubarak;

  /// Ramadan status title
  ///
  /// In en, this message translates to:
  /// **'Ramadan Status'**
  String get ramadanStatus;

  /// Days remaining in Ramadan
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining in this blessed month'**
  String ramadanDaysRemaining(int days);

  /// Ramadan blessed month description
  ///
  /// In en, this message translates to:
  /// **'The blessed month of fasting'**
  String get ramadanBlessedMonth;

  /// Information about when Ramadan settings are active
  ///
  /// In en, this message translates to:
  /// **'Ramadan settings will be active during the holy month'**
  String get ramadanSettingsInfo;

  /// Error message when settings cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Unable to load settings'**
  String get errorUnableToLoadSettings;

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

  /// Title for mobile reading mode overlay
  ///
  /// In en, this message translates to:
  /// **'Reading Mode'**
  String get mobileReadingModeTitle;

  /// Label for reading progress indicator
  ///
  /// In en, this message translates to:
  /// **'Reading Progress'**
  String get mobileReadingModeProgress;

  /// Button label for theme selection in mobile reading mode
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get mobileReadingModeTheme;

  /// Button label for font settings in mobile reading mode
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get mobileReadingModeFont;

  /// Button label for translation settings in mobile reading mode
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get mobileReadingModeTranslation;

  /// Button label for bookmark action in mobile reading mode
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get mobileReadingModeBookmark;

  /// Button label for previous navigation in mobile reading mode
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get mobileReadingModePrevious;

  /// Button label for next navigation in mobile reading mode
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get mobileReadingModeNext;

  /// Title for mobile reading settings sheet
  ///
  /// In en, this message translates to:
  /// **'Reading Settings'**
  String get mobileReadingModeSettings;

  /// Label for brightness control in mobile reading mode
  ///
  /// In en, this message translates to:
  /// **'Screen Brightness'**
  String get mobileReadingModeBrightness;

  /// Label for line height control in mobile reading mode
  ///
  /// In en, this message translates to:
  /// **'Line Height'**
  String get mobileReadingModeLineHeight;

  /// Label for night mode theme option
  ///
  /// In en, this message translates to:
  /// **'Night Mode'**
  String get mobileReadingModeNightMode;

  /// Label for green theme option
  ///
  /// In en, this message translates to:
  /// **'Green Theme'**
  String get mobileReadingModeGreenTheme;

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

  /// Label for Arabic search scope
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get quranArabic;

  /// Label for translation search scope
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get quranTranslation;

  /// Tafsir/commentary feature
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

  /// Feedback when bookmark is removed
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

  /// Sort bookmarks menu option
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get bookmarkSort;

  /// Manage categories menu option
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get bookmarkManageCategories;

  /// Export bookmarks menu option
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get bookmarkExport;

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

  /// Share button
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Copy button text
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get commonCopy;

  /// Message when dua is copied
  ///
  /// In en, this message translates to:
  /// **'Dua copied to clipboard'**
  String get duaCopiedToClipboard;

  /// Sharing feature coming soon message
  ///
  /// In en, this message translates to:
  /// **'Sharing feature coming soon!'**
  String get sharingSoon;

  /// Message when dua is saved to favorites
  ///
  /// In en, this message translates to:
  /// **'Dua saved to favorites!'**
  String get duaSavedToFavorites;

  /// Accessibility settings screen title
  ///
  /// In en, this message translates to:
  /// **'Accessibility Settings'**
  String get accessibilitySettings;

  /// Message when verse is copied
  ///
  /// In en, this message translates to:
  /// **'Verse copied to clipboard'**
  String get verseCopiedToClipboard;

  /// Message when verse is saved to favorites
  ///
  /// In en, this message translates to:
  /// **'Verse saved to favorites!'**
  String get verseSavedToFavorites;

  /// Learn more button text
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// Message when Allah's name is copied
  ///
  /// In en, this message translates to:
  /// **'Name of Allah copied to clipboard'**
  String get nameOfAllahCopied;

  /// Message for detailed explanations coming soon
  ///
  /// In en, this message translates to:
  /// **'Detailed explanations coming soon!'**
  String get detailedExplanationsSoon;

  /// Message when hadith is copied
  ///
  /// In en, this message translates to:
  /// **'Hadith copied to clipboard'**
  String get hadithCopiedToClipboard;

  /// Message when hadith is saved to favorites
  ///
  /// In en, this message translates to:
  /// **'Hadith saved to favorites!'**
  String get hadithSavedToFavorites;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Confirm button for confirmations
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// Clear button for clearing data
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get commonClear;

  /// View button for viewing content
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get commonView;

  /// Go button for navigation
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get commonGo;

  /// Download button for downloading content
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get commonDownload;

  /// Send email button
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get commonSendEmail;

  /// Help button or title
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get commonHelp;

  /// Delete button
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// Title for app exit confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Exit DeenMate'**
  String get navigationExitDialogTitle;

  /// Message for app exit confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the app?'**
  String get navigationExitDialogMessage;

  /// Title for prayer calculation methods screen
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation Methods'**
  String get prayerCalculationMethodsTitle;

  /// Button to apply selected calculation method
  ///
  /// In en, this message translates to:
  /// **'Apply Method'**
  String get prayerCalculationMethodsApplyMethod;

  /// Button to create custom calculation method
  ///
  /// In en, this message translates to:
  /// **'Create Custom Method'**
  String get prayerCalculationMethodsCreateCustom;

  /// Title for more features settings screen
  ///
  /// In en, this message translates to:
  /// **'More Features'**
  String get settingsMoreFeatures;

  /// Athan vibration setting title
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get athanSettingsVibration;

  /// Athan vibration setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Vibrate device during Athan'**
  String get athanSettingsVibrationSubtitle;

  /// Quick actions setting title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get athanSettingsQuickActions;

  /// Quick actions setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Show \"Mark as Prayed\" and \"Snooze\" buttons'**
  String get athanSettingsQuickActionsSubtitle;

  /// Auto-complete setting title
  ///
  /// In en, this message translates to:
  /// **'Auto-complete'**
  String get athanSettingsAutoComplete;

  /// Auto-complete setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Automatically mark prayer as completed'**
  String get athanSettingsAutoCompleteSubtitle;

  /// Add mute time range button text
  ///
  /// In en, this message translates to:
  /// **'Add Mute Time Range'**
  String get athanSettingsAddMuteTimeRange;

  /// Smart notifications setting title
  ///
  /// In en, this message translates to:
  /// **'Smart Notifications'**
  String get athanSettingsSmartNotifications;

  /// Smart notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Adjust notifications based on your activity'**
  String get athanSettingsSmartNotificationsSubtitle;

  /// Override DND setting title
  ///
  /// In en, this message translates to:
  /// **'Override Do Not Disturb'**
  String get athanSettingsOverrideDnd;

  /// Override DND setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Show prayer notifications even in DND mode'**
  String get athanSettingsOverrideDndSubtitle;

  /// Full screen notifications setting title
  ///
  /// In en, this message translates to:
  /// **'Full Screen Notifications'**
  String get athanSettingsFullScreenNotifications;

  /// Full screen notifications setting subtitle
  ///
  /// In en, this message translates to:
  /// **'Show prayer time as full screen alert'**
  String get athanSettingsFullScreenNotificationsSubtitle;

  /// Grant permission button text
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get permissionsGrant;

  /// Title for Athan and Notifications settings screen
  ///
  /// In en, this message translates to:
  /// **'Athan & Notifications'**
  String get athanNotificationsTitle;

  /// Tab title for Athan audio settings
  ///
  /// In en, this message translates to:
  /// **'Athan'**
  String get athanTabTitle;

  /// Tab title for Prayer notification settings
  ///
  /// In en, this message translates to:
  /// **'Prayers'**
  String get prayersTabTitle;

  /// Tab title for Advanced settings
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advancedTabTitle;

  /// Tab title for Ramadan specific settings
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get ramadanTabTitle;

  /// Section title for Athan Settings
  ///
  /// In en, this message translates to:
  /// **'Athan Settings'**
  String get athanSettingsTitle;

  /// Subtitle/description for Athan notifications
  ///
  /// In en, this message translates to:
  /// **'Call to prayer notifications when prayer time arrives'**
  String get athanSettingsSubtitle;

  /// Section title for Prayer Notifications
  ///
  /// In en, this message translates to:
  /// **'Prayer Notifications'**
  String get prayerNotificationsTitle;

  /// Section subtitle for Prayer Notifications
  ///
  /// In en, this message translates to:
  /// **'Customize notifications for each prayer'**
  String get prayerNotificationsSubtitle;

  /// Recommendation text for precise timing
  ///
  /// In en, this message translates to:
  /// **'Precise timing recommended for Athan'**
  String get preciseTimingRecommended;

  /// Section title for Advanced Settings
  ///
  /// In en, this message translates to:
  /// **'Advanced Settings'**
  String get advancedSettingsTitle;

  /// Section subtitle for Advanced Settings
  ///
  /// In en, this message translates to:
  /// **'Fine-tune notification behavior'**
  String get advancedSettingsSubtitle;

  /// Section title for Ramadan Settings
  ///
  /// In en, this message translates to:
  /// **'Ramadan Settings'**
  String get ramadanSettingsTitle;

  /// Section subtitle for Ramadan Settings
  ///
  /// In en, this message translates to:
  /// **'Special notifications for the holy month'**
  String get ramadanSettingsSubtitle;

  /// Status text when notifications are enabled
  ///
  /// In en, this message translates to:
  /// **'Notifications are enabled'**
  String get notificationsEnabled;

  /// Status text when notifications are disabled
  ///
  /// In en, this message translates to:
  /// **'Notifications are disabled'**
  String get notificationsDisabled;

  /// Section title for Audio Settings
  ///
  /// In en, this message translates to:
  /// **'Audio Settings'**
  String get audioSettingsTitle;

  /// Label for duration settings
  ///
  /// In en, this message translates to:
  /// **'Duration: '**
  String get durationLabel;

  /// Section title for Reminder Time
  ///
  /// In en, this message translates to:
  /// **'Reminder Time'**
  String get reminderTimeTitle;

  /// Section subtitle for Reminder Time
  ///
  /// In en, this message translates to:
  /// **'Notify me this many minutes before prayer time:'**
  String get reminderTimeSubtitle;

  /// Instruction for prayer notification selection
  ///
  /// In en, this message translates to:
  /// **'Choose which prayers to receive notifications for:'**
  String get choosePrayerNotifications;

  /// Section title for Notification Actions
  ///
  /// In en, this message translates to:
  /// **'Notification Actions'**
  String get notificationActionsTitle;

  /// Section title for Mute Settings
  ///
  /// In en, this message translates to:
  /// **'Mute Settings'**
  String get muteSettingsTitle;

  /// Section subtitle for Mute Settings
  ///
  /// In en, this message translates to:
  /// **'Configure when notifications should be silenced:'**
  String get muteSettingsSubtitle;

  /// Label for muted days selection
  ///
  /// In en, this message translates to:
  /// **'Muted Days:'**
  String get mutedDaysLabel;

  /// Monday weekday name
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get monday;

  /// Tuesday weekday name
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tuesday;

  /// Wednesday weekday name
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wednesday;

  /// Thursday weekday name
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thursday;

  /// Friday weekday name
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get friday;

  /// Saturday weekday name
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get saturday;

  /// Sunday weekday name
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sunday;

  /// Label for recommended calculation method
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get methodsRecommended;

  /// All calculation methods tab
  ///
  /// In en, this message translates to:
  /// **'All Methods'**
  String get methodsAllMethods;

  /// Compare calculation methods tab
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get methodsCompare;

  /// Location-based recommendations section title
  ///
  /// In en, this message translates to:
  /// **'Location-Based Recommendations'**
  String get methodsLocationBasedRecommendations;

  /// Explanation text for location-based recommendations
  ///
  /// In en, this message translates to:
  /// **'These methods are recommended for your region. Location detection would normally determine this automatically.'**
  String get methodsLocationRecommendationText;

  /// Title for all available methods section
  ///
  /// In en, this message translates to:
  /// **'All Available Methods'**
  String get methodsAllAvailableMethods;

  /// Description of available calculation methods
  ///
  /// In en, this message translates to:
  /// **'{count} calculation methods from Islamic organizations worldwide.'**
  String methodsFromOrganizations(int count);

  /// Method comparison section title
  ///
  /// In en, this message translates to:
  /// **'Method Comparison'**
  String get methodComparison;

  /// Method comparison description
  ///
  /// In en, this message translates to:
  /// **'Select two methods to compare their angles and characteristics.'**
  String get methodComparisonDescription;

  /// First method in comparison
  ///
  /// In en, this message translates to:
  /// **'Method 1'**
  String get methodComparisonMethod1;

  /// Second method in comparison
  ///
  /// In en, this message translates to:
  /// **'Method 2'**
  String get methodComparisonMethod2;

  /// Fallback text for unknown organization
  ///
  /// In en, this message translates to:
  /// **'Unknown Organization'**
  String get methodUnknownOrganization;

  /// Format for displaying prayer angle
  ///
  /// In en, this message translates to:
  /// **'{label}: {angle}°'**
  String methodAngleFormat(String label, String angle);

  /// Tooltip for about calculation methods button
  ///
  /// In en, this message translates to:
  /// **'About Calculation Methods'**
  String get methodsAboutTooltip;

  /// Tooltip for hide comparison button
  ///
  /// In en, this message translates to:
  /// **'Hide Comparison'**
  String get methodsHideComparisonTooltip;

  /// Apply method button text
  ///
  /// In en, this message translates to:
  /// **'Apply Method'**
  String get methodsApplyMethod;

  /// Custom methods tab
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get methodsCustom;

  /// Placeholder text when calculation method organization is unknown
  ///
  /// In en, this message translates to:
  /// **'Unknown Organization'**
  String get methodsUnknownOrganization;

  /// Placeholder text when data is not available
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get methodsNotAvailable;

  /// Label for impact assessment section in method comparison
  ///
  /// In en, this message translates to:
  /// **'Impact Assessment:'**
  String get methodsImpactAssessment;

  /// Label for Fajr prayer in calculation methods
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get methodsFajr;

  /// Label for Isha prayer in calculation methods
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get methodsIsha;

  /// Hint text for method selection dropdown
  ///
  /// In en, this message translates to:
  /// **'Select a calculation method'**
  String get methodsSelectMethod;

  /// Title for comparison results section
  ///
  /// In en, this message translates to:
  /// **'Comparison Results'**
  String get methodsComparisonResults;

  /// Label for Fajr angle in method comparison
  ///
  /// In en, this message translates to:
  /// **'Fajr Angle'**
  String get methodsFajrAngle;

  /// Label for Isha angle in method comparison
  ///
  /// In en, this message translates to:
  /// **'Isha Angle'**
  String get methodsIshaAngle;

  /// Label for organization in method comparison
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get methodsOrganization;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get methodsRetry;

  /// Label for user's current location
  ///
  /// In en, this message translates to:
  /// **'Your Location'**
  String get methodsYourLocation;

  /// Title for recommended methods section
  ///
  /// In en, this message translates to:
  /// **'Recommended Methods'**
  String get methodsRecommendedMethods;

  /// Title for custom method section
  ///
  /// In en, this message translates to:
  /// **'Custom Method'**
  String get methodsCustomMethod;

  /// Title for custom method creator
  ///
  /// In en, this message translates to:
  /// **'Custom Method Creator'**
  String get methodsCustomMethodCreator;

  /// Button text to create custom method
  ///
  /// In en, this message translates to:
  /// **'Create Custom Method'**
  String get methodsCreateCustomMethod;

  /// View button text
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get methodsView;

  /// Title for calculation methods info dialog
  ///
  /// In en, this message translates to:
  /// **'About Calculation Methods'**
  String get methodsAboutCalculationMethods;

  /// Button text to dismiss dialog
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get methodsGotIt;

  /// Error message when location cannot be loaded
  ///
  /// In en, this message translates to:
  /// **'Unable to load location'**
  String get unableToLoadLocation;

  /// Message explaining location requirement
  ///
  /// In en, this message translates to:
  /// **'Location is needed to show recommended methods'**
  String get locationIsNeeded;

  /// Retry button text in Athan settings
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get athanSettingsRetry;

  /// Coming soon message for features
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon...'**
  String get athanSettingsFeatureComingSoon;

  /// Success message when Athan test starts
  ///
  /// In en, this message translates to:
  /// **'Athan audio test started'**
  String get athanSettingsTestStarted;

  /// Error message when Athan test fails
  ///
  /// In en, this message translates to:
  /// **'Athan test failed'**
  String get athanSettingsTestFailed;

  /// Test Athan audio button text
  ///
  /// In en, this message translates to:
  /// **'Test Athan Audio'**
  String get athanSettingsTestAthanAudio;

  /// Success message when notifications are scheduled
  ///
  /// In en, this message translates to:
  /// **'Notifications scheduled for today'**
  String get athanSettingsNotificationsScheduled;

  /// Error message when scheduling fails
  ///
  /// In en, this message translates to:
  /// **'Scheduling failed'**
  String get athanSettingsSchedulingFailed;

  /// Schedule notifications button text
  ///
  /// In en, this message translates to:
  /// **'Schedule Now'**
  String get athanSettingsScheduleNow;

  /// Error message when debug info fails
  ///
  /// In en, this message translates to:
  /// **'Debug failed'**
  String get athanSettingsDebugFailed;

  /// Debug info button text
  ///
  /// In en, this message translates to:
  /// **'Debug Info'**
  String get athanSettingsDebugInfo;

  /// Success message for prayer notifications scheduling
  ///
  /// In en, this message translates to:
  /// **'Prayer notifications scheduled for today'**
  String get athanSettingsPrayerNotificationsScheduled;

  /// Error message when test notification fails
  ///
  /// In en, this message translates to:
  /// **'Test notification failed'**
  String get athanSettingsTestNotificationFailed;

  /// Schedule prayer notifications button text
  ///
  /// In en, this message translates to:
  /// **'Schedule Prayer Notifications'**
  String get athanSettingsSchedulePrayerNotifications;

  /// Success message when test notification is sent
  ///
  /// In en, this message translates to:
  /// **'Test notification sent immediately!'**
  String get athanSettingsTestNotificationSent;

  /// Test notification 1 second button text
  ///
  /// In en, this message translates to:
  /// **'Test Notification (1 sec)'**
  String get athanSettingsTestNotification1Sec;

  /// Success message when demo notification is sent
  ///
  /// In en, this message translates to:
  /// **'Demo notification sent! Azan should play now.'**
  String get athanSettingsDemoNotificationSent;

  /// Error message when demo notification fails
  ///
  /// In en, this message translates to:
  /// **'Demo notification failed'**
  String get athanSettingsDemoNotificationFailed;

  /// Demo notification 2 minutes button text
  ///
  /// In en, this message translates to:
  /// **'Demo Notification (2 min)'**
  String get athanSettingsDemoNotification2Min;

  /// Success message for immediate notification
  ///
  /// In en, this message translates to:
  /// **'Immediate notification sent!'**
  String get athanSettingsImmediateNotificationSent;

  /// Error message when Quran reader fails to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load: {errorMessage}'**
  String quranReaderLoadError(String errorMessage);

  /// Label for audio management controls
  ///
  /// In en, this message translates to:
  /// **'Audio Manager'**
  String get quranReaderAudioManager;

  /// Label for auto scroll feature
  ///
  /// In en, this message translates to:
  /// **'Auto Scroll'**
  String get quranReaderAutoScroll;

  /// Label to enable auto scroll functionality
  ///
  /// In en, this message translates to:
  /// **'Enable Auto Scroll'**
  String get quranReaderEnableAutoScroll;

  /// Label for quick navigation feature
  ///
  /// In en, this message translates to:
  /// **'Quick Jump'**
  String get quranReaderQuickJump;

  /// Option to copy only Arabic verse text
  ///
  /// In en, this message translates to:
  /// **'Copy Arabic Text'**
  String get quranReaderCopyArabicText;

  /// Subtitle explaining Arabic text copy feature
  ///
  /// In en, this message translates to:
  /// **'Copy only the Arabic verse'**
  String get quranReaderCopyArabicSubtitle;

  /// Option to copy only translation text
  ///
  /// In en, this message translates to:
  /// **'Copy Translation'**
  String get quranReaderCopyTranslation;

  /// Subtitle explaining translation copy feature
  ///
  /// In en, this message translates to:
  /// **'Copy only the translation'**
  String get quranReaderCopyTranslationSubtitle;

  /// Option to copy complete verse with translation
  ///
  /// In en, this message translates to:
  /// **'Copy Full Verse'**
  String get quranReaderCopyFullVerse;

  /// Subtitle explaining full verse copy feature
  ///
  /// In en, this message translates to:
  /// **'Copy Arabic text with translation'**
  String get quranReaderCopyFullVerseSubtitle;

  /// Option to report translation errors
  ///
  /// In en, this message translates to:
  /// **'Report Translation Error'**
  String get quranReaderReportError;

  /// Subtitle explaining error reporting feature
  ///
  /// In en, this message translates to:
  /// **'Help improve translation accuracy'**
  String get quranReaderReportErrorSubtitle;

  /// Dialog title for reporting translation errors
  ///
  /// In en, this message translates to:
  /// **'Report Translation Error'**
  String get quranReaderReportErrorDialogTitle;

  /// Success message when verse is copied
  ///
  /// In en, this message translates to:
  /// **'Verse copied to clipboard'**
  String get quranVerseCopiedToClipboard;

  /// Button to add a new bookmark
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get bookmarksAddBookmark;

  /// Placeholder message for bookmark dialog feature
  ///
  /// In en, this message translates to:
  /// **'Add bookmark dialog - Coming soon'**
  String get bookmarksAddBookmarkComingSoon;

  /// Placeholder message for category creation feature
  ///
  /// In en, this message translates to:
  /// **'Create category dialog - Coming soon'**
  String get bookmarksCreateCategoryComingSoon;

  /// Placeholder message for bookmark sorting feature
  ///
  /// In en, this message translates to:
  /// **'Sort options - Coming soon'**
  String get bookmarksSortOptionsComingSoon;

  /// Placeholder message for category management feature
  ///
  /// In en, this message translates to:
  /// **'Manage categories - Coming soon'**
  String get bookmarksManageCategoriesComingSoon;

  /// Placeholder message for bookmark export feature
  ///
  /// In en, this message translates to:
  /// **'Export bookmarks - Coming soon'**
  String get bookmarksExportBookmarksComingSoon;

  /// Button to mark reading session as complete
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get readingPlansMarkComplete;

  /// Button to create a new reading plan
  ///
  /// In en, this message translates to:
  /// **'Create Plan'**
  String get readingPlansCreatePlan;

  /// Button to delete a reading plan
  ///
  /// In en, this message translates to:
  /// **'Delete Plan'**
  String get readingPlansDeletePlan;

  /// Confirmation dialog for deleting a reading plan
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{planName}\"?'**
  String readingPlansDeletePlanConfirm(String planName);

  /// Title for create reading plan dialog
  ///
  /// In en, this message translates to:
  /// **'Create Reading Plan'**
  String get readingPlansCreatePlanTitle;

  /// Label for 30-day reading plan type
  ///
  /// In en, this message translates to:
  /// **'30-Day'**
  String get readingPlansThirtyDay;

  /// Label for Ramadan reading plan type
  ///
  /// In en, this message translates to:
  /// **'Ramadan'**
  String get readingPlansRamadan;

  /// Label for custom reading plan type
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get readingPlansCustom;

  /// Success message when reading plan is created
  ///
  /// In en, this message translates to:
  /// **'Reading plan created successfully!'**
  String get readingPlansPlanCreatedSuccess;

  /// Title for quick tools panel
  ///
  /// In en, this message translates to:
  /// **'Quick Tools'**
  String get quickTools;

  /// Navigation section header
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get navigation;

  /// Reading controls section header
  ///
  /// In en, this message translates to:
  /// **'Reading Controls'**
  String get readingControls;

  /// Actions section header
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Button to jump to a specific verse
  ///
  /// In en, this message translates to:
  /// **'Jump to Verse'**
  String get jumpToVerse;

  /// Button to increase font size
  ///
  /// In en, this message translates to:
  /// **'Font +'**
  String get fontSizeIncrease;

  /// Button to decrease font size
  ///
  /// In en, this message translates to:
  /// **'Font -'**
  String get fontSizeDecrease;

  /// Theme toggle button
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Label for translation font size control
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get translation;

  /// Button to add bookmark
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get addBookmark;

  /// Button to remove bookmark
  ///
  /// In en, this message translates to:
  /// **'Bookmarked'**
  String get removeBookmark;

  /// Navigation mode for Surah
  ///
  /// In en, this message translates to:
  /// **'Surah'**
  String get surah;

  /// Navigation mode for Page
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get page;

  /// Navigation mode for Juz/Para
  ///
  /// In en, this message translates to:
  /// **'Juz'**
  String get juz;

  /// Button to play verse audio
  ///
  /// In en, this message translates to:
  /// **'Play Audio'**
  String get playAudio;

  /// Button for additional actions
  ///
  /// In en, this message translates to:
  /// **'More Actions'**
  String get moreActions;

  /// Quick actions panel title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Copy action button
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Text size adjustment button
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// Translation button
  ///
  /// In en, this message translates to:
  /// **'Translate'**
  String get translate;

  /// Feedback when audio starts playing
  ///
  /// In en, this message translates to:
  /// **'Audio playing...'**
  String get audioPlaying;

  /// Feedback when bookmark is added
  ///
  /// In en, this message translates to:
  /// **'Bookmark added'**
  String get bookmarkAdded;

  /// Feedback when verse is shared
  ///
  /// In en, this message translates to:
  /// **'Verse shared'**
  String get verseShared;

  /// Feedback when more options are opened
  ///
  /// In en, this message translates to:
  /// **'More options opened'**
  String get moreOptionsOpened;

  /// Generic action completion feedback
  ///
  /// In en, this message translates to:
  /// **'Action completed'**
  String get actionCompleted;

  /// Text size adjustment feature
  ///
  /// In en, this message translates to:
  /// **'Text size adjustment'**
  String get textSizeAdjustment;

  /// Translation options feature
  ///
  /// In en, this message translates to:
  /// **'Translation options'**
  String get translationOptions;

  /// Copy options dialog title
  ///
  /// In en, this message translates to:
  /// **'Copy Options'**
  String get copyOptions;

  /// Option to copy Arabic text
  ///
  /// In en, this message translates to:
  /// **'Copy Arabic Text'**
  String get copyArabicText;

  /// Subtitle for copy Arabic option
  ///
  /// In en, this message translates to:
  /// **'Copy only the Arabic verse'**
  String get copyArabicSubtitle;

  /// Option to copy translation
  ///
  /// In en, this message translates to:
  /// **'Copy Translation'**
  String get copyTranslation;

  /// Subtitle for copy translation option
  ///
  /// In en, this message translates to:
  /// **'Copy only the translation'**
  String get copyTranslationSubtitle;

  /// Option to copy full verse
  ///
  /// In en, this message translates to:
  /// **'Copy Full Verse'**
  String get copyFullVerse;

  /// Subtitle for copy full verse option
  ///
  /// In en, this message translates to:
  /// **'Copy Arabic text with translation'**
  String get copyFullVerseSubtitle;

  /// Feedback when Arabic text is copied
  ///
  /// In en, this message translates to:
  /// **'Arabic text copied'**
  String get arabicTextCopied;

  /// Feedback when translation is copied
  ///
  /// In en, this message translates to:
  /// **'Translation copied'**
  String get translationCopied;

  /// Feedback when full verse is copied
  ///
  /// In en, this message translates to:
  /// **'Full verse copied'**
  String get fullVerseCopied;

  /// Gesture hint for tap action
  ///
  /// In en, this message translates to:
  /// **'Tap for actions'**
  String get tapForActions;

  /// Gesture hint for swipe actions
  ///
  /// In en, this message translates to:
  /// **'Swipe for quick actions'**
  String get swipeForQuickActions;

  /// Title for font controls widget
  ///
  /// In en, this message translates to:
  /// **'Font Controls'**
  String get fontControls;

  /// Label for Arabic text font size control
  ///
  /// In en, this message translates to:
  /// **'Arabic Text'**
  String get arabicText;

  /// Button text to reset font sizes to default
  ///
  /// In en, this message translates to:
  /// **'Reset Font Sizes'**
  String get resetFontSizes;

  /// Label for font preview section
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// Feedback when Arabic font size is adjusted
  ///
  /// In en, this message translates to:
  /// **'Arabic font size adjusted'**
  String get arabicFontAdjusted;

  /// Feedback when translation font size is adjusted
  ///
  /// In en, this message translates to:
  /// **'Translation font size adjusted'**
  String get translationFontAdjusted;

  /// Feedback when font sizes are reset
  ///
  /// In en, this message translates to:
  /// **'Font sizes reset to default'**
  String get fontSizesReset;

  /// Next track button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get audioNext;

  /// Previous track button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get audioPrevious;

  /// Repeat mode button
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get audioRepeat;

  /// Playback speed control
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get audioSpeed;

  /// Seek forward button tooltip
  ///
  /// In en, this message translates to:
  /// **'Seek forward 10 seconds'**
  String get audioSeekForward;

  /// Seek backward button tooltip
  ///
  /// In en, this message translates to:
  /// **'Seek backward 10 seconds'**
  String get audioSeekBackward;

  /// Message when no audio track is selected
  ///
  /// In en, this message translates to:
  /// **'No track selected'**
  String get audioNoTrackSelected;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Detailed hint text for hadith search
  ///
  /// In en, this message translates to:
  /// **'Search hadiths... (e.g., intention, deed)'**
  String get hadithSearchDetailedHint;

  /// Search button text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get hadithSearchButton;

  /// Progress text while searching
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get hadithSearchingProgress;

  /// Popular searches section title
  ///
  /// In en, this message translates to:
  /// **'Popular Searches'**
  String get hadithPopularSearches;

  /// Recent searches section title
  ///
  /// In en, this message translates to:
  /// **'Recent Searches'**
  String get hadithRecentSearches;

  /// Message when no recent searches
  ///
  /// In en, this message translates to:
  /// **'No recent searches yet'**
  String get hadithNoRecentSearches;

  /// Loading message while searching
  ///
  /// In en, this message translates to:
  /// **'Searching hadiths...'**
  String get hadithSearchLoadingMessage;

  /// No search results found message
  ///
  /// In en, this message translates to:
  /// **'No hadiths found'**
  String get hadithNoResultsFound;

  /// Detailed no results message
  ///
  /// In en, this message translates to:
  /// **'No hadiths found for \'{query}\'. Try searching for something else.'**
  String hadithNoResultsFoundDetails(String query);

  /// Button to try different search
  ///
  /// In en, this message translates to:
  /// **'Try Different Search'**
  String get hadithTryDifferentSearch;

  /// Button to clear search
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get hadithClearSearch;

  /// Button to change filter
  ///
  /// In en, this message translates to:
  /// **'Change Filter'**
  String get hadithChangeFilter;

  /// Search context showing what was searched for
  ///
  /// In en, this message translates to:
  /// **'for \'{query}\''**
  String hadithSearchContextFor(String query);

  /// Title for hadith books screen
  ///
  /// In en, this message translates to:
  /// **'Hadith Books'**
  String get hadithBooksScreenTitle;

  /// Hint text for hadith books search
  ///
  /// In en, this message translates to:
  /// **'Search hadith books...'**
  String get hadithBooksSearchHint;

  /// Filter option for all books
  ///
  /// In en, this message translates to:
  /// **'All Books'**
  String get hadithBooksFilterAll;

  /// Filter option for popular books
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get hadithBooksFilterPopular;

  /// Filter option for Kutub Sittah books
  ///
  /// In en, this message translates to:
  /// **'Kutub Sittah'**
  String get hadithBooksFilterKutubSittah;

  /// Text showing number of hadiths in a book
  ///
  /// In en, this message translates to:
  /// **'{count} hadiths'**
  String hadithBooksCountText(int count);

  /// Label for popular hadith books
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get hadithBooksPopularLabel;

  /// Message when no books found
  ///
  /// In en, this message translates to:
  /// **'No books found'**
  String get hadithBooksNoBooksFound;

  /// Subtitle for empty state in hadith books screen
  ///
  /// In en, this message translates to:
  /// **'Try searching for something else or change your filter'**
  String get hadithBooksEmptyStateSubtitle;

  /// Button text to show all books when no results found
  ///
  /// In en, this message translates to:
  /// **'Show all books'**
  String get hadithBooksShowAllBooks;

  /// Subtitle for popular hadith books section
  ///
  /// In en, this message translates to:
  /// **'Valuable hadith collections to organize life in the light of Islam'**
  String get hadithPopularBooksSubtitle;

  /// Subtitle for popular hadith topics section
  ///
  /// In en, this message translates to:
  /// **'Subject-wise hadith collections helpful in all areas of life'**
  String get hadithPopularTopicsSubtitle;

  /// Text showing total number of hadiths
  ///
  /// In en, this message translates to:
  /// **'Total hadiths {count}'**
  String hadithTotalCount(int count);

  /// Title for bookmark action
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get hadithBookmarkTitle;

  /// Subtitle for bookmark action
  ///
  /// In en, this message translates to:
  /// **'Saved hadiths'**
  String get hadithBookmarkSubtitle;

  /// No description provided for @hadithQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get hadithQuickAccess;

  /// No description provided for @hadithAdvancedSearch.
  ///
  /// In en, this message translates to:
  /// **'Advanced Search'**
  String get hadithAdvancedSearch;

  /// No description provided for @hadithAdvancedSearchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search in detail'**
  String get hadithAdvancedSearchSubtitle;

  /// Copy button text in hadith detail screen
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get hadithDetailCopy;

  /// Share button text in hadith detail screen
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get hadithDetailShare;

  /// Settings button text in hadith detail screen
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get hadithDetailSettings;

  /// Hadith number display text
  ///
  /// In en, this message translates to:
  /// **'Hadith number {number}'**
  String hadithDetailNumber(String number);

  /// Label for Arabic text section
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get hadithDetailArabicText;

  /// Label for translation section
  ///
  /// In en, this message translates to:
  /// **'Bengali Translation'**
  String get hadithDetailTranslation;

  /// Font size setting label
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get hadithDetailFontSize;

  /// Arabic text toggle label
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get hadithDetailArabicLabel;

  /// Translation text toggle label
  ///
  /// In en, this message translates to:
  /// **'Translation'**
  String get hadithDetailTranslationLabel;

  /// Reference information section title
  ///
  /// In en, this message translates to:
  /// **'Reference Information'**
  String get hadithDetailReferenceInfo;

  /// Narrator field label
  ///
  /// In en, this message translates to:
  /// **'Narrator'**
  String get hadithDetailNarrator;

  /// Chapter field label
  ///
  /// In en, this message translates to:
  /// **'Chapter'**
  String get hadithDetailChapter;

  /// Grade field label
  ///
  /// In en, this message translates to:
  /// **'Grade'**
  String get hadithDetailGrade;

  /// Reference field label
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get hadithDetailReference;

  /// Related topics section title
  ///
  /// In en, this message translates to:
  /// **'Related Topics'**
  String get hadithDetailRelatedTopics;

  /// Copy full hadith button text
  ///
  /// In en, this message translates to:
  /// **'Copy Full'**
  String get hadithDetailCopyFull;

  /// Share hadith button text
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get hadithDetailShareButton;

  /// Message when hadith is bookmarked
  ///
  /// In en, this message translates to:
  /// **'Hadith bookmarked'**
  String get hadithDetailBookmarkAdded;

  /// Message when bookmark is removed
  ///
  /// In en, this message translates to:
  /// **'Bookmark removed'**
  String get hadithDetailBookmarkRemoved;

  /// Message when text is copied
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get hadithDetailCopied;

  /// Success message when hadith is shared
  ///
  /// In en, this message translates to:
  /// **'Hadith shared successfully'**
  String get hadithDetailShared;

  /// Template for sharing hadith
  ///
  /// In en, this message translates to:
  /// **'{arabicText}\n\n{bengaliText}\n\nReference: {reference}\nNarrator: {narrator}'**
  String hadithShareTemplate(
      String arabicText, String bengaliText, String reference, String narrator);

  /// Format for topic display
  ///
  /// In en, this message translates to:
  /// **'{order} {name}'**
  String hadithTopicFormat(String order, String name);

  /// Reference label format
  ///
  /// In en, this message translates to:
  /// **'Reference: {reference}'**
  String hadithReferenceLabel(String reference);

  /// Narrator label format
  ///
  /// In en, this message translates to:
  /// **'Narrator: {narrator}'**
  String hadithNarratorLabel(String narrator);

  /// Chapter label format
  ///
  /// In en, this message translates to:
  /// **'Chapter: {chapter}'**
  String hadithChapterLabel(String chapter);

  /// Title for Quran audio manager sheet
  ///
  /// In en, this message translates to:
  /// **'Audio Manager'**
  String get quranAudioManager;

  /// Label before reciter name
  ///
  /// In en, this message translates to:
  /// **'Reciter:'**
  String get quranReciterLabel;

  /// Error text when loading reciters fails
  ///
  /// In en, this message translates to:
  /// **'Failed to load reciters: {error}'**
  String quranFailedToLoadReciters(String error);

  /// Generic start of download message
  ///
  /// In en, this message translates to:
  /// **'Starting download...'**
  String get audioDownloadStarting;

  /// Download progress message
  ///
  /// In en, this message translates to:
  /// **'Downloading {name}: {progress}%'**
  String audioDownloadProgress(String name, num progress);

  /// Download completed message
  ///
  /// In en, this message translates to:
  /// **'Download complete'**
  String get audioDownloadComplete;

  /// Storage used label
  ///
  /// In en, this message translates to:
  /// **'Storage used: {size}'**
  String audioStorageUsed(String size);

  /// Prompt to select reciter
  ///
  /// In en, this message translates to:
  /// **'Select reciter'**
  String get audioSelectReciter;

  /// Title for Zakat calculator screen
  ///
  /// In en, this message translates to:
  /// **'Zakat Calculator'**
  String get zakatTitle;

  /// Reset confirmation title
  ///
  /// In en, this message translates to:
  /// **'Reset Calculator'**
  String get zakatResetDialogTitle;

  /// Reset confirmation message
  ///
  /// In en, this message translates to:
  /// **'Clear all entered data?'**
  String get zakatResetDialogMessage;

  /// Snackbar after reset
  ///
  /// In en, this message translates to:
  /// **'Calculator reset successfully'**
  String get zakatResetSuccess;

  /// Reset form tooltip
  ///
  /// In en, this message translates to:
  /// **'Reset Form'**
  String get zakatResetFormTooltip;

  /// Calculate button
  ///
  /// In en, this message translates to:
  /// **'Calculate Zakat'**
  String get zakatCalculate;

  /// Calculating label
  ///
  /// In en, this message translates to:
  /// **'Calculating...'**
  String get zakatCalculating;

  /// Reset button common
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get commonReset;

  /// Label above ayah navigation input
  ///
  /// In en, this message translates to:
  /// **'Go to Ayah (chapter:verse)'**
  String get quranGoToAyahHint;

  /// Example placeholder for ayah input
  ///
  /// In en, this message translates to:
  /// **'e.g., 2:255'**
  String get quranExampleAyahHint;

  /// Go button for ayah navigation
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get quranGoButton;

  /// Header for verse options sheet
  ///
  /// In en, this message translates to:
  /// **'Verse Options'**
  String get quranVerseOptions;

  /// Juz dropdown item label
  ///
  /// In en, this message translates to:
  /// **'Juz {number}'**
  String quranJuzItem(int number);

  /// Snackbar for calc error
  ///
  /// In en, this message translates to:
  /// **'Error calculating Zakat: {error}'**
  String zakatCalcError(String error);

  /// Snackbar for calc success
  ///
  /// In en, this message translates to:
  /// **'Zakat calculation completed successfully'**
  String get zakatCalculationSuccess;

  /// Error loading nisab
  ///
  /// In en, this message translates to:
  /// **'Unable to load Nisab information: {error}'**
  String zakatUnableToLoadNisab(String error);

  /// Calculation error title
  ///
  /// In en, this message translates to:
  /// **'Calculation Error'**
  String get zakatCalculationError;

  /// About section title
  ///
  /// In en, this message translates to:
  /// **'About Zakat'**
  String get zakatAboutTitle;

  /// About text body
  ///
  /// In en, this message translates to:
  /// **'Zakat is one of the Five Pillars of Islam and represents 2.5% of your wealth that must be given to those in need when your assets exceed the Nisab threshold for a full lunar year.'**
  String get zakatAboutBody;

  /// Currency label
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get zakatCurrencyLabel;

  /// Maps currency code to label via switch in code
  ///
  /// In en, this message translates to:
  /// **'{code}'**
  String zakatCurrencyName(String code);

  /// Validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get zakatInvalidAmount;

  /// No description provided for @methodsAllAvailableMethodsCount.
  ///
  /// In en, this message translates to:
  /// **'Choose from all {count} available calculation methods used worldwide.'**
  String methodsAllAvailableMethodsCount(int count);

  /// Prompt to create custom method
  ///
  /// In en, this message translates to:
  /// **'Create your own calculation method with custom angles.'**
  String get methodsCreateCustomAngles;

  /// No description provided for @methodsApplied.
  ///
  /// In en, this message translates to:
  /// **'Applied \"{name}\" calculation method'**
  String methodsApplied(String name);

  /// No description provided for @methodsApplyFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to apply method: {error}'**
  String methodsApplyFailed(String error);

  /// Info bullet
  ///
  /// In en, this message translates to:
  /// **'• Fajr Angle: Determines morning prayer time'**
  String get methodsInfoFajrAngle;

  /// Info bullet
  ///
  /// In en, this message translates to:
  /// **'• Isha Angle: Determines night prayer time'**
  String get methodsInfoIshaAngle;

  /// Info bullet
  ///
  /// In en, this message translates to:
  /// **'• Regional Preferences: Based on local scholarly consensus'**
  String get methodsInfoRegionalPref;

  /// Info bullet
  ///
  /// In en, this message translates to:
  /// **'• Madhab Differences: Mainly affect Asr calculation'**
  String get methodsInfoMadhabDiff;

  /// Coming soon message
  ///
  /// In en, this message translates to:
  /// **'Custom method creation will be available in a future update.'**
  String get methodsCustomComingSoon;

  /// Test notification body
  ///
  /// In en, this message translates to:
  /// **'This is a test prayer notification'**
  String get athanSettingsTestNotificationMessage;

  /// Demo notification body
  ///
  /// In en, this message translates to:
  /// **'This is a demo prayer notification with Azan'**
  String get athanSettingsDemoNotificationMessage;

  /// Immediate notification body
  ///
  /// In en, this message translates to:
  /// **'This is an immediate test notification'**
  String get athanSettingsImmediateTestMessage;

  /// Label for immediate notification toggle/button
  ///
  /// In en, this message translates to:
  /// **'Immediate Notification'**
  String get labelImmediateNotification;

  /// Calibration instruction
  ///
  /// In en, this message translates to:
  /// **'Please calibrate your compass by moving your device in a figure-8 pattern'**
  String get qiblaCalibrateFigure8;

  /// Compass init error
  ///
  /// In en, this message translates to:
  /// **'Error initializing compass'**
  String get qiblaErrorInitializingCompass;

  /// Location error
  ///
  /// In en, this message translates to:
  /// **'Error getting location'**
  String get qiblaErrorGettingLocation;

  /// Calibrating text
  ///
  /// In en, this message translates to:
  /// **'Calibrating Compass...'**
  String get qiblaCalibratingCompass;

  /// Direction status
  ///
  /// In en, this message translates to:
  /// **'Perfect Direction'**
  String get qiblaDirectionPerfect;

  /// Turn right
  ///
  /// In en, this message translates to:
  /// **'Turn Right'**
  String get qiblaTurnRight;

  /// Turn around
  ///
  /// In en, this message translates to:
  /// **'Turn Around'**
  String get qiblaTurnAround;

  /// Turn left
  ///
  /// In en, this message translates to:
  /// **'Turn Left'**
  String get qiblaTurnLeft;

  /// Accuracy excellent
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get qiblaAccuracyExcellent;

  /// Accuracy good
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get qiblaAccuracyGood;

  /// Accuracy fair
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get qiblaAccuracyFair;

  /// Accuracy poor
  ///
  /// In en, this message translates to:
  /// **'Poor'**
  String get qiblaAccuracyPoor;

  /// Error title
  ///
  /// In en, this message translates to:
  /// **'Qibla Error'**
  String get qiblaError;

  /// Error help text
  ///
  /// In en, this message translates to:
  /// **'Please check your device settings and try again.'**
  String get qiblaErrorHelp;

  /// Calibrate button
  ///
  /// In en, this message translates to:
  /// **'Calibrate Compass'**
  String get qiblaCalibrateCompass;

  /// Help dialog title
  ///
  /// In en, this message translates to:
  /// **'Qibla Help'**
  String get qiblaHelpTitle;

  /// Help section header
  ///
  /// In en, this message translates to:
  /// **'Common Issues:'**
  String get qiblaHelpCommonIssues;

  /// Help item
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get qiblaHelpLocationPermission;

  /// Help item text
  ///
  /// In en, this message translates to:
  /// **'Make sure location services are enabled and permission is granted.'**
  String get qiblaHelpLocationPermissionText;

  /// Help item
  ///
  /// In en, this message translates to:
  /// **'Compass Sensor'**
  String get qiblaHelpCompassSensor;

  /// Help item text
  ///
  /// In en, this message translates to:
  /// **'Ensure your device has a compass sensor and it\'s working properly.'**
  String get qiblaHelpCompassSensorText;

  /// Help item
  ///
  /// In en, this message translates to:
  /// **'Calibration'**
  String get qiblaHelpCalibration;

  /// Help item text
  ///
  /// In en, this message translates to:
  /// **'Move your device in a figure-8 pattern to calibrate the compass.'**
  String get qiblaHelpCalibrationText;

  /// No description provided for @onboardingStepOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onboardingStepOfTotal(int step, int total);

  /// Permission title
  ///
  /// In en, this message translates to:
  /// **'Allow Location Access'**
  String get onboardingLocationPermissionTitle;

  /// Permission rationale
  ///
  /// In en, this message translates to:
  /// **'To provide accurate prayer times, DeenMate needs access to your location. Please enable location permissions in your device settings.'**
  String get onboardingLocationPermissionBody;

  /// Auto-detected current location label
  ///
  /// In en, this message translates to:
  /// **'Current Location'**
  String get locationCurrentLocation;

  /// Auto detected label
  ///
  /// In en, this message translates to:
  /// **'Auto-detected'**
  String get locationAutoDetected;

  /// Auto timezone label
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get locationAutoTimezone;

  /// Dialog title to select location
  ///
  /// In en, this message translates to:
  /// **'Select Your Location'**
  String get onboardingSelectLocation;

  /// Country label
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get commonCountry;

  /// City label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get commonCity;

  /// Welcome CTA
  ///
  /// In en, this message translates to:
  /// **'Tap to continue'**
  String get onboardingTapToContinue;

  /// Feature bullet
  ///
  /// In en, this message translates to:
  /// **'Accurate Prayer Times'**
  String get onboardingFeatureAccuratePrayerTimes;

  /// Feature bullet
  ///
  /// In en, this message translates to:
  /// **'Complete Quran Reading'**
  String get onboardingFeatureCompleteQuran;

  /// Feature bullet
  ///
  /// In en, this message translates to:
  /// **'Qibla Direction'**
  String get onboardingFeatureQibla;

  /// Feature bullet
  ///
  /// In en, this message translates to:
  /// **'Azan Notifications'**
  String get onboardingFeatureAzanNotifications;

  /// Prompt to enable notifications
  ///
  /// In en, this message translates to:
  /// **'Enable Azan & Salah Notifications?'**
  String get onboardingEnableAthanAndSalah;

  /// Info dialog text
  ///
  /// In en, this message translates to:
  /// **'Notifications setup will be completed later. You can enable them in settings.'**
  String get onboardingNotificationsSetupLater;

  /// Info dialog text
  ///
  /// In en, this message translates to:
  /// **'Notification preferences saved with defaults. You can change them later in settings.'**
  String get onboardingNotificationsSavedWithDefaults;

  /// Validation error for short name
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters long'**
  String get onboardingNameTooShort;

  /// Title for hadith settings dialog
  ///
  /// In en, this message translates to:
  /// **'Hadith Settings'**
  String get hadithDetailSettingsTitle;

  /// Content text for hadith settings dialog
  ///
  /// In en, this message translates to:
  /// **'Settings options will be available here.'**
  String get hadithDetailSettingsContent;

  /// Close button text for hadith settings dialog
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get hadithDetailSettingsClose;

  /// Prayer topic search query
  ///
  /// In en, this message translates to:
  /// **'Prayer'**
  String get hadithSearchTopicPrayer;

  /// Charity topic search query
  ///
  /// In en, this message translates to:
  /// **'Charity'**
  String get hadithSearchTopicCharity;

  /// Faith topic search query
  ///
  /// In en, this message translates to:
  /// **'Faith'**
  String get hadithSearchTopicFaith;

  /// Fasting topic search query
  ///
  /// In en, this message translates to:
  /// **'Fasting'**
  String get hadithSearchTopicFasting;

  /// Hajj topic search query
  ///
  /// In en, this message translates to:
  /// **'Hajj'**
  String get hadithSearchTopicHajj;

  /// Ethics topic search query
  ///
  /// In en, this message translates to:
  /// **'Ethics'**
  String get hadithSearchTopicEthics;

  /// Comma-separated list of search suggestions
  ///
  /// In en, this message translates to:
  /// **'Intention, Deeds, Prayer, Paradise, Hell, Supplication, Repentance, Patience, Gratitude, Parents'**
  String get hadithSearchSuggestions;

  /// Book filter label
  ///
  /// In en, this message translates to:
  /// **'Book: {bookName}'**
  String hadithSearchFilterBook(String bookName);

  /// Grade filter label
  ///
  /// In en, this message translates to:
  /// **'Grade: {grade}'**
  String hadithSearchFilterGrade(String grade);

  /// Arabic only filter label
  ///
  /// In en, this message translates to:
  /// **'Arabic Only'**
  String get hadithSearchFilterArabicOnly;

  /// Translation only filter label
  ///
  /// In en, this message translates to:
  /// **'Translation Only'**
  String get hadithSearchFilterTranslationOnly;

  /// Search filter dialog title
  ///
  /// In en, this message translates to:
  /// **'Search Filters'**
  String get hadithSearchFilterTitle;

  /// Reset filter button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get hadithSearchFilterReset;

  /// Book filter section title
  ///
  /// In en, this message translates to:
  /// **'Hadith Book'**
  String get hadithSearchFilterBookTitle;

  /// All books option text
  ///
  /// In en, this message translates to:
  /// **'All Books'**
  String get hadithSearchFilterAllBooks;

  /// Grade filter section title
  ///
  /// In en, this message translates to:
  /// **'Hadith Grade'**
  String get hadithSearchFilterGradeTitle;

  /// All grades option text
  ///
  /// In en, this message translates to:
  /// **'All Grades'**
  String get hadithSearchFilterAllGrades;

  /// Sahih grade option
  ///
  /// In en, this message translates to:
  /// **'Sahih'**
  String get hadithSearchFilterSahih;

  /// Hasan grade option
  ///
  /// In en, this message translates to:
  /// **'Hasan'**
  String get hadithSearchFilterHasan;

  /// Daif grade option
  ///
  /// In en, this message translates to:
  /// **'Daif'**
  String get hadithSearchFilterDaif;

  /// Search scope section title
  ///
  /// In en, this message translates to:
  /// **'Search Scope'**
  String get hadithSearchScopeTitle;

  /// Search in Arabic text option
  ///
  /// In en, this message translates to:
  /// **'Search in Arabic text'**
  String get hadithSearchInArabic;

  /// Search in translation option
  ///
  /// In en, this message translates to:
  /// **'Search in translation'**
  String get hadithSearchInTranslation;

  /// Apply filters button text
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get hadithSearchApplyFilters;

  /// No description provided for @comment4.
  ///
  /// In en, this message translates to:
  /// **'===== QURAN MODULE STRINGS ====='**
  String get comment4;

  /// Dialog title when audio is not available offline
  ///
  /// In en, this message translates to:
  /// **'Audio Not Downloaded'**
  String get quranAudioNotDownloaded;

  /// Message when audio is not available offline
  ///
  /// In en, this message translates to:
  /// **'The audio for {chapterName} is not available offline.'**
  String quranAudioNotAvailableOffline(String chapterName);

  /// Prompt for user action when audio not available
  ///
  /// In en, this message translates to:
  /// **'Would you like to:'**
  String get quranWouldYouLikeTo;

  /// Option to download surah audio
  ///
  /// In en, this message translates to:
  /// **'Download Surah'**
  String get quranDownloadSurah;

  /// Description for download option
  ///
  /// In en, this message translates to:
  /// **'Save for offline listening'**
  String get quranSaveForOffline;

  /// Option to play audio online
  ///
  /// In en, this message translates to:
  /// **'Play Online'**
  String get quranPlayOnline;

  /// Description for online play option
  ///
  /// In en, this message translates to:
  /// **'Requires internet connection'**
  String get quranRequiresInternet;

  /// Simple title for audio not available dialog
  ///
  /// In en, this message translates to:
  /// **'Audio not available offline'**
  String get quranAudioNotAvailableOfflineSimple;

  /// Simple prompt for verse audio
  ///
  /// In en, this message translates to:
  /// **'Play {verseKey} online or download for offline use?'**
  String quranPlayVerseOnlineOrDownload(String verseKey);

  /// Download button text
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get quranDownload;

  /// Reset filters button text
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get quranResetFilters;

  /// Error message when chapters fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading chapters'**
  String get quranErrorLoadingChapters;

  /// Error message when translations fail to load
  ///
  /// In en, this message translates to:
  /// **'Error loading translations'**
  String get quranErrorLoadingTranslations;

  /// Script type selector label
  ///
  /// In en, this message translates to:
  /// **'Surah Script'**
  String get quranSurahScript;

  /// Uthmanic script option
  ///
  /// In en, this message translates to:
  /// **'Uthmanic'**
  String get quranUthmanic;

  /// Indo-Pak script option
  ///
  /// In en, this message translates to:
  /// **'Indo-Pak'**
  String get quranIndoPak;

  /// Title for word-by-word section
  ///
  /// In en, this message translates to:
  /// **'Word-by-Word'**
  String get quranWordByWord;

  /// Toggle for word by word display
  ///
  /// In en, this message translates to:
  /// **'Show word by word'**
  String get quranShowWordByWord;

  /// Toggle for tafsir display
  ///
  /// In en, this message translates to:
  /// **'Show tafsir'**
  String get quranShowTafsir;

  /// Tafsir selection dialog title
  ///
  /// In en, this message translates to:
  /// **'Select Tafsir'**
  String get quranSelectTafsir;

  /// Sajdah marker indicator
  ///
  /// In en, this message translates to:
  /// **'Sajdah'**
  String get quranSajdahMarker;

  /// Tooltip for sajdah marker
  ///
  /// In en, this message translates to:
  /// **'Sajdah recommended'**
  String get quranSajdahRecommended;

  /// Auto scroll feature toggle
  ///
  /// In en, this message translates to:
  /// **'Auto Scroll'**
  String get quranAutoScroll;

  /// Auto scroll speed setting
  ///
  /// In en, this message translates to:
  /// **'Scroll Speed'**
  String get quranScrollSpeed;

  /// Audio repeat mode setting
  ///
  /// In en, this message translates to:
  /// **'Repeat Mode'**
  String get quranRepeatMode;

  /// No repeat mode
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get quranRepeatOff;

  /// Repeat one verse mode
  ///
  /// In en, this message translates to:
  /// **'Repeat One'**
  String get quranRepeatOne;

  /// Repeat all verses mode
  ///
  /// In en, this message translates to:
  /// **'Repeat All'**
  String get quranRepeatAll;

  /// Audio playback speed setting
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get quranPlaybackSpeed;

  /// Jump to specific verse action
  ///
  /// In en, this message translates to:
  /// **'Jump to Verse'**
  String get quranJumpToVerse;

  /// Offline status indicator
  ///
  /// In en, this message translates to:
  /// **'Currently offline'**
  String get quranCurrentlyOffline;

  /// Online status indicator
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get quranConnected;

  /// Message during text download
  ///
  /// In en, this message translates to:
  /// **'Downloading Quran text...'**
  String get quranDownloadingText;

  /// Message when text download completes
  ///
  /// In en, this message translates to:
  /// **'Quran text download complete'**
  String get quranTextDownloadComplete;

  /// Message when essential content download completes
  ///
  /// In en, this message translates to:
  /// **'Essential content downloaded successfully!'**
  String get quranEssentialContentDownloaded;

  /// Label for sajdah (prostration) marker
  ///
  /// In en, this message translates to:
  /// **'Sajdah'**
  String get quranSajdah;

  /// Title for sajdah information dialog
  ///
  /// In en, this message translates to:
  /// **'Sajdah Information'**
  String get quranSajdahInfo;

  /// Label for obligatory sajdah
  ///
  /// In en, this message translates to:
  /// **'Obligatory'**
  String get quranSajdahObligatory;

  /// Label for sajdah number in info dialog
  ///
  /// In en, this message translates to:
  /// **'Sajdah Number'**
  String get quranSajdahNumber;

  /// Label for sajdah type in info dialog
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get quranSajdahType;

  /// Label for verse reference in sajdah info
  ///
  /// In en, this message translates to:
  /// **'Verse'**
  String get quranSajdahVerse;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get quranClose;

  /// Description for obligatory sajdah verses
  ///
  /// In en, this message translates to:
  /// **'This is an obligatory sajdah verse. When reciting or listening to this verse, it is mandatory to perform prostration.'**
  String get quranSajdahObligatoryDescription;

  /// Description for recommended sajdah verses
  ///
  /// In en, this message translates to:
  /// **'This is a recommended sajdah verse. It is recommended to perform prostration when reciting or listening to this verse.'**
  String get quranSajdahRecommendedDescription;

  /// General description for sajdah verses
  ///
  /// In en, this message translates to:
  /// **'This verse contains a sajdah (prostration) marker. Consider performing prostration when reciting or listening to this verse.'**
  String get quranSajdahGeneralDescription;

  /// Title for Quran script variants selection
  ///
  /// In en, this message translates to:
  /// **'Script Variants'**
  String get quranScriptVariants;

  /// Description of script variants feature
  ///
  /// In en, this message translates to:
  /// **'Choose between different Quran script styles. Uthmanic is the traditional script, while IndoPak is popular in South Asia.'**
  String get quranScriptVariantsDescription;

  /// Description of Uthmanic script
  ///
  /// In en, this message translates to:
  /// **'Traditional Uthmanic script used in most printed Qurans worldwide. Features classical Arabic calligraphy.'**
  String get quranUthmanicDescription;

  /// Description of IndoPak script
  ///
  /// In en, this message translates to:
  /// **'IndoPak script style popular in South Asia. Features distinct letter forms and spacing.'**
  String get quranIndoPakDescription;

  /// Label for script selection
  ///
  /// In en, this message translates to:
  /// **'Script'**
  String get quranScript;

  /// Checkbox label for enabling transliteration search
  ///
  /// In en, this message translates to:
  /// **'Enable transliteration search'**
  String get quranEnableTransliteration;

  /// Checkbox label for enabling Bengali search
  ///
  /// In en, this message translates to:
  /// **'Enable Bengali search'**
  String get quranEnableBengaliSearch;

  /// Checkbox label for enabling fuzzy matching
  ///
  /// In en, this message translates to:
  /// **'Enable fuzzy matching'**
  String get quranEnableFuzzyMatch;

  /// Label for transliteration search scope
  ///
  /// In en, this message translates to:
  /// **'Transliteration'**
  String get quranTransliteration;

  /// Label for Bengali search scope
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get quranBengali;

  /// Label for all search scope
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get quranAll;

  /// Message shown while translations are loading
  ///
  /// In en, this message translates to:
  /// **'Loading translations...'**
  String get quranTranslationLoading;

  /// Title for available translations section
  ///
  /// In en, this message translates to:
  /// **'Available Translations'**
  String get quranAvailableTranslations;

  /// Label for selected translation IDs
  ///
  /// In en, this message translates to:
  /// **'Selected Translation IDs'**
  String get quranSelectedTranslationIds;

  /// Message asking user to wait for translations
  ///
  /// In en, this message translates to:
  /// **'Please wait while translations are being loaded...'**
  String get quranPleaseWaitWhileTranslationsAreBeingLoaded;

  /// Error message when translations fail to load
  ///
  /// In en, this message translates to:
  /// **'Failed to load translations'**
  String get quranFailedToLoadTranslations;

  /// Snackbar text for search errors
  ///
  /// In en, this message translates to:
  /// **'Search error: {error}'**
  String quranSearchError(String error);

  /// Title for quick tools section
  ///
  /// In en, this message translates to:
  /// **'Quick Tools'**
  String get quranQuickTools;

  /// Title for selected translations section
  ///
  /// In en, this message translates to:
  /// **'Selected Translations'**
  String get quranSelectedTranslations;

  /// Checkbox label for enabling auto scroll
  ///
  /// In en, this message translates to:
  /// **'Enable Auto Scroll'**
  String get quranEnableAutoScroll;

  /// Label for auto scroll speed setting
  ///
  /// In en, this message translates to:
  /// **'Speed (px/sec)'**
  String get quranSpeedPxSec;

  /// Word-by-word toggle subtitle
  ///
  /// In en, this message translates to:
  /// **'Show transliteration and meaning for each word'**
  String get quranWordByWordSubtitle;

  /// Label for word analysis source picker
  ///
  /// In en, this message translates to:
  /// **'Word-by-Word Source'**
  String get quranWordByWordSource;

  /// Label for playback speed menu
  ///
  /// In en, this message translates to:
  /// **'Playback Speed'**
  String get quranPlaybackSpeedLabel;

  /// Playback speed 0.5x
  ///
  /// In en, this message translates to:
  /// **'0.50x'**
  String get quranSpeed050;

  /// Playback speed 0.75x
  ///
  /// In en, this message translates to:
  /// **'0.75x'**
  String get quranSpeed075;

  /// Playback speed 1x
  ///
  /// In en, this message translates to:
  /// **'1.00x'**
  String get quranSpeed100;

  /// Playback speed 1.25x
  ///
  /// In en, this message translates to:
  /// **'1.25x'**
  String get quranSpeed125;

  /// Playback speed 1.5x
  ///
  /// In en, this message translates to:
  /// **'1.50x'**
  String get quranSpeed150;

  /// Playback speed 2x
  ///
  /// In en, this message translates to:
  /// **'2.00x'**
  String get quranSpeed200;

  /// Title for quick jump navigation feature
  ///
  /// In en, this message translates to:
  /// **'Quick Jump'**
  String get quranQuickJump;

  /// Android notification channel description for Athan
  ///
  /// In en, this message translates to:
  /// **'Call to prayer notifications when prayer time arrives'**
  String get athanNotificationsChannelDescription;

  /// Recommendation line in calculation method info dialog
  ///
  /// In en, this message translates to:
  /// **'We recommend using the method preferred in your region for consistency with your local Muslim community.'**
  String get methodsInfoRecommendation;

  /// Menu item to copy Arabic text
  ///
  /// In en, this message translates to:
  /// **'Copy Arabic Text'**
  String get quranCopyArabicText;

  /// Menu item to copy only Arabic verse
  ///
  /// In en, this message translates to:
  /// **'Copy Arabic Verse Only'**
  String get quranCopyOnlyArabicVerse;

  /// Menu item to copy translation
  ///
  /// In en, this message translates to:
  /// **'Copy Translation'**
  String get quranCopyTranslation;

  /// Menu item to copy only translation
  ///
  /// In en, this message translates to:
  /// **'Copy Translation Only'**
  String get quranCopyOnlyTranslation;

  /// Menu item to copy full verse with Arabic and translation
  ///
  /// In en, this message translates to:
  /// **'Copy Full Verse'**
  String get quranCopyFullVerse;

  /// Menu item to copy Arabic text with translation
  ///
  /// In en, this message translates to:
  /// **'Copy Arabic with Translation'**
  String get quranCopyArabicWithTranslation;

  /// Menu item to report translation error
  ///
  /// In en, this message translates to:
  /// **'Report Translation Error'**
  String get quranReportTranslationError;

  /// Description for reporting translation errors
  ///
  /// In en, this message translates to:
  /// **'Help improve translation accuracy'**
  String get quranHelpImproveTranslationAccuracy;

  /// Message shown when Arabic text is copied
  ///
  /// In en, this message translates to:
  /// **'Arabic text copied to clipboard'**
  String get quranArabicTextCopied;

  /// Message shown when translation is copied
  ///
  /// In en, this message translates to:
  /// **'Translation copied to clipboard'**
  String get quranTranslationCopied;

  /// Message shown when full verse is copied
  ///
  /// In en, this message translates to:
  /// **'Full verse copied to clipboard'**
  String get quranFullVerseCopied;

  /// Title for translation error report dialog
  ///
  /// In en, this message translates to:
  /// **'Report Translation Error'**
  String get quranReportTranslationErrorTitle;

  /// Thank you message for reporting translation errors
  ///
  /// In en, this message translates to:
  /// **'Thank you for helping improve Quran translation accuracy!'**
  String get quranThankYouForHelpingImproveQuranTranslation;

  /// Instructions for reporting translation errors
  ///
  /// In en, this message translates to:
  /// **'Please email us at support@deenmate.app with details about the error in verse {verseKey}'**
  String quranPleaseEmailUsAtSupportDeenmateAppWithDetailsAboutErrorInVerse(
      Object verseKey);

  /// Button text for sending email
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get quranSendEmail;

  /// Title for reading progress indicator
  ///
  /// In en, this message translates to:
  /// **'Reading Progress'**
  String get quranReadingProgress;

  /// Label for verse count in reading progress
  ///
  /// In en, this message translates to:
  /// **'Verse'**
  String get quranVerse;

  /// Label for reading streak counter
  ///
  /// In en, this message translates to:
  /// **'Reading Streak'**
  String get quranReadingStreak;

  /// Label for days in reading streak
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get quranDays;
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

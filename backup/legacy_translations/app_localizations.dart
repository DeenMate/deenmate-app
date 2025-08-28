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
/// import 'translations/app_localizations.dart';
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

  /// Juz navigation tab
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

  /// Suhoor meal time for Ramadan
  ///
  /// In en, this message translates to:
  /// **'Suhoor'**
  String get ramadanSuhoor;

  /// Iftaar meal time for Ramadan
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

  /// Generic loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get commonLoading;

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

import 'generated/app_localizations.dart';

// Temporary shims until l10n is regenerated. Remove after running gen-l10n.
extension AppLocalizationsSpeedShims on AppLocalizations {
  String get quranPlaybackSpeedLabel => quranPlaybackSpeed;
  String get quranSpeed050 => '0.50x';
  String get quranSpeed075 => '0.75x';
  String get quranSpeed100 => '1.00x';
  String get quranSpeed125 => '1.25x';
  String get quranSpeed150 => '1.50x';
  String get quranSpeed200 => '2.00x';
}

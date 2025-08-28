import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart'; // Added for context.go

import '../../../../core/theme/islamic_theme.dart';
import '../../../../core/constants/preference_keys.dart';
import '../../../../core/state/prayer_settings_state.dart';
import '../../../../core/localization/language_provider.dart';
import '../../../../core/localization/language_models.dart';
import '../widgets/islamic_decorative_elements.dart';
import '../widgets/islamic_gradient_background.dart';

/// Onboarding completion screen for DeenMate
class CompleteScreen extends ConsumerStatefulWidget {
  final VoidCallback? onComplete;

  const CompleteScreen({super.key, this.onComplete});

  @override
  ConsumerState<CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends ConsumerState<CompleteScreen> {
  bool _isTransferring = false;
  bool _hasTransferred = false;

  @override
  void initState() {
    super.initState();
    // Automatically transfer data when screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_hasTransferred) {
        _transferOnboardingData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IslamicGradientBackground(
        primaryColor: const Color(0xFFF8F9FA),
        secondaryColor: const Color(0xFFFFFFFF),
        child: SafeArea(
          child: Column(
            children: [
              // Status bar area
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withOpacity(0.05),
                ),
              ),

              // Progress indicator
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: OnboardingProgressIndicator(
                  currentStep: 8,
                  totalSteps: 8,
                ),
              ),

              // Main content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),

                      // Success icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF4CAF50).withOpacity(0.3),
                            width: 3,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Color(0xFF4CAF50),
                            size: 60,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Title
                      Text(
                        'Setup Complete!',
                        style: IslamicTheme.textTheme.headlineSmall?.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E2E2E),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      // Subtitle
                      Text(
                        'Your DeenMate app is ready to use',
                        style: IslamicTheme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF666666),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 40),

                      // Features list
                      _buildFeaturesList(),

                      const Spacer(),

                      // Get started button
                      _buildGetStartedButton(context),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Features',
          style: IslamicTheme.textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2E7D32),
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureItem('✓ Personal greeting configured'),
        _buildFeatureItem('✓ Prayer time source selected'),
        _buildFeatureItem('✓ Location and Mazhab set'),
        _buildFeatureItem('✓ Notification preferences saved'),
        _buildFeatureItem('✓ Theme and language chosen'),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Color(0xFF4CAF50),
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: IslamicTheme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: const Color(0xFF666666),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton(BuildContext context) {
    return GestureDetector(
      onTap: _isTransferring ? null : _transferOnboardingData,
      child: Container(
        width: 160,
        height: 48,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isTransferring
                ? [const Color(0xFFCCCCCC), const Color(0xFFDDDDDD)]
                : [
                    const Color(0xFF2E7D32),
                    const Color(0xFF4CAF50),
                    const Color(0xFF66BB6A)
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Container(
          width: 156,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          child: Center(
            child: _isTransferring
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _transferOnboardingData() async {
    if (_hasTransferred) return; // Prevent duplicate transfers

    setState(() {
      _isTransferring = true;
    });

    try {
      // Transfer all onboarding data to main app preferences
      await _transferLanguageData();
      await _transferPrayerSettings();
      await _transferNotificationSettings();
      await _transferThemeSettings();
      await _transferUserData();

      // Mark onboarding as completed
      await _markOnboardingCompleted();

      _hasTransferred = true;

      // Navigate to main app
      if (mounted) {
        // Try callback first, then fallback to router navigation
        if (widget.onComplete != null) {
          widget.onComplete!();
        } else {
          // Use router navigation as fallback
          context.go('/');
        }
      }
    } catch (e) {
      debugPrint('Error transferring onboarding data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving preferences: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isTransferring = false;
        });
      }
    }
  }

  Future<void> _transferLanguageData() async {
    try {
      // Get current language from SharedPreferences (onboarding system)
      final prefs = await SharedPreferences.getInstance();
      final languageCode =
          prefs.getString(PreferenceKeys.selectedLanguage) ?? 'en';

      // Convert to SupportedLanguage
      final language = SupportedLanguage.fromCode(languageCode);

      // Try to save to Hive-based language system (main app system)
      try {
        final languageSwitcher = ref.read(languageSwitcherProvider);
        final success = await languageSwitcher.switchLanguage(language);

        if (success) {
          debugPrint(
              'Transferred language to Hive system: ${language.code} (${language.nativeName})');
        } else {
          debugPrint(
              'Failed to transfer language to Hive system: $languageCode');
        }
      } catch (e) {
        debugPrint(
            'Hive language system not available, using SharedPreferences: $e');
      }

      // Always save to main app preferences for consistency
      await prefs.setString(PreferenceKeys.selectedLanguage, language.code);
      debugPrint(
          'Transferred language to SharedPreferences: ${language.code} (${language.nativeName})');
    } catch (e) {
      debugPrint('Error transferring language data: $e');
    }
  }

  Future<void> _transferPrayerSettings() async {
    try {
      // Prayer settings are already saved via PrayerSettingsState
      // Just ensure they're properly loaded
      await PrayerSettingsState.instance.loadSettings();

      debugPrint('Transferred prayer settings');
    } catch (e) {
      debugPrint('Error transferring prayer settings: $e');
    }
  }

  Future<void> _transferNotificationSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Transfer notification settings from onboarding to main app
      final notificationsEnabled =
          prefs.getBool('notifications_enabled') ?? true;
      final athanEnabled = prefs.getBool('athan_enabled') ?? true;
      final prayerRemindersEnabled =
          prefs.getBool('prayer_reminders_enabled') ?? true;
      final enabledPrayers = prefs.getStringList('enabled_prayers') ??
          ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

      // Save to main app using unified keys
      await prefs.setBool(
          PreferenceKeys.notificationsEnabled, notificationsEnabled);
      await prefs.setBool(PreferenceKeys.athanEnabled, athanEnabled);
      await prefs.setBool(
          PreferenceKeys.prayerRemindersEnabled, prayerRemindersEnabled);
      await prefs.setStringList(PreferenceKeys.enabledPrayers, enabledPrayers);

      debugPrint(
          'Transferred notification settings: enabled=$notificationsEnabled, athan=$athanEnabled, reminders=$prayerRemindersEnabled');
    } catch (e) {
      debugPrint('Error transferring notification settings: $e');
    }
  }

  Future<void> _transferThemeSettings() async {
    try {
      // Theme is already saved via theme provider
      // Just ensure it's properly applied
      final prefs = await SharedPreferences.getInstance();
      final currentTheme =
          prefs.getString(PreferenceKeys.selectedTheme) ?? 'system';

      debugPrint('Transferred theme: $currentTheme');
    } catch (e) {
      debugPrint('Error transferring theme settings: $e');
    }
  }

  Future<void> _transferUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Transfer user name
      final userName = prefs.getString(PreferenceKeys.userName) ?? '';
      if (userName.isNotEmpty) {
        await prefs.setString(PreferenceKeys.userName, userName);
      }

      debugPrint('Transferred user data: name=$userName');
    } catch (e) {
      debugPrint('Error transferring user data: $e');
    }
  }

  Future<void> _markOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(PreferenceKeys.onboardingCompleted, true);

      debugPrint('Marked onboarding as completed');
    } catch (e) {
      debugPrint('Error marking onboarding completed: $e');
    }
  }
}

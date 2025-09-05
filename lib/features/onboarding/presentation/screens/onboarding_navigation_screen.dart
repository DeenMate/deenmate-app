import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/generated/app_localizations.dart';

import '../providers/onboarding_providers.dart';
import '01_welcome_screen.dart';
import '02_username_screen.dart';
import '02_language_screen.dart';
import '03_location_screen.dart';
import '04_calculation_method_screen.dart';
import '05_madhhab_screen.dart';
import '06_notifications_screen.dart';
import '07_theme_screen.dart';
import '08_complete_screen.dart';

/// Onboarding navigation screen that manages the onboarding flow
/// This screen acts as a container for the onboarding process
class OnboardingNavigationScreen extends ConsumerStatefulWidget {
  const OnboardingNavigationScreen({super.key});

  @override
  ConsumerState<OnboardingNavigationScreen> createState() =>
      _OnboardingNavigationScreenState();
}

class _OnboardingNavigationScreenState
    extends ConsumerState<OnboardingNavigationScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingPage> get _pages => [
        OnboardingPage(
          screen: WelcomeScreen(onNext: _nextPage),
          title: AppLocalizations.of(context)!.onboardingWelcomeTitle,
        ),
        OnboardingPage(
          screen: UsernameScreen(onNext: _nextPage, onPrevious: _previousPage),
          title: AppLocalizations.of(context)!.onboardingUsernameTitle,
        ),
        OnboardingPage(
          screen: LanguageScreen(onNext: _nextPage, onPrevious: _previousPage),
          title: AppLocalizations.of(context)!.onboardingLanguageTitle,
        ),
        OnboardingPage(
          screen: LocationScreen(onNext: _nextPage, onPrevious: _previousPage),
          title: AppLocalizations.of(context)!.onboardingLocationTitle,
        ),
        OnboardingPage(
          screen: CalculationMethodScreen(
              onNext: _nextPage, onPrevious: _previousPage),
          title: AppLocalizations.of(context)!.onboardingCalculationTitle,
        ),
        OnboardingPage(
          screen: MadhhabScreen(onNext: _nextPage, onPrevious: _previousPage),
          title: AppLocalizations.of(context)!.onboardingMadhhabTitle,
        ),
        OnboardingPage(
          screen:
              NotificationsScreen(onNext: _nextPage, onPrevious: _previousPage),
          title: AppLocalizations.of(context)!.onboardingNotificationsTitle,
        ),
        OnboardingPage(
          screen: ThemeScreen(onNext: _nextPage, onPrevious: _previousPage),
          title: AppLocalizations.of(context)!.onboardingThemeTitle,
        ),
        OnboardingPage(
          screen: CompleteScreen(onComplete: _nextPage),
          title: AppLocalizations.of(context)!.onboardingCompleteTitle,
        ),
      ];

  @override
  void initState() {
    super.initState();
    // Reset onboarding state when entering onboarding flow
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref.read(onboardingProvider.notifier).resetOnboarding();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Complete onboarding
      ref.read(onboardingProvider.notifier).setOnboardingCompleted(true);
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    // Skip to completion
    ref.read(onboardingProvider.notifier).setOnboardingCompleted(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                if (_currentPage > 0)
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: _previousPage,
                  ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / _pages.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  '${_currentPage + 1}/${_pages.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (_currentPage < _pages.length - 1)
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(AppLocalizations.of(context)!.commonSkip),
                  ),
              ],
            ),
          ),

          // Page content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return _pages[index].screen;
              },
            ),
          ),

          // Navigation buttons - removed, using screen's own navigation
        ],
      ),
    );
  }
}

class OnboardingPage {
  final Widget screen;
  final String title;

  OnboardingPage({
    required this.screen,
    required this.title,
  });
}

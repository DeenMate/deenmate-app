# Onboarding Module - Technical Specification

**Module**: Onboarding  
**Purpose**: First-time user experience, app introduction, and initial setup  
**Architecture**: Clean Architecture with Repository Pattern  
**State Management**: Riverpod  
**Last Updated**: 1 September 2025

---

## 📁 **MODULE STRUCTURE**

```
lib/features/onboarding/
├── data/
│   ├── datasources/
│   │   ├── onboarding_local_datasource.dart    # SharedPreferences implementation
│   │   └── onboarding_remote_datasource.dart   # Analytics and tracking
│   ├── models/
│   │   ├── onboarding_step_model.dart          # Onboarding step data model
│   │   ├── user_setup_model.dart               # User setup configuration
│   │   └── onboarding_progress_model.dart      # Progress tracking model
│   └── repositories/
│       └── onboarding_repository_impl.dart     # Repository implementation
├── domain/
│   ├── entities/
│   │   ├── onboarding_step.dart                # Onboarding step entity
│   │   ├── user_setup.dart                     # User setup entity
│   │   └── onboarding_progress.dart            # Progress tracking entity
│   ├── repositories/
│   │   └── onboarding_repository.dart          # Abstract repository
│   └── usecases/
│       ├── get_onboarding_steps.dart           # Get onboarding flow
│       ├── complete_onboarding_step.dart       # Mark step complete
│       ├── save_user_setup.dart                # Save initial setup
│       ├── check_onboarding_status.dart        # Check if completed
│       └── reset_onboarding.dart               # Reset for testing
└── presentation/
    ├── providers/
    │   ├── onboarding_providers.dart           # Riverpod providers
    │   └── setup_providers.dart               # Setup state providers
    ├── screens/
    │   ├── onboarding_screen.dart              # Main onboarding flow
    │   ├── welcome_screen.dart                 # Welcome introduction
    │   ├── location_setup_screen.dart          # Location permission setup
    │   ├── prayer_setup_screen.dart            # Prayer preferences setup
    │   ├── notification_setup_screen.dart      # Notification preferences
    │   └── completion_screen.dart              # Onboarding completion
    └── widgets/
        ├── onboarding_page_view.dart           # Swipeable page container
        ├── step_indicator.dart                 # Progress indicator
        ├── permission_card.dart                # Permission request card
        ├── feature_showcase_card.dart          # Feature introduction card
        └── setup_completion_widget.dart        # Completion celebration
```

---

## 🎯 **CORE ENTITIES**

### **OnboardingStep Entity**
```dart
@freezed
class OnboardingStep with _$OnboardingStep {
  const factory OnboardingStep({
    required String id,                    // Unique step identifier
    required String title,                 // Step title
    required String description,           // Step description
    required String titleArabic,           // Arabic title
    required String titleBengali,          // Bengali title
    required String descriptionArabic,     // Arabic description
    required String descriptionBengali,    // Bengali description
    required IconData icon,                // Step icon
    required Color accentColor,            // Step theme color
    required String backgroundImage,       // Background image path
    required OnboardingStepType type,      // Step type (intro, permission, setup)
    required List<String> features,        // Features highlighted in step
    required bool isRequired,              // Whether step is mandatory
    required int order,                    // Step order in flow
    required Duration estimatedTime,       // Estimated completion time
  }) = _OnboardingStep;

  factory OnboardingStep.fromJson(Map<String, dynamic> json) =>
      _$OnboardingStepFromJson(json);
}

enum OnboardingStepType { 
  welcome, 
  featureIntro, 
  permissions, 
  setup, 
  completion 
}
```

### **UserSetup Entity**
```dart
@freezed
class UserSetup with _$UserSetup {
  const factory UserSetup({
    required String name,                  // User display name
    required String preferredLanguage,    // UI language preference
    required bool locationPermissionGranted, // Location access
    required bool notificationPermissionGranted, // Notification access
    required String calculationMethod,    // Prayer calculation method
    required String madhab,               // Jurisprudence school
    required bool enableAthan,            // Athan notifications
    required String athanSound,           // Selected athan sound
    required bool enableReminders,        // Prayer reminders
    required bool enableDailyContent,     // Daily Islamic content
    required Map<String, bool> featurePreferences, // Feature toggles
    required DateTime setupDate,          // Setup completion date
    required String setupVersion,         // App version during setup
  }) = _UserSetup;

  factory UserSetup.fromJson(Map<String, dynamic> json) =>
      _$UserSetupFromJson(json);

  /// Default user setup configuration
  factory UserSetup.defaultSetup() => UserSetup(
    name: '',
    preferredLanguage: 'en',
    locationPermissionGranted: false,
    notificationPermissionGranted: false,
    calculationMethod: 'ISNA',
    madhab: 'hanafi',
    enableAthan: true,
    athanSound: 'madinah',
    enableReminders: true,
    enableDailyContent: true,
    featurePreferences: {
      'qibla_finder': true,
      'zakat_calculator': true,
      'prayer_tracking': true,
      'quran_reading': true,
      'hadith_daily': true,
    },
    setupDate: DateTime.now(),
    setupVersion: '1.0.0',
  );
}
```

### **OnboardingProgress Entity**
```dart
@freezed
class OnboardingProgress with _$OnboardingProgress {
  const factory OnboardingProgress({
    required List<String> completedSteps,  // Completed step IDs
    required String currentStepId,         // Current active step
    required bool isCompleted,             // Overall completion status
    required double progressPercentage,    // Progress (0.0 - 1.0)
    required DateTime startedAt,           // Onboarding start time
    required DateTime? completedAt,        // Completion time
    required Duration totalTime,           // Time spent in onboarding
    required Map<String, DateTime> stepTimestamps, // Step completion times
    required bool canSkip,                 // Whether user can skip
    required List<String> skippedSteps,    // Skipped step IDs
  }) = _OnboardingProgress;

  factory OnboardingProgress.fromJson(Map<String, dynamic> json) =>
      _$OnboardingProgressFromJson(json);

  /// Initial progress state
  factory OnboardingProgress.initial() => OnboardingProgress(
    completedSteps: [],
    currentStepId: 'welcome',
    isCompleted: false,
    progressPercentage: 0.0,
    startedAt: DateTime.now(),
    completedAt: null,
    totalTime: Duration.zero,
    stepTimestamps: {},
    canSkip: false,
    skippedSteps: [],
  );

  /// Check if specific step is completed
  bool isStepCompleted(String stepId) => completedSteps.contains(stepId);

  /// Get next step in sequence
  String? getNextStep(List<OnboardingStep> allSteps) {
    final sortedSteps = allSteps..sort((a, b) => a.order.compareTo(b.order));
    final currentIndex = sortedSteps.indexWhere((step) => step.id == currentStepId);
    
    if (currentIndex < sortedSteps.length - 1) {
      return sortedSteps[currentIndex + 1].id;
    }
    return null; // No next step (completed)
  }
}
```

---

## 🎨 **ONBOARDING FLOW DESIGN**

### **Step 1: Welcome Screen**
```dart
OnboardingStep.welcome(
  title: 'Welcome to DeenMate',
  titleArabic: 'مرحباً بكم في دين ميت',
  titleBengali: 'দীন মেইটে স্বাগতম',
  description: 'Your comprehensive Islamic companion for daily worship and spiritual growth',
  features: ['Prayer Times', 'Qibla Direction', 'Quran Reading', 'Zakat Calculator'],
  backgroundImage: 'assets/images/onboarding/welcome_bg.png',
  accentColor: IslamicColors.primaryGreen,
)
```

### **Step 2: Feature Introduction**
```dart
OnboardingStep.featureIntro(
  title: 'Everything You Need',
  features: [
    'Accurate Prayer Times with Athan',
    'Qibla Compass for Prayer Direction',
    'Complete Quran with Translations',
    'Hadith Collections and Daily Content',
    'Zakat and Inheritance Calculators',
  ],
  backgroundImage: 'assets/images/onboarding/features_bg.png',
)
```

### **Step 3: Location Permission**
```dart
OnboardingStep.permissions(
  title: 'Enable Location Access',
  description: 'For accurate prayer times and Qibla direction based on your location',
  features: ['Automatic Prayer Times', 'Accurate Qibla Direction', 'Local Islamic Events'],
  isRequired: true,
)
```

### **Step 4: Notification Permission**
```dart
OnboardingStep.permissions(
  title: 'Enable Notifications',
  description: 'Receive prayer reminders, daily Islamic content, and important updates',
  features: ['Prayer Reminders', 'Daily Quran Verses', 'Hadith Notifications'],
  isRequired: false,
)
```

### **Step 5: Prayer Setup**
```dart
OnboardingStep.setup(
  title: 'Prayer Preferences',
  description: 'Customize your prayer experience',
  features: [
    'Calculation Method Selection',
    'Jurisprudence School (Madhab)',
    'Athan Sound Selection',
    'Prayer Reminder Settings',
  ],
)
```

### **Step 6: Completion**
```dart
OnboardingStep.completion(
  title: 'All Set!',
  description: 'Your Islamic companion is ready. Start your spiritual journey with DeenMate.',
  features: ['Personalized Experience', 'Accurate Islamic Tools', 'Daily Spiritual Content'],
)
```

---

## 🔄 **USE CASES**

### **GetOnboardingSteps Use Case**
```dart
class GetOnboardingSteps {
  final OnboardingRepository repository;

  GetOnboardingSteps(this.repository);

  Future<Either<Failure, List<OnboardingStep>>> call() async {
    try {
      final steps = await repository.getOnboardingSteps();
      return Right(steps);
    } catch (e) {
      return Left(CacheFailure('Failed to get onboarding steps: $e'));
    }
  }
}
```

### **CompleteOnboardingStep Use Case**
```dart
class CompleteOnboardingStep {
  final OnboardingRepository repository;

  CompleteOnboardingStep(this.repository);

  Future<Either<Failure, OnboardingProgress>> call(String stepId) async {
    try {
      final progress = await repository.completeStep(stepId);
      return Right(progress);
    } catch (e) {
      return Left(CacheFailure('Failed to complete step: $e'));
    }
  }
}
```

### **SaveUserSetup Use Case**
```dart
class SaveUserSetup {
  final OnboardingRepository repository;

  SaveUserSetup(this.repository);

  Future<Either<Failure, void>> call(UserSetup setup) async {
    try {
      await repository.saveUserSetup(setup);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save user setup: $e'));
    }
  }
}
```

---

## 🎮 **RIVERPOD PROVIDERS**

### **Onboarding State Management**
```dart
// Onboarding Steps Provider
final onboardingStepsProvider = FutureProvider<List<OnboardingStep>>((ref) async {
  final repository = ref.read(onboardingRepositoryProvider);
  final result = await GetOnboardingSteps(repository)();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (steps) => steps,
  );
});

// Onboarding Progress Provider
final onboardingProgressProvider = StateNotifierProvider<OnboardingProgressNotifier, OnboardingProgress>((ref) {
  return OnboardingProgressNotifier(ref.read(onboardingRepositoryProvider));
});

class OnboardingProgressNotifier extends StateNotifier<OnboardingProgress> {
  final OnboardingRepository _repository;

  OnboardingProgressNotifier(this._repository) : super(OnboardingProgress.initial()) {
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final progress = await _repository.getProgress();
      state = progress;
    } catch (e) {
      // Keep initial state on error
    }
  }

  Future<void> completeStep(String stepId) async {
    try {
      final updatedProgress = await _repository.completeStep(stepId);
      state = updatedProgress;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> skipStep(String stepId) async {
    try {
      final updatedProgress = await _repository.skipStep(stepId);
      state = updatedProgress;
    } catch (e) {
      // Handle error
    }
  }

  Future<void> completeOnboarding() async {
    try {
      await _repository.completeOnboarding();
      state = state.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        progressPercentage: 1.0,
      );
    } catch (e) {
      // Handle error
    }
  }
}

// User Setup Provider
final userSetupProvider = StateNotifierProvider<UserSetupNotifier, UserSetup>((ref) {
  return UserSetupNotifier(ref.read(onboardingRepositoryProvider));
});

class UserSetupNotifier extends StateNotifier<UserSetup> {
  final OnboardingRepository _repository;

  UserSetupNotifier(this._repository) : super(UserSetup.defaultSetup());

  Future<void> updateName(String name) async {
    state = state.copyWith(name: name);
    await _saveSetup();
  }

  Future<void> updateLanguage(String language) async {
    state = state.copyWith(preferredLanguage: language);
    await _saveSetup();
  }

  Future<void> updateCalculationMethod(String method) async {
    state = state.copyWith(calculationMethod: method);
    await _saveSetup();
  }

  Future<void> grantLocationPermission() async {
    state = state.copyWith(locationPermissionGranted: true);
    await _saveSetup();
  }

  Future<void> grantNotificationPermission() async {
    state = state.copyWith(notificationPermissionGranted: true);
    await _saveSetup();
  }

  Future<void> _saveSetup() async {
    try {
      await _repository.saveUserSetup(state);
    } catch (e) {
      // Handle error
    }
  }
}
```

---

## 🎨 **UI COMPONENTS**

### **OnboardingPageView Widget**
```dart
class OnboardingPageView extends ConsumerStatefulWidget {
  const OnboardingPageView({super.key});

  @override
  ConsumerState<OnboardingPageView> createState() => _OnboardingPageViewState();
}

class _OnboardingPageViewState extends ConsumerState<OnboardingPageView> {
  final PageController _pageController = PageController();
  
  @override
  Widget build(BuildContext context) {
    final stepsAsync = ref.watch(onboardingStepsProvider);
    final progress = ref.watch(onboardingProgressProvider);

    return stepsAsync.when(
      loading: () => const OnboardingLoadingScreen(),
      error: (error, stack) => OnboardingErrorScreen(error: error),
      data: (steps) => Scaffold(
        body: Column(
          children: [
            // Progress Indicator
            StepIndicator(
              currentStep: progress.currentStepId,
              totalSteps: steps.length,
              progress: progress.progressPercentage,
            ),
            
            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: steps.length,
                onPageChanged: (index) => _handlePageChange(steps[index].id),
                itemBuilder: (context, index) => OnboardingStepScreen(
                  step: steps[index],
                  onNext: () => _nextStep(steps, index),
                  onSkip: () => _skipStep(steps[index].id),
                  onComplete: () => _completeOnboarding(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePageChange(String stepId) {
    ref.read(onboardingProgressProvider.notifier).updateCurrentStep(stepId);
  }

  void _nextStep(List<OnboardingStep> steps, int currentIndex) {
    if (currentIndex < steps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipStep(String stepId) {
    ref.read(onboardingProgressProvider.notifier).skipStep(stepId);
    _nextStep([], 0); // Move to next regardless
  }

  void _completeOnboarding() {
    ref.read(onboardingProgressProvider.notifier).completeOnboarding();
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
```

### **StepIndicator Widget**
```dart
class StepIndicator extends StatelessWidget {
  final String currentStep;
  final int totalSteps;
  final double progress;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          ),
          const SizedBox(height: 8),
          
          // Step Counter
          Text(
            'Step ${(progress * totalSteps).ceil()} of $totalSteps',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
```

---

## 🧪 **TESTING STRATEGY**

### **Unit Tests**
```dart
// test/features/onboarding/domain/usecases/get_onboarding_steps_test.dart
void main() {
  late GetOnboardingSteps useCase;
  late MockOnboardingRepository mockRepository;

  setUp(() {
    mockRepository = MockOnboardingRepository();
    useCase = GetOnboardingSteps(mockRepository);
  });

  group('GetOnboardingSteps', () {
    test('should return onboarding steps when repository call is successful', () async {
      // arrange
      final expectedSteps = [OnboardingStep.welcome(/* ... */)];
      when(mockRepository.getOnboardingSteps())
          .thenAnswer((_) async => expectedSteps);

      // act
      final result = await useCase();

      // assert
      expect(result, equals(Right(expectedSteps)));
      verify(mockRepository.getOnboardingSteps());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
```

### **Widget Tests**
```dart
// test/features/onboarding/presentation/widgets/step_indicator_test.dart
void main() {
  group('StepIndicator', () {
    testWidgets('should display progress correctly', (tester) async {
      // arrange
      const progress = 0.5;
      const totalSteps = 6;

      // act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StepIndicator(
              currentStep: 'setup',
              totalSteps: totalSteps,
              progress: progress,
            ),
          ),
        ),
      );

      // assert
      expect(find.text('Step 3 of 6'), findsOneWidget);
      final progressIndicator = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progressIndicator.value, equals(progress));
    });
  });
}
```

---

## ♿ **ACCESSIBILITY FEATURES**

### **Screen Reader Support**
- Comprehensive semantic labels for all UI elements
- Step-by-step navigation announcements
- Progress updates announced to screen readers
- Skip options clearly announced

### **Keyboard Navigation**
- Full keyboard navigation support
- Focus management between steps
- Skip shortcuts (Tab + S)
- Clear focus indicators

### **Visual Accessibility**
- High contrast mode support
- Scalable text (supports system text scaling)
- Clear visual hierarchy
- Color-blind friendly design

---

## 🚀 **PERFORMANCE OPTIMIZATION**

### **Lazy Loading**
- Onboarding steps loaded on demand
- Background images loaded progressively
- Animations optimized for smooth transitions

### **Memory Management**
- Efficient page view with limited page caching
- Proper disposal of controllers and providers
- Optimized image loading and caching

---

## 📊 **ANALYTICS INTEGRATION**

### **Onboarding Metrics**
- Step completion rates
- Time spent on each step
- Skip patterns and reasons
- Drop-off points identification
- A/B testing for onboarding variations

### **User Setup Analytics**
- Most popular calculation methods
- Permission grant rates
- Feature adoption preferences
- Language selection patterns

---

## 🔮 **FUTURE ENHANCEMENTS**

### **Personalization**
- AI-powered step recommendations
- Adaptive onboarding based on user behavior
- Smart feature suggestions
- Personalized Islamic content recommendations

### **Advanced Features**
- Video introductions for complex features
- Interactive tutorials with guided tours
- Onboarding for new features (progressive disclosure)
- Community-driven onboarding tips

### **Integration**
- Social media sharing of setup completion
- Referral system integration
- Community welcome messages
- Mentor assignment for new users

---

*This specification provides a comprehensive foundation for the Onboarding module, ensuring a smooth and engaging first-time user experience that properly introduces DeenMate's Islamic features while respecting user preferences and accessibility needs.*

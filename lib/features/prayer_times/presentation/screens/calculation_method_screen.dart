import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../data/services/calculation_method_service.dart';
import '../../domain/entities/calculation_method.dart';
import '../../domain/entities/location.dart';
import '../../domain/entities/prayer_times.dart';
import '../providers/prayer_times_providers.dart';
import '../widgets/calculation_method_card.dart';
import '../widgets/method_comparison_widget.dart';

/// Calculation Method Selection Screen
/// Allows users to choose and compare different prayer time calculation methods
class CalculationMethodScreen extends ConsumerStatefulWidget {
  const CalculationMethodScreen({super.key});

  @override
  ConsumerState<CalculationMethodScreen> createState() => _CalculationMethodScreenState();
}

class _CalculationMethodScreenState extends ConsumerState<CalculationMethodScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedMethodId = 'MWL';
  bool _showComparison = false;
  String? _comparisonMethodId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCurrentMethod();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentMethod() async {
    final settingsAsync = ref.read(prayerSettingsProvider);
    settingsAsync.whenData((settings) {
      setState(() {
        _selectedMethodId = settings.calculationMethod;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(currentLocationProvider);
    final settingsAsync = ref.watch(prayerSettingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.prayerCalculationMethodsTitle),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_showComparison && _comparisonMethodId != null)
            IconButton(
              onPressed: _hideComparison,
              icon: const Icon(Icons.close),
              tooltip: AppLocalizations.of(context)!.methodsHideComparisonTooltip,
            ),
          IconButton(
            onPressed: _showInfoDialog,
            icon: const Icon(Icons.info_outline),
            tooltip: AppLocalizations.of(context)!.methodsAboutTooltip,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: AppLocalizations.of(context)!.methodsRecommended, icon: Icon(Icons.star_outline)),
            Tab(text: AppLocalizations.of(context)!.methodsAllMethods, icon: Icon(Icons.list)),
            Tab(text: AppLocalizations.of(context)!.methodsCustom, icon: Icon(Icons.tune)),
          ],
        ),
      ),
      body: locationAsync.when(
        data: (location) => TabBarView(
          controller: _tabController,
          children: [
            _buildRecommendedTab(location),
            _buildAllMethodsTab(location),
            _buildCustomTab(location),
          ],
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.unableToLoadLocation,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.locationIsNeeded,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(currentLocationProvider),
                child: Text(AppLocalizations.of(context)!.methodsRetry),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: _showComparison && _comparisonMethodId != null
          ? null
          : FloatingActionButton.extended(
              onPressed: _applySelectedMethod,
              icon: const Icon(Icons.check),
              label: Text(AppLocalizations.of(context)!.methodsApplyMethod),
              backgroundColor: Colors.green,
            ),
    );
  }

  Widget _buildRecommendedTab(Location location) {
    final recommendedMethods = CalculationMethodService.instance.getRecommendedMethods(location);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.methodsYourLocation,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${location.city}, ${location.country}'),
                  Text('${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.methodsRecommendedMethods,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'These methods are specifically recommended for your location based on regional preferences and accuracy.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ...recommendedMethods.map((method) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CalculationMethodCard(
              method: method,
              location: location,
              isSelected: method.name == _selectedMethodId,
              onSelected: () => _selectMethod(method.name),
              onCompare: () => _showComparison
                  ? _hideComparison()
                  : _startComparison(method.name),
              showCompareButton: true,
              isRecommended: true,
            ),
          ),),
        ],
      ),
    );
  }

  Widget _buildAllMethodsTab(Location location) {
    final allMethods = CalculationMethod.values;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.methodsAllAvailableMethods,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.methodsAllAvailableMethodsCount(allMethods.length),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ...allMethods.map((method) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CalculationMethodCard(
              method: method,
              location: location,
              isSelected: method.name == _selectedMethodId,
              onSelected: () => _selectMethod(method.name),
              onCompare: () => _showComparison
                  ? _hideComparison()
                  : _startComparison(method.name),
              showCompareButton: true,
            ),
          ),),
        ],
      ),
    );
  }

  Widget _buildCustomTab(Location location) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.methodsCustomMethod,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your own calculation method with custom angles.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.construction,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.methodsCustomMethodCreator,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This feature will allow you to create custom calculation methods with your preferred Fajr and Isha angles.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _showCustomMethodDialog,
                    child: Text(AppLocalizations.of(context)!.methodsCreateCustomMethod),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectMethod(String methodId) {
    setState(() {
      _selectedMethodId = methodId;
    });
  }

  void _startComparison(String methodId) {
    setState(() {
      _showComparison = true;
      _comparisonMethodId = methodId;
    });
  }

  void _hideComparison() {
    setState(() {
      _showComparison = false;
      _comparisonMethodId = null;
    });
  }

  Future<void> _applySelectedMethod() async {
    try {
      final method = CalculationMethod.fromName(_selectedMethodId);
      if (method == null) return;

      // Update prayer settings
      final currentSettings = await ref.read(prayerSettingsProvider.future);
      final updatedSettings = currentSettings.copyWith(
        calculationMethod: method.name,
        madhab: method.madhab,
      );

      // Save settings (implement this in your repository)
      // await ref.read(prayerTimesRepositoryProvider).savePrayerSettings(updatedSettings);

      // Invalidate prayer times to trigger recalculation
      ref.invalidate(currentPrayerTimesProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.methodsApplied(method.name)),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: AppLocalizations.of(context)!.methodsView,
              textColor: Colors.white,
              onPressed: () => context.pop(),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.methodsApplyFailed(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.methodsAboutCalculationMethods),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.methodsInfoFajrAngle,
              ),
              SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.methodsInfoIshaAngle,
              ),
              SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.methodsInfoRegionalPref,
              ),
              SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.methodsInfoMadhabDiff,
              ),
              SizedBox(height: 16),
              Text(
                'We recommend using the method preferred in your region for consistency with your local Muslim community.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(AppLocalizations.of(context)!.methodsGotIt),
          ),
        ],
      ),
    );
  }

  void _showCustomMethodDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.methodsCustomMethod),
        content: Text(AppLocalizations.of(context)!.methodsCustomComingSoon),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

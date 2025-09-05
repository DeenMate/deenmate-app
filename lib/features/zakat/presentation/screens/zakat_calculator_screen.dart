// Modern Zakat Calculator Screen with comprehensive Islamic calculations
// Clean architecture implementation with state management

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/shared/widgets/app_bar.dart';
import '../../../../core/shared/widgets/loading_widget.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/zakat_wealth.dart';
import '../providers/zakat_providers.dart';
import '../widgets/wealth_input_section.dart';
import '../widgets/zakat_result_card.dart';
import '../widgets/nisab_info_card.dart';
import '../widgets/calculation_breakdown_sheet.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Modern Zakat Calculator Screen following Islamic principles
class ZakatCalculatorScreen extends ConsumerStatefulWidget {
  const ZakatCalculatorScreen({super.key});

  @override
  ConsumerState<ZakatCalculatorScreen> createState() =>
      _ZakatCalculatorScreenState();
}

class _ZakatCalculatorScreenState extends ConsumerState<ZakatCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Wealth input controllers
  final _cashController = TextEditingController();
  final _savingsController = TextEditingController();
  final _goldGramsController = TextEditingController();
  final _goldValueController = TextEditingController();
  final _silverGramsController = TextEditingController();
  final _silverValueController = TextEditingController();
  final _businessInventoryController = TextEditingController();
  final _accountsReceivableController = TextEditingController();
  final _investmentsController = TextEditingController();
  final _rentalIncomeController = TextEditingController();
  final _otherAssetsController = TextEditingController();
  final _debtsController = TextEditingController();
  final _businessExpensesController = TextEditingController();

  String _selectedCurrency = 'USD';
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _loadSavedWealth();
    _fetchMetalPrices();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cashController.dispose();
    _savingsController.dispose();
    _goldGramsController.dispose();
    _goldValueController.dispose();
    _silverGramsController.dispose();
    _silverValueController.dispose();
    _businessInventoryController.dispose();
    _accountsReceivableController.dispose();
    _investmentsController.dispose();
    _rentalIncomeController.dispose();
    _otherAssetsController.dispose();
    _debtsController.dispose();
    _businessExpensesController.dispose();
    super.dispose();
  }

  void _loadSavedWealth() {
    final savedWealth = ref.read(savedZakatWealthProvider);
    if (savedWealth != null) {
      _populateControllersFromWealth(savedWealth);
    }
  }

  void _fetchMetalPrices() {
    ref
        .read(metalPricesProvider.notifier)
        .fetchCurrentPrices(_selectedCurrency);
  }

  void _populateControllersFromWealth(ZakatWealth wealth) {
    _cashController.text = wealth.cash > 0 ? wealth.cash.toString() : '';
    _savingsController.text =
        wealth.savings > 0 ? wealth.savings.toString() : '';
    _goldGramsController.text =
        wealth.goldGrams > 0 ? wealth.goldGrams.toString() : '';
    _goldValueController.text =
        wealth.goldValue > 0 ? wealth.goldValue.toString() : '';
    _silverGramsController.text =
        wealth.silverGrams > 0 ? wealth.silverGrams.toString() : '';
    _silverValueController.text =
        wealth.silverValue > 0 ? wealth.silverValue.toString() : '';
    _businessInventoryController.text =
        wealth.businessInventory > 0 ? wealth.businessInventory.toString() : '';
    _accountsReceivableController.text = wealth.accountsReceivable > 0
        ? wealth.accountsReceivable.toString()
        : '';
    _investmentsController.text =
        wealth.investments > 0 ? wealth.investments.toString() : '';
    _rentalIncomeController.text =
        wealth.rentalIncome > 0 ? wealth.rentalIncome.toString() : '';
    _otherAssetsController.text =
        wealth.otherAssets > 0 ? wealth.otherAssets.toString() : '';
    _debtsController.text = wealth.debts > 0 ? wealth.debts.toString() : '';
    _businessExpensesController.text =
        wealth.businessExpenses > 0 ? wealth.businessExpenses.toString() : '';
    _selectedCurrency = wealth.currency;
  }

  ZakatWealth _createWealthFromInputs() {
    return ZakatWealth(
      cash: double.tryParse(_cashController.text) ?? 0,
      savings: double.tryParse(_savingsController.text) ?? 0,
      goldGrams: double.tryParse(_goldGramsController.text) ?? 0,
      goldValue: double.tryParse(_goldValueController.text) ?? 0,
      silverGrams: double.tryParse(_silverGramsController.text) ?? 0,
      silverValue: double.tryParse(_silverValueController.text) ?? 0,
      businessInventory:
          double.tryParse(_businessInventoryController.text) ?? 0,
      accountsReceivable:
          double.tryParse(_accountsReceivableController.text) ?? 0,
      investments: double.tryParse(_investmentsController.text) ?? 0,
      rentalIncome: double.tryParse(_rentalIncomeController.text) ?? 0,
      otherAssets: double.tryParse(_otherAssetsController.text) ?? 0,
      debts: double.tryParse(_debtsController.text) ?? 0,
      businessExpenses: double.tryParse(_businessExpensesController.text) ?? 0,
      currency: _selectedCurrency,
      lastUpdated: DateTime.now(),
    );
  }

  Future<void> _calculateZakat() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isCalculating = true);

    try {
      final wealth = _createWealthFromInputs();

      // Save wealth data
      await ref.read(zakatWealthNotifierProvider.notifier).updateWealth(wealth);

      // Calculate Zakat
      await ref
          .read(zakatCalculationNotifierProvider.notifier)
          .calculateZakat(wealth);

      // Show success feedback
      _showCalculationSuccess();
    } catch (e) {
      _showErrorSnackBar(
          AppLocalizations.of(context)!.zakatCalcError(e.toString()));
    } finally {
      setState(() => _isCalculating = false);
    }
  }

  void _showCalculationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.zakatCalculationSuccess),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showCalculationBreakdown() {
    final calculation = ref.read(zakatCalculationNotifierProvider).value;
    if (calculation != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) =>
            CalculationBreakdownSheet(calculation: calculation),
      );
    }
  }

  void _resetForm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.zakatResetDialogTitle),
        content: Text(AppLocalizations.of(context)!.zakatResetDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.commonCancel),
          ),
          TextButton(
            onPressed: () {
              _clearAllControllers();
              ref.read(zakatWealthNotifierProvider.notifier).clearWealth();
              ref
                  .read(zakatCalculationNotifierProvider.notifier)
                  .clearCalculation();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content:
                        Text(AppLocalizations.of(context)!.zakatResetSuccess)),
              );
            },
            child: Text(AppLocalizations.of(context)!.commonReset),
          ),
        ],
      ),
    );
  }

  void _clearAllControllers() {
    _cashController.clear();
    _savingsController.clear();
    _goldGramsController.clear();
    _goldValueController.clear();
    _silverGramsController.clear();
    _silverValueController.clear();
    _businessInventoryController.clear();
    _accountsReceivableController.clear();
    _investmentsController.clear();
    _rentalIncomeController.clear();
    _otherAssetsController.clear();
    _debtsController.clear();
    _businessExpensesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final metalPricesAsync = ref.watch(metalPricesProvider);
    final nisabAsync = ref.watch(nisabThresholdProvider);
    final calculationAsync = ref.watch(zakatCalculationNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.zakatTitle,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchMetalPrices,
            tooltip: AppLocalizations.of(context)!.zakatRefreshPricesTooltip,
          ),
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: _resetForm,
            tooltip: AppLocalizations.of(context)!.zakatResetFormTooltip,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Islamic Introduction
              _buildIslamicIntroduction(),
              const SizedBox(height: 24),

              // Nisab Information
              nisabAsync.when(
                data: (nisab) => NisabInfoCard(
                  nisab: nisab,
                  currency: _selectedCurrency,
                ),
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: LoadingWidget(size: 24),
                  ),
                ),
                error: (error, stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      AppLocalizations.of(context)!
                          .zakatUnableToLoadNisab(error.toString()),
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Currency Selection
              _buildCurrencySelector(),
              const SizedBox(height: 24),

              // Wealth Input Sections
              WealthInputSection(
                title: AppLocalizations.of(context)!.zakatCashSavingsTitle,
                icon: Icons.account_balance_wallet,
                children: [
                  _buildAmountField(
                    controller: _cashController,
                    label: AppLocalizations.of(context)!.zakatCashSavingsLabel,
                    hint: AppLocalizations.of(context)!.zakatCashSavingsHint,
                    icon: Icons.payments,
                  ),
                  _buildAmountField(
                    controller: _savingsController,
                    label: AppLocalizations.of(context)!.zakatSavingsLabel,
                    hint: AppLocalizations.of(context)!.zakatSavingsHint,
                    icon: Icons.savings,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              WealthInputSection(
                title: AppLocalizations.of(context)!.zakatGoldSilverTitle,
                icon: Icons.diamond,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildAmountField(
                          controller: _goldGramsController,
                          label:
                              AppLocalizations.of(context)!.zakatGoldGramsLabel,
                          hint:
                              AppLocalizations.of(context)!.zakatGoldGramsHint,
                          icon: Icons.scale,
                          onChanged: _updateGoldValue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAmountField(
                          controller: _goldValueController,
                          label:
                              AppLocalizations.of(context)!.zakatGoldValueLabel,
                          hint:
                              AppLocalizations.of(context)!.zakatGoldValueHint,
                          icon: Icons.attach_money,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _buildAmountField(
                          controller: _silverGramsController,
                          label: AppLocalizations.of(context)!
                              .zakatSilverGramsLabel,
                          hint: AppLocalizations.of(context)!
                              .zakatSilverGramsHint,
                          icon: Icons.scale,
                          onChanged: _updateSilverValue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildAmountField(
                          controller: _silverValueController,
                          label: AppLocalizations.of(context)!
                              .zakatSilverValueLabel,
                          hint: AppLocalizations.of(context)!
                              .zakatSilverValueHint,
                          icon: Icons.attach_money,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              WealthInputSection(
                title: AppLocalizations.of(context)!.zakatBusinessAssetsTitle,
                icon: Icons.business,
                children: [
                  _buildAmountField(
                    controller: _businessInventoryController,
                    label: AppLocalizations.of(context)!
                        .zakatBusinessInventoryLabel,
                    hint: AppLocalizations.of(context)!
                        .zakatBusinessInventoryHint,
                    icon: Icons.inventory,
                  ),
                  _buildAmountField(
                    controller: _accountsReceivableController,
                    label: AppLocalizations.of(context)!
                        .zakatAccountsReceivableLabel,
                    hint: AppLocalizations.of(context)!
                        .zakatAccountsReceivableHint,
                    icon: Icons.request_quote,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              WealthInputSection(
                title: AppLocalizations.of(context)!
                    .zakatInvestmentsOtherAssetsTitle,
                icon: Icons.trending_up,
                children: [
                  _buildAmountField(
                    controller: _investmentsController,
                    label: AppLocalizations.of(context)!.zakatInvestmentsLabel,
                    hint: AppLocalizations.of(context)!.zakatInvestmentsHint,
                    icon: Icons.show_chart,
                  ),
                  _buildAmountField(
                    controller: _rentalIncomeController,
                    label: AppLocalizations.of(context)!.zakatRentalIncomeLabel,
                    hint: AppLocalizations.of(context)!.zakatRentalIncomeHint,
                    icon: Icons.home_work,
                  ),
                  _buildAmountField(
                    controller: _otherAssetsController,
                    label: AppLocalizations.of(context)!.zakatOtherAssetsLabel,
                    hint: AppLocalizations.of(context)!.zakatOtherAssetsHint,
                    icon: Icons.more_horiz,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              WealthInputSection(
                title: AppLocalizations.of(context)!.zakatDeductionsTitle,
                icon: Icons.remove_circle,
                children: [
                  _buildAmountField(
                    controller: _debtsController,
                    label: AppLocalizations.of(context)!.zakatDebtsLabel,
                    hint: AppLocalizations.of(context)!.zakatDebtsHint,
                    icon: Icons.credit_card,
                  ),
                  _buildAmountField(
                    controller: _businessExpensesController,
                    label: AppLocalizations.of(context)!
                        .zakatBusinessExpensesLabel,
                    hint:
                        AppLocalizations.of(context)!.zakatBusinessExpensesHint,
                    icon: Icons.receipt_long,
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Calculate Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isCalculating ? null : _calculateZakat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isCalculating
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                                AppLocalizations.of(context)!.zakatCalculating),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.calculate),
                            SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.zakatCalculate),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Calculation Result
              calculationAsync.when(
                data: (calculation) {
                  if (calculation == null) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      ZakatResultCard(
                        calculation: calculation,
                        onShowBreakdown: _showCalculationBreakdown,
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
                loading: () => const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: LoadingWidget(),
                  ),
                ),
                error: (error, stack) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 48,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!.zakatCalculationError,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          error.toString(),
                          style: AppTextStyles.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIslamicIntroduction() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mosque, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  AppLocalizations.of(context)!.zakatAboutTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.zakatAboutBody,
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 8),
            Text(
              '• Purifies your wealth and soul\n'
              '• Helps those less fortunate\n'
              '• Brings barakah (blessings) to your remaining wealth',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    const supportedCurrencies = [
      {'code': 'USD', 'name': 'usd', 'symbol': '\$'},
      {'code': 'EUR', 'name': 'eur', 'symbol': '€'},
      {'code': 'GBP', 'name': 'gbp', 'symbol': '£'},
      {'code': 'BDT', 'name': 'bdt', 'symbol': '৳'},
      {'code': 'INR', 'name': 'inr', 'symbol': '₹'},
      {'code': 'PKR', 'name': 'pkr', 'symbol': '₨'},
      {'code': 'SAR', 'name': 'sar', 'symbol': 'ر.س'},
      {'code': 'AED', 'name': 'aed', 'symbol': 'د.إ'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.zakatCurrencyLabel,
              style: AppTextStyles.titleSmall,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.monetization_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: supportedCurrencies.map((currency) {
                return DropdownMenuItem<String>(
                  value: currency['code'],
                  child: Text(
                      '${currency['symbol']} ${AppLocalizations.of(context)!.zakatCurrencyName(currency['name'] as String)}'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _selectedCurrency = value);
                  _fetchMetalPrices();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
        ],
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value != null && value.isNotEmpty) {
            final amount = double.tryParse(value);
            if (amount == null || amount < 0) {
              return AppLocalizations.of(context)!.zakatInvalidAmount;
            }
          }
          return null;
        },
      ),
    );
  }

  void _updateGoldValue(String grams) {
    final metalPrices = ref.read(metalPricesProvider).value;
    if (metalPrices != null && grams.isNotEmpty) {
      final gramsValue = double.tryParse(grams);
      if (gramsValue != null) {
        final value = gramsValue * metalPrices.goldPricePerGram;
        _goldValueController.text = value.toStringAsFixed(2);
      }
    }
  }

  void _updateSilverValue(String grams) {
    final metalPrices = ref.read(metalPricesProvider).value;
    if (metalPrices != null && grams.isNotEmpty) {
      final gramsValue = double.tryParse(grams);
      if (gramsValue != null) {
        final value = gramsValue * metalPrices.silverPricePerGram;
        _silverValueController.text = value.toStringAsFixed(2);
      }
    }
  }
}

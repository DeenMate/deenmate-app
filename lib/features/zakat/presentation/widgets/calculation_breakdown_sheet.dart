// Calculation breakdown bottom sheet widget
// Shows detailed asset-by-asset calculation breakdown

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/zakat_calculation.dart';

/// Bottom sheet displaying detailed Zakat calculation breakdown
class CalculationBreakdownSheet extends StatelessWidget {
  const CalculationBreakdownSheet({
    super.key,
    required this.calculation,
  });

  final ZakatCalculation calculation;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          _buildHeader(context),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Summary
                  _buildSummarySection(),
                  const SizedBox(height: 24),

                  // Asset Breakdown
                  _buildAssetBreakdownSection(),
                  const SizedBox(height: 24),

                  // Calculation Details
                  _buildCalculationDetailsSection(),
                  const SizedBox(height: 24),

                  // Islamic Guidelines
                  _buildIslamicGuidelinesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderColor.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zakat Calculation Breakdown',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Detailed analysis of your Zakat calculation',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    final currencySymbol = _getCurrencySymbol(calculation.currency);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Summary',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildSummaryRow(
              'Total Wealth',
              '$currencySymbol${calculation.wealth.toStringAsFixed(2)}',
              Icons.account_balance_wallet,
            ),
            const SizedBox(height: 12),
            _buildSummaryRow(
              'Nisab Threshold',
              '$currencySymbol${calculation.nisab.toStringAsFixed(2)}',
              Icons.trending_up,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: calculation.isEligible 
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _buildSummaryRow(
                'Zakat Due',
                '$currencySymbol${calculation.zakatDue.toStringAsFixed(2)}',
                calculation.isEligible ? Icons.mosque : Icons.info_outline,
                isHighlighted: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    IconData icon, {
    bool isHighlighted = false,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: isHighlighted 
              ? (calculation.isEligible ? AppColors.success : AppColors.warning)
              : AppColors.primary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
        GestureDetector(
          onTap: () => _copyToClipboard(value),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isHighlighted 
                  ? (calculation.isEligible 
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1))
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isHighlighted 
                        ? (calculation.isEligible ? AppColors.success : AppColors.warning)
                        : AppColors.primary,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.copy,
                  size: 12,
                  color: isHighlighted 
                      ? (calculation.isEligible ? AppColors.success : AppColors.warning)
                      : AppColors.primary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssetBreakdownSection() {
    final eligibleAssets = calculation.calculations.entries
        .where((entry) => entry.value.value > 0)
        .toList();

    if (eligibleAssets.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'No assets entered for calculation',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asset Breakdown',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ...eligibleAssets.map((entry) => _buildAssetItem(entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildAssetItem(ZakatAssetCalculation asset) {
    final currencySymbol = _getCurrencySymbol(calculation.currency);
    final icon = _getAssetIcon(asset.assetType);
    final title = _getAssetTitle(asset.assetType);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.02),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '$currencySymbol${asset.value.toStringAsFixed(2)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(width: 26), // Align with icon
              Expanded(
                child: Text(
                  'Zakat: $currencySymbol${asset.zakatDue.toStringAsFixed(2)} (2.5%)',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (asset.quantity != null && asset.unitValue != null) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const SizedBox(width: 26), // Align with icon
                Expanded(
                  child: Text(
                    '${asset.quantity!.toStringAsFixed(2)} units @ $currencySymbol${asset.unitValue!.toStringAsFixed(2)}/unit',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCalculationDetailsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calculation Details',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Zakat Rate', '2.5% (1/40th)'),
            _buildDetailRow('Calculation Type', _getCalculationTypeDescription()),
            _buildDetailRow('Currency', calculation.currency),
            if (calculation.goldPricePerGram != null)
              _buildDetailRow(
                'Gold Price',
                '${calculation.goldPricePerGram!.toStringAsFixed(2)} per gram',
              ),
            if (calculation.silverPricePerGram != null)
              _buildDetailRow(
                'Silver Price',
                '${calculation.silverPricePerGram!.toStringAsFixed(2)} per gram',
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIslamicGuidelinesSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.success.withOpacity(0.05),
              AppColors.success.withOpacity(0.02),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.mosque,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Islamic Guidelines',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildGuidelineItem(
                'Recipients of Zakat',
                'Eight categories mentioned in Quran (9:60): The poor, needy, '
                'collectors, those whose hearts are inclined, freeing slaves, '
                'debtors, in Allah\'s path, and travelers.',
              ),
              _buildGuidelineItem(
                'Timing',
                'Zakat is due once wealth reaches Nisab and remains above it '
                'for one full lunar year (Hawl).',
              ),
              _buildGuidelineItem(
                'Distribution',
                'It is recommended to distribute Zakat locally first, then to '
                'other areas if local needs are met.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuidelineItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'BDT':
        return '৳';
      case 'INR':
        return '₹';
      case 'PKR':
        return '₨';
      case 'SAR':
        return 'ر.س';
      case 'AED':
        return 'د.إ';
      default:
        return currency;
    }
  }

  IconData _getAssetIcon(ZakatAssetType assetType) {
    switch (assetType) {
      case ZakatAssetType.cash:
        return Icons.payments;
      case ZakatAssetType.savings:
        return Icons.savings;
      case ZakatAssetType.gold:
        return Icons.circle;
      case ZakatAssetType.silver:
        return Icons.circle_outlined;
      case ZakatAssetType.businessInventory:
        return Icons.inventory;
      case ZakatAssetType.accountsReceivable:
        return Icons.request_quote;
      case ZakatAssetType.investments:
        return Icons.show_chart;
      case ZakatAssetType.rentalIncome:
        return Icons.home_work;
      case ZakatAssetType.cattle:
        return Icons.pets;
      case ZakatAssetType.sheep:
        return Icons.pets;
      case ZakatAssetType.camels:
        return Icons.pets;
      case ZakatAssetType.crops:
        return Icons.agriculture;
      case ZakatAssetType.other:
        return Icons.more_horiz;
    }
  }

  String _getAssetTitle(ZakatAssetType assetType) {
    switch (assetType) {
      case ZakatAssetType.cash:
        return 'Cash & Checking Accounts';
      case ZakatAssetType.savings:
        return 'Savings & Fixed Deposits';
      case ZakatAssetType.gold:
        return 'Gold Assets';
      case ZakatAssetType.silver:
        return 'Silver Assets';
      case ZakatAssetType.businessInventory:
        return 'Business Inventory';
      case ZakatAssetType.accountsReceivable:
        return 'Accounts Receivable';
      case ZakatAssetType.investments:
        return 'Investments & Stocks';
      case ZakatAssetType.rentalIncome:
        return 'Rental Property Income';
      case ZakatAssetType.cattle:
        return 'Cattle';
      case ZakatAssetType.sheep:
        return 'Sheep & Goats';
      case ZakatAssetType.camels:
        return 'Camels';
      case ZakatAssetType.crops:
        return 'Agricultural Crops';
      case ZakatAssetType.other:
        return 'Other Assets';
    }
  }

  String _getCalculationTypeDescription() {
    switch (calculation.calculationType) {
      case ZakatCalculationType.comprehensive:
        return 'Comprehensive (All Assets)';
      case ZakatCalculationType.cashOnly:
        return 'Cash Only';
      case ZakatCalculationType.goldSilver:
        return 'Gold & Silver';
      case ZakatCalculationType.business:
        return 'Business Assets';
      case ZakatCalculationType.livestock:
        return 'Livestock';
      case ZakatCalculationType.agriculture:
        return 'Agriculture';
    }
  }

  void _copyToClipboard(String text) {
    // Remove currency symbols for copying
    final cleanText = text.replaceAll(RegExp(r'[^\d\.]'), '');
    Clipboard.setData(ClipboardData(text: cleanText));
  }
}

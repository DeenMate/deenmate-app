// Zakat calculation result display widget
// Shows calculation results with detailed breakdown and Islamic context

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/zakat_calculation.dart';

/// Widget displaying Zakat calculation results
class ZakatResultCard extends StatelessWidget {
  const ZakatResultCard({
    super.key,
    required this.calculation,
    this.onShowBreakdown,
    this.onShareResult,
  });

  final ZakatCalculation calculation;
  final VoidCallback? onShowBreakdown;
  final VoidCallback? onShareResult;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: calculation.isEligible
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.1),
                    AppColors.success.withOpacity(0.05),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.warning.withOpacity(0.1),
                    AppColors.warning.withOpacity(0.05),
                  ],
                ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildResultHeader(),
              const SizedBox(height: 20),

              // Main Result
              _buildMainResult(),
              const SizedBox(height: 16),

              // Wealth Summary
              _buildWealthSummary(),
              const SizedBox(height: 16),

              // Nisab Information
              _buildNisabInfo(),
              const SizedBox(height: 20),

              // Action Buttons
              _buildActionButtons(context),

              // Islamic Reminder
              if (calculation.isEligible) ...[
                const SizedBox(height: 16),
                _buildIslamicReminder(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: calculation.isEligible 
                ? AppColors.success.withOpacity(0.1)
                : AppColors.warning.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            calculation.isEligible ? Icons.mosque : Icons.info_outline,
            color: calculation.isEligible ? AppColors.success : AppColors.warning,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Zakat Calculation Result',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                calculation.isEligible ? 'Zakat is due' : 'Below Nisab threshold',
                style: AppTextStyles.bodySmall.copyWith(
                  color: calculation.isEligible 
                      ? AppColors.success 
                      : AppColors.warning,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainResult() {
    final currencySymbol = _getCurrencySymbol(calculation.currency);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: calculation.isEligible 
            ? AppColors.success.withOpacity(0.08)
            : AppColors.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: calculation.isEligible 
              ? AppColors.success.withOpacity(0.2)
              : AppColors.warning.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zakat Due',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$currencySymbol${calculation.zakatDue.toStringAsFixed(2)}',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: calculation.isEligible 
                        ? AppColors.success 
                        : AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (calculation.isEligible) ...[
                  const SizedBox(height: 4),
                  Text(
                    '2.5% of eligible wealth',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (calculation.isEligible)
            GestureDetector(
              onTap: () => _copyToClipboard('${calculation.zakatDue.toStringAsFixed(2)}'),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.copy,
                  color: AppColors.success,
                  size: 16,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWealthSummary() {
    final currencySymbol = _getCurrencySymbol(calculation.currency);
    
    return Row(
      children: [
        Expanded(
          child: _buildWealthItem(
            'Total Wealth',
            '$currencySymbol${calculation.wealth.toStringAsFixed(2)}',
            Icons.account_balance_wallet,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildWealthItem(
            'Nisab Threshold',
            '$currencySymbol${calculation.nisab.toStringAsFixed(2)}',
            Icons.trending_up,
          ),
        ),
      ],
    );
  }

  Widget _buildWealthItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.borderColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNisabInfo() {
    if (calculation.goldPricePerGram == null || calculation.silverPricePerGram == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Based on current gold (${calculation.goldPricePerGram!.toStringAsFixed(2)}/g) '
              'and silver (${calculation.silverPricePerGram!.toStringAsFixed(2)}/g) prices',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        if (onShowBreakdown != null)
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onShowBreakdown,
              icon: const Icon(Icons.analytics, size: 16),
              label: const Text('Breakdown'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        if (onShowBreakdown != null && onShareResult != null)
          const SizedBox(width: 12),
        if (onShareResult != null)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onShareResult,
              icon: const Icon(Icons.share, size: 16),
              label: const Text('Share'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildIslamicReminder() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.success.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.mosque,
            color: AppColors.success,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Islamic Reminder',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Paying Zakat purifies your wealth and brings barakah. '
                  'Give to the eight categories mentioned in the Quran: '
                  'the poor, needy, collectors, those whose hearts are inclined, '
                  'freeing slaves, debtors, in Allah\'s path, and travelers.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
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

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }
}

/// Compact version of the result card for summary views
class CompactZakatResultCard extends StatelessWidget {
  const CompactZakatResultCard({
    super.key,
    required this.calculation,
    this.onTap,
  });

  final ZakatCalculation calculation;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = _getCurrencySymbol(calculation.currency);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: calculation.isEligible 
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.warning.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  calculation.isEligible ? Icons.mosque : Icons.info_outline,
                  color: calculation.isEligible ? AppColors.success : AppColors.warning,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      calculation.isEligible ? 'Zakat Due' : 'Below Nisab',
                      style: AppTextStyles.titleSmall,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$currencySymbol${calculation.zakatDue.toStringAsFixed(2)}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: calculation.isEligible 
                            ? AppColors.success 
                            : AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
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
}

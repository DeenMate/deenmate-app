import 'package:flutter/material.dart';

import '../../../../core/theme/islamic_theme.dart';
import '../../../../core/localization/strings.dart';
import '../../../../l10n/generated/app_localizations.dart';

/// Qibla error widget with recovery options
class QiblaErrorWidget extends StatelessWidget {
  const QiblaErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    required this.onCalibrate,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onCalibrate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildErrorIcon(),
            const SizedBox(height: 24),
            _buildErrorTitle(context),
            const SizedBox(height: 16),
            _buildErrorMessage(context),
            const SizedBox(height: 32),
            _buildErrorActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.error_outline,
        size: 40,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.qiblaError,
      style: IslamicTheme.textTheme.headlineSmall?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            message,
            style: IslamicTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.qiblaErrorHelp,
            style: IslamicTheme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorActions(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: Text(AppLocalizations.of(context)!.commonRetry),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: IslamicTheme.islamicGreen,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onCalibrate,
          icon: const Icon(Icons.compass_calibration),
          label: Text(AppLocalizations.of(context)!.qiblaCalibrateCompass),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white.withOpacity(0.9),
            foregroundColor: IslamicTheme.islamicGreen,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: () {
            // Show help dialog
            showDialog(
              context: context,
              builder: (context) => _buildHelpDialog(context),
            );
          },
          icon: const Icon(Icons.help_outline, color: Colors.white),
          label: Text(
            AppLocalizations.of(context)!.commonHelp,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildHelpDialog(BuildContext context) {
    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.qiblaHelpTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.qiblaHelpCommonIssues,
            style: IslamicTheme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildHelpItem(
            context,
            AppLocalizations.of(context)!.qiblaHelpLocationPermission,
            AppLocalizations.of(context)!.qiblaHelpLocationPermissionText,
          ),
          _buildHelpItem(
            context,
            AppLocalizations.of(context)!.qiblaHelpCompassSensor,
            AppLocalizations.of(context)!.qiblaHelpCompassSensorText,
          ),
          _buildHelpItem(
            context,
            AppLocalizations.of(context)!.qiblaHelpCalibration,
            AppLocalizations.of(context)!.qiblaHelpCalibrationText,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.close),
        ),
      ],
    );
  }

  Widget _buildHelpItem(
      BuildContext context, String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: IslamicTheme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: IslamicTheme.textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

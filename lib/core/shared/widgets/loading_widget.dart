// Loading widget with Islamic styling
// Provides consistent loading indicators across the app

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Custom loading widget with Islamic theming
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    this.size = 40,
    this.color,
    this.message,
    this.showMessage = false,
  });

  final double size;
  final Color? color;
  final String? message;
  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    final loadingColor = color ?? AppColors.primary;
    
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(loadingColor),
            ),
          ),
          if (showMessage && message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Overlay loading widget for full-screen loading
class OverlayLoadingWidget extends StatelessWidget {
  const OverlayLoadingWidget({
    super.key,
    this.message = 'Loading...',
    this.backgroundColor,
  });

  final String message;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.black.withOpacity(0.5),
      child: LoadingWidget(
        message: message,
        showMessage: true,
      ),
    );
  }
}

/// Compact loading widget for inline use
class CompactLoadingWidget extends StatelessWidget {
  const CompactLoadingWidget({
    super.key,
    this.size = 20,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

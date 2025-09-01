import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/accessibility_settings.dart';
import '../repositories/settings_repository.dart';

/// Use case for updating accessibility settings
class UpdateAccessibilitySettings {
  final SettingsRepository repository;

  UpdateAccessibilitySettings(this.repository);

  Future<Either<Failure, void>> call(AccessibilitySettings settings) async {
    try {
      // Validate settings before updating
      if (!settings.isValid) {
        return Left(ValidationFailure('Invalid accessibility settings'));
      }

      await repository.updateAccessibilitySettings(settings);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to update accessibility settings: $e'));
    }
  }
}

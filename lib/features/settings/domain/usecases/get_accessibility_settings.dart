import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/accessibility_settings.dart';
import '../repositories/settings_repository.dart';

/// Use case for getting accessibility settings
class GetAccessibilitySettings {
  final SettingsRepository repository;

  GetAccessibilitySettings(this.repository);

  Future<Either<Failure, AccessibilitySettings>> call() async {
    try {
      final settings = await repository.getAccessibilitySettings();
      
      // Validate settings
      if (!settings.isValid) {
        return Left(ValidationFailure('Invalid accessibility settings detected'));
      }
      
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure('Failed to get accessibility settings: $e'));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

/// Use case for updating application settings
class UpdateAppSettings {
  final SettingsRepository repository;

  UpdateAppSettings(this.repository);

  Future<Either<Failure, void>> call(AppSettings settings) async {
    try {
      // Validate settings before updating
      if (!settings.isValid) {
        return Left(ValidationFailure('Invalid app settings'));
      }

      await repository.updateAppSettings(settings);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to update app settings: $e'));
    }
  }
}

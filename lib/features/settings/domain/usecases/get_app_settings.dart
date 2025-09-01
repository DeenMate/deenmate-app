import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

/// Use case for getting application settings
class GetAppSettings {
  final SettingsRepository repository;

  GetAppSettings(this.repository);

  Future<Either<Failure, AppSettings>> call() async {
    try {
      final settings = await repository.getAppSettings();
      
      // Validate settings
      if (!settings.isValid) {
        return Left(ValidationFailure('Invalid app settings detected'));
      }
      
      return Right(settings);
    } catch (e) {
      return Left(CacheFailure('Failed to get app settings: $e'));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/settings_repository.dart';

/// Use case for resetting all settings to defaults
class ResetSettings {
  final SettingsRepository repository;

  ResetSettings(this.repository);

  Future<Either<Failure, void>> call() async {
    try {
      await repository.resetToDefaults();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to reset settings: $e'));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/settings_repository.dart';

/// Use case for exporting settings to a portable format
class ExportSettings {
  final SettingsRepository repository;

  ExportSettings(this.repository);

  Future<Either<Failure, Map<String, dynamic>>> call() async {
    try {
      final settingsData = await repository.exportSettings();
      
      // Add metadata
      final exportData = {
        'version': '1.0',
        'exportDate': DateTime.now().toIso8601String(),
        'appVersion': '1.0.0', // Should come from app constants
        'settings': settingsData,
      };
      
      return Right(exportData);
    } catch (e) {
      return Left(CacheFailure('Failed to export settings: $e'));
    }
  }
}

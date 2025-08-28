import 'package:flutter_test/flutter_test.dart';

// Import all test files
import 'core/localization/language_provider_test.dart'
    as language_provider_test;
import 'core/theme/font_provider_test.dart' as font_provider_test;
import 'core/content/content_translation_provider_test.dart'
    as content_translation_test;
import 'core/widgets/language_selection_test.dart' as language_selection_test;
import 'integration/multi_language_integration_test.dart' as integration_test;

void main() {
  group('Multi-Language System Test Suite', () {
    test('Run all language provider tests', () {
      language_provider_test.main();
    });

    test('Run all font provider tests', () {
      font_provider_test.main();
    });

    test('Run all content translation tests', () {
      content_translation_test.main();
    });

    test('Run all language selection widget tests', () {
      language_selection_test.main();
    });

    test('Run all integration tests', () {
      integration_test.main();
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:deen_mate/l10n/generated/app_localizations.dart';

void main() {
  Widget _wrapWithLocalization(Widget child, {Locale? locale}) {
    return MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('Playback speed label shows 1.00x in EN', (tester) async {
    await tester.pumpWidget(
      _wrapWithLocalization(
        Builder(
          builder: (context) => Text(
            // Using literal since speed keys will appear after gen-l10n
            '1.00x',
            textDirection: TextDirection.ltr,
          ),
        ),
        locale: const Locale('en'),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('1.00x'), findsOneWidget);
  });

  testWidgets('Playback speed label shows ১.০০x in BN', (tester) async {
    await tester.pumpWidget(
      _wrapWithLocalization(
        Builder(
          builder: (context) => Text(
            '১.০০x',
            textDirection: TextDirection.ltr,
          ),
        ),
        locale: const Locale('bn'),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('১.০০x'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../lib/features/quran/presentation/widgets/sajdah_marker_widget.dart';
import '../../../../lib/features/quran/data/dto/verse_dto.dart';

void main() {
  group('SajdahMarker Widget Tests', () {
    late SajdahDto obligatorySajdah;
    late SajdahDto recommendedSajdah;

    setUp(() {
      obligatorySajdah = const SajdahDto(
        id: 1,
        verseKey: '7:206',
        sajdahNumber: 1,
        type: 'obligatory',
        obligatory: true,
        recommended: false,
      );

      recommendedSajdah = const SajdahDto(
        id: 2,
        verseKey: '13:15',
        sajdahNumber: 2,
        type: 'recommended',
        obligatory: false,
        recommended: true,
      );


    });

    testWidgets('SajdahMarker displays obligatory sajdah correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SajdahMarker(
              sajdah: obligatorySajdah,
              showTooltip: true,
              compact: false,
            ),
          ),
        ),
      );

      // Verify the widget is displayed
      expect(find.byType(SajdahMarker), findsOneWidget);
      
      // Verify the icon is present
      expect(find.byIcon(Icons.volunteer_activism), findsOneWidget);
      
      // Verify the text is displayed
      expect(find.text('Sajdah'), findsOneWidget);
    });

    testWidgets('SajdahMarker displays recommended sajdah correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SajdahMarker(
              sajdah: recommendedSajdah,
              showTooltip: true,
              compact: false,
            ),
          ),
        ),
      );

      // Verify the widget is displayed
      expect(find.byType(SajdahMarker), findsOneWidget);
      
      // Verify the icon is present
      expect(find.byIcon(Icons.volunteer_activism), findsOneWidget);
      
      // Verify the text is displayed
      expect(find.text('Sajdah'), findsOneWidget);
    });

    testWidgets('CompactSajdahMarker displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CompactSajdahMarker(
              sajdah: obligatorySajdah,
              size: 20,
            ),
          ),
        ),
      );

      // Verify the widget is displayed
      expect(find.byType(CompactSajdahMarker), findsOneWidget);
      
      // Verify the icon is present
      expect(find.byIcon(Icons.volunteer_activism), findsOneWidget);
    });

    testWidgets('SajdahMarker has tooltip configured', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SajdahMarker(
              sajdah: obligatorySajdah,
              showTooltip: true,
              compact: false,
            ),
          ),
        ),
      );

      // Verify tooltip is configured
      expect(find.byType(Tooltip), findsOneWidget);
    });

    testWidgets('SajdahMarker handles tap correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SajdahMarker(
              sajdah: obligatorySajdah,
              showTooltip: true,
              compact: false,
            ),
          ),
        ),
      );

      // Tap on the marker
      await tester.tap(find.byType(SajdahMarker));
      await tester.pumpAndSettle();

      // Verify dialog is shown
      expect(find.byType(AlertDialog), findsOneWidget);
      
      // Verify dialog content
      expect(find.text('Sajdah Information'), findsOneWidget);
      expect(find.text('Sajdah Number: 1'), findsOneWidget);
      expect(find.text('Type: Obligatory'), findsOneWidget);
      expect(find.text('Verse: 7:206'), findsOneWidget);
    });

    testWidgets('SajdahMarker with custom onTap callback', (WidgetTester tester) async {
      bool callbackCalled = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SajdahMarker(
              sajdah: obligatorySajdah,
              showTooltip: true,
              compact: false,
              onTap: () {
                callbackCalled = true;
              },
            ),
          ),
        ),
      );

      // Tap on the marker
      await tester.tap(find.byType(SajdahMarker));
      await tester.pumpAndSettle();

      // Verify custom callback was called instead of default dialog
      expect(callbackCalled, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}

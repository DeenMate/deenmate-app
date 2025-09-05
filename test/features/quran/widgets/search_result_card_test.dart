import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Search Result Highlighting Tests', () {
    test('RichText highlighting works with multiple matches', () {
      const query = 'Allah';
      const text = 'In the name of Allah, the Entirely Merciful, the Especially Merciful. Allah is great.';
      
      final highlightedText = _buildHighlightedText(text, query);
      
      // Verify that RichText is returned
      expect(highlightedText, isA<RichText>());
      
      final richText = highlightedText as RichText;
      expect(richText.text, isA<TextSpan>());
      
      final textSpan = richText.text as TextSpan;
      expect(textSpan.children, isNotNull);
      expect(textSpan.children!.length, 5); // Should have 5 spans
    });

    test('Empty query returns Text widget', () {
      const query = '';
      const text = 'In the name of Allah, the Entirely Merciful, the Especially Merciful.';
      
      final highlightedText = _buildHighlightedText(text, query);
      
      // Verify that Text is returned
      expect(highlightedText, isA<Text>());
      
      final textWidget = highlightedText as Text;
      expect(textWidget.data, text);
    });

    test('No matches returns Text widget', () {
      const query = 'NonExistentWord';
      const text = 'In the name of Allah, the Entirely Merciful, the Especially Merciful.';
      
      final highlightedText = _buildHighlightedText(text, query);
      
      // Verify that Text is returned
      expect(highlightedText, isA<Text>());
      
      final textWidget = highlightedText as Text;
      expect(textWidget.data, text);
    });

    test('RichText highlighting creates correct spans for matches', () {
      const query = 'Allah';
      const text = 'In the name of Allah, the Entirely Merciful, the Especially Merciful. Allah is great.';
      
      final highlightedText = _buildHighlightedText(text, query);
      
      expect(highlightedText, isA<RichText>());
      
      final richText = highlightedText as RichText;
      final textSpan = richText.text as TextSpan;
      
      // Should have 5 spans: "In the name of ", "Allah", ", the Entirely Merciful, the Especially Merciful. ", "Allah", " is great."
      expect(textSpan.children!.length, 5);
      
      // Check that highlighted spans have the correct styling
      bool hasHighlightedSpan = false;
      for (final span in textSpan.children!) {
        if (span is TextSpan && span.style?.backgroundColor != null) {
          hasHighlightedSpan = true;
          expect(span.style!.fontWeight, FontWeight.w600);
          expect(span.style!.backgroundColor, Colors.yellow.withOpacity(0.3));
        }
      }
      expect(hasHighlightedSpan, isTrue);
    });

    test('Special regex characters are handled correctly', () {
      const query = 'Allah*+?';
      const text = 'In the name of Allah, the Entirely Merciful, the Especially Merciful.';
      
      final highlightedText = _buildHighlightedText(text, query);
      
      // Should return Text widget since the escaped pattern won't match
      expect(highlightedText, isA<Text>());
    });
  });
}

Widget _buildHighlightedText(String text, String query) {
  final style = const TextStyle(
    color: Colors.black,
    height: 1.5,
  );
  
  final q = query.trim();
  if (q.isEmpty) return Text(text, style: style);
  
  try {
    final pattern = RegExp(RegExp.escape(q), caseSensitive: false);
    final matches = pattern.allMatches(text).toList();
    if (matches.isEmpty) return Text(text, style: style);

    final spans = <TextSpan>[];
    int cursor = 0;
    for (final m in matches) {
      if (m.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, m.start)));
      }
      spans.add(TextSpan(
        text: text.substring(m.start, m.end),
        style: style.copyWith(
          backgroundColor: Colors.yellow.withOpacity(0.3),
          fontWeight: FontWeight.w600,
        ),
      ));
      cursor = m.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return RichText(text: TextSpan(style: style, children: spans));
  } catch (_) {
    return Text(text, style: style);
  }
}

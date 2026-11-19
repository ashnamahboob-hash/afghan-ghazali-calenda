import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/screens/home_screen.dart';

void main() {
  testWidgets('Pashto and Dari use right-to-left direction; English uses left-to-right', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: HomeScreen()),
    );

    Directionality contentDirection() => tester.widget<Directionality>(
          find.byKey(const ValueKey('home-content-direction')),
        );

    expect(contentDirection().textDirection, TextDirection.rtl);

    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();
    await tester.tap(find.text('English').last);
    await tester.pumpAndSettle();
    expect(contentDirection().textDirection, TextDirection.ltr);

    await tester.tap(find.byIcon(Icons.language));
    await tester.pumpAndSettle();
    await tester.tap(find.text('دری').last);
    await tester.pumpAndSettle();
    expect(contentDirection().textDirection, TextDirection.rtl);
  });
}

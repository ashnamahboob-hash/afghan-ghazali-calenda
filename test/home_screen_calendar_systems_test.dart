import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/screens/home_screen.dart';

void main() {
  testWidgets('Calendar grid displays Afghan, Gregorian and Islamic dates',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('افغاني لمریز  ·  عیسوي میلادي  ·  اسلامي قمري'),
        findsOneWidget);
    expect(find.textContaining('·'), findsWidgets);
  });
}

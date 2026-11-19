import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:afghan_ghazali_calendar/screens/agriculture_screen.dart';

void main() {
  testWidgets('shows clearly labeled QA dates and updates them when crop changes',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AgricultureScreen(language: 'ps'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('ازمایښتي معلومات'), findsOneWidget);
    expect(find.text('15/10 – 15/11'), findsOneWidget);
    expect(find.text('15/05 – 15/06'), findsOneWidget);

    // The last dropdown is the crop selector.
    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('وریجې').last);
    await tester.pumpAndSettle();

    expect(find.text('01/09 – 20/09'), findsOneWidget);
    expect(find.text('01/01 – 20/01'), findsOneWidget);
    expect(find.textContaining('د کرنې لپاره یې مه کاروئ'), findsOneWidget);
  });
}

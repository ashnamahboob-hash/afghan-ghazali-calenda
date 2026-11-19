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
    // The screen contains an indeterminate loading spinner while its bundled
    // administrative reference is read; pump a bounded interval instead of
    // waiting for all animations to settle.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.textContaining('ازمایښتي معلومات'), findsOneWidget);
    expect(find.text('15/10 – 15/11'), findsOneWidget);
    expect(find.text('15/05 – 15/06'), findsOneWidget);

    // The last dropdown is the crop selector.
    await tester.tap(find.byType(DropdownButtonFormField<String>).last);
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.text('وریجې').last);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('01/09 – 20/09'), findsOneWidget);
    expect(find.text('01/01 – 20/01'), findsOneWidget);

    // The warning is below the initial viewport in the scrollable screen.
    // Scroll it into view before asserting so the lazy ListView builds it.
    final warning = find.textContaining('د حقیقي کرنې لپاره یې مه کاروئ');
    await tester.scrollUntilVisible(
      warning,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(warning, findsOneWidget);
  });
}

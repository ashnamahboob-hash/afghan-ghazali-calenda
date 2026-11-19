import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/screens/home_screen.dart';

void main() {
  testWidgets('Calendar grid displays Afghan, Gregorian and Islamic dates',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    // The calendar sits inside a scrollable page. Bring its legend into view
    // so all calendar day cells are built before checking their paired dates.
    final calendarLegend = find.textContaining('افغاني لمریز');
    await tester.ensureVisible(calendarLegend);
    await tester.pumpAndSettle();

    final dateLabels = find.byWidgetPredicate(
      (widget) => widget is Text && (widget.data?.contains(' · ') ?? false),
    );
    expect(dateLabels, findsAtLeastNWidgets(29));
  });
}

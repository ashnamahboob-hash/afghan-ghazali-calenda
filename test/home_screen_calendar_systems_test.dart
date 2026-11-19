import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/screens/home_screen.dart';

void main() {
  testWidgets('Calendar grid displays Afghan, Gregorian and Islamic dates',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();

    // The calendar is below the hero card in a lazy ListView. Scroll until
    // its legend is built, then bring the full calendar grid into view.
    final listView = find.byType(ListView).first;
    final calendarLegend = find.textContaining('افغاني لمریز');
    for (var attempt = 0;
        attempt < 6 && calendarLegend.evaluate().isEmpty;
        attempt++) {
      await tester.drag(listView, const Offset(0, -500));
      await tester.pumpAndSettle();
    }
    expect(calendarLegend, findsOneWidget);
    await tester.ensureVisible(calendarLegend);
    await tester.pumpAndSettle();

    final dateLabels = find.byWidgetPredicate(
      (widget) => widget is Text && (widget.data?.contains(' · ') ?? false),
    );
    expect(dateLabels, findsAtLeastNWidgets(29));
  });
}

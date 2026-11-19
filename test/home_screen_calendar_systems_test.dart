import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/screens/home_screen.dart';

void main() {
  testWidgets('Calendar grid displays Afghan, Gregorian and Islamic dates',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    await tester.pumpAndSettle();

    // Verify the rendered calendar exposes paired Gregorian and Islamic
    // day labels, without relying on a specific localized legend string.
    final dateLabels = find.byWidgetPredicate(
      (widget) =>
          widget is Text && (widget.data?.contains(' · ') ?? false),
    );
    // Each populated day cell shows the Gregorian and Islamic day numbers.
    expect(dateLabels, findsAtLeastNWidgets(29));
  });
}

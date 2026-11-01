import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:afghan_ghazali_calendar/screens/home_screen.dart';
import 'package:afghan_ghazali_calendar/services/afghan_calendar.dart';

void main() {
  testWidgets('Month arrows navigate by Afghan solar months', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    final current = AfghanCalendar.fromGregorian(DateTime.now());
    final nextMonth = current.month == 12 ? 1 : current.month + 1;
    final nextYear = current.month == 12 ? current.year + 1 : current.year;
    final nextLabel =
        '${AfghanCalendar.monthName(nextMonth, 'ps')} '
        '${AfghanCalendar.formatNumber(nextYear, 'ps')}';

    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pumpAndSettle();
    expect(find.text(nextLabel), findsOneWidget);

    final previousLabel =
        '${AfghanCalendar.monthName(current.month, 'ps')} '
        '${AfghanCalendar.formatNumber(current.year, 'ps')}';
    await tester.tap(find.byIcon(Icons.chevron_left));
    await tester.pumpAndSettle();
    expect(find.text(previousLabel), findsOneWidget);
  });
}

import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> _testSinglePoint(
    WidgetTester tester, [
    String dropdownValue = '',
  ]) async {
    // Inserting data
    final finder = find.byType(TextFormField);
    await tester.enterText(finder.first, 'x-2.25');
    await tester.enterText(finder.last, '2');

    if (dropdownValue.isNotEmpty) {
      // Changing the dropdown value
      await tester.tap(find.text('Newton'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(dropdownValue).last);
      await tester.pumpAndSettle();
    }

    // Solving
    final solveBtn = find.byKey(const Key('Nonlinear-button-solve'));

    await tester.ensureVisible(solveBtn);
    await tester.pumpAndSettle();

    await tester.tap(solveBtn);
    await tester.pump();

    // Expecting solutions
    expect(find.byType(RealResultCard), findsNWidgets(3));

    // Cleaning
    final cleanBtn = find.byKey(const Key('Nonlinear-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pump();

    expect(find.byType(RealResultCard), findsNothing);
  }

  Future<void> _testBracketing(
    WidgetTester tester, [
    String dropdownValue = '',
  ]) async {
    // Moving to the 'Bracketing' page
    await tester.tap(find.text('Bracketing'));
    await tester.pumpAndSettle();

    // Inserting data
    final finder = find.byType(TextFormField);
    await tester.enterText(finder.at(0), 'x-2.25');
    await tester.enterText(finder.at(1), '1');
    await tester.enterText(finder.at(2), '3');

    if (dropdownValue.isNotEmpty) {
      // Changing the dropdown value
      await tester.tap(find.text('Bisection'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(dropdownValue).last);
      await tester.pumpAndSettle();
    }

    // Solving
    final solveBtn = find.byKey(const Key('Nonlinear-button-solve'));

    await tester.ensureVisible(solveBtn);
    await tester.pumpAndSettle();

    await tester.tap(solveBtn);
    await tester.pump();

    // Expecting solutions
    expect(find.byType(RealResultCard), findsNWidgets(3));

    // Cleaning
    final cleanBtn = find.byKey(const Key('Nonlinear-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pump();

    expect(find.byType(RealResultCard), findsNothing);
  }

  group('Integration tests on the Nonlinear page', () {
    testWidgets(
      'Testing nonlinear equations - Newton',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the nonlinear page
        await tester.tap(find.byKey(const Key('NonlinearLogo-Container')));
        await tester.pumpAndSettle();

        await _testSinglePoint(tester);
      },
    );

    testWidgets(
      'Testing nonlinear equations - Steffensen',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the nonlinear page
        await tester.tap(find.byKey(const Key('NonlinearLogo-Container')));
        await tester.pumpAndSettle();

        await _testSinglePoint(tester, 'Steffensen');
      },
    );

    testWidgets(
      'Testing nonlinear equations - Bisection',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the nonlinear page
        await tester.tap(find.byKey(const Key('NonlinearLogo-Container')));
        await tester.pumpAndSettle();

        await _testBracketing(tester);
      },
    );

    testWidgets(
      'Testing nonlinear equations - Secant',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the nonlinear page
        await tester.tap(find.byKey(const Key('NonlinearLogo-Container')));
        await tester.pumpAndSettle();

        await _testBracketing(tester, 'Secant');
      },
    );

    testWidgets(
      'Testing nonlinear equations - Brent',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the nonlinear page
        await tester.tap(find.byKey(const Key('NonlinearLogo-Container')));
        await tester.pumpAndSettle();

        await _testBracketing(tester, 'Brent');
      },
    );
  });
}

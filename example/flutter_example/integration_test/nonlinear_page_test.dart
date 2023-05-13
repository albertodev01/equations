import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  var needsOpenPage = true;

  Future<void> testSinglePoint(
    WidgetTester tester, [
    String dropdownValue = '',
  ]) async {
    if (needsOpenPage) {
      // Opening the nonlinear page
      await tester.tap(find.byKey(const Key('NonlinearLogo-Container')));
      await tester.pumpAndSettle();

      needsOpenPage = false;
    }

    // Inserting data
    final finder = find.byType(TextFormField);
    await tester.enterText(finder.first, 'x-2.25');
    await tester.enterText(finder.last, '2');

    if (dropdownValue.isNotEmpty) {
      await tester.ensureVisible(find.text('Newton'));
      await tester.pumpAndSettle();

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
    await tester.ensureVisible(find.byType(RealResultCard).first);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNWidgets(3));

    // Cleaning
    final cleanBtn = find.byKey(const Key('Nonlinear-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pump();

    expect(find.byType(RealResultCard), findsNothing);
  }

  Future<void> testBracketing(
    WidgetTester tester, [
    String dropdownValue = '',
  ]) async {
    // Moving to the 'Bracketing' page
    tester
        .widget<InheritedNavigation>(find.byType(InheritedNavigation))
        .navigationIndex
        .value = 1;

    await tester.pumpAndSettle();

    // Inserting data
    final finder = find.byType(TextFormField);
    await tester.enterText(finder.at(0), 'x-2.25');
    await tester.enterText(finder.at(1), '1');
    await tester.enterText(finder.at(2), '3');

    if (dropdownValue.isNotEmpty) {
      await tester.ensureVisible(find.text('Bisection'));
      await tester.pumpAndSettle();

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
    await tester.ensureVisible(find.byType(RealResultCard).first);
    await tester.pumpAndSettle();

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
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testSinglePoint(tester);
      },
    );

    testWidgets(
      'Testing nonlinear equations - Steffensen',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testSinglePoint(tester, 'Steffensen');
      },
    );

    testWidgets(
      'Testing nonlinear equations - Bisection',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testBracketing(tester);
      },
    );

    testWidgets(
      'Testing nonlinear equations - Secant',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testBracketing(tester, 'Secant');
      },
    );

    testWidgets(
      'Testing nonlinear equations - Brent',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testBracketing(tester, 'Brent');
      },
    );
  });
}

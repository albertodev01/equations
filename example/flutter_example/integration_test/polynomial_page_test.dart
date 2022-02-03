import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> _testPolynomial(WidgetTester tester, int degree) async {
    final finder = find.byType(TextFormField);
    for (var i = 0; i <= degree; ++i) {
      await tester.enterText(finder.at(i), '${i + 1}');
    }

    // Solving
    final solveBtn = find.byKey(const Key('Polynomial-button-solve'));

    await tester.ensureVisible(solveBtn);
    await tester.pumpAndSettle();

    await tester.tap(solveBtn);
    await tester.pumpAndSettle();

    // Expecting solutions: 1 card for the root and 1 for the discriminant
    expect(find.byType(ComplexResultCard), findsNWidgets(degree + 1));

    // Cleaning
    final cleanBtn = find.byKey(const Key('Polynomial-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pumpAndSettle();

    expect(find.byType(ComplexResultCard), findsNothing);
  }

  group('Integration tests on the Polynomial page', () {
    testWidgets(
      'Testing linear equations',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the polynomial page
        await tester.tap(find.byKey(const Key('PolynomialLogo-Container')));
        await tester.pumpAndSettle();

        await _testPolynomial(tester, 1);
      },
    );

    testWidgets(
      'Testing quadratic equations',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the polynomial page
        await tester.tap(find.byKey(const Key('PolynomialLogo-Container')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Quadratic'));
        await tester.pumpAndSettle();

        await _testPolynomial(tester, 2);
      },
    );

    testWidgets(
      'Testing cubic equations',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the polynomial page
        await tester.tap(find.byKey(const Key('PolynomialLogo-Container')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cubic'));
        await tester.pumpAndSettle();

        await _testPolynomial(tester, 3);
      },
    );

    testWidgets(
      'Testing quartic equations',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the polynomial page
        await tester.tap(find.byKey(const Key('PolynomialLogo-Container')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Quartic'));
        await tester.pumpAndSettle();

        await _testPolynomial(tester, 4);
      },
    );
  });
}

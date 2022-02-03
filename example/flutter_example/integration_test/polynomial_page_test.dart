import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Integration tests on the Polynomial page', () {
    testWidgets(
      'Testing linear equations',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the polynomial page
        await tester.tap(find.byKey(const Key('PolynomialLogo-Container')));
        await tester.pumpAndSettle();

        // Inserting data
        final finder = find.byType(TextFormField);
        await tester.enterText(finder.first, '1');
        await tester.enterText(finder.last, '2');

        // Solving
        final solveBtn = find.byKey(const Key('Polynomial-button-solve'));

        await tester.ensureVisible(solveBtn);
        await tester.pumpAndSettle();

        await tester.tap(solveBtn);
        await tester.pumpAndSettle();

        // Expecting solutions: 1 card for the root and 1 for the discriminant
        expect(find.byType(ComplexResultCard), findsNWidgets(1 + 1));

        // Cleaning
        final cleanBtn = find.byKey(const Key('Polynomial-button-clean'));

        await tester.ensureVisible(cleanBtn);
        await tester.pumpAndSettle();

        await tester.tap(cleanBtn);
        await tester.pumpAndSettle();

        expect(find.byType(ComplexResultCard), findsNothing);
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

        // Inserting data
        final finder = find.byType(TextFormField);
        await tester.enterText(finder.at(0), '1');
        await tester.enterText(finder.at(1), '2');
        await tester.enterText(finder.at(2), '3');

        // Solving
        final solveBtn = find.byKey(const Key('Polynomial-button-solve'));

        await tester.ensureVisible(solveBtn);
        await tester.pumpAndSettle();

        await tester.tap(solveBtn);
        await tester.pumpAndSettle();

        // Expecting solutions: 2 cards for the root and 1 for the discriminant
        expect(find.byType(ComplexResultCard), findsNWidgets(2 + 1));

        // Cleaning
        final cleanBtn = find.byKey(const Key('Polynomial-button-clean'));

        await tester.ensureVisible(cleanBtn);
        await tester.pumpAndSettle();

        await tester.tap(cleanBtn);
        await tester.pumpAndSettle();

        expect(find.byType(ComplexResultCard), findsNothing);
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

        // Inserting data
        final finder = find.byType(TextFormField);
        await tester.enterText(finder.at(0), '1');
        await tester.enterText(finder.at(1), '2');
        await tester.enterText(finder.at(2), '3');
        await tester.enterText(finder.at(3), '4');

        // Solving
        final solveBtn = find.byKey(const Key('Polynomial-button-solve'));

        await tester.ensureVisible(solveBtn);
        await tester.pumpAndSettle();

        await tester.tap(solveBtn);
        await tester.pumpAndSettle();

        // Expecting solutions: 2 cards for the root and 1 for the discriminant
        expect(find.byType(ComplexResultCard), findsNWidgets(3 + 1));

        // Cleaning
        final cleanBtn = find.byKey(const Key('Polynomial-button-clean'));

        await tester.ensureVisible(cleanBtn);
        await tester.pumpAndSettle();

        await tester.tap(cleanBtn);
        await tester.pumpAndSettle();

        expect(find.byType(ComplexResultCard), findsNothing);
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

        // Inserting data
        final finder = find.byType(TextFormField);
        await tester.enterText(finder.at(0), '1');
        await tester.enterText(finder.at(1), '2');
        await tester.enterText(finder.at(2), '3');
        await tester.enterText(finder.at(3), '4');
        await tester.enterText(finder.at(4), '5');

        // Solving
        final solveBtn = find.byKey(const Key('Polynomial-button-solve'));

        await tester.ensureVisible(solveBtn);
        await tester.pumpAndSettle();

        await tester.tap(solveBtn);
        await tester.pumpAndSettle();

        // Expecting solutions: 2 cards for the root and 1 for the discriminant
        expect(find.byType(ComplexResultCard), findsNWidgets(4 + 1));

        // Cleaning
        final cleanBtn = find.byKey(const Key('Polynomial-button-clean'));

        await tester.ensureVisible(cleanBtn);
        await tester.pumpAndSettle();

        await tester.tap(cleanBtn);
        await tester.pumpAndSettle();

        expect(find.byType(ComplexResultCard), findsNothing);
      },
    );
  });
}

import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/models/inherited_navigation/inherited_navigation.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  var needsOpenPage = true;

  Future<void> testPolynomial(WidgetTester tester, int degree) async {
    if (needsOpenPage) {
      // Opening the nonlinear page
      await tester.tap(find.byKey(const Key('PolynomialLogo-Container')));
      await tester.pumpAndSettle();

      needsOpenPage = false;
    }

    if (degree != 1) {
      tester
          .widget<InheritedNavigation>(find.byType(InheritedNavigation))
          .navigationIndex
          .value = degree - 1;

      await tester.pumpAndSettle();
    }

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

    // Widgets: `degree` cards for the root and 1 for the discriminant
    await tester.ensureVisible(find.byType(ComplexResultCard).last);
    await tester.pumpAndSettle();

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
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testPolynomial(tester, 1);
      },
    );

    testWidgets(
      'Testing quadratic equations',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testPolynomial(tester, 2);
      },
    );

    testWidgets(
      'Testing cubic equations',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testPolynomial(tester, 3);
      },
    );

    testWidgets(
      'Testing quartic equations',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testPolynomial(tester, 4);
      },
    );
  });
}

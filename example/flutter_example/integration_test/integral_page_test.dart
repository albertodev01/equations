import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> _testIntegral(
    WidgetTester tester, [
    String type = '',
  ]) async {
    // Entering values
    await tester.enterText(
      find.byKey(const Key('EquationInput-function')),
      'x-3',
    );
    await tester.enterText(
      find.byKey(const Key('IntegralInput-lower-bound')),
      '1',
    );
    await tester.enterText(
      find.byKey(const Key('IntegralInput-upper-bound')),
      '2',
    );

    if (type.isNotEmpty) {
      await tester.ensureVisible(find.text('Simpson'));
      await tester.pumpAndSettle();

      // Changing the dropdown value
      await tester.tap(find.text('Simpson'));
      await tester.pumpAndSettle();

      await tester.tap(find.text(type).last);
      await tester.pumpAndSettle();
    }

    // Solving
    final solveBtn = find.byKey(const Key('Integral-button-solve'));

    await tester.ensureVisible(solveBtn);
    await tester.pumpAndSettle();

    await tester.tap(solveBtn);
    await tester.pumpAndSettle();

    // Expecting one card with the integral evaluation
    expect(find.byType(RealResultCard), findsOneWidget);

    // Cleaning
    final cleanBtn = find.byKey(const Key('Integral-button-clean'));

    await tester.ensureVisible(cleanBtn);
    await tester.pumpAndSettle();

    await tester.tap(cleanBtn);
    await tester.pumpAndSettle();

    expect(find.byType(RealResultCard), findsNothing);
  }

  group('Integration tests on the Integral page', () {
    testWidgets(
      'Testing the simpson method',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the integral page
        await tester.tap(find.byKey(const Key('IntegralsLogo-Container')));
        await tester.pumpAndSettle();

        await _testIntegral(tester);
      },
    );

    testWidgets(
      'Testing the trapezoid method',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the integral page
        await tester.tap(find.byKey(const Key('IntegralsLogo-Container')));
        await tester.pumpAndSettle();

        await _testIntegral(tester, 'Trapezoid');
      },
    );

    testWidgets(
      'Testing the midpoint method',
      (tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Opening the integral page
        await tester.tap(find.byKey(const Key('IntegralsLogo-Container')));
        await tester.pumpAndSettle();

        await _testIntegral(tester, 'Midpoint');
      },
    );
  });
}

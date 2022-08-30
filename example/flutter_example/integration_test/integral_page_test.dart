import 'package:equations_solver/main.dart' as app;
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils.dart';

void main() {
  var needsOpenPage = true;

  Future<void> testIntegral(
    WidgetTester tester, [
    String type = '',
  ]) async {
    if (needsOpenPage) {
      // Opening the integral page
      await tester.tap(find.byKey(const Key('IntegralsLogo-Container')));
      await tester.pumpAndSettle();

      needsOpenPage = false;
    }

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
    await tester.ensureVisible(find.byType(RealResultCard));
    await tester.pumpAndSettle();

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
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testIntegral(tester);
      },
    );

    testWidgets(
      'Testing the trapezoid method',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testIntegral(tester, 'Trapezoid');
      },
    );

    testWidgets(
      'Testing the midpoint method',
      (tester) async {
        await configureIfDesktop(tester);

        app.main();
        await tester.pumpAndSettle();
        await testIntegral(tester, 'Midpoint');
      },
    );
  });
}

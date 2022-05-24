import 'package:equations_solver/routes/integral_page/integral_results.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'integral_mock.dart';

void main() {
  group("Testing the 'IntegralResultsWidget' widget", () {
    testWidgets(
      'Making sure that, by default, the "No results" text appears',
      (tester) async {
        await tester.pumpWidget(
          const MockIntegralWidget(
            child: IntegralResultsWidget(),
          ),
        );

        // No snackbar by default
        expect(find.byType(NoResults), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that a result card appears when there is a solution to show',
      (tester) async {
        await tester.pumpWidget(
          MockIntegralWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, 'x+2');
        await tester.enterText(lowerInput, '1');
        await tester.enterText(upperInput, '3');

        // Solving the equation
        await tester.tap(find.byKey(const Key('Integral-button-solve')));
        await tester.pumpAndSettle();

        // No snackbar by default
        expect(find.byType(NoResults), findsNothing);
        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that a snackbar appears in case of computation errors',
      (tester) async {
        await tester.pumpWidget(
          MockIntegralWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, '');
        await tester.enterText(lowerInput, '1');
        await tester.enterText(upperInput, '3');

        // Solving the equation
        await tester.tap(find.byKey(const Key('Integral-button-solve')));
        await tester.pumpAndSettle();

        // No snackbar by default
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );
  });

  group('Golden tests - IntegralResultsWidget', () {
    testWidgets('IntegralResultsWidget', (tester) async {
      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      final equationInput = find.byKey(const Key('EquationInput-function'));
      final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
      final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

      // Filling the forms
      await tester.enterText(equationInput, 'x+2');
      await tester.enterText(lowerInput, '1');
      await tester.enterText(upperInput, '3');

      // Solving the equation
      await tester.tap(find.byKey(const Key('Integral-button-solve')));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(IntegralResultsWidget).last);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(IntegralResultsWidget),
        matchesGoldenFile('goldens/integral_results.png'),
      );
    });
  });
}

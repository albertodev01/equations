import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'nonlinear_mock.dart';

void main() {
  group("Testing the 'NonlinearResults' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        mockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
          child: const NonlinearResults(),
        ),
      );

      expect(find.byType(NonlinearResults), findsOneWidget);
      expect(find.byType(SectionTitle), findsOneWidget);
    });

    testWidgets(
      'Making sure that when an error occurred while solving the equation, '
      'a Snackbar appears.',
      (tester) async {
        await tester.pumpWidget(
          mockNonlinearWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        // Refreshing to make the snackbar appear
        await tester.tap(find.byKey(const Key('Nonlinear-button-solve')));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that, when there are no solutions, a text widget '
      "appears saying that there's nothing to display",
      (tester) async {
        await tester.pumpWidget(
          mockNonlinearWidget(
            child: const NonlinearResults(),
          ),
        );

        expect(find.byType(RealResultCard), findsNothing);
        expect(find.text('No solutions to display.'), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that, when there are solutions, solution widgets '
      'appear on the screen',
      (tester) async {
        await tester.pumpWidget(
          mockNonlinearWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        final equationInput = find.byKey(const Key('EquationInput-function'));
        final paramInput = find.byKey(const Key('EquationInput-first-param'));
        final solveButton = find.byKey(const Key('Nonlinear-button-solve'));

        // Filling the forms
        await tester.enterText(equationInput, 'x-3');
        await tester.enterText(paramInput, '3');

        // Solving the equation
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        expect(find.text('No solutions to display.'), findsNothing);
        expect(find.byType(RealResultCard), findsNWidgets(3));
      },
    );
  });

  group('Golden tests - NonlinearResults', () {
    testWidgets('NonlinearResults', (tester) async {
      await tester.pumpWidget(
        mockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      final equationInput = find.byKey(const Key('EquationInput-function'));
      final paramInput = find.byKey(const Key('EquationInput-first-param'));
      final solveButton = find.byKey(const Key('Nonlinear-button-solve'));

      // Filling the forms
      await tester.enterText(equationInput, 'x-3');
      await tester.enterText(paramInput, '3');

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.byType(NonlinearResults).last);
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(NonlinearResults),
        matchesGoldenFile('goldens/nonlinear_result.png'),
      );
    });
  });
}

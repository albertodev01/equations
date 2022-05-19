import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_results.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/nonlinear_plot_widget.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'nonlinear_mock.dart';

void main() {
  group("Testing the 'NonlinearBody' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        mockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(NonlinearDataInput), findsOneWidget);
      expect(find.byType(NonlinearResults), findsOneWidget);
    });

    testWidgets(
      'Making sure that the widget is responsive - small screens '
      'test',
      (tester) async {
        await tester.pumpWidget(
          mockNonlinearWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        expect(
          find.byKey(const Key('SingleChildScrollView-mobile-responsive')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('SingleChildScrollView-desktop-responsive')),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that the widget is responsive - large screens '
      'test',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(2000, 2000));

        await tester.pumpWidget(
          mockNonlinearWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        expect(
          find.byKey(const Key('SingleChildScrollView-mobile-responsive')),
          findsNothing,
        );
        expect(
          find.byKey(const Key('SingleChildScrollView-desktop-responsive')),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Making sure that the chars does NOT appear on smaller screens',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(250, 2000));

        await tester.pumpWidget(
          mockNonlinearWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        expect(
          find.byKey(const Key('SingleChildScrollView-mobile-responsive')),
          findsOneWidget,
        );
        expect(
          find.byKey(const Key('SingleChildScrollView-desktop-responsive')),
          findsNothing,
        );
        expect(
          find.byType(NonlinearPlotWidget),
          findsNothing,
        );
      },
    );

    testWidgets(
      'Making sure that single point equations works',
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

        // Making sure that there are no results
        expect(find.byType(NoResults), findsOneWidget);

        // Solving the equation
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        // Solutions on the UI!
        expect(find.byType(NoResults), findsNothing);
        expect(find.byType(RealResultCard), findsNWidgets(3));
      },
    );

    testWidgets('Making sure that bracketing equations works', (tester) async {
      await tester.pumpWidget(
        mockNonlinearWidget(
          nonlinearType: NonlinearType.bracketing,
          dropdownValue: 'Bisection',
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      final equationInput = find.byKey(const Key('EquationInput-function'));
      final paramInput1 = find.byKey(const Key('EquationInput-first-param'));
      final paramInput2 = find.byKey(const Key('EquationInput-second-param'));
      final solveButton = find.byKey(const Key('Nonlinear-button-solve'));

      // Filling the forms
      await tester.enterText(equationInput, 'x-3.17263');
      await tester.enterText(paramInput1, '2');
      await tester.enterText(paramInput2, '4.3');

      // Making sure that there are no results
      expect(find.byType(NoResults), findsOneWidget);

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      // Solutions on the UI!
      expect(find.byType(NoResults), findsNothing);
      expect(find.byType(RealResultCard), findsNWidgets(3));
    });
  });
}

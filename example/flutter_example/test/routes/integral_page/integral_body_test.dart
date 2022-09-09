import 'package:equations_solver/routes/integral_page/integral_data_input.dart';
import 'package:equations_solver/routes/integral_page/integral_results.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:equations_solver/routes/utils/input_kind_dialog_button.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'integral_mock.dart';

void main() {
  group("Testing the 'IntegralBody' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
        ),
      );

      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(IntegralDataInput), findsOneWidget);
      expect(find.byType(IntegralResultsWidget), findsOneWidget);
      expect(find.byType(InputKindDialogButton), findsOneWidget);
    });

    testWidgets(
      'Making sure that the widget is responsive - small screens test',
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
      'Making sure that the widget is responsive - large screens test',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(2000, 2000));

        await tester.pumpWidget(
          MockIntegralWidget(
            textControllers: [
              TextEditingController(),
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

    testWidgets('Making sure that simpson solver works', (tester) async {
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

      // Initial state
      expect(find.byType(NoResults), findsOneWidget);

      // Evaluating the integral
      await tester.tap(find.byKey(const Key('Integral-button-solve')));
      await tester.pumpAndSettle();

      // Results
      expect(find.byType(NoResults), findsNothing);
      expect(find.byType(RealResultCard), findsOneWidget);
    });

    testWidgets('Making sure that midpoint solver works', (tester) async {
      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          dropdownValue: IntegralDropdownItems.midpoint.name,
        ),
      );

      final equationInput = find.byKey(const Key('EquationInput-function'));
      final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
      final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

      // Filling the forms
      await tester.enterText(equationInput, 'x+2');
      await tester.enterText(lowerInput, '1');
      await tester.enterText(upperInput, '3');

      // Initial state
      expect(find.byType(NoResults), findsOneWidget);

      // Evaluating the integral
      await tester.tap(find.byKey(const Key('Integral-button-solve')));
      await tester.pumpAndSettle();

      // Results
      expect(find.byType(NoResults), findsNothing);
      expect(find.byType(RealResultCard), findsOneWidget);
    });

    testWidgets('Making sure that trapezoid solver works', (tester) async {
      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          dropdownValue: IntegralDropdownItems.midpoint.name,
        ),
      );

      final equationInput = find.byKey(const Key('EquationInput-function'));
      final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
      final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

      // Filling the forms
      await tester.enterText(equationInput, 'x+2');
      await tester.enterText(lowerInput, '1');
      await tester.enterText(upperInput, '3');

      // Initial state
      expect(find.byType(NoResults), findsOneWidget);

      // Evaluating the integral
      await tester.tap(find.byKey(const Key('Integral-button-solve')));
      await tester.pumpAndSettle();

      // Results
      expect(find.byType(NoResults), findsNothing);
      expect(find.byType(RealResultCard), findsOneWidget);
    });
  });
}

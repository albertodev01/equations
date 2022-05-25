import 'package:equations_solver/routes/integral_page/integral_data_input.dart';
import 'package:equations_solver/routes/integral_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';
import 'integral_mock.dart';

void main() {
  group("Testing the 'IntegralDataInput' widget", () {
    testWidgets(
      'Making sure that when trying to evaluate an integral, if at least one '
      'of the inputs is wrong, a snackbar appears',
      (tester) async {
        await tester.pumpWidget(
          MockIntegralWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
            child: const IntegralDataInput(),
          ),
        );

        // No snackbar by default
        expect(find.byType(SnackBar), findsNothing);

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Integral-button-solve'));
        await tester.tap(finder);

        // The snackbar appeared
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that fields can be cleared',
      (tester) async {
        await tester.pumpWidget(
          MockIntegralWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
            child: const IntegralDataInput(),
          ),
        );

        // Entering values
        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, 'x^2-1');
        await tester.enterText(lowerInput, '17');
        await tester.enterText(upperInput, '18');

        // Making sure that fields are filled
        expect(find.text('x^2-1'), findsOneWidget);
        expect(find.text('17'), findsOneWidget);
        expect(find.text('18'), findsOneWidget);

        // Tap the 'Clear' button
        final finder = find.byKey(const Key('Integral-button-clean'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        // Making sure that fields have been cleared
        expect(find.text('x^2-1'), findsNothing);
        expect(find.text('17'), findsNothing);
        expect(find.text('18'), findsNothing);

        tester
            .widgetList<TextFormField>(find.byType(TextFormField))
            .forEach((t) {
          expect(t.controller!.text.length, isZero);
        });
      },
    );

    testWidgets(
      'Making sure that integrals can be evaluated using the Simpson method',
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

        expect(find.byType(RealResultCard), findsNothing);

        // Entering values
        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, 'x^2-1');
        await tester.enterText(lowerInput, '2');
        await tester.enterText(upperInput, '5');

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Integral-button-solve'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that integrals can be evaluated using the Midpoint rule',
      (tester) async {
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

        expect(find.byType(RealResultCard), findsNothing);

        // Entering values
        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, 'x^2-1');
        await tester.enterText(lowerInput, '2');
        await tester.enterText(upperInput, '5');

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Integral-button-solve'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that integrals can be evaluated using the Trapezoid rule',
      (tester) async {
        await tester.pumpWidget(
          MockIntegralWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
            dropdownValue: IntegralDropdownItems.trapezoid.name,
          ),
        );

        expect(find.byType(RealResultCard), findsNothing);

        // Entering values
        final equationInput = find.byKey(const Key('EquationInput-function'));
        final lowerInput = find.byKey(const Key('IntegralInput-lower-bound'));
        final upperInput = find.byKey(const Key('IntegralInput-upper-bound'));

        // Filling the forms
        await tester.enterText(equationInput, 'x^2-1');
        await tester.enterText(lowerInput, '2');
        await tester.enterText(upperInput, '5');

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Integral-button-solve'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.byType(RealResultCard), findsOneWidget);
      },
    );
  });

  group('Golden tests - IntegralDataInput', () {
    testWidgets('IntegralDataInput - simpson', (tester) async {
      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          dropdownValue: IntegralDropdownItems.simpson.name,
          child: const IntegralDataInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/integral_data_input_simpson.png'),
      );
    });

    testWidgets('IntegralDataInput - midpoint', (tester) async {
      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          dropdownValue: IntegralDropdownItems.midpoint.name,
          child: const IntegralDataInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/integral_data_input_midpoint.png'),
      );
    });

    testWidgets('IntegralDataInput - trapezoid', (tester) async {
      await tester.pumpWidget(
        MockIntegralWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          dropdownValue: IntegralDropdownItems.trapezoid.name,
          child: const IntegralDataInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/integral_data_input_trapezoid.png'),
      );
    });
  });
}

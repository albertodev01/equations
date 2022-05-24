import 'package:equations_solver/routes/nonlinear_page/model/inherited_nonlinear.dart';
import 'package:equations_solver/routes/nonlinear_page/model/nonlinear_state.dart';
import 'package:equations_solver/routes/nonlinear_page/nonlinear_data_input.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/dropdown_selection.dart';
import 'package:equations_solver/routes/nonlinear_page/utils/precision_slider.dart';
import 'package:equations_solver/routes/utils/equation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';
import 'nonlinear_mock.dart';

void main() {
  group("Testing the 'NonlinearDataInput' widget", () {
    testWidgets(
      "Making sure that with a 'singlePoint' configuration type only "
      'has 2 input fields appear on the screen',
      (tester) async {
        await tester.pumpWidget(
          MockNonlinearWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
            dropdownValue: NonlinearDropdownItems.newton.name,
            child: const NonlinearDataInput(),
          ),
        );

        expect(find.byType(NonlinearDataInput), findsOneWidget);
        expect(find.byType(EquationInput), findsNWidgets(2));
        expect(find.byType(NonlinearDropdownSelection), findsOneWidget);
        expect(find.byType(PrecisionSlider), findsOneWidget);

        // To make sure that fields validation actually happens
        expect(find.byType(Form), findsOneWidget);
      },
    );

    testWidgets(
      "Making sure that with a 'bracketing' configuration type only "
      'has 3 input fields appear on the screen',
      (tester) async {
        await tester.pumpWidget(
          MockNonlinearWidget(
            nonlinearType: NonlinearType.bracketing,
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
            dropdownValue: NonlinearDropdownItems.secant.name,
            child: const NonlinearDataInput(),
          ),
        );

        expect(find.byType(NonlinearDataInput), findsOneWidget);
        expect(find.byType(EquationInput), findsNWidgets(3));
        expect(find.byType(NonlinearDropdownSelection), findsOneWidget);
        expect(find.byType(PrecisionSlider), findsOneWidget);

        // To make sure that fields validation actually happens
        expect(find.byType(Form), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that when trying to solve an equation, if at '
      'least one of the inputs is wrong, a snackbar appears',
      (tester) async {
        await tester.pumpWidget(
          MockNonlinearWidget(
            nonlinearType: NonlinearType.bracketing,
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
            dropdownValue: NonlinearDropdownItems.secant.name,
            child: const NonlinearDataInput(),
          ),
        );

        // No snackbar by default
        expect(find.byType(SnackBar), findsNothing);

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Nonlinear-button-solve'));
        await tester.tap(finder);

        // The snackbar appeared
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that single point equations can be solved',
      (tester) async {
        await tester.pumpWidget(
          MockNonlinearWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
            child: const NonlinearDataInput(),
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

        final inheritedWidget = tester.widget<InheritedNonlinear>(
          find.byType(InheritedNonlinear),
        );
        expect(inheritedWidget.nonlinearState.state.nonlinear, isNotNull);
      },
    );

    testWidgets(
      'Making sure that bracketing equations can be solved',
      (tester) async {
        await tester.pumpWidget(
          MockNonlinearWidget(
            nonlinearType: NonlinearType.bracketing,
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
            dropdownValue: NonlinearDropdownItems.secant.name,
            child: const NonlinearDataInput(),
          ),
        );

        final equationInput = find.byKey(const Key('EquationInput-function'));
        final paramInput1 = find.byKey(const Key('EquationInput-first-param'));
        final paramInput2 = find.byKey(const Key('EquationInput-second-param'));
        final solveButton = find.byKey(const Key('Nonlinear-button-solve'));

        // Filling the forms
        await tester.enterText(equationInput, 'x-3');
        await tester.enterText(paramInput1, '1');
        await tester.enterText(paramInput2, '4');

        // Solving the equation
        await tester.tap(solveButton);
        await tester.pumpAndSettle();

        final inheritedWidget = tester.widget<InheritedNonlinear>(
          find.byType(InheritedNonlinear),
        );
        expect(inheritedWidget.nonlinearState.state.nonlinear, isNotNull);
      },
    );

    testWidgets('Making sure that textfields can be cleared', (tester) async {
      late FocusScopeNode focusScope;

      await tester.pumpWidget(
        MockWrapper(
          child: Builder(
            builder: (context) {
              focusScope = FocusScope.of(context);

              return MockNonlinearWidget(
                textControllers: [
                  TextEditingController(),
                  TextEditingController(),
                ],
                child: const NonlinearDataInput(),
              );
            },
          ),
        ),
      );

      final equationInput = find.byKey(const Key('EquationInput-function'));
      final paramInput = find.byKey(const Key('EquationInput-first-param'));
      final cleanButton = find.byKey(const Key('Nonlinear-button-clean'));

      // Filling the forms
      await tester.enterText(equationInput, 'x-3');
      await tester.enterText(paramInput, '3');

      // Making sure that fields are filled
      expect(find.text('x-3'), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
      expect(focusScope.hasFocus, isTrue);

      // Tap the 'Clear' button
      await tester.tap(cleanButton);
      await tester.pumpAndSettle();

      final inheritedWidget = tester.widget<InheritedNonlinear>(
        find.byType(InheritedNonlinear),
      );
      expect(inheritedWidget.nonlinearState.state.nonlinear, isNull);

      tester.widgetList<TextFormField>(find.byType(TextFormField)).forEach((t) {
        expect(t.controller!.text.length, isZero);
      });
    });
  });

  group('Golden tests - NonlinearDataInput', () {
    testWidgets('NonlinearDataInput - single point', (tester) async {
      await tester.pumpWidget(
        MockNonlinearWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
          child: const NonlinearDataInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/nonlinear_data_input_single_point.png'),
      );
    });

    testWidgets('NonlinearDataInput - bracketing', (tester) async {
      await tester.pumpWidget(
        MockNonlinearWidget(
          nonlinearType: NonlinearType.bracketing,
          dropdownValue: NonlinearDropdownItems.bisection.name,
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          child: const NonlinearDataInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/nonlinear_data_input_bracketing.png'),
      );
    });
  });
}

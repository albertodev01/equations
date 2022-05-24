import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_data_input.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';
import 'polynomial_mock.dart';

void main() {
  group("Testing the 'PolynomialDataInput' widget", () {
    testWidgets(
      "Making sure that with a 'linear' configuration type only "
      '2 input fields appear on the screen',
      (tester) async {
        await tester.pumpWidget(
          MockPolynomialWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        expect(find.byType(PolynomialDataInput), findsOneWidget);
        expect(find.byType(PolynomialInputField), findsNWidgets(2));

        // To make sure that fields validation actually happens
        expect(find.byType(Form), findsOneWidget);
      },
    );

    testWidgets(
      "Making sure that with a 'quadratic' configuration type only "
      '3 input fields appear on the screen',
      (tester) async {
        await tester.pumpWidget(
          MockPolynomialWidget(
            polynomialType: PolynomialType.quadratic,
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        expect(find.byType(PolynomialDataInput), findsOneWidget);
        expect(find.byType(PolynomialInputField), findsNWidgets(3));

        // To make sure that fields validation actually happens
        expect(find.byType(Form), findsOneWidget);
      },
    );

    testWidgets(
      "Making sure that with a 'cubic' configuration type only "
      '4 input fields appear on the screen',
      (tester) async {
        await tester.pumpWidget(
          MockPolynomialWidget(
            polynomialType: PolynomialType.cubic,
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        expect(find.byType(PolynomialDataInput), findsOneWidget);
        expect(find.byType(PolynomialInputField), findsNWidgets(4));

        // To make sure that fields validation actually happens
        expect(find.byType(Form), findsOneWidget);
      },
    );

    testWidgets(
      "Making sure that with a 'quartic' configuration type only "
      '5 input fields appear on the screen',
      (tester) async {
        await tester.pumpWidget(
          MockPolynomialWidget(
            polynomialType: PolynomialType.quartic,
            textControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        expect(find.byType(PolynomialDataInput), findsOneWidget);
        expect(find.byType(PolynomialInputField), findsNWidgets(5));

        // To make sure that fields validation actually happens
        expect(find.byType(Form), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that when trying to solve an equation, if at '
      'least one of the inputs is wrong, a snackbar appears',
      (tester) async {
        await tester.pumpWidget(
          MockPolynomialWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        // No snackbar by default
        expect(find.byType(SnackBar), findsNothing);

        // Tap the 'Solve' button
        final finder = find.byKey(const Key('Polynomial-button-solve'));
        await tester.tap(finder);

        // The snackbar appeared
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);

        final inheritedWidget = tester.widget<InheritedPolynomial>(
          find.byType(InheritedPolynomial),
        );
        expect(inheritedWidget.polynomialState.state.algebraic, isNull);
      },
    );

    testWidgets('Making sure that equations can be solved', (tester) async {
      late FocusScopeNode focusScope;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              focusScope = FocusScope.of(context);

              return MockPolynomialWidget(
                polynomialType: PolynomialType.quadratic,
                textControllers: [
                  TextEditingController(),
                  TextEditingController(),
                  TextEditingController(),
                ],
              );
            },
          ),
        ),
      );

      final coeffA = find.byKey(
        const Key('PolynomialInputField-coefficient-0'),
      );
      final coeffB = find.byKey(
        const Key('PolynomialInputField-coefficient-1'),
      );
      final coeffC = find.byKey(
        const Key('PolynomialInputField-coefficient-2'),
      );
      final solveButton = find.byKey(
        const Key('Polynomial-button-solve'),
      );
      final cleanButton = find.byKey(
        const Key('Polynomial-button-clean'),
      );

      // Filling the forms
      await tester.enterText(coeffA, '-5');
      await tester.enterText(coeffB, '1/2');
      await tester.enterText(coeffC, '3');

      final inheritedWidget = tester.widget<InheritedPolynomial>(
        find.byType(InheritedPolynomial),
      );
      expect(inheritedWidget.polynomialState.state.algebraic, isNull);
      expect(focusScope.hasFocus, isTrue);

      // Solving the equation
      await tester.tap(solveButton);
      await tester.pumpAndSettle();

      // Cleaning the UI
      await tester.tap(cleanButton);
      await tester.pumpAndSettle();

      tester.widgetList<TextFormField>(find.byType(TextFormField)).forEach((t) {
        expect(t.controller!.text.length, isZero);
      });
    });
  });

  group('Golden tests - PolynomialDataInput', () {
    testWidgets('PolynomialDataInput - linear', (tester) async {
      await tester.pumpWidget(
        MockPolynomialWidget(
          textControllers: [
            TextEditingController(),
            TextEditingController(),
          ],
          child: const PolynomialDataInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/polynomial_data_input_linear.png'),
      );
    });

    testWidgets('PolynomialDataInput - quadratic', (tester) async {
      await tester.pumpWidget(
        MockPolynomialWidget(
          polynomialType: PolynomialType.quadratic,
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          child: const PolynomialDataInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/polynomial_data_input_quadratic.png'),
      );
    });

    testWidgets('PolynomialDataInput - cubic', (tester) async {
      await tester.pumpWidget(
        MockPolynomialWidget(
          polynomialType: PolynomialType.cubic,
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          child: const PolynomialDataInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/polynomial_data_input_cubic.png'),
      );
    });

    testWidgets('PolynomialDataInput - quartic', (tester) async {
      await tester.pumpWidget(
        MockPolynomialWidget(
          polynomialType: PolynomialType.quartic,
          textControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          child: const PolynomialDataInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/polynomial_data_input_quartic.png'),
      );
    });
  });
}

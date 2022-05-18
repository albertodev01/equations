import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_results.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/section_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../mock_wrapper.dart';
import 'polynomial_mock.dart';

void main() {
  group("Testing the 'PolynomialResults' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedPolynomial(
            polynomialState: PolynomialState(PolynomialType.linear),
            child: const PolynomialResults(),
          ),
        ),
      );

      expect(find.byType(PolynomialResults), findsOneWidget);
      expect(find.byType(SectionTitle), findsNWidgets(2));
      expect(find.byType(PolynomialDiscriminant), findsOneWidget);
    });

    testWidgets(
      'Making sure that, when there are no solutions, a text widget '
      "appears saying that there's nothing to display",
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: InheritedPolynomial(
              polynomialState: PolynomialState(PolynomialType.linear),
              child: const PolynomialResults(),
            ),
          ),
        );

        expect(find.byType(ComplexResultCard), findsNothing);
        expect(find.text('No solutions to display.'), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that, when there are solutions, solution widgets '
      'appear on the screen',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: InheritedPolynomial(
              polynomialState: PolynomialState(PolynomialType.linear)
                ..solvePolynomial(const ['1', '2']),
              child: const PolynomialResults(),
            ),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('No solutions to display.'), findsNothing);
        expect(find.byType(ComplexResultCard), findsNWidgets(2));
        expect(find.byKey(const Key('PolynomialDiscriminant')), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that when an error occurred while solving the '
      'equation, a Snackbar appears.',
      (tester) async {
        await tester.pumpWidget(
          mockPolynomialWidget(
            textControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
          ),
        );

        await tester.tap(find.byKey(const Key('Polynomial-button-solve')));
        await tester.pumpAndSettle();

        // Refreshing to make the snackbar appear
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
      },
    );
  });

  group('Golden tests - PolynomialResults', () {
    testWidgets('PolynomialResults', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: InheritedPolynomial(
            polynomialState: PolynomialState(PolynomialType.linear)
              ..solvePolynomial(const ['1', '2']),
            child: const PolynomialResults(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/no_discriminant.png'),
      );
    });
  });
}

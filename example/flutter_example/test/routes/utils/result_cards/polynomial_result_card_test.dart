import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/result_cards/polynomial_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PolynomialResultCard' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: PolynomialResultCard(
            algebraic: Algebraic.fromReal(
              [1, 2, 3],
            ),
          ),
        ),
      );

      expect(find.byType(PolynomialResultCard), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testGoldens('PolynomialResultCard - without fractions', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Constant',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1]),
            withFraction: false,
          ),
        )
        ..addScenario(
          'Linear',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2.5]),
            withFraction: false,
          ),
        )
        ..addScenario(
          'Quadratic',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2, 3]),
            withFraction: false,
          ),
        )
        ..addScenario(
          'Cubic',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2, 3 / 4, 4]),
            withFraction: false,
          ),
        )
        ..addScenario(
          'Quartic',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2, 3, 4, 5]),
            withFraction: false,
          ),
        )
        ..addScenario(
          'Quintic',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2, 3, 4, 5, 6]),
            withFraction: false,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(550, 2000),
      );
      await screenMatchesGolden(tester, 'polynomial_result_card_no_fractions');
    });

    testGoldens('PolynomialResultCard - with fractions', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Constant',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1]),
          ),
        )
        ..addScenario(
          'Linear',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2 / 5]),
          ),
        )
        ..addScenario(
          'Quadratic',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2, 3]),
          ),
        )
        ..addScenario(
          'Cubic',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2, 3, 4]),
          ),
        )
        ..addScenario(
          'Quartic',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2, 3, 4, 5]),
          ),
        )
        ..addScenario(
          'Quintic',
          PolynomialResultCard(
            algebraic: Algebraic.fromReal([1, 2, 3, 4, 5.6, 6]),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(550, 2350),
      );
      await screenMatchesGolden(tester, 'polynomial_result_card');
    });
  });
}

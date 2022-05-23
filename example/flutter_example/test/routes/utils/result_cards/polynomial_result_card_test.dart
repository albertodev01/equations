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
      expect(find.byType(ListTile), findsWidgets);
    });
  });

  group('Golden tests - PolynomialResultCard', () {
    testWidgets(
      'PolynomialResultCard - no fraction - constant',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1]),
              withFraction: false,
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_nofraction_constant.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - no fraction - linear',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2.5]),
              withFraction: false,
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_nofraction_linear.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - no fraction - quadratic',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2, 3]),
              withFraction: false,
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_nofraction_quadratic.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - no fraction - cubic',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2, 3 / 4, 4]),
              withFraction: false,
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_nofraction_cubic.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - no fraction - quartic',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2, 3, 4, 5]),
              withFraction: false,
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_nofraction_quartic.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - no fraction - quintic',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2, 3, 4, 5, 6]),
              withFraction: false,
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_nofraction_quintic.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - fraction - constant',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1]),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_fraction_constant.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - fraction - linear',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2.5]),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_fraction_linear.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - fraction - quadratic',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2, 3]),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_fraction_quadratic.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - fraction - cubic',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2, 3 / 4, 4]),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_fraction_cubic.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - fraction - quartic',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2, 3, 4, 5]),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_fraction_quartic.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - fraction - quintic',
      (tester) async {
        await tester.pumpWidget(
          MockWrapper(
            child: PolynomialResultCard(
              algebraic: Algebraic.fromReal([1, 2, 3, 4, 5, 6]),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_fraction_quintic.png',
          ),
        );
      },
    );
  });
}

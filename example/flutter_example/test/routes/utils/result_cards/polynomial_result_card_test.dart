import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/collapsible.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
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
      expect(find.byType(Collapsible), findsWidgets);
      expect(find.byType(ComplexResultCard), findsNWidgets(3));
    });
  });

  group('Golden tests - PolynomialResultCard', () {
    testWidgets(
      'PolynomialResultCard - constant',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(300, 150));

        await tester.pumpWidget(
          MockWrapper(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: PolynomialResultCard(
                algebraic: Algebraic.fromReal([1]),
              ),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_constant.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - linear',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(300, 250));

        await tester.pumpWidget(
          MockWrapper(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: PolynomialResultCard(
                algebraic: Algebraic.fromReal([1, 2.5]),
              ),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_linear.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - quadratic',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(300, 350));

        await tester.pumpWidget(
          MockWrapper(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: PolynomialResultCard(
                algebraic: Algebraic.fromReal([1, 2, 3]),
              ),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_quadratic.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - cubic',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(300, 450));

        await tester.pumpWidget(
          MockWrapper(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: PolynomialResultCard(
                algebraic: Algebraic.fromReal([1, 2, 3 / 4, 4]),
              ),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_cubic.png',
          ),
        );
      },
    );

    testWidgets(
      'PolynomialResultCard - quartic',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(300, 550));

        await tester.pumpWidget(
          MockWrapper(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: PolynomialResultCard(
                algebraic: Algebraic.fromReal([1, 2, 3, 4, 5]),
              ),
            ),
          ),
        );
        await expectLater(
          find.byType(PolynomialResultCard),
          matchesGoldenFile(
            'goldens/polynomial_result_card_quartic.png',
          ),
        );
      },
    );
  });
}

import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'ComplexResultCard' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ComplexResultCard(
            value: Complex(5, -3),
          ),
        ),
      );

      expect(find.byType(ComplexResultCard), findsOneWidget);
      expect(find.text('5.00000000 - 3.00000000i'), findsOneWidget);
      expect(
        find.byKey(const Key('Fraction-ComplexResultCard')),
        findsOneWidget,
      );
    });
  });

  group('Golden tests - ComplexResultCard', () {
    testWidgets('ComplexResultCard', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ComplexResultCard(
            value: Complex(5, -3),
          ),
        ),
      );
      await expectLater(
        find.byType(ComplexResultCard),
        matchesGoldenFile('goldens/complex_result_card.png'),
      );
    });

    testWidgets('ComplexResultCard - no fraction', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ComplexResultCard(
            value: Complex(5, -3),
            withFraction: false,
          ),
        ),
      );
      await expectLater(
        find.byType(ComplexResultCard),
        matchesGoldenFile('goldens/complex_result_nofraction.png'),
      );
    });

    testWidgets('ComplexResultCard - decimals', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: ComplexResultCard(
            value: Complex(5.75, -0.5),
          ),
        ),
      );
      await expectLater(
        find.byType(ComplexResultCard),
        matchesGoldenFile('goldens/complex_result_card_decimals.png'),
      );
    });
  });
}

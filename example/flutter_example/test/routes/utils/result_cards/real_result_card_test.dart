import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'RealResultCard' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: RealResultCard(
            value: 0.5,
          ),
        ),
      );

      expect(find.byType(RealResultCard), findsOneWidget);
      expect(find.byKey(const Key('Fraction-ResultCard')), findsOneWidget);
    });

    testWidgets('Making sure that the fraction can be hidden', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: RealResultCard(
            value: 0.5,
            withFraction: false,
          ),
        ),
      );

      expect(find.byType(RealResultCard), findsOneWidget);
      expect(find.byKey(const Key('Fraction-ResultCard')), findsNothing);
    });

    testWidgets(
      "Making sure that when the value is 'NaN', an error message "
      'actually appears',
      (tester) async {
        await tester.pumpWidget(
          const MockWrapper(
            child: RealResultCard(
              value: double.nan,
            ),
          ),
        );

        expect(find.byType(RealResultCard), findsOneWidget);
        expect(find.text('Not computed'), findsOneWidget);
      },
    );
  });

  group('Golden tests - RealResultCard', () {
    testWidgets('RealResultCard', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: RealResultCard(
            value: 13,
            leading: 'f(x): ',
          ),
        ),
      );
      await expectLater(
        find.byType(RealResultCard),
        matchesGoldenFile('goldens/real_result_card.png'),
      );
    });

    testWidgets('RealResultCard - no fraction', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: RealResultCard(
            value: 13,
            withFraction: false,
          ),
        ),
      );
      await expectLater(
        find.byType(RealResultCard),
        matchesGoldenFile('goldens/real_result_card_nofraction.png'),
      );
    });

    testWidgets('RealResultCard - decimals', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: RealResultCard(
            value: -2.43,
          ),
        ),
      );
      await expectLater(
        find.byType(RealResultCard),
        matchesGoldenFile('goldens/real_result_card_decimals.png'),
      );
    });
  });
}

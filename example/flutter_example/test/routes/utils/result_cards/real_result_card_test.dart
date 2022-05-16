import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

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

    testGoldens('RealResultCard', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          '',
          const RealResultCard(
            value: 12,
          ),
        )
        ..addScenario(
          '',
          const RealResultCard(
            value: 0.5,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(350, 350),
      );
      await screenMatchesGolden(tester, 'real_result_card');
    });
  });
}

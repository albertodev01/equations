import 'package:equations_solver/routes/utils/result_cards/bool_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'BoolResultCard' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: BoolResultCard(
          leading: 'Test: ',
          value: true,
        ),
      ));

      expect(find.byType(BoolResultCard), findsOneWidget);
      expect(find.text('Test: Yes'), findsOneWidget);
    });

    testGoldens('BoolResultCard', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'True',
          const BoolResultCard(
            leading: 'Test: ',
            value: true,
          ),
        )
        ..addScenario(
          'False',
          const BoolResultCard(
            leading: 'Test: ',
            value: false,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(350, 350),
      );
      await screenMatchesGolden(tester, 'bool_result_card');
    });
  });
}

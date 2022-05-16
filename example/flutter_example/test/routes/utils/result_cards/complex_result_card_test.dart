import 'package:equations/equations.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

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

    testGoldens('RealResultCard', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'With integers',
          const ComplexResultCard(
            value: Complex(5, -3),
          ),
        )
        ..addScenario(
          'With doubles',
          const ComplexResultCard(
            value: Complex(5.75, -0.5),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: Scaffold(body: child)),
        surfaceSize: const Size(350, 350),
      );
      await screenMatchesGolden(tester, 'complex_result_card');
    });
  });
}

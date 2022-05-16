import 'package:equations_solver/routes/utils/body_pages/equation_text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'EquationTextFormatter' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: Scaffold(
            body: EquationTextFormatter(
              equation: 'x^2 - 5',
            ),
          ),
        ),
      );

      expect(find.byType(EquationTextFormatter), findsOneWidget);
      expect(find.byType(RichText), findsOneWidget);
    });

    testGoldens('EquationTextFormatter', (tester) async {
      const widget = SizedBox(
        width: 200,
        height: 100,
        child: Scaffold(
          body: EquationTextFormatter(
            equation: 'x^2 - 5',
          ),
        ),
      );

      final builder = GoldenBuilder.column()..addScenario('', widget);

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(child: child),
        surfaceSize: const Size(200, 170),
      );
      await screenMatchesGolden(tester, 'equation_text_formatter');
    });
  });
}

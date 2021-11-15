import 'package:equations_solver/routes/utils/equation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'EquationInput' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: EquationInput(
            controller: TextEditingController(),
            placeholderText: 'Demo',
          ),
        ),
      );

      expect(find.byType(EquationInput), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testGoldens('EquationInput', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'Small width - no overflow',
          EquationInput(
            controller: TextEditingController(),
            placeholderText: 'Demo',
            baseWidth: 150,
          ),
        )
        ..addScenario(
          'Large width - overflow',
          EquationInput(
            controller: TextEditingController(),
            placeholderText: 'Demo',
            baseWidth: 999999999,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        surfaceSize: const Size(350, 250),
        wrapper: (child) => MockWrapper(child: child),
      );
      await screenMatchesGolden(tester, 'equation_input');
    });
  });
}

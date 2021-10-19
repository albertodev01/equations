import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'ComplexNumberInput' widget", () {
    testWidgets('Making sure that the widget renders', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: ComplexNumberInput(
          realController: TextEditingController(),
          imaginaryController: TextEditingController(),
        ),
      ));

      expect(find.byType(ComplexNumberInput), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('i'), findsOneWidget);
      expect(find.text('+'), findsOneWidget);
    });

    testGoldens('ComplexNumberInput', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'No values',
          ComplexNumberInput(
            realController: TextEditingController(),
            imaginaryController: TextEditingController(),
          ),
        )
        ..addScenario(
          'With values',
          ComplexNumberInput(
            realController: TextEditingController(
              text: '5',
            ),
            imaginaryController: TextEditingController(
              text: '-2/3',
            ),
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(200, 200),
      );
      await screenMatchesGolden(tester, 'complex_number_input');
    });
  });
}

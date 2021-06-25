import 'package:equations_solver/routes/polynomial_page/polynomial_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../mock_wrapper.dart';

void main() {
  group("Testing the 'PolynomialInputField' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(MockWrapper(
        child: PolynomialInputField(
          controller: controller,
          placeholder: 'Demo',
        ),
      ));

      expect(find.byType(PolynomialInputField), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
    });

    testWidgets(
        'Making sure that a PolynomialInputField has a validator '
        'function to validate inputs', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(MockWrapper(
        child: PolynomialInputField(
          controller: controller,
          placeholder: 'Demo',
        ),
      ));

      final finder =
          find.byKey(const Key('PolynomialInputField-TextFormField'));
      expect(finder, findsOneWidget);

      // Testing the validator. Making sure that is accepts numbers and fractions
      final textField = tester.firstWidget(finder) as TextFormField;
      final validatorFunction = textField.validator!;

      expect(validatorFunction('1'), isNull);
      expect(validatorFunction('-2/3'), isNull);
      expect(validatorFunction('2.2587'), isNull);

      expect(validatorFunction(''), isNotNull);
    });

    testGoldens('PolynomialInputField', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          '',
          PolynomialInputField(
            controller: TextEditingController(text: '-1/2'),
            placeholder: 'Demo',
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(110, 110),
      );
      await screenMatchesGolden(tester, 'polynomial_input_field');
    });
  });
}

import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'ComplexNumberInput' widget", () {
    testWidgets('Making sure that the widget renders', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: ComplexNumberInput(
            realController: TextEditingController(),
            imaginaryController: TextEditingController(),
          ),
        ),
      );

      expect(find.byType(ComplexNumberInput), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('i'), findsOneWidget);
      expect(find.text('+'), findsOneWidget);
    });
  });

  group('Golden tests - ComplexNumberInput', () {
    testWidgets('ComplexNumberInput - no values', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: ComplexNumberInput(
            realController: TextEditingController(),
            imaginaryController: TextEditingController(),
          ),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/complex_input_novalues.png'),
      );
    });

    testWidgets('ComplexNumberInput - values', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: ComplexNumberInput(
            realController: TextEditingController(text: '3'),
            imaginaryController: TextEditingController(text: '1'),
          ),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/complex_input_values.png'),
      );
    });
  });
}

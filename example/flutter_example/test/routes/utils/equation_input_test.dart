import 'package:equations_solver/routes/utils/equation_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });

  group('Golden tests - EquationInput', () {
    testWidgets('EquationInput', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: EquationInput(
            controller: TextEditingController(),
            placeholderText: 'Demo',
            baseWidth: 150,
          ),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/equation_input.png'),
      );
    });
  });
}

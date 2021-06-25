import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'MatrixInput' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(MockWrapper(
        child: MatrixInput(
          matrixControllers: [
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
            TextEditingController(),
          ],
          matrixSize: 2,
        ),
      ));

      expect(find.byType(MatrixInput), findsOneWidget);
      expect(find.byType(Table), findsOneWidget);
      expect(find.byType(SystemInputField), findsNWidgets(4));
    });

    testGoldens('MatrixInput', (tester) async {
      final builder = GoldenBuilder.column()
        ..addScenario(
          'MatrixInput - 2x2',
          MatrixInput(
            matrixControllers: [
              TextEditingController(text: '1'),
              TextEditingController(text: '2'),
              TextEditingController(text: '3'),
              TextEditingController(text: '4'),
            ],
            matrixSize: 2,
          ),
        )
        ..addScenario(
          'MatrixInput - 3x3',
          MatrixInput(
            matrixControllers: [
              TextEditingController(text: '1'),
              TextEditingController(text: '2'),
              TextEditingController(text: '3'),
              TextEditingController(text: '4'),
              TextEditingController(text: '5'),
              TextEditingController(text: '6'),
              TextEditingController(text: '7'),
              TextEditingController(text: '8'),
              TextEditingController(text: '9'),
            ],
            matrixSize: 3,
          ),
        );

      await tester.pumpWidgetBuilder(
        builder.build(),
        wrapper: (child) => MockWrapper(
          child: child,
        ),
        surfaceSize: const Size(300, 400),
      );
      await screenMatchesGolden(tester, 'matrix_input');
    });
  });
}

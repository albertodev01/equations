import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'MatrixInput' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: MatrixInput(
            matrixControllers: [
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
              TextEditingController(),
            ],
            matrixSize: 2,
          ),
        ),
      );

      expect(find.byType(MatrixInput), findsOneWidget);
      expect(find.byType(Table), findsOneWidget);
      expect(find.byType(SystemInputField), findsNWidgets(4));
    });
  });

  group('Golden tests - MatrixInput', () {
    testWidgets('MatrixInput - 1x1', (tester) async {
      await tester.binding.setSurfaceSize(const Size(110, 110));

      await tester.pumpWidget(
        MockWrapper(
          child: MatrixInput(
            matrixControllers: [
              TextEditingController(text: '1'),
            ],
            matrixSize: 1,
          ),
        ),
      );
      await expectLater(
        find.byType(MatrixInput),
        matchesGoldenFile('goldens/matrix_input_1.png'),
      );
    });

    testWidgets('MatrixInput - 2x2', (tester) async {
      await tester.binding.setSurfaceSize(const Size(170, 170));

      await tester.pumpWidget(
        MockWrapper(
          child: MatrixInput(
            matrixControllers: [
              TextEditingController(text: '1'),
              TextEditingController(text: '2'),
              TextEditingController(text: '3'),
              TextEditingController(text: '4'),
            ],
            matrixSize: 2,
          ),
        ),
      );
      await expectLater(
        find.byType(MatrixInput),
        matchesGoldenFile('goldens/matrix_input_2.png'),
      );
    });

    testWidgets('MatrixInput - 3x3', (tester) async {
      await tester.binding.setSurfaceSize(const Size(200, 200));

      await tester.pumpWidget(
        MockWrapper(
          child: MatrixInput(
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
        ),
      );
      await expectLater(
        find.byType(MatrixInput),
        matchesGoldenFile('goldens/matrix_input_3.png'),
      );
    });

    testWidgets('MatrixInput - 4x4', (tester) async {
      await tester.binding.setSurfaceSize(const Size(230, 230));

      await tester.pumpWidget(
        MockWrapper(
          child: MatrixInput(
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
              TextEditingController(text: '10'),
              TextEditingController(text: '11'),
              TextEditingController(text: '12'),
              TextEditingController(text: '13'),
              TextEditingController(text: '14'),
              TextEditingController(text: '15'),
              TextEditingController(text: '16'),
            ],
            matrixSize: 4,
          ),
        ),
      );
      await expectLater(
        find.byType(MatrixInput),
        matchesGoldenFile('goldens/matrix_input_4.png'),
      );
    });
  });
}

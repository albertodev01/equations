import 'package:equations_solver/routes/system_page/system_input_field.dart';
import 'package:equations_solver/routes/system_page/utils/vector_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'VectorInput' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        MockWrapper(
          child: VectorInput(
            vectorControllers: [
              TextEditingController(),
              TextEditingController(),
            ],
            vectorSize: 2,
          ),
        ),
      );

      expect(find.byType(VectorInput), findsOneWidget);
      expect(find.byType(SystemInputField), findsNWidgets(2));
    });
  });

  group('Golden tests - VectorInput', () {
    testWidgets('VectorInput - 1', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 150));

      await tester.pumpWidget(
        MockWrapper(
          child: VectorInput(
            vectorControllers: [
              TextEditingController(text: '1'),
            ],
            vectorSize: 1,
          ),
        ),
      );
      await expectLater(
        find.byType(VectorInput),
        matchesGoldenFile('goldens/vector_input_1.png'),
      );
    });

    testWidgets('VectorInput - 2', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 200));

      await tester.pumpWidget(
        MockWrapper(
          child: VectorInput(
            vectorControllers: [
              TextEditingController(text: '1'),
              TextEditingController(text: '2'),
            ],
            vectorSize: 2,
          ),
        ),
      );
      await expectLater(
        find.byType(VectorInput),
        matchesGoldenFile('goldens/vector_input_2.png'),
      );
    });

    testWidgets('VectorInput - 3', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 250));

      await tester.pumpWidget(
        MockWrapper(
          child: VectorInput(
            vectorControllers: [
              TextEditingController(text: '1'),
              TextEditingController(text: '2'),
              TextEditingController(text: '3'),
            ],
            vectorSize: 3,
          ),
        ),
      );
      await expectLater(
        find.byType(VectorInput),
        matchesGoldenFile('goldens/vector_input_3.png'),
      );
    });

    testWidgets('VectorInput - 4', (tester) async {
      await tester.binding.setSurfaceSize(const Size(150, 300));

      await tester.pumpWidget(
        MockWrapper(
          child: VectorInput(
            vectorControllers: [
              TextEditingController(text: '1'),
              TextEditingController(text: '2'),
              TextEditingController(text: '3'),
              TextEditingController(text: '4'),
            ],
            vectorSize: 4,
          ),
        ),
      );
      await expectLater(
        find.byType(VectorInput),
        matchesGoldenFile('goldens/vector_input_4.png'),
      );
    });
  });
}

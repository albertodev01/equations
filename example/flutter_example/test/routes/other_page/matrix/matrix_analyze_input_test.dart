import 'package:equations_solver/routes/other_page/matrix/matrix_analyzer_input.dart';
import 'package:equations_solver/routes/system_page/utils/matrix_input.dart';
import 'package:equations_solver/routes/system_page/utils/size_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';
import '../matrix_mock.dart';

void main() {
  List<TextEditingController> generateControllers() {
    return List<TextEditingController>.generate(
      25,
      (index) => TextEditingController(text: '$index'),
      growable: false,
    );
  }

  group("Testing the 'MatrixAnalyzerInput' widget", () {
    testWidgets(
      'Making sure that matrices can be analyzed',
      (tester) async {
        await tester.pumpWidget(
          MockMatrixOther(
            controllers: [
              TextEditingController(),
            ],
            child: const MatrixAnalyzerInput(),
          ),
        );

        expect(find.byType(SizePicker), findsOneWidget);
        expect(find.byType(MatrixInput), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);

        // Matrix input
        await tester.enterText(find.byType(TextFormField), '1');
        await tester.tap(find.byKey(const Key('MatrixAnalyze-button-analyze')));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsNothing);
        expect(find.text('1'), findsOneWidget);

        // Cleaning
        final finder = find.byKey(const Key('MatrixAnalyze-button-clean'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.text('1'), findsNothing);

        tester.widgetList<TextFormField>(find.byType(TextFormField)).forEach(
          (textController) {
            expect(textController.controller!.text.length, isZero);
          },
        );
      },
    );

    testWidgets(
      'Making sure that when trying to evaluate a matrix, if at least one of '
      'the inputs is wrong, a snackbar appears',
      (tester) async {
        await tester.pumpWidget(
          MockMatrixOther(
            controllers: [
              TextEditingController(),
            ],
            child: const MatrixAnalyzerInput(),
          ),
        );

        expect(find.byType(SizePicker), findsOneWidget);
        expect(find.byType(MatrixInput), findsOneWidget);
        expect(find.byType(Form), findsOneWidget);

        // Wrong input check
        await tester.tap(find.byKey(const Key('MatrixAnalyze-button-analyze')));
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      },
    );

    testWidgets(
      'Making sure that the form can be cleared correctly',
      (tester) async {
        await tester.pumpWidget(
          MockMatrixOther(
            min: 2,
            controllers: generateControllers(),
            child: const MatrixAnalyzerInput(),
          ),
        );

        expect(find.byType(SizePicker), findsOneWidget);
        expect(find.byType(MatrixInput), findsOneWidget);

        // Expecting to find some mock data
        expect(find.text('0'), findsOneWidget);
        expect(find.text('1'), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.text('3'), findsOneWidget);

        // Now clearing
        await tester.tap(find.byKey(const Key('MatrixAnalyze-button-clean')));
        await tester.pumpAndSettle();

        expect(find.text('0'), findsNothing);
        expect(find.text('1'), findsNothing);
        expect(find.text('2'), findsNothing);
        expect(find.text('3'), findsNothing);

        tester.widgetList<TextFormField>(find.byType(TextFormField)).forEach(
          (textFormField) {
            expect(textFormField.controller!.text.length, isZero);
          },
        );
      },
    );
  });

  group('Golden tests - MatrixAnalyzerInput', () {
    testWidgets('MatrixAnalyzerInput - 1x1', (tester) async {
      await tester.binding.setSurfaceSize(const Size(450, 350));

      await tester.pumpWidget(
        MockMatrixOther(
          controllers: generateControllers(),
          child: const MatrixAnalyzerInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/matrix_analyze_input_1x1.png'),
      );
    });

    testWidgets('MatrixAnalyzerInput - 2x2', (tester) async {
      await tester.binding.setSurfaceSize(const Size(350, 370));

      await tester.pumpWidget(
        MockMatrixOther(
          min: 2,
          controllers: generateControllers(),
          child: const MatrixAnalyzerInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/matrix_analyze_input_2x2.png'),
      );
    });

    testWidgets('MatrixAnalyzerInput - 3x3', (tester) async {
      await tester.binding.setSurfaceSize(const Size(350, 450));

      await tester.pumpWidget(
        MockMatrixOther(
          min: 3,
          controllers: generateControllers(),
          child: const MatrixAnalyzerInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/matrix_analyze_input_3x3.png'),
      );
    });

    testWidgets('MatrixAnalyzerInput - 4x4', (tester) async {
      await tester.binding.setSurfaceSize(const Size(350, 500));

      await tester.pumpWidget(
        MockMatrixOther(
          min: 4,
          controllers: generateControllers(),
          child: const MatrixAnalyzerInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/matrix_analyze_input_4x4.png'),
      );
    });
  });
}

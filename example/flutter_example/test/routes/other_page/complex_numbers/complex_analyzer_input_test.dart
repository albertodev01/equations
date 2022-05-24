import 'package:equations_solver/routes/other_page/complex_numbers/complex_analyzer_input.dart';
import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';
import '../complex_numbers_mock.dart';

void main() {
  group("Testing the 'ComplexAnalyzerInput' widget", () {
    testWidgets('Making sure that the widget renders', (tester) async {
      await tester.pumpWidget(
        const MockComplexNumbers(
          child: ComplexAnalyzerInput(),
        ),
      );

      expect(find.byType(ComplexAnalyzerInput), findsOneWidget);
      expect(find.byType(ComplexNumberInput), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
    });

    testWidgets(
      'Making sure that when trying to evaluate a complex number, if at least '
      'one of the inputs is wrong, a snackbar appears',
      (tester) async {
        await tester.pumpWidget(
          const MockComplexNumbers(
            child: ComplexAnalyzerInput(),
          ),
        );

        // Entering some text
        const realKey = Key('ComplexNumberInput-TextFormField-RealPart');
        const imagKey = Key('ComplexNumberInput-TextFormField-ImaginaryPart');

        await tester.enterText(find.byKey(realKey), '-1/2');
        await tester.enterText(find.byKey(imagKey), '..');
        await tester.tap(
          find.byKey(const Key('ComplexAnalyze-button-analyze')),
        );
        await tester.pumpAndSettle();

        // Making sure that we can see the entered text and the snackbar
        expect(find.text('-1/2'), findsOneWidget);
        expect(find.byType(SnackBar), findsOneWidget);

        // Clearing
        await tester.tap(find.byKey(const Key('ComplexAnalyze-button-clean')));
        await tester.pumpAndSettle();

        expect(find.text('-1/2'), findsNothing);
      },
    );

    testWidgets(
      'Making sure that complex numbers can be analyzed',
      (tester) async {
        await tester.pumpWidget(
          const MockComplexNumbers(
            child: ComplexAnalyzerInput(),
          ),
        );

        // Entering some text
        const realKey = Key('ComplexNumberInput-TextFormField-RealPart');
        const imagKey = Key('ComplexNumberInput-TextFormField-ImaginaryPart');

        await tester.enterText(find.byKey(realKey), '-1/2');
        await tester.enterText(find.byKey(imagKey), '5');

        await tester.tap(
          find.byKey(const Key('ComplexAnalyze-button-analyze')),
        );
        await tester.pumpAndSettle();

        expect(find.text('-1/2'), findsOneWidget);
        expect(find.text('5'), findsOneWidget);

        // Cleaning
        final finder = find.byKey(const Key('ComplexAnalyze-button-clean'));
        await tester.tap(finder);
        await tester.pumpAndSettle();

        expect(find.text('-1/2'), findsNothing);
        expect(find.text('5'), findsNothing);

        tester.widgetList<TextFormField>(find.byType(TextFormField)).forEach(
          (textController) {
            expect(textController.controller!.text.length, isZero);
          },
        );
      },
    );
  });

  group('Golden tests - ComplexAnalyzerInput', () {
    testWidgets('ComplexAnalyzerInput', (tester) async {
      await tester.pumpWidget(
        MockComplexNumbers(
          controllers: [
            TextEditingController(text: '2'),
            TextEditingController(text: '-1'),
          ],
          child: const ComplexAnalyzerInput(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/complex_analyze_input.png'),
      );
    });
  });
}

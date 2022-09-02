import 'package:equations_solver/routes/other_page/complex_numbers/complex_number_analyzer_results.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';
import '../complex_numbers_mock.dart';

void main() {
  group("Testing the 'ComplexNumberAnalyzerResult' widget", () {
    testWidgets('Making sure that the widget renders', (tester) async {
      await tester.pumpWidget(
        const MockComplexNumbers(
          child: ComplexNumberAnalyzerResult(),
        ),
      );

      expect(find.byType(ComplexNumberAnalyzerResult), findsOneWidget);
      expect(find.byType(RealResultCard), findsNothing);
    });

    testWidgets('Making sure that the widget is responsive', (tester) async {
      await tester.binding.setSurfaceSize(const Size(2000, 2000));

      await tester.pumpWidget(
        const MockComplexNumbers(
          complexMockData: true,
        ),
      );

      expect(
        find.byType(Wrap),
        findsOneWidget,
      );
    });

    testWidgets(
      'Making sure that analysis results can correctly be displayed',
      (tester) async {
        await tester.pumpWidget(
          const MockComplexNumbers(
            complexMockData: true,
            child: ComplexNumberAnalyzerResult(),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(RealResultCard), findsNWidgets(5));
        expect(find.byType(ComplexResultCard), findsNWidgets(3));
      },
    );
  });

  group('Golden tests - MockComplexNumbers', () {
    testWidgets('MockComplexNumbers', (tester) async {
      await tester.pumpWidget(
        const MockComplexNumbers(
          complexMockData: true,
          child: ComplexNumberAnalyzerResult(),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/complex_output_results.png'),
      );
    });
  });
}

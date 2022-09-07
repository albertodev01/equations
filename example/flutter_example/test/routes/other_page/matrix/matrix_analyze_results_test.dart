import 'package:equations_solver/routes/other_page/matrix/matrix_analyze_results.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_output.dart';
import 'package:equations_solver/routes/utils/no_results.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:equations_solver/routes/utils/result_cards/real_result_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';
import '../matrix_mock.dart';

void main() {
  group("Testing the 'MatrixOtherBody' widget", () {
    testWidgets(
      'Making sure that the widget renders nothing when there are no '
      'analysis results',
      (tester) async {
        await tester.pumpWidget(
          const MockMatrixOther(
            child: MatrixAnalyzerResults(),
          ),
        );

        expect(find.byType(RealResultCard), findsNothing);
      },
    );

    testWidgets('Making sure that the widget is responsive', (tester) async {
      await tester.binding.setSurfaceSize(const Size(2000, 2000));

      await tester.pumpWidget(
        const MockMatrixOther(
          matrixMockData: true,
          child: MatrixAnalyzerResults(),
        ),
      );

      expect(
        find.byType(Wrap),
        findsOneWidget,
      );
    });

    testWidgets(
      'Making sure that the widget correctly shows the results',
      (tester) async {
        await tester.pumpWidget(
          const MockMatrixOther(
            matrixMockData: true,
            child: MatrixAnalyzerResults(),
          ),
        );

        expect(find.byType(NoResults), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsNothing);
        expect(find.byType(RealResultCard), findsNWidgets(3));
        expect(find.byType(ComplexResultCard), findsNWidgets(5));
        expect(find.byType(MatrixOutput), findsNWidgets(3));
      },
    );
  });

  group('Golden tests - MatrixAnalyzerResults', () {
    testWidgets('MatrixAnalyzerResults - results', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 1400));

      await tester.pumpWidget(
        const MockMatrixOther(
          matrixMockData: true,
          child: SizedBox(
            width: 900,
            child: SingleChildScrollView(
              child: MatrixAnalyzerResults(),
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/matrix_analyze_results_onecolumn.png'),
      );
    });

    testWidgets('MatrixAnalyzerResults - results', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        const MockMatrixOther(
          matrixMockData: true,
          child: SingleChildScrollView(
            child: MatrixAnalyzerResults(),
          ),
        ),
      );

      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/matrix_analyze_results.png'),
      );
    });
  });
}

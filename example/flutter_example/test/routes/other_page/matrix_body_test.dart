import 'package:equations_solver/routes/other_page/matrix/matrix_analyze_results.dart';
import 'package:equations_solver/routes/other_page/matrix/matrix_analyzer_input.dart';
import 'package:equations_solver/routes/other_page/matrix_body.dart';
import 'package:equations_solver/routes/utils/body_pages/go_back_button.dart';
import 'package:flutter_test/flutter_test.dart';

import 'matrix_mock.dart';

void main() {
  group("Testing the 'MatrixOtherBody' widget", () {
    testWidgets('Making sure that the widget renders', (tester) async {
      await tester.pumpWidget(
        const MockMatrixOther(),
      );

      expect(find.byType(MatrixOtherBody), findsOneWidget);
      expect(find.byType(GoBackButton), findsOneWidget);
      expect(find.byType(MatrixAnalyzerInput), findsOneWidget);
      expect(find.byType(MatrixAnalyzerResults), findsOneWidget);
    });
  });
}

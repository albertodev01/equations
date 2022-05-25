import 'package:equations_solver/routes/other_page.dart';
import 'package:equations_solver/routes/other_page/complex_numbers_body.dart';
import 'package:equations_solver/routes/other_page/matrix_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'OtherPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(
        const MockWrapper(
          child: OtherPage(),
        ),
      );

      expect(find.byType(EquationScaffold), findsOneWidget);
      expect(find.byType(MatrixOtherBody), findsOneWidget);
      expect(find.byType(ComplexNumberOtherBody), findsNothing);
    });
  });
}

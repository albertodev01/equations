import 'package:equations_solver/routes/integral_page.dart';
import 'package:equations_solver/routes/integral_page/integral_body.dart';
import 'package:equations_solver/routes/utils/equation_scaffold.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'IntegralPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: IntegralPage(),
      ));

      expect(find.byType(IntegralPage), findsOneWidget);
      expect(find.byType(EquationScaffold), findsOneWidget);
      expect(find.byType(IntegralBody), findsOneWidget);
    });
  });
}

import 'package:equations_solver/routes/polynomial_page.dart';
import 'package:equations_solver/routes/polynomial_page/polynomial_body.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_wrapper.dart';

void main() {
  group("Testing the 'PolynomialPage' widget", () {
    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: PolynomialPage(),
      ));

      expect(find.byType(PolynomialBody), findsOneWidget);
      expect(find.byType(PolynomialPage), findsOneWidget);
    });

    testWidgets('Making sure that the widget is rendered', (tester) async {
      await tester.pumpWidget(const MockWrapper(
        child: PolynomialPage(),
      ));

      expect(find.byType(PolynomialBody), findsOneWidget);
      expect(find.byType(PolynomialPage), findsOneWidget);
    });
  });
}

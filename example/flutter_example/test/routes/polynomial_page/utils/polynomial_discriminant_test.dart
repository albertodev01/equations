import 'package:equations_solver/routes/polynomial_page/model/inherited_polynomial.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_state.dart';
import 'package:equations_solver/routes/polynomial_page/utils/polynomial_discriminant.dart';
import 'package:equations_solver/routes/utils/result_cards/complex_result_card.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mock_wrapper.dart';

void main() {
  group("Testing the 'PolynomialDiscriminant' widget", () {
    testWidgets('Making sure that the widget can be rendered', (tester) async {
      await tester.pumpWidget(
        InheritedPolynomial(
          polynomialState: PolynomialState(PolynomialType.linear)
            ..solvePolynomial(['1', '2']),
          child: const MockWrapper(
            child: PolynomialDiscriminant(),
          ),
        ),
      );

      expect(find.byType(PolynomialDiscriminant), findsOneWidget);
      expect(find.byType(ComplexResultCard), findsOneWidget);
    });
  });

  group('Golden test - PolynomialDiscriminant', () {
    testWidgets('PolynomialDiscriminant', (tester) async {
      await tester.pumpWidget(
        InheritedPolynomial(
          polynomialState: PolynomialState(PolynomialType.linear)
            ..solvePolynomial(['1', '2']),
          child: const MockWrapper(
            child: PolynomialDiscriminant(),
          ),
        ),
      );
      await expectLater(
        find.byType(MockWrapper),
        matchesGoldenFile('goldens/polynomial_discriminant.png'),
      );
    });
  });
}

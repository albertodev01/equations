import 'package:equations/equations.dart';
import 'package:equations_solver/routes/polynomial_page/model/polynomial_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing the 'PolynomialResult' class", () {
    test('Initial values', () {
      final polynomialResult = PolynomialResult(
        algebraic: Algebraic.fromReal(
          const [1, 2],
        ),
      );

      expect(polynomialResult.algebraic, isA<Linear>());
    });

    test('Making sure that objects can be properly compared', () {
      final polynomialResult = PolynomialResult(
        algebraic: Algebraic.fromReal(
          const [1, 2],
        ),
      );

      expect(
        polynomialResult,
        equals(
          PolynomialResult(
            algebraic: Algebraic.fromReal(
              const [1, 2],
            ),
          ),
        ),
      );

      expect(
        PolynomialResult(
          algebraic: Algebraic.fromReal(
            const [1, 2],
          ),
        ),
        polynomialResult,
      );

      expect(
        polynomialResult ==
            PolynomialResult(
              algebraic: Algebraic.fromReal(
                const [1, 2],
              ),
            ),
        isTrue,
      );

      expect(
        PolynomialResult(
              algebraic: Algebraic.fromReal(
                const [1, 2],
              ),
            ) ==
            polynomialResult,
        isTrue,
      );

      expect(
        PolynomialResult(
              algebraic: Algebraic.fromReal(
                const [1, -2],
              ),
            ) ==
            polynomialResult,
        isFalse,
      );

      expect(
        polynomialResult.hashCode,
        equals(
          PolynomialResult(
            algebraic: Algebraic.fromReal(
              const [1, 2],
            ),
          ).hashCode,
        ),
      );
    });
  });
}

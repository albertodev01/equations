import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group('Testing the behaviors of the PolynomialLongDivision class.', () {
    final results = PolynomialLongDivision(
      polyNumerator: Algebraic.fromReal([1, -3, 6, 7.8]),
      polyDenominator: Algebraic.fromReal([2, -9]),
    );

    test('Making sure that values are properly constructed.', () {
      expect(
        results.polyNumerator,
        equals(Algebraic.fromReal([1, -3, 6, 7.8])),
      );
      expect(
        results.polyDenominator,
        equals(Algebraic.fromReal([2, -9])),
      );
    });

    test("Making sure that 'toString()' is properly overridden", () {
      final results = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, 2, 3]),
        polyDenominator: Algebraic.fromReal([2, 1]),
      );

      expect(results.toString(), equals('(1x^2 + 2x + 3) / (2x + 1)'));
    });

    test('Making sure that instances can be properly compared.', () {
      final results2 = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, -3, 6, 7.8]),
        polyDenominator: Algebraic.fromReal([2, -9]),
      );

      expect(results2 == results, isTrue);
      expect(
        results ==
            PolynomialLongDivision(
              polyNumerator: Algebraic.fromReal([1, -3, 6, 7.8]),
              polyDenominator: Algebraic.fromReal([2, -9]),
            ),
        isTrue,
      );

      expect(
        results.hashCode,
        equals(
          PolynomialLongDivision(
            polyNumerator: Algebraic.fromReal([1, -3, 6, 7.8]),
            polyDenominator: Algebraic.fromReal([2, -9]),
          ).hashCode,
        ),
      );

      expect(
        results ==
            PolynomialLongDivision(
              polyNumerator: Algebraic.fromReal([-3, 6, 7.8]),
              polyDenominator: Algebraic.fromReal([2, -9]),
            ),
        isFalse,
      );
      expect(
        results ==
            PolynomialLongDivision(
              polyNumerator: Algebraic.fromReal([1, -3, 6, 7.8]),
              polyDenominator: Algebraic.fromReal([2, 9]),
            ),
        isFalse,
      );
    });

    test(
        'Making sure that an exception is thrown if the degree of the '
        'denominator is bigger than the degree of the numerator.', () {
      final results = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, 2, 3]),
        polyDenominator: Algebraic.fromReal([2, 1, 0, -1]),
      );

      expect(
        () => results.divide(),
        throwsA(isA<PolynomialLongDivisionException>()),
      );
    });

    test("Making sure that the 'divide()' method works properly", () {
      final polyLongDivision = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, 3, -6]),
        polyDenominator: Algebraic.fromReal([1, 7]),
      );

      final results = polyLongDivision.divide();

      expect(results.quotient, equals(Algebraic.fromReal([1, -4])));
      expect(results.remainder, equals(Algebraic.fromReal([22])));
    });
  });
}

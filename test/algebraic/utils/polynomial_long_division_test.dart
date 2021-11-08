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
      expect(results == results2, isTrue);
      expect(results, equals(results2));
      expect(results2, equals(results));
      expect(
        results ==
            PolynomialLongDivision(
              polyNumerator: Algebraic.fromReal([1, -3, 6, 7.8]),
              polyDenominator: Algebraic.fromReal([2, -9]),
            ),
        isTrue,
      );
      expect(
        PolynomialLongDivision(
              polyNumerator: Algebraic.fromReal([1, -3, 6, 7.8]),
              polyDenominator: Algebraic.fromReal([2, -9]),
            ) ==
            results,
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
      'denominator is bigger than the degree of the numerator.',
      () {
        final results = PolynomialLongDivision(
          polyNumerator: Algebraic.fromReal([1, 2, 3]),
          polyDenominator: Algebraic.fromReal([2, 1, 0, -1]),
        );

        expect(
          results.divide,
          throwsA(isA<PolynomialLongDivisionException>()),
        );
      },
    );

    test("Making sure that the 'divide()' method works properly", () {
      final polyLongDivision = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, 3, -6]),
        polyDenominator: Algebraic.fromReal([1, 7]),
      );

      final results = polyLongDivision.divide();

      expect(results.quotient, equals(Algebraic.fromReal([1, -4])));
      expect(results.remainder, equals(Algebraic.fromReal([22])));
    });

    test(
      'Making sure that quotient 1 and remainder 0 are returned when '
      'dividing the same polynomials',
      () {
        final polyLongDivision = PolynomialLongDivision(
          polyNumerator: Algebraic.fromReal([1, 3, -6]),
          polyDenominator: Algebraic.fromReal([1, 3, -6]),
        );

        final results = polyLongDivision.divide();

        expect(results.quotient, equals(Algebraic.fromReal([1])));
        expect(results.remainder, equals(Algebraic.fromReal([0])));
      },
    );

    test('Batch tests', () {
      final dividends = [
        Algebraic.fromReal([3, -5, 10, -3]),
        Algebraic.fromReal([2, -9, 0, 15]),
        Algebraic.fromReal([1, 5]),
        Algebraic.fromReal([1, -3, 0]),
        Algebraic.fromReal([26]),
      ];
      final divisors = [
        Algebraic.fromReal([3, 1]),
        Algebraic.fromReal([2, -5]),
        Algebraic.fromReal([1, 5]),
        Algebraic.fromReal([1, 0, 1]),
        Algebraic.fromReal([2]),
      ];
      final results = [
        AlgebraicDivision(
          quotient: Algebraic.fromReal([1, -2, 4]),
          remainder: Algebraic.fromReal([-7]),
        ),
        AlgebraicDivision(
          quotient: Algebraic.fromReal([1, -2, -5]),
          remainder: Algebraic.fromReal([-10]),
        ),
        AlgebraicDivision(
          quotient: Algebraic.fromReal([1]),
          remainder: Algebraic.fromReal([0]),
        ),
        AlgebraicDivision(
          quotient: Algebraic.fromReal([1]),
          remainder: Algebraic.fromReal([-3, -1]),
        ),
        AlgebraicDivision(
          quotient: Algebraic.fromReal([13]),
          remainder: Algebraic.fromReal([0]),
        ),
      ];

      for (var i = 0; i < results.length; ++i) {
        expect(dividends[i] / divisors[i], equals(results[i]));
      }
    });
  });
}

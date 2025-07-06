import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group('PolynomialLongDivision', () {
    final results = PolynomialLongDivision(
      polyNumerator: Algebraic.fromReal([1, -3, 6, 7.8]),
      polyDenominator: Algebraic.fromReal([2, -9]),
    );

    test('Smoke test', () {
      expect(
        results.polyNumerator,
        equals(Algebraic.fromReal([1, -3, 6, 7.8])),
      );
      expect(results.polyDenominator, equals(Algebraic.fromReal([2, -9])));
    });

    test('toString()', () {
      final results = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, 2, 3]),
        polyDenominator: Algebraic.fromReal([2, 1]),
      );

      expect(results.toString(), equals('(1x^2 + 2x + 3) / (2x + 1)'));
    });

    test('Object comparison', () {
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

    test('Exception is thrown if degree denominator > degree numerator', () {
      final results = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, 2, 3]),
        polyDenominator: Algebraic.fromReal([2, 1, 0, -1]),
      );

      expect(results.divide, throwsA(isA<PolynomialLongDivisionException>()));
    });

    test('divide() method', () {
      final polyLongDivision = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, 3, -6]),
        polyDenominator: Algebraic.fromReal([1, 7]),
      );

      final results = polyLongDivision.divide();

      expect(results.quotient, equals(Algebraic.fromReal([1, -4])));
      expect(results.remainder, equals(Algebraic.fromReal([22])));
    });

    test('Quotient 1 and remainder 0 if polynomials are equal', () {
      final polyLongDivision = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, 3, -6]),
        polyDenominator: Algebraic.fromReal([1, 3, -6]),
      );

      final results = polyLongDivision.divide();

      expect(results.quotient, equals(Algebraic.fromReal([1])));
      expect(results.remainder, equals(Algebraic.fromReal([0])));
    });

    group('Batch tests', () {
      test('Test 1: (3x^3 - 5x^2 + 10x - 3) / (3x + 1)', () {
        final dividend = Algebraic.fromReal([3, -5, 10, -3]);
        final divisor = Algebraic.fromReal([3, 1]);
        final expected = (
          quotient: Algebraic.fromReal([1, -2, 4]),
          remainder: Algebraic.fromReal([-7]),
        );
        expect(dividend / divisor, equals(expected));
      });

      test('Test 2: (2x^3 - 9x^2 + 15) / (2x - 5)', () {
        final dividend = Algebraic.fromReal([2, -9, 0, 15]);
        final divisor = Algebraic.fromReal([2, -5]);
        final expected = (
          quotient: Algebraic.fromReal([1, -2, -5]),
          remainder: Algebraic.fromReal([-10]),
        );
        expect(dividend / divisor, equals(expected));
      });

      test('Test 3: (x + 5) / (x + 5)', () {
        final dividend = Algebraic.fromReal([1, 5]);
        final divisor = Algebraic.fromReal([1, 5]);
        final expected = (
          quotient: Algebraic.fromReal([1]),
          remainder: Algebraic.fromReal([0]),
        );
        expect(dividend / divisor, equals(expected));
      });

      test('Test 4: (x^2 - 3x) / (x^2 + 1)', () {
        final dividend = Algebraic.fromReal([1, -3, 0]);
        final divisor = Algebraic.fromReal([1, 0, 1]);
        final expected = (
          quotient: Algebraic.fromReal([1]),
          remainder: Algebraic.fromReal([-3, -1]),
        );
        expect(dividend / divisor, equals(expected));
      });

      test('Test 5: 26 / 2', () {
        final dividend = Algebraic.fromReal([26]);
        final divisor = Algebraic.fromReal([2]);
        final expected = (
          quotient: Algebraic.fromReal([13]),
          remainder: Algebraic.fromReal([0]),
        );
        expect(dividend / divisor, equals(expected));
      });
    });
  });
}

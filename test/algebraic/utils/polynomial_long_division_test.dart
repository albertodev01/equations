import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

/// Checks that `numerator = quotient * denominator + remainder`, coefficient by
/// coefficient and within [tolerance] (relative to the size of the numerator
/// coefficients), and that the remainder is either zero or has a lower degree
/// than the denominator.
void expectValidDivision(
  Algebraic numerator,
  Algebraic denominator,
  AlgebraicDivision result, {
  double tolerance = 0,
}) {
  final remainder = result.remainder;
  final remainderIsZero = remainder.coefficients.every((c) => c.isZero);

  expect(
    remainderIsZero ||
        remainder.coefficients.length < denominator.coefficients.length,
    isTrue,
    reason:
        'The degree of the remainder $remainder must be lower than the '
        'degree of the denominator $denominator',
  );

  final rebuilt = result.quotient * denominator + remainder;
  final expected = numerator.coefficients;
  final actual = rebuilt.coefficients;

  expect(
    actual.length,
    equals(expected.length),
    reason: '$rebuilt should be equal to $numerator',
  );

  final scale = expected.fold<double>(1, (m, c) => max(m, c.abs()));
  for (var i = 0; i < expected.length; ++i) {
    expect(
      (actual[i] - expected[i]).abs(),
      lessThanOrEqualTo(tolerance * scale),
      reason: '$rebuilt should be equal to $numerator',
    );
  }
}

/// Returns a random polynomial of the given [degree] whose coefficients are
/// integers in `[-5, 5]` and whose leading coefficient is [leading] (a random
/// non-zero integer if `null`).
Algebraic randomIntegerPolynomial(Random random, int degree, {int? leading}) {
  final lead =
      leading ?? (random.nextInt(5) + 1) * (random.nextBool() ? 1 : -1);

  return Algebraic.fromReal([
    lead.toDouble(),
    ...List<double>.generate(degree, (_) => random.nextInt(11) - 5.0),
  ]);
}

/// Returns a random polynomial of the given [degree] whose coefficients are
/// complex numbers with real and imaginary parts in `[-10, 10)`.
Algebraic randomComplexPolynomial(Random random, int degree) {
  Complex randomComplex() => Complex(
    random.nextDouble() * 20 - 10,
    random.nextDouble() * 20 - 10,
  );

  return Algebraic.from(
    List<Complex>.generate(degree + 1, (_) => randomComplex()),
  );
}

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

    test('Quotient 0 if degree denominator > degree numerator', () {
      final results = PolynomialLongDivision(
        polyNumerator: Algebraic.fromReal([1, 2, 3]),
        polyDenominator: Algebraic.fromReal([2, 1, 0, -1]),
      ).divide();

      expect(results.quotient, equals(Algebraic.fromReal([0])));
      expect(results.remainder, equals(Algebraic.fromReal([1, 2, 3])));
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

    group('Division tests', () {
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

      test('Test 6: Division resulting in empty remainder (all zeros)', () {
        final dividend = Algebraic.fromReal([2, 4, 2]); // 2x^2 + 4x + 2
        final divisor = Algebraic.fromReal([1, 1]); // x + 1
        final result = PolynomialLongDivision(
          polyNumerator: dividend,
          polyDenominator: divisor,
        ).divide();
        expect(result.remainder.coefficients.length, greaterThan(0));
        expect(result.remainder.coefficients.every((c) => c.isZero), isTrue);
      });
    });

    group('Division by zero', () {
      test('Non-constant polynomial divided by zero', () {
        expect(
          PolynomialLongDivision(
            polyNumerator: Algebraic.fromReal([1, 1]),
            polyDenominator: Algebraic.fromReal([0]),
          ).divide,
          throwsA(isA<PolynomialLongDivisionException>()),
        );
      });

      test('High degree polynomial divided by zero', () {
        expect(
          () =>
              Algebraic.fromReal([3, -1, 0, 2, 5, 0, 1]) /
              Algebraic.fromReal([0]),
          throwsA(isA<PolynomialLongDivisionException>()),
        );
      });

      test('Constant divided by zero', () {
        expect(
          () => Algebraic.fromReal([5]) / Algebraic.fromReal([0]),
          throwsA(isA<PolynomialLongDivisionException>()),
        );
      });

      test('Zero divided by zero', () {
        expect(
          () => Algebraic.fromReal([0]) / Algebraic.fromReal([0]),
          throwsA(isA<PolynomialLongDivisionException>()),
        );
      });

      test('Complex polynomial divided by complex zero', () {
        expect(
          () =>
              Algebraic.from(const [Complex(1, 2), Complex.i()]) /
              Constant(a: const Complex.zero()),
          throwsA(isA<PolynomialLongDivisionException>()),
        );
      });
    });

    group('Numerator degree lower than denominator degree', () {
      test('x / x^2', () {
        final result =
            Algebraic.fromReal([1, 0]) / Algebraic.fromReal([1, 0, 0]);

        expect(result.quotient, equals(Algebraic.fromReal([0])));
        expect(result.remainder, equals(Algebraic.fromReal([1, 0])));
      });

      test('7 / (x + 1)', () {
        final result = Algebraic.fromReal([7]) / Algebraic.fromReal([1, 1]);

        expect(result.quotient, equals(Algebraic.fromReal([0])));
        expect(result.remainder, equals(Algebraic.fromReal([7])));
      });

      test('0 / (x + 1)', () {
        final result = Algebraic.fromReal([0]) / Algebraic.fromReal([1, 1]);

        expect(result.quotient, equals(Algebraic.fromReal([0])));
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('0 / (x^5 - 2x + 1)', () {
        final result =
            Algebraic.fromReal([0]) / Algebraic.fromReal([1, 0, 0, 0, -2, 1]);

        expect(result.quotient, equals(Algebraic.fromReal([0])));
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('0 / 5', () {
        final result = Algebraic.fromReal([0]) / Algebraic.fromReal([5]);

        expect(result.quotient, equals(Algebraic.fromReal([0])));
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('The result types are normalized', () {
        final result = PolynomialLongDivision(
          polyNumerator: GenericAlgebraic.realEquation(coefficients: [1, 2, 3]),
          polyDenominator: Algebraic.fromReal([1, 0, 0, 0, 0, 0, 1]),
        ).divide();

        expect(result.quotient, isA<Constant>());
        expect(result.remainder, isA<Quadratic>());
        expect(result.remainder, equals(Algebraic.fromReal([1, 2, 3])));
      });
    });

    group('Constant denominators', () {
      test('(4x^2 + 2x + 6) / 2', () {
        final result = Algebraic.fromReal([4, 2, 6]) / Algebraic.fromReal([2]);

        expect(result.quotient, equals(Algebraic.fromReal([2, 1, 3])));
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('(x^3 - 2x) / -4', () {
        final result =
            Algebraic.fromReal([1, 0, -2, 0]) / Algebraic.fromReal([-4]);

        expect(
          result.quotient,
          equals(Algebraic.fromReal([-0.25, 0, 0.5, 0])),
        );
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('(3 + 4i) / (1 + 2i)', () {
        final result =
            Algebraic.from(const [Complex(3, 4)]) /
            Algebraic.from(const [Complex(1, 2)]);

        expect(result.quotient, isA<Constant>());
        expect(result.quotient.coefficients.single.real, closeTo(2.2, 1e-12));
        expect(
          result.quotient.coefficients.single.imaginary,
          closeTo(-0.4, 1e-12),
        );
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('(x^2 + ix + 1) / i', () {
        final result =
            Algebraic.from(const [
              Complex.fromReal(1),
              Complex.i(),
              Complex.fromReal(1),
            ]) /
            Algebraic.from(const [Complex.i()]);

        expect(
          result.quotient,
          equals(
            Algebraic.from(const [
              Complex(0, -1),
              Complex.fromReal(1),
              Complex(0, -1),
            ]),
          ),
        );
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });
    });

    group('Denominators of degree 2 or higher', () {
      test('(2x^3 + 3x^2 + 3x + 1) / (x^2 + x + 1)', () {
        final result =
            Algebraic.fromReal([2, 3, 3, 1]) / Algebraic.fromReal([1, 1, 1]);

        expect(result.quotient, equals(Algebraic.fromReal([2, 1])));
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('x^3 / (x^2 + 1)', () {
        final result =
            Algebraic.fromReal([1, 0, 0, 0]) / Algebraic.fromReal([1, 0, 1]);

        expect(result.quotient, equals(Algebraic.fromReal([1, 0])));
        expect(result.remainder, equals(Algebraic.fromReal([-1, 0])));
      });

      test('(x^3 + 1) / x^2', () {
        final result =
            Algebraic.fromReal([1, 0, 0, 1]) / Algebraic.fromReal([1, 0, 0]);

        expect(result.quotient, equals(Algebraic.fromReal([1, 0])));
        expect(result.remainder, equals(Algebraic.fromReal([1])));
      });

      test('(x^4 - 1) / (x^2 + 1)', () {
        final result =
            Algebraic.fromReal([1, 0, 0, 0, -1]) /
            Algebraic.fromReal([1, 0, 1]);

        expect(result.quotient, equals(Algebraic.fromReal([1, 0, -1])));
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('(x^4 + x + 1) / x^3', () {
        final result =
            Algebraic.fromReal([1, 0, 0, 1, 1]) /
            Algebraic.fromReal([1, 0, 0, 0]);

        expect(result.quotient, equals(Algebraic.fromReal([1, 0])));
        expect(result.remainder, equals(Algebraic.fromReal([1, 1])));
      });

      test('(x^5 + x^2 + 1) / (x^3 + 1) drops two leading zeros', () {
        final result =
            Algebraic.fromReal([1, 0, 0, 1, 0, 1]) /
            Algebraic.fromReal([1, 0, 0, 1]);

        expect(result.quotient, equals(Algebraic.fromReal([1, 0, 0])));
        expect(result.remainder, equals(Algebraic.fromReal([1])));
      });

      test('(x^3 - 1) / (x^3 + x)', () {
        final result =
            Algebraic.fromReal([1, 0, 0, -1]) /
            Algebraic.fromReal([1, 0, 1, 0]);

        expect(result.quotient, equals(Algebraic.fromReal([1])));
        expect(result.remainder, equals(Algebraic.fromReal([-1, -1])));
      });

      test('(x^5 + 2x^4 - x + 7) / (x^3 - x + 2)', () {
        final result =
            Algebraic.fromReal([1, 2, 0, 0, -1, 7]) /
            Algebraic.fromReal([1, 0, -1, 2]);

        expect(result.quotient, equals(Algebraic.fromReal([1, 2, 1])));
        expect(result.remainder, equals(Algebraic.fromReal([-4, 5])));
      });

      test('(6x^4 + 5x^3 - 4x^2 + 3x - 2) / (2x^2 + x - 1)', () {
        final result =
            Algebraic.fromReal([6, 5, -4, 3, -2]) /
            Algebraic.fromReal([2, 1, -1]);

        expect(result.quotient, equals(Algebraic.fromReal([3, 1, -1])));
        expect(result.remainder, equals(Algebraic.fromReal([5, -3])));
      });

      test('(3x^7 - 2x^5 + 5x^2 + x - 4) / (4x^3 - 2x^2 + 1)', () {
        final result =
            Algebraic.fromReal([3, 0, -2, 0, 0, 5, 1, -4]) /
            Algebraic.fromReal([4, -2, 0, 1]);

        expect(
          result.quotient,
          equals(
            Algebraic.fromReal([0.75, 0.375, -0.3125, -0.34375, -0.265625]),
          ),
        );
        expect(
          result.remainder,
          equals(Algebraic.fromReal([4.78125, 1.34375, -3.734375])),
        );
      });

      test('(x^8 - 1) / (x^4 + 1)', () {
        final result =
            Algebraic.fromReal([1, 0, 0, 0, 0, 0, 0, 0, -1]) /
            Algebraic.fromReal([1, 0, 0, 0, 1]);

        expect(result.quotient, equals(Algebraic.fromReal([1, 0, 0, 0, -1])));
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('(x^10 - 1) / (x^4 + x^2 + 1)', () {
        final result =
            Algebraic.fromReal([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]) /
            Algebraic.fromReal([1, 0, 1, 0, 1]);

        expect(
          result.quotient,
          equals(Algebraic.fromReal([1, 0, -1, 0, 0, 0, 1])),
        );
        expect(result.remainder, equals(Algebraic.fromReal([-1, 0, -2])));
      });

      test('Equal polynomials with a non-unit leading coefficient', () {
        final result =
            Algebraic.fromReal([2, 0, 4]) / Algebraic.fromReal([2, 0, 4]);

        expect(result.quotient, equals(Algebraic.fromReal([1])));
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('Numerator is a multiple of the denominator', () {
        final result =
            Algebraic.fromReal([6, 3, 0]) / Algebraic.fromReal([2, 1, 0]);

        expect(result.quotient, equals(Algebraic.fromReal([3])));
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('Same degree, non-zero remainder', () {
        // (2x^2 + 3x + 4) = 2 * (x^2 + x + 1) + (x + 2)
        final result =
            Algebraic.fromReal([2, 3, 4]) / Algebraic.fromReal([1, 1, 1]);

        expect(result.quotient, equals(Algebraic.fromReal([2])));
        expect(result.remainder, equals(Algebraic.fromReal([1, 2])));
      });

      test('Quotient and remainder types follow their degree', () {
        final result =
            Algebraic.fromReal([1, 0, 0, 0, 0, 0, 0, 0, 0, 0, -1]) /
            Algebraic.fromReal([1, 0, 1, 0, 1]);

        expect(result.quotient, isA<GenericAlgebraic>());
        expect(result.remainder, isA<Quadratic>());
      });
    });

    group('Complex coefficients', () {
      test('(x^2 + 1) / (x - i)', () {
        final result =
            Algebraic.fromReal([1, 0, 1]) /
            Algebraic.from(const [Complex.fromReal(1), Complex(0, -1)]);

        expect(
          result.quotient,
          equals(Algebraic.from(const [Complex.fromReal(1), Complex.i()])),
        );
        expect(result.remainder, equals(Algebraic.fromReal([0])));
      });

      test('(x^3 + i) / (x^2 + ix)', () {
        final result =
            Algebraic.from(const [
              Complex.fromReal(1),
              Complex.zero(),
              Complex.zero(),
              Complex.i(),
            ]) /
            Algebraic.from(const [
              Complex.fromReal(1),
              Complex.i(),
              Complex.zero(),
            ]);

        expect(
          result.quotient,
          equals(Algebraic.from(const [Complex.fromReal(1), Complex(0, -1)])),
        );
        expect(
          result.remainder,
          equals(Algebraic.from(const [Complex.fromReal(-1), Complex.i()])),
        );
      });

      test('Non-unit complex leading coefficient', () {
        final numerator = Algebraic.from(const [
          Complex(2, -1),
          Complex(0, 3),
          Complex.fromReal(-4),
          Complex(1, 1),
          Complex.fromReal(5),
        ]);
        final denominator = Algebraic.from(const [
          Complex(1, 1),
          Complex.fromReal(2),
          Complex(0, -1),
        ]);

        expectValidDivision(
          numerator,
          denominator,
          numerator / denominator,
          tolerance: 1e-12,
        );
      });
    });

    group('Consistency', () {
      test('The / operator is the same as divide()', () {
        final numerator = Algebraic.fromReal([3, 0, -2, 0, 0, 5, 1, -4]);
        final denominator = Algebraic.fromReal([4, -2, 0, 1]);

        expect(
          numerator / denominator,
          equals(
            PolynomialLongDivision(
              polyNumerator: numerator,
              polyDenominator: denominator,
            ).divide(),
          ),
        );
      });

      test('divide() can be called multiple times', () {
        final division = PolynomialLongDivision(
          polyNumerator: Algebraic.fromReal([1, 0, 0, 0, -1]),
          polyDenominator: Algebraic.fromReal([1, 0, 1]),
        );

        expect(division.divide(), equals(division.divide()));
        expect(
          division.polyNumerator,
          equals(Algebraic.fromReal([1, 0, 0, 0, -1])),
        );
      });

      test('The operands are not modified', () {
        final coefficients = [
          const Complex.fromReal(1),
          const Complex.fromReal(2),
          const Complex.fromReal(3),
          const Complex.fromReal(4),
          const Complex.fromReal(5),
        ];
        final numerator = Algebraic.from(coefficients);
        final denominator = Algebraic.fromReal([1, 1]);

        final _ = numerator / denominator;

        expect(
          coefficients,
          equals(Algebraic.fromReal([1, 2, 3, 4, 5]).coefficients),
        );
        expect(numerator, equals(Algebraic.fromReal([1, 2, 3, 4, 5])));
        expect(denominator, equals(Algebraic.fromReal([1, 1])));
      });
    });

    group('Randomized identity checks (N = Q * D + R)', () {
      test('Integer coefficients, exact results', () {
        // A leading coefficient of 1, 2 or 4 keeps every operation exact
        final random = Random(42);
        const leadingCoefficients = [1, -1, 2, -2, 4, -4];

        for (var t = 0; t < 300; ++t) {
          final denominatorDegree = random.nextInt(5);
          final numeratorDegree = random.nextInt(8);
          final numerator = randomIntegerPolynomial(random, numeratorDegree);
          final denominator = randomIntegerPolynomial(
            random,
            denominatorDegree,
            leading: leadingCoefficients[random.nextInt(6)],
          );

          final result = numerator / denominator;

          expectValidDivision(numerator, denominator, result);
          if (numeratorDegree >= denominatorDegree) {
            expect(
              result.quotient.degree,
              equals(numeratorDegree - denominatorDegree),
            );
          } else {
            expect(result.quotient, equals(Algebraic.fromReal([0])));
            expect(result.remainder, equals(numerator));
          }
        }
      });

      test('Complex coefficients', () {
        final random = Random(7);

        for (var t = 0; t < 300; ++t) {
          final numerator = randomComplexPolynomial(random, random.nextInt(10));
          final denominator = randomComplexPolynomial(
            random,
            random.nextInt(6),
          );

          expectValidDivision(
            numerator,
            denominator,
            numerator / denominator,
            tolerance: 1e-9,
          );
        }
      });

      test('Multiplying and dividing gives back the factor', () {
        final random = Random(1234);

        for (var t = 0; t < 100; ++t) {
          final a = randomIntegerPolynomial(random, random.nextInt(5));
          final b = randomIntegerPolynomial(
            random,
            random.nextInt(5),
            leading: 1,
          );

          final result = (a * b) / b;

          expect(result.quotient, equals(a));
          expect(result.remainder, equals(Algebraic.fromReal([0])));
        }
      });
    });
  });
}

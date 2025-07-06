import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('Generic Algebraic', () {
    test('Object construction', () {
      final equation = GenericAlgebraic(
        coefficients: const [Complex.i(), Complex.fromReal(3), Complex(5, 6)],
      );

      // Checking properties
      expect(equation.degree, equals(2));
      expect(equation.derivative(), isA<Linear>());
      expect(equation.isRealEquation, isFalse);
      expect(equation.discriminant(), const Complex(33, -20));
      expect(
        equation.coefficients,
        equals(const [Complex.i(), Complex.fromReal(3), Complex(5, 6)]),
      );

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(const Complex.i()));
      expect(equation[1], equals(const Complex.fromReal(3)));
      expect(equation[2], equals(const Complex(5, 6)));

      expect(() => equation[-1], throwsA(isA<RangeError>()));

      expect(equation.coefficient(2), equals(const Complex.i()));
      expect(equation.coefficient(1), equals(const Complex.fromReal(3)));
      expect(equation.coefficient(0), equals(const Complex(5, 6)));
      expect(equation.coefficient(3), isNull);

      // Converting to string
      expect(equation.toString(), equals('f(x) = 1ix^2 + 3x + (5 + 6i)'));
      expect(
        equation.toStringWithFractions(),
        equals('f(x) = 1ix^2 + 3x + (5 + 6i)'),
      );

      // Checking solutions
      final solutions = equation.solutions();

      expect(
        solutions.first.real,
        const MoreOrLessEquals(-0.8357, precision: 1.0e-4),
      );
      expect(
        solutions.first.imaginary,
        const MoreOrLessEquals(-1.4914, precision: 1.0e-4),
      );
      expect(
        solutions[1].real,
        const MoreOrLessEquals(0.8357, precision: 1.0e-4),
      );
      expect(
        solutions[1].imaginary,
        const MoreOrLessEquals(4.4914, precision: 1.0e-4),
      );

      // Evaluation
      final eval = equation.realEvaluateOn(2);
      expect(eval, equals(const Complex(11, 10)));
    });

    test('Constant polynomial', () {
      final noSolutions = GenericAlgebraic.realEquation(coefficients: [1]);

      expect(noSolutions.solutions().length, isZero);
    });

    test('realEquation constructor', () {
      final genericAlgebraic = GenericAlgebraic.realEquation(
        coefficients: [1, 2, 3],
      );

      expect(genericAlgebraic[0], equals(const Complex.fromReal(1)));
      expect(genericAlgebraic[1], equals(const Complex.fromReal(2)));
      expect(genericAlgebraic[2], equals(const Complex.fromReal(3)));

      // There must be an exception is the first coeff. is zero
      expect(
        () => GenericAlgebraic.realEquation(coefficients: [0, 3, 6]),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('Exception is thrown if the coeff. of the highest degree is zero', () {
      expect(
        () => GenericAlgebraic(coefficients: const [Complex.zero()]),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('Derivatives types', () {
      final polynomialDegree6 = GenericAlgebraic.realEquation(
        coefficients: [1, 2, 3, 4, 5, 6, 7],
      );
      final polynomialDegree5 = GenericAlgebraic.realEquation(
        coefficients: [1, 2, 3, 4, 5, 6],
      );
      final polynomialDegree4 = GenericAlgebraic.realEquation(
        coefficients: [1, 2, 3, 4, 5],
      );
      final polynomialDegree3 = GenericAlgebraic.realEquation(
        coefficients: [1, 2, 3, 4],
      );
      final polynomialDegree2 = GenericAlgebraic.realEquation(
        coefficients: [1, 2, 3],
      );
      final polynomialDegree1 = GenericAlgebraic.realEquation(
        coefficients: [1, 2],
      );
      final polynomialDegree0 = GenericAlgebraic.realEquation(
        coefficients: [1],
      );

      expect(polynomialDegree6.derivative(), isA<GenericAlgebraic>());
      expect(polynomialDegree5.derivative(), isA<Quartic>());
      expect(polynomialDegree4.derivative(), isA<Cubic>());
      expect(polynomialDegree3.derivative(), isA<Quadratic>());
      expect(polynomialDegree2.derivative(), isA<Linear>());
      expect(polynomialDegree1.derivative(), isA<Constant>());
      expect(polynomialDegree0.derivative(), isA<Constant>());
    });

    test('Derivatives', () {
      final genericAlgebraic1 = GenericAlgebraic.realEquation(
        coefficients: [2, 0, -2, 0, 7, 0],
      );

      expect(
        genericAlgebraic1.derivative(),
        equals(Algebraic.fromReal([10, 0, -6, 0, 7])),
      );
      expect(genericAlgebraic1.discriminant().real, equals(29679104));
      expect(genericAlgebraic1.discriminant().imaginary, isZero);

      final genericAlgebraic2 = GenericAlgebraic.realEquation(
        coefficients: [1, -5, 2, -2, 0, 7, 13],
      );

      expect(
        genericAlgebraic2.derivative(),
        equals(Algebraic.fromReal([6, -25, 8, -6, 0, 7])),
      );
      expect(
        genericAlgebraic2.discriminant().real.round(),
        equals(1002484790644),
      );
      expect(genericAlgebraic2.discriminant().imaginary, isZero);
    });

    test('Objects comparison', () {
      final fx = GenericAlgebraic.realEquation(coefficients: [1, 2, 3, 4, 5]);
      final otherFx = GenericAlgebraic.realEquation(
        coefficients: [1, 2, 3, 4, 5],
      );

      final notEqual = GenericAlgebraic.realEquation(
        coefficients: [1, 2, 3, 4, 5],
        initialGuess: List<Complex>.generate(4, (_) => const Complex.zero()),
      );

      expect(fx, equals(otherFx));
      expect(fx == otherFx, isTrue);
      expect(otherFx, equals(fx));
      expect(otherFx == fx, isTrue);

      expect(
        fx,
        equals(GenericAlgebraic.realEquation(coefficients: [1, 2, 3, 4, 5])),
      );
      expect(
        GenericAlgebraic.realEquation(coefficients: [1, 2, 3, 4, 5]),
        equals(fx),
      );

      expect(fx.hashCode, equals(otherFx.hashCode));

      expect(fx == notEqual, isFalse);
      expect(fx.hashCode == notEqual.hashCode, isFalse);

      expect(
        GenericAlgebraic(
          coefficients: const [
            Complex(3, -2),
            Complex.zero(),
            Complex.fromReal(7),
          ],
          initialGuess: const [Complex(3, 2), Complex.fromImaginary(8)],
        ),
        equals(
          GenericAlgebraic(
            coefficients: const [
              Complex(3, -2),
              Complex.zero(),
              Complex.fromReal(7),
            ],
            initialGuess: const [Complex(3, 2), Complex.fromImaginary(8)],
          ),
        ),
      );
    });

    test('copyWith', () {
      final genericAlgebraic = GenericAlgebraic.realEquation(
        coefficients: [1, 2, 3],
      );

      // Objects equality
      expect(genericAlgebraic, equals(genericAlgebraic.copyWith()));
      expect(
        genericAlgebraic,
        equals(genericAlgebraic.copyWith(maxSteps: 2000)),
      );

      // Objects inequality
      expect(
        genericAlgebraic == genericAlgebraic.copyWith(maxSteps: 1),
        isFalse,
      );
    });

    test('Testing validation of coefficients', () {
      // Test empty coefficients
      expect(
        () => GenericAlgebraic(coefficients: []),
        throwsA(isA<AlgebraicException>()),
      );

      // Test zero leading coefficient
      expect(
        () => GenericAlgebraic(
          coefficients: const [Complex.zero(), Complex.fromReal(1)],
        ),
        throwsA(isA<AlgebraicException>()),
      );

      // Test real equation with zero leading coefficient
      expect(
        () => GenericAlgebraic.realEquation(coefficients: [0, 1]),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('Convergence criteria', () {
      final equation = GenericAlgebraic(
        coefficients: const [
          Complex.fromReal(1),
          Complex.fromReal(-5),
          Complex.fromReal(6),
        ],
      );

      final solutions = equation.solutions();
      expect(solutions.length, equals(2));
    });

    test('Root clustering for multiple roots', () {
      // Test polynomial with multiple roots: (x-2)^3
      final equation = GenericAlgebraic(
        coefficients: const [
          Complex.fromReal(1),
          Complex.fromReal(-6),
          Complex.fromReal(12),
          Complex.fromReal(-8),
        ],
      );

      final solutions = equation.solutions();
      expect(solutions.length, equals(3));

      // All roots should be close to 2
      for (final solution in solutions) {
        expect(solution.real.round(), equals(2));
        expect(solution.imaginary.round(), isZero);
      }
    });

    test('Numerical stability', () {
      // Test polynomial with very small coefficients
      final equation = GenericAlgebraic(
        coefficients: const [
          Complex.fromReal(1.0e-12),
          Complex.fromReal(1.0e-13),
          Complex.fromReal(1.0e-12),
        ],
      );

      expect(equation.solutions, throwsA(isA<AlgebraicException>()));
    });

    test('Custom initial guesses', () {
      final equation = GenericAlgebraic(
        coefficients: const [
          Complex.fromReal(1),
          Complex.fromReal(-5),
          Complex.fromReal(6),
        ],
        initialGuess: const [Complex.fromReal(2.5), Complex.fromReal(2.5)],
      );

      final solutions = equation.solutions();
      expect(solutions.length, equals(2));
    });

    test('Edge cases', () {
      // Test with very high degree polynomial
      final highDegree = GenericAlgebraic(
        coefficients: List.generate(10, (i) => Complex.fromReal(i + 1)),
      );
      expect(highDegree.solutions().length, equals(9));

      // Test with very small precision
      final smallPrecision = GenericAlgebraic(
        coefficients: const [Complex.fromReal(1), Complex.fromReal(2)],
        precision: 1.0e-20,
      );
      expect(smallPrecision.solutions().length, equals(1));

      // Test with very large maxSteps
      final largeMaxSteps = GenericAlgebraic(
        coefficients: const [Complex.fromReal(1), Complex.fromReal(2)],
        maxSteps: 10000,
      );
      expect(largeMaxSteps.solutions().length, equals(1));
    });

    group('Solutions tests', () {
      void verifyGenericAlgebraicSolutions(
        GenericAlgebraic equation,
        List<Complex> expectedSolutions,
      ) {
        final solutions = equation.solutions();
        expect(solutions.length, equals(equation.coefficients.length - 1));

        // Keep track of which expected solutions have been matched
        final matchedExpected = List<bool>.filled(
          expectedSolutions.length,
          false,
        );

        // For each found solution
        for (final solution in solutions) {
          var foundMatch = false;

          // Try to match it with any unmatched expected solution
          for (var i = 0; i < expectedSolutions.length; i++) {
            if (!matchedExpected[i] &&
                MoreOrLessEquals(
                  expectedSolutions[i].real,
                  precision: 1.0e-5,
                ).matches(solution.real, {}) &&
                MoreOrLessEquals(
                  expectedSolutions[i].imaginary,
                  precision: 1.0e-5,
                ).matches(solution.imaginary, {})) {
              matchedExpected[i] = true;
              foundMatch = true;
              break;
            }
          }

          // If no match was found, fail the test
          expect(
            foundMatch,
            isTrue,
            reason: 'Solution $solution did not match any expected solution',
          );
        }

        // Verify all expected solutions were matched
        expect(
          matchedExpected.every((matched) => matched),
          isTrue,
          reason: 'Not all expected solutions were matched',
        );
      }

      test('Test 1', () {
        final equation = GenericAlgebraic.realEquation(
          coefficients: [2, 3, -11, -6],
        );
        verifyGenericAlgebraicSolutions(equation, const [
          Complex.fromReal(-3),
          Complex.fromReal(-0.5),
          Complex.fromReal(2),
        ]);
      });

      test('Test 2', () {
        final equation = GenericAlgebraic.realEquation(
          coefficients: [1, -5, 2, -2, 0, 7, 13],
          precision: 1.0e-15,
        );
        verifyGenericAlgebraicSolutions(equation, const [
          Complex(-0.82299, 0.54911),
          Complex(-0.82299, -0.54911),
          Complex(0.25017, 1.35612),
          Complex(0.25017, -1.35612),
          Complex(1.50487, 0),
          Complex(4.64077, 0),
        ]);
      });

      test('Test 3', () {
        final equation = GenericAlgebraic.realEquation(
          coefficients: [2, 1, -2, 1, 7],
          precision: 1.0e-15,
        );
        verifyGenericAlgebraicSolutions(equation, const [
          Complex(-1.22152, 0.693491),
          Complex(-1.22152, -0.693491),
          Complex(0.97152, 0.91106),
          Complex(0.97152, -0.91106),
        ]);
      });

      test('Test 4', () {
        final equation = GenericAlgebraic(
          coefficients: const [
            Complex(3, -2),
            Complex.zero(),
            Complex.fromReal(7),
            Complex.fromReal(-1),
          ],
        );
        verifyGenericAlgebraicSolutions(equation, const [
          Complex(-0.47308, 1.33835),
          Complex(0.14162, 0.00079),
          Complex(0.33146, -1.33914),
        ]);
      });

      test('Test 5', () {
        final equation = GenericAlgebraic(
          coefficients: const [
            Complex.fromReal(1),
            Complex.zero(),
            Complex.i(),
            Complex.zero(),
            Complex.zero(),
            Complex(1, -6),
          ],
        );
        verifyGenericAlgebraicSolutions(equation, const [
          Complex(-1.40832, 0.54238),
          Complex(-0.70223, -1.11291),
          Complex(-0.18806, 1.42498),
          Complex(1.00340, -1.22343),
          Complex(1.29521, 0.36898),
        ]);
      });

      test('Test 6', () {
        final equation = GenericAlgebraic.realEquation(
          coefficients: [12, 5, -8, 6, -3, 14, 22, -1, 4],
        );
        verifyGenericAlgebraicSolutions(equation, const [
          Complex(-1.14661, -0.05096),
          Complex(-1.14661, 0.05096),
          Complex(-0.13933, 1.03116),
          Complex(-0.13933, -1.03116),
          Complex(0.06712, -0.40317),
          Complex(0.06712, 0.40317),
          Complex(1.01050, 0.61469),
          Complex(1.01050, -0.61469),
        ]);
      });
    });
  });
}

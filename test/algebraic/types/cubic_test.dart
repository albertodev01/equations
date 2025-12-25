import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('Cubic', () {
    test('Object construction', () {
      final equation = Cubic(
        a: const Complex.fromReal(-1),
        c: const Complex.fromReal(5),
        d: const Complex.fromReal(-9),
      );

      // Checking properties
      expect(equation.degree, equals(3));
      expect(
        equation.derivative(),
        Quadratic(a: const Complex.fromReal(-3), c: const Complex.fromReal(5)),
      );
      expect(equation.isRealEquation, isTrue);
      expect(equation.discriminant(), equals(const Complex.fromReal(-1687)));
      expect(
        equation.coefficients,
        equals(const [
          Complex.fromReal(-1),
          Complex.zero(),
          Complex.fromReal(5),
          Complex.fromReal(-9),
        ]),
      );

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(const Complex.fromReal(-1)));
      expect(equation[1], equals(const Complex.zero()));
      expect(equation[2], equals(const Complex.fromReal(5)));
      expect(equation[3], equals(const Complex.fromReal(-9)));

      expect(() => equation[-1], throwsA(isA<RangeError>()));

      expect(equation.coefficient(3), equals(const Complex.fromReal(-1)));
      expect(equation.coefficient(2), equals(const Complex.zero()));
      expect(equation.coefficient(1), equals(const Complex.fromReal(5)));
      expect(equation.coefficient(0), equals(const Complex.fromReal(-9)));
      expect(equation.coefficient(4), isNull);

      // Converting to string
      expect(equation.toString(), equals('f(x) = -1x^3 + 5x + -9'));
      expect(
        equation.toStringWithFractions(),
        equals('f(x) = -1x^3 + 5x + -9'),
      );

      // Checking solutions
      final solutions = equation.solutions();
      expect(solutions[2].real, const MoreOrLessEquals(1.42759826966));
      expect(solutions[2].imaginary, const MoreOrLessEquals(-1.05551430999854));
      expect(solutions[1].real, const MoreOrLessEquals(-2.855196539321));
      expect(solutions[1].imaginary.round(), isZero);
      expect(solutions.first.real, const MoreOrLessEquals(1.42759826966));
      expect(
        solutions.first.imaginary,
        const MoreOrLessEquals(1.0555143099985407),
      );

      // Evaluation
      final eval = equation.realEvaluateOn(0.5);
      expect(eval, Complex.fromRealFraction(Fraction(-53, 8)));
    });

    test('realEquation constructor', () {
      final cubic = Cubic.realEquation(a: 5, b: 1, c: -6);

      expect(cubic.a, equals(const Complex.fromReal(5)));
      expect(cubic.b, equals(const Complex.fromReal(1)));
      expect(cubic.c, equals(const Complex.fromReal(-6)));
      expect(cubic.d, equals(const Complex.zero()));

      // There must be an exception is the first coeff. is zero
      expect(
        () => Cubic.realEquation(a: 0),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('Exception is thrown if the coeff. of the highest degree is zero', () {
      expect(
        () => Cubic(a: const Complex.zero()),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('Objects comparison works properly', () {
      final fx = Cubic(
        a: const Complex(2, -3),
        b: Complex.fromImaginaryFraction(Fraction(6, 5)),
        c: const Complex(5, -1),
        d: const Complex(-9, -6),
      );

      final otherFx = Cubic(
        a: const Complex(2, -3),
        b: Complex.fromImaginaryFraction(Fraction(6, 5)),
        c: const Complex(5, -1),
        d: const Complex(-9, -6),
      );

      expect(fx, equals(otherFx));
      expect(otherFx, equals(fx));
      expect(fx == otherFx, isTrue);
      expect(otherFx == fx, isTrue);

      expect(
        fx,
        equals(
          Cubic(
            a: const Complex(2, -3),
            b: Complex.fromImaginaryFraction(Fraction(6, 5)),
            c: const Complex(5, -1),
            d: const Complex(-9, -6),
          ),
        ),
      );
      expect(
        Cubic(
          a: const Complex(2, -3),
          b: Complex.fromImaginaryFraction(Fraction(6, 5)),
          c: const Complex(5, -1),
          d: const Complex(-9, -6),
        ),
        equals(fx),
      );

      expect(fx.hashCode, equals(otherFx.hashCode));
    });

    test('copyWith', () {
      final cubic = Cubic.realEquation(a: 7, c: 13);

      // Objects equality
      expect(cubic, equals(cubic.copyWith()));
      expect(
        cubic,
        equals(
          cubic.copyWith(
            a: const Complex(7, 0),
            c: const Complex(13, 0),
          ),
        ),
      );

      // Objects inequality
      expect(cubic == cubic.copyWith(b: const Complex.fromReal(7)), isFalse);
    });

    test('Regression: Ax^3 + D case is correctly handled', () {
      final cubic = Cubic.realEquation(d: -1).solutions();

      expect(cubic.first, equals(const Complex(1, 0)));
      expect(cubic[1], equals(Complex(-1 / 2, sqrt(3) / 2)));
      expect(cubic.last, equals(Complex(-0.4999999999999995, -sqrt(3) / 2)));
    });

    test('Edge cases and numerical stability', () {
      // Test very small coefficient
      expect(
        () => Cubic(a: const Complex.fromReal(1e-11)),
        throwsA(isA<AlgebraicException>()),
      );

      // Test zero coefficient
      expect(
        () => Cubic(a: const Complex.zero()),
        throwsA(isA<AlgebraicException>()),
      );

      // Test triple root case (discriminant near zero)
      final tripleRoot = Cubic(
        b: const Complex.fromReal(-3),
        c: const Complex.fromReal(3),
        d: const Complex.fromReal(-1),
      );
      final tripleRootSolutions = tripleRoot.solutions();
      expect(tripleRootSolutions.length, 3);
      expect(tripleRootSolutions[0], tripleRootSolutions[1]);
      expect(tripleRootSolutions[1], tripleRootSolutions[2]);

      // Test double root case
      final doubleRoot = Cubic(
        b: const Complex.fromReal(-3),
        c: const Complex.fromReal(3),
        d: const Complex.fromReal(-1.0001),
      );
      final doubleRootSolutions = doubleRoot.solutions();
      expect(doubleRootSolutions.length, 3);
      expect(doubleRootSolutions[0], isNot(doubleRootSolutions[2]));
    });

    test('Depressed cubic case', () {
      final depressed = Cubic(d: const Complex.fromReal(-8));
      final solutions = depressed.solutions();
      expect(solutions.length, 3);

      // Solutions should be 2, -1 + i*sqrt(3), -1 - i*sqrt(3)
      expect(solutions[0].real, closeTo(2, 1e-10));
      expect(solutions[1].real, closeTo(-1, 1e-10));
      expect(solutions[1].imaginary, closeTo(sqrt(3), 1e-10));
      expect(solutions[2].real, closeTo(-1, 1e-10));
      expect(solutions[2].imaginary, closeTo(-sqrt(3), 1e-10));
    });

    test('Large coefficients', () {
      final large = Cubic(
        a: const Complex.fromReal(10000000000),
        b: const Complex.fromReal(100000000),
        c: const Complex.fromReal(1000000),
        d: const Complex.fromReal(10000),
      );
      final solutions = large.solutions();
      expect(solutions.length, 3);

      // Verify that solutions are reasonable
      for (final solution in solutions) {
        expect(solution.abs(), lessThan(1e10));
      }
    });

    group('Solutions tests', () {
      void verifyCubicSolutions(
        Cubic equation,
        List<Complex> expectedSolutions,
      ) {
        final solutions = equation.solutions();
        expect(solutions.length, equals(3));

        for (var i = 0; i < 3; ++i) {
          expect(
            solutions[i].real,
            MoreOrLessEquals(expectedSolutions[i].real, precision: 1.0e-5),
          );
          expect(
            solutions[i].imaginary,
            MoreOrLessEquals(expectedSolutions[i].imaginary, precision: 1.0e-5),
          );
        }
      }

      test('Test 1', () {
        final equation = Cubic.realEquation(a: 2, b: 3, c: -11, d: -6);
        verifyCubicSolutions(equation, const [
          Complex.fromReal(-0.5),
          Complex.fromReal(2),
          Complex.fromReal(-3),
        ]);
      });

      test('Test 2', () {
        final equation = Cubic(
          a: const Complex.i(),
          c: const Complex(-2, 5),
          d: const Complex.fromReal(7),
        );
        verifyCubicSolutions(equation, const [
          Complex(-1.04472, 1.77929),
          Complex(0.31133, -2.75745),
          Complex(0.73338, 0.97815),
        ]);
      });

      test('Test 3', () {
        final equation = Cubic.realEquation(a: -4, c: 8);
        verifyCubicSolutions(equation, const [
          Complex.zero(),
          Complex.fromReal(-1.41421),
          Complex.fromReal(1.41421),
        ]);
      });

      test('Test 4', () {
        final equation = Cubic.realEquation(b: 1, c: 1, d: 1);
        verifyCubicSolutions(equation, const [
          Complex.fromReal(-1),
          Complex.fromImaginary(-1),
          Complex.i(),
        ]);
      });

      test('Test 5', () {
        final equation = Cubic(a: const Complex.i(), b: const Complex(5, -8));
        verifyCubicSolutions(equation, const [
          Complex.zero(),
          Complex.zero(),
          Complex(8, 5),
        ]);
      });

      test('Test 6', () {
        final equation = Cubic(
          a: const Complex.fromReal(5),
          d: const Complex.fromReal(3),
        );
        verifyCubicSolutions(equation, const [
          Complex(0.42172, 0.73043),
          Complex.fromReal(-0.84343),
          Complex(0.42172, -0.73043),
        ]);
      });

      test('Test 7', () {
        final equation = Cubic(a: const Complex(-6, 2), d: const Complex.i());
        verifyCubicSolutions(equation, const [
          Complex(0.43666, 0.31895),
          Complex(-0.49455, 0.21869),
          Complex(0.05788, -0.53763),
        ]);
      });

      test('Test 8', () {
        final equation = Cubic(
          a: const Complex(1, 1),
          d: const Complex(-1, -1),
        );
        verifyCubicSolutions(equation, const [
          Complex(1, 0),
          Complex(-0.5, 0.86603),
          Complex(-0.4999999999999995, -0.86603),
        ]);
      });

      test('Test 9', () {
        final equation = Cubic(
          a: const Complex(1, 1),
          b: const Complex(-2, 1),
          c: const Complex(1, -2),
          d: const Complex(-1, 1),
        );
        verifyCubicSolutions(equation, const [
          Complex(-0.76278, -1.44625),
          Complex(0.95294, -0.52328),
          Complex(0.30983, 0.46953),
        ]);
      });

      test('Test 10', () {
        final equation = Cubic.realEquation(b: -3, c: 3, d: -1);
        verifyCubicSolutions(equation, const [
          Complex.fromReal(1),
          Complex.fromReal(1),
          Complex.fromReal(1),
        ]);
      });
    });
  });
}

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('Quadratic', () {
    test('Object construction', () {
      final equation = Quadratic(
        a: const Complex.fromReal(2),
        b: const Complex.fromReal(-5),
        c: Complex.fromRealFraction(Fraction(3, 2)),
      );

      // Checking properties
      expect(equation.degree, equals(2));
      expect(
        equation.derivative(),
        Linear(a: const Complex.fromReal(4), b: const Complex.fromReal(-5)),
      );
      expect(equation.isRealEquation, isTrue);
      expect(equation.discriminant(), equals(const Complex.fromReal(13)));
      expect(
        equation.coefficients,
        equals([
          const Complex.fromReal(2),
          const Complex.fromReal(-5),
          Complex.fromRealFraction(Fraction(3, 2)),
        ]),
      );

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(const Complex.fromReal(2)));
      expect(equation[1], equals(const Complex.fromReal(-5)));
      expect(equation[2], equals(Complex.fromRealFraction(Fraction(3, 2))));

      expect(() => equation[-1], throwsA(isA<RangeError>()));

      expect(equation.coefficient(2), equals(const Complex.fromReal(2)));
      expect(equation.coefficient(1), equals(const Complex.fromReal(-5)));
      expect(
        equation.coefficient(0),
        equals(Complex.fromRealFraction(Fraction(3, 2))),
      );
      expect(equation.coefficient(3), isNull);

      // Converting to string
      expect(equation.toString(), equals('f(x) = 2x^2 + -5x + 1.5'));
      expect(
        equation.toStringWithFractions(),
        equals('f(x) = 2x^2 + -5x + 3/2'),
      );

      // Checking solutions
      final solutions = equation.solutions();
      expect(solutions.first.real, const MoreOrLessEquals(2.151387818866));
      expect(solutions.first.imaginary, isZero);
      expect(solutions[1].real, const MoreOrLessEquals(0.348612181134));
      expect(solutions[1].imaginary, isZero);

      // Evaluation
      final eval = equation.realEvaluateOn(Fraction(-2, 5).toDouble());
      expect(eval.real.toStringAsFixed(2), equals('3.82'));
      expect(eval.imaginary.round(), isZero);
    });

    test('Exception is thrown if the coeff. of the highest degree is zero', () {
      expect(
        () => Quadratic(
          a: const Complex.zero(),
          b: const Complex.i(),
          c: const Complex.fromReal(4),
        ),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('realEquation', () {
      final quadratic = Quadratic.realEquation(a: -3, b: 2, c: 1);

      expect(quadratic.a, equals(const Complex.fromReal(-3)));
      expect(quadratic.b, equals(const Complex.fromReal(2)));
      expect(quadratic.c, equals(const Complex.fromReal(1)));

      // There must be an exception is the first coeff. is zero
      expect(
        () => Quadratic.realEquation(a: 0),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('Objects comparison works properly', () {
      final fx = Quadratic(
        a: const Complex(2, 3),
        b: const Complex.i(),
        c: const Complex(-1, 0),
      );

      final otherFx = Quadratic(
        a: const Complex(2, 3),
        b: const Complex.i(),
        c: const Complex(-1, 0),
      );

      expect(fx, equals(otherFx));
      expect(fx == otherFx, isTrue);
      expect(otherFx, equals(fx));
      expect(otherFx == fx, isTrue);

      expect(
        fx,
        equals(
          Quadratic(
            a: const Complex(2, 3),
            b: const Complex.i(),
            c: const Complex(-1, 0),
          ),
        ),
      );
      expect(
        Quadratic(
          a: const Complex(2, 3),
          b: const Complex.i(),
          c: const Complex(-1, 0),
        ),
        equals(fx),
      );
      expect(
        fx ==
            Quadratic(
              a: const Complex(2, 3),
              b: const Complex.i(),
              c: const Complex(-1, 0),
            ),
        isTrue,
      );
      expect(
        Quadratic(
              a: const Complex(2, 3),
              b: const Complex.i(),
              c: const Complex(-1, 0),
            ) ==
            fx,
        isTrue,
      );

      expect(fx.hashCode, equals(otherFx.hashCode));
    });

    test('copyWith', () {
      final quadratic = Quadratic(
        a: const Complex.i(),
        b: const Complex(6, -1),
        c: const Complex.i(),
      );

      // Objects equality
      expect(quadratic, equals(quadratic.copyWith()));
      expect(
        quadratic,
        equals(
          quadratic.copyWith(
            a: const Complex.i(),
            b: const Complex(6, -1),
            c: const Complex.i(),
          ),
        ),
      );

      // Objects inequality
      expect(quadratic == quadratic.copyWith(b: const Complex.zero()), isFalse);
    });

    group('Solutions tests', () {
      void verifyQuadraticSolutions(
        Quadratic equation,
        List<Complex> expectedSolutions,
      ) {
        final solutions = equation.solutions();
        expect(solutions.length, equals(2));

        for (var i = 0; i < 2; ++i) {
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
        final equation = Quadratic.realEquation(a: -3, b: 1 / 5, c: 16);
        verifyQuadraticSolutions(equation, const [
          Complex.fromReal(2.34297),
          Complex.fromReal(-2.2763),
        ]);
      });

      test('Test 2', () {
        final equation = Quadratic.realEquation(b: 5, c: -4);
        verifyQuadraticSolutions(equation, const [
          Complex.fromReal(0.70156),
          Complex.fromReal(-5.70156),
        ]);
      });

      test('Test 3', () {
        final equation = Quadratic(
          a: const Complex(3, 1),
          b: const Complex(2, -7),
        );
        verifyQuadraticSolutions(equation, const [
          Complex(0.09999, 2.3),
          Complex.zero(),
        ]);
      });

      test('Test 4', () {
        final equation = Quadratic();
        verifyQuadraticSolutions(equation, const [
          Complex.zero(),
          Complex.zero(),
        ]);
      });

      test('Test 5', () {
        final equation = Quadratic.realEquation(a: 9, b: 6, c: -6);
        verifyQuadraticSolutions(equation, const [
          Complex.fromReal(0.54858),
          Complex.fromReal(-1.21525),
        ]);
      });

      test('Test 6', () {
        final equation = Quadratic.realEquation(c: -1);
        verifyQuadraticSolutions(equation, const [
          Complex.fromReal(1),
          Complex.fromReal(-1),
        ]);
      });

      test('Test 7', () {
        final equation = Quadratic.realEquation(c: 1);
        verifyQuadraticSolutions(equation, const [
          Complex.fromImaginary(1),
          Complex.fromImaginary(-1),
        ]);
      });

      test('Test 8', () {
        final equation = Quadratic(
          a: const Complex(1, 1),
          b: const Complex(-2, 1),
          c: const Complex(1, -1),
        );
        verifyQuadraticSolutions(equation, const [
          Complex(0.63755, 0.05634),
          Complex(-0.13755, -1.55634),
        ]);
      });

      test('Test 9', () {
        final equation = Quadratic.realEquation(b: -2, c: 1);
        verifyQuadraticSolutions(equation, const [
          Complex.fromReal(1),
          Complex.fromReal(1),
        ]);
      });

      test('Test 10', () {
        final equation = Quadratic(
          a: const Complex.fromReal(1e-10),
          b: const Complex.fromReal(1e-8),
          c: const Complex.fromReal(1e-6),
        );
        verifyQuadraticSolutions(equation, const [
          Complex(-49.99999, 86.60254),
          Complex(-50, -86.60254),
        ]);
      });

      test('Test 11', () {
        final equation = Quadratic.realEquation(
          a: 10000000000,
          b: 100000000,
          c: 1000000,
        );
        verifyQuadraticSolutions(equation, const [
          Complex(-0.00499, 0.00866),
          Complex(-0.005, -0.00866),
        ]);
      });
    });
  });
}

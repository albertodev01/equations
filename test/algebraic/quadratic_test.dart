import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing 'Quadratic' algebraic equations", () {
    test("Making sure that a 'Quadratic' object is properly constructed", () {
      final equation = Quadratic(
        a: const Complex.fromReal(2),
        b: const Complex.fromReal(-5),
        c: Complex.fromRealFraction(Fraction(3, 2)),
      );

      // Checking properties
      expect(equation.degree, equals(2));
      expect(
        equation.derivative(),
        Linear(
          a: const Complex.fromReal(4),
          b: const Complex.fromReal(-5),
        ),
      );
      expect(equation.isRealEquation, isTrue);
      expect(
        equation.discriminant(),
        equals(const Complex.fromReal(13)),
      );
      expect(
        equation.coefficients,
        equals(
          [
            const Complex.fromReal(2),
            const Complex.fromReal(-5),
            Complex.fromRealFraction(Fraction(3, 2)),
          ],
        ),
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

    test(
      'Making sure that an exception is thrown if the coeff. of the '
      'highest degree is zero',
      () {
        expect(
          () => Quadratic(
            a: const Complex.zero(),
            b: const Complex.i(),
            c: const Complex.fromReal(4),
          ),
          throwsA(isA<AlgebraicException>()),
        );
      },
    );

    test(
      "Making sure that a correct 'Quadratic' instance is created from a "
      "list of 'double' (real) values",
      () {
        final quadratic = Quadratic.realEquation(a: -3, b: 2, c: 1);

        expect(quadratic.a, equals(const Complex.fromReal(-3)));
        expect(quadratic.b, equals(const Complex.fromReal(2)));
        expect(quadratic.c, equals(const Complex.fromReal(1)));

        // There must be an exception is the first coeff. is zero
        expect(
          () => Quadratic.realEquation(a: 0),
          throwsA(isA<AlgebraicException>()),
        );
      },
    );

    test('Making sure that objects comparison works properly', () {
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
      expect(fx.hashCode, equals(otherFx.hashCode));
    });

    test("Making sure that 'copyWith' clones objects correctly", () {
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

    test('Batch tests', () {
      final equations = [
        Quadratic.realEquation(a: -3, b: 1 / 5, c: 16).solutions(),
        Quadratic.realEquation(b: 5, c: -4).solutions(),
        Quadratic(
          a: const Complex(3, 1),
          b: const Complex(2, -7),
        ).solutions(),
        Quadratic().solutions(),
        Quadratic.realEquation(a: 9, b: 6, c: -6).solutions(),
      ];

      final solutions = <List<Complex>>[
        const [
          Complex.fromReal(-2.2763),
          Complex.fromReal(2.3429),
        ],
        const [
          Complex.fromReal(0.7015),
          Complex.fromReal(-5.7016),
        ],
        const [
          Complex.zero(),
          Complex(0.1, 2.3),
        ],
        const [
          Complex.zero(),
          Complex.zero(),
        ],
        const [
          Complex.fromReal(0.5485),
          Complex.fromReal(-1.2153),
        ],
      ];

      for (var i = 0; i < equations.length; ++i) {
        for (var j = 0; j < equations[i].length; ++j) {
          expect(
            equations[i][j].real,
            MoreOrLessEquals(solutions[i][j].real, precision: 1.0e-4),
          );
          expect(
            equations[i][j].imaginary,
            MoreOrLessEquals(solutions[i][j].imaginary, precision: 1.0e-4),
          );
        }
      }
    });
  });
}

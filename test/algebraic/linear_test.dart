import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing 'Linear' algebraic equations", () {
    test("Making sure that a 'Linear' object is properly constructed", () {
      final equation = Linear(
        a: const Complex.fromReal(3),
        b: Complex.fromRealFraction(Fraction(6, 5)),
      );

      // Checking properties
      expect(equation.degree, equals(1));
      expect(
        equation.derivative(),
        equals(
          Constant(a: const Complex.fromReal(3)),
        ),
      );
      expect(equation.isRealEquation, isTrue);
      expect(equation.discriminant(), equals(const Complex.fromReal(1)));
      expect(
        equation.coefficients,
        equals(
          [
            const Complex.fromReal(3),
            Complex.fromRealFraction(Fraction(6, 5)),
          ],
        ),
      );

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(const Complex.fromReal(3)));
      expect(equation[1], equals(Complex.fromRealFraction(Fraction(6, 5))));

      expect(() => equation[-1], throwsA(isA<RangeError>()));

      expect(equation.coefficient(1), equals(const Complex.fromReal(3)));
      expect(
        equation.coefficient(0),
        equals(Complex.fromRealFraction(Fraction(6, 5))),
      );
      expect(equation.coefficient(2), isNull);

      // Converting to string
      expect(equation.toString(), equals('f(x) = 3x + 1.2'));
      expect(equation.toStringWithFractions(), equals('f(x) = 3x + 6/5'));

      // Checking solutions
      final solutions = equation.solutions();
      expect(
        solutions[0].real,
        const MoreOrLessEquals(-0.4, precision: 1.0e-1),
      );
      expect(solutions[0].imaginary, isZero);

      // Evaluation
      expect(
        equation.realEvaluateOn(1),
        equals(const Complex.fromReal(4.2)),
      );
      expect(
        equation.evaluateOn(const Complex(1, -3)),
        equals(const Complex(4.2, -9)),
      );
    });

    test("Making sure that 'Linear' is properly printed with fractions", () {
      // The equation
      final equation = Linear(
        a: const Complex(4, 7),
        b: const Complex(5, 1),
      );

      // Its string representation
      const equationStr = 'f(x) = (4 + 7i)x + (5 + 1i)';

      // Making sure it's properly printed
      expect(equation.toStringWithFractions(), equals(equationStr));
    });

    test(
      "Making sure that a correct 'Linear' instance is created from a "
      "list of 'double' (real) values",
      () {
        final linear = Linear.realEquation(a: 5, b: 1);

        expect(linear.a, equals(const Complex.fromReal(5)));
        expect(linear.b, equals(const Complex.fromReal(1)));

        // There must be an exception is the first coeff. is zero
        expect(
          () => Linear.realEquation(a: 0),
          throwsA(isA<AlgebraicException>()),
        );
      },
    );

    test(
      'Making sure that an exception is thrown if the coeff. of the '
      'highest degree is zero',
      () {
        expect(
          () => Linear(a: const Complex.zero()),
          throwsA(isA<AlgebraicException>()),
        );
      },
    );

    test('Making sure that objects comparison works properly', () {
      final fx = Linear(
        a: const Complex(2, 3),
        b: const Complex.i(),
      );

      expect(
        fx,
        equals(Linear(
          a: const Complex(2, 3),
          b: const Complex.i(),
        )),
      );
      expect(
        fx ==
            Linear(
              a: const Complex(2, 3),
              b: const Complex.i(),
            ),
        isTrue,
      );
      expect(
        fx.hashCode,
        equals(Linear(
          a: const Complex(2, 3),
          b: const Complex.i(),
        ).hashCode),
      );
    });

    test("Making sure that 'copyWith' clones objects correctly", () {
      final linear = Linear(
        a: const Complex.i(),
        b: const Complex(-3, 8),
      );

      // Objects equality
      expect(linear, equals(linear.copyWith()));
      expect(
        linear,
        equals(
          linear.copyWith(a: const Complex.i(), b: const Complex(-3, 8)),
        ),
      );

      // Objects inequality
      expect(linear == linear.copyWith(b: const Complex.zero()), isFalse);
    });

    test('Batch tests', () {
      final equations = [
        Linear.realEquation(
          a: 2,
          b: 3,
        ).solutions(),
        Linear(
          a: const Complex.i(),
          b: const Complex(4, -6),
        ).solutions(),
        Linear().solutions(),
        Linear.realEquation(
          a: -61,
          b: -61,
        ).solutions(),
        Linear(
          a: const Complex.i(),
          b: -const Complex.i(),
        ).solutions(),
      ];

      final solutions = <List<Complex>>[
        const [Complex.fromReal(-3 / 2)],
        const [Complex(6, 4)],
        const [Complex.zero()],
        const [Complex.fromReal(-1)],
        const [Complex.fromReal(1)],
      ];

      for (var i = 0; i < equations.length; ++i) {
        for (var j = 0; j < equations[i].length; ++j) {
          expect(
            equations[i][j].real,
            MoreOrLessEquals(solutions[i][j].real, precision: 1.0e-5),
          );
          expect(
            equations[i][j].imaginary,
            MoreOrLessEquals(solutions[i][j].imaginary, precision: 1.0e-5),
          );
        }
      }
    });
  });
}

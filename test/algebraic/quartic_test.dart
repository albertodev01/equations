import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing 'Quartic' algebraic equations", () {
    test("Making sure that a 'Quartic' object is properly constructed", () {
      final equation = Quartic.realEquation(a: 3, b: 6, d: 2, e: -1);

      // Checking properties
      expect(equation.degree, equals(4));
      expect(
        equation.derivative(),
        Cubic(
          a: const Complex.fromReal(12),
          b: const Complex.fromReal(18),
          d: const Complex.fromReal(2),
        ),
      );
      expect(equation.isRealEquation, isTrue);
      expect(equation.discriminant(), equals(const Complex.fromReal(-70848)));
      expect(
        equation.coefficients,
        equals(
          const [
            Complex.fromReal(3),
            Complex.fromReal(6),
            Complex.zero(),
            Complex.fromReal(2),
            Complex.fromReal(-1),
          ],
        ),
      );

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(const Complex.fromReal(3)));
      expect(equation[1], equals(const Complex.fromReal(6)));
      expect(equation[2], equals(const Complex.zero()));
      expect(equation[3], equals(const Complex.fromReal(2)));
      expect(equation[4], equals(const Complex.fromReal(-1)));

      expect(() => equation[-1], throwsA(isA<RangeError>()));

      expect(equation.coefficient(4), equals(const Complex.fromReal(3)));
      expect(equation.coefficient(3), equals(const Complex.fromReal(6)));
      expect(equation.coefficient(2), equals(const Complex.zero()));
      expect(equation.coefficient(1), equals(const Complex.fromReal(2)));
      expect(equation.coefficient(0), equals(const Complex.fromReal(-1)));
      expect(equation.coefficient(5), isNull);

      // Converting to string
      expect(
        equation.toString(),
        equals('f(x) = 3x^4 + 6x^3 + 2x + -1'),
      );
      expect(
        equation.toStringWithFractions(),
        equals('f(x) = 3x^4 + 6x^3 + 2x + -1'),
      );

      // Checking solutions
      final solutions = equation.solutions();
      expect(solutions.first.real, const MoreOrLessEquals(-2.173571613806));
      expect(solutions.first.imaginary.round(), isZero);
      expect(solutions[1].real, const MoreOrLessEquals(0.349518864775));
      expect(solutions[1].imaginary.round(), isZero);
      expect(solutions[2].real, const MoreOrLessEquals(-0.087973625484));
      expect(solutions[2].imaginary, const MoreOrLessEquals(0.656527118533));
      expect(solutions[3].real, const MoreOrLessEquals(-0.087973625484));
      expect(solutions[3].imaginary, const MoreOrLessEquals(-0.656527118533));

      // Evaluation
      final eval = equation.realEvaluateOn(2);
      expect(eval.real.round(), equals(99));
      expect(eval.imaginary.round(), isZero);
    });

    test(
      'Making sure that an exception is thrown if the coeff. of the highest'
      ' degree is zero',
      () {
        expect(
          () => Quartic(a: const Complex.zero()),
          throwsA(isA<AlgebraicException>()),
        );
      },
    );

    test(
      "Making sure that a correct 'Quadratic' instance is created from a "
      "list of 'double' (real) values",
      () {
        final quartic = Quartic.realEquation(a: -3, d: 8);

        expect(quartic.a, equals(const Complex.fromReal(-3)));
        expect(quartic.d, equals(const Complex.fromReal(8)));

        // There must be an exception is the first coeff. is zero
        expect(
          () => Quartic.realEquation(a: 0),
          throwsA(isA<AlgebraicException>()),
        );
      },
    );

    test('Making sure that objects comparison works properly', () {
      final fx = Quartic(
        a: const Complex(3, -6),
        b: const Complex.fromImaginary(-2),
        c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
        d: const Complex.i(),
        e: const Complex.fromReal(9),
      );

      final otherFx = Quartic(
        a: const Complex(3, -6),
        b: const Complex.fromImaginary(-2),
        c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
        d: const Complex.i(),
        e: const Complex.fromReal(9),
      );

      expect(fx, equals(otherFx));
      expect(fx == otherFx, isTrue);
      expect(otherFx, equals(fx));
      expect(otherFx == fx, isTrue);

      expect(
        fx,
        equals(Quartic(
          a: const Complex(3, -6),
          b: const Complex.fromImaginary(-2),
          c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
          d: const Complex.i(),
          e: const Complex.fromReal(9),
        )),
      );
      expect(
        Quartic(
          a: const Complex(3, -6),
          b: const Complex.fromImaginary(-2),
          c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
          d: const Complex.i(),
          e: const Complex.fromReal(9),
        ),
        equals(fx),
      );
      expect(
        fx ==
            Quartic(
              a: const Complex(3, -6),
              b: const Complex.fromImaginary(-2),
              c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
              d: const Complex.i(),
              e: const Complex.fromReal(9),
            ),
        isTrue,
      );
      expect(
        Quartic(
              a: const Complex(3, -6),
              b: const Complex.fromImaginary(-2),
              c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
              d: const Complex.i(),
              e: const Complex.fromReal(9),
            ) ==
            fx,
        isTrue,
      );

      expect(fx.hashCode, equals(otherFx.hashCode));
    });

    test("Making sure that 'copyWith' clones objects correctly", () {
      final quartic = Quartic.realEquation(c: 5, d: -6);

      // Objects equality
      expect(quartic, equals(quartic.copyWith()));
      expect(
        quartic,
        equals(
          quartic.copyWith(
            a: const Complex.fromReal(1),
            b: const Complex.zero(),
            c: const Complex.fromReal(5),
            d: const Complex.fromReal(-6),
            // ignore: prefer_const_constructors
            e: Complex.zero(),
          ),
        ),
      );

      // Objects inequality
      expect(quartic == quartic.copyWith(c: const Complex.zero()), isFalse);
    });

    test('Batch tests', () {
      final equations = [
        Quartic.realEquation(
          a: 2,
          b: 1,
          c: -2,
          d: 1,
          e: 7,
        ).solutions(),
        Quartic(
          a: const Complex.fromReal(5),
          b: const Complex(-5, 12),
          d: const Complex.fromReal(1),
        ).solutions(),
        Quartic.realEquation(
          a: 5,
          b: 6,
          d: -1,
        ).solutions(),
        Quartic(
          a: const Complex(4, -7),
          b: const Complex(2, 3),
          d: const Complex.fromReal(2),
          e: const Complex(10, 1),
        ).solutions(),
        Quartic(
          a: const Complex.i(),
          c: -const Complex.i(),
          e: const Complex.fromReal(-3),
        ).solutions(),
      ];

      final solutions = <List<Complex>>[
        const [
          Complex(-1.22152, -0.69349),
          Complex(-1.22152, 0.69349),
          Complex(0.97152, -0.91106),
          Complex(0.97152, 0.91106),
        ],
        const [
          Complex(-0.23979, -0.1419),
          Complex.zero(),
          Complex(0.21956, 0.16265),
          Complex(1.02023, -2.42074),
        ],
        const [
          Complex.fromReal(-1),
          Complex.fromReal(-0.55826),
          Complex.zero(),
          Complex.fromReal(0.35826),
        ],
        const [
          Complex(-0.85119, 0.37549),
          Complex(-0.46831, -0.97907),
          Complex(0.51992, 0.88058),
          Complex(0.99958, -0.677),
        ],
        const [
          Complex(-1.39765, 0.42028),
          Complex(-0.56196, -1.04527),
          Complex(0.56196, 1.04527),
          Complex(1.39765, -0.42028),
        ],
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

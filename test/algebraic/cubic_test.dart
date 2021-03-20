import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing 'Cubic' algebraic equations", () {
    test("Making sure that a 'Cubic' object is properly constructed", () {
      final equation = Cubic(
        a: const Complex.fromReal(-1),
        c: const Complex.fromReal(5),
        d: const Complex.fromReal(-9),
      );

      // Checking properties
      expect(equation.degree, equals(3));
      expect(
        equation.derivative(),
        Quadratic(
          a: const Complex.fromReal(-3),
          c: const Complex.fromReal(5),
        ),
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
          ]));

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
      expect(solutions[2].real, const MoreOrLessEquals(1.427598269660));
      expect(solutions[2].imaginary, const MoreOrLessEquals(1.055514309999));
      expect(solutions[1].real, const MoreOrLessEquals(-2.855196539321));
      expect(solutions[1].imaginary.round(), isZero);
      expect(solutions[0].real, const MoreOrLessEquals(1.427598269660));
      expect(solutions[0].imaginary, const MoreOrLessEquals(-1.055514309999));

      // Evaluation
      final eval = equation.realEvaluateOn(0.5);
      expect(eval, Complex.fromRealFraction(Fraction(-53, 8)));
    });

    test(
        "Making sure that a correct 'Cubic' instance is created from a list "
        "of 'double' (real) values", () {
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

    test(
        'Making sure that an exception is thrown if the coeff. of the highest degree is zero',
        () {
      expect(
        () => Cubic(a: const Complex.zero()),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('Making sure that objects comparison works properly', () {
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
      expect(fx == otherFx, isTrue);
      expect(fx.hashCode, equals(otherFx.hashCode));
    });

    test("Making sure that 'copyWith' clones objects correctly", () {
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
  });
}

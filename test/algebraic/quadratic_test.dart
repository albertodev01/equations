import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing 'Quadratic' algebraic equations", () {
    test("Making sure that a 'Quadratic' object is properly constructed", () {
      final equation = Quadratic(
        a: Complex.fromReal(2),
        b: Complex.fromReal(-5),
        c: Complex.fromRealFraction(Fraction(3, 2)),
      );

      // Checking properties
      expect(equation.degree, equals(2));
      expect(
          equation.derivative(),
          Linear(
            a: Complex.fromReal(4),
            b: Complex.fromReal(-5),
          ));
      expect(equation.isRealEquation, isTrue);
      expect(equation.discriminant(), equals(Complex.fromReal(13)));
      expect(
          equation.coefficients,
          equals([
            Complex.fromReal(2),
            Complex.fromReal(-5),
            Complex.fromRealFraction(Fraction(3, 2)),
          ]));

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(Complex.fromReal(2)));
      expect(equation[1], equals(Complex.fromReal(-5)));
      expect(equation[2], equals(Complex.fromRealFraction(Fraction(3, 2))));
      expect(() => equation[-1], throwsA(isA<RangeError>()));

      // Converting to string
      expect(equation.toString(), equals("f(x) = 2x^2 + -5x + 1.5"));
      expect(
          equation.toStringWithFractions(), equals("f(x) = 2x^2 + -5x + 3/2"));

      // Checking solutions
      final solutions = equation.solutions();
      expect(solutions[0].real, MoreOrLessEquals(2.151387818866));
      expect(solutions[0].imaginary, isZero);
      expect(solutions[1].real, MoreOrLessEquals(0.348612181134));
      expect(solutions[1].imaginary, isZero);

      // Evaluation
      final eval = equation.realEvaluateOn(Fraction(-2, 5).toDouble());
      expect(eval.real.toStringAsFixed(2), equals("3.82"));
      expect(eval.imaginary.round(), isZero);
    });

    test(
        "Making sure that an exception is thrown if the coeff. of the highest degree is zero",
        () {
      expect(
          () => Quadratic(
                a: Complex.zero(),
                b: Complex.i(),
                c: Complex.fromReal(4),
              ),
          throwsA(isA<AlgebraicException>()));
    });

    test(
        "Making sure that a correct 'Quadratic' instance is created from a "
        "list of 'double' (real) values", () {
      final quadratic = Quadratic.realEquation(a: -3, b: 2, c: 1);

      expect(quadratic.a, equals(Complex.fromReal(-3)));
      expect(quadratic.b, equals(Complex.fromReal(2)));
      expect(quadratic.c, equals(Complex.fromReal(1)));

      // There must be an exception is the first coeff. is zero
      expect(() => Quadratic.realEquation(a: 0),
          throwsA(isA<AlgebraicException>()));
    });

    test("Making sure that objects comparison works properly", () {
      final fx = Quadratic(a: Complex(2, 3), b: Complex.i(), c: Complex(-1, 0));

      final otherFx =
          Quadratic(a: Complex(2, 3), b: Complex.i(), c: Complex(-1, 0));

      expect(fx, equals(otherFx));
      expect(fx == otherFx, isTrue);
      expect(fx.hashCode, equals(otherFx.hashCode));
    });

    test("Making sure that 'copyWith' clones objects correctly", () {
      final quadratic =
          Quadratic(a: Complex.i(), b: Complex(6, -1), c: Complex.i());

      // Objects equality
      expect(quadratic, equals(quadratic.copyWith()));
      expect(
          quadratic,
          equals(quadratic.copyWith(
            a: Complex.i(),
            b: Complex(6, -1),
            c: Complex.i(),
          )));

      // Objects inequality
      expect(quadratic == quadratic.copyWith(b: Complex.zero()), isFalse);
    });
  });
}

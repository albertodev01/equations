import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing 'Cubic' algebraic equations", () {
    test("Making sure that a 'Cubic' object is properly constructed", () {
      final equation = Cubic(
        a: Complex.fromReal(-1),
        c: Complex.fromReal(5),
        d: Complex.fromReal(-9),
      );

      // Checking properties
      expect(equation.degree, equals(3));
      expect(
          equation.derivative(),
          Quadratic(
            a: Complex.fromReal(-3),
            c: Complex.fromReal(5),
          ));
      expect(equation.isRealEquation, isTrue);
      expect(equation.discriminant(), equals(Complex.fromReal(-1687)));
      expect(
          equation.coefficients,
          equals([
            Complex.fromReal(-1),
            Complex.zero(),
            Complex.fromReal(5),
            Complex.fromReal(-9),
          ]));

      // Converting to string
      expect(equation.toString(), equals("f(x) = -1x^3 + 5x + -9"));
      expect(
          equation.toStringWithFractions(), equals("f(x) = -1x^3 + 5x + -9"));

      // Checking solutions
      final solutions = equation.solutions();
      expect(solutions[2].real, MoreOrLessEquals(1.427598269660));
      expect(solutions[2].imaginary, MoreOrLessEquals(1.055514309999));
      expect(solutions[1].real, MoreOrLessEquals(-2.855196539321));
      expect(solutions[1].imaginary.round(), isZero);
      expect(solutions[0].real, MoreOrLessEquals(1.427598269660));
      expect(solutions[0].imaginary, MoreOrLessEquals(-1.055514309999));

      // Evaluation
      final eval = equation.realEvaluateOn(0.5);
      expect(eval, Complex.fromRealFraction(Fraction(-53, 8)));
    });

    test(
        "Making sure that an exception is thrown if the coeff. of the highest degree is zero",
        () {
      expect(
          () => Cubic(
                a: Complex.zero(),
              ),
          throwsA(isA<AlgebraicException>()));
    });

    test("Making sure that objects comparison works properly", () {
      final fx = Cubic(
          a: Complex(2, -3),
          b: Complex.fromImaginaryFraction(Fraction(6, 5)),
          c: Complex(5, -1),
          d: Complex(-9, -6));

      final otherFx = Cubic(
          a: Complex(2, -3),
          b: Complex.fromImaginaryFraction(Fraction(6, 5)),
          c: Complex(5, -1),
          d: Complex(-9, -6));

      expect(fx, equals(otherFx));
      expect(fx == otherFx, isTrue);
      expect(fx.hashCode, equals(otherFx.hashCode));
    });
  });
}

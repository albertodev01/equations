import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing 'Quartic' algebraic equations", () {
    test("Making sure that a 'Quartic' object is properly constructed", () {
      final equation = Quartic(
          a: Complex.fromReal(3),
          b: Complex.fromReal(6),
          d: Complex.fromReal(2),
          e: Complex.fromReal(-1));

      // Checking properties
      expect(equation.degree, equals(4));
      expect(
          equation.derivative(),
          Cubic(
              a: Complex.fromReal(12),
              b: Complex.fromReal(18),
              d: Complex.fromReal(2)));
      expect(equation.isRealEquation, isTrue);
      expect(equation.discriminant(), equals(Complex.fromReal(-70848)));
      expect(
          equation.coefficients,
          equals([
            Complex.fromReal(3),
            Complex.fromReal(6),
            Complex.zero(),
            Complex.fromReal(2),
            Complex.fromReal(-1),
          ]));

      // Converting to string
      expect(equation.toString(), equals("f(x) = 3x^4 + 6x^3 + 2x + -1"));
      expect(equation.toStringWithFractions(),
          equals("f(x) = 3x^4 + 6x^3 + 2x + -1"));

      // Checking solutions
      final solutions = equation.solutions();
      expect(solutions[0].real, MoreOrLessEquals(-2.173571613806));
      expect(solutions[0].imaginary.round(), isZero);
      expect(solutions[1].real, MoreOrLessEquals(0.349518864775));
      expect(solutions[1].imaginary.round(), isZero);
      expect(solutions[2].real, MoreOrLessEquals(-0.087973625484));
      expect(solutions[2].imaginary, MoreOrLessEquals(0.656527118533));
      expect(solutions[3].real, MoreOrLessEquals(-0.087973625484));
      expect(solutions[3].imaginary, MoreOrLessEquals(-0.656527118533));

      // Evaluation
      final eval = equation.realEvaluateOn(2);
      expect(eval.real.round(), equals(99));
      expect(eval.imaginary.round(), isZero);
    });

    test(
        "Making sure that an exception is thrown if the coeff. of the highest"
        " degree is zero", () {
      expect(() {
        Quartic(
          a: Complex.zero(),
        );
      }, throwsA(isA<AlgebraicException>()));
    });

    test("Making sure that objects comparison works properly", () {
      final fx = Quartic(
          a: Complex(3, -6),
          b: Complex.fromImaginary(-2),
          c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
          d: Complex.i(),
          e: Complex.fromReal(9));

      final otherFx = Quartic(
          a: Complex(3, -6),
          b: Complex.fromImaginary(-2),
          c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
          d: Complex.i(),
          e: Complex.fromReal(9));

      expect(fx, equals(otherFx));
      expect(fx == otherFx, isTrue);
      expect(fx.hashCode, equals(otherFx.hashCode));
    });
  });
}

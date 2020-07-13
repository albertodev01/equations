import 'package:equations/src/algebraic/cubic.dart';
import 'package:equations/src/algebraic/quartic.dart';
import 'package:equations/src/complex.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing quartic equations", () {
    test("Real equation -> 3x^4 + 6x^3 + 2x - 1 = 0", () {
      final equation = Quartic(
          a: Complex.fromReal(3),
          b: Complex.fromReal(6),
          d: Complex.fromReal(2),
          e: Complex.fromReal(-1));

      expect(equation.degree, 4);
      expect(
          equation.derivative(),
          Cubic(
              a: Complex.fromReal(12),
              b: Complex.fromReal(18),
              d: Complex.fromReal(2)));
      expect(equation.isRealEquation, true);
      expect(equation.discriminant(), Complex.fromReal(-70848));
      expect("$equation", "f(x) = 3x^4 + 6x^3 + 2x + -1");
      expect("${equation.toStringWithFractions()}",
          "f(x) = 3x^4 + 6x^3 + 2x + -1");

      final solutions = equation.solutions();
      expect(solutions[0].real.toStringAsFixed(12), "-2.173571613806");
      expect(solutions[0].imaginary.round(), 0);
      expect(solutions[1].real.toStringAsFixed(12), "0.349518864775");
      expect(solutions[1].imaginary.round(), 0);
      expect(solutions[2].real.toStringAsFixed(12), "-0.087973625484");
      expect(solutions[2].imaginary.toStringAsFixed(12), "0.656527118533");
      expect(solutions[3].real.toStringAsFixed(12), "-0.087973625484");
      expect(solutions[3].imaginary.toStringAsFixed(12), "-0.656527118533");

      final eval = equation.realEvaluateOn(2);
      expect(eval.real.round(), 99);
      expect(eval.imaginary.round(), 0);
    });

    test("Complex equation -> (3-6i)x^4 - 2ix^3 + (1/2+1/5i)x^2 + ix + 9 = 0",
        () {
      final equation = Quartic(
          a: Complex(3, -6),
          b: Complex.fromImaginary(-2),
          c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
          d: Complex.i(),
          e: Complex.fromReal(9));

      expect(equation.degree, 4);
      expect(
          equation.derivative(),
          Cubic(
            a: Complex(12, -24),
            b: Complex(0, -6),
            c: Complex.fromFraction(Fraction(1, 1), Fraction(2, 5)),
            d: Complex.i(),
          )
      );

      //expect(equation.discriminant(), Complex.fromReal(-70848));
      expect("$equation",
          "f(x) = (3 - 6i)x^4 + -2ix^3 + (0.5 + 0.2i)x^2 + 1ix + 9");
      expect("${equation.toStringWithFractions()}",
          "f(x) = (3 - 6i)x^4 + -2ix^3 + (1/2 + 1/5i)x^2 + 1ix + 9");

      final solutions = equation.solutions();
      expect(solutions[0].real.toStringAsFixed(12), "-0.994433103518");
      expect(solutions[0].imaginary.toStringAsFixed(12), "0.599283348246");
      expect(solutions[1].real.toStringAsFixed(12), "-0.597306297068");
      expect(solutions[1].imaginary.toStringAsFixed(12), "-0.909627391560");
      expect(solutions[2].real.toStringAsFixed(12), "0.413042868758");
      expect(solutions[2].imaginary.toStringAsFixed(12), "0.937061578767");
      expect(solutions[3].real.toStringAsFixed(12), "0.912029865161");
      expect(solutions[3].imaginary.toStringAsFixed(12), "-0.493384202121");

      final eval = equation.evaluateOn(Complex(-2, 3));
      expect(eval.real.round(), 387);
      expect(eval.imaginary.round(), 973);
    });
  });
}

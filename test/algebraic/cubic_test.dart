import 'package:equations/src/algebraic/cubic.dart';
import 'package:equations/src/algebraic/quadratic.dart';
import 'package:equations/src/complex/complex.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing cubic equations", () {
    test("Real equation -> -x^3 + 5x - 9 = 0", () {
      final equation = Cubic(
        a: Complex.fromReal(-1),
        c: Complex.fromReal(5),
        d: Complex.fromReal(-9),
      );

      expect(equation.degree, 3);
      expect(
          equation.derivative(),
          Quadratic(
            a: Complex.fromReal(-3),
            c: Complex.fromReal(5),
          ));
      expect(equation.isRealEquation, true);
      expect(equation.discriminant(), Complex.fromReal(-1687));
      expect("$equation", "f(x) = -1x^3 + 5x + -9");
      expect("${equation.toStringWithFractions()}", "f(x) = -1x^3 + 5x + -9");

      final solutions = equation.solutions();
      expect(solutions[2].real.toStringAsFixed(12), "1.427598269660");
      expect(solutions[2].imaginary.toStringAsFixed(12), "1.055514309999");
      expect(solutions[1].real.toStringAsFixed(12), "-2.855196539321");
      expect(solutions[1].imaginary.round(), 0);
      expect(solutions[0].real.toStringAsFixed(12), "1.427598269660");
      expect(solutions[0].imaginary.toStringAsFixed(12), "-1.055514309999");

      final eval = equation.realEvaluateOn(0.5);
      expect(eval, Complex.fromRealFraction(Fraction(-53, 8)));
    });

    test("Complex equation -> (2-3i)x^3 + 6/5ix^2 - (-5+i)x - (9+6i) = 0", () {
      final equation = Cubic(
          a: Complex(2, -3),
          b: Complex.fromImaginaryFraction(Fraction(6, 5)),
          c: Complex(5, -1),
          d: Complex(-9, -6));

      expect(equation.degree, 3);
      expect(
          equation.derivative(),
          Quadratic(
            a: Complex(6, -9),
            b: Complex.fromImaginaryFraction(Fraction(12, 5)),
            c: Complex(5, -1),
          ));
      expect(equation.isRealEquation, false);
      expect(equation.discriminant().real.toStringAsFixed(3), "-31299.688");
      expect(equation.discriminant().imaginary.toStringAsFixed(3), "27460.192");
      expect(
          "$equation", "f(x) = (2 - 3i)x^3 + 1.2ix^2 + (5 - 1i)x + (-9 - 6i)");
      expect("${equation.toStringWithFractions()}",
          "f(x) = (2 - 3i)x^3 + 6/5ix^2 + (5 - 1i)x + (-9 - 6i)");

      final solutions = equation.solutions();
      expect(solutions[0].real.toStringAsFixed(12), "0.348906207844");
      expect(solutions[0].imaginary.toStringAsFixed(12), "-1.734303423032");
      expect(solutions[1].real.toStringAsFixed(12), "-1.083892638909");
      expect(solutions[1].imaginary.toStringAsFixed(12), "0.961044482775");
      expect(solutions[2].real.toStringAsFixed(12), "1.011909507988");
      expect(solutions[2].imaginary.toStringAsFixed(12), "0.588643555642");

      final eval = equation.evaluateOn(Complex(2, 1));
      expect(eval.real.toFraction(), Fraction(171, 5));
      expect(eval.imaginary.toFraction(), Fraction(83, 5));
    });
  });
}

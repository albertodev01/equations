import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing quadratic equations", () {
    test("Real equation -> 2x^2 - 5x + 3/2 = 0", () {
      final equation = Quadratic(
        a: Complex.fromReal(2),
        b: Complex.fromReal(-5),
        c: Complex.fromRealFraction(Fraction(3, 2)),
      );

      expect(equation.degree, 2);
      expect(
          equation.derivative(),
          Linear(
            a: Complex.fromReal(4),
            b: Complex.fromReal(-5),
          ));
      expect(equation.isRealEquation, true);
      expect(equation.discriminant(), Complex.fromReal(13));
      expect("$equation", "f(x) = 2x^2 + -5x + 1.5");
      expect("${equation.toStringWithFractions()}", "f(x) = 2x^2 + -5x + 3/2");

      final solutions = equation.solutions();
      expect(solutions[0].real.toStringAsFixed(12), "2.151387818866");
      expect(solutions[0].imaginary, 0);
      expect(solutions[1].real.toStringAsFixed(12), "0.348612181134");
      expect(solutions[1].imaginary, 0);

      final eval = equation.realEvaluateOn(Fraction(-2, 5).toDouble());
      expect(eval.real.toStringAsFixed(2), "3.82");
      expect(eval.imaginary.round(), 0);
    });

    test("Complex equation -> i/3x^2 + (6+i)x = 0", () {
      final equation = Quadratic(
        a: Complex.fromImaginaryFraction(Fraction(1, 3)),
        b: Complex(6, 1),
      );

      expect(equation.degree, 2);
      expect(
          equation.derivative(),
          Linear(
              a: Complex.fromImaginaryFraction(Fraction(2, 3)),
              b: Complex(6, 1)));
      expect(equation.isRealEquation, true);
      expect(equation.discriminant(), Complex(35, 12));
      expect("$equation", "f(x) = 0.3333333333333333ix^2 + (6 + 1i)x");
      expect(
          "${equation.toStringWithFractions()}", "f(x) = 1/3ix^2 + (6 + 1i)x");

      final solutions = equation.solutions();
      expect(solutions[0].real.round(), 0);
      expect(solutions[0].imaginary.round(), 0);
      expect(solutions[1].real.round(), -3);
      expect(solutions[1].imaginary.round(), 18);

      final eval = equation.evaluateOn(Complex.i());
      expect(eval.real.toFraction(), Fraction(-1, 1));
      expect(eval.imaginary.toFraction(), Fraction(17, 3));
    });
  });
}

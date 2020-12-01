import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing linear equations", () {
    test("Real equation -> 3x + 6/5 = 0", () {
      final equation = Linear(
        a: Complex.fromReal(3),
        b: Complex.fromRealFraction(Fraction(6, 5)),
      );

      expect(equation.degree, 1);
      expect(equation.derivative(), Constant(a: Complex.fromReal(3)));
      expect(equation.isRealEquation, true);
      expect(equation.discriminant(), Complex.fromReal(1));
      expect("$equation", "f(x) = 3x + 1.2");
      expect("${equation.toStringWithFractions()}", "f(x) = 3x + 6/5");

      final solutions = equation.solutions();
      expect(solutions[0].real.toStringAsFixed(1), "-0.4");
      expect(solutions[0].imaginary, 0);

      final eval = equation.realEvaluateOn(0);
      expect(eval, Complex.fromRealFraction(Fraction(6, 5)));
    });

    test("Complex equation -> 2ix + (6/5 - i) = 0", () {
      final equation = Linear(
        a: Complex.fromImaginary(2),
        b: Complex.fromFraction(Fraction(6, 5), Fraction.fromDouble(-1)),
      );

      expect(equation.degree, 1);
      expect(equation.derivative(), Constant(a: Complex.fromImaginary(2)));
      expect(equation.isRealEquation, false);
      expect(equation.discriminant(), Complex.fromReal(1));
      expect("$equation", "f(x) = 2ix + (1.2 - 1i)");
      expect("${equation.toStringWithFractions()}", "f(x) = 2ix + (6/5 - 1i)");

      final solutions = equation.solutions();
      expect(
          solutions[0], Complex.fromFraction(Fraction(1, 2), Fraction(3, 5)));

      final eval = equation.realEvaluateOn(2);
      expect(eval, Complex.fromFraction(Fraction(6, 5), Fraction(3, 1)));

      final eval2 = equation.evaluateOn(Complex.i());
      expect(eval2.real, -0.8);
      expect(eval2.imaginary.round(), -1);
    });
  });
}

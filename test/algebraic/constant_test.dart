import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing constant equations", () {
    test("Degree = 0", () {
      final equation = Constant(a: Complex(3, 7));

      expect(equation.degree, 0);
      expect(equation.derivative(), Constant(a: Complex.zero()));
      expect(equation.solutions().length, 0);
      expect(equation.isRealEquation, false);
      expect("$equation", "f(x) = (3 + 7i)");

      final discriminant = equation.discriminant();
      expect(discriminant.real.isNaN, true);
      expect(discriminant.imaginary.isNaN, true);

      final eval = equation.realEvaluateOn(2);
      expect(eval, Complex(3, 7));
    });

    test("Degree not defined", () {
      final equation = Constant(a: Complex.zero());

      expect(equation.degree, double.negativeInfinity);
      expect(equation.isRealEquation, true);

      final eval = equation.realEvaluateOn(6);
      expect(eval, Complex.zero());
    });
  });
}

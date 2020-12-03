import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing 'Constant' algebraic equations", () {
    test("Making sure that a 'Constant' object is properly constructed", () {
      final equation = Constant(a: Complex(3, 7));

      // Checking the fields
      expect(equation.degree, isZero);
      expect(equation.derivative(), equals(Constant(a: Complex.zero())));
      expect(equation.solutions().length, isZero);
      expect(equation.isRealEquation, isFalse);
      expect(equation.toString(), equals("f(x) = (3 + 7i)"));

      // There's NO discriminant for constant values
      final discriminant = equation.discriminant();
      expect(discriminant.real.isNaN, isTrue);
      expect(discriminant.imaginary.isNaN, isTrue);

      // Evaluation
      final eval = equation.realEvaluateOn(2);
      expect(eval, equals(Complex(3, 7)));
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

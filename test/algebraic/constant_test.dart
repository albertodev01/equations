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
      expect(equation.coefficients, equals([
        Complex(3, 7)
      ]));

      // Converting to string
      expect(equation.toString(), equals("f(x) = (3 + 7i)"));
      expect(equation.toStringWithFractions(), equals("f(x) = 3 + 7i"));

      // There's NO discriminant for constant values
      final discriminant = equation.discriminant();
      expect(discriminant.real.isNaN, isTrue);
      expect(discriminant.imaginary.isNaN, isTrue);

      // Evaluation
      final eval = equation.realEvaluateOn(2);
      expect(eval, equals(Complex(3, 7)));
    });

    test("Making sure that in case of zero, the degree is -inf", () {
      final equation = Constant(a: Complex.zero());
      expect(equation.degree, equals(double.negativeInfinity));
      expect(equation.isRealEquation, isTrue);

      final eval = equation.realEvaluateOn(6);
      expect(eval, Complex.zero());
    });
  });
}

import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing 'Constant' algebraic equations", () {
    test("Making sure that a 'Constant' object is properly constructed", () {
      final equation = Constant(a: Complex(3, 7));

      // Checking properties
      expect(equation.degree, isZero);
      expect(equation.derivative(), equals(Constant(a: Complex.zero())));
      expect(equation.solutions().length, isZero);
      expect(equation.isRealEquation, isFalse);
      expect(equation.coefficients, equals([Complex(3, 7)]));

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(Complex(3, 7)));
      expect(() => equation[-1], throwsA(isA<RangeError>()));

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

    test(
        "Making sure that a correct 'Constant' instance is created from a "
        "list of 'double' (real) values", () {
      final constant = Constant.realEquation(a: 5);

      expect(constant.a, equals(Complex.fromReal(5)));
    });

    test("Making sure that in case of zero, the degree is -inf", () {
      final equation = Constant(a: Complex.zero());
      expect(equation.degree, equals(double.negativeInfinity));
      expect(equation.isRealEquation, isTrue);

      final eval = equation.realEvaluateOn(6);
      expect(eval, Complex.zero());
    });

    test("Making sure that objects comparison works properly", () {
      final fx = Constant(a: Complex.fromReal(6));

      expect(fx, equals(Constant(a: Complex.fromReal(6))));
      expect(fx == Constant(a: Complex.fromReal(6)), isTrue);
      expect(fx.hashCode, equals(Constant(a: Complex.fromReal(6)).hashCode));
    });
  });
}

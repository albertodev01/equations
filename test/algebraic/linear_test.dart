import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing 'Linear' algebraic equations", () {
    test("Making sure that a 'Linear' object is properly constructed", () {
      final equation = Linear(
        a: Complex.fromReal(3),
        b: Complex.fromRealFraction(Fraction(6, 5)),
      );

      // Checking properties
      expect(equation.degree, equals(1));
      expect(equation.derivative(), equals(Constant(a: Complex.fromReal(3))));
      expect(equation.isRealEquation, isTrue);
      expect(equation.discriminant(), equals(Complex.fromReal(1)));
      expect(
          equation.coefficients,
          equals([
            Complex.fromReal(3),
            Complex.fromRealFraction(Fraction(6, 5)),
          ]));

      // Converting to string
      expect(equation.toString(), equals("f(x) = 3x + 1.2"));
      expect(equation.toStringWithFractions(), equals("f(x) = 3x + 6/5"));

      // Checking solutions
      final solutions = equation.solutions();
      expect(solutions[0].real, MoreOrLessEquals(-0.4, precision: 1.0e-1));
      expect(solutions[0].imaginary, isZero);

      // Evaluation
      expect(equation.realEvaluateOn(1), equals(Complex.fromReal(4.2)));
      expect(equation.evaluateOn(Complex(1, -3)), equals(Complex(4.2, -9)));
    });

    test(
        "Making sure that an exception is thrown if the coeff. of the highest degree is zero",
        () {
      expect(
          () => Linear(a: Complex.zero()), throwsA(isA<AlgebraicException>()));
    });

    test("Making sure that objects comparison works properly", () {
      final fx = Linear(
        a: Complex(2, 3),
        b: Complex.i(),
      );

      expect(fx, equals(Linear(a: Complex(2, 3), b: Complex.i())));
      expect(fx == Linear(a: Complex(2, 3), b: Complex.i()), isTrue);
      expect(fx.hashCode,
          equals(Linear(a: Complex(2, 3), b: Complex.i()).hashCode));
    });
  });
}

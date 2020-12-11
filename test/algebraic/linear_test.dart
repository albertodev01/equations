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

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(Complex.fromReal(3)));
      expect(equation[1], equals(Complex.fromRealFraction(Fraction(6, 5))));
      expect(() => equation[-1], throwsA(isA<RangeError>()));

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
        "Making sure that a 'Linear' object is properly printed with fractions",
        () {
      // The equation
      final equation = Linear(
        a: Complex(4, 7),
        b: Complex(5, 1),
      );

      // Its string representation
      final equationStr = "f(x) = (4 + 7i)x + (5 + 1i)";

      // Making sure it's properly printed
      expect(equation.toStringWithFractions(), equals(equationStr));
    });

    test(
        "Making sure that a correct 'Linear' instance is created from a "
        "list of 'double' (real) values", () {
      final linear = Linear.realEquation(a: 5, b: 1);

      expect(linear.a, equals(Complex.fromReal(5)));
      expect(linear.b, equals(Complex.fromReal(1)));
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

    test("Making sure that 'copyWith' clones objects correctly", () {
      final linear = Linear(a: Complex.i(), b: Complex(-3, 8));

      // Objects equality
      expect(linear, equals(linear.copyWith()));
      expect(
          linear, equals(linear.copyWith(a: Complex.i(), b: Complex(-3, 8))));

      // Objects inequality
      expect(linear == linear.copyWith(b: Complex.zero()), isFalse);
    });
  });
}

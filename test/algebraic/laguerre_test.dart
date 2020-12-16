import 'package:equations/equations.dart';
import 'package:equations/src/algebraic/types/laguerre.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group("Testing the 'Laguerre' class for polynomial roots finding", () {
    test("Making sure that a 'Laguerre' object is properly constructed", () {
      final equation = Laguerre(coefficients: const [
        Complex.i(),
        Complex.fromReal(3),
        Complex(-3, -2),
      ]);

      // Checking properties
      expect(equation.degree, equals(2));
      expect(equation.derivative(), isA<Linear>());
      expect(equation.isRealEquation, isFalse);
      expect(equation.discriminant(), equals(Complex.zero()));
      expect(
          equation.coefficients,
          equals([
            Complex.i(),
            Complex.fromReal(3),
            Complex(-3, -2),
          ]));

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(Complex.i()));
      expect(equation[1], equals(Complex.fromReal(3)));
      expect(equation[2], equals(Complex(-3, -2)));
      expect(() => equation[-1], throwsA(isA<RangeError>()));

      // Converting to string
      expect(equation.toString(), equals("f(x) = 1ix^2 + 3x + (-3 - 2i)"));
      expect(equation.toStringWithFractions(),
          equals("f(x) = 1ix^2 + 3x + (-3 - 2i)"));

      // Checking solutions
      final solutions = equation.solutions();
      expect(solutions[1].real, MoreOrLessEquals(-1.1748, precision: 1.0e-4));
      expect(
          solutions[1].imaginary, MoreOrLessEquals(2.7768, precision: 1.0e-4));
      expect(solutions[0].real, MoreOrLessEquals(1.1748, precision: 1.0e-4));
      expect(
          solutions[0].imaginary, MoreOrLessEquals(0.2232, precision: 1.0e-4));

      // Evaluation
      final eval = equation.realEvaluateOn(2);
      expect(eval, equals(Complex(3, 2)));
    });

    test(
        "Making sure that a correct 'Laguerre' instance is created from a list "
        "of 'double' (real) values", () {
      final laguerre = Laguerre.realEquation(coefficients: [1, 2, 3]);

      expect(laguerre[0], equals(Complex.fromReal(1)));
      expect(laguerre[1], equals(Complex.fromReal(2)));
      expect(laguerre[2], equals(Complex.fromReal(3)));

      // There must be an exception is the first coeff. is zero
      expect(() => Laguerre.realEquation(coefficients: [0, 3, 6]),
          throwsA(isA<AlgebraicException>()));
    });

    test(
        "Making sure that an exception is thrown if the coefficient with the "
        "highest degree is zero", () {
      expect(() => Laguerre(coefficients: [Complex.zero()]),
          throwsA(isA<AlgebraicException>()));
    });

    test("Making sure that various derivatives are properly computed.", () {
      final polynomialDegree6 =
          Laguerre.realEquation(coefficients: [1, 2, 3, 4, 5, 6, 7]);
      final polynomialDegree5 =
          Laguerre.realEquation(coefficients: [1, 2, 3, 4, 5, 6]);
      final polynomialDegree4 =
          Laguerre.realEquation(coefficients: [1, 2, 3, 4, 5]);
      final polynomialDegree3 =
          Laguerre.realEquation(coefficients: [1, 2, 3, 4]);
      final polynomialDegree2 = Laguerre.realEquation(coefficients: [1, 2, 3]);
      final polynomialDegree1 = Laguerre.realEquation(coefficients: [1, 2]);
      final polynomialDegree0 = Laguerre.realEquation(coefficients: [1]);

      expect(polynomialDegree6.derivative(), isA<Laguerre>());
      expect(polynomialDegree5.derivative(), isA<Quartic>());
      expect(polynomialDegree4.derivative(), isA<Cubic>());
      expect(polynomialDegree3.derivative(), isA<Quadratic>());
      expect(polynomialDegree2.derivative(), isA<Linear>());
      expect(polynomialDegree1.derivative(), isA<Constant>());
      expect(polynomialDegree0.derivative(), isA<Constant>());
    });

    test("Making sure that objects comparison works properly", () {
      final fx = Laguerre.realEquation(coefficients: [1, 2, 3, 4, 5]);
      final otherFx = Laguerre.realEquation(coefficients: [1, 2, 3, 4, 5]);

      expect(fx, equals(otherFx));
      expect(fx == otherFx, isTrue);
      expect(fx.hashCode, equals(otherFx.hashCode));
    });

    test("Making sure that 'copyWith' clones objects correctly", () {
      final laguerre = Laguerre.realEquation(coefficients: [1, 2, 3]);

      // Objects equality
      expect(laguerre, equals(laguerre.copyWith()));
      expect(laguerre, equals(laguerre.copyWith(maxSteps: 8000)));

      // Objects inequality
      expect(laguerre == laguerre.copyWith(maxSteps: 1), isFalse);
    });
  });
}

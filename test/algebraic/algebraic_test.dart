import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../double_approximation_matcher.dart';

void main() {
  group(
      "Testing the public interface of 'Algebraic' which is shared with all "
      "of its concrete subclasses.", () {
    // Tests with complex numbers
    group("Testing the complex 'variant' of the 'from' method", () {
      test(
          "Making sure that a 'Constant' object is properly constructed when "
          "the length of the coefficients list is 1", () {
        final equation = Algebraic.from([
          Complex(1, 0),
        ]);
        expect(equation, isA<Constant>());
      });

      test(
          "Making sure that a 'Linear' object is properly constructed when "
          "the length of the coefficients list is 12", () {
        final equation = Algebraic.from([
          Complex(1, 0),
          Complex(2, 0),
        ]);
        expect(equation, isA<Linear>());

        expect(equation[0], Complex(1, 0));
        expect(equation[1], Complex(2, 0));
        expect(equation.coefficient(1), Complex(1, 0));
        expect(equation.coefficient(0), Complex(2, 0));
      });

      test(
          "Making sure that a 'Quadratic' object is properly constructed when "
          "the length of the coefficients list is 3", () {
        final equation = Algebraic.from([
          Complex(1, 0),
          Complex(2, 0),
          Complex(3, 0),
        ]);
        expect(equation, isA<Quadratic>());
      });

      test(
          "Making sure that a 'Cubic' object is properly constructed when "
          "the length of the coefficients list is 4", () {
        final equation = Algebraic.from([
          Complex(1, 0),
          Complex(2, 0),
          Complex(3, 0),
          Complex(4, 0),
        ]);
        expect(equation, isA<Cubic>());
      });

      test(
          "Making sure that a 'Quartic' object is properly constructed when "
          "the length of the coefficients list is 5", () {
        final equation = Algebraic.from([
          Complex(1, 0),
          Complex(2, 0),
          Complex(3, 0),
          Complex(4, 0),
          Complex(5, 0),
        ]);
        expect(equation, isA<Quartic>());
      });

      test(
          "Making sure that a 'Laguerre' object is properly constructed when "
          "the length of the coefficients list is 6", () {
        final equation = Algebraic.from([
          Complex(1, 0),
          Complex(2, 0),
          Complex(3, 0),
          Complex(4, 0),
          Complex(5, 0),
          Complex(6, 0),
        ]);
        expect(equation, isA<Laguerre>());
      });
    });

    // Tests with real numbers
    group("Testing the real 'variant' of the 'from' method", () {
      test(
          "Making sure that a 'Constant' object is properly constructed when "
          "the length of the coefficients list is 1", () {
        final equation = Algebraic.fromReal([1]);
        expect(equation, isA<Constant>());
      });

      test(
          "Making sure that a 'Linear' object is properly constructed when "
          "the length of the coefficients list is 12", () {
        final equation = Algebraic.fromReal([1, 2]);
        expect(equation, isA<Linear>());
      });

      test(
          "Making sure that a 'Quadratic' object is properly constructed when "
          "the length of the coefficients list is 3", () {
        final equation = Algebraic.fromReal([1, 2, 3]);
        expect(equation, isA<Quadratic>());
      });

      test(
          "Making sure that a 'Cubic' object is properly constructed when "
          "the length of the coefficients list is 4", () {
        final equation = Algebraic.fromReal([1, 2, 3, 4]);
        expect(equation, isA<Cubic>());
      });

      test(
          "Making sure that a 'Quartic' object is properly constructed when "
          "the length of the coefficients list is 5", () {
        final equation = Algebraic.fromReal([1, 2, 3, 4, 5]);
        expect(equation, isA<Quartic>());
      });

      test(
          "Making sure that a 'Laguerre' object is properly constructed when "
          "the length of the coefficients list is 6", () {
        final equation = Algebraic.fromReal([1, 2, 3, 4, 5, 6]);
        expect(equation, isA<Laguerre>());
      });
    });

    group("Testing the evaluation of the integral of a polynomial", () {
      test(
          "Making sure that that the integral of a 'Constant' instance is "
          "properly evaluated on the given upper and lower bounds.", () {
        final constant = Algebraic.from(const [Complex(2, -5)]);
        final integral = constant.evaluateIntegralOn(4, 5);

        expect(integral.real.round(), equals(2));
        expect(integral.imaginary.round(), equals(-5));
      });

      test(
          "Making sure that that the integral of a 'Linear' instance is "
          "properly evaluated on the given upper and lower bounds.", () {
        // Real polynomial test
        final realEq = Linear.realEquation(
          a: -6,
          b: 2,
        );

        final realRes = realEq.evaluateIntegralOn(2, 1);
        expect(realRes.real, MoreOrLessEquals(7, precision: 0));

        // Complex polynomial test
        final complexEq = Linear(
          a: Complex(4, -3),
        );

        final complexRes = complexEq.evaluateIntegralOn(0, 3);
        expect(complexRes.real, MoreOrLessEquals(18, precision: 1.0e-1));
        expect(
            complexRes.imaginary, MoreOrLessEquals(-13.5, precision: 1.0e-1));
      });

      test(
          "Making sure that that the integral of a 'Quadratic' instance is "
          "properly evaluated on the given upper and lower bounds.", () {
        // Real polynomial test
        final realEq = Quadratic.realEquation(
          a: 2,
          c: -5,
        );

        final realRes = realEq.evaluateIntegralOn(1, 3);
        expect(realRes.real, MoreOrLessEquals(7.3, precision: 1.0e-1));

        // Complex polynomial test
        final complexEq = Quadratic(
          a: Complex(3, -5),
          b: Complex(1, 2),
          c: Complex.fromImaginary(4),
        );

        final complexRes = complexEq.evaluateIntegralOn(-1, 5);
        expect(complexRes.real, MoreOrLessEquals(138, precision: 1.0e-1));
        expect(complexRes.imaginary, MoreOrLessEquals(-162, precision: 1.0e-1));
      });

      test(
          "Making sure that that the integral of a 'Cubic' instance is "
          "properly evaluated on the given upper and lower bounds.", () {
        // Real polynomial test
        final realEq = Cubic.realEquation(a: 1, c: 3, d: -5);

        final realRes = realEq.evaluateIntegralOn(1, 3);
        expect(realRes.real.round(), equals(22));

        // Complex polynomial test
        final complexEq = Cubic(
          a: Complex(3, -5),
          b: Complex(1, 2),
          c: Complex.fromImaginary(4),
          d: Complex.fromReal(4),
        );

        final complexRes = complexEq.evaluateIntegralOn(-1, 5);
        expect(complexRes.real, MoreOrLessEquals(534, precision: 1.0e-1));
        expect(complexRes.imaginary, MoreOrLessEquals(-648, precision: 1.0e-1));
      });

      test(
          "Making sure that that the integral of a 'Quartic' instance is "
          "properly evaluated on the given upper and lower bounds.", () {
        // Real polynomial test
        final realEq = Quartic.realEquation(a: 3, b: -1, c: 4, d: 0.5, e: -2);

        final realRes = realEq.evaluateIntegralOn(2, -2);
        expect(realRes.real, MoreOrLessEquals(-51.73, precision: 1.0e-2));

        // Complex polynomial test
        final complexEq = Quartic(
          a: Complex.i(),
          b: Complex(-3, 5),
          c: Complex(4, 1),
          d: -Complex.i(),
        );

        final complexRes = complexEq.evaluateIntegralOn(0.5, 1.2);
        expect(complexRes.real, MoreOrLessEquals(0.6290, precision: 1.0e-4));
        expect(
            complexRes.imaginary, MoreOrLessEquals(2.9446, precision: 1.0e-4));
      });
    });

    group("Testing arithmetic operations on polynomials with real values", () {
      // Tests with complex numbers
      test("Sum of two polynomials", () {
        final complex1 = Algebraic.from(
            [Complex(-3, 10), Complex.i(), Complex.fromImaginary(6)]);
        final complex2 = Algebraic.fromReal([1, 5]);

        final sum = complex1 + complex2;
        final sumResult = Algebraic.from([
          Complex(-3, 10),
          Complex(1, 1),
          Complex(5, 6),
        ]);

        expect(sum, equals(sumResult));
        expect(sum, equals(complex2 + complex1));
        expect(sum, isA<Quadratic>());
      });

      test("Difference of two polynomials", () {
        final complex1 = Algebraic.from([
          Complex(-4, -7),
          Complex(2, 3),
          Complex.zero(),
        ]);
        final complex2 = Algebraic.from([
          Complex(3, 6),
          -Complex.i(),
          Complex(7, -8),
          Complex(1, -3),
          Complex(5, 6),
        ]);

        final diff = complex1 - complex2;
        final diffResult = Algebraic.from([
          Complex(-3, -6),
          Complex.i(),
          Complex(-11, 1),
          Complex(1, 6),
          -Complex(5, 6),
        ]);

        expect(diff, equals(diffResult));
        expect(complex2 - complex1, equals(-diffResult));
        expect(diffResult, isA<Quartic>());
      });

      test("Product of two polynomials", () {
        final complex1 = Algebraic.from([
          Complex.fromImaginaryFraction(Fraction(6, 2)),
          -Complex.i(),
        ]);
        final complex2 = Algebraic.from([
          Complex(4, 2),
          Complex.fromImaginary(19),
          Complex(9, -16),
          Complex(-2, 3),
        ]);

        final prod = complex1 * complex2;
        final prodResult = Algebraic.from([
          Complex(-6, 12),
          Complex(-55, -4),
          Complex(67, 27),
          Complex(-25, -15),
          Complex(3, 2),
        ]);

        expect(prod, equals(prodResult));
        expect(prod, equals(complex2 * complex1));
        expect(prod, isA<Quartic>());
      });

      // Tests with real numbers
      test("Sum of two polynomials", () {
        final quadratic = Algebraic.fromReal([3, -2, 5]);
        final linear = Algebraic.fromReal([4, -10]);

        final sum = quadratic + linear;
        final sumResult = Algebraic.fromReal([3, 2, -5]);

        expect(sum, equals(sumResult));
        expect(sum, equals(linear + quadratic));
        expect(sum, isA<Quadratic>());
      });

      test("Difference of two polynomials", () {
        final quadratic = Algebraic.fromReal([3, -2, 1]);
        final quartic = Algebraic.fromReal([4, 6, 5, -3, 8]);

        final diff = quadratic - quartic;
        final diffResult = Algebraic.fromReal([-4, -6, -2, 1, -7]);

        expect(diff, equals(diffResult));
        expect(quartic - quadratic, equals(-diffResult));
        expect(diffResult, isA<Quartic>());
      });

      test("Product of two polynomials", () {
        final linear = Algebraic.fromReal([2, -2]);
        final cubic = Algebraic.fromReal([1, 0, -4, 5]);

        final prod = linear * cubic;
        final prodResult = Algebraic.fromReal([2, -2, -8, 18, -10]);

        expect(prod, equals(prodResult));
        expect(prod, equals(cubic * linear));
        expect(prod, isA<Quartic>());
      });
    });
  });
}

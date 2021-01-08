import 'package:equations/equations.dart';
import 'package:test/test.dart';

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

    group("Testing arithmetic operations on polynomials with real values", () {
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

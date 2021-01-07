import 'package:equations/equations.dart';
import 'package:test/test.dart';

void main() {
  group("Testing static methods of 'Algebraic'", () {
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

    group("Testing arithmetic operations on polynomials", () {
      test("Sum of two polynomials", () {
        final quadratic = Algebraic.fromReal([3, -2, 5]);
        final linear = Algebraic.fromReal([4, -10]);

        final sum = Algebraic.fromReal([3, 2, -5]);
        expect(quadratic + linear, equals(sum));
      });

      test("Difference of two polynomials", () {
        final quadratic = Algebraic.fromReal([3, -2, 1]);
        final quartic = Algebraic.fromReal([4, 6, 5, -3, 8]);

        final diff = Algebraic.fromReal([-4, -6, -2, 1, -7]);
        expect(quadratic - quartic, equals(diff));
      });
    });
  });
}

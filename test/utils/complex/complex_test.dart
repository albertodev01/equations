import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing constructors", () {
    test(("Making sure that the default constructor works as expected"), () {
      final complex = Complex(-2, 6);

      expect(complex.real, -2);
      expect(complex.imaginary, 6);
    });

    test(
        ("Making sure that real numbers are properly converted into complex ones."),
        () {
      final complex = Complex.fromReal(7.0);

      expect(complex.real, 7);
      expect(complex.imaginary, 0);
    });

    test(
        ("Making sure that real numbers are properly converted into complex ones"),
        () {
      final c = Complex.fromImaginary(7);

      expect(c.real, 0);
      expect(c.imaginary, 7);
    });

    test(("Fractional numbers constructor"), () {
      final c = Complex.fromFraction(Fraction(1), Fraction(2, 4));

      expect(c.real, 1);
      expect(c.imaginary, 0.5);
    });

    test(("Polar coordinates conversions"), () {
      // From polar
      final fromPolar = Complex.fromPolar(2, 60, angleInRadians: false);
      expect(fromPolar.real.round(), 1);
      expect(fromPolar.imaginary, math.sqrt(3));

      final fromPolar2 = Complex.fromPolar(0, 0);
      expect(fromPolar2.real, 0);
      expect(fromPolar2.imaginary, 0);

      final oneOverSqrtTwo = (1 / math.sqrt(2)).toStringAsFixed(12);
      final fromPolar3 = Complex.fromPolar(1, math.pi / 4);
      expect(fromPolar3.real.toStringAsFixed(12), oneOverSqrtTwo);
      expect(fromPolar3.imaginary.toStringAsFixed(12), oneOverSqrtTwo);

      // To polar
      final toPolar = Complex(5, -7).toPolarCoordinates();
      expect(toPolar.r, math.sqrt(74));
      expect(toPolar.phiDegrees.toStringAsFixed(4), "-54.4623");
      expect(toPolar.phiRadians.toStringAsFixed(4), "-0.9505");

      final toPolar2 = Complex(5, 1).toPolarCoordinates();
      expect(toPolar2.r, math.sqrt(26));
      expect(toPolar2.phiDegrees.toStringAsFixed(4), "11.3099");
      expect(toPolar2.phiRadians.toStringAsFixed(4), "0.1974");
    });

    test(("Real numbers constructor"), () {
      final c = Complex.fromReal(7);

      expect(c.real, 7);
      expect(c.imaginary, 0);
    });

    test(("Imaginary constructor"), () {
      final c = Complex.i();

      expect(c.real, 0);
      expect(c.imaginary, 1);
    });

    test(("Printing values"), () {
      expect("${Complex(-2, 6)}", "-2 + 6i");
      expect("${Complex(-2, -6)}", "-2 - 6i");
      expect("${Complex(-2.1, 6.3)}", "-2.1 + 6.3i");

      expect("${Complex.fromImaginary(3)}", "3i");
      expect("${Complex.fromImaginary(-3)}", "-3i");

      expect("${Complex.fromReal(3)}", "3");
      expect("${Complex.fromReal(-3)}", "-3");

      expect(Complex(0.5, 3.2).toStringAsFraction(), "1/2 + 16/5i");
      expect(Complex(-0.5, -3.2).toStringAsFraction(), "-1/2 - 16/5i");
      expect(Complex(-0.5, 3.2).toStringAsFraction(), "-1/2 + 16/5i");
      expect(Complex(0.5, -3.2).toStringAsFraction(), "1/2 - 16/5i");

      expect(Complex(1, -3).toStringWithParenthesis(), "(1 - 3i)");
      expect(Complex(7, 0).toStringWithParenthesis(), "7");
      expect(Complex(0, 7).toStringWithParenthesis(), "7i");
      expect(Complex(0, -7).toStringWithParenthesis(), "-7i");
    });

    test(("Equality"), () {
      final c = Complex(1, 3);

      expect(c == c, true);
      expect(c == Complex(1, 3), true);
      expect(c == Complex.fromFraction(Fraction(1), Fraction(6, 2)), true);
      expect(c == Complex(-1, 3), false);
    });
  });

  group("Testing complex numbers operators", () {
    test("operator +", () {
      final value = Complex(3, -5) + Complex(-8, 13);

      expect(value.real, -5);
      expect(value.imaginary, 8);

      final value2 = Complex.fromReal(5) + Complex.fromImaginary(-16);

      expect(value2.real, 5);
      expect(value2.imaginary, -16);
    });

    test("operator -", () {
      final value = Complex(3, -5) - Complex(-8, 13);

      expect(value.real, 11);
      expect(value.imaginary, -18);

      final value2 = Complex.fromReal(5) - Complex.fromImaginary(-16);

      expect(value2.real, 5);
      expect(value2.imaginary, 16);
    });

    test("operator *", () {
      final value = Complex(3, -5) * Complex(-8, 13);

      expect(value.real, 41);
      expect(value.imaginary, 79);

      final value2 = Complex.fromReal(5) * Complex.fromImaginary(-16);

      expect(value2.real, 0);
      expect(value2.imaginary, -80);
    });

    test("operator /", () {
      final value = Complex(3, -5) / Complex(-8, 13);
      final realValue = Fraction(-89, 233).toDouble();
      final imagValue = Fraction(1, 233).toDouble();

      // Equality of a double is hard to achieve due to approximations, so I
      // prefer checking the strings with a fixed precision which works better
      expect(value.real.toStringAsFixed(12), realValue.toStringAsFixed(12));
      expect(
          value.imaginary.toStringAsFixed(12), imagValue.toStringAsFixed(12));

      final value2 = Complex.fromReal(5) / Complex.fromImaginary(-16);

      expect(value2.real, 0);
      expect(value2.imaginary, 0.3125);
    });
  });

  group("Testing complex numbers properties", () {
    test("Conjugate", () {
      expect(Complex(3, 7).conjugate(), Complex(3, -7));
      expect(Complex(3, -7).conjugate(), Complex(3, 7));
    });

    test("Reciprocal", () {
      expect(Complex(2, 1).reciprocal(), Complex(0.4, -0.2));
      expect(Complex.fromImaginary(1).conjugate(), Complex.fromImaginary(-1));
    });

    test("Modulus/magnitude/absolute value", () {
      expect(Complex(3, 7).abs().toStringAsFixed(12),
          math.sqrt(58).toStringAsFixed(12));
    });

    test("Exponent -> e^z where z = a + bi", () {
      final value = Complex(3, 7).exp(); // e^(3 + 7i)

      expect(value.real.toStringAsFixed(12), "15.142531566087");
      expect(value.imaginary.toStringAsFixed(12), "13.195928586606");

      final value2 = Complex.i().exp(); // e^i
      expect(value2.real.toStringAsFixed(12), "0.540302305868");
      expect(value2.imaginary.toStringAsFixed(12), "0.841470984808");
    });

    test("Trig functions", () {
      final value = Complex.i().sin();
      //expect(value, Complex.fromImaginary(_sinh(1)));

      final value2 = Complex.i().cos();
      //expect(value2, Complex.fromReal(_cosh(1)));

      final value3 = Complex.i().tan();
      expect(value3, value / value2);
      // tan(i) = tanh(1)i = (sinh(1) / cosh(1))i
      //expect(value3.abs().toStringAsFixed(12),
      //    Complex.fromImaginary(_sinh(1) / _cosh(1)).abs.toStringAsFixed(12));
    });

    test("Complex roots", () {
      final sqrt = Complex(5, 1).sqrt();
      expect(sqrt.real.toStringAsFixed(12), "2.247111425096");
      expect(sqrt.imaginary.toStringAsFixed(12), "0.222507880302");

      final fifthRoot = Complex(5, 1).nthRoot(5);
      expect(fifthRoot.real.toStringAsFixed(12), "1.384072376713");
      expect(fifthRoot.imaginary.toStringAsFixed(12), "0.054670354363");
    });

    test("Zero", () {
      final value = Complex.zero();

      expect(value.abs(), 0);
      expect(value.isZero, true);
    });

    test("Negate", () {
      final value = Complex.i().negate;

      expect(value.real, 0);
      expect(value.imaginary, -1);
    });

    test("Power", () {
      final pow1 = Complex(2, 7).pow(4);
      expect(pow1.real.round(), 1241);
      expect(pow1.imaginary.round(), -2520);

      final pow2 = Complex(-2, -7).pow(3);
      expect(pow2.real.round(), 286);
      expect(pow2.imaginary.round(), 259);

      final pow3 = Complex(2, -1).pow(2);
      expect(pow3.real.round(), 3);
      expect(pow3.imaginary.round(), -4);
    });
  });
}

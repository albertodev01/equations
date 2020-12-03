import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:fraction/fraction.dart';
import 'package:test/test.dart';

void main() {
  group("Testing constructors", () {
    test("Making sure that the default constructor works as expected", () {
      final complex = Complex(-2, 6);

      expect(complex.real, -2);
      expect(complex.imaginary, 6);
    });

    test(
        "Making sure that real numbers are properly converted into complex ones.",
        () {
      expect(Complex.fromReal(7.0).real, equals(7));
      expect(Complex.fromReal(7.0).imaginary, isZero);

      expect(Complex.fromImaginary(7.0).real, isZero);
      expect(Complex.fromImaginary(7.0).imaginary, equals(7));
    });

    test("Making sure that named constructor for '0' and 'i' work.", () {
      final zero = Complex.zero();
      expect(zero.real, isZero);
      expect(zero.imaginary, isZero);

      final i = Complex.i();
      expect(i.real, isZero);
      expect(i.imaginary, equals(1));
    });

    test(
        "Making sure that Complex objects are properly built from Fraction objects",
        () {
      final fromFraction = Complex.fromFraction(Fraction(3, 5), Fraction(1, 4));
      expect(fromFraction.real, equals(0.6));
      expect(fromFraction.imaginary, equals(0.25));

      final fromRealFraction = Complex.fromRealFraction(Fraction(3, 5));
      expect(fromRealFraction.real, equals(0.6));
      expect(fromRealFraction.imaginary, isZero);

      final fromImaginaryFraction =
          Complex.fromImaginaryFraction(Fraction(1, 4));
      expect(fromImaginaryFraction.real, isZero);
      expect(fromImaginaryFraction.imaginary, equals(0.25));

      final fromMixedFraction = Complex.fromMixedFraction(
          MixedFraction.fromString("2 1/2"), MixedFraction.fromString("1 3/5"));
      expect(fromMixedFraction.real, equals(2.5));
      expect(fromMixedFraction.imaginary, equals(1.6));

      final fromRealMixedFraction =
          Complex.fromRealMixedFraction(MixedFraction.fromString("2 1/2"));
      expect(fromRealMixedFraction.real, equals(2.5));
      expect(fromRealMixedFraction.imaginary, isZero);

      final fromImaginaryMixedFraction =
          Complex.fromImaginaryMixedFraction(MixedFraction.fromString("2 1/2"));
      expect(fromImaginaryMixedFraction.real, isZero);
      expect(fromImaginaryMixedFraction.imaginary, equals(2.5));
    });

    test(("Polar coordinates conversions"), () {
      // From polar
      final fromPolar = Complex.fromPolar(2, 60, angleInRadians: false);
      expect(fromPolar.real.round(), equals(1));
      expect(fromPolar.imaginary, equals(math.sqrt(3)));

      final fromPolar2 = Complex.fromPolar(0, 0);
      expect(fromPolar2.real, isZero);
      expect(fromPolar2.imaginary, isZero);

      final oneOverSqrtTwo = (1 / math.sqrt(2)).toStringAsFixed(12);
      final fromPolar3 = Complex.fromPolar(1, math.pi / 4);
      expect(fromPolar3.real.toStringAsFixed(12), equals(oneOverSqrtTwo));
      expect(fromPolar3.imaginary.toStringAsFixed(12), equals(oneOverSqrtTwo));

      // To polar
      final toPolar = Complex(5, -7).toPolarCoordinates();
      expect(toPolar.r, math.sqrt(74));
      expect(toPolar.phiDegrees.toStringAsFixed(4), equals("-54.4623"));
      expect(toPolar.phiRadians.toStringAsFixed(4), equals("-0.9505"));

      final toPolar2 = Complex(5, 1).toPolarCoordinates();
      expect(toPolar2.r, math.sqrt(26));
      expect(toPolar2.phiDegrees.toStringAsFixed(4), equals("11.3099"));
      expect(toPolar2.phiRadians.toStringAsFixed(4), equals("0.1974"));
    });

    test(("Printing values"), () {
      expect("${Complex(-2, 6)}", equals("-2 + 6i"));
      expect("${Complex(-2, -6)}", equals("-2 - 6i"));
      expect("${Complex(-2.1, 6.3)}", equals("-2.1 + 6.3i"));

      expect("${Complex.fromImaginary(3)}", equals("3i"));
      expect("${Complex.fromImaginary(-3)}", equals("-3i"));

      expect("${Complex.fromReal(3)}", equals("3"));
      expect("${Complex.fromReal(-3)}", equals("-3"));

      expect(Complex(0.5, 3.2).toStringAsFraction(), equals("1/2 + 16/5i"));
      expect(Complex(-0.5, -3.2).toStringAsFraction(), equals("-1/2 - 16/5i"));
      expect(Complex(-0.5, 3.2).toStringAsFraction(), equals("-1/2 + 16/5i"));
      expect(Complex(0.5, -3.2).toStringAsFraction(), equals("1/2 - 16/5i"));

      expect(Complex(2, -3).toStringWithParenthesis(), equals("(2 - 3i)"));
      expect(Complex(-2, -3).toStringWithParenthesis(), equals("(-2 - 3i)"));
      expect(Complex(7, 0).toStringWithParenthesis(), equals("7"));
      expect(Complex(0, 7).toStringWithParenthesis(), equals("7i"));
      expect(Complex(0, -7).toStringWithParenthesis(), equals("-7i"));
    });
  });

  group("Testing objects equality", () {
    test("Making sure that complex comparison is made via cross product", () {
      expect(Complex(3, 12) == Complex(3, 12), isTrue);
      expect(Complex(-3, -12) == Complex(6, 13), isFalse);

      expect(Complex(3, 12).hashCode == Complex(3, 12).hashCode, isTrue);
      expect(Complex(-6, -13).hashCode == Complex(6, 13).hashCode, isFalse);
    });

    test(
        "Making sure that 'compareTo' returns 1, -1 or 0 according with the natural sorting",
        () {
      expect(Complex(2, 1).compareTo(Complex(3, 7)), equals(-1));
      expect(Complex(3, 7).compareTo(Complex(2, 1)), equals(1));
      expect(Complex(3, 5).compareTo(Complex(3, 5)), equals(0));
    });
  });

  group("Testing the API of the Complex class", () {
    test(
        "Making sure that the conjugate changes the sign of the imaginary part",
        () {
      expect(Complex(3, 7).conjugate(), equals(Complex(3, -7)));
      expect(Complex(3, -7).conjugate(), equals(Complex(3, 7)));
    });

    test("Making sure that the reciprocal is actually 1/(a + bi)", () {
      expect(Complex(2, 1).reciprocal(), equals(Complex(0.4, -0.2)));
      expect(Complex.fromImaginary(1).conjugate(),
          equals(Complex.fromImaginary(-1)));

      expect(
          () => Complex.zero().reciprocal(), throwsA(isA<ComplexException>()));
    });

    test(
        "Making sure that modulus (or 'magnitude' or 'absolute' value) is correct",
        () {
      expect(Complex(3, 7).abs().toStringAsFixed(12),
          equals(math.sqrt(58).toStringAsFixed(12)));
    });

    test("Making sure that the exponential works properly", () {
      final value = Complex(3, 7).exp(); // e^(3 + 7i)

      expect(value.real.toStringAsFixed(12), equals("15.142531566087"));
      expect(value.imaginary.toStringAsFixed(12), equals("13.195928586606"));

      final value2 = Complex.i().exp(); // e^i
      expect(value2.real.toStringAsFixed(12), equals("0.540302305868"));
      expect(value2.imaginary.toStringAsFixed(12), equals("0.841470984808"));
    });

    test(
        "Making sure that sine, cosine, tangent and cotangents work properly on Complex",
        () {
      final i = Complex.i();

      expect(i.sin().real, isZero);
      expect(i.sin().imaginary.toStringAsFixed(12), equals("1.175201193644"));
      expect(i.cos().real.toStringAsFixed(12), equals("1.543080634815"));
      expect(i.cos().imaginary, isZero);
      expect(i.cos() / i.sin(), equals(i.cot()));
      expect(i.sin() / i.cos(), equals(i.tan()));
    });

    test("Making sure that the n-th root of the complex number is correct", () {
      final sqrt = Complex(5, 1).sqrt();
      expect(sqrt.real.toStringAsFixed(12), equals("2.247111425096"));
      expect(sqrt.imaginary.toStringAsFixed(12), equals("0.222507880302"));

      final fifthRoot = Complex(5, 1).nthRoot(5);
      expect(fifthRoot.real.toStringAsFixed(12), equals("1.384072376713"));
      expect(fifthRoot.imaginary.toStringAsFixed(12), equals("0.054670354363"));
    });

    test("Making sure that the 'power' operation properly works", () {
      final pow1 = Complex(2, 7).pow(4);
      expect(pow1.real.round(), equals(1241));
      expect(pow1.imaginary.round(), equals(-2520));

      final pow2 = Complex(-2, -7).pow(3);
      expect(pow2.real.round(), equals(286));
      expect(pow2.imaginary.round(), equals(259));

      final pow3 = Complex(2, -1).pow(2);
      expect(pow3.real.round(), equals(3));
      expect(pow3.imaginary.round(), equals(-4));
    });
  });

  group("Testing complex numbers operators", () {
    test("Making sure that the sum between two complex numbers is correct", () {
      final value = Complex(3, -5) + Complex(-8, 13);
      expect(value.real, equals(-5));
      expect(value.imaginary, equals(8));

      final value2 = Complex.fromReal(5) + Complex.fromImaginary(-16);
      expect(value2.real, equals(5));
      expect(value2.imaginary, equals(-16));
    });

    test(
        "Making sure that the difference between two complex numbers is correct",
        () {
      final value = Complex(3, -5) - Complex(-8, 13);
      expect(value.real, equals(11));
      expect(value.imaginary, equals(-18));

      final value2 = Complex.fromReal(5) - Complex.fromImaginary(-16);
      expect(value2.real, equals(5));
      expect(value2.imaginary, equals(16));
    });

    test("Making sure that the product between two complex numbers is correct",
        () {
      final value = Complex(3, -5) * Complex(-8, 13);
      expect(value.real, equals(41));
      expect(value.imaginary, equals(79));

      final value2 = Complex.fromReal(5) * Complex.fromImaginary(-16);
      expect(value2.real, equals(0));
      expect(value2.imaginary, equals(-80));
    });

    test("Making sure that the quotient between two complex numbers is correct",
        () {
      final value = Complex(3, -5) / Complex(-8, 13);
      final realValue = Fraction(-89, 233).toDouble();
      final imagValue = Fraction(1, 233).toDouble();

      // Equality of a double is hard to achieve due to approximations, so I
      // prefer checking the strings with a fixed precision which works better
      expect(value.real.toStringAsFixed(12),
          equals(realValue.toStringAsFixed(12)));
      expect(value.imaginary.toStringAsFixed(12),
          equals(imagValue.toStringAsFixed(12)));

      final value2 = Complex.fromReal(5) / Complex.fromImaginary(-16);
      expect(value2.real, equals(0));
      expect(value2.imaginary, equals(0.3125));
    });
  });
}

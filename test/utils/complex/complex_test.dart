import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('Testing constructors', () {
    test('Making sure that the default constructor works as expected', () {
      const complex = Complex(-2, 6);

      expect(complex.real, -2);
      expect(complex.imaginary, 6);
    });

    test(
      'Making sure that real numbers are properly converted into complex ones.',
      () {
        expect(const Complex.fromReal(7.0).real, equals(7));
        expect(const Complex.fromReal(7.0).imaginary, isZero);

        expect(const Complex.fromImaginary(7.0).real, isZero);
        expect(const Complex.fromImaginary(7.0).imaginary, equals(7));
      },
    );

    test("Making sure that named constructor for '0' and 'i' work.", () {
      const zero = Complex.zero();
      expect(zero.real, isZero);
      expect(zero.imaginary, isZero);

      const i = Complex.i();
      expect(i.real, isZero);
      expect(i.imaginary, equals(1));
    });

    test(
      'Making sure that const Complex objects are properly built from Fraction '
      'objects',
      () {
        final fromFraction = Complex.fromFraction(
          Fraction(3, 5),
          Fraction(1, 4),
        );
        expect(fromFraction.real, equals(0.6));
        expect(fromFraction.imaginary, equals(0.25));

        final fromRealFraction = Complex.fromRealFraction(Fraction(3, 5));
        expect(fromRealFraction.real, equals(0.6));
        expect(fromRealFraction.imaginary, isZero);

        final fromImaginaryFraction = Complex.fromImaginaryFraction(
          Fraction(1, 4),
        );
        expect(fromImaginaryFraction.real, isZero);
        expect(
          fromImaginaryFraction.imaginary,
          equals(0.25),
        );

        final fromMixedFraction = Complex.fromMixedFraction(
          MixedFraction.fromString('2 1/2'),
          MixedFraction.fromString('1 3/5'),
        );
        expect(
          fromMixedFraction.real,
          equals(2.5),
        );
        expect(
          fromMixedFraction.imaginary,
          equals(1.6),
        );

        final fromRealMixedFraction = Complex.fromRealMixedFraction(
          MixedFraction.fromString('2 1/2'),
        );
        expect(
          fromRealMixedFraction.real,
          equals(2.5),
        );
        expect(fromRealMixedFraction.imaginary, isZero);

        final fromImaginaryMixedFraction = Complex.fromImaginaryMixedFraction(
          MixedFraction.fromString('2 1/2'),
        );
        expect(fromImaginaryMixedFraction.real, isZero);
        expect(
          fromImaginaryMixedFraction.imaginary,
          equals(2.5),
        );
      },
    );

    test('Polar coordinates conversions', () {
      // From polar
      final fromPolar = Complex.fromPolar(2, 60, angleInRadians: false);
      expect(
        fromPolar.real.round(),
        equals(1),
      );
      expect(
        fromPolar.imaginary,
        equals(math.sqrt(3)),
      );

      final fromPolar2 = Complex.fromPolar(0, 0);
      expect(fromPolar2.real, isZero);
      expect(fromPolar2.imaginary, isZero);

      final oneOverSqrtTwo = 1 / math.sqrt(2);
      final fromPolar3 = Complex.fromPolar(1, math.pi / 4);
      expect(
        fromPolar3.real,
        MoreOrLessEquals(oneOverSqrtTwo),
      );
      expect(
        fromPolar3.imaginary,
        MoreOrLessEquals(oneOverSqrtTwo),
      );

      // To polar
      final toPolar = const Complex(5, -7).toPolarCoordinates();
      expect(toPolar.r, math.sqrt(74));
      expect(
        toPolar.phiDegrees,
        const MoreOrLessEquals(-54.4623, precision: 1.0e-4),
      );
      expect(
        toPolar.phiRadians,
        const MoreOrLessEquals(-0.9505, precision: 1.0e-4),
      );

      final toPolar2 = const Complex(5, 1).toPolarCoordinates();
      expect(toPolar2.r, math.sqrt(26));
      expect(
        toPolar2.phiDegrees,
        const MoreOrLessEquals(11.3099, precision: 1.0e-4),
      );
      expect(
        toPolar2.phiRadians,
        const MoreOrLessEquals(0.1974, precision: 1.0e-4),
      );
    });

    test('Printing values', () {
      expect('${const Complex(-2, 6)}', equals('-2 + 6i'));
      expect('${const Complex(-2, -6)}', equals('-2 - 6i'));
      expect('${const Complex(-2.1, 6.3)}', equals('-2.1 + 6.3i'));

      expect('${const Complex.fromImaginary(3)}', equals('3i'));
      expect('${const Complex.fromImaginary(-3)}', equals('-3i'));

      expect('${const Complex.fromReal(3)}', equals('3'));
      expect('${const Complex.fromReal(-3)}', equals('-3'));

      expect(
        const Complex(0.5, 3.2).toStringAsFraction(),
        equals('1/2 + 16/5i'),
      );
      expect(
        const Complex(-0.5, -3.2).toStringAsFraction(),
        equals('-1/2 - 16/5i'),
      );
      expect(
        const Complex(-0.5, 3.2).toStringAsFraction(),
        equals('-1/2 + 16/5i'),
      );
      expect(
        const Complex(0.5, -3.2).toStringAsFraction(),
        equals('1/2 - 16/5i'),
      );

      expect(
        const Complex(2, -3).toStringWithParenthesis(),
        equals('(2 - 3i)'),
      );
      expect(
        const Complex(-2, -3).toStringWithParenthesis(),
        equals('(-2 - 3i)'),
      );
      expect(
        const Complex(7, 0).toStringWithParenthesis(),
        equals('7'),
      );
      expect(
        const Complex(0, 7).toStringWithParenthesis(),
        equals('7i'),
      );
      expect(
        const Complex(0, -7).toStringWithParenthesis(),
        equals('-7i'),
      );

      expect(
        const Complex(1.123, 9.876).toStringAsFixed(1),
        equals('1.1 + 9.9i'),
      );
      expect(
        const Complex(1.123, -9.876).toStringAsFixed(1),
        equals('1.1 - 9.9i'),
      );
      expect(
        const Complex(1.123, 9.876).toStringAsFixed(0),
        equals('1 + 10i'),
      );
      expect(
        const Complex.fromReal(13.345678).toStringAsFixed(3),
        equals('13.346'),
      );
      expect(
        const Complex.fromImaginary(13.345678).toStringAsFixed(3),
        equals('13.346i'),
      );
      expect(
        const Complex.fromImaginary(13.345678).toStringAsFixed(0),
        equals('13i'),
      );
      expect(
        const Complex.fromImaginary(13.2).toStringAsFixed(3),
        equals('13.200i'),
      );
      expect(
        const Complex.fromReal(13.47).toStringAsFixed(5),
        equals('13.47000'),
      );
    });
  });

  group('Testing objects equality', () {
    test('Making sure that complex comparison is made via cross product', () {
      expect(const Complex(3, 12) == const Complex(3, 12), isTrue);
      expect(const Complex(3, 12) == const Complex(3, 12), isTrue);
      expect(const Complex(-3, -12) == const Complex(6, 13), isFalse);
      expect(const Complex(6, 13) == const Complex(-3, -12), isFalse);

      expect(
        const Complex(3, 12).hashCode == const Complex(3, 12).hashCode,
        isTrue,
      );
      expect(
        const Complex(-6, -13).hashCode == const Complex(6, 13).hashCode,
        isFalse,
      );
    });

    test(
      "Making sure that 'compareTo' returns 1, -1 or 0 according with the "
      'natural sorting',
      () {
        expect(const Complex(2, 1).compareTo(const Complex(3, 7)), equals(-1));
        expect(const Complex(3, 7).compareTo(const Complex(2, 1)), equals(1));
        expect(const Complex(3, 5).compareTo(const Complex(3, 5)), equals(0));
      },
    );

    test("Making sure that 'copyWith' clones objects correctly", () {
      const complex = Complex(8, -11);

      // Objects equality
      expect(complex, equals(complex.copyWith()));
      expect(complex, equals(complex.copyWith(real: 8, imaginary: -11)));

      // Objects inequality
      expect(complex == complex.copyWith(real: 1), isFalse);
    });
  });

  group('Testing the API of the const Complex class', () {
    test(
      'Making sure that the conjugate changes the sign of the imaginary part',
      () {
        expect(
          const Complex(3, 7).conjugate(),
          equals(const Complex(3, -7)),
        );
        expect(
          const Complex(3, -7).conjugate(),
          equals(const Complex(3, 7)),
        );
      },
    );

    test('Making sure that the reciprocal is actually 1/(a + bi)', () {
      expect(
        const Complex(2, 1).reciprocal(),
        equals(const Complex(0.4, -0.2)),
      );
      expect(
        const Complex.fromImaginary(1).conjugate(),
        equals(const Complex.fromImaginary(-1)),
      );

      expect(
        () => const Complex.zero().reciprocal(),
        throwsA(isA<ComplexException>()),
      );
    });

    test(
      "Making sure that modulus (or 'magnitude' or 'absolute' value) is correct",
      () {
        expect(
          const Complex(3, 7).abs(),
          MoreOrLessEquals(math.sqrt(58)),
        );
      },
    );

    test('Making sure that the exponential works properly', () {
      final value = const Complex(3, 7).exp(); // e^(3 + 7i)
      expect(
        value.real,
        const MoreOrLessEquals(15.142531566087),
      );
      expect(
        value.imaginary,
        const MoreOrLessEquals(13.195928586606),
      );

      final value2 = const Complex.i().exp(); // e^i
      expect(
        value2.real,
        const MoreOrLessEquals(0.540302305868),
      );
      expect(
        value2.imaginary,
        const MoreOrLessEquals(0.841470984808),
      );
    });

    test(
      'Making sure that sine, cosine, tangent and cotangents work properly on const Complex',
      () {
        const i = Complex.i();

        expect(i.sin().real, isZero);
        expect(
          i.sin().imaginary,
          const MoreOrLessEquals(1.175201193644),
        );
        expect(
          i.cos().real,
          const MoreOrLessEquals(1.543080634815),
        );
        expect(i.cos().imaginary, isZero);
        expect(
          i.cos() / i.sin(),
          equals(i.cot()),
        );
        expect(
          i.sin() / i.cos(),
          equals(i.tan()),
        );
      },
    );

    test('Making sure that the n-th root of the complex number is correct', () {
      final sqrt = const Complex(5, 1).sqrt();
      expect(
        sqrt.real,
        const MoreOrLessEquals(2.247111425096),
      );
      expect(
        sqrt.imaginary,
        const MoreOrLessEquals(0.222507880302),
      );

      final fifthRoot = const Complex(5, 1).nthRoot(5);
      expect(
        fifthRoot.real,
        const MoreOrLessEquals(1.384072376713),
      );
      expect(
        fifthRoot.imaginary,
        const MoreOrLessEquals(0.054670354363),
      );

      final negativeRoot = const Complex(5, 1).nthRoot(-2);
      expect(
        negativeRoot.real,
        const MoreOrLessEquals(0.440694807915),
      );
      expect(
        negativeRoot.imaginary,
        const MoreOrLessEquals(-0.043637385523),
      );

      final noRoot = const Complex(5, 1).nthRoot(1);
      expect(
        noRoot.real,
        equals(5),
      );
      expect(
        noRoot.imaginary,
        equals(1),
      );
    });

    test(
      "Making sure that the 'nthRoot' method also works when the phase is negative",
      () {
        const negativePhase = Complex(-0.5, -1);
        final negativePhaseRoot = negativePhase.nthRoot(2);

        expect(negativePhase.phase(), isNegative);
        expect(
          negativePhase.phase(),
          const MoreOrLessEquals(-2.03444, precision: 1.0e-5),
        );

        expect(negativePhaseRoot.real.round(), -1);
        expect(
          negativePhaseRoot.imaginary,
          const MoreOrLessEquals(0.899453719973),
        );
      },
    );

    test("Making sure that the 'power' operation properly works", () {
      final pow1 = const Complex(2, 7).pow(4);
      expect(pow1.real.round(), equals(1241));
      expect(pow1.imaginary.round(), equals(-2520));

      final pow2 = const Complex(-2, -7).pow(3);
      expect(pow2.real.round(), equals(286));
      expect(pow2.imaginary.round(), equals(259));

      final pow3 = const Complex(2, -1).pow(2);
      expect(pow3.real.round(), equals(3));
      expect(pow3.imaginary.round(), equals(-4));
    });
  });

  group('Testing complex numbers operators', () {
    test('Making sure that the sum between two complex numbers is correct', () {
      final value = const Complex(3, -5) + const Complex(-8, 13);
      expect(value.real, equals(-5));
      expect(value.imaginary, equals(8));

      final value2 =
          const Complex.fromReal(5) + const Complex.fromImaginary(-16);
      expect(value2.real, equals(5));
      expect(value2.imaginary, equals(-16));
    });

    test(
      'Making sure that the difference between two complex numbers is correct',
      () {
        final value = const Complex(3, -5) - const Complex(-8, 13);
        expect(value.real, equals(11));
        expect(value.imaginary, equals(-18));

        final value2 =
            const Complex.fromReal(5) - const Complex.fromImaginary(-16);
        expect(value2.real, equals(5));
        expect(value2.imaginary, equals(16));
      },
    );

    test(
      'Making sure that the product between two complex numbers is correct',
      () {
        final value = const Complex(3, -5) * const Complex(-8, 13);
        expect(value.real, equals(41));
        expect(value.imaginary, equals(79));

        final value2 =
            const Complex.fromReal(5) * const Complex.fromImaginary(-16);
        expect(value2.real, equals(0));
        expect(value2.imaginary, equals(-80));
      },
    );

    test('Making sure that complex objects are properly compared', () {
      const five = Complex.fromReal(5);
      const ten = Complex.fromReal(10);

      expect(five > ten, isFalse);
      expect(five >= ten, isFalse);
      expect(five < ten, isTrue);
      expect(five <= ten, isTrue);
    });

    test(
      'Making sure that the quotient between two complex numbers is correct',
      () {
        final value = const Complex(3, -5) / const Complex(-8, 13);
        final realValue = Fraction(-89, 233).toDouble();
        final imagValue = Fraction(1, 233).toDouble();

        // Equality of a double is hard to achieve due to approximations, so I
        // prefer checking the strings with a fixed precision which works better
        expect(value.real, MoreOrLessEquals(realValue));
        expect(value.imaginary, MoreOrLessEquals(imagValue));

        final v2 = const Complex.fromReal(5) / const Complex.fromImaginary(-16);
        expect(v2.real, equals(0));
        expect(v2.imaginary, equals(0.3125));
      },
    );

    test('Making sure that the negation works properly.', () {
      const value = Complex(3, -5);

      expect(-value, equals(const Complex(-3, 5)));
      expect(-(-value), equals(value));
    });
  });
}

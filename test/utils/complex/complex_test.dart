import 'dart:math' as math;

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

void main() {
  group('Constructors', () {
    test('Default constructor', () {
      const complex = Complex(-2, 6);

      expect(complex.real, -2);
      expect(complex.imaginary, 6);
    });

    test(
      'fromReal()',
      () {
        expect(const Complex.fromReal(7).real, equals(7));
        expect(const Complex.fromReal(7).imaginary, isZero);

        expect(const Complex.fromImaginary(7).real, isZero);
        expect(const Complex.fromImaginary(7).imaginary, equals(7));
      },
    );

    test('fromImaginary()', () {
      const zero = Complex.zero();
      expect(zero.real, isZero);
      expect(zero.imaginary, isZero);

      const i = Complex.i();
      expect(i.real, isZero);
      expect(i.imaginary, equals(1));
    });

    test(
      'fromFraction()',
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

    test('fromPolar()', () {
      // From polar
      final fromPolar = Complex.fromPolar(
        r: 2,
        theta: 60,
        angleInRadians: false,
      );
      expect(
        fromPolar.real.round(),
        equals(1),
      );
      expect(
        fromPolar.imaginary,
        equals(math.sqrt(3)),
      );

      final fromPolar2 = Complex.fromPolar(r: 0, theta: 0);
      expect(fromPolar2.real, isZero);
      expect(fromPolar2.imaginary, isZero);

      final oneOverSqrtTwo = 1 / math.sqrt(2);
      final fromPolar3 = Complex.fromPolar(r: 1, theta: math.pi / 4);
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

    test('toString()', () {
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

  group('Object comparison', () {
    test('Object comparison', () {
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
      'compareTo()',
      () {
        expect(const Complex(2, 1).compareTo(const Complex(3, 7)), equals(-1));
        expect(const Complex(3, 7).compareTo(const Complex(2, 1)), equals(1));
        expect(const Complex(3, 5).compareTo(const Complex(3, 5)), equals(0));
      },
    );

    test('Ordering operators', () {
      const five = Complex.fromReal(5);
      const ten = Complex.fromReal(10);

      expect(five > ten, isFalse);
      expect(five >= ten, isFalse);
      expect(five < ten, isTrue);
      expect(five <= ten, isTrue);
    });

    test('copyWith()', () {
      const complex = Complex(8, -11);

      // Objects equality
      expect(complex, equals(complex.copyWith()));
      expect(complex, equals(complex.copyWith(real: 8, imaginary: -11)));

      // Objects inequality
      expect(complex == complex.copyWith(real: 1), isFalse);
    });
  });

  group('API', () {
    test(
      'conjugate()',
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

    test('reciprocal()', () {
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
      'abs()',
      () {
        expect(
          const Complex(3, 7).abs(),
          MoreOrLessEquals(math.sqrt(58)),
        );
      },
    );

    test('exp()', () {
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
      'sin(), cos(), tan() and cot()',
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

        final cot = i.cos() / i.sin();
        expect(i.cot().real, MoreOrLessEquals(cot.real));
        expect(i.cot().imaginary, MoreOrLessEquals(cot.imaginary));

        final tan = i.sin() / i.cos();
        expect(i.tan().real, MoreOrLessEquals(tan.real));
        expect(i.tan().imaginary, MoreOrLessEquals(tan.imaginary));

        // tan(1 + 2i) and cot(1 + 2i)
        const z = Complex(1, 2);
        expect(z.tan().real, const MoreOrLessEquals(0.033812826079897));
        expect(z.tan().imaginary, const MoreOrLessEquals(1.014793616146634));
        expect(z.cot().real, const MoreOrLessEquals(0.032797755533753));
        expect(z.cot().imaginary, const MoreOrLessEquals(-0.984329226458191));
      },
    );

    test(
      'sin() and cos() with large imaginary values (x.abs() > 20)',
      () {
        const largeImag = Complex(0, 25);
        final sinLarge = largeImag.sin();
        final cosLarge = largeImag.cos();

        expect(sinLarge.real.isFinite, isTrue);
        expect(sinLarge.imaginary.isFinite, isTrue);
        expect(cosLarge.real.isFinite, isTrue);
        expect(cosLarge.imaginary.isFinite, isTrue);

        const largeNegImag = Complex(0, -25);
        final sinLargeNeg = largeNegImag.sin();
        final cosLargeNeg = largeNegImag.cos();

        expect(sinLargeNeg.real.isFinite, isTrue);
        expect(sinLargeNeg.imaginary.isFinite, isTrue);
        expect(cosLargeNeg.real.isFinite, isTrue);
        expect(cosLargeNeg.imaginary.isFinite, isTrue);
      },
    );

    test('nthRoot()', () {
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
      'nthRoot() when the phase is negative',
      () {
        const negativePhase = Complex(-0.5, -1);
        final negativePhaseRoot = negativePhase.nthRoot(2);

        expect(negativePhase.phase(), isNegative);
        expect(
          negativePhase.phase(),
          const MoreOrLessEquals(-2.03444, precision: 1.0e-5),
        );

        // The principal root has argument phase() / 2, in (-pi/2, pi/2].
        expect(
          negativePhaseRoot.real,
          const MoreOrLessEquals(0.555892970251),
        );
        expect(
          negativePhaseRoot.imaginary,
          const MoreOrLessEquals(-0.899453719973),
        );
        expect(negativePhaseRoot, equals(negativePhase.sqrt()));
      },
    );

    test('pow()', () {
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

  group('Edge cases', () {
    const nan = double.nan;
    const inf = double.infinity;

    test('toString() of zero and of large whole numbers', () {
      expect('${const Complex.zero()}', equals('0'));
      expect('${const Complex(-0, -0)}', equals('0'));
      expect(const Complex.zero().toStringWithParenthesis(), equals('0'));
      expect(const Complex.zero().toStringAsFixed(2), equals('0.00'));
      expect(const Complex.zero().toStringAsFraction(), equals('0'));

      expect('${const Complex(1e20, 0)}', equals('100000000000000000000'));
      expect('${const Complex(1e21, -2)}', equals('1e+21 - 2i'));
      expect('${const Complex(nan, inf)}', equals('NaN + Infinityi'));
    });

    test('toStringAsFixed() omits the parts that are zero once rounded', () {
      expect(const Complex(5, 0.04).toStringAsFixed(1), equals('5.0'));
      expect(const Complex(0.04, -5).toStringAsFixed(1), equals('-5.0i'));
      expect(const Complex(-0.04, 5).toStringAsFixed(1), equals('5.0i'));
      expect(const Complex(-0.04, 0.04).toStringAsFixed(1), equals('0.0'));
    });

    test('toStringAsFraction() throws with non-finite values', () {
      expect(
        () => const Complex(nan, 1).toStringAsFraction(),
        throwsA(isA<FractionException>()),
      );
    });

    test('abs() does not overflow or underflow', () {
      expect(
        const Complex(3e200, 4e200).abs() / 5e200,
        const MoreOrLessEquals(1),
      );
      expect(
        const Complex(3e-200, -4e-200).abs() / 5e-200,
        const MoreOrLessEquals(1),
      );
      expect(const Complex(5e-324, 0).abs(), equals(5e-324));
      expect(const Complex(inf, nan).abs(), equals(inf));
      expect(const Complex(nan, 1).abs(), isNaN);
    });

    test('Division and reciprocal() with extreme magnitudes', () {
      final ratio = const Complex(1e200, 1e200) / const Complex(1e200, 1e200);
      expect(ratio.real, const MoreOrLessEquals(1));
      expect(ratio.imaginary, const MoreOrLessEquals(0));

      final small = const Complex(1e-200, 1e-200).reciprocal();
      expect(small.real / 5e199, const MoreOrLessEquals(1));
      expect(small.imaginary / -5e199, const MoreOrLessEquals(1));

      // Like double division, dividing by zero gives NaN instead of throwing.
      final byZero = const Complex(1, 2) / const Complex.zero();
      expect(byZero.real, isNaN);
      expect(byZero.imaginary, isNaN);
    });

    test('exp(), sin() and cos() do not produce NaN on overflow', () {
      expect(const Complex(1000, 0).exp(), equals(const Complex(inf, 0)));

      final sin = const Complex(0, 1000).sin();
      expect(sin.real, isZero);
      expect(sin.imaginary, equals(inf));

      final sinNegative = const Complex(0, -1000).sin();
      expect(sinNegative.real, isZero);
      expect(sinNegative.imaginary, equals(-inf));

      final cos = const Complex(0, 1000).cos();
      expect(cos.real, equals(inf));
      expect(cos.imaginary, isZero);

      // cosh(710) is finite, even if exp(710) overflows.
      expect(const Complex(0, 710).cos().real.isFinite, isTrue);
    });

    test('sin() and cos() are accurate with small imaginary parts', () {
      // sin(1e-10 i) = i sinh(1e-10), and sinh(x) = x + x^3/6 + ...
      expect(
        const Complex(0, 1e-10).sin().imaginary / 1e-10,
        const MoreOrLessEquals(1, precision: 1e-15),
      );
      expect(
        const Complex(0, 0.5).sin().imaginary,
        const MoreOrLessEquals(0.521095305493747, precision: 1e-15),
      );
    });

    test('tan() and cot() with large imaginary parts', () {
      final tan = const Complex(1, 400).tan();
      expect(tan.real, const MoreOrLessEquals(0));
      expect(tan.imaginary, equals(1));

      final tanNegative = const Complex(1, -400).tan();
      expect(tanNegative.real, const MoreOrLessEquals(0));
      expect(tanNegative.imaginary, equals(-1));

      final cot = const Complex(1, 400).cot();
      expect(cot.real, const MoreOrLessEquals(0));
      expect(cot.imaginary, equals(-1));

      // Zero is a pole of the cotangent.
      expect(const Complex.zero().cot().real, isNaN);
    });

    test('sqrt() returns the principal root', () {
      expect(const Complex(4, 0).sqrt(), equals(const Complex(2, 0)));
      expect(const Complex(-4, 0).sqrt(), equals(const Complex(0, 2)));
      // In a double context, the literal -0 is the negative zero -0.0.
      expect(const Complex(-4, -0).sqrt(), equals(const Complex(0, -2)));
      expect(const Complex.zero().sqrt(), equals(const Complex.zero()));

      final root = const Complex(0, -1).sqrt();
      expect(root.real, MoreOrLessEquals(1 / math.sqrt(2)));
      expect(root.imaginary, MoreOrLessEquals(-1 / math.sqrt(2)));

      final large = const Complex(-1e308, 1e308).sqrt();
      expect(large.real.isFinite && large.imaginary.isFinite, isTrue);
      expect(large.real, greaterThan(0));
    });

    test('nthRoot() returns the principal root', () {
      expect(
        const Complex(0, -1).nthRoot(2),
        equals(const Complex(0, -1).sqrt()),
      );

      // The principal cube root of -8 is 2 * e^(i pi/3) = 1 + sqrt(3)i.
      final cubeRoot = const Complex(-8, 0).nthRoot(3);
      expect(cubeRoot.real, const MoreOrLessEquals(1));
      expect(cubeRoot.imaginary, MoreOrLessEquals(math.sqrt(3)));

      // A negative argument gives a root with a negative argument.
      final negativeArgument = const Complex(0, -8).nthRoot(3);
      expect(negativeArgument.real, MoreOrLessEquals(math.sqrt(3)));
      expect(negativeArgument.imaginary, const MoreOrLessEquals(-1));

      expect(const Complex.zero().nthRoot(3), equals(const Complex.zero()));
      expect(
        () => const Complex(5, 3).nthRoot(0),
        throwsA(isA<ComplexException>()),
      );
      expect(
        () => const Complex.zero().nthRoot(-2),
        throwsA(isA<ComplexException>()),
      );
    });

    test('pow() with integer exponents is exact', () {
      expect(const Complex.i().pow(2), equals(const Complex(-1, 0)));
      expect(const Complex(-2, 0).pow(2).real, equals(4));
      expect(const Complex(-2, 0).pow(2).imaginary, isZero);
      expect(const Complex(2, 7).pow(4), equals(const Complex(1241, -2520)));
      expect(const Complex(2, 1).pow(1), equals(const Complex(2, 1)));
      expect(const Complex(2, 1).pow(2.0), equals(const Complex(3, 4)));

      // 1 / (2 + i)^2 = 1 / (3 + 4i) = (3 - 4i) / 25
      final inverse = const Complex(2, 1).pow(-2);
      expect(inverse.real, const MoreOrLessEquals(0.12));
      expect(inverse.imaginary, const MoreOrLessEquals(-0.16));

      // Inverting the base first avoids the overflow of (1e-200)^2.
      final tiny = const Complex(1e-200, 0).pow(-1);
      expect(tiny.real / 1e200, const MoreOrLessEquals(1));
    });

    test('pow() with zero base or zero exponent', () {
      expect(const Complex.zero().pow(0), equals(const Complex(1, 0)));
      expect(const Complex(3, 4).pow(0), equals(const Complex(1, 0)));
      expect(const Complex.zero().pow(2), equals(const Complex.zero()));
      expect(const Complex.zero().pow(0.5), equals(const Complex.zero()));
      expect(
        () => const Complex.zero().pow(-1),
        throwsA(isA<ComplexException>()),
      );
      expect(const Complex(1, 1).pow(nan).real, isNaN);
    });

    test('pow() with fractional exponents uses the principal branch', () {
      final root = const Complex(0, -1).pow(0.5);
      final sqrt = const Complex(0, -1).sqrt();
      expect(root.real, MoreOrLessEquals(sqrt.real));
      expect(root.imaginary, MoreOrLessEquals(sqrt.imaginary));
    });

    test('log()', () {
      final log = const Complex(3, 4).log();
      expect(log.real, const MoreOrLessEquals(1.6094379124341003));
      expect(log.imaginary, const MoreOrLessEquals(0.9272952180016122));

      expect(const Complex(math.e, 0).log().real, const MoreOrLessEquals(1));
      expect(const Complex(-1, 0).log(), equals(const Complex(0, math.pi)));
      expect(const Complex(-1, -0).log(), equals(const Complex(0, -math.pi)));
      expect(const Complex.i().log(), equals(const Complex(0, math.pi / 2)));

      // exp(log(z)) = z
      final back = const Complex(-2, 7).log().exp();
      expect(back.real, const MoreOrLessEquals(-2));
      expect(back.imaginary, const MoreOrLessEquals(7));

      expect(
        () => const Complex.zero().log(),
        throwsA(isA<ComplexException>()),
      );
    });

    test('log() with moduli close to 1 or out of range', () {
      // log|1 + 1e-10i| = log(1 + 1e-20) / 2 = 5e-21
      expect(
        const Complex(1, 1e-10).log().real / 5e-21,
        const MoreOrLessEquals(1),
      );

      final large = const Complex(1e300, 1e300).log();
      expect(large.real, const MoreOrLessEquals(691.1221014884936));
      expect(large.imaginary, const MoreOrLessEquals(math.pi / 4));

      // The modulus is above the largest double, but its logarithm isn't.
      final huge = const Complex(1.7e308, 1.7e308).log();
      expect(huge.real, const MoreOrLessEquals(710.0734104835082));

      final tiny = const Complex(3e-320, 0).log();
      expect(tiny.real, MoreOrLessEquals(math.log(3e-320), precision: 1e-9));

      expect(
        const Complex(double.infinity, 1).log().real,
        equals(double.infinity),
      );
    });

    test('sinh(), cosh() and tanh()', () {
      const z = Complex(1, 2);

      expect(z.sinh().real, const MoreOrLessEquals(-0.4890562590412937));
      expect(z.sinh().imaginary, const MoreOrLessEquals(1.4031192506220405));
      expect(z.cosh().real, const MoreOrLessEquals(-0.64214812471552));
      expect(z.cosh().imaginary, const MoreOrLessEquals(1.0686074213827783));
      expect(z.tanh().real, const MoreOrLessEquals(1.16673625724092));
      expect(z.tanh().imaginary, const MoreOrLessEquals(-0.24345820118572534));

      // sinh(iy) = i sin(y) and cosh(iy) = cos(y)
      expect(const Complex(0, 1).sinh().real, isZero);
      expect(
        const Complex(0, 1).sinh().imaginary,
        MoreOrLessEquals(math.sin(1)),
      );
      expect(const Complex(0, 1).cosh().real, MoreOrLessEquals(math.cos(1)));

      // cosh(z)^2 - sinh(z)^2 = 1
      const w = Complex(0.3, -0.7);
      final identity = w.cosh().pow(2) - w.sinh().pow(2);
      expect(identity.real, const MoreOrLessEquals(1));
      expect(identity.imaginary, const MoreOrLessEquals(0));
    });

    test('sinh(), cosh() and tanh() with extreme values', () {
      expect(const Complex(1000, 0).sinh(), equals(const Complex(inf, 0)));
      expect(const Complex(-1000, 0).sinh(), equals(const Complex(-inf, 0)));

      final cosh = const Complex(1000, 0).cosh();
      expect(cosh.real, equals(inf));
      expect(cosh.imaginary, isZero);

      // sinh(x) = x + x^3/6 + ...
      expect(
        const Complex(1e-10, 0).sinh().real / 1e-10,
        const MoreOrLessEquals(1, precision: 1e-15),
      );

      final tanh = const Complex(400, 1).tanh();
      expect(tanh.real, equals(1));
      expect(tanh.imaginary, const MoreOrLessEquals(0));

      final tanhNegative = const Complex(-400, 1).tanh();
      expect(tanhNegative.real, equals(-1));
      expect(tanhNegative.imaginary, const MoreOrLessEquals(0));
    });

    test('powComplex()', () {
      // i^i = e^(-pi/2)
      final iToI = const Complex.i().powComplex(const Complex.i());
      expect(iToI.real, MoreOrLessEquals(math.exp(-math.pi / 2)));
      expect(iToI.imaginary, const MoreOrLessEquals(0));

      final general = const Complex(2, 3).powComplex(const Complex(4, 5));
      expect(general.real, const MoreOrLessEquals(-0.7530458367485594));
      expect(general.imaginary, const MoreOrLessEquals(-0.9864287886477446));

      // The principal branch: log(-8) = log(8) + i pi
      final negativeBase = const Complex(-8, 0).powComplex(
        const Complex(1 / 3, 0.5),
      );
      expect(negativeBase.real, const MoreOrLessEquals(-0.20518171649981812));
      expect(
        negativeBase.imaginary,
        const MoreOrLessEquals(0.3616021795693124),
      );

      // Real exponents are the same as pow(), so integer ones are exact.
      expect(
        const Complex(1, 1).powComplex(const Complex(2, 0)),
        equals(const Complex(0, 2)),
      );
      expect(
        const Complex(3, 4).powComplex(const Complex.zero()),
        equals(const Complex(1, 0)),
      );
    });

    test('powComplex() with zero base', () {
      expect(
        const Complex.zero().powComplex(const Complex(1, 1)),
        equals(const Complex.zero()),
      );
      expect(
        const Complex.zero().powComplex(const Complex.zero()),
        equals(const Complex(1, 0)),
      );
      expect(
        () => const Complex.zero().powComplex(const Complex.i()),
        throwsA(isA<ComplexException>()),
      );
      expect(
        () => const Complex.zero().powComplex(const Complex(-1, 2)),
        throwsA(isA<ComplexException>()),
      );
    });

    test('compareTo() and NaN', () {
      expect(
        const Complex(nan, 0).compareTo(const Complex(1, 0)),
        equals(1),
      );
      expect(
        const Complex(1, 0).compareTo(const Complex(0, 1)),
        isZero,
      );
    });
  });

  group('Operators', () {
    test('opearator +', () {
      final value = const Complex(3, -5) + const Complex(-8, 13);
      expect(value.real, equals(-5));
      expect(value.imaginary, equals(8));

      final value2 =
          const Complex.fromReal(5) + const Complex.fromImaginary(-16);
      expect(value2.real, equals(5));
      expect(value2.imaginary, equals(-16));
    });

    test(
      'operator -',
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
      'operator *',
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

    test(
      'operator /',
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

        final v3 = const Complex(-1, -3) / const Complex(4, 1);
        expect(v3.real, equals(-7 / 17));
        expect(v3.imaginary, equals(-11 / 17));
      },
    );

    test('operator -()', () {
      const value = Complex(3, -5);
      expect(-value, equals(const Complex(-3, 5)));

      final negative = -value;
      expect(-negative, equals(value));
    });
  });
}

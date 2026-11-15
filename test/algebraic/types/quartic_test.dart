import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

/// Checks that [actual] and [expected] contain the same roots, in any order.
///
/// The order in which the roots are returned is not part of the API, so each
/// expected root is matched with a distinct actual root.
void expectSameRoots(
  List<Complex> actual,
  List<Complex> expected, {
  double precision = 1.0e-5,
}) {
  expect(actual.length, equals(expected.length));

  final remaining = [...actual];
  for (final root in expected) {
    final index = remaining.indexWhere(
      (x) =>
          (x.real - root.real).abs() <= precision &&
          (x.imaginary - root.imaginary).abs() <= precision,
    );
    expect(
      index,
      isNot(-1),
      reason: 'Expected root $root not found in $actual',
    );
    remaining.removeAt(index);
  }
}

void main() {
  group('Quartic', () {
    test('Object construction', () {
      final equation = Quartic.realEquation(a: 3, b: 6, d: 2, e: -1);

      // Checking properties
      expect(equation.degree, equals(4));
      expect(
        equation.derivative(),
        Cubic(
          a: const Complex.fromReal(12),
          b: const Complex.fromReal(18),
          d: const Complex.fromReal(2),
        ),
      );
      expect(equation.isRealEquation, isTrue);
      expect(equation.discriminant(), equals(const Complex.fromReal(-70848)));
      expect(
        equation.coefficients,
        equals(const [
          Complex.fromReal(3),
          Complex.fromReal(6),
          Complex.zero(),
          Complex.fromReal(2),
          Complex.fromReal(-1),
        ]),
      );

      // Making sure that coefficients can be accessed via index
      expect(equation[0], equals(const Complex.fromReal(3)));
      expect(equation[1], equals(const Complex.fromReal(6)));
      expect(equation[2], equals(const Complex.zero()));
      expect(equation[3], equals(const Complex.fromReal(2)));
      expect(equation[4], equals(const Complex.fromReal(-1)));

      expect(() => equation[-1], throwsA(isA<RangeError>()));

      expect(equation.coefficient(4), equals(const Complex.fromReal(3)));
      expect(equation.coefficient(3), equals(const Complex.fromReal(6)));
      expect(equation.coefficient(2), equals(const Complex.zero()));
      expect(equation.coefficient(1), equals(const Complex.fromReal(2)));
      expect(equation.coefficient(0), equals(const Complex.fromReal(-1)));
      expect(equation.coefficient(5), isNull);

      // Converting to string
      expect(equation.toString(), equals('f(x) = 3x^4 + 6x^3 + 2x + -1'));
      expect(
        equation.toStringWithFractions(),
        equals('f(x) = 3x^4 + 6x^3 + 2x + -1'),
      );

      // Checking solutions
      expectSameRoots(
        equation.solutions(),
        const [
          Complex.fromReal(-2.173571613806),
          Complex.fromReal(0.349518864775),
          Complex(-0.087973625484, 0.656527118533),
          Complex(-0.087973625484, -0.656527118533),
        ],
        precision: 1.0e-12,
      );

      // Evaluation
      final eval = equation.realEvaluateOn(2);
      expect(eval.real.round(), equals(99));
      expect(eval.imaginary.round(), isZero);
    });

    test('Exception is thrown if the coeff. of the highest degree is zero', () {
      expect(
        () => Quartic(a: const Complex.zero()),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('realEquation', () {
      final quartic = Quartic.realEquation(a: -3, d: 8);

      expect(quartic.a, equals(const Complex.fromReal(-3)));
      expect(quartic.d, equals(const Complex.fromReal(8)));

      // There must be an exception is the first coeff. is zero
      expect(
        () => Quartic.realEquation(a: 0),
        throwsA(isA<AlgebraicException>()),
      );
    });

    test('Objects comparison works properly', () {
      final fx = Quartic(
        a: const Complex(3, -6),
        b: const Complex.fromImaginary(-2),
        c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
        d: const Complex.i(),
        e: const Complex.fromReal(9),
      );

      final otherFx = Quartic(
        a: const Complex(3, -6),
        b: const Complex.fromImaginary(-2),
        c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
        d: const Complex.i(),
        e: const Complex.fromReal(9),
      );

      expect(fx, equals(otherFx));
      expect(fx == otherFx, isTrue);
      expect(otherFx, equals(fx));
      expect(otherFx == fx, isTrue);

      expect(
        fx,
        equals(
          Quartic(
            a: const Complex(3, -6),
            b: const Complex.fromImaginary(-2),
            c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
            d: const Complex.i(),
            e: const Complex.fromReal(9),
          ),
        ),
      );
      expect(
        Quartic(
          a: const Complex(3, -6),
          b: const Complex.fromImaginary(-2),
          c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
          d: const Complex.i(),
          e: const Complex.fromReal(9),
        ),
        equals(fx),
      );
      expect(
        fx ==
            Quartic(
              a: const Complex(3, -6),
              b: const Complex.fromImaginary(-2),
              c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
              d: const Complex.i(),
              e: const Complex.fromReal(9),
            ),
        isTrue,
      );
      expect(
        Quartic(
              a: const Complex(3, -6),
              b: const Complex.fromImaginary(-2),
              c: Complex.fromFraction(Fraction(1, 2), Fraction(1, 5)),
              d: const Complex.i(),
              e: const Complex.fromReal(9),
            ) ==
            fx,
        isTrue,
      );

      expect(fx.hashCode, equals(otherFx.hashCode));
    });

    test('copyWith', () {
      final quartic = Quartic.realEquation(c: 5, d: -6);

      // Objects equality
      expect(quartic, equals(quartic.copyWith()));
      expect(
        quartic,
        equals(
          quartic.copyWith(
            a: const Complex.fromReal(1),
            b: const Complex.zero(),
            c: const Complex.fromReal(5),
            d: const Complex.fromReal(-6),
            // Not adding `const` to run the test with a different object
            // ignore: prefer_const_constructors
            e: Complex.zero(),
          ),
        ),
      );

      // Objects inequality
      expect(quartic == quartic.copyWith(c: const Complex.zero()), isFalse);
    });

    group('Solutions tests', () {
      void verifyQuarticSolutions(
        Quartic equation,
        List<Complex> expectedSolutions,
      ) {
        expectSameRoots(equation.solutions(), expectedSolutions);
      }

      test('Test 1', () {
        verifyQuarticSolutions(
          Quartic.realEquation(a: 2, b: 1, c: -2, d: 1, e: 7),
          const [
            Complex(-1.22152, -0.69349),
            Complex(-1.22152, 0.69349),
            Complex(0.97152, -0.91106),
            Complex(0.97152, 0.91106),
          ],
        );
      });

      test('Test 2', () {
        verifyQuarticSolutions(
          Quartic(
            a: const Complex.fromReal(5),
            b: const Complex(-5, 12),
            d: const Complex.fromReal(1),
          ),
          const [
            Complex(-0.23979, -0.1419),
            Complex.zero(),
            Complex(0.21956, 0.16265),
            Complex(1.02023, -2.42074),
          ],
        );
      });

      test('Test 3', () {
        verifyQuarticSolutions(Quartic.realEquation(a: 5, b: 6, d: -1), const [
          Complex.fromReal(-1),
          Complex.fromReal(-0.55826),
          Complex.zero(),
          Complex.fromReal(0.35826),
        ]);
      });

      test('Test 4', () {
        verifyQuarticSolutions(
          Quartic(
            a: const Complex(4, -7),
            b: const Complex(2, 3),
            d: const Complex.fromReal(2),
            e: const Complex(10, 1),
          ),
          const [
            Complex(-0.85119, 0.37549),
            Complex(-0.46831, -0.97907),
            Complex(0.51992, 0.88058),
            Complex(0.99958, -0.677),
          ],
        );
      });

      test('Test 5', () {
        verifyQuarticSolutions(
          Quartic(
            a: const Complex.i(),
            c: -const Complex.i(),
            e: const Complex.fromReal(-3),
          ),
          const [
            Complex(1.39765, -0.42028),
            Complex(-1.39765, 0.42028),
            Complex(0.56196, 1.04527),
            Complex(-0.56196, -1.04527),
          ],
        );
      });

      test('Test 6', () {
        verifyQuarticSolutions(
          Quartic.realEquation(b: -10, c: 35, d: -50, e: 24),
          const [
            Complex.fromReal(1),
            Complex.fromReal(2),
            Complex.fromReal(3),
            Complex.fromReal(4),
          ],
        );
      });

      test('Test 7', () {
        verifyQuarticSolutions(Quartic.realEquation(c: 2, e: 1), const [
          Complex(0, 1),
          Complex(0, -1),
          Complex(0, -1),
          Complex(0, 1),
        ]);
      });

      test('Test 8', () {
        verifyQuarticSolutions(Quartic.realEquation(c: -5, e: 4), const [
          Complex.fromReal(2),
          Complex.fromReal(-2),
          Complex.fromReal(1),
          Complex.fromReal(-1),
        ]);
      });

      test('Test 9', () {
        verifyQuarticSolutions(Quartic.realEquation(), const [
          Complex.zero(),
          Complex.zero(),
          Complex.zero(),
          Complex.zero(),
        ]);
      });

      test('Test 10', () {
        verifyQuarticSolutions(Quartic(), const [
          Complex.zero(),
          Complex.zero(),
          Complex.zero(),
          Complex.zero(),
        ]);
      });

      test('Test 11: Large coefficients are valid', () {
        // 1e11 * (x^4 - 16) = 0
        verifyQuarticSolutions(
          Quartic.realEquation(a: 100000000000, e: -1600000000000),
          const [
            Complex.fromReal(2),
            Complex.fromReal(-2),
            Complex(0, 2),
            Complex(0, -2),
          ],
        );
      });

      test('Test 12', () {
        verifyQuarticSolutions(Quartic(a: const Complex(-4, 15)), const [
          Complex.zero(),
          Complex.zero(),
          Complex.zero(),
          Complex.zero(),
        ]);
      });

      test('Test 13', () {
        verifyQuarticSolutions(Quartic.realEquation(a: 523), const [
          Complex.zero(),
          Complex.zero(),
          Complex.zero(),
          Complex.zero(),
        ]);
      });

      test('Test 14', () {
        verifyQuarticSolutions(
          Quartic(a: const Complex(2, 1), e: const Complex(9, 3).negate),
          const [
            Complex(1.43428, -0.05090),
            Complex(0.05090, 1.43428),
            Complex(-1.43428, 0.05090),
            Complex(-0.05090, -1.43428),
          ],
        );
      });

      test('Test 15', () {
        verifyQuarticSolutions(Quartic.realEquation(a: 8, e: 3), const [
          Complex(0.55334, 0.55334),
          Complex(-0.55334, 0.55334),
          Complex(-0.55334, -0.55334),
          Complex(0.55334, -0.55334),
        ]);
      });

      test('Test 16', () {
        verifyQuarticSolutions(Quartic.realEquation(a: 2, c: -5, e: 13), const [
          Complex(1.37831, -0.80607),
          Complex(-1.37831, 0.80607),
          Complex(1.37831, 0.80607),
          Complex(-1.37831, -0.80607),
        ]);
      });

      test('Test 17', () {
        verifyQuarticSolutions(Quartic.realEquation(c: 1, e: 1), const [
          Complex(0.5, 0.86602),
          Complex(-0.5, -0.86602),
          Complex(0.49999, -0.86602),
          Complex(-0.49999, 0.86602),
        ]);
      });

      test('Test 18', () {
        verifyQuarticSolutions(
          Quartic(
            a: const Complex(2, 1),
            c: const Complex(-5, 0),
            e: const Complex(4, -4),
          ),
          const [
            Complex(1.35597, 0.12969),
            Complex(-1.35597, -0.12969),
            Complex(0.87794, -0.76982),
            Complex(-0.87794, 0.76982),
          ],
        );
      });

      test('Test 19', () {
        verifyQuarticSolutions(Quartic.realEquation(b: -5, c: 6), const [
          Complex.zero(),
          Complex.zero(),
          Complex.fromReal(3),
          Complex.fromReal(2),
        ]);
      });

      test('Test 20', () {
        verifyQuarticSolutions(
          Quartic(
            a: const Complex(1, 1),
            b: const Complex(-5, 0),
            c: const Complex(6, 0),
          ),
          const [
            Complex.zero(),
            Complex.zero(),
            Complex(1.28607, -2.98242),
            Complex(1.21392, 0.48242),
          ],
        );
      });

      test(
        'Test 21: Special case ax^4 + cx^2 + e = 0 with root.abs() < epsilon',
        () {
          final quartic = Quartic.realEquation(
            c: -1e-12, // Very small negative c
          );

          final solutions = quartic.solutions();
          expect(solutions.length, equals(4));

          // Should have at least one zero solution
          final hasZero = solutions.any((s) => s.abs() < 1e-10);
          expect(hasZero, isTrue);
        },
      );

      test('Test 22: Double zero roots on ax^4 + cx^2 + e', () {
        final quartic = Quartic.realEquation(c: -1);
        final solutions = quartic.solutions();

        expect(solutions.length, equals(4));
        final zeroCount = solutions.where((s) => s.abs() < 1e-10).length;
        expect(zeroCount, equals(2));

        final nonZeroSolutions = solutions
            .where((s) => s.abs() >= 1e-10)
            .toList();
        expect(nonZeroSolutions.length, equals(2));
        expect(
          nonZeroSolutions.any(
            (s) => (s - const Complex.fromReal(1)).abs() < 1e-10,
          ),
          isTrue,
        );
        expect(
          nonZeroSolutions.any(
            (s) => (s - const Complex.fromReal(-1)).abs() < 1e-10,
          ),
          isTrue,
        );
      });

      test('Test 23: Small coefficients are not treated as zero', () {
        // x^4 - 1e-12 = 0 has roots +/-1e-3 and +/-1e-3i
        expectSameRoots(
          Quartic.realEquation(e: -1e-12).solutions(),
          const [
            Complex.fromReal(1e-3),
            Complex.fromReal(-1e-3),
            Complex(0, 1e-3),
            Complex(0, -1e-3),
          ],
          precision: 1e-15,
        );
      });

      test('Test 24: Small roots of a biquadratic are not dropped', () {
        // x^4 - x^2 + 1e-12 = 0 has roots about +/-1 and +/-1e-6
        expectSameRoots(
          Quartic.realEquation(c: -1, e: 1e-12).solutions(),
          const [
            Complex.fromReal(1),
            Complex.fromReal(-1),
            Complex.fromReal(1e-6),
            Complex.fromReal(-1e-6),
          ],
          precision: 1e-12,
        );
      });

      test('Test 25: Double root ((x - 1)^2(x - 2)(x - 3))', () {
        expectSameRoots(
          Quartic.realEquation(b: -7, c: 17, d: -17, e: 6).solutions(),
          const [
            Complex.fromReal(1),
            Complex.fromReal(1),
            Complex.fromReal(2),
            Complex.fromReal(3),
          ],
          precision: 1e-9,
        );
      });

      test('Test 26: Triple root ((x - 1)^3(x - 2))', () {
        expectSameRoots(
          Quartic.realEquation(b: -5, c: 9, d: -7, e: 2).solutions(),
          const [
            Complex.fromReal(1),
            Complex.fromReal(1),
            Complex.fromReal(1),
            Complex.fromReal(2),
          ],
          precision: 1e-9,
        );
      });

      test('Test 27: Quadruple root ((x - 1)^4)', () {
        expectSameRoots(
          Quartic.realEquation(b: -4, c: 6, d: -4, e: 1).solutions(),
          const [
            Complex.fromReal(1),
            Complex.fromReal(1),
            Complex.fromReal(1),
            Complex.fromReal(1),
          ],
          precision: 1e-9,
        );
      });

      test('Test 28: Double complex roots (((x - 1)^2 + 1)^2)', () {
        expectSameRoots(
          Quartic.realEquation(b: -4, c: 8, d: -8, e: 4).solutions(),
          const [
            Complex(1, 1),
            Complex(1, 1),
            Complex(1, -1),
            Complex(1, -1),
          ],
          precision: 1e-9,
        );
      });

      test('Test 29: Zero root with a small linear coefficient', () {
        // x^4 + 1e-11x = x(x^3 + 1e-11): the other roots are the cube roots
        // of -1e-11, whose magnitude is about 2.15e-4.
        final solutions = Quartic.realEquation(d: 1e-11).solutions();
        final cubeRoot = pow(1e-11, 1 / 3).toDouble();

        expectSameRoots(
          solutions,
          [
            const Complex.zero(),
            Complex.fromReal(-cubeRoot),
            Complex(cubeRoot / 2, cubeRoot * sqrt(3) / 2),
            Complex(cubeRoot / 2, -cubeRoot * sqrt(3) / 2),
          ],
          precision: 1e-15,
        );
      });
    });
  });
}

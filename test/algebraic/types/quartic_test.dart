import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

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
      final solutions = equation.solutions();
      expect(solutions.first.real, const MoreOrLessEquals(-2.173571613806));
      expect(solutions.first.imaginary.round(), isZero);
      expect(solutions[1].real, const MoreOrLessEquals(0.349518864775));
      expect(solutions[1].imaginary.round(), isZero);
      expect(solutions[2].real, const MoreOrLessEquals(-0.087973625484));
      expect(solutions[2].imaginary, const MoreOrLessEquals(0.656527118533));
      expect(solutions[3].real, const MoreOrLessEquals(-0.087973625484));
      expect(solutions[3].imaginary, const MoreOrLessEquals(-0.656527118533));

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
        final solutions = equation.solutions();
        expect(solutions.length, equals(4));

        for (var i = 0; i < 4; ++i) {
          expect(
            solutions[i].real,
            MoreOrLessEquals(expectedSolutions[i].real, precision: 1.0e-5),
          );
          expect(
            solutions[i].imaginary,
            MoreOrLessEquals(expectedSolutions[i].imaginary, precision: 1.0e-5),
          );
        }
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

      test('Test 11', () {
        expect(
          () => Quartic.realEquation(a: 100000000000),
          throwsA(isA<AlgebraicException>()),
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
    });
  });
}

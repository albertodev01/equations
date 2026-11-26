import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

List<AlgebraicInequalitySolution> solve(
  List<double> coefficients,
  AlgebraicInequalityType inequalityType,
) => AlgebraicInequalitySolver(
  polynomial: Algebraic.fromReal(coefficients),
  inequalityType: inequalityType,
).solve();

Matcher isSmallerThan(
  double value, {
  required bool isInclusive,
  double precision = 1.0e-12,
}) => isA<AlgebraicInequalitySmallerThan>()
    .having(
      (s) => s.value,
      'value',
      MoreOrLessEquals(value, precision: precision),
    )
    .having((s) => s.isInclusive, 'isInclusive', isInclusive);

Matcher isGreaterThan(
  double value, {
  required bool isInclusive,
  double precision = 1.0e-12,
}) => isA<AlgebraicInequalityGreaterThan>()
    .having(
      (s) => s.value,
      'value',
      MoreOrLessEquals(value, precision: precision),
    )
    .having((s) => s.isInclusive, 'isInclusive', isInclusive);

Matcher isInterval(
  double start,
  double end, {
  required bool isInclusive,
  double precision = 1.0e-12,
}) => isA<AlgebraicInequalityInterval>()
    .having(
      (s) => s.start,
      'start',
      MoreOrLessEquals(start, precision: precision),
    )
    .having((s) => s.end, 'end', MoreOrLessEquals(end, precision: precision))
    .having((s) => s.isInclusive, 'isInclusive', isInclusive);

void main() {
  const lessThan = AlgebraicInequalityType.lessThan;
  const lessThanOrEqualTo = AlgebraicInequalityType.lessThanOrEqualTo;
  const greaterThan = AlgebraicInequalityType.greaterThan;
  const greaterThanOrEqualTo = AlgebraicInequalityType.greaterThanOrEqualTo;

  group('AlgebraicInequalitySolver', () {
    test('Smoke test', () {
      final solver = AlgebraicInequalitySolver(
        polynomial: Algebraic.fromReal([1, -1]),
        inequalityType: greaterThan,
      );

      expect(solver.polynomial, equals(Algebraic.fromReal([1, -1])));
      expect(solver.inequalityType, equals(greaterThan));
      expect(solver.precision, equals(1.0e-10));
      expect(solver.solve(), [isGreaterThan(1, isInclusive: false)]);
    });

    test('Objects comparison', () {
      final solver = AlgebraicInequalitySolver(
        polynomial: Algebraic.fromReal([1, -1]),
        inequalityType: greaterThan,
      );

      expect(
        solver,
        equals(
          AlgebraicInequalitySolver(
            polynomial: Algebraic.fromReal([1, -1]),
            inequalityType: greaterThan,
          ),
        ),
      );
      expect(
        solver.hashCode,
        equals(
          AlgebraicInequalitySolver(
            polynomial: Algebraic.fromReal([1, -1]),
            inequalityType: greaterThan,
          ).hashCode,
        ),
      );
      expect(
        solver,
        isNot(
          AlgebraicInequalitySolver(
            polynomial: Algebraic.fromReal([1, -1]),
            inequalityType: lessThan,
          ),
        ),
      );
      expect(
        solver,
        isNot(
          AlgebraicInequalitySolver(
            polynomial: Algebraic.fromReal([1, -1]),
            inequalityType: greaterThan,
            precision: 1.0e-8,
          ),
        ),
      );
    });

    test('toString()', () {
      final solver = AlgebraicInequalitySolver(
        polynomial: Algebraic.fromReal([1, -1]),
        inequalityType: greaterThan,
      );

      expect(
        solver.toString(),
        equals(
          'AlgebraicInequalitySolver(polynomial: f(x) = 1x + -1, '
          'inequalityType: AlgebraicInequalityType.greaterThan, '
          'precision: 1e-10)',
        ),
      );
    });

    group('Validation', () {
      test('The precision must be positive', () {
        expect(
          () => AlgebraicInequalitySolver(
            polynomial: Algebraic.fromReal([1, -1]),
            inequalityType: lessThan,
            precision: 0,
          ).solve(),
          throwsA(isA<AlgebraicException>()),
        );
      });

      test('The coefficients must be real', () {
        expect(
          () => AlgebraicInequalitySolver(
            polynomial: Algebraic.from(const [
              Complex.fromReal(1),
              Complex.i(),
            ]),
            inequalityType: lessThan,
          ).solve(),
          throwsA(isA<AlgebraicException>()),
        );
      });
    });

    group('Touching intervals are joined', () {
      test('(x - 1)^2 * (x - 3) <= 0 is x <= 3', () {
        expect(
          solve([1, -5, 7, -3], lessThanOrEqualTo),
          [isSmallerThan(3, isInclusive: true)],
        );
      });

      test('(x - 1)^3 >= 0 is x >= 1', () {
        expect(
          solve([1, -3, 3, -1], greaterThanOrEqualTo),
          [isGreaterThan(1, isInclusive: true)],
        );
      });

      test('(x - 1)^2 >= 0 holds for all real numbers', () {
        expect(
          solve([1, -2, 1], greaterThanOrEqualTo),
          [isA<AlgebraicInequalityAllRealNumbers>()],
        );
      });
    });

    group('Roots where P(x) touches zero', () {
      test('(x - 1)^2 <= 0 is only x = 1', () {
        expect(
          solve([1, -2, 1], lessThanOrEqualTo),
          [isInterval(1, 1, isInclusive: true)],
        );
      });

      test('(x - 1)^2 < 0 has no solutions', () {
        expect(solve([1, -2, 1], lessThan), isEmpty);
      });

      test('(x - 1)^2 > 0 excludes x = 1', () {
        expect(solve([1, -2, 1], greaterThan), [
          isSmallerThan(1, isInclusive: false),
          isGreaterThan(1, isInclusive: false),
        ]);
      });

      test('(x - 1)^2 * (x + 2) > 0 is -2 < x < 1 or x > 1', () {
        expect(solve([1, 0, -3, 2], greaterThan), [
          isInterval(-2, 1, isInclusive: false),
          isGreaterThan(1, isInclusive: false),
        ]);
      });

      test('(x^2 - 2)^2 <= 0 is only x = -sqrt(2) and x = sqrt(2)', () {
        expect(solve([1, 0, -4, 0, 4], lessThanOrEqualTo), [
          isInterval(
            -1.4142135623730951,
            -1.4142135623730951,
            isInclusive: true,
          ),
          isInterval(1.4142135623730951, 1.4142135623730951, isInclusive: true),
        ]);
      });
    });

    group('Repeated roots computed numerically', () {
      // The roots of (x - 2)^5 are computed with errors of about 1e-3, and
      // with imaginary parts of the same size.
      test('(x - 2)^5 > 0 is x > 2', () {
        final solutions = solve([1, -10, 40, -80, 80, -32], greaterThan);

        expect(solutions, hasLength(1));
        expect(
          solutions.single,
          isA<AlgebraicInequalityGreaterThan>()
              .having(
                (s) => s.value,
                'value',
                const MoreOrLessEquals(2, precision: 1.0e-2),
              )
              .having((s) => s.isInclusive, 'isInclusive', false),
        );
      });

      test('(x - 2)^5 <= 0 is x <= 2', () {
        final solutions = solve([1, -10, 40, -80, 80, -32], lessThanOrEqualTo);

        expect(solutions, hasLength(1));
        expect(
          solutions.single,
          isA<AlgebraicInequalitySmallerThan>()
              .having(
                (s) => s.value,
                'value',
                const MoreOrLessEquals(2, precision: 1.0e-2),
              )
              .having((s) => s.isInclusive, 'isInclusive', true),
        );
      });

      test('(x - 1)(x - 2)^2(x - 3)^2 <= 0 is x <= 1, x = 2 and x = 3', () {
        expect(solve([1, -11, 47, -97, 96, -36], lessThanOrEqualTo), [
          isSmallerThan(1, isInclusive: true),
          isInterval(2, 2, isInclusive: true, precision: 1.0e-6),
          isInterval(3, 3, isInclusive: true, precision: 1.0e-6),
        ]);
      });

      test('(x - 1)^4 * (x^2 + 1) > 0 excludes x = 1', () {
        final solutions = solve([1, -4, 7, -8, 7, -4, 1], greaterThan);

        expect(solutions, hasLength(2));
        expect(solutions.first, isA<AlgebraicInequalitySmallerThan>());
        expect(solutions.last, isA<AlgebraicInequalityGreaterThan>());
        expect(
          (solutions.first as AlgebraicInequalitySmallerThan).value,
          const MoreOrLessEquals(1, precision: 1.0e-3),
        );
        expect(
          (solutions.first as AlgebraicInequalitySmallerThan).value,
          equals((solutions.last as AlgebraicInequalityGreaterThan).value),
        );
      });
    });

    group('Complex roots', () {
      test('x^2 + 1 < 0 has no solutions', () {
        expect(solve([1, 0, 1], lessThan), isEmpty);
      });

      test('x^2 + 1 >= 0 holds for all real numbers', () {
        expect(
          solve([1, 0, 1], greaterThanOrEqualTo),
          [isA<AlgebraicInequalityAllRealNumbers>()],
        );
      });

      test('(x - 1)(x^2 + 1) > 0 is x > 1', () {
        // The complex roots have real part 0, which must not split x > 1.
        expect(solve([1, -1, 1, -1], greaterThan), [
          isA<AlgebraicInequalityGreaterThan>()
              .having(
                (s) => s.value,
                'value',
                const MoreOrLessEquals(1, precision: 1.0e-10),
              )
              .having((s) => s.isInclusive, 'isInclusive', false),
        ]);
      });

      test('x^6 - 1 < 0 is -1 < x < 1', () {
        expect(solve([1, 0, 0, 0, 0, 0, -1], lessThan), [
          isInterval(-1, 1, isInclusive: false, precision: 1.0e-10),
        ]);
      });
    });

    group('Close roots', () {
      test('Distinct roots 1e-3 apart are not merged', () {
        // (x - 1000)(x - 1000.001) < 0
        expect(solve([1, -2000.001, 1000001], lessThan), [
          isInterval(1000, 1000.001, isInclusive: false, precision: 1.0e-6),
        ]);
      });

      test('Small roots of a degree 5 polynomial', () {
        // (x - 1e-3)(x + 1e-3) * x^3 > 0
        expect(solve([1, 0, -1e-6, 0, 0, 0], greaterThan), [
          isInterval(-1e-3, 0, isInclusive: false, precision: 1.0e-10),
          isGreaterThan(1e-3, isInclusive: false),
        ]);
      });
    });

    group('Constant polynomials', () {
      test('A positive constant is > 0 everywhere', () {
        expect(
          solve([5], greaterThan),
          [isA<AlgebraicInequalityAllRealNumbers>()],
        );
        expect(solve([5], lessThanOrEqualTo), isEmpty);
      });

      test('The zero polynomial satisfies only non-strict inequalities', () {
        final zero = Constant(a: const Complex.zero());

        for (final type in [lessThanOrEqualTo, greaterThanOrEqualTo]) {
          expect(
            AlgebraicInequalitySolver(
              polynomial: zero,
              inequalityType: type,
            ).solve(),
            [isA<AlgebraicInequalityAllRealNumbers>()],
          );
        }
        for (final type in [lessThan, greaterThan]) {
          expect(
            AlgebraicInequalitySolver(
              polynomial: zero,
              inequalityType: type,
            ).solve(),
            isEmpty,
          );
        }
      });
    });

    group('Inequalities table', () {
      final cases = <(List<double>, AlgebraicInequalityType, List<Matcher>)>[
        // Linear
        ([1, -1], lessThan, [isSmallerThan(1, isInclusive: false)]),
        ([1, -1], greaterThanOrEqualTo, [isGreaterThan(1, isInclusive: true)]),
        ([-1, 1], greaterThan, [isSmallerThan(1, isInclusive: false)]),
        ([-1, 1], lessThanOrEqualTo, [isGreaterThan(1, isInclusive: true)]),
        ([1e-3, -1e-3], greaterThan, [isGreaterThan(1, isInclusive: false)]),
        ([1, -1e6], lessThan, [isSmallerThan(1000000, isInclusive: false)]),

        // Quadratic: x^2 - 4 and its opposite
        ([1, 0, -4], lessThan, [isInterval(-2, 2, isInclusive: false)]),
        (
          [1, 0, -4],
          greaterThanOrEqualTo,
          [
            isSmallerThan(-2, isInclusive: true),
            isGreaterThan(2, isInclusive: true),
          ],
        ),
        ([-1, 0, 4], greaterThan, [isInterval(-2, 2, isInclusive: false)]),
        (
          [-1, 0, 4],
          lessThanOrEqualTo,
          [
            isSmallerThan(-2, isInclusive: true),
            isGreaterThan(2, isInclusive: true),
          ],
        ),

        // Quadratic without real roots: x^2 + 1 and -(x^2 + 1)
        ([1, 0, 1], lessThanOrEqualTo, []),
        ([1, 0, 1], greaterThan, [isA<AlgebraicInequalityAllRealNumbers>()]),
        ([-1, 0, -1], lessThan, [isA<AlgebraicInequalityAllRealNumbers>()]),
        ([-1, 0, -1], greaterThanOrEqualTo, []),

        // Double root at zero: x^2
        ([1, 0, 0], lessThan, []),
        ([1, 0, 0], lessThanOrEqualTo, [isInterval(0, 0, isInclusive: true)]),
        (
          [1, 0, 0],
          greaterThan,
          [
            isSmallerThan(0, isInclusive: false),
            isGreaterThan(0, isInclusive: false),
          ],
        ),
        (
          [1, 0, 0],
          greaterThanOrEqualTo,
          [
            isA<AlgebraicInequalityAllRealNumbers>(),
          ],
        ),

        // Triple root at zero: x^3
        ([1, 0, 0, 0], greaterThan, [isGreaterThan(0, isInclusive: false)]),
        (
          [1, 0, 0, 0],
          lessThanOrEqualTo,
          [isSmallerThan(0, isInclusive: true)],
        ),

        // (x - 1)(x - 2)(x - 3)
        (
          [1, -6, 11, -6],
          lessThan,
          [
            isSmallerThan(1, isInclusive: false),
            isInterval(2, 3, isInclusive: false),
          ],
        ),
        (
          [1, -6, 11, -6],
          greaterThanOrEqualTo,
          [
            isInterval(1, 2, isInclusive: true),
            isGreaterThan(3, isInclusive: true),
          ],
        ),

        // x^3 - x^2 + x - 1 = (x - 1)(x^2 + 1), with two complex roots
        ([1, -1, 1, -1], lessThan, [isSmallerThan(1, isInclusive: false)]),

        // x^4 - 1
        (
          [1, 0, 0, 0, -1],
          lessThanOrEqualTo,
          [
            isInterval(-1, 1, isInclusive: true),
          ],
        ),
        (
          [1, 0, 0, 0, -1],
          greaterThan,
          [
            isSmallerThan(-1, isInclusive: false),
            isGreaterThan(1, isInclusive: false),
          ],
        ),

        // (x - 1)(x - 2)(x - 3)(x - 4)
        (
          [1, -10, 35, -50, 24],
          greaterThan,
          [
            isSmallerThan(1, isInclusive: false),
            isInterval(2, 3, isInclusive: false),
            isGreaterThan(4, isInclusive: false),
          ],
        ),
        (
          [1, -10, 35, -50, 24],
          lessThanOrEqualTo,
          [
            isInterval(1, 2, isInclusive: true),
            isInterval(3, 4, isInclusive: true),
          ],
        ),

        // (x^2 - 1)^2: two double roots
        (
          [1, 0, -2, 0, 1],
          lessThanOrEqualTo,
          [
            isInterval(-1, -1, isInclusive: true),
            isInterval(1, 1, isInclusive: true),
          ],
        ),
        (
          [1, 0, -2, 0, 1],
          greaterThan,
          [
            isSmallerThan(-1, isInclusive: false),
            isInterval(-1, 1, isInclusive: false),
            isGreaterThan(1, isInclusive: false),
          ],
        ),

        // (x - 1)(x - 2)(x - 3)(x - 4)(x - 5)
        (
          [1, -15, 85, -225, 274, -120],
          lessThan,
          [
            isSmallerThan(1, isInclusive: false, precision: 1e-9),
            isInterval(2, 3, isInclusive: false, precision: 1e-9),
            isInterval(4, 5, isInclusive: false, precision: 1e-9),
          ],
        ),
        (
          [1, -15, 85, -225, 274, -120],
          greaterThanOrEqualTo,
          [
            isInterval(1, 2, isInclusive: true, precision: 1e-9),
            isInterval(3, 4, isInclusive: true, precision: 1e-9),
            isGreaterThan(5, isInclusive: true, precision: 1e-9),
          ],
        ),

        // Constants
        ([-2], lessThan, [isA<AlgebraicInequalityAllRealNumbers>()]),
        ([-2], greaterThanOrEqualTo, []),
      ];

      const symbols = {
        lessThan: '<',
        lessThanOrEqualTo: '<=',
        greaterThan: '>',
        greaterThanOrEqualTo: '>=',
      };

      for (final (coefficients, type, expected) in cases) {
        final polynomial = Algebraic.fromReal(coefficients);

        test('$polynomial ${symbols[type]} 0', () {
          expect(solve(coefficients, type), expected);
        });
      }
    });

    test('Algebraic.solveInequality delegates to this class', () {
      final polynomial = Algebraic.fromReal([1, -5, 7, -3]);

      expect(
        polynomial.solveInequality(inequalityType: lessThanOrEqualTo),
        equals(
          AlgebraicInequalitySolver(
            polynomial: polynomial,
            inequalityType: lessThanOrEqualTo,
          ).solve(),
        ),
      );
    });
  });
}

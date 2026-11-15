import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

/// Solves the inequality of the polynomial with the given real [coefficients].
List<AlgebraicInequalitySolution> solve(
  List<double> coefficients,
  AlgebraicInequalityType inequalityType,
) => AlgebraicInequalitySolver(
  polynomial: Algebraic.fromReal(coefficients),
  inequalityType: inequalityType,
).solve();

/// Matches an [AlgebraicInequalitySmallerThan] solution.
Matcher isSmallerThan(double value, {required bool isInclusive}) =>
    isA<AlgebraicInequalitySmallerThan>()
        .having((s) => s.value, 'value', MoreOrLessEquals(value))
        .having((s) => s.isInclusive, 'isInclusive', isInclusive);

/// Matches an [AlgebraicInequalityGreaterThan] solution.
Matcher isGreaterThan(double value, {required bool isInclusive}) =>
    isA<AlgebraicInequalityGreaterThan>()
        .having((s) => s.value, 'value', MoreOrLessEquals(value))
        .having((s) => s.isInclusive, 'isInclusive', isInclusive);

/// Matches an [AlgebraicInequalityInterval] solution.
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

import 'dart:math';

import 'package:equations/equations.dart';
import 'package:test/test.dart';

import 'solver_checks.dart';

void main() {
  group('All solvers', () {
    for (final MapEntry(key: name, value: build) in allSolvers.entries) {
      group(name, () {
        test('Rejects non-square matrices', () {
          expect(
            () => build(
              matrixOf([
                [1, 2, 3],
                [4, 5, 6],
              ]),
              [1, 2],
            ),
            throwsSolverException('square'),
          );
          expect(
            () => build(
              matrixOf([
                [1, 2],
                [3, 4],
                [5, 6],
              ]),
              [1, 2, 3],
            ),
            throwsSolverException('square'),
          );
        });

        test('Rejects known values of the wrong length', () {
          final matrix = matrixOf([
            [4, 1],
            [1, 3],
          ]);

          expect(() => build(matrix, [1]), throwsSolverException('size'));
          expect(() => build(matrix, [1, 2, 3]), throwsSolverException('size'));
        });

        test('Rejects NaN and infinite values in the matrix', () {
          for (final value in [double.nan, double.infinity, -double.infinity]) {
            expect(
              () => build(
                matrixOf([
                  [4, value],
                  [value, 3],
                ]),
                [1, 2],
              ),
              throwsSolverException('finite'),
              reason: 'value: $value',
            );
          }
        });

        test('Rejects NaN and infinite known values', () {
          final matrix = matrixOf([
            [4, 1],
            [1, 3],
          ]);

          for (final value in [double.nan, double.infinity, -double.infinity]) {
            expect(
              () => build(matrix, [1, value]),
              throwsSolverException('finite'),
              reason: 'value: $value',
            );
          }
        });

        test('Rejects negative, NaN and infinite precisions', () {
          final matrix = matrixOf([
            [4, 1],
            [1, 3],
          ]);

          for (final precision in [-1e-10, double.nan, double.infinity]) {
            expect(
              () => build(matrix, [1, 2], precision: precision),
              throwsSolverException('precision'),
              reason: 'precision: $precision',
            );
          }
        });

        test('Solves 1x1 systems', () {
          final solution = build(
            matrixOf([
              [4],
            ]),
            [2],
          ).solve();

          expect(solution, hasLength(1));
          expect(solution.first, closeTo(0.5, 1e-9));
        });

        test('Solves random symmetric positive-definite systems', () {
          final random = Random(name.length);

          for (var n = 1; n <= 12; ++n) {
            final matrix = randomDominantSpdMatrix(n, random);
            final x = randomVector(n, random);
            final solver = build(matrix, multiply(matrix, x));

            final solution = solver.solve();
            expectVectorClose(solution, x);
            expectSmallResidual(solver, solution, tolerance: 1e-9);
          }
        });

        test('Returns zero when the known values are zero', () {
          final matrix = matrixOf([
            [4, 1, 0],
            [1, 5, 2],
            [0, 2, 6],
          ]);

          expect(build(matrix, [0, 0, 0]).solve(), everyElement(equals(0)));
        });

        test('Solves systems with huge and tiny elements', () {
          const x = <double>[1, -2, 3];

          for (final scale in [1e-150, 1e-20, 1e20, 1e150]) {
            final matrix = RealMatrix.fromFlattenedData(
              rows: 3,
              columns: 3,
              data: [
                4,
                1,
                0,
                1,
                5,
                2,
                0,
                2,
                6,
              ].map((value) => value * scale).toList(),
            );
            final solver = build(matrix, multiply(matrix, x));

            expectVectorClose(solver.solve(), x, tolerance: 1e-9);
          }
        });

        test("Doesn't modify its inputs and is repeatable", () {
          final data = [
            [4.0, 1.0, 0.0],
            [1.0, 5.0, 2.0],
            [0.0, 2.0, 6.0],
          ];
          final matrix = matrixOf(data);
          final knownValues = <double>[1, 2, 3];
          final solver = build(matrix, knownValues);

          final first = solver.solve();
          final copy = List<double>.of(first);

          // Changing a returned solution must not affect the next ones
          first[0] = 1000;
          final second = solver.solve();

          expect(second, orderedEquals(copy));
          expect(knownValues, orderedEquals(<double>[1, 2, 3]));
          expect(solver.knownValues, orderedEquals(<double>[1, 2, 3]));
          expect(solver.matrix, equals(matrixOf(data)));
        });

        test('Is equal only to solvers of the same type', () {
          final matrix = matrixOf([
            [4, 1],
            [1, 3],
          ]);
          final solver = build(matrix, [1, 2]);

          expect(solver, equals(solver));
          expect(solver, equals(build(matrix, [1, 2])));
          expect(solver.hashCode, equals(build(matrix, [1, 2]).hashCode));
          expect(solver, isNot(equals(build(matrix, [1, 3]))));
          expect(solver, isNot(equals(build(matrix, [1, 2], precision: 1e-6))));
          expect(
            solver,
            isNot(
              equals(
                build(
                  matrixOf([
                    [4, 1],
                    [1, 4],
                  ]),
                  [1, 2],
                ),
              ),
            ),
          );

          for (final MapEntry(key: otherName, value: other)
              in allSolvers.entries) {
            if (otherName != name) {
              expect(
                solver,
                isNot(equals(other(matrix, [1, 2]))),
                reason: 'compared with $otherName',
              );
            }
          }
        });
      });
    }

    test('All solvers agree on the same systems', () {
      final random = Random(42);

      for (var n = 2; n <= 8; ++n) {
        final matrix = randomDominantSpdMatrix(n, random);
        final knownValues = randomVector(n, random);
        final reference = GaussianElimination(
          matrix: matrix,
          knownValues: knownValues,
        ).solve();

        for (final build in allSolvers.values) {
          expectVectorClose(
            build(matrix, knownValues).solve(),
            reference,
            tolerance: 1e-9,
          );
        }
      }
    });
  });

  group('General direct solvers', () {
    for (final MapEntry(key: name, value: build)
        in generalDirectSolvers.entries) {
      group(name, () {
        test('Pivots when a diagonal element is zero', () {
          final solver = build(
            matrixOf([
              [0, 1],
              [1, 0],
            ]),
            [2, 3],
          );

          expect(solver.solve(), orderedEquals(<double>[3, 2]));
        });

        test('Handles a cyclic row permutation', () {
          // Partial pivoting moves the rows in a 3-cycle (not a swap), so a
          // permutation applied in the wrong direction gives wrong results.
          final solver = build(
            matrixOf([
              [0, 0, 4],
              [3, 1, 0],
              [0, 2, 1],
            ]),
            [4, 4, 3],
          );

          expectVectorClose(solver.solve(), [1, 1, 1], tolerance: 1e-14);
        });

        test('Solves triangular systems', () {
          final upper = build(
            matrixOf([
              [2, 1, -1],
              [0, 3, 2],
              [0, 0, 4],
            ]),
            [2, 5, 4],
          );
          final lower = build(
            matrixOf([
              [2, 0, 0],
              [1, 3, 0],
              [-1, 2, 4],
            ]),
            [2, 4, 5],
          );

          expectVectorClose(upper.solve(), [1, 1, 1], tolerance: 1e-14);
          expectVectorClose(lower.solve(), [1, 1, 1], tolerance: 1e-14);
        });

        test('Solves random non-symmetric systems', () {
          final random = Random(7);

          for (var n = 1; n <= 15; ++n) {
            final matrix = randomMatrix(n, random);
            final x = randomVector(n, random);
            final solver = build(matrix, multiply(matrix, x));

            final solution = solver.solve();
            expectSmallResidual(solver, solution);
            expectVectorClose(solution, x, tolerance: 1e-6);
          }
        });

        test('Is backward stable with ill-conditioned matrices', () {
          // The Hilbert matrix of order 6 has a condition number of ~1.5e7
          final matrix = hilbertMatrix(6);
          final x = List<double>.filled(6, 1);
          final solver = build(matrix, multiply(matrix, x));

          final solution = solver.solve();
          expectSmallResidual(solver, solution);
          expectVectorClose(solution, x, tolerance: 1e-6);
        });

        test('Throws when the matrix is singular', () {
          final exactlySingular = [
            matrixOf([
              [0, 0],
              [0, 0],
            ]),
            matrixOf([
              [1, 2],
              [2, 4],
            ]),
            // Only the last pivot is zero
            matrixOf([
              [1, 0, 0],
              [0, 1, 0],
              [1, 1, 0],
            ]),
          ];

          // Exact zero pivots are detected even with a zero precision
          for (final matrix in exactlySingular) {
            final knownValues = List<double>.filled(matrix.rowCount, 1);

            expect(
              build(matrix, knownValues).solve,
              throwsSolverException('singular'),
            );
            expect(
              build(matrix, knownValues, precision: 0).solve,
              throwsSolverException('singular'),
            );
          }

          // Because of rounding, the last pivot of this singular matrix is
          // tiny but not zero: only a positive precision detects it.
          final rounded = matrixOf([
            [1, 2, 3],
            [4, 5, 6],
            [7, 8, 9],
          ]);
          expect(
            build(rounded, [1, 1, 1]).solve,
            throwsSolverException('singular'),
          );
          expect(
            build(rounded, [1, 1, 1], precision: 0).solve,
            returnsNormally,
          );
        });

        test('Uses the precision to detect nearly singular matrices', () {
          final matrix = matrixOf([
            [1, 1],
            [1, 1 + 1e-12],
          ]);
          const knownValues = <double>[2, 2 + 1e-12];

          expect(
            build(matrix, knownValues).solve,
            throwsSolverException('singular'),
          );

          final solver = build(matrix, knownValues, precision: 1e-14);
          expectSmallResidual(solver, solver.solve());
        });

        test('Agrees with the other general direct solvers', () {
          final random = Random(11);

          for (var n = 2; n <= 10; ++n) {
            final matrix = randomMatrix(n, random);
            final knownValues = randomVector(n, random);
            final solution = build(matrix, knownValues).solve();

            for (final other in generalDirectSolvers.values) {
              expectVectorClose(
                other(matrix, knownValues).solve(),
                solution,
                tolerance: 1e-9,
              );
            }
          }
        });
      });
    }
  });

  group('SystemSolver', () {
    test('computeResidualNorm', () {
      final solver = GaussianElimination(
        matrix: matrixOf([
          [2, 1],
          [1, 3],
        ]),
        knownValues: [5, 7],
      );

      // Residual of [0, 0] is -b, whose norm is sqrt(25 + 49)
      expect(solver.computeResidualNorm([0, 0]), closeTo(sqrt(74), 1e-14));
      expect(solver.computeResidualNorm([1.6, 1.8]), closeTo(0, 1e-14));
      expect(solver.computeResidualNorm([double.nan, 0]), isNaN);
      expect(
        solver.computeResidualNorm([double.infinity, 0]),
        equals(double.infinity),
      );
      expect(() => solver.computeResidualNorm([1]), throwsSolverException());
      expect(
        () => solver.computeResidualNorm([1, 2, 3]),
        throwsSolverException(),
      );
    });

    test("computeResidualNorm doesn't overflow or underflow", () {
      for (final scale in [1e-200, 1e200]) {
        final solver = GaussianElimination(
          matrix: matrixOf([
            [scale, 0],
            [0, scale],
          ]),
          knownValues: [scale, scale],
        );

        // The residual of [0, 0] is [-scale, -scale]
        expect(
          solver.computeResidualNorm([0, 0]),
          closeTo(sqrt(2) * scale, 1e-14 * scale),
        );
        expect(solver.computeResidualNorm([1, 1]), equals(0));
      }
    });

    test('isDiagonallyDominant', () {
      expect(
        SystemSolver.isDiagonallyDominant(
          matrixOf([
            [0],
          ]),
        ),
        isTrue,
      );

      // Weak dominance (equality) is enough
      expect(
        SystemSolver.isDiagonallyDominant(
          matrixOf([
            [1, 1],
            [1, 1],
          ]),
        ),
        isTrue,
      );

      // Absolute values are compared
      expect(
        SystemSolver.isDiagonallyDominant(
          matrixOf([
            [-3, 1, -2],
            [1, -3, 2],
            [0, -1, 1],
          ]),
        ),
        isTrue,
      );

      // Only the last row isn't dominant
      expect(
        SystemSolver.isDiagonallyDominant(
          matrixOf([
            [3, 1, 1],
            [1, 3, 1],
            [1, 1, 1],
          ]),
        ),
        isFalse,
      );
    });

    test('hasSolution and determinant', () {
      final regular = GaussianElimination(
        matrix: matrixOf([
          [2, 1],
          [1, 3],
        ]),
        knownValues: [5, 7],
      );
      final singular = GaussianElimination(
        matrix: matrixOf([
          [1, 2],
          [2, 4],
        ]),
        knownValues: [5, 7],
      );

      expect(regular.hasSolution(), isTrue);
      expect(regular.determinant(), closeTo(5, 1e-14));
      expect(singular.hasSolution(), isFalse);
      expect(singular.determinant(), equals(0));
    });

    test('String conversion of 1x1 systems', () {
      final solver = GaussianElimination(
        matrix: matrixOf([
          [-4],
        ]),
        knownValues: [2],
      );

      expect(solver.toString(), equals('[-4.0]'));
      expect(solver.toStringAugmented(), equals('[-4.0 | 2.0]'));
      expect(solver.size, equals(1));
    });
  });
}

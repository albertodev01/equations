import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';
import 'solver_checks.dart';

void main() {
  group('JacobiSolver', () {
    test('Smoke test', () {
      final jacobi = JacobiSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [2, 1],
            [5, 7],
          ],
        ),
        knownValues: [11, 13],
        x0: [1, 1],
      );

      final matrix = RealMatrix.fromData(
        rows: 2,
        columns: 2,
        data: const [
          [2, 1],
          [5, 7],
        ],
      );

      expect(jacobi.matrix, equals(matrix));
      expect(jacobi.knownValues, orderedEquals(<double>[11, 13]));
      expect(jacobi.x0, orderedEquals(<double>[1, 1]));
      expect(jacobi.maxSteps, equals(1000));
      expect(jacobi.precision, equals(1.0e-10));
      expect(jacobi.size, equals(2));
      expect(jacobi.hasSolution(), isTrue);

      expect(jacobi.determinant(), equals(9));

      final solutions = jacobi.solve();
      expect(solutions.first, const MoreOrLessEquals(7.11, precision: 1.0e-2));
      expect(solutions[1], const MoreOrLessEquals(-3.22, precision: 1.0e-2));
    });

    test('String conversion test', () {
      final solver = JacobiSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [2, 1],
            [5, 7],
          ],
        ),
        knownValues: [11, 13],
        x0: [1, 1],
      );

      const toString =
          '[2.0, 1.0]\n'
          '[5.0, 7.0]';
      const toStringAugmented =
          '[2.0, 1.0 | 11.0]\n'
          '[5.0, 7.0 | 13.0]';

      expect(solver.toString(), equals(toString));
      expect(solver.toStringAugmented(), equals(toStringAugmented));
    });

    test('Matrix validation test', () {
      expect(
        () => JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [1, 2],
              [4, 5],
            ],
          ),
          knownValues: [7, 8, 9],
          x0: [1, 2],
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Initial vector validation test', () {
      expect(
        () => JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [1, 2],
              [4, 5],
            ],
          ),
          knownValues: [7, 8],
          x0: [],
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    test('Equality test', () {
      final jacobi = JacobiSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
        x0: [1, 2],
      );

      final jacobi2 = JacobiSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2],
            [3, 4],
          ],
        ),
        knownValues: [0, -6],
        x0: [1, 2],
      );

      expect(jacobi, equals(jacobi2));
      expect(jacobi == jacobi2, isTrue);
      expect(jacobi2, equals(jacobi));
      expect(jacobi2 == jacobi, isTrue);
      expect(jacobi2.hashCode, jacobi.hashCode);
    });

    test('Diagonal dominance check', () {
      final diagonallyDominant = JacobiSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [4, 1], // |4| > |1|
            [1, 5], // |5| > |1|
          ],
        ),
        knownValues: [7, 8],
        x0: [1, 2],
      );

      final notDiagonallyDominant = JacobiSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [1, 2], // |1| < |2|
            [3, 4],
          ],
        ),
        knownValues: [7, 8],
        x0: [1, 2],
      );

      expect(diagonallyDominant.isDiagonallyDominant(), isTrue);
      expect(notDiagonallyDominant.isDiagonallyDominant(), isFalse);
    });

    test('Residual norm computation', () {
      final jacobi = JacobiSolver(
        matrix: RealMatrix.fromData(
          rows: 2,
          columns: 2,
          data: const [
            [4, 1],
            [1, 3],
          ],
        ),
        knownValues: [5, 4],
        x0: [1, 1],
      );

      final solution = jacobi.solve();
      final residualNorm = jacobi.computeResidualNorm(solution);

      expect(residualNorm, lessThan(1e-8));
    });

    test('Throws exception for zero diagonal elements', () {
      expect(
        () => JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [0, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 4],
          x0: [1, 1],
        ),
        throwsA(isA<SystemSolverException>()),
      );
    });

    group('Solver tests', () {
      void verifySolutions(
        JacobiSolver solver,
        List<double> expectedSolutions,
      ) {
        final solutions = solver.solve();
        for (var i = 0; i < solutions.length; ++i) {
          expect(
            solutions[i],
            MoreOrLessEquals(expectedSolutions[i], precision: 1.0e-1),
          );
        }
      }

      test('Test 1', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [25, 15, -5],
              [15, 18, 0],
              [-5, 0, 11],
            ],
          ),
          knownValues: [35, 33, 6],
          x0: [3, 1, -1],
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 2', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [1, 0, 1],
              [0, 2, 0],
              [1, 0, 3],
            ],
          ),
          knownValues: [6, 5, -2],
          x0: [0, 0, 0],
        );

        verifySolutions(solver, <double>[10, 2.5, -4]);
      });

      test('Test 3', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [1, 0, 0],
              [0, 1, 0],
              [0, 0, 1],
            ],
          ),
          knownValues: [5, -2, 3],
          x0: [3, 3, 3],
        );

        verifySolutions(solver, <double>[5, -2, 3]);
      });

      test('Test 4', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 4],
          x0: [1, 1],
        );

        verifySolutions(solver, <double>[1, 1]);
      });

      test('Test 5', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [5, 1, 0],
              [1, 5, 1],
              [0, 1, 5],
            ],
          ),
          knownValues: [6, 7, 6],
          x0: [0, 0, 0],
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 6', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [3, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 7],
          x0: [0, 0],
        );

        verifySolutions(solver, <double>[1, 2]);
      });

      test('Test 7', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 3,
            columns: 3,
            data: const [
              [6, 1, 0],
              [1, 6, 1],
              [0, 1, 6],
            ],
          ),
          knownValues: [7, 8, 7],
          x0: [0, 0, 0],
        );

        verifySolutions(solver, <double>[1, 1, 1]);
      });

      test('Test 8', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 4,
            columns: 4,
            data: const [
              [4, 1, 0, 0],
              [1, 4, 1, 0],
              [0, 1, 4, 1],
              [0, 0, 1, 4],
            ],
          ),
          knownValues: [5, 6, 6, 5],
          x0: [0, 0, 0, 0],
        );

        verifySolutions(solver, <double>[1, 1, 1, 1]);
      });
    });

    group('Edge cases', () {
      test('Throws a SystemSolverException for non-square matrices', () {
        expect(
          () => JacobiSolver(
            matrix: RealMatrix.fromData(
              rows: 3,
              columns: 2,
              data: const [
                [1, 2],
                [3, 4],
                [5, 6],
              ],
            ),
            knownValues: [1, 2, 3],
            x0: [0, 0, 0],
          ),
          throwsA(isA<SystemSolverException>()),
        );
      });

      test('The initial guess defaults to the zero vector', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 4],
        );

        expect(solver.x0, orderedEquals(<double>[0, 0]));
        expect(solver.computeResidualNorm(solver.solve()), lessThan(1e-8));
      });

      test('Throws when maxSteps is smaller than 1', () {
        expect(
          () => JacobiSolver(
            matrix: RealMatrix.fromData(
              rows: 1,
              columns: 1,
              data: const [
                [1],
              ],
            ),
            knownValues: [1],
            maxSteps: 0,
          ),
          throwsA(isA<SystemSolverException>()),
        );
      });

      test('Throws when the method diverges', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [1, 5],
              [7, 1],
            ],
          ),
          knownValues: [1, 1],
        );

        expect(solver.solve, throwsA(isA<SystemSolverException>()));
      });

      test("Throws when the method doesn't converge within maxSteps", () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 4],
          maxSteps: 3,
        );

        expect(
          solver.solve,
          throwsA(
            isA<SystemSolverException>().having(
              (e) => e.message,
              'message',
              contains('did not converge within 3 steps'),
            ),
          ),
        );
      });

      test('Converges when the solution has large components', () {
        final solver = JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 1],
              [1, 3],
            ],
          ),
          knownValues: [5e7, 4e7],
        );

        final solution = solver.solve();
        expect(
          solution.first,
          const MoreOrLessEquals(10000000, precision: 1e-2),
        );
        expect(solution[1], const MoreOrLessEquals(10000000, precision: 1e-2));
      });

      test('Equality depends on the initial guess', () {
        JacobiSolver build(List<double> x0) => JacobiSolver(
          matrix: RealMatrix.fromData(
            rows: 2,
            columns: 2,
            data: const [
              [4, 1],
              [1, 3],
            ],
          ),
          knownValues: [5, 4],
          x0: x0,
        );

        expect(build([0, 0]), equals(build([0, 0])));
        expect(build([0, 0]), isNot(equals(build([1, 0]))));
      });
    });

    group('Convergence', () {
      test('Converges where Gauss-Seidel diverges', () {
        // The Jacobi iteration matrix of this system is nilpotent (its
        // spectral radius is 0), while the Gauss-Seidel one has spectral
        // radius 2.
        final matrix = matrixOf([
          [1, 2, -2],
          [1, 1, 1],
          [2, 2, 1],
        ]);

        final solution = JacobiSolver(
          matrix: matrix,
          knownValues: [1, 3, 5],
        ).solve();

        expectVectorClose(solution, [1, 1, 1], tolerance: 1e-14);
        expect(
          GaussSeidelSolver(matrix: matrix, knownValues: [1, 3, 5]).solve,
          throwsSolverException('Gauss-Seidel'),
        );
      });

      test("Doesn't converge for some positive-definite matrices", () {
        // Symmetric positive-definite, but the Jacobi iteration matrix has
        // spectral radius 1.8
        final solver = JacobiSolver(
          matrix: matrixOf([
            [1, 0.9, 0.9],
            [0.9, 1, 0.9],
            [0.9, 0.9, 1],
          ]),
          knownValues: [2.8, 2.8, 2.8],
        );

        expect(solver.solve, throwsSolverException('Jacobi'));
      });

      test('Counts the steps correctly', () {
        // With the identity matrix, the first step finds the solution and
        // the second one confirms it (no change).
        JacobiSolver identity(int maxSteps, {List<double>? x0}) => JacobiSolver(
          matrix: matrixOf([
            [1, 0],
            [0, 1],
          ]),
          knownValues: [3, -4],
          x0: x0,
          maxSteps: maxSteps,
        );

        expect(identity(1).solve, throwsSolverException('within 1 steps'));
        expect(identity(2).solve(), orderedEquals(<double>[3, -4]));
        expect(
          identity(1, x0: [3, -4]).solve(),
          orderedEquals(<double>[3, -4]),
        );
      });

      test('Converges for weakly dominant irreducible matrices', () {
        final matrix = poissonMatrix(5);
        final x = <double>[1, 2, 3, 4, 5];
        final solver = JacobiSolver(
          matrix: matrix,
          knownValues: multiply(matrix, x),
        );

        expectVectorClose(solver.solve(), x);
      });

      test("The result doesn't share memory with x0", () {
        final x0 = <double>[0, 0];
        final solver = JacobiSolver(
          matrix: matrixOf([
            [4, 1],
            [1, 3],
          ]),
          knownValues: [5, 4],
          x0: x0,
        );

        solver.solve()[0] = 100;
        expect(x0, orderedEquals(<double>[0, 0]));
        expect(solver.x0, orderedEquals(<double>[0, 0]));
      });
    });

    group('Validation', () {
      final matrix = matrixOf([
        [4, 1],
        [1, 3],
      ]);

      test('Rejects NaN and infinite initial guesses', () {
        for (final value in [double.nan, double.infinity]) {
          expect(
            () => JacobiSolver(
              matrix: matrix,
              knownValues: [1, 2],
              x0: [value, 0],
            ),
            throwsSolverException('finite'),
          );
        }
      });

      test('Rejects initial guesses of the wrong length', () {
        expect(
          () => JacobiSolver(matrix: matrix, knownValues: [1, 2], x0: [0]),
          throwsSolverException('x0'),
        );
        expect(
          () =>
              JacobiSolver(matrix: matrix, knownValues: [1, 2], x0: [0, 0, 0]),
          throwsSolverException('x0'),
        );
      });

      test('Rejects non-positive maxSteps', () {
        for (final maxSteps in [0, -1]) {
          expect(
            () => JacobiSolver(
              matrix: matrix,
              knownValues: [1, 2],
              maxSteps: maxSteps,
            ),
            throwsSolverException('maxSteps'),
          );
        }
      });

      test('Rejects zeros on the diagonal of larger matrices', () {
        expect(
          () => JacobiSolver(
            matrix: matrixOf([
              [4, 1, 0],
              [1, 3, 1],
              [0, 1, 0],
            ]),
            knownValues: [1, 2, 3],
          ),
          throwsSolverException('diagonal'),
        );
      });
    });
  });
}

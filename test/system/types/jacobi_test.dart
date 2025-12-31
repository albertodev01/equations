import 'package:equations/equations.dart';
import 'package:test/test.dart';

import '../../double_approximation_matcher.dart';

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
      expect(jacobi.maxSteps, equals(30));
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
  });
}
